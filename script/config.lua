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
surface_pairclass_access_shaft="access-shaft"
surface_pairclass_transport_chest="transport-chest"
surface_entity_underground_wall="underground-wall"
surface_tile_underground_floor="underground-floor"
surface_tile_sky_floor="sky-floor"
surface_tile_sky_concrete="sky-concrete"
surface_prefix="surfacesmod"
surface_task_triggercreatepair="trigger-create-paired-entity"
surface_task_triggercreatesurface="trigger-create-paired-surface"
surface_task_createpair="create-paired-entity"
surface_task_finishpair="finalize-paired-entity"
time_required_for_teleportation=60
ticks_between_event={}
ticks_between_event["update_players_using_access_shafts"]=5
ticks_between_event["check_player_collision_with_access_shafts"]=2
ticks_between_event["update_transport_chest_contents"]=5
ticks_between_event["execute_first_task_in_waiting_queue"]=2