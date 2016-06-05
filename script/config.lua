--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

config={}
config.surface_type_underground="cavern"
config.surface_type_sky="platform"
config.surface_type_all="all"
config.surface_location_above="above"
config.surface_location_below="below"
config.pairclass_access_shaft="access-shaft"
config.pairclass_transport_chest="transport-chest"
config.pairclass_electric_pole="electric-pole"
config.pairclass_fluid_transport="fluid-transport"
config.pairclass_rail_transport="rail-transport"
config.entity_underground_wall="underground-wall"
config.tile_underground_floor="underground-floor"
config.tile_sky_floor="sky-floor"
config.tile_sky_concrete="sky-concrete"
config.surface_prefix="surfacesmod"
config.task_triggercreatepair="trigger-create-paired-entity"
config.task_triggercreatesurface="trigger-create-paired-surface"
config.task_triggercreateentity="trigger-create-entity"
config.task_createpair="create-paired-entity"
config.task_finishpair="finalize-paired-entity"
config.teleportation_time_waiting=20
config.teleportation_check_range=0.5
config.ticks_between_event={}
config.ticks_between_event["update_players_using_access_shafts"]=5
config.ticks_between_event["check_player_collision_with_access_shafts"]=2
config.ticks_between_event["update_transport_chest_contents"]=5
config.ticks_between_event["update_fluid_transport_contents"]=5
config.ticks_between_event["execute_first_task_in_waiting_queue"]=2
config.ticks_between_event["clear_ground_for_paired_entities"]=1