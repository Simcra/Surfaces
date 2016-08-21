--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.lib.api")
require("script.lib.struct")
require("script.lib.surfaces")
require("script.lib.util")
require("script.taskmgr")

--[[--
Contains all event manager functions.

@module eventmgr
]]
eventmgr = {}

local tasks = const.taskmgr.task
local handles = const.eventmgr.handle
local func, func_pause = {}, {}
local event_uid, event_uid_valid

function eventmgr.exec(_event)
	for k, v in pairs(handles) do
		if _event.tick % v.tick == 0 then
			if func_pause[tostring(v.func)] then
				func_pause[tostring(v.func)] = nil
			else
				func[tostring(v.func)](_event)
			end
		end
	end
end

function eventmgr.raise_event(_id, _data, _delay)
	global.raise_events = global.raise_events or {}
	event_uid = event_uid or global.event_uid
	event_uid_valid = event_uid_valid or table.reverse(event_uid)
	if event_uid_valid[_id] then
		table.insert(global.raise_events, {id = _id, data = _data, exec = (api.game.tick() + _delay)})
	end
end

-- This function updates the contents of each transport and receiver chest in the map, providing that they are both valid and if they are not, they will be destroyed
function func.transport_item_process(_event)
	global.item_transport = global.item_transport or {}
	for k, v in pairs(global.item_transport) do
		if not(api.valid({v.input, v.output})) then
			api.destroy({v.input, v.output})
			global.item_transport[k] = nil
		else
			local _max_items = config.item_transport.base_count * config.item_transport.multiplier[const.tier_valid[v.tier]]
			if v.modifier then
				_max_items = _max_items * v.modifier
			end
			local _input = api.entity.get_inventory(v.input, defines.inventory.chest)
			local _output = api.entity.get_inventory(v.output, defines.inventory.chest)
			for _key, _value in pairs(api.inventory.get_contents(_input)) do
				local _amount = _value > _max_items and _max_items or _value
				local _itemstack = struct.SimpleItemStack(_key, _amount)
				if api.inventory.can_insert(_output, _itemstack) then
					local _remove = struct.SimpleItemStack(_key, api.inventory.insert(_output, _itemstack))
					api.inventory.remove(_input, _remove)
				end
				break
			end
		end
	end
end

-- This function updates the contents of each intersurface fluid tank in the map, providing that they are both valid and if they are not, they will be destroyed
function func.transport_fluid_process(_event)
	global.fluid_transport = global.fluid_transport or {}
	for k, v in pairs(global.fluid_transport) do
		if not(api.valid({v.a, v.b})) then
			api.destroy({v.a, v.b})
			global.fluid_transport[k] = nil
		else
			local fluidbox_a, fluidbox_b = api.entity.fluidbox(v.a), api.entity.fluidbox(v.b)
			if fluidbox_a ~= nil or fluidbox_b ~= nil then
				if fluidbox_a == nil then
					fluidbox_b.amount = fluidbox_b.amount/2
					api.entity.set_fluidbox({v.a, v.b}, fluidbox_b)
				elseif fluidbox_b == nil then
					fluidbox_a.amount = fluidbox_a.amount/2
					api.entity.set_fluidbox({v.a, v.b}, fluidbox_a)
				elseif fluidbox_a.type == fluidbox_b.type then
					local fluidbox_new = fluidbox_a
					fluidbox_new.amount = (fluidbox_a.amount + fluidbox_b.amount)/2
					api.entity.set_fluidbox({v.a, v.b}, fluidbox_new)
				end
			end
		end
	end
end

-- This function updates the contents of each intersurface accumulator in the map, providing that they are both valid and if they are not, they will be destroyed
function func.transport_energy_process(_event)
	global.energy_transport = global.energy_transport or {}
	for k, v in pairs(global.energy_transport) do
		if not(api.valid({v.a, v.b})) then
			api.destroy({v.a, v.b})
			global.energy_transport[k] = nil
		else
			local energy_a, energy_b = api.entity.energy(v.a), api.entity.energy(v.b)
			if energy_a ~= nil or energy_b ~= nil then
				if energy_a == nil then
					api.entity.set_energy({v.a, v.b}, energy_b/2)
				elseif energy_b == nil then
					api.entity.set_energy({v.a, v.b}, energy_a/2)
				else
					api.entity.set_energy({v.a, v.b}, (energy_a + energy_b)/2)
				end
			end
		end
	end
end

function func.raise_events(_event)
	global.raise_events = global.raise_events or {}
	for k, v in pairs(global.raise_events) do
		if _event.tick >= v.exec then
			api.game.raise_event(v.id, v.data)
			global.raise_events[k] = nil
		end
	end
end

-- Execute the first task in the process queue, taskmgr is used to avoid annoying desync errors in multiplayer.
function func.taskmgr_execute(_event)
	taskmgr.exec()
end

