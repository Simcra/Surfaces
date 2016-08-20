--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

function math.round(_number, _decimal_places)
	_decimal_places = _decimal_places or 0 -- round to nearest integer if decimal places is not specified
	local _multiplier = 10^_decimal_places
	return math.floor(_number * _multiplier + 0.5) / _multiplier
end

--[[
returns a copy of a table

@param _table [Required] - The table to copy
@param _recursive [Optional] - a boolean value, should we recursively copy each table inside this table?
@return table
]]
function table.copy(_table)
	if type(_table) == "table" then
		local _result = {}
		for k, v in pairs(_table) do
			_result[k] = table.copy(v)
		end
		return _result
	else
		return _table
	end
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
function table.tostring(_table, _add_spacing)
	local _result = "{"
	local _equal, _comma = (_add_spacing and " = " or "="), (_add_spacing and " , " or ",")
	for k, v in pairs(_table) do
		_result = _result .. tostring(k) .. _equal .. (type(v) == "table" and table.tostring(v, _add_spacing) or (type(v) == "string" and v or tostring(v))) .. _comma
	end
	if string.len(_result) > 1 then
		_result = string.sub(_result, 1, string.len(_result) - 2)		-- removes the last comma
	end
	return _result .. "}"
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
function table.reverse(_table, _store_old_index, _index_field)
	local _result = {}
	for k, v in pairs(_table) do
		_result[((_index_field and v[_index_field]) and v[_index_field] or (not(_index_field) and v or nil))] = _store_old_index and k or true
	end
	return _result
end

function table.readonly(_table)
	if type(_table) == "table" then
		for k, v in pairs(_table) do
			if type(v) == "table" then
				_table[k] = table.readonly(v)
			end
		end
		local _proxy = {}
		local _meta = {__index = _table, __newindex = function(_table, _key, _value) return false end}
		setmetatable(_proxy, _meta)
		return _proxy
	else
		return _table
	end
end

local lua_pairs = pairs
function pairs(_table)
	local _metatable = getmetatable(_table)
	if _metatable and type(_metatable.__index) == "table" then
		return lua_pairs(_metatable.__index)  
	else
		return lua_pairs(_table)
	end
end