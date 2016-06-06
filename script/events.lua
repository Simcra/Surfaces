--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")
require("script.lib.pair-data")
require("script.lib.surfaces")
require("script.lib.pair-util")
require("script.lib.util")

events = {}
function events.on_tick(event)
	if util.game_tick()%config.ticks_between_event["update_players_using_access_shafts"]==0 then
		events.update_players_using_access_shafts(event)
	end
	if util.game_tick()%config.ticks_between_event["check_player_collision_with_access_shafts"]==0 then
		events.check_player_collision_with_access_shafts(event)
	end
	if util.game_tick()%config.ticks_between_event["update_transport_chest_contents"]==0 then
		events.update_transport_chest_contents(event)
	end
	if util.game_tick()%config.ticks_between_event["update_fluid_transport_contents"]==0 then
		events.update_fluid_transport_contents(event)
	end
	if util.game_tick()%config.ticks_between_event["execute_first_task_in_waiting_queue"]==0 then
		events.execute_first_task_in_waiting_queue(event)
	end
end

function events.on_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, {task = config.task_triggercreatepair, data = {entity = event.created_entity}})
	end
end

function events.on_robot_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, {task = config.task_triggercreatepair, data = {entity = event.created_entity}})
	end
end

function events.on_chunk_generated(event)
	if surfaces.is_from_this_mod(event.surface) then
		surfaces.chunk_generator_corrections(event.surface, event.area)
	end
end

function events.on_preplayer_mined_item(event)
	if pairdata.get(event.entity) ~= nil then
		pairutil.destroy_paired_entity(event.entity)
	end
end

function events.on_robot_pre_mined(event)
	if pairdata.get(event.entity) ~= nil then
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

function events.on_train_changed_state(event)
	--if front carriage is nearby a intersurface train stop and train state is stopped
	--if event.train.state == defines.trainstate.wait_station
end

function events.update_players_using_access_shafts(event)
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	for name, data in pairs(global.players_using_access_shafts) do
		local player = data.player_entity
		if player.walking_state.walking or not(data.destination_access_shaft) then
			global.players_using_access_shafts[name]=nil
		else
			if data.time_waiting >= config.teleportation_time_waiting then
				if data.destination_access_shaft and data.destination_access_shaft.valid then
					surfaces.transport_player_to_access_shaft(player, data.destination_access_shaft)
				end
				global.players_using_access_shafts[name] = nil
			end
			data.time_waiting = data.time_waiting + config.ticks_between_event["update_players_using_access_shafts"]
		end
	end
end

function events.check_player_collision_with_access_shafts(event)
	for index, player in ipairs(game.players) do
		if not(player.walking_state.walking) and (global.players_using_access_shafts == nil or global.players_using_access_shafts[player.name] == nil) then
			local access_shaft = surfaces.find_nearby_access_shaft(player, config.teleportation_check_range, player.surface)
			if access_shaft and access_shaft.valid then
				local paired_access_shaft = pairutil.find_paired_entity(access_shaft)
				if paired_access_shaft and paired_access_shaft.valid then
					global.players_using_access_shafts = global.players_using_access_shafts or {}
					global.players_using_access_shafts[player.name] = {time_waiting = 0, player_entity = player, destination_access_shaft = paired_access_shaft}
				else
					--create access shaft, maybe?
				end
			end
		end
	end
end

function events.update_transport_chest_contents(event)
	global.transport_chests = global.transport_chests or {}
	for k, v in pairs(global.transport_chests) do
		if not(v.input and v.input.valid) or not(v.output and v.output.valid) then
			if v.input and v.input.valid then v.input.destroy() end
			if v.output and v.output.valid then v.output.destroy() end
			table.remove(global.transport_chests, k)
		else
			local input = v.input.get_inventory(defines.inventory.chest)
			local output = v.output.get_inventory(defines.inventory.chest)
			for key, value in pairs(input.get_contents()) do
				local itemstack = {name = key, count = value}
				if output.can_insert(itemstack) then
					local remove_itemstack = {name = key, count = output.insert(itemstack)}
					input.remove(remove_itemstack)
				end
			end
		end
	end
end

function events.update_fluid_transport_contents(event)
	global.fluid_transport = global.fluid_transport or {}
	for k, v in pairs(global.fluid_transport) do
		if not(v.a and v.a.valid) or not(v.b and v.b.valid) then
			if v.a and v.a.valid then v.a.destroy() end
			if v.b and v.b.valid then v.b.destroy() end
			table.remove(global.fluid_transport, k)
		else
			local fluidbox_a, fluidbox_b = v.a.fluidbox[1], v.b.fluidbox[1]
			if not(fluidbox_a == nil and fluidbox_b == nil) then
				if fluidbox_a == nil then
					fluidbox_b.amount = fluidbox_b.amount/2
					v.a.fluidbox[1] = fluidbox_b
					v.b.fluidbox[1] = fluidbox_b
				elseif fluidbox_b == nil then
					fluidbox_a.amount = fluidbox_a.amount/2
					v.a.fluidbox[1] = fluidbox_a
					v.b.fluidbox[1] = fluidbox_a
				elseif fluidbox_a.type == fluidbox_b.type then
					local fluidbox_new = fluidbox_a
					fluidbox_new.amount = (fluidbox_new.amount + fluidbox_b.amount)/2
					v.a.fluidbox[1] = fluidbox_new
					v.b.fluidbox[1] = fluidbox_new
				end
			end
		end
	end
end

function events.execute_first_task_in_waiting_queue(event)
	global.task_queue = global.task_queue or {}
	for k, v in ipairs(global.task_queue) do
		if v.task == config.task_triggercreatepair then
			local destination_surface = pairutil.validate_paired_entity(v.data.entity)
			if destination_surface then
				table.insert(global.task_queue, {task = config.task_triggercreatesurface, data = {entity = v.data.entity, pair_location = destination_surface}})
			end
		elseif v.task == config.task_triggercreatesurface then
			local surface = pairutil.create_paired_surface(v.data.entity, v.data.pair_location)
			if surface == nil then
				table.insert(global.task_queue, v)
			elseif surface ~= false then
				util.request_generate_chunks(surface, v.data.entity.position, 0)
				table.insert(global.task_queue, {task = config.task_createpair, data = {entity = v.data.entity, paired_surface = surface}})
			end
		elseif v.task == config.task_createpair then
			local pair = pairutil.create_paired_entity(v.data.entity, v.data.paired_surface)
			if pair == nil or pair == false then
				table.insert(global.task_queue, v)
			else
				table.insert(global.task_queue, {task = config.task_finishpair, data = {entity = v.data.entity, paired_entity = pair})
			end
		elseif v.task == config.task_finishpair then
			pairutil.finalize_paired_entity(v.data.entity, v.data.paired_entity)
		end
		table.remove(global.task_queue, k)
		break
	end
end
