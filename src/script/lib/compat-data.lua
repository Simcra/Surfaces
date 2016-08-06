--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util-base")
require("script.lib.api")

--[[--
This module stores mod data and can be used to determine if a mod is installed.

@module compat
]]
compat = {}

--- mod data is encapsulated in a local variable to prevent external access without using <code>compat</code> functions
local moddata = {}

--[[--
Inserts mod data into the compat table during data loading phase

@param _data [Required] - a table of data, consisting of string indexes and boolean values. for example; {["warehousing"] = true}
]]
function compat.insert_data(_data) -- only works prior to a map being loaded or created (designed for use during data loading phases)
	if (game == nil) then
		for k, v in pairs(_data) do
			if type(k) == "string" and type(v) == "boolean" then
				compat.insert(k)
				moddata[string.lower(k)].active = v
			end
		end
	end
end

--[[--
Insert a blank entry in the mod data table for the mod specified

@param _name [Required] - the string name of a mod, found in the <code>info.json</code> file
@return <code>true</code> if _name was inserted or already exists, <code>false</code> otherwise.
]]
function compat.insert(_name)
	if (type(_name) == "string") then
		if (moddata[string.lower(_name)] == nil) then
			moddata[string.lower(_name)] = {}
		end
		return true
	end
	return false
end

--[[--
Inserts an entry for the mod specified gathering data from the active mods list if it exists

@param _name [Required] - the string name of a mod, found in the <code>info.json</code> file
]]
function compat.insert_and_update(_name)
	if compat.insert(_name) == true then
		compat.update(_name)
	end
end

--[[--
Inserts an entry for the mod specified gathering data from the active mods list if it exists

@param _name [Required] - the name of a mod, as found in <code>info.json</code>
]]
function compat.insert_array(_data)
	if type(_data) == "table" then
		for k, v in pairs(_data) do
			compat.insert(_data)
		end
	end
end

--[[--
updates data for the mod specified, assuming it exists and is present in the active mods list 

@param _name [Required] - the name of a mod, as found in <code>info.json</code>
]]
function compat.update(_name)
	if type(_name) == "string" then
		if moddata[string.lower(_name)] ~= nil then
			local _version = api.game.active_mod(_name)
			moddata[string.lower(_name)].active = (_version ~= nil)
			moddata[string.lower(_name)].version = _version or ""
		end
	end
end

--[[--
updates data for all active mods
]]
function compat.update_all()
	for k, v in pairs(moddata) do
		compat.update(k)
	end
	for k, v in pairs(api.game.active_mods()) do
		compat.insert_and_update(k)
	end
end

--[[--
returns true if the mod specified is active

@param _name [Required] - the name of a mod, as found in <code>info.json</code>
]]
function compat.active(_name)
	if type(_name) == "string" then
		return moddata[string.lower(_name)] ~= nil and (moddata[string.lower(_name)].active ~= nil and moddata[string.lower(_name)].active == true or false) or false
	else
		return false
	end
end

--[[--
returns the string version of a mod

@param _name [Required] - the name of a mod, as found in <code>info.json</code>
]]
function compat.version(_name)
	if type(_name) == "string" then
		return moddata[string.lower(_name)] ~= nil and moddata[string.lower(_name)].version or nil
	else
		return nil
	end
end

return compat
