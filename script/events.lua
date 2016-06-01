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
	if game.tick%ticks_between_event["update_fluid_transport_contents"]==0 then
		update_fluid_transport_contents(event)
	end
	if game.tick%ticks_between_event["execute_first_task_in_waiting_queue"]==0 then
		execute_first_task_in_waiting_queue(event)
	end
	if game.tick%ticks_between_event["clear_ground_for_paired_entities"]==0 then
		clear_ground_for_paired_entities(event)
	end
end

function on_built_entity(event)
	if pairdata_get(event.created_entity)~=nil then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, {task=task_triggercreatepair, data={entity=event.created_entity}})
	end
end

function on_robot_built_entity(event)
	if pairdata_get(event.created_entity)~=nil then
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
	if pairdata_get(event.entity)~=nil then
		destroy_paired_entity(event.entity)
	end
end

function on_robot_pre_mined(event)
	if pairdata_get(event.entity)~=nil then
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
				if data.destination_access_shaft and data.destination_access_shaft.valid then
					transport_player_to_access_shaft(player, data.destination_access_shaft)
				end
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
				else
					--create access shaft
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

function update_fluid_transport_contents(event)
	global.fluid_transport = global.fluid_transport or {}
	for k, v in pairs(global.fluid_transport) do
		if not(v.a and v.a.valid) or not(v.b and v.b.valid) then
			if v.a and v.a.valid then v.a.destroy() end
			if v.b and v.b.valid then v.b.destroy() end
			table.remove(global.fluid_transport, k)
		else
			local fluidbox_a, fluidbox_b = v.a.fluidbox[1], v.b.fluidbox[1]
			if not(fluidbox_a==nil and fluidbox_b==nil) then
				if fluidbox_a==nil then
					fluidbox_b.amount = fluidbox_b.amount/2
					v.a.fluidbox[1]=fluidbox_b
					v.b.fluidbox[1]=fluidbox_b
				elseif fluidbox_b==nil then
					fluidbox_a.amount = fluidbox_a.amount/2
					v.a.fluidbox[1]=fluidbox_a
					v.b.fluidbox[1]=fluidbox_a
				elseif fluidbox_a.type==fluidbox_b.type then
					local fluidbox_new = fluidbox_a
					fluidbox_new.amount = (fluidbox_new.amount + fluidbox_b.amount)/2
					v.a.fluidbox[1] = fluidbox_new
					v.b.fluidbox[1] = fluidbox_new
				end
			end
		end
	end
end

function execute_first_task_in_waiting_queue(event)
	global.task_queue = global.task_queue or {}
	for k, v in ipairs(global.task_queue) do
		if v.task==task_triggercreatepair then
			local destination_surface = validate_paired_entity(v.data.entity)
			if destination_surface then
				table.insert(global.task_queue, {task=task_triggercreatesurface, data={entity=v.data.entity, pair_location=destination_surface}})
			end
		elseif v.task==task_triggercreatesurface then
			local surface = create_paired_surface(v.data.entity, v.data.pair_location)
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
				table.insert(global.task_queue, {task=task_finishpair,data=v.data})
			end
		elseif v.task==task_finishpair then
			finalize_paired_entity(v.data.entity, v.data.paired_entity)
		end
		table.remove(global.task_queue, k)
		break
	end
end

function clear_ground_for_paired_entities(event)
	global.paired_entities = global.paired_entities or {}
	global.paired_entities_position = global.paired_entities_position or 1
	local entities = global.paired_entities[global.paired_entities_position]
	if entities ~= nil then
		if entities.a and entities.b and entities.a.valid and entities.b.valid then
			clear_floor_around_entity(entities.a, pairdata_get(entities.a).radius or 1)
			clear_floor_around_entity(entities.b, pairdata_get(entities.b).radius or 1)
		end
		global.paired_entities_position = global.paired_entities_position+1
	else
		global.paired_entities_position=1
	end
end