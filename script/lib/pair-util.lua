--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")

local paired_entity_data = {}

function get_paired_entity_data(entity)
	return paired_entity_data[entity.name]
end

function insert_pair_entity_data(entity_name, pair_name, relative_destination, entity_pairclass, valid_domain, allowed_on_nauvis)
	local pairdata = {name=pair_name, destination=relative_destination, class=entity_pairclass, domain=valid_domain, nauvis=allowed_on_nauvis}
	paired_entity_data[entity_name] = pairdata
end

function update_entity_data(array_of_pairdata)
	for k,v in pairs(array_of_pairdata) do
		insert_pair_entity_data(v[1],v[2],v[3],v[4],v[5],v[6])
	end
end

function is_paired_entity(entity)
	return paired_entity_data[entity.name]~=nil
end