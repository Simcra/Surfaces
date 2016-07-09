--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.lib.struct-base")
require("script.lib.util-base")

-- Declaring local functions and variables
local TilePositions
local MapGenFrequency = {valid = table.reverse({"none", "very-low", "normal", "high", "very-high"}), default = "normal"}
local MapGenSize = {valid = table.reverse({"none", "very-low", "normal", "high", "very-high"}), default = "normal"}
local MapGenRichness = {valid = table.reverse({"none", "very-low", "normal", "high", "very-high"}), default = "normal"}

--[[
Functions in the section below are intended to construct and return predefined structures from provided data, some designed to follow Factorio concepts
For more information on these concepts, see the LuaAPI (http://lua-api.factorio.com/0.13.3/Concepts.html)
]]
function struct.TilePositions(_boundingbox) -- Pass-through function for local TilePositions 
	return struct.is_BoundingBox(_boundingbox) and TilePositions(_boundingbox.left_top.x, _boundingbox.left_top.y, _boundingbox.right_bottom.x, _boundingbox.right_bottom.y) or (struct.is_Position(_boundingbox) and TilePositions(_boundingbox.x, _boundingbox.y, _boundingbox.x, _boundingbox.y) or nil)
end

TilePositions = function(_x1, _y1, _x2, _y2) -- Returns a table of positions inside the specified coordinates, mapped through from the bounding box
	local _result = {}
	for _y = _y1, _y2, 1 do										-- start from the top row going down
		for _x = _x1, _x2, 1 do									-- start from the left going right
			table.insert(_result, struct.Position(_x, _y))		-- insert the current position
		end
	end
	return _result
end

function struct.MapGenSettings_copy(_mapgensettings, _remove_autoplace, _random_seed, _water, _peaceful, _terrain, _autoplace, _seed, _width, _height)
	return struct.is_MapGenSettings(_mapgensettings) and struct.MapGenSettings(
		_terrain or _mapgensettings.terrain_segmentation,
		_water or _mapgensettings.water,
		(type(_remove_autoplace) == "boolean" and _remove_autoplace == true) and struct.AutoplaceControls_copy(_mapgensettings.autoplace_controls, nil, "none") or (_autoplace or _mapgensettings.autoplace_controls),
		(type(_random_seed) == "boolean" and _random_seed == true) and nil or (_seed or _mapgensettings.seed),
		_width or _mapgensettings.width,
		_height or _mapgensettings.height,
		_peaceful or (_mapgensettings.peaceful_mode)) or nil
end

function struct.AutoplaceControls_copy(_controls, _frequency, _size, _richness)
	if struct.is_AutoplaceControls(_controls) then
		local _result = {}
		for k, v in pairs(_controls) do
			_result[k] = struct.AutoplaceControl(
				struct.is_MapGenFrequency(_frequency) == true and _frequency or v.frequency,
				struct.is_MapGenSize(_size) == true and _size or v.size,
				struct.is_MapGenRichness(_richness) == true and _richness or v.richness)
		end
		return _result
	end
end

function struct.MapGenSettings(_terrain, _water, _autoplace_controls, _seed, _width, _height, _peaceful)
	return {
		terrain_segmentation = (struct.is_MapGenFrequency(_terrain) and _terrain ~= "none") and _terrain or MapGenFrequency.default,
		water = (struct.is_MapGenSize(_water)) and _water or MapGenSize.default,
		autoplace_controls = struct.is_AutoplaceControls(_autoplace_controls) and _autoplace_controls or {},
		seed = type(_seed) == "number" and math.round(_seed) or math.round(math.random() * const.max_int),
		width = type(_width) == "number" and math.round(_width) or 0,
		height = type(_height) == "number" and math.round(_height) or 0,
		peaceful_mode = type(_peaceful) == "boolean" and _peaceful or false
	}
end

function struct.AutoplaceControl(_frequency, _size, _richness)
	return {
		frequency = struct.is_MapGenFrequency(_frequency) and _frequency or MapGenFrequency.default,
		size = struct.is_MapGenSize(_size) and _size or MapGenSize.default,
		richness = struct.is_MapGenRichness(_richness) and _richness or MapGenRichness.default
	}
end

--[[
Functions in the section below are used to determine validity
]]

function struct.is_Tiles(_tiles)
	local _count = 0
	if _tiles ~= nil then
		for k, v in pairs(_tiles) do
			_count = _count + 1
			if type(v.name) ~= "string" or struct.is_Position(v.position) ~= true then
				return false
			end
		end
	end
	return (_count > 0)
end

function struct.is_Direction(_direction)
	return (_direction == defines.direction.north or 
		_direction == defines.direction.northeast or 
		_direction == defines.direction.east or 
		_direction == defines.direction.southeast or 
		_direction == defines.direction.south or
		_direction == defines.direction.southwest or
		_direction == defines.direction.west or
		_direction == defines.direction.northwest)
end

function struct.is_AutoplaceControls(_controls)
	for k, v in pairs(_controls) do
		if struct.is_AutoplaceControl(v) == false then
			return false
		end
	end
	return true
end

function struct.is_MapGenFrequency(_frequency)
	return (type(_frequency) == "string" and MapGenFrequency.valid[_frequency] ~= nil)
end

function struct.is_MapGenSize(_size)
	return (type(_size) == "string" and MapGenSize.valid[_size] ~= nil)
end

function struct.is_MapGenRichness(_richness)
	return (type(_richness) == "string" and MapGenRichness.valid[_richness] ~= nil)
end

function struct.is_MapGenSettings(_mapgensettings)
	return (_mapgensettings and _mapgensettings.terrain_segmentation and _mapgensettings.water and _mapgensettings.autoplace_controls and _mapgensettings.seed and _mapgensettings.width and _mapgensettings.height and _mapgensettings.peaceful_mode) and ((struct.is_MapGenFrequency(_mapgensettings.terrain_segmentation) and _mapgensettings.terrain_segmentation ~= "none") and struct.is_MapGenSize(_mapgensettings.water) and struct.is_AutoplaceControls(_mapgensettings.autoplace_controls) and type(_mapgensettings.seed) == "number" and type(_mapgensettings.width) == "number" and type(_mapgensettings.height) == "number" and type(_mapgensettings.peaceful_mode) == "boolean") or false
end

function struct.is_AutoplaceControl(_control)
	return (_control and struct.is_MapGenFrequency(_control.frequency) and struct.is_MapGenSize(_control.size) and struct.is_MapGenRichness(_control.richness))
end

--[[
Internal task queue structs
]]
function struct.TaskSpecification(_id, _data)
	local _taskdata = struct.TaskData(_id, _data)
	return _taskdata and {task = _id, data = _taskdata} or nil
end

function struct.TaskData(_id, _fields)
	if _fields and struct.is_TaskID(_id) then
		local _tasks = const.eventmgr.task
		if _id == _tasks.trigger_create_paired_entity then
			return api.valid({_fields[1]}) and {entity = _fields[1], player_index = _fields[2]} or nil
		elseif _id == _tasks.trigger_create_paired_surface then
			return (api.valid({_fields[1], _fields[2]}) and table.reverse(const.surface.rel_loc)[_fields[2]]) and {entity = _fields[1], pair_location = _fields[2], player_index = _fields[3]} or nil
		elseif _id == _tasks.create_paired_entity then
			return (api.valid({_fields[1], _fields[2]})) and {entity = _fields[1], paired_surface = _fields[2], player_index = _fields[3]} or nil
		elseif _id == _tasks.finalize_paired_entity then
			return (api.valid({_fields[1], _fields[2]})) and {entity = _fields[1], paired_entity = _fields[2], player_index = _fields[3]} or nil
		elseif _id == _tasks.remove_sky_tile then
			if api.valid({_fields[1], _fields[2]}) and type(_fields[3]) == "number" then
				local _entity = table.deepcopy(_fields[1])
				local _paired_entity = table.deepcopy(_fields[2])
				local _radius = table.deepcopy(_fields[3])
				return {
					entity = _entity,
					paired_entity = _paired_entity,
					position = _entity.position,
					surface = _entity.surface,
					paired_surface = _paired_entity and _paired_entity.surface or nil,
					radius = _radius}
			end
		elseif _id == _tasks.spill_entity_result then
			if api.valid(_fields[1]) and type(_fields[2]) == "table" then
				local _entity = table.deepcopy(_fields[1])
				local _products = table.deepcopy(_fields[2])
				return {
					entity = _entity,
					surface = _entity.surface,
					position = _entity.position,
					products = _products}
			end
		end
	end
end	

function struct.is_TaskID(_id)
	return (type(_id) == "number" and const.eventmgr.task_valid[_id] ~= nil)
end