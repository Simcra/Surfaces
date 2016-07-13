--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.api")
require("script.lib.util-base")

local moddata = {}
compat = {}

function compat.debug()
	error(table.tostring(moddata))
end

function compat.insert_data(_data) -- only works prior to a map being loaded or created (designed for use during data loading phases)
	if game == nil then
		for k, v in pairs(_data) do
			if type(k) == "string" and type(v) == "boolean" then
				compat.insert(k)
				moddata[string.lower(k)].active = v
			end
		end
	end
end

function compat.insert(_name)
	if type(_name) == "string" then
		if moddata[string.lower(_name)] == nil then
			moddata[string.lower(_name)] = {}
			return true
		end
	end
	return false
end

function compat.insert_and_update(_name)
	if compat.insert(_name) == true then
		compat.update(_name)
	end
end

function compat.insert_array(_data)
	if type(_data) == "table" then
		for k, v in pairs(_data) do
			compat.insert(_data)
		end
	end
end

function compat.update(_name)
	if type(_name) == "string" then
		if moddata[string.lower(_name)] ~= nil then
			local _version = api.game.active_mod(_name)
			moddata[string.lower(_name)].active = _version ~= nil
			moddata[string.lower(_name)].version = _version or ""
		end
	end
end

function compat.update_all()
	for k, v in pairs(moddata) do 
		compat.update(k)
	end
	for k, v in pairs(api.game.active_mods()) do
		compat.insert_and_update(k)
	end
end

function compat.active(_name)
	if type(_name) == "string" then
		return moddata[string.lower(_name)] ~= nil and (moddata[string.lower(_name)].active ~= nil and moddata[string.lower(_name)].active == true or false) or false
	else
		return false
	end
end

function compat.version(_name)
	if type(_name) == "string" then
		return moddata[string.lower(_name)] ~= nil and moddata[string.lower(_name)].version or nil
	else
		return nil
	end
end