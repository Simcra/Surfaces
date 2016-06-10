--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.api-util")
require("script.lib.util")
require("script.enum")
require("script.lib.pair-data")

surfaces={}

-- declaring local functions, these are defined in the bottom-most section
local get_relative_surface, create_relative_surface, get_mapname, is_valid, is_valid_type, get_map_gen_settings, create_surface

function surfaces.is_from_this_mod(surface)
	return surface and string.find(util.get_name(surface), enum.prefix .. "_") ~= nil or nil
end

function surfaces.get_layer(surface)
	local surface_name = util.get_name(surface)
	if surfaces.is_from_this_mod(surface_name) then
		local surface_string = enum.prefix .."_" .. enum.surface.type[(table.reverse(enum.surface.type, true, "id")[surfaces.get_type(surface)])].name .. "_"
		return tonumber(string.sub(surface_name, string.find(surface_name, surface_string) + string.len(surface_string)))
	elseif surface_name == "nauvis" then
		return 0
	end
end

function surfaces.get_type(surface)
	local surface_name = util.get_name(surface)
	if surfaces.is_from_this_mod(surface_name) then
		if string.find(surface_name, "_" .. enum.surface.type.underground.name .. "_") then
			return enum.surface.type.underground.id
		elseif string.find(surface_name, "_" .. enum.surface.type.sky.name .. "_") then
			return enum.surface.type.sky.id
		end
	end
end	

function surfaces.is_below_nauvis(surface)
	return surfaces.get_type(surface) == enum.surface.type.underground.id
end

function surfaces.is_above_nauvis(surface)
	return surfaces.get_type(surface) == enum.surface.type.sky.id
end

function surfaces.get_surface_below(surface)
	return get_relative_surface(surface, enum.surface.rel_loc.below)
end

function surfaces.get_surface_above(surface)
	return get_relative_surface(surface, enum.surface.rel_loc.above)
end

function surfaces.create_surface_below(surface)
	return create_relative_surface(surface, enum.surface.rel_loc.below)
end

function surfaces.create_surface_above(surface)
	return create_relative_surface(surface, enum.surface.rel_loc.above)
end

function surfaces.chunk_generator_corrections(surface, area)
	local newTiles, entitiesToCorrect = {}, {}
	local tile_name, entity_name
	local is_below_nauvis = surfaces.is_below_nauvis(surface)
	if is_below_nauvis == true then
		tile_name = enum.prototype.tile.underground_floor.name
		entity_name = enum.prototype.entity.underground_wall.name
	else
		tile_name = enum.prototype.tile.sky_floor.name
	end
	local validArea = struct.BoundingBox(area.left_top.x, area.left_top.y, area.right_bottom.x-1, area.right_bottom.y-1)
	
	-- destroy entities which should not spawn on this surface and gather information for fixing entity location
	for k, v in pairs(util.find_entities(surface, validArea)) do
		local pair_data = pairdata.get(v)
		local entity_type = util.get_type(v)
		if is_below_nauvis == true then
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius})
			elseif entity_type == "unit-spawner" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 5})
			elseif entity_type == "turret" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 4})
			elseif entity_type ~= "resource" and util.get_name(v) ~= entity_name and entity_type ~= "player" then
				v.destroy()
			end
		else
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius})
			elseif entity_type ~= "player" then
				v.destroy()
			end
		end
	end
	
	--fix floor for sky surfaces
	if is_below_nauvis == false then
		for k, v in pairs(entitiesToCorrect) do
			surfaces.clear_floor_around_location(v.position, surface, v.radius)
		end
	end
	
	-- insert appropriate tiles into array, create walls and set tiles
	for k, v in pairs(struct.TilePositions(validArea)) do
		if is_below_nauvis == true then
			util.create_entity(surface, {name = entity_name, position = v, force = game.forces.player})
			table.insert(newTiles, {name = tile_name, position = v})
		else
			if util.get_name(util.get_tile(surface, v)) ~= enum.prototype.tile.sky_concrete.name then
				table.insert(newTiles, {name = tile_name, position = v})
			end
		end
	end
	util.set_tiles(surface, newTiles)
	
	--fix floor for underground surfaces
	if is_below_nauvis == true then
		for k, v in pairs(entitiesToCorrect) do
			surfaces.clear_floor_around_location(v.position, surface, v.radius)
		end
	end
end

function surfaces.clear_floor_around_entity(entity, radius)
	if util.is_valid(entity) then
		surfaces.clear_floor_around_location(entity.position, entity.surface, radius)
	end
end

function surfaces.clear_floor_around_location(position, surface, radius)
	if struct.is_Position(position) and util.is_valid(surface) then
		if surfaces.is_from_this_mod(surface) then
			radius = radius or 0
			local area = struct.BoundingBox(position.x - radius, position.y - radius, position.x + radius, position.y + radius)
			if surfaces.is_below_nauvis(surface) then
				for k, v in pairs(util.find_entities(surface, area, enum.prototype.entity.underground_wall.name, enum.prototype.entity.underground_wall.type)) do
					v.destroy()
				end
			else
				local newTiles = {}
				for k, v in pairs(struct.TilePositions(area)) do
					table.insert(newTiles, {name = enum.prototype.tile.sky_concrete.name, position = v})
				end
				util.set_tiles(surface, newTiles)
			end
		end
	end
