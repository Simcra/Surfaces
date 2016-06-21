--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.pair-data")
require("script.lib.surfaces")
require("script.lib.struct")
require("script.lib.api-util")
require("script.lib.util")

pairutil = {}

-- Attempts to find the paired entity of the provided entity, returning the result
function pairutil.find_paired_entity(entity)
	if api.valid(entity) then
		local pair_data = pairdata.get(entity) or pairdata.reverse(entity)
		if pair_data then
			if pair_data.destination == enum.surface.rel_loc.above then
				return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_above(entity.surface), pair_data.name, api.type(api.game.entity_prototype(pair_data.name)))
			elseif pair_data.destination == enum.surface.rel_loc.below then
				return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_below(entity.surface), pair_data.name, api.type(api.game.entity_prototype(pair_data.name)))
			end
		end
	end
end


-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.validate_paired_entity(entity, player_index)
	if api.valid(entity) and (surfaces.is_from_this_mod(entity.surface) == true or api.name(entity.surface) == "nauvis") then
		local pair_data = pairdata.get(entity)
		if surfaces.is_below_nauvis(entity.surface) then
			if pair_data.domain == enum.surface.type.sky.id then
				if player_index and api.game.player(player_index) then
					util.message(player_index, entity.name .. " may not be placed in sky surfaces, it has been dropped on the ground.")
				end
				table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.spill_entity_result, {entity, api.entity.minable_result(entity)}))
				api.destroy(entity)
			end
		elseif surfaces.is_above_nauvis(entity.surface) then
			if pair_data.domain == enum.surface.type.underground.id then
				if player_index and api.game.player(player_index) then
					util.message(player_index, entity.name .. " may not be placed in underground surfaces, it has been dropped on the ground.")
				end
				table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.spill_entity_result, {entity, api.entity.minable_result(entity)}))
				api.destroy(entity)
			end
		else
			if pair_data.nauvis ~= true then
				if player_index and api.game.player(player_index) then
					util.message(player_index, entity.name .. " may not be placed on the nauvis surface, it has been dropped on the ground.")
				end
				table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.spill_entity_result, {entity, api.entity.minable_result(entity)}))
				api.destroy(entity)
			end
		end
		if entity then
			return pair_data.destination
		end
	else
		if player_index and api.game.player(player_index) then
			util.message(player_index, entity.name .. " may not be placed on this surface, it has been dropped on the ground.")
		end
		table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.spill_entity_result, {entity, api.entity.minable_result(entity)}))
		api.destroy(entity)
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_surface(entity, pair_location)
	if api.valid(entity) and (pair_location and table.reverse(enum.surface.rel_loc)[pair_location]) then
		if pair_location == enum.surface.rel_loc.above then
			local paired_surface = surfaces.get_surface_above(entity)
			return (paired_surface == nil) and surfaces.create_surface_above(entity.surface) or paired_surface
		else
			local paired_surface = surfaces.get_surface_below(entity)
			return (paired_surface == nil) and surfaces.create_surface_below(entity.surface) or paired_surface
		end
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_entity(entity, paired_surface)
	if api.valid({entity, paired_surface}) then
		local pair_data = pairdata.get(entity)
		pairutil.clear_ground(entity.position, paired_surface, pair_data.radius, pair_data.tile)
		local paired_entity = api.surface.create_entity(paired_surface, {name = pair_data.name, position = entity.position, force = entity.force})
		return (api.valid(paired_entity) == true) and paired_entity or false
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.finalize_paired_entity(entity, paired_entity, player_index)
	if api.valid(entity) then
		local pair_data = pairdata.get(entity)
		paired_entity = paired_entity or pairutil.find_paired_entity(entity)
		if paired_entity then
			if pair_data.class == pairclass.get("electric-pole") then
				api.entity.connect_neighbour(entity, paired_entity, enum.wire.all)
			elseif pair_data.class == pairclass.get("fluid-transport") then
				table.insert(global.fluid_transport, {a = entity, b = paired_entity})
			elseif pair_data.class == pairclass.get("transport-chest") then
				table.insert(global.transport_chests, {input = entity, output = paired_entity})
			elseif pair_data.class == pairclass.get("rail-transport") then
				api.entity.set_direction(paired_entity, api.entity.direction(entity))
			end
		else
			if player_index and api.game.player(player_index) then
				util.message(player_index, entity.name .. " could not be paired successfully, it has been dropped on the ground.")
			end
			table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.spill_entity_result, {entity, api.entity.minable_result(entity)}))
			api.destroy(entity)
		end
	end
