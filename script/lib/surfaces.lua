--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")
require("script.lib.util")
require("script.lib.pair-data")

surfaces={}
function surfaces.get_name(surface)
	if type(surface) == "string" then
		return surface
	else
		if surface and surface.valid then
			return surface.name
		else
			return tostring(surface)
		end
	end
end

function surfaces.get_mapname(surface_type, surface_layer)
	if surfaces.is_valid_input(surface_type, surface_layer) then
		return config.surface_prefix .. "_" .. surface_type .. "_" .. surface_layer
	end
	return "nauvis"
end
	
function surfaces.is_valid_type(surface_type)
	return (surface_type == config.surface_type_underground or surface_type == config.surface_type_sky)
end

function surfaces.is_valid_input(surface_type, surface_layer)
	return ((surface_layer >= 1) and surfaces.is_valid_type(surface_type))
end

function surfaces.is_from_this_mod(surface)
	return string.find(tostring(surfaces.get_name(surface)), config.surface_prefix .. "_") ~= nil
end

function surfaces.get_layer(surface)
	local surface_name = surfaces.get_name(surface)
	if surfaces.is_from_this_mod(surface_name) then
		local surface_string = surface_prefix .."_" .. surfaces.get_type(surface) .. "_"
		return tonumber(string.sub(surface_name, string.find(surface_name, surface_string) + string.len(surface_string)))
	elseif surface_name == "nauvis" then
		return 0
	end
end

function surfaces.get_type(surface)
	local surface_name = surfaces.get_name(surface)
	if surfaces.is_from_this_mod(surface_name) then
		if string.find(surface_name, config.surface_type_underground) then
			return config.surface_type_underground
		elseif string.find(surface_name, config.surface_type_sky) then
			return config.surface_type_sky
		end
	end
end	

function surfaces.is_underground(surface)
	return surfaces.get_type(surface) == config.surface_type_underground
end

function surfaces.is_above_nauvis(surface)
	return surfaces.get_type(surface) == config.surface_type_sky
end

function surfaces.get_surface_below(surface)
	return surfaces.get_relative_surface(surface, config.surface_location_below)
end

function surfaces.get_surface_above(surface)
	return surfaces.get_relative_surface(surface, config.surface_location_above)
end

function surfaces.create_surface_below(surface)
	return surfaces.create_relative_surface(surface, config.surface_location_below)
end

function surfaces.create_surface_above(surface)
	return surfaces.create_relative_surface(surface, config.surface_location_above)
end

function surfaces.create_surface(surface_type, surface_layer)
	local result = false
	if surfaces.is_valid_input(surface_type, surface_layer) then
		local surface_name = surfaces.get_mapname(surface_type, surface_layer)
		if util.get_surface(surface_name) == nil then
			util.create_surface(surface_name, surfaces.get_map_gen_settings(surface_type))
		end
		result = util.get_surface(surface_name)
	end
	return result
end

function surfaces.get_relative_surface(surface, relative_location)
	if surface then
		local surface_name = surfaces.get_name(surface)
		if type(surface) == "string" then
			surface = util.get_surface(surface_name)
		end
		if surface and surface.valid then
			if surface_name == "nauvis" or surfaces.is_from_this_mod(surface_name) then
				local surface_layer = surfaces.get_layer(surface_name)
				if relative_location == config.surface_location_below then
					if surfaces.is_above_nauvis(surface_name) then
						if surface_layer > 1 then
							return util.get_surface(surfaces.get_mapname(config.surface_type_sky, surface_layer - 1))
						else
							return util.get_surface("nauvis")
						end
					else
						return util.get_surface(surfaces.get_mapname(config.surface_type_underground, surface_layer + 1))			
					end
				elseif relative_location == config.surface_location_above then
					if surfaces.is_underground(surface_name) then
						if surface_layer > 1 then
							return util.get_surface(surfaces.get_mapname(config.surface_type_underground, surface_layer - 1))
						else
							return util.get_surface("nauvis")
						end
					else
						return util.get_surface(surfaces.get_mapname(config.surface_type_sky, surface_layer + 1))			
					end
				end
			end
		end
	end
end

function surfaces.create_relative_surface(surface, relative_location)
	if surface then
		local surface_layer = surfaces.get_layer(surface)
		local surface_name = surfaces.get_name(surface)
		if surfaces.is_from_this_mod(surface_name) then
			if relative_location == config.surface_location_below then
				if surfaces.is_underground(surface_name) then
					return surfaces.create_surface(config.surface_type_underground, surface_layer + 1)
				end
			elseif relative_location == config.surface_location_above then
				if surfaces.is_above_nauvis(surface_name) then
					return surfaces.create_surface(config.surface_type_sky, surface_layer + 1)
				end
			end
		elseif surfaces.get_name(surface) == "nauvis" then
			if relative_location == config.surface_location_above then
				return surfaces.create_surface(config.surface_type_sky, surface_layer + 1)
			elseif relative_location == config.surface_location_below then
				return surfaces.create_surface(config.surface_type_underground, surface_layer + 1)
			end
		end
		return surfaces.get_relative_surface(surface, relative_location)
	end
