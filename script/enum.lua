--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.util")

--[[
Note: This is NOT a configuration file, nor are any files other than config.lua! 

If you alter anything in this script you will most likely break your save game and/or your version of the mod.
]]
enum = {
	prefix = "surfacesmod",
	max_int = 4294967295,
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
			finalize_paired_entity = 4,
			remove_sky_tile = 5,
			spill_entity_result = 6
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
				name = "underground-wall",
				type = "tree",
				hardness = 2,
				mining_time = 4,
				order = "z-a[surfaces]-a[underground-wall]",
				map_colour = util.RGB(60, 52, 36),
				resistances = {
					{type = "impact", percent = 80},
					{type = "physical", percent = 5},
					{type = "poison", percent = 100},
					{type = "fire", percent = 100},
					{type = "acid", percent = 95},
					{type = "explosion", percent = 5}
				}
			},
			access_shaft = {
				type = "simple-entity",
				mining_time = 8,
				order = "z-a[surfaces]-a[access-shaft]",
				map_colour = util.RGB(127, 88, 43, 50),
				resistances = {
					{type = "physical", percent = 20},
					{type = "impact", percent = 20},
					{type = "poison", percent = 100},
					{type = "fire", percent = 5},
					{type = "acid", percent = 15}
				}
			}
		},
		tile = {
			underground_floor = {
				name = "underground-floor",
				walking_speed_modifier = 0.8,
				layer = 57,
				map_colour = util.RGB(107, 44, 4)
			},
			sky_floor = {
				name = "sky-floor",
				layer = 58,
				map_colour = util.RGB(145, 212, 252)
			},
			sky_concrete = {
				name = "sky-concrete",
				layer = 59
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