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

events = {}
local eventmgr = {}
local addon_data, loaded_addon_data = nil, false

function events.set_addon_data(data)
	if addon_data == nil and type(data) == "table" then
		addon_data = data
	end
end

-- This function is called every game tick, it's primary purpose is to act as a timer for each of the handles in the event manager
function events.on_tick(event)
	if loaded_addon_data == false then
		loaded_addon_data = true
		compat.update_all()
		for k, v in pairs(addon_data) do
			if compat.active(k) == true then
				pairdata.insert_array(v)
			end
		end
	end
	for k, v in pairs(const.eventmgr.handle) do
		if event.tick % v.tick == 0 then
			eventmgr[tostring(v.func)](event)
		end
	end
end

-- This function is called whenever an entity is built by the player
function events.on_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil or pairdata.reverse(event.created_entity) ~= nil then
		table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.trigger_create_paired_entity, {event.created_entity, event.player_index}))
	end
end

-- This function is called whenever an entity is built by a construction robot
function events.on_robot_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil or pairdata.reverse(event.created_entity) ~= nil then
		table.insert(global.task_queue, struct.TaskSpecification(const.eventmgr.task.trigger_create_paired_entity, {event.created_entity}))
	end
end

-- This function is called whenever a chunk is generated
function events.on_chunk_generated(event)
	if surfaces.is_from_this_mod(event.surface) then
		surfaces.chunk_generator_corrections(event.surface, event.area)
	end
end

-- This function is called just before an entity is deconstructed by the player
function events.on_preplayer_mined_item(event)
	if pairdata.get(event.entity) ~= nil or pairdata.reverse(event.entity) ~= nil then
		pairutil.destroy_paired_entity(event.entity)
	end
end

-- This function is called just before an entity is deconstructed by a construction robot
function events.on_robot_pre_mined(event)
	if pairdata.get(event.entity) ~= nil or pairdata.reverse(event.entity) ~= nil then
		pairutil.destroy_paired_entity(event.entity)
	end
end

function events.on_player_mined_item(event)

end

function events.on_robot_mined(event)

end

function events.on_marked_for_deconstruction(event)
	
end

function events.on_canceled_deconstruction(event)

end

function events.on_player_driving_changed_state(event)
	
end

function events.on_put_item(event)

end

function events.on_player_rotated_entity(event)

end

function events.on_trigger_created_entity(event)

end

function events.on_picked_up_item(event)

end

function events.on_sector_scanned(event)
	
end

function events.on_entity_died(event)

end

-- This function is called whenever a train changes state from moving to stopping or stopping to stopped, etc.
function events.on_train_changed_state(event)
	--temporarily commented out until surface teleport can be used on non-player entities
	--[[
	if api.train.state(event.train) == defines.trainstate.wait_station then
		local front_rail = event.train.front_rail
		if front_rail ~= nil then
			local locomotive = surfaces.find_nearby_entity(front_rail, 2, front_rail.surface, nil, "locomotive")
			local cargo_wagon = surfaces.find_nearby_entity(front_rail, 2, front_rail.surface, nil, "cargo-wagon")
			local valid_carriage = (api.valid(locomotive) and locomotive or (api.valid(cargo_wagon) and cargo_wagon or nil))
			if valid_carriage ~= nil then
				local train_stop = surfaces.find_nearby_entity(valid_carriage, 4, front_rail.surface, nil, "train-stop")
				if pairdata.get(train_stop) ~= nil then
					local pair = pairutil.find_paired_entity(train_stop)
					for k, v in pairs(event.train.carriages) do
						api.entity.teleport(v, v.position, pair.surface)
					end
				end
			end
		end
	end
	--]]
end

-- This function looks at the global table containing players who are using an access shaft and teleports them to the destination access shaft if one exists
function eventmgr.update_players_using_access_shafts(event)
	for name, data in pairs(global.players_using_access_shafts) do
		if data.entity.walking_state.walking == true or data.destination == nil then
			global.players_using_access_shafts[name] = nil
		else
			if data.time_waiting >= config.teleportation_time_waiting then
				if api.valid(data.destination) then
					surfaces.transport_player_to_access_shaft(data.entity, data.destination)
				end
				global.players_using_access_shafts[name] = nil
			end
			data.time_waiting = data.time_waiting + const.eventmgr.handle.access_shaft_teleportation.tick
		end
	end
end

-- This function checks whether any players are near an access shaft and adds them to the global table for players using access shafts if they are within range of one and not moving
function eventmgr.check_player_collision_with_access_shafts(event)
	for _, player in pairs(api.game.players()) do
		if not(player.walking_state.walking) and global.players_using_access_shafts[player.name] == nil then
			local access_shaft = surfaces.find_nearby_access_shaft(player, config.teleportation_check_range, player.surface)
			if api.valid(access_shaft) then
				local paired_access_shaft = pairutil.find_paired_entity(access_shaft)
				if api.valid(paired_access_shaft) then
					global.players_using_access_shafts[player.name] = {time_waiting = 0, entity = player, destination = paired_access_shaft}
				end
			end
		end
	end
end

-- This function updates the contents of each transport and receiver chest in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_transport_chest_contents(event)
	for k, v in pairs(global.transport_chests) do
		if not(api.valid({v.input, v.output})) then
			api.destroy({v.input, v.output})
			global.transport_chests[k] = nil
		else
			local max_items = config.item_transport.base_count * config.item_transport.multiplier[table.reverse(const.tier, true)[v.tier]]
			if v.size then
				max_items = max_items * v.size
			end
			local input = api.entity.get_inventory(v.input, defines.inventory.chest)
			local output = api.entity.get_inventory(v.output, defines.inventory.chest)
			for key, value in pairs(api.inventory.get_contents(input)) do
				local amount = value > max_items and max_items or value
				local itemstack = struct.ItemStack(key, amount)
				if api.inventory.can_insert(output, itemstack) then
					local remove_itemstack = struct.ItemStack(key, api.inventory.insert(output, itemstack))
					api.inventory.remove(input, remove_itemstack)
				end
				break
			end
		end
	end
end

-- This function updates the contents of each intersurface fluid tank in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_fluid_transport_contents(event)
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
function eventmgr.execute_first_task_in_waiting_queue(event)
	local tasks = const.eventmgr.task
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
					if struct.is_ItemStack(value) then
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