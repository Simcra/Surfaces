--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.proto")
require("script.lib.api")
require("script.lib.util")

pairdata, pairclass, skytiles = {}, {}, {}

local paired_entity_data, paired_entity_data_reverse = {}, {}
local paired_entity_classes, paired_entity_classes_reverse = {}, {}
local sky_tile_whitelist = {}
local next_pairclass_id = 0
local pause_index = false
local index_data, index_classes

--[[
Paired entity data
]]
function pairdata.get(_id)		-- inputs may be actual entities or their just their name, api.name(entity) is cool like that
	local _name = api.name(_id)
	if paired_entity_data[_name] then
		return table.deepcopy(paired_entity_data[_name])
	end
end

function pairdata.insert(_entity_name, _pair_name, _pair_location, _pair_class, _allowed_on_nauvis, _custom_data, _ground_clear_radius, _valid_surface_type, _sky_tile)
	if type(_entity_name) == "string" and type(_pair_name) == "string" and type(_pair_location) == "number" and table.reverse(const.surface.rel_loc)[_pair_location] and type(_pair_class) == "number" and paired_entity_classes_reverse[_pair_class] and paired_entity_data[_entity_name] == nil then
		local _pairdata = {}
		_pairdata.name = _pair_name
		_pairdata.destination = _pair_location
		_pairdata.class = _pair_class
		_pairdata.domain = _valid_surface_type and (table.reverse(const.surface.type, false, "id")[_valid_surface_type] and _valid_surface_type or const.surface.type.all.id) or const.surface.type.all.id
		_pairdata.nauvis = _allowed_on_nauvis and (_allowed_on_nauvis == true or _allowed_on_nauvis == "true") or false
		_pairdata.radius = (type(_ground_clear_radius) == "number" and _ground_clear_radius >= 0) and _ground_clear_radius or 1
		_pairdata.tile = (type(_sky_tile) == "string") and _sky_tile or proto.get_field({"tile", "floor", "wood"}, "name")
		_pairdata.custom = _custom_data or {}
		if _sky_tile then
			skytiles.insert(_sky_tile)
		end
		if _pair_class == pairclass.get("transport-chest") and (_custom_data == nil or _custom_data.tier == nil or table.reverse(const.tier)[_custom_data.tier] == nil) then
			_pairdata.custom.tier = const.tier.crude
		end
		if _pair_class == pairclass.get("transport-chest") and (_custom_data == nil or _custom_data.size == nil) then
			_pairdata.custom.size = 1
		end
		paired_entity_data[_entity_name] = _pairdata
		index_data()
	end
end

function pairdata.reverse(_id) -- gets the paired entity data from the reverse pair
	local _name = api.name(_id)
	if _name and paired_entity_data_reverse[_name] and paired_entity_data[paired_entity_data_reverse[_name]] then
		return table.deepcopy(paired_entity_data[paired_entity_data_reverse[_name]])
	end
end

function pairdata.insert_array(_array)
	for k, v in pairs(_array) do
		pause_index = true
		pairdata.insert(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
	end
	index_data()
end

--[[
Paired entity classes
]]
function pairclass.get(_name)																		-- returns the unique ID of the pair class if it exists, or otherwise nil
	return (type(_name) == "string" and paired_entity_classes[_name]) and table.deepcopy(paired_entity_classes[_name]) or nil
end

function pairclass.insert(_name)
	if type(_name) == "string" and paired_entity_classes[_name] == nil then							-- if the pair class is not already defined
		next_pairclass_id = next_pairclass_id + 1													-- increment pairclass ID
		paired_entity_classes[_name] = next_pairclass_id										-- insert our new pair class, giving it an ID
		index_classes()
	end
end

function pairclass.insert_array(_classes)															-- _classes is a table of strings, for example: {"access-shaft", "electric-pole"}
	for k, v in pairs(_classes) do
		pause_index = true
		pairclass.insert(v)																			-- each pair class will be inserted and assigned a unique identifier
	end
	index_classes()
end

function pairclass.reverse(_id) 																	-- gets the string index of the pair class from the pair class ID
	if type(_id) == "number" and paired_entity_classes_reverse[_id] and paired_entity_classes[paired_entity_classes_reverse[_id]] then
		return table.deepcopy(paired_entity_classes[paired_entity_classes_reverse[_id]])
	end
end

--[[
Sky tile whitelist
]]
function skytiles.get(_name)																		-- returns true if the tile prototype is in the whitelist, or otherwise nil
	return _name and sky_tile_whitelist[api.name(_name)]
end

function skytiles.insert(_name)
	if type(_name) == "string" and skytiles.get(_name) == nil then									-- if the tile prototype is not already in the whitelist
		sky_tile_whitelist[_name] = true															-- insert the tile prototype
	end
end

function skytiles.insert_array(_array)																-- _array is a table of strings of valid game tile prototypes, for example: {"concrete", "stone-path"}
	for k, v in pairs(_array) do
		skytiles.insert(v)																			-- each tile name will be insterted sequentually
	end
end

--[[
Indexing functions
]]
index_data = function()
	if pause_index == false then
		paired_entity_data_reverse = table.reverse(paired_entity_data, true, "name")
	else
		pause_index = false
	end
end

index_classes = function()
	if pause_index == false then
		paired_entity_classes_reverse = table.reverse(paired_entity_classes, true)
	else
		pause_index = false
	end
end