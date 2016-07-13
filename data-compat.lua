--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("script.lib.compat-data")

--[[
Pre-init mod compatibility stuff, array to be passed in format "index = data" where:
	- index should be the mod name as described by the specific mod string
	- data should be a boolean, may be a result of tests or otherwise passed simply as true or false
]]
local mod_data = {
	["bobwarfare"] = (type(bobmods) == "table" and type(bobmods.warfare) == "table"),
	["warehousing"] = (type(define_warehouse) == "function")
}
compat.insert_data(mod_data)
-- compat.insert and compat.insert_data are not the same function, compat.insert may only be called after the game is loaded, meanwhile compat.insert_data will work in the data loading phases