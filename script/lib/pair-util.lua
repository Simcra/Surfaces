--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")
require("script.lib.pair-data")
require("script.lib.surfaces")
require("script.lib.util")

pairutil={}
function pairutil.find_paired_entity(entity)
	local pair_data = pairdata.get(entity)
	if pair_data then
		if pair_data.destination == config.surface_location_above then
			return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_above(entity.surface), pair_data.name, util.entity_prototypes()[pair_data.name].type)
		elseif pair_data.destination == config.surface_location_below then
			return surfaces.find_nearby_entity(entity, 0.5, surfaces.get_surface_below(entity.surface), pair_data.name, util.entity_prototypes()[pair_data.name].type)
		end
	end
	return nil
end

function pairutil.validate_paired_entity(entity)
	local pair_data = pairdata.get(entity)
	if entity.surface.name == "nauvis" or surfaces.is_from_this_mod(entity.surface) then
		if surfaces.is_underground(entity.surface) then
			if pair_data.domain == config.surface_type_sky then 
				entity.destroy()
			end
		elseif surfaces.is_above_nauvis(entity.surface) then
			if pair_data.domain == config.surface_type_underground then
				entity.destroy()
			end
		else
			if pair_data.nauvis ~= true then
				entity.destroy()
			end
		end
	else
		entity.destroy()
	end
	return pair_data.destination
end

function pairutil.create_paired_surface(entity, pair_location)
	local paired_surface
	if entity and entity.valid then
		if pair_location == config.surface_location_above then
			paired_surface = surfaces.get_surface_above(entity)
			if not(paired_surface and paired_surface.valid) then
				return surfaces.create_surface_above(entity.surface)
			end
		elseif pair_location == config.surface_location_below then
			paired_surface = surfaces.get_surface_below(entity)
			if not(paired_surface and paired_surface.valid) then
				return surfaces.create_surface_below(entity.surface)
			end
		end
	else
		return false
	end
	return paired_surface
end

function pairutil.create_paired_entity(entity, paired_surface)
	local pair_data = pairdata.get(entity)
	local paired_entity = nil
	if paired_surface and paired_surface.valid then
		surfaces.clear_floor_around_location(entity.position, paired_surface, pair_data.radius)
		paired_entity = util.create_entity(paired_surface,{name = pair_data.name, position = entity.position, force = entity.force})
		if not(paired_entity) or not(paired_entity.valid) then
			return false
		end
		return paired_entity
	else
		return false
	end
end

function pairutil.finalize_paired_entity(entity, paired_entity)
	local pair_data = pairdata.get(entity)
	paired_entity = paired_entity or pairutil.find_paired_entity(entity)
	if pair_data.class == config.pairclass_electric_pole then
		entity.connect_neighbour(paired_entity)
		entity.connect_neighbour{wire = defines.circuitconnector.red, target_entity = paired_entity}
		entity.connect_neighbour{wire = defines.circuitconnector.green, target_entity = paired_entity}
	elseif pair_data.class == config.pairclass_fluid_transport then
		global.fluid_transport = global.fluid_transport or {}
		table.insert(global.fluid_transport, {a = entity, b = paired_entity})
	elseif pair_data.class == config.pairclass_transport_chest then
		global.transport_chests = global.transport_chests or {}
		table.insert(global.transport_chests, {input = entity, output = paired_entity})
	end
end

function pairutil.destroy_paired_entity(entity)
	local paired_entity = pairutil.find_paired_entity(entity)
	if paired_entity then
		paired_entity.destroy()
	end
end
