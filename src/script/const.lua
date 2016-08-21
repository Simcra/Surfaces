--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.lib.util-base")

--[[--
Holds constant data that is shared between modules

@module const
]]
local _const = {
	--- Are we in debug mode?
	debug = false,
	--- Maximum unsigned integer value, used for random seeding in mapgensettings.
	max_uint = 4294967295,
	--- Surfaces data, stores various constant data for surfaces, such as: prefix (<code>const.surface.prefix</code>),
	-- relative locations (<code>const.surface.rel\_loc</code>), surface types (<code>const.surface.type</code>),
	-- tiles to overriden during chunk corrections (<code>const.surface.override\_tiles</code>),
	-- and the surface separator string (<code>const.surface.separator</code>) 
	surface = {
		-- Every surface created by this mod will be prefixed with this tag, it must not be changed or saves will be broken.
		prefix = "surfacesmod",
		-- Separator string, used to construct surfaces, if this is changed, surfaces will need to be migrated.
		separator = "-",
		-- Tiles that will be overridden during Surfaces chunk corrections
		override_tiles = {["out-of-map"] = true, ["grass"] = true, ["grass-medium"] = true, ["grass-dry"] = true, ["dirt"] = true, ["dirt-dark"] = true,
			["sand"] = true, ["sand-dark"] = true, ["water"] = true, ["deepwater"] = true, ["water-green"] = true, ["deepwater-green"] = true},
		-- Surface type classification, the surfaces module uses this information to identify surfaces from this mod. Each entry contains both an ID and a name.
		type = {
			underground = {id = 1, name = "cavern"},
			sky = {id = 2, name = "platform"},
			all = {id = 3, name = "all"}
		},
		-- Relative location, used in surfaces module and pairutil module for dimensional logic.
		rel_loc = {above = 1, below = 2}
	},
	-- chunkgen data (used to determine delay between initial on_chunk_generated event and post_chunk_generated event)
	chunkgen = {delay = 60, rand = 30},
	-- Event Manager data
	eventmgr = {
		-- Handle definitions, these are used to call functions from within the on_tick timer in the events module
		handle = {
			-- Used to update transport chest contents, moves items from transport chests to receiver chests
			item_transport_update = {id = 1, tick = 5, func = "transport_item_process"},
			-- Used to update intersurface fluid tank contents
			fluid_transport_update = {id = 2, tick = 2, func = "transport_fluid_process"},
			-- Used to update intersurface accumulator contents
			energy_transport_update = {id = 3, tick = 2, func = "transport_energy_process"},
			-- Raises events using on_tick timer, this way events may be called after a specific number of ticks have passed
			raise_event_timer = {id = 4, tick = 5, func = "raise_events"},
			-- Used to execute the first task in the Task Manager queue
			taskmgr_update = {id = 5, tick = 2, func = "taskmgr_execute"},
			-- Inspects the global surface migrations table for entries, processing in a serial manner, similar to the task queue
			surface_migrations_update = {id = 6, tick = 30, func = "surfaces_migrations"}
		}
	},
	-- Task Manager data
	taskmgr = {
		-- Task definitions, used to uniquely identify each process in the task manager
		task = {
			trigger_create_paired_entity = 1,
			trigger_create_paired_surface = 2,
			create_paired_entity = 3, 
			finalize_paired_entity = 4,
			remove_sky_tile = 5,
			spill_entity_result = 6
		}
	},
	-- Wire definitions, used to determine which wires to connect when placing paired entities
	wire = {
		copper = 1,
		red = 2,
		green = 3,
		circuit = 4,
		all = 5
	},
	-- Tiers available for transport chests, will also be used for other purposes in the future
	tier = {
		crude = 1,
		basic = 2,
		standard = 3,
		improved = 4,
		advanced = 5
	}
}

-- index table for <code>const.eventmgr.task</code>
_const.taskmgr.task_valid = table.reverse(_const.taskmgr.task, true)
-- index table for <code>const.tier</code>
_const.tier_valid = table.reverse(_const.tier, true)
-- index table for <code>const.surface.type</code>
_const.surface.type_valid = table.reverse(_const.surface.type, true, "id")
-- index table for <code>const.surface.rel_loc</code>
_const.surface.rel_loc_valid = table.reverse(_const.surface.rel_loc, true)

const = _const
const = table.readonly(_const)

return const
