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

-- Create shorthand references to data from enum
local loc_above = enum.surface.rel_loc.above
local loc_below = enum.surface.rel_loc.below
local st_und = enum.surface.type.underground.id
local st_sky = enum.surface.type.sky.id
local st_all = enum.surface.type.all.id

-- register entity pair-classes used by paired entities in this mod.
local entity_pair_class = {
	"access-shaft",
	"electric-pole",
	"transport-chest",
	"fluid-transport",
	"rail-transport"}
pairclass.insert_array(entity_pair_class)

-- create a shorthand reference to the ID of each entity pair-class registered by this mod.
local pc_acc_shaft = pairclass.get("access-shaft")
local pc_elec_pole = pairclass.get("electric-pole")
local pc_trans_chest = pairclass.get("transport-chest")
local pc_fluid_trans = pairclass.get("fluid-transport")
local pc_rail_trans = pairclass.get("rail-transport")

--[[
insert entity pair data defined by this mod, structure of fields is as follows:
	- entity (must be a valid entity prototype string)								(required)
	- paired entity (must be a valid entity prototype string)						(required)
		- a new entity of this prototype will be placed on the paired surface after the entity has been placed by a player or construction robot
	- relative location (must be a constant defined by enum) 						(required)
		[valid values: enum.surface.rel_loc.above, enum.surface.rel_loc.below]
		- specifies which surface the paired entity will be placed on relative to the current surface (either above or below this surface)
	- pair class (must be a valid pair-class ID)									(required)
		- valid pair-class IDs are obtained through pairclass.get(name)
		- pair-classes must be registered using either pairclass.insert(name) or pairclass.insert_array({name, another_name})
		- pair-class will effect the behaviour when creating a paired entity, for example:
			- all "electric-pole" paired entities will connect the circuit and electric network between the two paired entities
			- all "fluid-transport" paired entities will share their fluidbox contents evenly to allow fluid transportation
	- allowed this entity to be constructed on the primary surface? 				(optional)		[default: false]
		- determines whether or not this entity may be placed on the "nauvis" surface
		- if this is set to false, entities of this type will be dropped on the ground when a robot or player attempts to build them on the "nauvis" surface
	- radius to be cleared around the entity (in tiles) upon placement				(optional)		[default: 0]
		- in sky surfaces, this will be the radius (in tiles) that sky tiles will be placed in sky surfaces prior to paired entity placement (also applies when this entity is deconstructed)
		- in underground surfaces, this will be the radius (in tiles) that underground walls are cleared for this paired entity
		- a radius of 0 results in a single tile centered on the entity's position, likewise a radius of 5 results in eleven tiles centered on the entity's position
	- ID of valid domain(s) for this paired entity						 			(optional)		[default: enum.surface.type.all.id]
		- specifies which surfaces this entity may be placed in, other than the primary surface:
			- enum.surface.type.underground.id		- allows this entity to only be placed in underground surfaces
			- enum.surface.type.sky.id				- allows this entity to only be placed in sky surfaces
			- enum.surface.type.all.id 				- allows this entity to be placed in both sky and underground surfaces
	- sky tile (must be a valid tile prototype string)								(optional)		[default: enum.prototype.tile.sky_concrete.name]
]]
local entity_pair_data = {
	{"sky-entrance", "sky-exit", loc_above, pc_acc_shaft, true, 1, st_sky},
	{"sky-exit", "sky-entrance", loc_below, pc_acc_shaft, false, 1, st_sky},
	{"underground-entrance", "underground-exit", loc_below, pc_acc_shaft, true, 1, st_und},
	{"underground-exit", "underground-entrance", loc_above, pc_acc_shaft, false, 1, st_und},
	{"wooden-transport-chest-up", "wooden-receiver-chest-upper", loc_above, pc_trans_chest, true},
	{"wooden-transport-chest-down", "wooden-receiver-chest-lower", loc_below, pc_trans_chest, true},
	{"iron-transport-chest-up", "iron-receiver-chest-upper", loc_above, pc_trans_chest, true},
	{"iron-transport-chest-down", "iron-receiver-chest-lower", loc_below, pc_trans_chest, true},
	{"steel-transport-chest-up", "steel-receiver-chest-upper", loc_above, pc_trans_chest, true},
	{"steel-transport-chest-down", "steel-receiver-chest-lower", loc_below, pc_trans_chest, true},
	{"smart-transport-chest-up", "smart-receiver-chest-upper", loc_above, pc_trans_chest, true},
	{"smart-transport-chest-down", "smart-receiver-chest-lower", loc_below, pc_trans_chest, true},
	{"logistic-transport-chest-up", "logistic-receiver-chest-upper", loc_above, pc_trans_chest, true},
	{"logistic-transport-chest-down", "logistic-receiver-chest-lower", loc_below, pc_trans_chest, true},
	{"big-electric-pole-upper", "big-electric-pole-lower", loc_below, pc_elec_pole, true, 1},
	{"big-electric-pole-lower", "big-electric-pole-upper", loc_above, pc_elec_pole, true, 1},
	{"medium-electric-pole-upper", "medium-electric-pole-lower", loc_below, pc_elec_pole, true},
	{"medium-electric-pole-lower", "medium-electric-pole-upper", loc_above, pc_elec_pole, true},
	{"small-electric-pole-upper", "small-electric-pole-lower", loc_below, pc_elec_pole, true},
	{"small-electric-pole-lower", "small-electric-pole-upper", loc_above, pc_elec_pole, true},
	{"substation-upper", "substation-lower", loc_below, pc_elec_pole, true, 1},
	{"substation-lower", "substation-upper", loc_above, pc_elec_pole, true, 1},
	{"fluid-transport-upper", "fluid-transport-lower", loc_below, pc_fluid_trans, true},
	{"fluid-transport-lower", "fluid-transport-upper", loc_above, pc_fluid_trans, true},
	{"train-stop-upper", "train-stop-lower", loc_below, pc_rail_trans, true, 2},
	{"train-stop-lower", "train-stop-upper", loc_above, pc_rail_trans, true, 2}}
pairdata.insert_array(entity_pair_data)

-- insert tiles for sky surfaces to ignore during chunk generation (pairdata.insert will insert the sky tile if it does not already exist in the skytiles array, therefore in most cases this is not necessary)
local whitelist_sky_tiles = {
	enum.prototype.tile.sky_concrete.name}	-- "sky-concrete", the prototype name
skytiles.insert_array(whitelist_sky_tiles)

-- initialise global variables
local init_globs = function()
	global.task_queue = global.task_queue or {}
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	global.transport_chests = global.transport_chests or {}
	global.fluid_transport = global.fluid_transport or {}
end

-- control functions (on_init, on_load, on_config_changed)
local function on_init()
	init_globs()
end

local function on_load()
	init_globs()
end

local function on_configuration_changed()
	init_globs()
end

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