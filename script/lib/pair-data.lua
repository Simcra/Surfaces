--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util")
require("script.enum")
require("script.lib.api-util")

pairdata = {}
pairclass = {}
skytiles = {}

local paired_entity_data = {}
local paired_entity_classes = {}
local sky_tile_whitelist = {}
local next_pairclass_id = 0

--[[
Paired entity data
]]
function pairdata.get(entity)
	return entity ~= nil and paired_entity_data[util.get_name(entity)]		-- inputs may be actual entities or their just their name, util.get_name(entity) is cool like that
end

function pairdata.insert(entity_name, pair_name, pair_location, entity_pairclass, valid_domain, allowed_on_nauvis, ground_clear_radius, create_tile, remove_tile_when_mined)
	if type(entity_name) == "string" and type(pair_name) == "string" then
		if type(pair_location) == "number" and table.reverse(enum.surface.rel_loc)[pair_location] then
			if type(entity_pairclass) == "number" and table.reverse(paired_entity_classes)[entity_pairclass] then
				if paired_entity_data[entity_name] == nil then
					paired_entity_data[entity_name] = {
						name = pair_name,
						destination = pair_location,
						class = entity_pairclass,
						domain = valid_domain and (table.reverse(enum.surface.type, false, "id")[valid_domain] and valid_domain or enum.surface.type.all.id) or enum.surface.type.all.id,
						nauvis = (type(allowed_on_nauvis) == "boolean") and allowed_on_nauvis or true,
						radius = (type(ground_clear_radius) == "number" and ground_clear_radius >= 0) and ground_clear_radius or 1,
						tile = (type(create_tile) == "string") and create_tile or nil}
				end
			end
		end
	end
end

function pairdata.reverse(paired_entity)
	if paired_entity ~= nil then
		local pair_data = table.reverse(paired_entity_data, true, "name")
		local pair_index = pair_data[util.get_name(paired_entity)]
		if pair_index ~= nil then
			return paired_entity_data[pair_index]
		end
	end
end

function pairdata.insert_array(array)
	for k,v in pairs(array) do
		pairdata.insert(v[1],v[2],v[3],v[4],v[5],v[6],v[7], v[8])
	end
end

--[[
Paired entity classes
]]
function pairclass.get(class_name)
	return type(class_name) == "string" and paired_entity_classes[class_name]					-- returns the unique ID of the pair class if it exists, or otherwise nil
end

function pairclass.insert(class_name)
	if pairclass.get(class_name) == nil then													-- if the pair class is not already defined
		next_pairclass_id = next_pairclass_id + 1
		paired_entity_classes[class_name] = next_pairclass_id									-- insert our new pair class, giving it a unique ID
	end
end

function pairclass.insert_array(pair_classes)													-- pair_classes is a table of strings, example: {"sm-access-shaft", "sm-electric-pole"}
	for k, v in pairs(pair_classes) do
		pairclass.insert(v)																		-- each pair class will be inserted and assigned a unique identifier
	end
end

--[[
Sky tile whitelist
]]
function skytiles.get(prototype)
	return type(prototype) == "string" and (sky_tile_whitelist[prototype]) ~= nil or false		-- returns true if the tile prototype is in the whitelist, or otherwise false
end

function skytiles.insert(prototype)
	if skytiles.get(prototype) == nil then														-- if the tile prototype is not already in the whitelist
		sky_tile_whitelist[prototype] = true													-- insert the tile prototype into the whitelist
	end
end

function skytiles.insert_array(prototypes)														-- prototypes is a table of strings of valid game tile prototypes, example: {"sky-floor", "underground-floor", "sky-concrete"}
	for k, v in pairs(prototypes) do
		skytiles.insert(v)																		-- each tile name will be insterted sequentually
	end
end