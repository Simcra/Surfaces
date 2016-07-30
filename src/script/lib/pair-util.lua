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

local override_tiles
if override_tiles == nil then
	override_tiles = const.override_tiles
	override_tiles[tn_und_wall] = true
end

-- Attempts to find the paired entity of the provided entity, returning the result
function pairutil.find_paired_entity(_entity)
	if api.valid(_entity) then
		if pairdata.exists(_entity) then
			local _pair_data = pairdata.get(_entity) or pairdata.reverse(_entity)
			if _pair_data then
				if _pair_data.destination == const.surface.rel_loc.above then
					return surfaces.find_nearby_entity(_entity, 0.5, surfaces.get_surface_above(_entity.surface), _pair_data.name, api.type(api.game.entity_prototype(_pair_data.name)))
				elseif _pair_data.destination == const.surface.rel_loc.below then
					return surfaces.find_nearby_entity(_entity, 0.5, surfaces.get_surface_below(_entity.surface), _pair_data.name, api.type(api.game.entity_prototype(_pair_data.name)))
				end
			end
		end
	end
end


-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.validate_paired_entity(_entity, _player_index)
	if api.valid(_entity) and (surfaces.is_from_this_mod(_entity.surface) == true or api.name(_entity.surface) == "nauvis") then
		local _pair_data = pairdata.get(_entity)
		if surfaces.is_below_nauvis(_entity.surface) then
			if _pair_data.domain == const.surface.type.sky.id then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), "(s) may not be placed in underground surfaces, it has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		elseif surfaces.is_above_nauvis(_entity.surface) then
			if _pair_data.domain == const.surface.type.underground.id then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), " may not be placed in sky surfaces, it has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		else
			if _pair_data.nauvis ~= true then
				if _player_index and api.game.player(_player_index) then
					util.message(_player_index, {"", api.localised_name(_entity), " may not be placed on the nauvis surface, it has been dropped on the ground."})
				end
				table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
				api.destroy(_entity)
			end
		end
		if _entity then
			return _pair_data.destination
		end
	else
		if _player_index and api.game.player(_player_index) then
			util.message(_player_index, {"", api.localised_name(_entity), " may not be placed on this surface, it has been dropped on the ground."})
		end
		table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
		api.destroy(_entity)
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_surface(_entity, _pair_location)
	if api.valid(_entity) and (_pair_location and const.surface.rel_loc_valid[_pair_location]) then
		if _pair_location == const.surface.rel_loc.above then
			local _paired_surface = surfaces.get_surface_above(_entity)
			return (_paired_surface == nil) and surfaces.create_surface_above(_entity.surface) or _paired_surface
		else
			local _paired_surface = surfaces.get_surface_below(_entity)
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
			if _pair_data.class == pairclass.get("electric-pole") then
				api.entity.connect_neighbour(_entity, _paired_entity, const.wire.all)
			elseif _pair_data.class == pairclass.get("fluid-transport") then
				table.insert(global.fluid_transport, {a = _entity, b = _paired_entity})
			elseif _pair_data.class == pairclass.get("transport-chest") then
				table.insert(global.transport_chests, {input = _entity, output = _paired_entity, tier = _pair_data.custom.tier, modifier = _pair_data.modifier})
			elseif _pair_data.class == pairclass.get("rail-transport") then
				api.entity.set_direction(_paired_entity, api.entity.direction(_entity))
			end
		else
			if _player_index and api.game.player(_player_index) then
				util.message(_player_index, {"", api.localised_name(_entity), " could not be paired successfully, it has been dropped on the ground."})
			end
			table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.spill_entity_result, {_entity, api.entity.minable_result(_entity)}))
			api.destroy(_entity)
		end
	end
end

-- Internal function, called from events.on_preplayer_mined_item(event) and events.on_robot_pre_mined(event)
function pairutil.destroy_paired_entity(_entity)
	local _paired_entity = pairutil.find_paired_entity(_entity)
	local _pair_data = pairdata.get(_entity) or pairdata.reverse(_entity)
	table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.remove_sky_tile, {_entity, _paired_entity, _pair_data.radius}))
	api.destroy(_paired_entity)
end

-- Used to clear the ground around a position for placement of a paired entity, also used to clear ground around unit spawners and other things during chunk generation event
function pairutil.clear_ground(_position, _surface, _radius, _tile_name, _ignore_walls)
	if struct.is_Position(_position) and api.valid(_surface) then
		if surfaces.is_from_this_mod(_surface) then
			_radius = (type(_radius) == "number" and _radius >= 0) and _radius or 0
			local _area = struct.BoundingBox(_position.x - _radius, _position.y - _radius, _position.x + _radius, _position.y + _radius)
			local _is_underground = surfaces.is_below_nauvis(_surface)
			local _tiles, _old_tiles = {}, {}
			if _is_underground == true and _ignore_walls ~= true then
				for k, v in pairs(api.surface.find_entities(_surface, _area, en_und_wall, et_und_wall)) do
					api.destroy(v)
				end
			end
			for k, v in pairs(struct.Positions(_area)) do
				local _current_tile = api.surface.get_tile(_surface, v)
				local _current_tile_name = api.name(_current_tile)
				if _is_underground == true then
					table.insert(_old_tiles, {name = ((override_tiles[_current_tile_name]) and tn_und_dirt or _current_tile_name), position = v})
					table.insert(_tiles, {name = tn_und_dirt, position = v})
				else
					_tile_name = _tile_name or tn_wood_floor
					table.insert(_old_tiles, {name = ((skytiles.get(_current_tile_name)) and _current_tile_name or _tile_name), position = v})
					table.insert(_tiles, {name = _tile_name, position = v})
				end
			end
			api.surface.set_tiles(_surface, _tiles)
			api.surface.set_tiles(_surface, _old_tiles)
		end
	end
end

-- Used to remove tiles underneath paired entities when they are placed in the sky. Respects when users place down concrete and stone brick above paired entity tiles, ensuring that players do not lose tiles. Needs to be improved significantly or will be deprecated in the near future.
function pairutil.remove_tiles(_position, _surface, _radius)
	if struct.is_Position(_position) and api.valid(_surface) then
		if surfaces.is_from_this_mod(_surface) and surfaces.is_above_nauvis(_surface) then
			_radius = _radius or 0
			local _area = struct.BoundingBox(_position.x - _radius, _position.y - _radius, _position.x + _radius, _position.y + _radius)
			local _safe_area = struct.BoundingBox(_area.left_top.x - 1, _area.left_top.y - 1, _area.right_bottom.x + 1, _area.right_bottom.y + 1)
			local _old_tiles, _new_tiles, _entities = {}, {}, {}
			for k, v in pairs(struct.Positions(_area)) do
				local tile_prototype = api.name(api.surface.get_tile(_surface, v))
				table.insert(_old_tiles, {name = ((skytiles.get(tile_prototype) == nil) and tile_prototype or tn_sky_void), position = v})
				table.insert(_new_tiles, {name = tn_sky_void, position = v})
			end
			for k, v in pairs(api.surface.find_entities(_surface, _safe_area, "player", "player")) do
				if v.player ~= nil then
					surfaces.transport_player(v.player, surfaces.get_surface_below(v.surface), v.position)
				end
			end
			api.surface.set_tiles(_surface, _new_tiles)
			api.surface.set_tiles(_surface, _old_tiles)
		end
	end
end

return pairutil