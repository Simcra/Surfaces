--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util")
require("script.enum")

struct = {}

-- Declaring local functions
local TilePositions

-- Declaring local variables
local valid_MapGenFrequency = table.reverse({"none", "very-low", "normal", "high", "very-high"})
local valid_MapGenSize = table.reverse({"none", "very-small", "small", "medium", "big", "very-big"})
local valid_MapGenRichness = table.reverse({"very-poor", "poor", "regular", "good", "very-good"})

--[[
Functions in the section below are intended to construct and return predefined structures from provided data, some are defined by Factorio concepts
For more information on these concepts, see the LuaAPI (http://lua-api.factorio.com/0.12.35/Concepts.html)
]]
function struct.BoundingBox(x1, y1, x2, y2)
	return (x1 and y1 and x2 and y2) and {left_top = struct.Position(x1, y1), right_bottom = struct.Position(x2, y2)} or nil
end

function struct.Position(x, y)
	return (x and y) and {x = x, y = y} or nil
end

function struct.ItemStack(name, count, health)
	return name and {name = name, count = count or 1, health = health or 1} or nil
end

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

function struct.MapGenSettings_copy(mapgensettings, disable_autoplace_controls, random_seed, water, peaceful, terrain, autoplace, seed, shift, width, height)
	return struct.is_MapGenSettings(mapgensettings) and struct.MapGenSettings(
		terrain or mapgensettings.terrain_segmentation,
		water or mapgensettings.water,
		(type(disable_autoplace_controls) == "boolean" and disable_autoplace_controls == true) and struct.AutoplaceControls_copy(mapgensettings.autoplace_controls, nil, "none") or (autoplace or mapgensettings.autoplace_controls),
		(type(random_seed) == "boolean" and random_seed == true) and nil or (seed or mapgensettings.seed),
		struct.is_Position(shift) and shift or mapgensettings.shift,
		width or mapgensettings.width,
		height or mapgensettings.height,
		peaceful or (mapgensettings.peaceful_mode == "true")) or nil
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

function struct.MapGenSettings(terrain, water, autoplace_controls, seed, shift, width, height, peaceful)
	if seed == nil then
		math.randomseed(math.random(1, 4294967295))
	end
	return {
		terrain_segmentation = (struct.is_MapGenFrequency(terrain) and terrain ~= "none") and terrain or "normal",
		water = (struct.is_MapGenSize(water)) and water or "medium",
		autoplace_controls = struct.is_AutoplaceControls(autoplace_controls) and autoplace_controls or {},
		seed = type(seed) == "number" and math.round(seed) or math.round(math.random()*4294967295),
		shift = struct.is_Position(shift) and shift or struct.Position(0, 0),
		width = type(width) == "number" and math.round(width) or 0,
		height = type(height) == "number" and math.round(height) or 0,
		peaceful_mode = type(peaceful) == "boolean" and tostring(peaceful) or "false"}
end

function struct.is_MapGenSettings(mapgensettings)
	return (mapgensettings and mapgensettings.terrain_segmentation and mapgensettings.water and mapgensettings.autoplace_controls and mapgensettings.seed and mapgensettings.shift and mapgensettings.width and mapgensettings.height and mapgensettings.peaceful_mode) and ((struct.is_MapGenFrequency(mapgensettings.terrain_segmentation) and mapgensettings.terrain_segmentation ~= "none") and struct.is_MapGenSize(mapgensettings.water) and struct.is_AutoplaceControls(mapgensettings.autoplace_controls) and type(mapgensettings.seed) == "number" and struct.is_Position(mapgensettings.shift) and type(mapgensettings.width) == "number" and type(mapgensettings.height) == "number" and type(mapgensettings.peaceful_mode) == "string") or false
end

function struct.AutoplaceControl(frequency, size, richness)
	return {
		frequency = struct.is_MapGenFrequency(frequency) and frequency or "normal",
		size = struct.is_MapGenSize(size) and size or "medium",
		richness = struct.is_MapGenRichness(richness) and richness or "regular"}
end

--[[
Functions in the section below are used to determine if data structure is valid
]]
function struct.is_Position(position)
	return (position and type(position.x) == "number" and type(position.y) == "number")
end

function struct.is_BoundingBox(area)
	return (area and struct.is_Position(area.left_top) and struct.is_Position(area.right_bottom))
end

function struct.is_ItemStack(itemstack)
	return (itemstack and type(itemstack.name) == "string" and type(itemstack.count) == "number")
end

function struct.is_AutoplaceControl(control)
	return (control and struct.is_MapGenFrequency(control.frequency) and struct.is_MapGenSize(control.size) and struct.is_MapGenRichness(control.richness))
end

function struct.is_Tiles(tiles)
	local count = 0
	if tiles ~= nil then
		for k, v in pairs(tiles) do
			count = count + 1
			if type(v.name) ~= "string" or struct.is_Position(v.position) ~= true then
				return false
			end
		end
	end
	return (count > 0)
end

function struct.is_Direction(direction)
	return (direction == defines.direction.north or 
		direction == defines.direction.northeast or 
		direction == defines.direction.east or 
		direction == defines.direction.southeast or 
		direction == defines.direction.south or
		direction == defines.direction.southwest or
		direction == defines.direction.west or
		direction == defines.direction.northwest)
end

function struct.is_AutoplaceControls(controls)
	for k, v in pairs(controls) do
		if struct.is_AutoplaceControl(v) == false then
			return false
		end
	end
	return true
end

function struct.is_MapGenFrequency(frequency)
	return (type(frequency) == "string" and valid_MapGenFrequency[frequency] ~= nil)
end

function struct.is_MapGenSize(size)
	return (type(size) == "string" and valid_MapGenSize[size] ~= nil)
end

function struct.is_MapGenRichness(richness)
	return (type(richness) == "string" and valid_MapGenRichness[richness] ~= nil)
end

--[[
Internal task queue structures
]]
function struct.TaskSpecification(id, data)
	local new_data = struct.TaskData(id, data)
	return new_data and {task = id, data = new_data} or nil
end

function struct.TaskData(id, fields)
	if fields and struct.is_TaskID(id) then
		local tasks = enum.eventmgr.task
		if id == tasks.trigger_create_paired_entity then
			return api.valid(fields) and {entity = fields[1]} or nil
		elseif id == tasks.trigger_create_paired_surface then
			return (api.valid(fields[1]) and fields[2] and table.reverse(enum.surface.rel_loc)[fields[2]]) and {entity = fields[1], pair_location = fields[2]} or nil
		elseif id == tasks.create_paired_entity then
			return (api.valid(fields[1]) and api.valid(fields[2])) and {entity = fields[1], paired_surface = fields[2]} or nil
		elseif id == tasks.finalize_paired_entity then
			return (api.valid(fields[1]) and api.valid(fields[2])) and {entity = fields[1], paired_entity = fields[2]} or nil
		end
	end
end	

function struct.is_TaskID(id)
	return (type(id) == "number" and table.reverse(enum.eventmgr.task)[id] ~= nil)
end