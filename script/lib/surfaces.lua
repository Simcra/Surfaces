--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")
require("script.lib.util")
require("script.lib.pair-util")
require("defines")

function create_surface(surface_type, surface_layer)
	local result = false
	if is_valid_surface(surface_type, surface_layer) then
		local surface_name = surface_mapname(surface_type, surface_layer)
		if get_surface(surface_name)==nil then
			game.create_surface(surface_name, get_map_gen_settings(surface_type))
		end
		result = get_surface(surface_name)
	end
	return result
end

function surface_mapname(surface_type, surface_layer)
	local result = "nauvis"
	if is_valid_surface(surface_type, surface_layer) then
		result = surface_prefix.."_"..surface_type.."_"..surface_layer
	end
	return result
end
	
function is_valid_surface_type(surface_type)
	return (surface_type==surface_type_underground or surface_type==surface_type_sky)
end

function is_surface_from_this_mod(surface)
	return string.find(tostring(get_surface_name(surface)), surface_prefix.."_") ~= nil
end

function get_surface_name(surface)
	if surface and surface.valid then return surface.name
	else return surface end
end

function get_surface_layer(surface)
	local surface_name=get_surface_name(surface)
	local surface_layer=nil
	if is_surface_from_this_mod(surface_name) then
		local surface_string=surface_prefix.."_"..get_surface_type(surface_name).."_"
		surface_layer=string.sub(surface_name, string.find(surface_name, surface_string)+string.len(surface_string))
	elseif surface_name=="nauvis" then surface_layer=0 end
	return tonumber(surface_layer)
end

function get_surface_type(surface)
	local surface_name = get_surface_name(surface)
	if is_surface_from_this_mod(surface) then
		if string.find(surface_name, surface_type_underground) then return surface_type_underground
		elseif string.find(surface_name, surface_type_sky) then return surface_type_sky end
	end
	return nil
end	

function is_surface_underground(surface)
	return get_surface_type(get_surface_name(surface)) == surface_type_underground
end

function get_surface_above(surface)
	if surface and surface.valid then
		if is_surface_from_this_mod(surface) or surface.name=="nauvis" then
			local surface_layer = get_surface_layer(surface)
			if is_surface_underground(surface) then
				if surface_layer > 1 then return get_surface(surface_mapname(surface_type_underground, surface_layer-1))
				elseif surface.name=="nauvis" then return get_surface(surface_mapname(surface_type_sky, 1))
				else return get_surface("nauvis") end
			else
				return get_surface(surface_mapname(surface_type_sky, surface_layer+1))
			end
		end
	end
end

function create_surface_above(surface)
	local surface_name = get_surface_name(surface)
	if is_surface_from_this_mod(surface) then
		local surface_layer = get_surface_layer(surface)
		if not(is_surface_underground(surface)) then
			return create_surface(surface_type_sky, surface_layer+1)
		end
	elseif surface_name == "nauvis" then
		return create_surface(surface_type_sky, 1)
	end
	return get_surface_above(surface)
end

function get_surface_below(surface)
	if is_surface_from_this_mod(surface) or surface.name=="nauvis" then
		local surface_layer = get_surface_layer(surface)
		if is_surface_underground(surface) then
			return get_surface(surface_mapname(surface_type_underground, surface_layer+1))
		else
			if surface_layer > 1 then return get_surface(surface_mapname(surface_type_sky, surface_layer-1))
			elseif surface.name=="nauvis" then return get_surface(surface_mapname(surface_type_underground, 1))
			else return get_surface("nauvis") end
		end
	end
end

function create_surface_below(surface)
	if is_surface_from_this_mod(surface) then
		local surface_layer = get_surface_layer(surface)
		if is_surface_underground(surface) then 
			return create_surface(surface_type_underground, surface_layer+1)
		end
	elseif get_surface_name(surface) == "nauvis" then
		return create_surface(surface_type_underground, 1)
	end
	return get_surface_below(surface)
end

function is_valid_surface(surface_type, surface_layer)
	return ((surface_layer >=1) and is_valid_surface_type(surface_type))
end

function surfaces_chunk_generated(surface, area)
	local newTiles, entitiesToCorrect = {}, {}
	--local pairEntities={"sky-entrance", "sky-exit", "underground-entrance", "underground-exit", "electric-pole-upper", "electric-pole-lower", "fluid-transport-upper", "fluid-transport-lower", "receiver-chest-lower", "receiver-chest-upper", "transport-chest-up", "transport-chest-down"}
	local tile_name, entity_name
	local is_underground = is_surface_underground(surface)
	if is_underground then
		tile_name = tile_underground_floor
		entity_name = entity_underground_wall
	else
		tile_name = tile_sky_floor
	end
	local validArea = table.deepcopy(area)
	validArea.right_bottom.x = area.right_bottom.x-1
	validArea.right_bottom.y = area.right_bottom.y-1
	
	-- destroy entities which should not spawn on this surface and gather information for fixing entity location
	for k, v in pairs(surface.find_entities(validArea)) do
		local pair_data = pairdata_get(v)
		if is_underground == true then
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
	if is_underground == false then
		for k, v in pairs(entitiesToCorrect) do
			clear_floor_around_location(v.position, surface, v.radius)
		end
	end
	
	-- insert appropriate tiles into array, create walls and set tiles
	for k, v in ipairs(get_tiles_in_area(validArea)) do
		table.insert(newTiles, {name = tile_name, position = {v.x, v.y}})
		-- section below needs to be replaced since it causes much lag.
		-- Without this script update is: ~0.1 -> 0.25ms
		-- With this, script update is: ~1 -> 2.03ms
		--[[if is_underground == true and surface.count_entities_filtered({area = {{v.x, v.y},{v.x, v.y}}, name = entity_name}) == 0 then
			surface.create_entity({name = entity_name, position = {v.x, v.y}, force = game.forces.player})
		end]]
	end
	surface.set_tiles(newTiles)
	
	--fix floor for underground surfaces
	if is_underground == true then
		for k, v in pairs(entitiesToCorrect) do
			clear_floor_around_location(v.position, surface, v.radius)
		end
	end
