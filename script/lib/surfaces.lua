--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.lib.api")
require("script.lib.pair-data")
require("script.lib.struct")
require("script.lib.util")
require("script.proto")

surfaces = {}

-- declaring local functions, these are defined in the bottom-most section
local get_relative_surface, create_relative_surface, get_mapname, is_valid, is_valid_type, get_map_gen_settings, create_surface, get_type

function surfaces.is_from_this_mod(surface)
	return surface and string.find(api.name(surface), const.prefix .. "_") ~= nil or nil
end

function surfaces.get_layer(surface)
	local surface_name = api.name(surface)
	if surface_name == "nauvis" then
		return 0
	elseif surfaces.is_from_this_mod(surface_name) then
		local surface_string = const.prefix .."_" .. const.surface.type[(table.reverse(const.surface.type, true, "id")[get_type(surface)])].name .. "_"
		return tonumber(string.sub(surface_name, string.find(surface_name, surface_string) + string.len(surface_string)))
	end
end

function surfaces.is_below_nauvis(surface)
	return get_type(surface) == const.surface.type.underground.id
end

function surfaces.is_above_nauvis(surface)
	return get_type(surface) == const.surface.type.sky.id
end

function surfaces.get_surface_below(surface)
	return get_relative_surface(surface, const.surface.rel_loc.below)
end

function surfaces.get_surface_above(surface)
	return get_relative_surface(surface, const.surface.rel_loc.above)
end

function surfaces.create_surface_below(surface)
	return create_relative_surface(surface, const.surface.rel_loc.below)
end

function surfaces.create_surface_above(surface)
	return create_relative_surface(surface, const.surface.rel_loc.above)
end

function surfaces.chunk_generator_corrections(surface, area)
	local newTiles, entitiesToCorrect = {}, {}
	local tile_name, entity_name
	local is_below_nauvis = surfaces.is_below_nauvis(surface)
	if is_below_nauvis == true then
		tile_name = proto.get_field({"tile", "underground_dirt"}, "name")
		entity_name = proto.get_field({"entity", "underground_wall"}, "name")
		if global.mod_surfaces[api.name(surface)] == nil then
			surface.daytime = 0.5
			surface.freeze_daytime(true)
			global.mod_surfaces[api.name(surface)] = true
		end
	else
		tile_name = proto.get_field({"tile", "sky_void"}, "name")
	end
	local validArea = struct.BoundingBox(area.left_top.x, area.left_top.y, area.right_bottom.x-1, area.right_bottom.y-1)
	
	-- destroy entities which should not spawn on this surface and gather information for fixing entity location
	for k, v in pairs(api.surface.find_entities(surface, validArea)) do
		local pair_data = pairdata.get(v) or pairdata.reverse(v)
		local entity_type = api.type(v)
		if is_below_nauvis == true then
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius}) -- Underground surfaces don't need tiles passed through (only works for sky surfaces)
			elseif entity_type == "unit-spawner" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 9})
			elseif entity_type == "turret" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 8})
			elseif entity_type ~= "resource" and api.name(v) ~= entity_name and entity_type ~= "player" then
				api.destroy(v)
			end
		else
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius, tile = pair_data.tile}) -- Pass through tile from pairdata for clear floor function
			elseif entity_type ~= "player" then
				api.destroy(v)
			end
		end
	end
	
	--fix floor for sky surfaces
	if is_below_nauvis == false then
		for k, v in pairs(entitiesToCorrect) do
			pairutil.clear_ground(v.position, surface, v.radius, v.tile)
		end
	end
	
	-- insert appropriate tiles into array, create walls and set tiles
	for k, v in pairs(struct.TilePositions(validArea)) do
		if is_below_nauvis == true then
			api.surface.create_entity(surface, {name = entity_name, position = v, force = api.game.force("player")})
			table.insert(newTiles, {name = tile_name, position = v})
		elseif skytiles.get(api.name(api.surface.get_tile(surface, v))) == nil then
			table.insert(newTiles, {name = tile_name, position = v})
		end
	end
	api.surface.set_tiles(surface, newTiles)
	
	--fix floor for underground surfaces
	if is_below_nauvis == true then
		for k, v in pairs(entitiesToCorrect) do
			pairutil.clear_ground(v.position, surface, v.radius) -- tile does not need to be passed through, tiles are only created in sky surfaces
		end
	end
end

function surfaces.transport_player_to_access_shaft(player, destination_access_shaft)
	local new_position = api.surface.find_non_colliding_position(destination_access_shaft.surface, player.character.prototype.name, destination_access_shaft.position, 2, 1)
	if new_position ~= nil then
		api.entity.teleport(player, new_position, destination_access_shaft.surface)
	end
end

function surfaces.transport_player(player, surface, position)
	local new_position = api.surface.find_non_colliding_position(surface, player.character.prototype.name, position, 0, 1)
	if new_position ~= nil then
		api.entity.teleport(player, new_position, surface)
	end
end

