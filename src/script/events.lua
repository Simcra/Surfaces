--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.lib.api")
require("script.lib.pair-util")
require("script.lib.pair-data")
require("script.lib.struct")
require("script.lib.surfaces")
require("script.lib.util")

--[[--
Contains all event manager functions and maps through to functions from other modules where necessary.

@module events
]]
events = {}

local eventmgr = {}
local addon_data, loaded_addon_data = nil, false
local pause_event = {}

-- declare local variables
local en_und_wall = proto.get_field({"entity", "underground_wall"}, "name")
local tn_und_wall = proto.get_field({"tile", "underground_wall"}, "name")
local tn_und_dirt = proto.get_field({"tile", "underground_dirt"}, "name")
local tn_sky_void = proto.get_field({"tile", "sky_void"}, "name")
local tasks = const.eventmgr.task
local handles = const.eventmgr.handle


function events.set_addon_data(_data)
	if addon_data == nil and type(_data) == "table" then
		addon_data = _data
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
		remote.call("Surfaces", "migrate", "_")
	end
	for k, v in pairs(handles) do
		if _event.tick % v.tick == 0 then
			if pause_event[tostring(v.func)] ~= false then
				pause_event[tostring(v.func)] = false
			else
				eventmgr[tostring(v.func)](_event)
			end
		end
	end
end

-- This function is called whenever an entity is built by the player
function events.on_built_entity(_event)
	if pairdata.exists(_event.created_entity) then
		table.insert(global.task_queue, struct.TaskSpecification(tasks.trigger_create_paired_entity, {_event.created_entity, _event.player_index}))
	end
end

-- This function is called whenever an entity is built by a construction robot
function events.on_robot_built_entity(_event)
	if pairdata.exists(_event.created_entity) then
		table.insert(global.task_queue, struct.TaskSpecification(tasks.trigger_create_paired_entity, {_event.created_entity}))
	end
end

-- This function is called whenever a chunk is generated
function events.on_chunk_generated(_event)
	if surfaces.is_from_this_mod(_event.surface) then
		local _surface, _area, _tiles = _event.surface, _event.area, {}
		local _is_underground = surfaces.is_below_nauvis(_surface.name)
		local _tile_name = ((_is_underground == true) and tn_und_wall or tn_sky_void)
		
		-- freeze daytime for this surface at midnight if it is an underground surface
		if _is_underground and global.mod_surfaces[_surface.name] == nil then
			_surface.daytime = 0.5
			_surface.freeze_daytime(true)
			global.mod_surfaces[_surface.name] = true
		end
		
		-- destroy entities which should not spawn on this surface, gathering information for clearing the ground prior to replacing tiles
		for k, v in pairs(api.surface.find_entities(_surface, _area)) do
			local _name, _type, _position = api.name(v), api.type(v), api.position(v)
			if pairdata.exists(_name) then -- if pair data exists for this entity
				local _pairdata = pairdata.get(_name) or pairdata.reverse(_name) -- gather pair data for this entity
				pairutil.clear_ground(_position, _surface, _pairdata.radius, _pairdata.custom.tile)
			elseif _is_underground ~= true then
				if _type ~= "player" then
					api.destroy(v)
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
		local _cur_x, _cur_y
		for _y = 0, 31, 1 do
			_cur_y = _area.left_top.y + _y
			for _x = 0, 31, 1 do
				_cur_x = _area.left_top.x + _x
				local _cur_tile = api.surface.get_tile(_surface, {x = _cur_x, y = _cur_y})
				if (_is_underground and (const.surface.override_tiles[_cur_tile.name] or _cur_tile.collides_with("ground-tile") ~= true)) or
					(_is_underground ~= true and skytiles.get(_cur_tile.name) == nil
				) then
					table.insert(_tiles, {name = _tile_name, position = {x = _cur_x, y = _cur_y}})
				end
			end
		end
		api.surface.set_tiles(_surface, _tiles) -- replace the normally generated tiles with underground walls or sky tiles
		
		-- create underground wall entities
		if _is_underground then
			for k, v in pairs(_tiles) do
				api.surface.create_entity(_surface, {name = en_und_wall, position = v.position, force = api.game.force("player")})
			end
		end
	end
end

