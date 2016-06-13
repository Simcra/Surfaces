--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")

--[[
Note: This is NOT a configuration file, nor are any files other than config.lua! 

If you alter anything in this script you will most likely break your save game and/or your version of the mod.
]]

enum = {
	prefix = "surfacesmod",
	surface = {
		type = {
			underground = {
				id = 1,
				name = "cavern"
			},
			sky = {
				id = 2,
				name = "platform"
			},
			all = {
				id = 3,
				name = "all"
			}
		},
		rel_loc = {
			above = 1,
			below = 2
		}
	},
	eventmgr = {
		task = {
			trigger_create_paired_entity = 1,
			trigger_create_paired_surface = 2,				
			create_paired_entity = 3,
			finalize_paired_entity = 4
		},
		handle = {
			access_shaft_teleportation = {
				id = 1,
				tick = config.ticks_between_event.update_players_using_access_shafts,
				func = "update_players_using_access_shafts"
			},
			access_shaft_update = {
				id = 2,
				tick = config.ticks_between_event.check_player_collision_with_access_shafts,
				func = "check_player_collision_with_access_shafts"
			},
			transport_chest_update = {
				id = 3,
				tick = config.ticks_between_event.update_transport_chest_contents,
				func = "update_transport_chest_contents"
			},
			fluid_transport_update = {
				id = 4,
				tick = config.ticks_between_event.update_fluid_transport_contents,
				func = "update_fluid_transport_contents"
			},
			taskmgr = {
				id = 5,
				tick = config.ticks_between_event.execute_first_task_in_waiting_queue,
				func = "execute_first_task_in_waiting_queue"
			}
		}
	},
	prototype = {
		entity = {
			underground_wall = {
				id = 1,
				name = "underground-wall",
				type = "tree"
			},
			access_shaft = {
				type = "simple-entity"
			}
		},
		tile = {
			underground_floor = {
				id = 1,
				name = "underground-floor"
			},
			sky_floor = {
				id = 2,
				name = "sky-floor"
			},
			sky_concrete = {
				id = 3,
				name = "sky-concrete"
			}
		}
	},
	wire = {
		copper = 1,
		red = 2,
		green = 3,
		all = 4
	}
}