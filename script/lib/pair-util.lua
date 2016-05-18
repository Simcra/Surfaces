--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")

local paired_entity_data = {}
paired_entity_data["sky-entrance"]={name="sky-exit", location=surface_location_above, class=surface_pairclass_access_shaft, realm=surface_type_sky, nauvis=true}
paired_entity_data["sky-exit"]={name="sky-entrance", location=surface_location_below, class=surface_pairclass_access_shaft, realm=surface_type_sky, nauvis=false}
paired_entity_data["underground-entrance"]={name="underground-exit", location=surface_location_below, class=surface_pairclass_access_shaft, realm=surface_type_underground, nauvis=true}
paired_entity_data["underground-exit"]={name="underground-entrance", location=surface_location_above, class=surface_pairclass_access_shaft, realm=surface_type_underground, nauvis=false}
paired_entity_data["transport-chest-up"]={name="receiver-chest-upper", location=surface_location_above, class=surface_pairclass_transport_chest, realm=surface_type_all, nauvis=true}
paired_entity_data["transport-chest-down"]={name="receiver-chest-lower", location=surface_location_below, class=surface_pairclass_transport_chest, realm=surface_type_all, nauvis=true}
paired_entity_data["receiver-chest-upper"]={name="transport-chest-up", location=surface_location_below, class=surface_pairclass_transport_chest, realm=surface_type_all, nauvis=true}
paired_entity_data["receiver-chest-lower"]={name="transport-chest-down", location=surface_location_above, class=surface_pairclass_transport_chest, realm=surface_type_all, nauvis=true}
	
function get_paired_entity_data(entity)
	return paired_entity_data[entity.name]
end

function is_paired_entity(entity)
	return paired_entity_data[entity.name]~=nil
end