--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.pair-data")
require("script.lib.surfaces")
require("script.lib.struct")
require("script.lib.api-util")
require("script.lib.util")

pairutil = {}

-- Attempts to find the paired entity of the provided entity, returning the result
function pairutil.find_paired_entity(entity)
	if util.is_valid(entity) then
		local pair_data = pairdata.get(entity)
		if pair_data then
			if pair_data.destination == enum.surface.rel_loc.above then
				return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_above(entity.surface), pair_data.name, util.get_entity_prototypes()[pair_data.name].type)
			elseif pair_data.destination == enum.surface.rel_loc.below then
				return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_below(entity.surface), pair_data.name, util.get_entity_prototypes()[pair_data.name].type)
			end
		end
	end
end


-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.validate_paired_entity(entity)
	if util.is_valid(entity) and entity.surface and (util.get_name(entity.surface) == "nauvis" or surfaces.is_from_this_mod(entity.surface)) then
		local pair_data = pairdata.get(entity)
		if surfaces.is_below_nauvis(entity.surface) then
			if pair_data.domain == enum.surface.type.sky.id then 
				util.destroy(entity)
			end
		elseif surfaces.is_above_nauvis(entity.surface) then
			if pair_data.domain == enum.surface.type.underground.id then
				util.destroy(entity)
			end
		else
			if pair_data.nauvis ~= true then
				util.destroy(entity)
			end
		end
		if entity then
			return pair_data.destination
		end
	else
		util.destroy(entity)
	end
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_surface(entity, pair_location)
	if util.is_valid(entity) and (pair_location and table.reverse(enum.surface.rel_loc)[pair_location]) then
		if pair_location == enum.surface.rel_loc.above then
			local paired_surface = surfaces.get_surface_above(entity)
			if not(util.is_valid(paired_surface)) then
				return surfaces.create_surface_above(entity.surface)
			end
			return paired_surface	
		else
			local paired_surface = surfaces.get_surface_below(entity)
			if not(util.is_valid(paired_surface)) then
				return surfaces.create_surface_below(entity.surface)
			end
			return paired_surface
		end
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.create_paired_entity(entity, paired_surface)
	if util.is_valid(entity) and util.is_valid(paired_surface) and struct.is_Position(entity.position) then
		local pair_data = pairdata.get(entity)
		surfaces.clear_floor_around_location(entity.position, paired_surface, pair_data.radius)
		local paired_entity = util.create_entity(paired_surface, {name = pair_data.name, position = entity.position, force = entity.force})
		if util.is_valid(paired_entity) then
			return paired_entity
		else
			return false
		end
	else
		return false
	end
	return nil
end

-- Internal function, called from events.execute_first_task_in_waiting_queue(event)
function pairutil.finalize_paired_entity(entity, paired_entity)
	if util.is_valid(entity) then
		local pair_data = pairdata.get(entity)
		paired_entity = paired_entity or pairutil.find_paired_entity(entity)
		if paired_entity then
			if pair_data.class == pairclass.get("sm-electric-pole") then
				entity.connect_neighbour(paired_entity)
				entity.connect_neighbour{wire = defines.circuitconnector.red, target_entity = paired_entity}
				entity.connect_neighbour{wire = defines.circuitconnector.green, target_entity = paired_entity}
			elseif pair_data.class == pairclass.get("sm-fluid-transport") then
				global.fluid_transport = global.fluid_transport or {}
				table.insert(global.fluid_transport, {a = entity, b = paired_entity})
			elseif pair_data.class == pairclass.get("sm-transport-chest") then
				global.transport_chests = global.transport_chests or {}
				table.insert(global.transport_chests, {input = entity, output = paired_entity})
			end
		else
			util.destroy(entity)
		end
	end
end

-- Internal function, called from events.on_preplayer_mined_item(event) and events.on_robot_pre_mined(event)
function pairutil.destroy_paired_entity(entity)
	local paired_entity = pairutil.find_paired_entity(entity)
	util.destroy(paired_entity)
end
