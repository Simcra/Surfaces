--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require("util")
require("defines") --pre 0.13
require("script.config")
require("script.lib.pair-data")
require("script.events")

-- Entity pairing data
local entity_pair_data = {
	{"sky-entrance", "sky-exit", config.surface_location_above, config.pairclass_access_shaft, config.surface_type_sky},
	{"sky-exit", "sky-entrance", config.surface_location_below, config.pairclass_access_shaft, config.surface_type_sky},
	{"underground-entrance", "underground-exit", config.surface_location_below, config.pairclass_access_shaft, config.surface_type_underground},
	{"underground-exit", "underground-entrance", config.surface_location_above, config.pairclass_access_shaft, config.surface_type_underground, false},
	{"transport-chest-up", "receiver-chest-upper", config.surface_location_above, config.pairclass_transport_chest},
	{"transport-chest-down", "receiver-chest-lower", config.surface_location_below, config.pairclass_transport_chest},
	{"electric-pole-upper", "electric-pole-lower", config.surface_location_below, config.pairclass_electric_pole},
	{"electric-pole-lower", "electric-pole-upper", config.surface_location_above, config.pairclass_electric_pole},
	{"fluid-transport-upper", "fluid-transport-lower", config.surface_location_below, config.pairclass_fluid_transport},
	{"fluid-transport-lower", "fluid-transport-upper", config.surface_location_above, config.pairclass_fluid_transport},
	{"rail-transport-upper", "rail-transport-lower", config.surface_location_below, config.pairclass_rail_transport, nil, true, 2},
	{"rail-transport-lower", "rail-transport-upper", config.surface_location_above, config.pairclass_rail_transport, nil, true, 2}}
pairdata.insert_array(entity_pair_data)

-- Register event handlers
script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_configuration_changed)
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

-- Called when this module is initialised (when game is started and mod is loaded)
local function on_init(event)
	
end

-- Called when the map is loaded
local function on_load(event)
	
end
	
local function on_configuration_changed(event)
	
end
