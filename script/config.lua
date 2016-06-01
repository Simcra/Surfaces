--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

surface_type_underground="cavern"
surface_type_sky="platform"
surface_type_all="all"
surface_location_above="above"
surface_location_below="below"
pairclass_access_shaft="access-shaft"
pairclass_transport_chest="transport-chest"
pairclass_electric_pole="electric-pole"
pairclass_fluid_transport="fluid-transport"
pairclass_rail_transport="rail-transport"
entity_underground_wall="underground-wall"
tile_underground_floor="underground-floor"
tile_sky_floor="sky-floor"
tile_sky_concrete="sky-concrete"
surface_prefix="surfacesmod"
task_triggercreatepair="trigger-create-paired-entity"
task_triggercreatesurface="trigger-create-paired-surface"
task_triggercreateentity="trigger-create-entity"
task_createpair="create-paired-entity"
task_finishpair="finalize-paired-entity"
teleportation_time_waiting=20
teleportation_check_range=0.5
ticks_between_event={}
ticks_between_event["update_players_using_access_shafts"]=5
ticks_between_event["check_player_collision_with_access_shafts"]=2
ticks_between_event["update_transport_chest_contents"]=5
ticks_between_event["update_fluid_transport_contents"]=5
ticks_between_event["execute_first_task_in_waiting_queue"]=2
ticks_between_event["create_entities_in_waiting_queue"]=1