--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("script.proto")
require("script.lib.compat-data")

--[[
Pre-init mod compatibility stuff, array to be passed in format "index = data" where:
	- index should be the mod name as described by the specific mod string
	- data should be a boolean, may be a result of tests or otherwise passed simply as true or false
]]
local mod_data = {
	["bobelectronics"] = (type(bobmods) == "table" and data.raw["recipe"]["bob-rubber"] ~= nil),
	["squeak through"] = (type(prototype_type_gap_requirements) == "table")
}
compat.insert_data(mod_data)

-- Final fixes
if compat.active("squeak through") == true then
	data.raw["tree"][proto.get_field({"entity", "underground_wall"}, "name")].collision_box = {{-0.499, -0.499}, {0.499, 0.499}}
end
if compat.active("bobelectronics") == true then
	local _tinned_copper_cable = (data.raw["item"]["tinned-copper-cable"] ~= nil)
	data.raw["recipe"][proto.get_field({"recipe", "connector", "crude"}, "name")].ingredients = {
		{proto.get_field({"item", "servo", "crude"}, "name"), 1}, {"copper-cable", 2}, {"basic-circuit-board", 2}
	}
	data.raw["recipe"][proto.get_field({"recipe", "connector", "basic"}, "name")].ingredients = {
		{proto.get_field({"item", "servo", "crude"}, "name"), 2},
		{(_tinned_copper_cable and "tinned-copper-cable" or "copper-cable"), (_tinned_copper_cable and 3 or 6)}, {"basic-circuit-board", 4}
	}
	data.raw["recipe"][proto.get_field({"recipe", "connector", "standard"}, "name")].ingredients = {
		{proto.get_field({"item", "servo", "standard"}, "name"), 1}, {"electronic-circuit", 2}, {"basic-electronic-components", 5}
	}
	data.raw["recipe"][proto.get_field({"recipe", "connector", "improved"}, "name")].ingredients = {
		{proto.get_field({"item", "servo", "standard"}, "name"), 2}, {"electronic-circuit", 4}, {"electronic-components", 2}
	}
	data.raw["recipe"][proto.get_field({"recipe", "connector", "advanced"}, "name")].ingredients = {
		{proto.get_field({"item", "servo", "improved"}, "name"), 2}, {"advanced-circuit", 2}, {"insulated-cable", 6}
	}
end