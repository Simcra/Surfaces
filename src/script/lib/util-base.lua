--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

function math.round(number, decimal_places)
	decimal_places = decimal_places or 0
	local multiplier = 10^decimal_places
	return math.floor(number * multiplier + 0.5) / multiplier
end

--[[
returns a copy of a table

@param _table [Required] - The table to copy
@param _recursive [Optional] - a boolean value, should we recursively copy each table inside this table?
@return table
]]
function table.copy(_table, _recursive)
	local _result
	if type(_table) == "table" then
		_result = {}
		for k, v in pairs(_table) do
			_result[k] = _recursive and table.copy(v, _recursive) or v
		end
	else
		return _table
	end
	return _result
end

--[[
merges two tables and returns the result

@param _table [Required] - The first table
@param _new_table [Optional] - The second table, values in this table will overwrite values in the first table if they exist in both places
@return table
]]
function table.merge(_table, _new_table)
	if type(_table) == "table" and type(_new_table) == "table" then
		local _result = table.copy(_table, true)
		for k, v in pairs(_new_table) do
			local _new_data = v
			if type(_result[k]) == "table" and type(v) == "table" then
				_new_data = table.merge(_result[k], v)
			end
			_result[k] = _new_data
		end
		return _result
	end
end

--[[
Used mostly for debugging tables, however, may potentially have other uses.
Returns a string representation of the table, traversing recursively, see example below:

Given that:
	t = {parameterA = 2, parameterB = {innerParameterA = "A", innerParameterB = "B"}, parameterC = "42"},
	string_a = table.tostring(t, false),
	string_b = table.tostring(t, true)
The following is true:
	string_a == "{parameterA=2,parameterB={innerParameterA=A,innerParameterB=B},parameterC=42}",
	string_b == "{parameterA = 2, parameterB = {innerParameterA = A, innerParameterB = B}, parameterC = 42}"
]]
function table.tostring(t, add_spacing)
	local result = "{"
	local equalstring = "="
	local commastring = ","
	if add_spacing then
		equalstring = " = "
		commastring = ", "
	end
	for k, v in pairs(t) do
		if type(v) == "table" then
			result = result .. tostring(k) .. equalstring .. table.tostring(v, add_spacing) .. commastring
		elseif type(v) == "string" then
			result = result .. tostring(k) .. equalstring .. v .. commastring
		else
			result = result .. tostring(k) .. equalstring .. tostring(v) .. commastring
		end
	end
	if string.len(result) > 1 then
		result = string.sub(result, 1, string.len(result) - 2)		-- remove the last comma
	end
	return result .. "}"
end

--[[
Intended to be used to verify the existance of a value in a table.
Creates a table indexed by the values from the provided table where new values are set to true, see usage example below:

Given that:
	t = {"1", "12", {data = "34"}, "62"}, rt = table.reverse(t), rt_2 = table.reverse(t, true), rt_3 = table.reverse(t, true, "data")
The following is true:
	rt["12"] == true, rt["34"] == nil,
	rt_2["12"] == 2, rt_2["34"] == nil,
	rt_3["12"] == nil, rt_3["34"] == 3
]] 
function table.reverse(t, store_old_index, subtable_index)
	local rTable = {}
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