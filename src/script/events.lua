--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.eventmgr")
require("script.lib.api")
require("script.lib.pair-data")
require("script.lib.struct")
require("script.lib.surfaces")
require("script.lib.util")
require("script.pair-util")
local taskmgr = require("script.taskmgr-data")

--[[--
Contains all event manager functions and maps through to functions from other modules where necessary.

@module events
]]
events = {}

local addon_data, loaded_addon_data = nil, false

-- declare local variables
local en_und_wall = proto.entity.underground_wall.name
local et_und_wall = proto.entity.underground_wall.type
local tn_und_wall = proto.tile.underground_wall.name
local tn_und_dirt = proto.tile.underground_dirt.name
local tn_sky_void = proto.tile.sky_void.name
local tasks = const.taskmgr.task

function events.set_addon_data(_data)
	if type(_data) == "table" then
		addon_data = _data
		loaded_addon_data = false
	end
end

-- This function is called every game tick, it's primary purpose is to act as a timer for each of the handles in the event manager
function events.on_tick(_event)
	if loaded_addon_data == false then
		loaded_addon_data = true
		compat.update_all()
		for k, v in pairs(addon_data) do
			if compat.active(k) == true then
				pairdata.insert_array(v)
			end
		end
	end
	eventmgr.exec(_event)
end

-- This function is called whenever an entity is built by the player
function events.on_built_entity(_event)
	if pairdata.exists(_event.created_entity) then
		taskmgr.insert(tasks.trigger_create_paired_entity, {_event.created_entity, _event.player_index})
	end
end

-- This function is called whenever a chunk is generated
function events.on_chunk_generated(_event)
	if surfaces.is_mod_surface(_event.surface) then
		local _surface, _area, _tiles = _event.surface, _event.area, {}
		local _is_underground = surfaces.is_below_nauvis(_surface.name)
		local _tile_name = ((_is_underground == true) and tn_und_wall or tn_sky_void)
		
		global.frozen_surfaces = global.frozen_surfaces or {}
		-- freeze daytime for this surface at midnight if it is an underground surface
		if _is_underground and not(global.frozen_surfaces[_surface.name]) then
			_surface.daytime = 0.5
			_surface.freeze_daytime(true)
			global.frozen_surfaces[_surface.name] = true
		end
		
		local _data = {surface = _surface, area = _area, underground = _is_underground, tile = _tile_name}
		local _delay = (const.chunkgen.delay + math.round(const.chunkgen.rand * math.random()))
		eventmgr.raise_event(global.event_uid.post_chunk_generated, _data, _delay)
	end
end

