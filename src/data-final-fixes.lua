--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("prototypes.prototype")
require("script.lib.compat-data")

--[[
Mod compatibility data, array to be passed in format "index = is_active" where:
	- index is the name of the mod found in it's info.json file\
	- is_active is a boolean, calculated through checks or provided as <code>true</code> or <code>false</code>
]]
local mod_data = {
	--["5dim_energy"] = (data.raw["recipe"]["5d-basic-accumulator-2"] ~= nil),
	--["5dim_logistic"] = (data.raw["recipe"]["5d-requester"] ~= nil),
	--["5dim_transport"] = (data.raw["recipe"]["5d-storage-tank"] ~= nil),
	["bio_industries"] = (type(BI_Config) == "table"),
	["bobelectronics"] = (type(bobmods) == "table" and data.raw["recipe"]["bob-rubber"] ~= nil),
	["boblogistics"] = (type(bobmods) == "table" and type(bobmods.logistics) == "table"),
	["bobpower"] = (type(bobmods) == "table" and type(bobmods.power) == "table"),
	["bobwarfare"] = (type(bobmods) == "table" and type(bobmods.warfare) == "table"),
	["squeak through"] = (type(prototype_type_gap_requirements) == "table"),	
	["warehousing"] = (type(define_warehouse) == "function")
}
compat.insert_data(mod_data)

-- Other prototypes which are only loaded when optional mods are installed
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
if compat.active("warehousing") == true then
	require("prototypes.item.addons.warehousing")
	require("prototypes.entity.addons.warehousing")
	require("prototypes.recipe.addons.warehousing")
end
if compat.active("squeak through") == true or compat.active("bio_industries") == true then -- if either Squeak Through or the Bio Industries mod is detected
	local _uw_type = proto.entity.underground_wall.type
	local _uw_name = proto.entity.underground_wall.name
	data.raw[_uw_type][_uw_name] = proto.definition({"entity"}, "underground_wall", true) -- completely reload the underground wall prototype
end

-- Final recipe fixes
if compat.active("bobelectronics") == true then
	local _tinned_copper_cable = (data.raw["item"]["tinned-copper-cable"] ~= nil) -- is tinned copper cable from Bobs Electronics present?
	local _servo_crude = proto.item.servo.crude.name
	local _servo_std = proto.item.servo.standard.name
	local _servo_imp = proto.item.servo.improved.name
	data.raw["recipe"][proto.recipe.connector.crude.name].ingredients = {{_servo_crude, 1}, {"copper-cable", 2}, {"basic-circuit-board", 2}}
	data.raw["recipe"][proto.recipe.connector.basic.name].ingredients = {{_servo_crude, 2}, {(_tinned_copper_cable and "tinned-copper-cable" or "copper-cable"),
		(_tinned_copper_cable and 3 or 6)}, {"basic-circuit-board", 4}}
	data.raw["recipe"][proto.recipe.connector.standard.name].ingredients = {{_servo_std, 1}, {"electronic-circuit", 2}, {"basic-electronic-components", 5}}
	data.raw["recipe"][proto.recipe.connector.improved.name].ingredients = {{_servo_std, 2}, {"electronic-circuit", 4}, {"electronic-components", 2}}
	data.raw["recipe"][proto.recipe.connector.advanced.name].ingredients = {{_servo_imp, 2}, {"advanced-circuit", 2}, {"insulated-cable", 6}}
end