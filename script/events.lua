--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")
require("script.lib.surfaces")

function on_tick(event)
	if game.tick%ticks_between_event["update_players_using_access_shafts"]==0 then
		update_players_using_access_shafts(event)
	end
	if game.tick%ticks_between_event["check_player_collision_with_access_shafts"]==0 then
		check_player_collision_with_access_shafts(event)
	end
	if game.tick%ticks_between_event["update_transport_chest_contents"]==0 then
		update_transport_chest_contents(event)
	end
	if game.tick%ticks_between_event["execute_first_task_in_waiting_queue"]==0 then
		execute_first_task_in_waiting_queue(event)
	end
end

function on_built_entity(event)
	if is_paired_entity(event.created_entity) then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, {task=task_triggercreatepair, data={entity=event.created_entity}})
	end
end

function on_robot_built_entity(event)
	if is_paired_entity(event.created_entity) then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, {task=task_triggercreatepair, data={entity=event.created_entity}})
	end
end

function on_chunk_generated(event)
	if is_surface_from_this_mod(event.surface) then
		surfaces_chunk_generated(event.surface, event.area)
	end
end

function on_preplayer_mined_item(event)
	if event.entity.name==surface_underground_wall_entity then
		underground_floor_fix(event.entity, event.entity.surface)
	elseif is_paired_entity(event.entity) then
		destroy_paired_entity(event.entity)
	end
end

function on_robot_pre_mined(event)
	if event.entity.name==surface_underground_wall_entity then
		underground_floor_fix(event.entity, event.entity.surface)
	elseif is_paired_entity(event.entity) then
		destroy_paired_entity(event.entity)
	end
end

function on_player_mined_item(event)

end

function on_robot_mined(event)

end

function on_marked_for_deconstruction(event)
	
end

function on_canceled_deconstruction(event)

end

function on_player_driving_changed_state(event)
	
end

function on_put_item(event)

end

function on_player_rotated_entity(event)

end

function on_trigger_created_entity(event)

end

function on_picked_up_item(event)

end

function on_sector_scanned(event)

end

function on_entity_died(event)

end

function on_train_changed_state(event)

end

function update_players_using_access_shafts(event)
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	for name, data in pairs(global.players_using_access_shafts) do
		local player = data.player_entity
		if player.walking_state.walking or not(data.destination_access_shaft) then
			global.players_using_access_shafts[name]=nil
		else
			if data.time_waiting >= teleportation_time_waiting then
				transport_player_to_access_shaft(player, data.destination_access_shaft)
				global.players_using_access_shafts[name]=nil
			end
			data.time_waiting = data.time_waiting + ticks_between_event["update_players_using_access_shafts"]
		end
	end
end

function check_player_collision_with_access_shafts(event)
	for index, player in ipairs(game.players) do
		if not(player.walking_state.walking) and (global.players_using_access_shafts==nil or global.players_using_access_shafts[player.name]==nil) then
			local access_shaft = find_nearby_access_shaft(player, teleportation_check_range, player.surface)
			if access_shaft then
				local paired_access_shaft = find_paired_entity(access_shaft)
				if paired_access_shaft then
					global.players_using_access_shafts = global.players_using_access_shafts or {}
					global.players_using_access_shafts[player.name] = {time_waiting = 0, player_entity = player, destination_access_shaft=paired_access_shaft}
				end
			end
		end
	end
end

function update_transport_chest_contents(event)
	global.transport_chests = global.transport_chests or {}
	for k, v in pairs(global.transport_chests) do
		if not(v.input and v.input.valid) or not(v.output and v.output.valid) then
			if v.input and v.input.valid then v.input.destroy() end
			if v.output and v.output.valid then v.output.destroy() end
			table.remove(global.transport_chests, k)
		else
			local input=v.input.get_inventory(defines.inventory.chest)
			local output=v.output.get_inventory(defines.inventory.chest)
			for key, value in pairs(input.get_contents()) do
				local itemstack={name=key, count=value}
				if output.can_insert(itemstack) then
					local remove_itemstack={name=key, count=output.insert(itemstack)}
					input.remove(remove_itemstack)
				end
			end
		end
	end
end

function execute_first_task_in_waiting_queue(event)
	global.task_queue = global.task_queue or {}
	for k, v in pairs(global.task_queue) do
		if v.task==task_triggercreatepair then
			trigger_create_paired_entity(v.data.entity)
		elseif v.task==task_triggercreatesurface then
			local surface = trigger_create_paired_surface(v.data.entity, v.data.pair_location)
			if surface==nil then
				table.insert(global.task_queue, v)
			elseif surface~=false then
				surface.request_to_generate_chunks(v.data.entity.position, 1)
				table.insert(global.task_queue, {task=task_createpair, data={entity=v.data.entity, paired_surface=surface}})
			end
		elseif v.task==task_createpair then
			local paired_entity = create_paired_entity(v.data.entity, v.data.paired_surface)
			if paired_entity==nil or paired_entity==false then
				table.insert(global.task_queue, v)
			else
				table.insert(global.task_queue, {task=task_finishpair,data={entity=v.data.entity, paired_entity=paired_entity}})
			end
		elseif v.task==task_finishpair then
			finalize_paired_entity(v.data.entity, v.data.paired_entity)
		end
		table.remove(global.task_queue, k)
		break
	end
end