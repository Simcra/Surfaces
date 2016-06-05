--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

util={}
function util.get_tiles_in_area(area)
	return util.get_tiles_in_bounding_box(area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

function util.get_tiles_in_bounding_box(x1,y1,x2,y2)
	local result = {}
	for pos_y=y1, y2, 1 do
		for pos_x=x1, x2, 1 do
			table.insert(result, {x=pos_x, y=pos_y})
		end
	end
	return result
end

--[[
Useful mostly for debugging as it traverses a table gathering all fields in a string format, see below example.

table = {parameterA = 2, parameterB = {innerParameterA = "A", innerParameterB = "B"}, parameterC = "42"}
table.tostring(table) will return "{parameterA=2, parameterB={innerParameterA=A, innerParameterB=B}, parameterC=42, }"
]]
function table.tostring(t)
	result = "{"
	for k, v in pairs(t) do
		if type(v)=="table" then
			result=result..tostring(k).."="..table.tostring(v)..", "
		elseif type(v)=="string" then
			result=result..tostring(k).."="..v..", "
		else
			result=result..tostring(k).."="..tostring(v)..", "
		end
	end
	if string.len(result) > 4 then
		result = string.sub(result, 1, string.len(result)-2)
	end
	return result.."}"
end


--[[
Useful for attempting to locate whether or not a value is in an array, see the below example

array = {"1","12","34","62"}
reverseArray(array)["12"] is equal to true
reverseArray(array)["4"] is equal to nil
]] 
function util.reverseTable(t)
	local rTable = {}
	for k, v in ipairs(t) do
		rTable[v] = true
	end
	return rTable
end

--[[
The below functions are referenced throughout this mod and serve as a single call to LuaAPI functions.
These functions allow mod-breaking changes in Factorio base to be quickly fixed.
]]

function util.get_player(identifier)
	return game.get_player(identifier) --pre 0.13
	--return game.players[identifier] --post 0.13
end

function util.get_surface(identifier)
	return game.get_surface(identifier) --pre 0.13
	--return game.surfaces[identifier] --post 0.13
end

function util.entity_prototypes()
	return game.entity_prototypes
end

function util.game_tick()
	return game.tick
end

function util.request_generate_chunks(surface, position, radius)
	if surface then
		surface.request_to_generate_chunks(position, radius)
	end
end

function util.create_entity(surface, entity_data)
	if entity_data and entity_data.name and entity_data.position then
		return surface.create_entity(entity_data)
	end
end

function util.create_surface(name, mapgensettings)
	return game.create_surface(name, mapgensettings)
end

function util.find_non_colliding_position(surface, prototype, center, radius, precision)
	return surface.find_non_colliding_position(prototype, center, radius, precision)
end