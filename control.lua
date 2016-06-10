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
local insert_mod_data, on_init, on_load, on_configuration_changed

-- Create shorthand references to information from enum
local loc_above = enum.surface.rel_loc.above
local loc_below = enum.surface.rel_loc.below
local st_und = enum.surface.type.underground.id
local st_sky = enum.surface.type.sky.id

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
	{"sky-exit", "sky-entrance", loc_below, pc_acc_shaft, st_sky},
	{"underground-entrance", "underground-exit", loc_below, pc_acc_shaft, st_und},
	{"underground-exit", "underground-entrance", loc_above, pc_acc_shaft, st_und, false},
	{"transport-chest-up", "receiver-chest-upper", loc_above, pc_trans_chest},
	{"transport-chest-down", "receiver-chest-lower", loc_below, pc_trans_chest},
	{"electric-pole-upper", "electric-pole-lower", loc_below, pc_elec_pole},
	{"electric-pole-lower", "electric-pole-upper", loc_above, pc_elec_pole},
	{"fluid-transport-upper", "fluid-transport-lower", loc_below, pc_fluid_trans},
	{"fluid-transport-lower", "fluid-transport-upper", loc_above, pc_fluid_trans},
	{"rail-transport-upper", "rail-transport-lower", loc_below, pc_rail_trans, nil, true, 2},
	{"rail-transport-lower", "rail-transport-upper", loc_above, pc_rail_trans, nil, true, 2}}
pairdata.insert_array(entity_pair_data)

-- insert tiles for sky surfaces to ignore during chunk generation
local whitelist_sky_tiles = {
	enum.prototype.tile.sky_concrete.name}	-- "sky-concrete", the prototype name
skytiles.insert_array(whitelist_sky_tiles)

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