function events.on_entity_died(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

function events.on_player_driving_changed_state(_event)
	local _player = api.game.player(_event.player_index)
	local _vehicle = _player.vehicle
	if _vehicle ~= nil then
		if pairdata.exists(_vehicle) then
			local _pairdata = pairdata.get(_vehicle)
			if _pairdata.class == pairclass.get("access-shaft") then
				local _paired_access_shaft = pairutil.find_paired_entity(_vehicle)
				if api.valid(_paired_access_shaft) then
					surfaces.transport_player_to_entity(_player, _paired_access_shaft)
				end
			end
		end
	end
end

function events.on_player_mined_tile(_event)
	local _surface = api.game.player(_event.player_index).surface
	if surfaces.is_mod_surface(_surface) then
		for k, v in pairs(_event.positions) do
			pairutil.fix_tiles(v, _surface)
		end
	end
end

-- This function is called just before an entity is deconstructed by the player
function events.on_preplayer_mined_item(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
		pairutil.fix_tiles(_event.entity.position, _event.entity.surface, 1)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

-- This function is called whenever an entity is built by a construction robot
function events.on_robot_built_entity(_event)
	if pairdata.exists(_event.created_entity) then
		taskmgr.insert(tasks.trigger_create_paired_entity, {_event.created_entity})
	end
end

function events.on_robot_mined_tile(_event)
	local _surface = _event.robot.surface
	if surfaces.is_mod_surface(_surface) then
		for k, v in pairs(_event.positions) do
			pairutil.fix_tiles(v, _surface)
		end
	end
end

-- This function is called just before an entity is deconstructed by a construction robot
function events.on_robot_pre_mined(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
		pairutil.fix_tiles(_event.entity.position, _event.entity.surface, 1)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

-- This function is called whenever a train changes state (from moving to stopping, or stopping to stopped, etc).
--[[temporarily commented out until surface teleport can be used on non-player entities
function events.on_train_changed_state(_event)
	if api.train.state(_event.train) == defines.trainstate.wait_station then
		local front_rail = _event.train.front_rail
		if front_rail ~= nil then
			local locomotive = surfaces.find_nearby_entity(front_rail, 2, front_rail.surface, nil, "locomotive")
			local cargo_wagon = surfaces.find_nearby_entity(front_rail, 2, front_rail.surface, nil, "cargo-wagon")
			local valid_carriage = (api.valid(locomotive) and locomotive or (api.valid(cargo_wagon) and cargo_wagon or nil))
			if valid_carriage ~= nil then
				local train_stop = surfaces.find_nearby_entity(valid_carriage, 4, front_rail.surface, nil, "train-stop")
				if pairdata.get(train_stop) ~= nil then
					local pair = pairutil.find_paired_entity(train_stop)
					for k, v in pairs(_event.train.carriages) do
						api.entity.teleport(v, v.position, pair.surface)
					end
				end
			end
		end
	end
end]]

function events.post_chunk_generated(_event)
	local _surface, _area, _is_underground, _tile_name, _tiles = _event.surface, _event.area, _event.underground, _event.tile, {}
	-- destroy entities which should not spawn on this surface, gathering information for clearing the ground prior to replacing tiles
	for k, v in pairs(api.surface.find_entities(_surface, _area)) do
		local _name, _type, _position = api.name(v), api.type(v), api.position(v)
		if pairdata.exists(_name) then -- if pair data exists for this entity
			local _pairdata = pairdata.get(_name) or pairdata.reverse(_name) -- gather pair data for this entity
			pairutil.clear_ground(_position, _surface, _pairdata.radius, _pairdata.custom.tile)
		elseif _is_underground ~= true then
			if _type ~= "player" then
				api.destroy(v)
			else
				if global.migrate_surfaces[api.name(_surface)] then
					pairutil.clear_ground(v.position, v.surface, 1)
				else
					surfaces.transport_player(v.player, api.game.surface("nauvis"), v.position, 128)
				end
			end
		elseif _type == "unit-spawner" then
			pairutil.clear_ground(_position, _surface, 11)
		elseif _type == "turret" then
			pairutil.clear_ground(_position, _surface, 10)
		elseif _type ~= "resource" and _type ~= "unit" and _name ~= en_und_wall and _type ~= "player" then
			api.destroy(v)
		end
	end
	
	-- iterate over tile positions in the chunk and gather data into one table so that the tiles may be replaced all at once.
	for _y = 0, 31, 1 do
		local _cur_y = _area.left_top.y + _y
		for _x = 0, 31, 1 do
			local _cur_x = _area.left_top.x + _x
			local _cur_pos = struct.Position(_cur_x, _cur_y)
			local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
			if not(surfaces.is_tile_placement_valid(_cur_tile,_surface)) then
				table.insert(_tiles, {name = _tile_name, position = _cur_pos})
			end
		end
	end
	api.surface.set_tiles(_surface, _tiles) -- replace the normally generated tiles with underground walls or sky tiles
	
	-- create underground wall entities
	if _is_underground then
		for k, v in pairs(_tiles) do
			local _count_resources = api.surface.count_entities(_surface, struct.BoundingBox_from_Position(v.position.x,v.position.y, 2), nil, "resource")
			local _count_walls = api.surface.count_entities(_surface, v.position, en_und_wall, et_und_wall)
			if _count_resources > 0 and _count_walls == 0 then
				api.surface.create_entity(_surface, {name = en_und_wall, position = v.position, force = api.game.force("neutral")})
			end
		end
	end
end

return events