--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.pair-data")
require("script.lib.api")
require("script.const")
require("script.proto")
require("script.lib.struct")
require("script.lib.surfaces")
require("script.lib.util")

--[[--
Pair-util provides functionality for handling paired entities properly, many of the functions provided here also require the surfaces module

@module pairutil
]]
pairutil = {}

local en_und_wall = proto.get_field({"entity", "underground_wall"}, "name")
local et_und_wall = proto.get_field({"entity", "underground_wall"}, "type")
local tn_und_wall = proto.get_field({"tile", "underground_wall"}, "name")
local tn_und_dirt = proto.get_field({"tile", "underground_dirt"}, "name")
local tn_sky_void = proto.get_field({"tile", "sky_void"}, "name")
local tn_wood_floor = proto.get_field({"tile", "floor", "wood"}, "name")

local rl_above, rl_below = const.surface.rel_loc.above, const.surface.rel_loc.below
local st_und, st_sky, st_all = const.surface.type.underground, const.surface.type.sky, const.surface.type.all
local wt_circuit = const.wire.circuit
local tasks = const.eventmgr.task


local override_tiles = table.copy(const.surface.override_tiles, true)
override_tiles[tn_und_wall] = true

-- Attempts to find the paired entity of the provided entity, returning the result
function pairutil.find_paired_entity(_entity)
	if api.valid(_entity) then
		if pairdata.exists(_entity) then
			local _pair_data = pairdata.get(_entity) or pairdata.reverse(_entity)
			if _pair_data then
				local _dest = _pair_data.destination
				local _target_surface = (_dest == rl_above) and surfaces.get_surface_above(_entity.surface) or
					(_dest == rl_below and surfaces.get_surface_below(_entity.surface))
				return surfaces.find_nearby_entity(_entity, 0.5, _target_surface, _pair_data.name, api.type(api.game.entity_prototype(_pair_data.name)))
			end
		end
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.validate_paired_entity(_entity, _player_index)
	if api.valid(_entity) and (surfaces.is_mod_surface(_entity.surface) or api.name(_entity.surface) == "nauvis") then
		local _pair_data = pairdata.get(_entity)
		if surfaces.is_below_nauvis(_entity.surface) then
			if _pair_data.domain == st_sky.id then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed in underground surfaces, the item has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		elseif surfaces.is_above_nauvis(_entity.surface) then
			if _pair_data.domain == st_und.id then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed in sky surfaces, the item has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		else
			if _pair_data.nauvis ~= true then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed on the nauvis surface, the item has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		end
		if _entity then
			return _pair_data.destination
		end
	else
		if _player_index and api.game.player(_player_index) then
			util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed on this surface, the item has been dropped on the ground."})
		end
		table.insert(global.task_queue, struct.TaskSpecification(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
		api.destroy(_entity)
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_surface(_entity, _pair_location)
	if api.valid(_entity) and (_pair_location and const.surface.rel_loc_valid[_pair_location]) then
		if _pair_location == rl_above then
			local _paired_surface = surfaces.get_surface_above(_entity.surface)
			return (_paired_surface == nil) and surfaces.create_surface_above(_entity.surface) or _paired_surface
		elseif _pair_location == rl_below then
			local _paired_surface = surfaces.get_surface_below(_entity.surface)
			return (_paired_surface == nil) and surfaces.create_surface_below(_entity.surface) or _paired_surface
		end
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_entity(_entity, _paired_surface)
	if api.valid({_entity, _paired_surface}) then
		local _pair_data = pairdata.get(_entity)
		pairutil.clear_ground(_entity.position, _paired_surface, _pair_data.radius, _pair_data.custom.tile)
		local _paired_entity = api.surface.create_entity(_paired_surface, {name = _pair_data.name, position = _entity.position, force = _entity.force})
		return (api.valid(_paired_entity) == true) and _paired_entity or false
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.finalize_paired_entity(_entity, _paired_entity, _player_index)
	if api.valid(_entity) then
		local _pair_data = pairdata.get(_entity)
		_paired_entity = _paired_entity or pairutil.find_paired_entity(_entity)
		if _paired_entity then
			if _pair_data.class == pairclass.get("energy-transport") then
				table.insert(global.energy_transport, {a = _entity, b = _paired_entity})
				api.entity.connect_neighbour(_entity, _paired_entity, wt_circuit)
			elseif _pair_data.class == pairclass.get("fluid-transport") then
				table.insert(global.fluid_transport, {a = _entity, b = _paired_entity})
			elseif _pair_data.class == pairclass.get("item-transport") then
				table.insert(global.item_transport, {input = _entity, output = _paired_entity, tier = _pair_data.custom.tier, modifier = _pair_data.modifier})
			elseif _pair_data.class == pairclass.get("rail-transport") then
				api.entity.set_direction(_paired_entity, api.entity.direction(_entity))
			elseif _pair_data.class == pairclass.get("access-shaft") then
				local _coal, _inv = struct.SimpleItemStack("coal", 100), defines.inventory.fuel
				_entity.operable, _paired_entity.operable = false, false --Prevent people from opening or driving the access-shaft (since it's really a vehicle)
				api.inventory.insert(api.entity.get_inventory(_entity, _inv), _coal) --Add some fuel into the access-shaft vehicle to prevent the "no-fuel" icon from flashing
				api.inventory.insert(api.entity.get_inventory(_paired_entity, _inv), _coal) --Add some fuel into the paired access-shaft vehicle to prevent the "no-fuel" icon from flashing
			end
		else
			if _player_index and api.game.player(_player_index) then
				util.message(_player_index, {"", api.localised_name(_entity), " could not be paired successfully, the item has been dropped on the ground."})
			end
			table.insert(global.task_queue, struct.TaskSpecification(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
			api.destroy(_entity)
		end
	end
end

-- Internal function, called from events.on_preplayer_mined_item(event) and events.on_robot_pre_mined(event)
function pairutil.destroy_paired_entity(_entity)
	local _paired_entity = pairutil.find_paired_entity(_entity)
	local _pair_data = pairdata.get(_entity) or pairdata.reverse(_entity)
	table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.remove_sky_tile, {_entity, _paired_entity, _pair_data.radius}))
	if _pair_data.class == pairclass.get("access-shaft") then
		api.entity.get_inventory(_entity, defines.inventory.fuel).clear()
		api.entity.get_inventory(_paired_entity, defines.inventory.fuel).clear()
	end
	api.destroy(_paired_entity)
end

-- Used to clear the ground around a position for placement of a paired entity, also used to clear ground around unit spawners and other things during chunk generation event
function pairutil.clear_ground(_position, _surface, _radius, _tile, _ignore_walls)
	if struct.is_Position(_position) and api.valid(_surface) and surfaces.is_mod_surface(_surface) then
		_radius = (type(_radius) == "number" and _radius >= 0) and _radius or 0
		local _pos_x, _pos_y = _position.x, _position.y
		local _area, _tiles, _old_tiles = struct.BoundingBox_from_Position(_pos_x, _pos_y, _radius), {},  {}
		local _is_underground, _is_platform = surfaces.is_below_nauvis(_surface), surfaces.is_above_nauvis(_surface)
		local _tile_name = (_is_underground) and tn_und_dirt or (_tile or tn_wood_floor)
		if _is_underground and not(_ignore_walls) then
			for k, v in pairs(api.surface.find_entities(_surface, _area, en_und_wall, et_und_wall)) do
				api.destroy(v)
			end
		end
		for _y = _pos_y - _radius, _pos_y + _radius, 1 do
			for _x = _pos_x - _radius, _pos_x + _radius, 1 do
				local _cur_pos = struct.Position(_x, _y)
				local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
				local _cur_tile_name = api.name(_cur_tile)
				local _cur_tile_valid = surfaces.is_tile_placement_valid(_cur_tile, _surface, override_tiles)
				table.insert(_tiles, {name = _tile_name, position = _cur_pos})
				table.insert(_old_tiles, {name = (_cur_tile_valid and _cur_tile_name ~= tn_sky_void) and _cur_tile_name or _tile_name, position = _cur_pos})
			end
		end
		api.surface.set_tiles(_surface, _tiles)
		api.surface.set_tiles(_surface, _old_tiles)
	end
end

-- Fixes silly ground problems in underground and platform surfaces
function pairutil.fix_tiles(_position, _surface, _radius, _remove_tiles)
	if struct.is_Position(_position) and api.valid(_surface) and surfaces.is_mod_surface(_surface) then
		_radius = _radius or 0
		local _is_underground, _is_platform = surfaces.is_below_nauvis(_surface), surfaces.is_above_nauvis(_surface)
		if _remove_tiles and not(_is_platform) then return end -- remove tiles only works in sky surfaces
		local _tile_name = (_is_underground) and tn_und_dirt or (_is_platform and tn_sky_void) 
		local _old_tiles, _tiles, _entities, _pos_x, _pos_y = {}, {}, {}, math.floor(_position.x), math.floor(_position.y)
		local _area = (_remove_tiles) and struct.BoundingBox_from_Position(_pos_x, _pos_y, _radius) or {}
		local _safe_area = (_remove_tiles) and struct.BoundingBox_from_Position(_pos_x, _pos_y, _radius + 1) or {}
		for _y = _pos_y - _radius, _pos_y + _radius, 1 do
			for _x = _pos_x - _radius, _pos_x + _radius, 1 do
				local _cur_pos = struct.Position(_x, _y)
				local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
				local _cur_tile_name = api.name(_cur_tile)
				table.insert(_tiles, {name = _tile_name, position = _cur_pos})
				if _remove_tiles then
					table.insert(_old_tiles, {name = _tile_name, position = _cur_pos})
				else
					local _name = (surfaces.is_tile_placement_valid(_cur_tile, _surface) and _cur_tile_name or _tile_name)
					table.insert(_old_tiles, {name = _name, position = _cur_pos})
					if (_is_underground and _name == tn_und_wall) then
						table.insert(_entities, {name = en_und_wall, position = struct.Position(_x, _y)})
					end
				end
			end
		end
		if _remove_tiles then
			for k, v in pairs(api.surface.find_entities(_surface, _safe_area, "player", "player")) do
				if v.player then
					surfaces.transport_player(v.player, surfaces.get_surface_below(v.surface), v.position)
				end
			end
		end
		api.surface.set_tiles(_surface, _tiles)
		api.surface.set_tiles(_surface, _old_tiles)
		for k, v in pairs(_entities) do
			if api.surface.count_entities(_surface, v.position, en_und_wall, et_und_wall) == 0 then
				api.surface.create_entity(_surface, v)
			end
		end
	end
end

-- Used to remove tiles underneath paired entities when they are placed in the sky. Respects when users place down concrete and stone brick above paired entity tiles, ensuring that players do not lose tiles. Needs to be improved significantly or will be deprecated in the near future.
function pairutil.remove_tiles(_position, _surface, _radius)
	pairutil.fix_tiles(_position, _surface, _radius, true)
end

return pairutil