end

-- Internal function, called from events.on_preplayer_mined_item(event) and events.on_robot_pre_mined(event)
function pairutil.destroy_paired_entity(entity)
	local pair_entity = pairutil.find_paired_entity(entity)
	local pair_data = pairdata.get(entity) or pairdata.reverse(entity)
	table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.remove_sky_tile, {entity, pair_entity, pair_data.radius}))
	api.destroy(pair_entity)
end

-- Used to clear the ground around a position for placement of a paired entity, also used to clear ground around unit spawners and other things during chunk generation event
function pairutil.clear_ground(position, surface, radius, tile)
	if struct.is_Position(position) and api.valid(surface) then
		if surfaces.is_from_this_mod(surface) then
			radius = radius or 0
			local area = struct.BoundingBox(position.x - radius, position.y - radius, position.x + radius, position.y + radius)
			if surfaces.is_below_nauvis(surface) then
				local und_wall = enum.prototype.entity.underground_wall
				for k, v in pairs(api.surface.find_entities(surface, area, und_wall.name, und_wall.type)) do
					api.destroy(v)
				end
			else
				local newTiles, oldTiles = {}, {}
				local sky_tile_prototype = enum.prototype.tile.sky_concrete.name
				for k, v in pairs(struct.TilePositions(area)) do
					local tile_prototype = api.name(api.surface.get_tile(surface, v))
					table.insert(oldTiles, {name = ((skytiles.get(tile_prototype) == nil) and tile_prototype or sky_tile_prototype), position = v})
					table.insert(newTiles, {name = tile, position = v})
				end
				api.surface.set_tiles(surface, newTiles)
			end
		end
	end
end

-- Used to remove tiles underneath paired entities when they are placed in the sky. Respects when users place down concrete and stone brick above paired entity tiles, ensuring that players do not lose tiles.
function pairutil.remove_tiles(position, surface, radius)
	if struct.is_Position(position) and api.valid(surface) then
		if surfaces.is_from_this_mod(surface) and surfaces.is_above_nauvis(surface) then
			radius = radius or 0
			local area = struct.BoundingBox(position.x - radius, position.y - radius, position.x + radius, position.y + radius)
			local safeArea = struct.BoundingBox(area.left_top.x - 1, area.left_top.y - 1, area.right_bottom.x + 1, area.right_bottom.y + 1)
			local oldTiles, newTiles, entities = {}, {}, {}
			local sky_tile_prototype = enum.prototype.tile.sky_floor.name
			for k, v in pairs(struct.TilePositions(area)) do
				local tile_prototype = api.name(api.surface.get_tile(surface, v))
				table.insert(oldTiles, {name = ((skytiles.get(tile_prototype) == nil) and tile_prototype or sky_tile_prototype), position = v})
				table.insert(newTiles, {name = sky_tile_prototype, position = v})
			end
			--for k, v in pairs(api.surface.find_entities(surface, area)) do
			for k, v in pairs(api.surface.find_entities(surface, safeArea, "player", "player")) do
				--table.insert(entities, v)
				for key, value in pairs(api.game.players()) do
					if value.character == v then
						surfaces.transport_player(value, api.game.surface("nauvis"), v.position)
						break
					end
				end
			end
			api.surface.set_tiles(surface, newTiles)
			api.surface.set_tiles(surface, oldTiles)
			-- temporarily commented out until surface teleport can be used on non-player entities
			--for k, v in pairs(entities) do
			--	if api.type(v) ~= "player" then
			--		api.entity.teleport(v, v.position, surface)
			--	end
			--end
		end
	end
end