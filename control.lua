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
local rl_above = const.surface.rel_loc.above
local rl_below = const.surface.rel_loc.below
local st_und = const.surface.type.underground.id
local st_sky = const.surface.type.sky.id
local st_all = const.surface.type.all.id

-- register entity pair classes used by paired entities in this mod.
local entity_pair_class_data = {"access-shaft", "electric-pole", "transport-chest", "fluid-transport", "rail-transport"}
pairclass.insert_array(entity_pair_class_data)

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
	- relative location (must be a valid id defined by const)	 					(required)
		[valid values: const.surface.rel_loc.above, const.surface.rel_loc.below]
		- specifies which surface the paired entity will be placed on relative to the current surface (either above or below this surface)
	- pair class (must be a valid pair class ID)									(required)
		- valid pair-class IDs are obtained through pairclass.get(name)
		- pair-classes must be registered using either pairclass.insert(name) or pairclass.insert_array({name, another_name})
		- pair-class will effect the behaviour when creating a paired entity, for example:
			- all "electric-pole" paired entities will connect the circuit and electric network between the two paired entities
			- all "fluid-transport" paired entities will share their fluidbox contents with their pair
	- is allowed this entity to be constructed on the main surface (nauvis)?		(optional)		[default: false]
		- if this is set to false, entities of this type will be dropped on the ground when a robot or player attempts to build them on the main surface
	- custom data (must be a table if specified)									(optional)		[default: {}, any required fields will be generated]
		- used by transport chests to store tier which modifies speed of item transportation
	- radius to be cleared around the entity (in tiles) upon placement				(optional)		[default: 0]
		- in sky surfaces, this will be the radius (in tiles) that sky tiles will be placed in sky surfaces prior to paired entity placement (also applies when this entity is deconstructed)
		- in underground surfaces, this will be the radius (in tiles) that underground walls are cleared for this paired entity
		- a radius of 0 results in a single tile centered on the entity's position, likewise a radius of 5 results in eleven tiles centered on the entity's position
	- ID of valid domain for this paired entity						 				(optional)		[default: const.surface.type.all.id]
		- specifies which surface type this entity may be placed in, excluding the primary surface:
			- const.surface.type.underground.id			- allows this entity to only be placed in underground surfaces
			- const.surface.type.sky.id					- allows this entity to only be placed in sky surfaces
			- const.surface.type.all.id 				- allows this entity to be placed in both sky and underground surfaces and any future surface types specified by this mod
	- sky tile (must be a valid tile prototype string)								(optional)		[default: proto.tile.platform.name]
		- if specified, instead of placing construction-platform underneath the paired entity on sky surfaces, this tile prototype will be placed.
]]
local entity_pair_data = {
	{"sky-entrance", "sky-exit", rl_above, pc_acc_shaft, true, nil, 1, st_sky},
	{"sky-exit", "sky-entrance", rl_below, pc_acc_shaft, false, nil, 1, st_sky},
	{"underground-entrance", "underground-exit", rl_below, pc_acc_shaft, true, nil, 1, st_und},
	{"underground-exit", "underground-entrance", rl_above, pc_acc_shaft, false, nil, 1, st_und},
	{"wooden-transport-chest-up", "wooden-receiver-chest-upper", rl_above, pc_trans_chest, true, {tier = const.tier.crude}, 1},
	{"wooden-transport-chest-down", "wooden-receiver-chest-lower", rl_below, pc_trans_chest, true, {tier = const.tier.crude}, 1},
	{"iron-transport-chest-up", "iron-receiver-chest-upper", rl_above, pc_trans_chest, true, {tier = const.tier.standard}, 1},
	{"iron-transport-chest-down", "iron-receiver-chest-lower", rl_below, pc_trans_chest, true, {tier = const.tier.standard}, 1},
	{"steel-transport-chest-up", "steel-receiver-chest-upper", rl_above, pc_trans_chest, true, {tier = const.tier.improved}, 1},
	{"steel-transport-chest-down", "steel-receiver-chest-lower", rl_below, pc_trans_chest, true, {tier = const.tier.improved}, 1},
	{"logistic-transport-chest-up", "logistic-receiver-chest-upper", rl_above, pc_trans_chest, true, {tier = const.tier.advanced}, 1},
	{"logistic-transport-chest-down", "logistic-receiver-chest-lower", rl_below, pc_trans_chest, true, {tier = const.tier.advanced}, 1},
	{"big-electric-pole-upper", "big-electric-pole-lower", rl_below, pc_elec_pole, true, nil, 1},
	{"big-electric-pole-lower", "big-electric-pole-upper", rl_above, pc_elec_pole, true, nil, 1},
	{"medium-electric-pole-upper", "medium-electric-pole-lower", rl_below, pc_elec_pole, true, nil, 1},
	{"medium-electric-pole-lower", "medium-electric-pole-upper", rl_above, pc_elec_pole, true, nil, 1},
	{"small-electric-pole-upper", "small-electric-pole-lower", rl_below, pc_elec_pole, true, nil, 1},
	{"small-electric-pole-lower", "small-electric-pole-upper", rl_above, pc_elec_pole, true, nil, 1},
	{"substation-upper", "substation-lower", rl_below, pc_elec_pole, true, nil, 1},
	{"substation-lower", "substation-upper", rl_above, pc_elec_pole, true, nil, 1},
	{"fluid-transport-upper", "fluid-transport-lower", rl_below, pc_fluid_trans, true, nil, 1},
	{"fluid-transport-lower", "fluid-transport-upper", rl_above, pc_fluid_trans, true, nil, 1}--,
	--{"train-stop-upper", "train-stop-lower", rl_below, pc_rail_trans, true, nil, 2},
	--{"train-stop-lower", "train-stop-upper", rl_above, pc_rail_trans, true, nil, 2}
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
	global.transport_chests = global.transport_chests or {}
	global.fluid_transport = global.fluid_transport or {}
end

local addon_data = {
	warehousing = {
		{"transport-storehouse-up", "receiver-storehouse-upper", rl_above, pc_trans_chest, true, {tier = const.tier.standard, size = 36}, 1},
		{"transport-storehouse-down", "receiver-storehouse-lower", rl_below, pc_trans_chest, true, {tier = const.tier.standard, size = 36}, 1},
		{"logistic-transport-storehouse-up", "logistic-receiver-storehouse-upper", rl_above, pc_trans_chest, true, {tier = const.tier.advanced, size = 36}, 1},
		{"logistic-transport-storehouse-down", "logistic-receiver-storehouse-lower", rl_below, pc_trans_chest, true, {tier = const.tier.advanced, size = 36}, 1},
		{"transport-warehouse-up", "receiver-warehouse-upper", rl_above, pc_trans_chest, true, {tier = const.tier.improved, size = 9}, 2},
		{"transport-warehouse-down", "receiver-warehouse-lower", rl_below, pc_trans_chest, true, {tier = const.tier.improved, size = 9}, 2},
		{"logistic-transport-warehouse-up", "logistic-receiver-warehouse-upper", rl_above, pc_trans_chest, true, {tier = const.tier.advanced, size = 9}, 2},
		{"logistic-transport-warehouse-down", "logistic-receiver-warehouse-lower", rl_below, pc_trans_chest, true, {tier = const.tier.advanced, size = 9}, 2}
	}
}
events.set_addon_data(addon_data)

-- control functions (on_init, on_load, on_config_changed)
local function on_init()
	init_globals()
end

local function on_load()
	init_globals()
end

local function on_configuration_changed()
	init_globals()
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