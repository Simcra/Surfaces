--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("prototypes.prototype")
require("script.const")
require("script.lib.api")
require("script.lib.pair-data")
require("script.lib.struct")
require("script.lib.surfaces")
require("script.lib.util")
local taskmgr = require("script.taskmgr-data")

--[[--
Pair-util provides functionality for handling paired entities, many of the functions provided here also require the surfaces module functions

@module pairutil
]]
pairutil = {}

local en_und_wall = proto.entity.underground_wall.name
local et_und_wall = proto.entity.underground_wall.type
local tn_und_wall = proto.tile.underground_wall.name
local tn_und_dirt = proto.tile.underground_dirt.name
local tn_sky_void = proto.tile.sky_void.name
local tn_wood_floor = proto.tile.floor.wood.name

local rl_above, rl_below, rl_valid = const.surface.rel_loc.above, const.surface.rel_loc.below, const.surface.rel_loc_valid
local st_und, st_sky, st_all = const.surface.type.underground, const.surface.type.sky, const.surface.type.all
local wt_circuit = const.wire.circuit
local tasks = const.taskmgr.task

local override_tiles = table.copy(const.surface.override_tiles, true)
override_tiles[tn_und_wall] = true

-- Attempts to find the paired entity of the provided entity, returning the result
function pairutil.find_paired_entity(_entity)
	if api.valid(_entity) and pairdata.exists(_entity) then
		local _pair_data = pairdata.get(_entity) or pairdata.reverse(_entity)
		local _dest = _pair_data.destination
		local _target_surface = (_dest == rl_above) and surfaces.get_surface_above(_entity.surface) or
			(_dest == rl_below and surfaces.get_surface_below(_entity.surface))
		return surfaces.find_nearby_entity(_entity, 0.5, _target_surface, _pair_data.name, api.type(api.game.entity_prototype(_pair_data.name)))
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
				taskmgr.insert(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)})
				api.destroy(_entity)
			end
		elseif surfaces.is_above_nauvis(_entity.surface) then
			if _pair_data.domain == st_und.id then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed in sky surfaces, the item has been dropped on the ground."})
				end
				taskmgr.insert(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)})
				api.destroy(_entity)
			end
		else
			if _pair_data.nauvis ~= true then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed on the nauvis surface, the item has been dropped on the ground."})
				end
				taskmgr.insert(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)})
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
		taskmgr.insert(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)})
		api.destroy(_entity)
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_surface(_entity, _pair_location)
	if api.valid(_entity) and (_pair_location and rl_valid[_pair_location]) then
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
				local _coal_stack = struct.SimpleItemStack("coal", 100)
				_entity.operable, _paired_entity.operable = false, false --Prevent people from opening or driving the access-shaft (since it's really a vehicle)
				api.inventory.insert(api.entity.get_inventory(_entity, defines.inventory.fuel), _coal_stack) --Add some fuel into the access-shaft vehicle to prevent the "no-fuel" icon from flashing
				api.inventory.insert(api.entity.get_inventory(_paired_entity, defines.inventory.fuel), _coal_stack) --Add some fuel into the paired access-shaft vehicle to prevent the "no-fuel" icon from flashing
			end
		else
			if _player_index and api.game.player(_player_index) then
				util.message(_player_index, {"", api.localised_name(_entity), " could not be paired successfully, the item has been dropped on the ground."})
			end
			taskmgr.insert(tasks.spill_entity_result, {_entity, api.entity.minable_result(_entity)})
			api.destroy(_entity)
		end
	end
end

-- Internal function, called from events.on_preplayer_mined_item(event) and events.on_robot_pre_mined(event)
function pairutil.destroy_paired_entity(_entity)
	local _paired_entity = pairutil.find_paired_entity(_entity)
	local _pair_data = pairdata.get(_entity) or pairdata.get(_paired_entity)
	if _pair_data.class == pairclass.get("access-shaft") then
		local _inventories = {api.entity.get_inventory(_entity, defines.inventory.fuel), api.entity.get_inventory(_paired_entity, defines.inventory.fuel)}
		for k, v in pairs(_inventories) do v.clear() end
	end
	taskmgr.insert(tasks.remove_sky_tile, {_entity, _paired_entity, _pair_data.radius})
	api.destroy(_paired_entity)
end

-- Used to clear the ground around a position for placement of a paired entity, also used to clear ground around unit spawners and other things during chunk generation event
function pairutil.clear_ground(_position, _surface, _radius, _tile, _ignore_walls)
	if struct.is_Position(_position) and api.valid(_surface) and surfaces.is_mod_surface(_surface) then
		_radius = (type(_radius) == "number" and _radius >= 0) and _radius or 0
		local _pos_x, _pos_y = math.floor(_position.x) + 0.5, math.floor(_position.y) + 0.5
		local _area, _tiles, _old_tiles = struct.BoundingBox_from_Position(_pos_x, _pos_y, _radius), {},  {}
		local _x1, _y1, _x2, _y2 = _area.left_top.x, _area.left_top.y, _area.right_bottom.x, _area.right_bottom.y
		local _is_underground, _is_platform = surfaces.is_below_nauvis(_surface), surfaces.is_above_nauvis(_surface)
		local _tile_name = (_is_underground) and tn_und_dirt or (_tile or tn_wood_floor)
		if _is_underground and not(_ignore_walls) then
			for k, v in pairs(api.surface.find_entities(_surface, _area, en_und_wall, et_und_wall)) do
				api.destroy(v)
			end
		end
		for _y = _y1, _y2, 1 do
			for _x = _x1, _x2, 1 do
				local _cur_pos = struct.Position(_x, _y)
				local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
				local _cur_tile_name, _cur_tile_valid = api.name(_cur_tile), surfaces.is_tile_placement_valid(_cur_tile, _surface, override_tiles)
				if not(_cur_tile_valid) and (_cur_tile_name ~= tn_sky_void and _cur_tile_name ~= tn_und_dirt) then
					table.insert(_tiles, {name = _tile_name, position = _cur_pos})
					table.insert(_old_tiles, {name = _tile_name, position = _cur_pos})
					if _is_underground and not(_ignore_walls) then
						if _x == _x1 and _y == _y1 then pairutil.fix_tiles(struct.Position(_x - 1, _y - 1), _surface, 0, nil, tn_und_wall)
						elseif _x == _x1 and _y == _y2 then pairutil.fix_tiles(struct.Position(_x - 1, _y + 1), _surface, 0, nil, tn_und_wall)
						elseif _x == _x2 and _y == _y1 then pairutil.fix_tiles(struct.Position(_x + 1, _y - 1), _surface, 0, nil, tn_und_wall)
						elseif _x == _x2 and _y == _y2 then pairutil.fix_tiles(struct.Position(_x + 1, _y + 1), _surface, 0, nil, tn_und_wall) end
						if _x == _x1 then pairutil.fix_tiles(struct.Position(_x - 1, _y), _surface, 0, nil, tn_und_wall)
						elseif _x == _x2 then pairutil.fix_tiles(struct.Position(_x + 1, _y), _surface, 0, nil, tn_und_wall) end
						if _y == _y1 then pairutil.fix_tiles(struct.Position(_x, _y - 1), _surface, 0, nil, tn_und_wall)
						elseif _y == _y2 then pairutil.fix_tiles(struct.Position(_x, _y + 1), _surface, 0, nil, tn_und_wall) end
					end
				end
			end
		end
		api.surface.set_tiles(_surface, _tiles)
		api.surface.set_tiles(_surface, _old_tiles)
	end
end

-- Fixes silly ground problems in underground and platform surfaces
function pairutil.fix_tiles(_position, _surface, _radius, _remove_tiles, _override_tile)
	if struct.is_Position(_position) and api.valid(_surface) and surfaces.is_mod_surface(_surface) then
		_radius = _radius or 0
		local _is_underground, _is_platform = surfaces.is_below_nauvis(_surface), surfaces.is_above_nauvis(_surface)
		if _remove_tiles and not(_is_platform) then return end -- remove tiles only works in sky surfaces
		local _tile_name = _override_tile or ((_is_underground) and tn_und_dirt or (_is_platform and tn_sky_void)) 
		local _old_tiles, _tiles, _entities = {}, {}, {}
		local _pos_x, _pos_y = math.floor(_position.x) + 0.5, math.floor(_position.y) + 0.5
		local _x1, _y1, _x2, _y2 = _pos_x - _radius, _pos_y - _radius, _pos_x + _radius, _pos_y + _radius
		local _area, _safe_area = {}, {}
		if _remove_tiles then
			_area, _safe_area = struct.BoundingBox(_x1, _y1, _x2, _y2), struct.BoundingBox(_x1 - 1, _y1 - 1, _x2 + 1, _y2 + 1)
		end
		for _y = _y1, _y2, 1 do
			for _x = _x1, _x2, 1 do
				local _cur_pos = struct.Position(_x, _y)
				local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
				local _cur_tile_name = api.name(_cur_tile)
				if _cur_tile_name ~= _tile_name then
					table.insert(_tiles, {name = _tile_name, position = _cur_pos})
					if _remove_tiles then
						table.insert(_old_tiles, {name = _tile_name, position = _cur_pos})
					else
						local _name = (surfaces.is_tile_placement_valid(_cur_tile, _surface) and _cur_tile_name or _tile_name)
						table.insert(_old_tiles, {name = _name, position = _cur_pos})
						if (_is_underground and _name == tn_und_wall) then
							table.insert(_entities, {name = en_und_wall, position = _cur_pos})
						end
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
function pairutil.remove_tiles(_position, _surface, _radius) return pairutil.fix_tiles(_position, _surface, _radius, true) end

return pairutil