function surfaces.find_nearby_access_shaft(entity, radius, surface)
	if radius and api.valid({entity, surface}) and struct.is_Position(entity.position) then
		local entities = api.surface.find_entities(surface, struct.BoundingBox(entity.position.x - radius, entity.position.y - radius, entity.position.x + radius, entity.position.y + radius), nil, proto.get_field({"entity", "access_shaft"}, "type"))
		if entities ~= nil then
			for k, v in pairs(entities) do
				local pair_data = pairdata.get(v)
				if pair_data ~= nil and pair_data.class == pairclass.get("access-shaft") then
					return v
				end
			end
		end
	end
end

function surfaces.find_nearby_entity(anchor, radius, surface, entity_name, entity_type)
	if radius and api.valid({surface, anchor}) and struct.is_Position(anchor.position) then
		local entities = api.surface.find_entities(surface, struct.BoundingBox(anchor.position.x - radius, anchor.position.y - radius, anchor.position.x + radius, anchor.position.y + radius), entity_name, entity_type)
		if entities ~= nil then
			for k, v in pairs(entities) do
				return v
			end
		end
	end
end

--[[
The below functions are all specific to the surfaces module, they therefore should not be called by other modules.
]]

get_mapname = function(surface_type, surface_layer)
	return is_valid(surface_type, surface_layer) and (const.prefix .. "_" .. const.surface.type[(table.reverse(const.surface.type, true, "id")[surface_type])].name .. "_" .. surface_layer) or "nauvis"
end

is_valid_type = function(surface_type)
	return (surface_type == const.surface.type.underground.id or surface_type == const.surface.type.sky.id) == true
end

is_valid = function(surface_type, surface_layer)
	return ((surface_layer >= 1) and is_valid_type(surface_type)) == true
end

get_map_gen_settings = function(surface_type)
	if surface_type == const.surface.type.underground.id then
		local nauvis_settings = api.surface.map_gen_settings(api.game.surface("nauvis"))
		return struct.MapGenSettings_copy(nauvis_settings, false, true, "none")
	elseif surface_type == const.surface.type.sky.id then
		local nauvis_settings = api.surface.map_gen_settings(api.game.surface("nauvis"))
		return struct.MapGenSettings_copy(nauvis_settings, true, true, "none")
	end
end

create_surface = function(surface_type, surface_layer)
	if is_valid(surface_type, surface_layer) then
		local surface_name = get_mapname(surface_type, surface_layer)
		return api.game.surface(surface_name) or api.game.create_surface(surface_name, get_map_gen_settings(surface_type))
	end
	return false	-- failed to create surface, inputs were invalid
end

get_relative_surface = function(surface, relative_location)
	if surface and (surfaces.is_from_this_mod(surface) or api.name(surface) == "nauvis") then
		local surface_name = api.name(surface)	-- gather and store the name of the surface
		if type(surface) == "string" then
			surface = api.game.surface(surface_name) -- if provided input was a string and not the surface, attempt to get the surface from game surfaces table
		end
		if api.valid(surface) then		-- if the surface exists and is valid
			if relative_location == const.surface.rel_loc.below then
				if surfaces.is_above_nauvis(surface_name) then
					return surfaces.get_layer(surface_name) > 1 and api.game.surface(get_mapname(const.surface.type.sky.id, surfaces.get_layer(surface_name) - 1)) or api.game.surface("nauvis")
				else
					return api.game.surface(get_mapname(const.surface.type.underground.id, surfaces.get_layer(surface_name) + 1))			
				end
			elseif relative_location == const.surface.rel_loc.above then
				if surfaces.is_below_nauvis(surface_name) then
					return surfaces.get_layer(surface_name) > 1 and api.game.surface(get_mapname(const.surface.type.underground.id, surfaces.get_layer(surface_name) - 1)) or api.game.surface("nauvis")
				else
					return api.game.surface(get_mapname(const.surface.type.sky.id, surfaces.get_layer(surface_name) + 1))			
				end
			end
		end
	end
end

create_relative_surface = function(surface, relative_location)
	if surface and (surfaces.is_from_this_mod(surface) or api.name(surface) == "nauvis") then
		local surface_name = api.name(surface)
		if relative_location == const.surface.rel_loc.below and (surfaces.is_below_nauvis(surface_name) or surface_name == "nauvis") then
			return create_surface(const.surface.type.underground.id, surfaces.get_layer(surface_name) + 1)
		elseif relative_location == const.surface.rel_loc.above and (surfaces.is_above_nauvis(surface_name) or surface_name == "nauvis") then
			return create_surface(const.surface.type.sky.id, surfaces.get_layer(surface_name) + 1)
		end
		return get_relative_surface(surface, relative_location)
	end
end

get_type = function(surface)
	local surface_name = api.name(surface)
	if surfaces.is_from_this_mod(surface_name) then
		if string.find(surface_name, "_" .. const.surface.type.underground.name .. "_") then
			return const.surface.type.underground.id
		elseif string.find(surface_name, "_" .. const.surface.type.sky.name .. "_") then
			return const.surface.type.sky.id
		end
	end
end	