end

function surfaces.chunk_generator_corrections(surface, area)
	local newTiles, entitiesToCorrect = {}, {}
	local tile_name, entity_name
	local is_underground = surfaces.is_underground(surface)
	if is_underground then
		tile_name = config.tile_underground_floor
		entity_name = config.entity_underground_wall
	else
		tile_name = config.tile_sky_floor
	end
	local validArea = table.deepcopy(area)
	validArea.right_bottom.x = area.right_bottom.x-1
	validArea.right_bottom.y = area.right_bottom.y-1
	
	-- destroy entities which should not spawn on this surface and gather information for fixing entity location
	for k, v in pairs(surface.find_entities(validArea)) do
		local pair_data = pairdata.get(v)
		if is_underground then
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius})
			elseif v.type == "unit-spawner" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 5})
			elseif v.type == "turret" then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = 4})
			elseif v.type ~= "resource" and v.name ~= entity_name and v.type ~= "player" then
				v.destroy()
			end
		else
			if pair_data ~= nil then
				table.insert(entitiesToCorrect, {position = table.deepcopy(v.position), radius = pair_data.radius})
			else
				if v.type ~= "player" then v.destroy() end
			end
		end
	end
	
	--fix floor for sky surfaces
	if not(is_underground) then
		for k, v in pairs(entitiesToCorrect) do
			surfaces.clear_floor_around_location(v.position, surface, v.radius)
		end
	end
	
	-- insert appropriate tiles into array, create walls and set tiles
	for k, v in ipairs(util.get_tiles_in_area(validArea)) do
		table.insert(newTiles, {name = tile_name, position = v})
		if is_underground then
			util.create_entity(surface, {name = entity_name, position = v, force = game.forces.player})
		end
	end
	surface.set_tiles(newTiles)
	
	--fix floor for underground surfaces
	if is_underground then
		for k, v in pairs(entitiesToCorrect) do
			surfaces.clear_floor_around_location(v.position, surface, v.radius)
		end
	end
end

function surfaces.clear_floor_around_entity(entity, radius)
	if entity and entity.valid then
		return surfaces.clear_floor_around_location(entity.position, entity.surface, radius)
	end
end

function surfaces.clear_floor_around_location(position, surface, radius)
	if surfaces.is_from_this_mod(surface) and radius and radius >= 0 then
		local area = {left_top = {x = position.x - radius, y = position.y - radius}, right_bottom = {x = position.x + radius, y = position.y + radius}}
		local newTiles, oldTiles = {}, util.get_tiles_in_area(area)
		if surfaces.is_underground(surface) then
			for k, v in pairs(oldTiles) do
				for key, value in pairs(surface.find_entities_filtered({area = {v, v}, type = "tree", name = entity_underground_wall})) do
					value.destroy()
				end
			end			
		else
			for k, v in pairs(oldTiles) do
				table.insert(newTiles, {name = tile_sky_concrete, position = {v.x, v.y}})
			end
			surface.set_tiles(newTiles)
		end
	end
end

function surfaces.get_map_gen_settings(surface_type)
	math.randomseed(game.tick)
	local map_gen_settings = {
		terrain_segmentation = util.get_surface("nauvis").map_gen_settings.terrain_segmentation,
		water = "none",
		autoplace_controls = util.get_surface("nauvis").map_gen_settings.autoplace_controls,
		width = util.get_surface("nauvis").map_gen_settings.width,
		height = util.get_surface("nauvis").map_gen_settings.height,
		seed = math.floor(math.random()*4294967295),
		peaceful_mode = util.get_surface("nauvis").map_gen_settings.peaceful_mode}
	if surface_type == config.surface_type_sky then
		for k, v in pairs(map_gen_settings.autoplace_controls) do
			v.size = "none"
		end
	end
	return map_gen_settings
end

function surfaces.transport_player_to_access_shaft(player, destination_access_shaft)
	local new_position = util.find_non_colliding_position(destination_access_shaft.surface, player.character.prototype.name, destination_access_shaft.position, 2, 1)
	if not(new_position) then
		new_position = player.position
	end
	player.teleport(new_position, destination_access_shaft.surface)
end

function surfaces.find_nearby_access_shaft(entity, radius, surface)
	for k, v in pairs(surface.find_entities_filtered({area = {{entity.position.x - radius, entity.position.y - radius},{entity.position.x + radius, entity.position.y + radius}}, type = "simple-entity"})) do
		local pair_data = pairdata.get(v)
		if pair_data ~= nil and pair_data.class == config.pairclass_access_shaft then
			return v
		end
	end
	return nil
end

function surfaces.find_nearby_entity(anchor, radius, surface, entity_name, entity_type)
	if surface then
		for k, v in pairs(surface.find_entities_filtered({area = {{anchor.position.x - radius,anchor.position.y - radius}, {anchor.position.x + radius, anchor.position.y + radius}}, name = entity_name, type = entity_type})) do
			return v
		end
	end
	return nil
end