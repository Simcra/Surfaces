--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.config")

pairdata = {}
local paired_entity_data = {}

function pairdata.get(entity)
	if entity and entity.valid and entity.name then
		return paired_entity_data[entity.name]
	else return nil end
end

function pairdata.insert(entity_name, pair_name, relative_destination, entity_pairclass, valid_domain, allowed_on_nauvis, ground_clear_radius)
	ground_clear_radius = ground_clear_radius or 1
	allowed_on_nauvis = allowed_on_nauvis or true
	valid_domain = valid_domain or config.surface_type_all
	local data = {name = pair_name, destination = relative_destination, class = entity_pairclass, domain = valid_domain, nauvis = allowed_on_nauvis, radius = ground_clear_radius}
	paired_entity_data[entity_name] = data
end

function pairdata.insert_array(array)
	for k,v in pairs(array) do
		pairdata.insert(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
	end
end