end

function clear_floor_around_entity(entity, radius)
	if entity and entity.valid then return clear_floor_around_location(entity.position, entity.surface, radius) end
end

function clear_floor_for_paired_entity(entity, surface, radius)
	return clear_floor_around_location({x = entity.position.x, y = entity.position.y}, surface, radius)
end

function clear_floor_around_location(position, surface, radius)
	if is_surface_from_this_mod(surface) and radius and radius>=0 then
		local area = {left_top = {x = position.x - radius, y = position.y - radius}, right_bottom = {x = position.x + radius, y = position.y + radius}}
		local newTiles, oldTiles = {}, get_tiles_in_area(area)
		if is_surface_underground(surface) then
			for k, v in pairs(oldTiles) do
				for key, value in pairs(surface.find_entities_filtered({area = {v, v}, type="tree", name == entity_underground_wall})) do
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

function get_map_gen_settings(surface_type)
	math.randomseed(game.tick)
	local map_gen_settings = {
		terrain_segmentation = get_surface("nauvis").map_gen_settings.terrain_segmentation,
		water = "none",
		autoplace_controls = get_surface("nauvis").map_gen_settings.autoplace_controls,
		width = get_surface("nauvis").map_gen_settings.width,
		height = get_surface("nauvis").map_gen_settings.height,
		seed = math.floor(math.random()*4294967295),
		peaceful_mode = get_surface("nauvis").map_gen_settings.peaceful_mode}
	if surface_type == surface_type_sky then
		for k, v in pairs(map_gen_settings.autoplace_controls) do v.size = "none" end
	end
	return map_gen_settings
end

function transport_player_to_access_shaft(player, destination_access_shaft)
	local new_position = destination_access_shaft.surface.find_non_colliding_position(player.character.prototype.name, destination_access_shaft.position, 2, 1)
	if not(new_position) then
		new_position = player.position
	end
	player.teleport(new_position, destination_access_shaft.surface)
end

function find_nearby_access_shaft(entity, radius, surface)
	for k, v in pairs(surface.find_entities_filtered({area={{entity.position.x-radius,entity.position.y-radius},{entity.position.x+radius,entity.position.y+radius}},type="simple-entity"})) do
		local pair_data = pairdata_get(v)
		if pair_data ~= nil and pair_data.class==pairclass_access_shaft then
			return v
		end
	end
	return nil
end

function find_paired_entity(entity)
	local pair_data = pairdata_get(entity)
	if pair_data then
		if pair_data.destination==surface_location_above then
			return find_nearby_entity_by_name(entity, 0.5, get_surface_above(entity.surface), pair_data.name)
		else
			return find_nearby_entity_by_name(entity, 0.5, get_surface_below(entity.surface), pair_data.name)
		end
	end
	return nil
end

function validate_paired_entity(entity)
	local pair_data = pairdata_get(entity)
	local paired_entity, paired_surface = nil
	if is_surface_underground(entity.surface) then
		if pair_data.domain==surface_type_sky then 
			entity.destroy()
		end
	elseif entity.surface.name=="nauvis" then
		if pair_data.nauvis~=true then
			entity.destroy()
		end
	elseif is_surface_from_this_mod(entity.surface) then
		if pair_data.domain==surface_type_underground then
			entity.destroy()
		end
	end
	return pair_data.destination
end

function create_paired_surface(entity, pair_location)
	local paired_surface = nil
	if entity and entity.valid then
		if pair_location==surface_location_above then
			paired_surface=get_surface_above(entity)
			if not(paired_surface) or not(paired_surface.valid) then
				paired_surface=create_surface_above(entity.surface)
			end
		elseif pair_location==surface_location_below then
			paired_surface=get_surface_below(entity)
			if not(paired_surface) or not(paired_surface.valid) then
				paired_surface=create_surface_below(entity.surface)
			end
		end
	else
		paired_surface=false
	end
	return paired_surface
end

function create_paired_entity(entity, paired_surface)
	local pair_data = pairdata_get(entity)
	local paired_entity = nil
	if paired_surface and paired_surface.valid then
		clear_floor_for_paired_entity(entity, paired_surface, pair_data.radius)
		paired_entity = paired_surface.create_entity({name=pair_data.name, position=entity.position, force=entity.force})
		if not(paired_entity and paired_entity.valid) then
			return false
		end
		return paired_entity
	else return false
	end
end

function finalize_paired_entity(entity, paired_entity)
	local pair_data = pairdata_get(entity)
	if pair_data.class==pairclass_electric_pole then
		entity.connect_neighbour(paired_entity)
		entity.connect_neighbour{wire = defines.circuitconnector.red, target_entity = paired_entity}
		entity.connect_neighbour{wire = defines.circuitconnector.green, target_entity = paired_entity}
	elseif pair_data.class==pairclass_fluid_transport then
		global.fluid_transport = global.fluid_transport or {}
		table.insert(global.fluid_transport, {a=entity, b=paired_entity})
	elseif pair_data.class==pairclass_transport_chest then
		global.transport_chests = global.transport_chests or {}
		table.insert(global.transport_chests, {input=entity,output=paired_entity})
	end
end

function destroy_paired_entity(entity)
	local paired_entity = find_paired_entity(entity)
	if paired_entity then
		paired_entity.destroy()
	end
end