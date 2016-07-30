--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.api")
require("script.proto")
require("script.lib.util")

--- provides access to paired entity data
pairdata = {}

--- provides access to paired entity class data
pairclass = {}

--- provides access to sky tile whitelist data
skytiles = {}

--- paired entity data is encapsulated in a local variable to prevent external access without using <code>pairdata.get(_id)</code>
local paired_entity_data = {}
--- the lookup table for paired entity data is encapsulated in a local variable and updated after every pair data insert operation, used by <code>pairdata.reverse(_id)</code> function
local paired_entity_data_reverse = {}
--- paired entity class data is encapsulated in a local variable to prevent external access without using <code>pairclass.get(_id)</code>
local paired_entity_classes = {}
--- the lookup table for paired entity class data is encapsulated in a local variable and updated after every pair class insert operation, used by <code>pairclass.reverse(_id)</code> function
local paired_entity_classes_reverse = {}
--- sky tile whitelist is encapsulated in a local variable to prevent external access without using <code>skytiles.get(_id)</code>
local sky_tile_whitelist = {}
--- counter for pairclass IDs, used to determine the next "free" pairclass ID
local next_pairclass_id = 0
--- when set to true, causes the indexer to skip a cycle, will automatically be set to false afterwards
local pause_index = false

---	this function updates the lookup table for paired entity data
local function index_data()
	if pause_index == false then
		paired_entity_data_reverse = table.reverse(paired_entity_data, true, "name")
	else
		pause_index = false
	end
end

---	this function updates the lookup table for paired entity class data
local function index_classes()
	if pause_index == false then
		paired_entity_classes_reverse = table.reverse(paired_entity_classes, true)
	else
		pause_index = false
	end
end

--[[--
returns paired entity data for an entity or entity prototype

@param _id [Required] - an entity reference or prototype string.
]]
function pairdata.get(_id)
	local _name = api.name(_id)
	if paired_entity_data[_name] then
		return table.deepcopy(paired_entity_data[_name])
	end
end

--[[--
returns true if paired entity data exists for an entity or entity prototype

@param _id [Required] - an entity reference or prototype string.
]]
function pairdata.exists(_id)
	local _name = api.name(_id)
	return (paired_entity_data[_name] ~= nil or paired_entity_data_reverse[_name] ~= nil)
end

--[[--
inserts data into the paired entity data table providing that all the required fields are valid.

@param _entity_name [Required] - Name of the entity, must be a valid prototype name
@param _paired_entity_name [Required] - Name of the paired entity, must be a valid prototype name
@param _relative_location [Required] - ID of the surface to place the paired entity on, must be either <code>const.surface.rel_loc.above</code> or <code>const.surface.rel_loc.below</code>
@param _pair_class [Required] - ID of the pair class for this entity, must be valid and should be obtained using <code>pairclass.get(_id)</code> function.
@param _placeable_on_nauvis [Optional] - A boolean value. Can this paired entity be placed on the nauvis surface? defaults to false.
@param _custom_data [Optional] - A table of values. Transport chests use this field to store tier data which effects speed of item transportation.
@param _clear_tile_radius [Optional] - A number value. Will be used to determine the radius of tiles cleared around this entity upon placement, defaults to 0 and will only clear the tile directly underneath the entity's position.
@param _placeable_surface_type [Optional] - A single valid surface type. Any of the IDs from the <code>const.surface.type</code> definitions are valid, for example, <code>const.surface.type.underground.id</code>.
]]
function pairdata.insert(_entity_name, _paired_entity_name, _relative_location, _pair_class, _placeable_on_nauvis, _custom_data, _clear_tile_radius, _placeable_surface_type)
	if (type(_entity_name) == "string" and type(_paired_entity_name) == "string" and type(_relative_location) == "number"
		and const.surface.rel_loc_valid[_relative_location] and type(_pair_class) == "number"
		and paired_entity_classes_reverse[_pair_class] and paired_entity_data[_entity_name] == nil
		) then
		local _pairdata = {
			name = _paired_entity_name,
			destination = _relative_location,
			class = _pair_class,
			domain = (type(_placeable_surface_type) == "number" and const.surface.type_valid[_placeable_surface_type]) and _placeable_surface_type or const.surface.type.all.id,
			nauvis = (type(_placeable_on_nauvis) == "boolean") and _placeable_on_nauvis or false,
			radius = (type(_clear_tile_radius) == "number" and _clear_tile_radius >= 0) and _clear_tile_radius or 0,
			custom = (type(_custom_data) == "table") and _custom_data or {}
		}
		if _pairdata.custom.tile then
			skytiles.insert(_pairdata.custom.tile)
		end
		if _pair_class == pairclass.get("transport-chest") and (_custom_data == nil or _custom_data.tier == nil or const.tier_valid[_custom_data.tier] == nil) then
			_pairdata.custom.tier = const.tier.crude
		end
		paired_entity_data[_entity_name] = _pairdata
		index_data()
	end
