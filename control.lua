--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]
require "util"
require "defines"
require "script.config"
require "script.events"

-- Called whenever map is loaded by a player
function on_load()
	
end

-- Event handlers
script.on_load(function() on_load() end)
script.on_event(defines.events.on_built_entity, function(event) on_built_entity(event) end) -- when the player builds an entity
script.on_event(defines.events.on_robot_built_entity, function(event) on_robot_built_entity(event) end) -- when a robot builds an entity
script.on_event(defines.events.on_chunk_generated, function(event) on_chunk_generated(event) end) -- when a chunk is generated
script.on_event(defines.events.on_preplayer_mined_item, function(event) on_preplayer_mined_item(event) end) -- prior to when a player attempts to mine an object
script.on_event(defines.events.on_robot_pre_mined, function(event) on_robot_pre_mined(event) end) -- prior to when a robot attempts to mine an object
script.on_event(defines.events.on_player_mined_item, function(event) on_player_mined_item(event) end) -- after a player successfully mines an object
script.on_event(defines.events.on_robot_mined, function(event) on_robot_mined(event) end) -- after a robot successfully mines an object
script.on_event(defines.events.on_marked_for_deconstruction, function(event) on_marked_for_deconstruction(event) end) -- when an object has been marked for deconstruction
script.on_event(defines.events.on_canceled_deconstruction, function(event) on_canceled_deconstruction(event) end) -- when an object is removed from deconstruction queue
script.on_event(defines.events.on_player_driving_changed_state, function(event) on_player_driving_changed_state(event) end) -- when the player stops or starts moving in a vehicle
script.on_event(defines.events.on_put_item, function(event) on_put_item(event) end) -- when the player attempts to build something
script.on_event(defines.events.on_player_rotated_entity, function(event) on_player_rotated_entity(event) end) -- when the player rotates an entity
script.on_event(defines.events.on_trigger_created_entity, function(event) on_trigger_created_entity(event) end) -- prior to when an entity is created
script.on_event(defines.events.on_picked_up_item, function(event) on_picked_up_item(event) end) -- when a player picks up an item
script.on_event(defines.events.on_sector_scanned, function(event) on_sector_scanned(event) end) -- when the radar scans a sector
script.on_event(defines.events.on_entity_died, function(event) on_entity_died(event) end) -- when an entity dies
script.on_event(defines.events.on_train_changed_state, function(event) on_train_changed_state(event) end) -- when a train starts or stops moving
script.on_event(defines.events.on_tick, function(event) on_tick(event) end) -- every tick