-- This function is called just before an entity is deconstructed by the player
function events.on_preplayer_mined_item(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

-- This function is called just before an entity is deconstructed by a construction robot
function events.on_robot_pre_mined(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

function events.on_player_mined_item(_event)

end

function events.on_robot_mined(_event)

end

function events.on_marked_for_deconstruction(_event)
	
end

function events.on_canceled_deconstruction(_event)

end

function events.on_player_driving_changed_state(_event)
	
end

function events.on_put_item(_event)

end

function events.on_player_rotated_entity(_event)

end

function events.on_trigger_created_entity(_event)

end

function events.on_picked_up_item(_event)

end

function events.on_sector_scanned(_event)
	
end

function events.on_entity_died(_event)
	if api.name(_event.entity) == en_und_wall then
		pairutil.clear_ground(_event.entity.position, _event.entity.surface, 0, nil, true)
	elseif pairdata.exists(_event.entity) then
		pairutil.destroy_paired_entity(_event.entity)
	end
end

-- This function is called whenever a train changes state (from moving to stopping, or stopping to stopped, etc).
function events.on_train_changed_state(_event)
	--temporarily commented out until surface teleport can be used on non-player entities
	--[[
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
	--]]
end

-- This function looks at the global table containing players who are using an access shaft and teleports them to the destination access shaft if one exists
function eventmgr.update_players_using_access_shafts(_event)
	for k, v in pairs(global.players_using_access_shafts) do
		if v.entity.walking_state.walking == true or v.destination == nil then
			global.players_using_access_shafts[k] = nil
		else
			if v.time_waiting >= config.teleportation_time_waiting then
				if api.valid(v.destination) then
					surfaces.transport_player_to_entity(v.entity, v.destination)
				end
				global.players_using_access_shafts[k] = nil
			end
			v.time_waiting = v.time_waiting + handles.access_shaft_teleportation.tick
		end
	end
end

-- This function checks whether any players are near an access shaft and adds them to the global table for players using access shafts if they are within range of one and not moving
function eventmgr.check_player_collision_with_access_shafts(_event)
	for _, _player in pairs(api.game.players()) do
		if _player.walking_state.walking ~= true and global.players_using_access_shafts[_player.name] == nil then
			local _access_shaft = surfaces.find_nearby_access_shaft(_player, config.teleportation_check_range, _player.surface)
			if api.valid(_access_shaft) then
				local _paired_access_shaft = pairutil.find_paired_entity(_access_shaft)
				if api.valid(_paired_access_shaft) then
					global.players_using_access_shafts[_player.name] = {time_waiting = 0, entity = _player, destination = _paired_access_shaft}
				end
			end
		end
	end
end

-- This function updates the contents of each transport and receiver chest in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_transport_chest_contents(_event)
	for k, v in pairs(global.transport_chests) do
		if not(api.valid({v.input, v.output})) then
			api.destroy({v.input, v.output})
			global.transport_chests[k] = nil
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
					local remove_itemstack = struct.SimpleItemStack(_key, api.inventory.insert(_output, _itemstack))
					api.inventory.remove(_input, remove_itemstack)
				end
				break
			end
		end
	end
end

function eventmgr.surfaces_migrations(_event)
	for k, v in pairs(global.surfaces_to_migrate) do
		if v.migrated then
			if v.player then
				api.entity.teleport(v.player.entity, v.player.position, v.player.surface) -- move the player back to his position prior to surface migrations
			end
			api.game.delete_surface(v.surface) -- first, we created the universe, and now, we must destroy it with fire!
			global.surfaces_to_migrate[k] = nil -- remove this entry, we are done here.
		elseif not(v.migrating) then
			global.surfaces_to_migrate[k].migrating = true -- lock process chain to this worker to prevent this from being completed multiple times
			
			-- declaring local variables
			local _surface, _new_surface = v.surface, v.new_surface
			local _is_underground, _is_platform = v.underground, v.platform
			local _chunks_generated = true
			
			-- first loop, check that all chunks are generated prior to processing.
			for _chunk in api.surface.get_chunks(_surface) do
				if not(api.surface.is_chunk_generated(_new_surface, _chunk, true)) then
					_chunks_generated = false
				end
			end
			
			-- chunks were not generated, we need to move a player since surfaces won't generate without at least one player being present
			if _chunks_generated ~= true then
				local _player_one = api.game.player(1)
				if api.valid(_player_one) then
					local _old_surface = api.name(_player_one.character.surface)
					if _old_surface == api.name(_surface) then 
						_old_surface = api.name(_new_surface)	-- We are going to delete the old surface, let's not kill the player in the process :)
					end
					local _old_position = table.deepcopy(_player_one.character.position)
					global.surfaces_to_migrate[k].player = {entity = _player_one, surface = _old_surface, position = _old_position}
					surfaces.transport_player(_player_one, _new_surface, _struct.Position(0, 0), 128, 1)
				end
				v.migrating = nil -- we are finished processing for now, remove the lock.
				return -- wait for next loop, giving the surface a chance to generate.
			end			
			
			-- Now we can actually do some processing, hooray.
			for _chunk in api.surface.get_chunks(_surface) do
				local _cx, _cy, _cur_x, _cur_y = _chunk.x * 32, _chunk.y * 32
				local _old_tiles, _tiles = {}, {}
				for _y = 0, 31, 1 do
					_cur_y = _cy + _y
					for _x = 0, 31, 1 do
						_cur_x = _cx + _x
						local _cur_tile = api.surface.get_tile(_surface, {x = _cur_x, y = _cur_y})
						if (_is_underground) then
							table.insert(_old_tiles, {name = tn_und_dirt, position = {x = _cur_x, y = _cur_y}})
						elseif (_is_platform) then
							table.insert(_old_tiles, {name = tn_sky_void, position = {x = _cur_x, y = _cur_y}})
						end
						table.insert(_tiles, {name = api.name(_cur_tile), position = {x = _cur_x, y = _cur_y}})
					end
				end
				api.surface.set_tiles(_new_surface, _old_tiles)
				api.surface.set_tiles(_new_surface, _tiles)
			end
			
			-- iterate over all of the entities in the old surface, copying them one by one to the new surface
			for k, v in pairs(api.surface.find_entities(_surface)) do
				if api.type(v) ~= "player" then
					api.surface.create_entity(_new_surface, {
						name = api.name(v),
						position = api.position(v),
						direction = api.entity.direction(v),
						force = api.entity.force(v)
					})
				else
					api.entity.teleport(v.player, api.position(v), _new_surface)
				end
			end
			
			global.surfaces_to_migrate[k].migrated = true -- we are done, wait for next cycle and finish up
		end
		return -- only process one surface at a time, let's not kill the game just yet...
	end
end

-- This function updates the contents of each intersurface fluid tank in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_fluid_transport_contents(_event)
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

-- This function is used to avoid annoying desync errors when playing in multiplayer, it acts as a system to queue tasks such as creating entities and surfaces that need to happen on the same tick on all clients
function eventmgr.execute_first_task_in_waiting_queue(_event)
	for k, v in pairs(global.task_queue) do
		if v.task == tasks.trigger_create_paired_entity then										-- Validates the entity prior to creation of it's pair, gathering the relative location for the paired entity
			local destination_surface = pairutil.validate_paired_entity(v.data.entity, v.data.player_index)
			if destination_surface then
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.trigger_create_paired_surface,
					{v.data.entity, destination_surface, v.data.player_index}))						-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.trigger_create_paired_surface then									-- Validates the paired surface, creating it if it does not yet exist
			local surface = pairutil.create_paired_surface(v.data.entity, v.data.pair_location)
			if surface == nil then																	-- If the surface has not yet been created
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			elseif surface ~= false then															-- Ensures that data passed is valid and if not, the task is simply removed from the queue
				api.surface.request_generate_chunks(surface, v.data.entity.position, 0)				-- Fixes a small bug with chunk generation
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.create_paired_entity,
					{v.data.entity, surface, v.data.player_index}))									-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.create_paired_entity then											-- Creates the paired entity
			local pair = pairutil.create_paired_entity(v.data.entity, v.data.paired_surface)
			if pair == nil or pair == false then													-- If the pair fails to be created for some unknown reason
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			else																					-- Otherwise
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.finalize_paired_entity,
					{v.data.entity, pair, v.data.player_index}))									-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.finalize_paired_entity then											-- Performs final processing for the paired entity (example: intersurface electric poles are connected to one another)
			pairutil.finalize_paired_entity(v.data.entity, v.data.paired_entity, v.data.player_index)
		elseif v.task == tasks.remove_sky_tile then													-- Remove tiles created by paired entities in sky surfaces, called after destruction of paired entities
			if api.valid({v.data.entity, v.data.paired_entity}) == false then						-- Check if the two entities have been destroyed yet.
				pairutil.remove_tiles(v.data.position, v.data.surface, v.data.radius)				-- If they have, call remove tiles function with appropriate data for both.
				pairutil.remove_tiles(v.data.position, v.data.paired_surface, v.data.radius)
			else
				table.insert(global.task_queue, v)
			end
		elseif v.task == tasks.spill_entity_result then												-- Spill an itemstack on the ground, used to drop entity results on the ground where an invalid entity was placed
			if api.valid(v.data.entity) == false then
				for key, value in pairs(v.data.products) do
					if struct.is_SimpleItemStack(value) then
						api.surface.spill_items(v.data.surface, v.data.position, value)
					end
				end
			else
				table.insert(global.task_queue, v)
			end
		end
		table.remove(global.task_queue, k)															-- Remove the current task from the queue, it has finished executing
		break																						-- Exit loop, we have finished processing the first task in the queue
	end
end

return events