end

function surfaces.transport_player_to_access_shaft(player_entity, destination_access_shaft)
	local new_position = util.find_non_colliding_position(destination_access_shaft.surface, player_entity.character.prototype.name, destination_access_shaft.position, 2, 1)
	if new_position ~= nil then
		util.teleport(player_entity, new_position, destination_access_shaft.surface)
	end
end

function surfaces.find_nearby_access_shaft(entity, radius, surface)
	if radius and util.is_valid(entity) and util.is_valid(surface) and struct.is_Position(entity.position) then
		for k, v in pairs(util.find_entities(surface, struct.BoundingBox(entity.position.x - radius, entity.position.y - radius, entity.position.x + radius, entity.position.y + radius), nil, enum.prototype.entity.access_shaft.type)) do
			local pair_data = pairdata.get(v)
			if pair_data ~= nil and pair_data.class == pairclass.get("sm-access-shaft") then
				return v
			end
		end
	end
end

function surfaces.find_nearby_entity(anchor, radius, surface, entity_name, entity_type)
	if util.is_valid(anchor) and radius and util.is_valid(surface) and struct.is_Position(anchor.position) then
		for k, v in pairs(util.find_entities(surface, struct.BoundingBox(anchor.position.x - radius, anchor.position.y - radius, anchor.position.x + radius, anchor.position.y + radius), entity_name, entity_type)) do
			return v
		end
	end
end

--[[
The below functions are all specific to the surfaces module, they therefore should not be called by other modules.
]]

get_mapname = function(surface_type, surface_layer)
	return is_valid(surface_type, surface_layer) and (enum.prefix .. "_" .. enum.surface.type[(table.reverse(enum.surface.type, true, "id")[surface_type])].name .. "_" .. surface_layer) or "nauvis"
end

is_valid_type = function(surface_type)
	return (surface_type == enum.surface.type.underground.id or surface_type == enum.surface.type.sky.id) == true
end

is_valid = function(surface_type, surface_layer)
	return ((surface_layer >= 1) and is_valid_type(surface_type)) == true
end

get_map_gen_settings = function(surface_type)
	if surface_type == enum.surface.type.underground.id then
		return struct.MapGenSettings_copy(util.get_map_gen_settings(util.get_surface("nauvis")), false, true, "none")
	elseif surface_type == enum.surface.type.sky.id then
		return struct.MapGenSettings_copy(util.get_map_gen_settings(util.get_surface("nauvis")), true, true, "none")
	end
end

create_surface = function(surface_type, surface_layer)
	if is_valid(surface_type, surface_layer) then
		local surface_name = get_mapname(surface_type, surface_layer)
		if util.get_surface(surface_name) == nil then
			util.create_surface(surface_name, get_map_gen_settings(surface_type))
		end
		return util.get_surface(surface_name)
	end
	return false	-- failed to create surface
end

get_relative_surface = function(surface, relative_location)
	if surface and (surfaces.is_from_this_mod(surface) or util.get_name(surface) == "nauvis") then
		local surface_name = util.get_name(surface)
		if type(surface) == "string" then
			surface = util.get_surface(surface_name)
		end
		if util.is_valid(surface) then
			if relative_location == enum.surface.rel_loc.below then
				if surfaces.is_above_nauvis(surface_name) then
					return surfaces.get_layer(surface_name) > 1 and util.get_surface(get_mapname(enum.surface.type.sky.id, surfaces.get_layer(surface_name) - 1)) or util.get_surface("nauvis")
				else
					return util.get_surface(get_mapname(enum.surface.type.underground.id, surfaces.get_layer(surface_name) + 1))			
				end
			elseif relative_location == enum.surface.rel_loc.above then
				if surfaces.is_below_nauvis(surface_name) then
					return surfaces.get_layer(surface_name) > 1 and util.get_surface(get_mapname(enum.surface.type.underground.id, surfaces.get_layer(surface_name) - 1)) or util.get_surface("nauvis")
				else
					return util.get_surface(get_mapname(enum.surface.type.sky.id, surfaces.get_layer(surface_name) + 1))			
				end
			end
		end
	end
end

create_relative_surface = function(surface, relative_location)
	if surface and (surfaces.is_from_this_mod(surface) or util.get_name(surface) == "nauvis") then
		local surface_name = util.get_name(surface)
		if relative_location == enum.surface.rel_loc.below then
			if surfaces.is_below_nauvis(surface_name) or surface_name == "nauvis" then
				return create_surface(enum.surface.type.underground.id, surfaces.get_layer(surface_name) + 1)
			end
		elseif relative_location == enum.surface.rel_loc.above then
			if surfaces.is_above_nauvis(surface_name) or surface_name == "nauvis" then
				return create_surface(enum.surface.type.sky.id, surfaces.get_layer(surface_name) + 1)
			end
		end
		return get_relative_surface(surface, relative_location)
	end
end