function func.surfaces_migrations(_event)
	global.migrate_surfaces = global.migrate_surfaces or {}
	for k, v in pairs(global.migrate_surfaces) do
		if type(v) == "table" then
			if v.migrated then
				if v.player then
					api.entity.teleport(v.player.entity, v.player.origin, v.player.surface) -- move the player back to his position prior to surface migrations
				end
				api.game.delete_surface(v.surface) -- first, we created the universe, and now, we must destroy it with fire!
				util.broadcast("Migration complete: " .. api.name(v.new_surface))
				global.migrate_surfaces[api.name(v.new_surface)] = nil
				global.migrate_surfaces[k] = nil -- remove this entry, we are done here.
			elseif not(v.migrating) then
				global.migrate_surfaces[k].migrating = true -- lock process chain to this worker to prevent this from being completed multiple times
				-- declaring local variables
				local _surface, _new_surface = v.surface, v.new_surface
				local _is_underground, _is_platform = v.underground, v.platform
				local _chunks_generated = true
				-- first loop, check that all chunks are generated prior to processing.
				for _chunk in api.surface.get_chunks(_surface) do
					if not(api.surface.is_chunk_generated(_new_surface, _chunk, true)) then
						if v.player then
							global.migrate_surfaces[k].player.next = struct.Position((_chunk.x * 32) + 15, (_chunk.y * 32) + 15)
						end
						api.surface.request_generate_chunks(_new_surface, _chunk)
						_chunks_generated = false
					end
				end
				-- chunks were not generated, we need to move a player since surfaces won't generate without at least one player being present
				if _chunks_generated ~= true then
					if v.player then surfaces.transport_player(v.player.entity, _new_surface, v.player.next, 15, 1)
					else
						local _player_one = api.game.player(1)
						if api.valid(_player_one) then
							local _old_surface = _player_one.character.surface
							-- We are going to delete the old surface, let's not kill the player in the process :)
							if _old_surface == _surface then
								_old_surface = _new_surface
							end
							local _old_position = table.deepcopy(_player_one.character.position)
							global.migrate_surfaces[k].player = {entity = _player_one, surface = _old_surface, origin = _old_position, next = struct.Position(0,0)}
						end
						util.broadcast("Migrating surface: " .. api.name(_surface)) -- Let's alert all players that we are migrating
						-- and alert player 1 that he should go AFK
						util.message(1, "You will be teleported around the new surface for chunk generation purposes. Please be patient and do not force close Factorio, this has been known to take up to 30 minutes on large maps.") 
					end
					global.migrate_surfaces[k].migrating = nil -- we are finished processing for now, remove the lock.
					return -- wait for next loop, giving the surface a chance to generate.
				end			
				
				-- Now we can actually do some processing, hooray.
				local _tile_name = _is_underground and tn_und_dirt or (_is_platform and tn_sky_void)
				for _chunk in api.surface.get_chunks(_surface) do
					local _cx, _cy, _cur_x, _cur_y = _chunk.x * 32, _chunk.y * 32
					local _old_tiles, _tiles = {}, {}
					for _y = 0, 31, 1 do
						_cur_y = _cy + _y
						for _x = 0, 31, 1 do
							_cur_x = _cx + _x
							local _cur_pos = struct.Position(_cur_x, _cur_y)
							local _cur_tile = api.surface.get_tile(_surface, _cur_pos)
							local _cur_tile_name = api.name(_cur_tile)
							table.insert(_old_tiles, {name = _tile_name, position = _cur_pos})
							table.insert(_tiles, {name = _cur_tile_name, position = _cur_pos})
						end
					end
					for k, v in pairs(api.surface.find_entities(_new_surface, struct.BoundingBox(_cx, _cy, _cx + 32, _cy + 32), "player", "player")) do
						surfaces.transport_player(v.player, api.game.surface("nauvis"), struct.Position(0, 0), 1024, 1)
					end
					for k, v in pairs(api.surface.find_entities(_new_surface, struct.BoundingBox(_cx, _cy, _cx + 32, _cy + 32), et_und_wall, en_und_wall)) do
						api.destroy(v)
					end
					api.surface.set_tiles(_new_surface, _old_tiles)
					api.surface.set_tiles(_new_surface, _tiles)
				end
				
				-- iterate over all of the entities in the old surface, copying them one by one to the new surface
				for k, v in pairs(api.surface.find_entities(_surface)) do
					if api.type(v) ~= "player" then
						api.surface.create_entity(_new_surface, {name = api.name(v), position = api.position(v), direction = api.entity.direction(v),
							force = api.entity.force(v)})
					else
						api.entity.teleport(v.player, api.position(v), _new_surface)
					end
				end
				global.migrate_surfaces[k].migrated = true -- we are done, wait for next cycle and finish up
			end
			return -- only process one surface at a time.
		end
	end
end

return eventmgr