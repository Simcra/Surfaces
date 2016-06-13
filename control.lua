--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("util")
require("defines") --pre 0.13
require("script.enum")
require("script.lib.pair-data")
require("script.events")

-- Declare local functions
local on_init, on_load, on_configuration_changed

-- Create shorthand references to information from enum
local loc_above = enum.surface.rel_loc.above
local loc_below = enum.surface.rel_loc.below
local st_und = enum.surface.type.underground.id
local st_sky = enum.surface.type.sky.id
local st_all = enum.surface.type.all.id

-- insert all entity pair classes defined by this mod.
local entity_pair_class = {
"sm-access-shaft",
"sm-electric-pole",
"sm-transport-chest",
"sm-fluid-transport",
"sm-rail-transport"}
pairclass.insert_array(entity_pair_class)

-- create shorthand references to IDs of entity pair classes defined by function above
local pc_acc_shaft = pairclass.get("sm-access-shaft")
local pc_elec_pole = pairclass.get("sm-electric-pole")
local pc_trans_chest = pairclass.get("sm-transport-chest")
local pc_fluid_trans = pairclass.get("sm-fluid-transport")
local pc_rail_trans = pairclass.get("sm-rail-transport")

-- insert entity pair data defined by this mod
local entity_pair_data = {
	{"sky-entrance", "sky-exit", loc_above, pc_acc_shaft, st_sky},
	{"sky-exit", "sky-entrance", loc_below, pc_acc_shaft, st_sky, false},
	{"underground-entrance", "underground-exit", loc_below, pc_acc_shaft, st_und},
	{"underground-exit", "underground-entrance", loc_above, pc_acc_shaft, st_und, false},
	{"wooden-transport-chest-up", "wooden-receiver-chest-upper", loc_above, pc_trans_chest},
	{"wooden-transport-chest-down", "wooden-receiver-chest-lower", loc_below, pc_trans_chest},
	{"iron-transport-chest-up", "iron-receiver-chest-upper", loc_above, pc_trans_chest},
	{"iron-transport-chest-down", "iron-receiver-chest-lower", loc_below, pc_trans_chest},
	{"steel-transport-chest-up", "steel-receiver-chest-upper", loc_above, pc_trans_chest},
	{"steel-transport-chest-down", "steel-receiver-chest-lower", loc_below, pc_trans_chest},
	{"smart-transport-chest-up", "smart-receiver-chest-upper", loc_above, pc_trans_chest},
	{"smart-transport-chest-down", "smart-receiver-chest-lower", loc_below, pc_trans_chest},
	{"logistic-transport-chest-up", "logistic-receiver-chest-upper", loc_above, pc_trans_chest},
	{"logistic-transport-chest-down", "logistic-receiver-chest-lower", loc_below, pc_trans_chest},
	{"big-electric-pole-upper", "big-electric-pole-lower", loc_below, pc_elec_pole},
	{"big-electric-pole-lower", "big-electric-pole-upper", loc_above, pc_elec_pole},
	{"medium-electric-pole-upper", "medium-electric-pole-lower", loc_below, pc_elec_pole},
	{"medium-electric-pole-lower", "medium-electric-pole-upper", loc_above, pc_elec_pole},
	{"small-electric-pole-upper", "small-electric-pole-lower", loc_below, pc_elec_pole},
	{"small-electric-pole-lower", "small-electric-pole-upper", loc_above, pc_elec_pole},
	{"substation-upper", "substation-lower", loc_below, pc_elec_pole},
	{"substation-lower", "substation-upper", loc_above, pc_elec_pole},
	{"fluid-transport-upper", "fluid-transport-lower", loc_below, pc_fluid_trans},
	{"fluid-transport-lower", "fluid-transport-upper", loc_above, pc_fluid_trans},
	{"train-stop-upper", "train-stop-lower", loc_below, pc_rail_trans, st_all, true, 2},
	{"train-stop-lower", "train-stop-upper", loc_above, pc_rail_trans, st_all, true, 2}}
pairdata.insert_array(entity_pair_data)

-- insert tiles for sky surfaces to ignore during chunk generation
local whitelist_sky_tiles = {
	enum.prototype.tile.sky_concrete.name}	-- "sky-concrete", the prototype name
skytiles.insert_array(whitelist_sky_tiles)	-- do note that you do not have to do this as it will be specified by the create-tile as provided with pairdata
-- for example: pairdata.insert(entity_prototype_a, entity_prototype_b, loc_below, pairclass, nil, true, 0, tile_prototype}
-- in this example, tile_prototype will automatically be inserted into the skytiles data

-- Register event handlers
script.on_init(function() on_init() end)
script.on_load(function() on_load() end)
script.on_configuration_changed(function() on_configuration_changed() end)

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
-- When an entity is created, see http://lua-api.factorio.com/0.12.35/events.html#on_trigger_created_entity
script.on_event(defines.events.on_trigger_created_entity, function(event) events.on_trigger_created_entity(event) end)
-- When a player picks up an item
script.on_event(defines.events.on_picked_up_item, function(event) events.on_picked_up_item(event) end)
-- When the radar scans a sector
script.on_event(defines.events.on_sector_scanned, function(event) events.on_sector_scanned(event) end)
-- When an entity dies
script.on_event(defines.events.on_entity_died, function(event) events.on_entity_died(event) end)
-- When a train changes state, see http://lua-api.factorio.com/0.12.35/defines.html#trainstate
script.on_event(defines.events.on_train_changed_state, function(event) events.on_train_changed_state(event) end)
-- Every tick
script.on_event(defines.events.on_tick, function(event) events.on_tick(event) end)

on_init = function()

end

on_load = function()

end

on_configuration_changed = function()

end