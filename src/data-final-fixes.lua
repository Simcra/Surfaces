--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("script.proto")
require("script.lib.compat-data")

--[[
Mod compatibility data, array to be passed in format "name = is_active" where:
	- index is the name of the mod found in it's info.json file\
	- is_active is a boolean, calculated through checks or provided as <code>true</code> or <code>false</code>
]]
local mod_data = {
	["bobelectronics"] = (type(bobmods) == "table" and data.raw["recipe"]["bob-rubber"] ~= nil),
	["squeak through"] = (type(prototype_type_gap_requirements) == "table")
}
compat.insert_data(mod_data)

-- Other prototypes which are only loaded when optional mods are installed
if compat.active("warehousing") == true then
	require("prototypes.item.addons.warehousing")
	require("prototypes.entity.addons.warehousing")
	require("prototypes.recipe.addons.warehousing")
end
if compat.active("bobpower") == true then
	require("prototypes.item.addons.bobpower")
	require("prototypes.entity.addons.bobpower")
	require("prototypes.recipe.addons.bobpower")
end
if compat.active("boblogistics") == true then
	require("prototypes.item.addons.boblogistics")
	require("prototypes.entity.addons.boblogistics")
	require("prototypes.recipe.addons.boblogistics")
end
if compat.active("squeak through") == true then
	data.raw[proto.get_field({"entity", "underground_wall"}, "type")][proto.get_field({"entity", "underground_wall"}, "name")].collision_box = {
		{-0.499, -0.499}, {0.499, 0.499}}
end

-- Final recipe fixes
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