end

--[[--
returns paired entity data for an entity or entity prototype from the paired entity rather than the regular entity

@param _id [Required] - an entity reference or prototype string.
]]
function pairdata.reverse(_id) -- gets the paired entity data from the reverse pair
	local _name = api.name(_id)
	if _name and paired_entity_data_reverse[_name] and paired_entity_data[paired_entity_data_reverse[_name]] then
		return table.deepcopy(paired_entity_data[paired_entity_data_reverse[_name]])
	end
end

--[[--
Passes a table of pairdata entries to the <code>pairdata.insert(_entity_name, _paired_entity_name, _relative_location, _pair_class, _placeable_on_nauvis, _custom_data, _clear_tile_radius, _placeable_surface_type)</code> function, indexing the table after completion as opposed to after each insert operation to reduce workload.
]]
function pairdata.insert_array(_array)
	for k, v in pairs(_array) do
		pause_index = true
		pairdata.insert(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
	end
	index_data()
end

--[[--
returns the ID of the specified paired entity class

@param _name [Required] - a valid class name
]]
function pairclass.get(_name)																		-- returns the unique ID of the pair class if it exists, or otherwise nil
	return (type(_name) == "string" and paired_entity_classes[_name]) and table.deepcopy(paired_entity_classes[_name]) or nil
end

--[[--
inserts a new paired entity class, assigning it a unique ID

@param _name [Required] - a string value, this will be used to reference the paired entity class in all future calls to <code>pairclass.get(_name)</code>
]]
function pairclass.insert(_name)
	if type(_name) == "string" and paired_entity_classes[_name] == nil then							-- if the pair class is not already defined
		next_pairclass_id = next_pairclass_id + 1													-- increment pairclass ID
		paired_entity_classes[_name] = next_pairclass_id										-- insert our new pair class, giving it an ID
		index_classes()
	end
end

--[[--
passes a table of pairclass entries to the <code>pairclass.insert(_name)</code> function, indexing the table after completion as opposed to after each insert operation to reduce workload.

@param _classes [Required] - a table of strings to be passed to <code>pairclass.insert(_name)</code>
]]
function pairclass.insert_array(_classes)															-- _classes is a table of strings, for example: {"access-shaft", "electric-pole"}
	for k, v in pairs(_classes) do
		pause_index = true
		pairclass.insert(v)																			-- each pair class will be inserted and assigned a unique identifier
end
index_classes()
end

--[[--
gets the string index of the pair class from a valid pair class ID

@param _id [Required] - an entity reference or prototype string.
]]
function pairclass.reverse(_id) 																	--
	if type(_id) == "number" and paired_entity_classes_reverse[_id] then
		return paired_entity_classes_reverse[_id]
end
end

--[[--
returns true if the tile prototype is in the whitelist, or otherwise nil

@param _name [Required] - a tile reference or prototype string.
]]
function skytiles.get(_name)																		--
	return _name and sky_tile_whitelist[api.name(_name)] or nil
end

--[[--
inserts a tile prototype into the sky tiles whitelist

@param _name [Required] - a tile prototype string.
]]
function skytiles.insert(_name)
	if type(_name) == "string" and skytiles.get(_name) == nil then									-- if the tile prototype is not already in the whitelist
		sky_tile_whitelist[_name] = true															-- insert the tile prototype
	end
end

--[[--
inserts a table of tile prototypes into the sky tiles whitelist

@param _array [Required] - a table of tile prototype strings, for example, <code>{"concrete", "stone-path"}</code>
]]
function skytiles.insert_array(_array)
	for k, v in pairs(_array) do
		skytiles.insert(v)																			-- each tile name will be insterted sequentually
	end
end
