--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.struct-base")
require("script.lib.util-base")

--[[
Note: This is NOT a configuration file! Data in this file CAN and most probably WILL break your savegame if modified.
]]
const = {
	prefix = "surfacesmod", -- Every surface created by this mod will be prefixed with this tag, it must not be changed or saves will be broken.
	max_int = 4294967295,
	surface = {	
		type = { -- Surface type classification, surfaces utilizing this mod must be one of these specifications.
			underground = {
				id = 1,
				name = "cavern"
			},
			sky = {
				id = 2,
				name = "platform"
			},
			all = { -- this does not classify "all" surfaces, only surface types specified in this mod.
				id = 3,
				name = "all"
			}
		},
		rel_loc = { -- Relative location, used in surfaces module to reduce human error.
			above = 1,
			below = 2
		}
	},
	eventmgr = { -- Event Manager
		task = { -- Task definitions, used to uniquely identify each "task"
			trigger_create_paired_entity = 1,
			trigger_create_paired_surface = 2,				
			create_paired_entity = 3,
			finalize_paired_entity = 4,
			remove_sky_tile = 5,
			spill_entity_result = 6
		},
		handle = { -- Handle definitions, these handles are used to call functions from within the on_tick timer in events.lua
			access_shaft_teleportation = { -- Used to teleport players between surfaces once configured waiting time has passed, see config.lua
				id = 1,
				tick = config.ticks_between_event.update_players_using_access_shafts,
				func = "update_players_using_access_shafts"
			},
			access_shaft_update = { -- Used to check each player for a nearby access shaft, prior to teleportation.
				id = 2,
				tick = config.ticks_between_event.check_player_collision_with_access_shafts,
				func = "check_player_collision_with_access_shafts"
			},
			transport_chest_update = { -- Used to update transport chest contents, moves items from transport chests to receiver chests
				id = 3,
				tick = config.ticks_between_event.update_transport_chest_contents,
				func = "update_transport_chest_contents"
			},
			fluid_transport_update = { -- Used to update intersurface fluid tank contents
				id = 4,
				tick = config.ticks_between_event.update_fluid_transport_contents,
				func = "update_fluid_transport_contents"
			},
			taskmgr = { -- Used to execute the first task in the Task Manager queue
				id = 5,
				tick = config.ticks_between_event.execute_first_task_in_waiting_queue,
				func = "execute_first_task_in_waiting_queue"
			}
		}
	},
	wire = { -- Wire definitions, used in util-api module for electric pole pairing (and potentially other things)
		copper = 1,
		red = 2,
		green = 3,
		circuit = 4,
		all = 5
	},
	tier = {
		crude = 1,
		basic = 2,
		standard = 3,
		improved = 4,
		advanced = 5
	},
	pictures = {
		blank = struct.Picture("__base__/graphics/terrain/blank.png", "extra-high", 32, 32),
		pipecovers = {
			north = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-north.png", "extra-high", 44, 32),
			east = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-east.png", "extra-high", 32, 32),
			south = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-south.png", "extra-high", 46, 52),
			west = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-west.png", "extra-high", 32, 32)
		}
	},
	sounds = {
		resource_mining = {
			struct.Sound("__core__/sound/axe-mining-ore-1.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-2.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-3.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-4.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-5.ogg", 1.0)
		}
	}
}
const.eventmgr.task_valid = table.reverse(const.eventmgr.task)