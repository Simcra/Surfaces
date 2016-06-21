--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

util = {}

-- Why is this not already in the math library?! Silly Lua....
function math.round(number, decimal_places)
	decimal_places = decimal_places or 0
	local multiplier = 10^decimal_places
	return math.floor(number * multiplier + 0.5) / multiplier
end

function math.rerandomize(offset)
	offset = offset or 0
	math.randomseed(math.round(offset + (math.random() * enum.max_int)))
end

--[[
Useful mostly for debugging tables but may also have other uses.
Returns a string representation of the table, traversing recursively, see example below:

given that t = {parameterA = 2, parameterB = {innerParameterA = "A", innerParameterB = "B"}, parameterC = "42"}
if add_spacing is specified, the result will be "{parameterA=2, parameterB={innerParameterA=A, innerParameterB=B}, parameterC=42}"
Otherwise, "{parameterA = 2, parameterB = {innerParameterA = A, innerParameterB = B}, parameterC = 42}"
]]
function table.tostring(t, add_spacing)
	local result = "{"
	local equalstring = "="
	if add_spacing and (add_spacing == true or add_spacing == "true") then
		equalstring = " = "
	end
	for k, v in pairs(t) do
		if type(v) == "table" then
			result = result .. tostring(k) .. equalstring .. table.tostring(v, add_spacing) .. ", "
		elseif type(v) == "string" then
			result = result .. tostring(k) .. equalstring .. v .. ", "
		else
			result = result .. tostring(k) .. equalstring .. tostring(v) .. ", "
		end
	end
	if string.len(result) > 1 then
		result = string.sub(result, 1, string.len(result) - 2)
	end
	return result .. "}"
end

-- just a boring debug function to print text to every player's screen
function util.debug(text)
	for k, v in pairs(game.players) do
		util.message(k, text)
	end
end

-- prints text to a player's screen
function util.message(player_id, text)
	api.game.player(player_id).print(text)
end

-- transforms colour as RGB into factorio map colour format
function util.RGB(red, green, blue, alpha)
	red = red and (red > 255 and 255 or red) or 0
	green = green and (green > 255 and 255 or green) or 0
	blue = blue and (blue > 255 and 255 or blue) or 0
	alpha = alpha and (alpha > 100 and 100 or alpha) or 100
	return {r = (red / 255), g = (green / 255), b = (blue / 255), a = (alpha / 100)}
end
	

--[[
Intended to be used to verifying the existance of a value in a table.
Creates a table indexed by the values from the provided table where new values are set to true, see usage example below:

Given that:
t = {"1", "12", {data = "34"}, "62"}; rt = table.reverse(t); rt_2 = table.reverse(t, true); and rt_3 = table.reverse(t, true, "data")
The following is true:
rt["12"] == true; rt["62"] == true; rt["34"] == nil; rt_2["62"] == 4; rt_2["12"] == 2; and rt_3["34"] == 3;
]] 
function table.reverse(t, store_old_index, subtable_index)
	local rTable = {}
	store_old_index = (store_old_index and store_old_index == true)
	if subtable_index then
		for k, v in pairs(t) do
			if v[subtable_index] then
				rTable[v[subtable_index]] = store_old_index and k or true
			end
		end
	else
		for k, v in pairs(t) do
			rTable[v] = store_old_index and k or true
		end
	end
	return rTable
end

api = {}
-- Does this LuaObject exist and is it a valid reference to an object in the game engine?
function api.valid(objects)
	if objects ~= nil and type(objects) == "table" then
		if objects.valid == nil then
			for k, v in pairs(objects) do
				if api.valid(v) == false then
					return false
				end
			end
			return true
		else
			return objects.valid == true
		end
	end
end