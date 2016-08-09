--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("util")
require("script.const")
require("script.events")
require("script.proto")
require("script.lib.compat-data")
require("script.lib.pair-data")

-- Create shorthand references to constants and prototype data
local rl_above, rl_below = const.surface.rel_loc.above, const.surface.rel_loc.below
local st_und, st_sky, st_all = const.surface.type.underground.id, const.surface.type.sky.id, const.surface.type.all.id
local t_crude, t_basic, t_std, t_imp, t_adv = const.tier.crude, const.tier.basic, const.tier.standard, const.tier.improved, const.tier.advanced

-- register entity pair classes used by paired entities in this mod.
local entity_pair_class_data = {"access-shaft", "energy-transport", "fluid-transport", "item-transport", "rail-transport"}
pairclass.insert_array(entity_pair_class_data)

-- create a shorthand reference to the ID of each entity pair-class registered by this mod.
local pc_acc_shaft = pairclass.get("access-shaft")
local pc_energy_trans = pairclass.get("energy-transport")
local pc_fluid_trans = pairclass.get("fluid-transport")
local pc_item_trans = pairclass.get("item-transport")
local pc_rail_trans = pairclass.get("rail-transport")

--[[
see <code>pairdata.insert(_entity_name, _paired_entity_name, _relative_location, _pair_class, _placeable_on_nauvis, _custom_data, _clear_tile_radius, _placeable_surface_type)</code> for more information.
]]
local entity_pair_data = {
	{"sky-entrance", "sky-exit", rl_above, pc_acc_shaft, true, nil, 1, st_sky},
	{"sky-exit", "sky-entrance", rl_below, pc_acc_shaft, false, nil, 1, st_sky},
	{"underground-entrance", "underground-exit", rl_below, pc_acc_shaft, true, nil, 1, st_und},
	{"underground-exit", "underground-entrance", rl_above, pc_acc_shaft, false, nil, 1, st_und},
	{"wooden-transport-chest-up", "wooden-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_crude}},
	{"wooden-transport-chest-down", "wooden-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_crude}},
	{"iron-transport-chest-up", "iron-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_std}},
	{"iron-transport-chest-down", "iron-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_std}},
	{"steel-transport-chest-up", "steel-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_imp}},
	{"steel-transport-chest-down", "steel-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_imp}},
	{"logistic-transport-chest-up", "logistic-receiver-chest-upper", rl_above, pc_item_trans, true, {tier = t_adv}},
	{"logistic-transport-chest-down", "logistic-receiver-chest-lower", rl_below, pc_item_trans, true, {tier = t_adv}},
	{"energy-transport-upper", "energy-transport-lower", rl_below, pc_energy_trans, true, nil, 0.5},
	{"energy-transport-lower", "energy-transport-upper", rl_above, pc_energy_trans, true, nil, 0.5},
	{"fluid-transport-upper", "fluid-transport-lower", rl_below, pc_fluid_trans, true, nil, 1},
	{"fluid-transport-lower", "fluid-transport-upper", rl_above, pc_fluid_trans, true, nil, 1},
--	{"train-stop-upper", "train-stop-lower", rl_below, pc_rail_trans, true, nil, 0.5},
--	{"train-stop-lower", "train-stop-upper", rl_above, pc_rail_trans, true, nil, 0.5}
}
pairdata.insert_array(entity_pair_data)

-- insert tiles for sky surfaces to ignore during chunk generation (pairdata.insert will insert the sky tile if it does not already exist in the skytiles array, therefore in most cases this is not necessary)
local whitelist_sky_tiles = {"wooden-floor"}	-- "wooden-floor", the prototype name
skytiles.insert_array(whitelist_sky_tiles)

-- initialise global variables
local init_globals = function()
	global.task_queue = global.task_queue or {}
	global.mod_surfaces = global.mod_surfaces or {}
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	global.item_transport = global.item_transport or {}
	global.fluid_transport = global.fluid_transport or {}
	global.energy_transport = global.energy_transport or {}
	global.surfaces_to_migrate = global.surfaces_to_migrate or {}
end

-- mod addon data, will be loaded only if the index of the entry is present in active mods
local addon_data = {
	warehousing = { -- Warehousing mod
		{"transport-storehouse-up", "receiver-storehouse-upper", rl_above, pc_item_trans, true, {tier = t_std, modifier = 8}, 1},
		{"transport-storehouse-down", "receiver-storehouse-lower", rl_below, pc_item_trans, true, {tier = t_std, modifier = 8}, 1},
		{"logistic-transport-storehouse-up", "logistic-receiver-storehouse-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 8}, 1},
		{"logistic-transport-storehouse-down", "logistic-receiver-storehouse-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 8}, 1},
		{"transport-warehouse-up", "receiver-warehouse-upper", rl_above, pc_item_trans, true, {tier = t_imp, modifier = 20}, 2},
		{"transport-warehouse-down", "receiver-warehouse-lower", rl_below, pc_item_trans, true, {tier = t_imp, modifier = 20}, 2},
		{"logistic-transport-warehouse-up", "logistic-receiver-warehouse-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 20}, 2},
		{"logistic-transport-warehouse-down", "logistic-receiver-warehouse-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 20}, 2}
	},
	bobpower = {
		{"energy-transport-2-upper", "energy-transport-2-lower", rl_below, pc_energy_trans, true},
		{"energy-transport-2-lower", "energy-transport-2-upper", rl_above, pc_energy_trans, true},
		{"energy-transport-3-upper", "energy-transport-3-lower", rl_below, pc_energy_trans, true},
		{"energy-transport-3-lower", "energy-transport-3-upper", rl_above, pc_energy_trans, true},
		{"energy-transport-4-upper", "energy-transport-4-lower", rl_below, pc_energy_trans, true},
		{"energy-transport-4-lower", "energy-transport-4-upper", rl_above, pc_energy_trans, true}
	},
	boblogistics = {
		{"logistic-transport-chest-2-up", "logistic-receiver-chest-2-upper", rl_above, pc_item_trans, true, {tier = t_adv, modifier = 1.5}},
		{"logistic-transport-chest-2-down", "logistic-receiver-chest-2-lower", rl_below, pc_item_trans, true, {tier = t_adv, modifier = 1.5}},
		{"fluid-transport-2-upper", "fluid-transport-2-lower", rl_below, pc_fluid_trans, true},
		{"fluid-transport-2-lower", "fluid-transport-2-upper", rl_above, pc_fluid_trans, true},
		{"fluid-transport-3-upper", "fluid-transport-3-lower", rl_below, pc_fluid_trans, true},
		{"fluid-transport-3-lower", "fluid-transport-3-upper", rl_above, pc_fluid_trans, true},
		{"fluid-transport-4-upper", "fluid-transport-4-lower", rl_below, pc_fluid_trans, true},
		{"fluid-transport-4-lower", "fluid-transport-4-upper", rl_above, pc_fluid_trans, true}
	}
}
events.set_addon_data(addon_data)

-- control functions (on_init, on_load, on_config_changed)
local function on_init()
	init_globals()
end

local function on_load()

end

local function on_configuration_changed(_config_data)
	init_globals()
	local mod_changes = _config_data["mod_changes"]
	if mod_changes and mod_changes["Surfaces"] then
		local ver = _config_data["mod_changes"]["Surfaces"]["old_version"]
		local ver_parts = string.gmatch(ver, "%d+")
		local ver_rel, ver_mjr, ver_mnr = tonumber(ver_parts()), tonumber(ver_parts()), tonumber(ver_parts())
		if ver_rel == 0 and ver_mjr == 0 and ver_mnr <= 6 then
			util.broadcast("Please be patient and wait until surface migrations have been completed")
			remote.call("Surfaces", "migrate", "_")
		end
	end
end

-- Register event handlers
script.on_init(function() on_init() end)
script.on_load(function() on_load() end)
script.on_configuration_changed(function(_config_data) on_configuration_changed(_config_data) end)

-- When an entity is built by a player
script.on_event(defines.events.on_built_entity, function(event) events.on_built_entity(event) end)
-- When a construction robot builds an entity
script.on_event(defines.events.on_robot_built_entity, function(event) events.on_robot_built_entity(event) end)
-- When a chunk is generated
script.on_event(defines.events.on_chunk_generated, function(event) events.on_chunk_generated(event) end)
-- Prior to when a player harvests an entity (contains variables: entity, player_index)
script.on_event(defines.events.on_preplayer_mined_item, function(event) events.on_preplayer_mined_item(event) end)
-- Prior to when a robot harvests an entity (contains variables: entity)
script.on_event(defines.events.on_robot_pre_mined, function(event) events.on_robot_pre_mined(event) end)
-- After a player successfully harvests an entity (contains variables: item_stack, player_index)
script.on_event(defines.events.on_player_mined_item, function(event) events.on_player_mined_item(event) end)
-- After a robot successfully harvests an entity (contains variables: item_stack)
script.on_event(defines.events.on_robot_mined, function(event) events.on_robot_mined(event) end)
-- When an object has been marked for deconstruction
script.on_event(defines.events.on_marked_for_deconstruction, function(event) events.on_marked_for_deconstruction(event) end)
-- When an object is removed from deconstruction queue
script.on_event(defines.events.on_canceled_deconstruction, function(event) events.on_canceled_deconstruction(event) end)
-- When the player enters or exits a vehicle
script.on_event(defines.events.on_player_driving_changed_state, function(event) events.on_player_driving_changed_state(event) end)
-- When the Player attempts to place/use something
script.on_event(defines.events.on_put_item, function(event) events.on_put_item(event) end)
-- When the player rotates an entity
script.on_event(defines.events.on_player_rotated_entity, function(event) events.on_player_rotated_entity(event) end)
-- When an entity is created
script.on_event(defines.events.on_trigger_created_entity, function(event) events.on_trigger_created_entity(event) end)
-- When a player picks up an item
script.on_event(defines.events.on_picked_up_item, function(event) events.on_picked_up_item(event) end)
-- When the radar scans a sector
script.on_event(defines.events.on_sector_scanned, function(event) events.on_sector_scanned(event) end)
-- When an entity dies
script.on_event(defines.events.on_entity_died, function(event) events.on_entity_died(event) end)
-- When a train changes state, see http://lua-api.factorio.com/latest/defines.html#trainstate for states
script.on_event(defines.events.on_train_changed_state, function(event) events.on_train_changed_state(event) end)
-- Every tick
script.on_event(defines.events.on_tick, function(event) events.on_tick(event) end)

remote.add_interface("Surfaces", {
	["migrate"] = function(_separator)
		for k, v in pairs(api.game.surfaces()) do
			surfaces.migrate_surface(v, _separator)
		end
	end
})