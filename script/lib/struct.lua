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
function struct.TilePositions(boundingbox) -- Pass-through function for local TilePositions 
	return struct.is_BoundingBox(boundingbox) and TilePositions(boundingbox.left_top.x, boundingbox.left_top.y, boundingbox.right_bottom.x, boundingbox.right_bottom.y) or (struct.is_Position(boundingbox) and TilePositions(boundingbox.x, boundingbox.y, boundingbox.x, boundingbox.y) or nil)
end

TilePositions = function(x1, y1, x2, y2) -- Returns a table of positions inside the specified coordinates
	local result = {}
	for pos_y = y1, y2, 1 do
		for pos_x = x1, x2, 1 do
			table.insert(result, struct.Position(pos_x, pos_y))
		end
	end
	return result
end

function struct.MapGenSettings_copy(mapgensettings, disable_autoplace_controls, random_seed, water, peaceful, terrain, autoplace, seed, width, height)
	return struct.is_MapGenSettings(mapgensettings) and struct.MapGenSettings(
		terrain or mapgensettings.terrain_segmentation,
		water or mapgensettings.water,
		(type(disable_autoplace_controls) == "boolean" and disable_autoplace_controls == true) and struct.AutoplaceControls_copy(mapgensettings.autoplace_controls, nil, "none") or (autoplace or mapgensettings.autoplace_controls),
		(type(random_seed) == "boolean" and random_seed == true) and nil or (seed or mapgensettings.seed),
		width or mapgensettings.width,
		height or mapgensettings.height,
		peaceful or (mapgensettings.peaceful_mode)) or nil
end

function struct.AutoplaceControls_copy(controls, frequency, size, richness)
	if struct.is_AutoplaceControls(controls) then
		local newcontrols = {}
		for k, v in pairs(controls) do
			newcontrols[k] = struct.AutoplaceControl(frequency or v.frequency, size or v.size, richness or v.richness)
		end
		return newcontrols
	end
end

function struct.MapGenSettings(terrain, water, autoplace_controls, seed, width, height, peaceful)
	return {
		terrain_segmentation = (struct.is_MapGenFrequency(terrain) and terrain ~= "none") and terrain or MapGenFrequency.default,
		water = (struct.is_MapGenSize(water)) and water or MapGenSize.default,
		autoplace_controls = struct.is_AutoplaceControls(autoplace_controls) and autoplace_controls or {},
		seed = type(seed) == "number" and math.round(seed) or math.round(math.random() * const.max_int),
		width = type(width) == "number" and math.round(width) or 0,
		height = type(height) == "number" and math.round(height) or 0,
		peaceful_mode = type(peaceful) == "boolean" and peaceful or false}
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
	local count = 0
	if _tiles ~= nil then
		for k, v in pairs(_tiles) do
			count = count + 1
			if type(v.name) ~= "string" or struct.is_Position(v.position) ~= true then
				return false
			end
		end
	end
	return (count > 0)
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
function struct.TaskSpecification(id, data)
	local new_data = struct.TaskData(id, data)
	return new_data and {task = id, data = new_data} or nil
end

function struct.TaskData(id, fields)
	if fields and struct.is_TaskID(id) then
		local tasks = const.eventmgr.task
		if id == tasks.trigger_create_paired_entity then
			return api.valid({fields[1]}) and {entity = fields[1], player_index = fields[2]} or nil
		elseif id == tasks.trigger_create_paired_surface then
			return (api.valid({fields[1], fields[2]}) and table.reverse(const.surface.rel_loc)[fields[2]]) and {entity = fields[1], pair_location = fields[2], player_index = fields[3]} or nil
		elseif id == tasks.create_paired_entity then
			return (api.valid({fields[1], fields[2]})) and {entity = fields[1], paired_surface = fields[2], player_index = fields[3]} or nil
		elseif id == tasks.finalize_paired_entity then
			return (api.valid({fields[1], fields[2]})) and {entity = fields[1], paired_entity = fields[2], player_index = fields[3]} or nil
		elseif id == tasks.remove_sky_tile then
			if api.valid({fields[1], fields[2]}) and type(fields[3]) == "number" then
				local entity = table.deepcopy(fields[1])
				local paired_entity = table.deepcopy(fields[2])
				local radius = table.deepcopy(fields[3])
				return {
					entity = entity,
					paired_entity = paired_entity,
					position = entity.position,
					surface = entity.surface,
					paired_surface = paired_entity and paired_entity.surface or nil,
					radius = radius}
			end
		elseif id == tasks.spill_entity_result then
			if api.valid(fields[1]) and type(fields[2]) == "table" then
				local entity = table.deepcopy(fields[1])
				local products = table.deepcopy(fields[2])
				return {
					entity = entity,
					surface = entity.surface,
					position = entity.position,
					products = products}
			end
		end
	end
end	

function struct.is_TaskID(id)
	return (type(id) == "number" and table.reverse(const.eventmgr.task)[id] ~= nil)
end