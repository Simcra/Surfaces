--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.util-base")
local struct = require("script.lib.struct-base")


-- Note: This is NOT a configuration file! Data in this file CAN and most probably WILL break your savegame if modified.

local function create_id_table(_indexes)
	local _count, _table = 0, {}
	for k, v in pairs(_indexes) do
		_count = _count + 1
		_table[v] = _count
	end
	return _table
end


--[[--
Holds constant data that is shared between modules

@module const
]]
const = {
	-- Every surface created by this mod will be prefixed with this tag, it must not be changed or saves will be broken.
	prefix = "surfacesmod",
	-- Maximum unsigned integer value, used for random seeding in mapgen.
	max_uint = 4294967295,
	-- Surfaces data
	surface = {
		-- Surface type classification, the surfaces module uses this information to identify surfaces from this mod. Each entry contains both an ID and a name.
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
		-- Relative location, used in surfaces module and pairutil module for dimensional logic.
		rel_loc = create_id_table({"above", "below"})
	},
	-- Event Manager data
	eventmgr = {
		-- Task definitions, used to uniquely identify each "task" in the event manager
		task = create_id_table({"trigger_create_paired_entity", "trigger_create_paired_surface", "create_paired_entity", "finalize_paired_entity", "remove_sky_tile", "spill_entity_result"}),
		-- Handle definitions, these are used to call functions from within the on_tick timer in the events module
		handle = {
			-- Used to teleport players between surfaces once configured waiting time has passed, see config.lua
			access_shaft_teleportation = {
				id = 1,
				tick = config.ticks_between_event.update_players_using_access_shafts,
				func = "update_players_using_access_shafts"
			},
			-- Used to check each player for a nearby access shaft, prior to teleportation.
			access_shaft_update = {
				id = 2,
				tick = config.ticks_between_event.check_player_collision_with_access_shafts,
				func = "check_player_collision_with_access_shafts"
			},
			-- Used to update transport chest contents, moves items from transport chests to receiver chests
			transport_chest_update = {
				id = 3,
				tick = config.ticks_between_event.update_transport_chest_contents,
				func = "update_transport_chest_contents"
			},
			-- Used to update intersurface fluid tank contents
			fluid_transport_update = {
				id = 4,
				tick = config.ticks_between_event.update_fluid_transport_contents,
				func = "update_fluid_transport_contents"
			},
			-- Used to execute the first task in the Task Manager queue
			taskmgr = {
				id = 5,
				tick = config.ticks_between_event.execute_first_task_in_waiting_queue,
				func = "execute_first_task_in_waiting_queue"
			}
		}
	},
	-- Wire definitions, used to determine which wires to connect when placing paired entities
	wire = create_id_table({"copper", "red", "green", "circuit", "all"}),
	-- Pictures, used to reduce the amount of duplicate code in prototype definitions
	pictures = {
		blank = struct.Picture("__base__/graphics/terrain/blank.png", "extra-high", 32, 32),
		pipecovers = {
			north = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-north.png", "extra-high", 44, 32),
			east = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-east.png", "extra-high", 32, 32),
			south = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-south.png", "extra-high", 46, 52),
			west = struct.Picture("__base__/graphics/entity/pipe-covers/pipe-cover-west.png", "extra-high", 32, 32)
		}
	},
	-- Sounds, used to reduce the amount of duplicate code in prototype definitions
	sounds = {
		resource_mining = {
			struct.Sound("__core__/sound/axe-mining-ore-1.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-2.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-3.ogg", 1.0),
			struct.Sound("__core__/sound/axe-mining-ore-4.ogg", 1.0),
			struct.Sound("__core__/sound/axe-(.ogg", 1.0)
		},
		stone_impact = struct.Sound("__base__/sound/car-stone-impact.ogg", 1.0)
	},
	-- Tiles that will be overridden during Surfaces chunk corrections
	override_tiles = table.reverse({"out-of-map", "grass", "grass-medium", "grass-dry", "dirt", "dirt-dark", "sand", "sand-dark", "water", "deepwater", "water-green", "deepwater-green"}),
	-- Tiers available for transport chests, will also be used for other purposes in the future
	tier = create_id_table({"crude", "basic", "standard", "improved", "advanced"})
}

-- index table for <code>const.eventmgr.task</code>
const.eventmgr.task_valid = table.reverse(const.eventmgr.task, true)
-- index table for <code>const.tier</code>
const.tier_valid = table.reverse(const.tier, true)
-- index table for <code>const.surface.type</code>
const.surface.type_valid = table.reverse(const.surface.type, true, "id")
-- index table for <code>const.surface.rel_loc</code>
const.surface.rel_loc_valid = table.reverse(const.surface.rel_loc, true)

return const
