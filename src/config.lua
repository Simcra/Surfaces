--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

config = {
	teleportation_check_range = 0.5,			-- [default: 0.5]		distance (in tiles) that players must be from the center of an access shaft for it to transport them
	teleportation_time_waiting = 20,			-- [default: 20]		time (in ticks, 60 ticks = 1 second) that players must stand still before teleportation will occur

	item_transport = {
		base_count = 4,							-- [default: 4]			base count of items moved during one transport cycle
		multiplier = {							-- multipliers for each different tier of transport chest
			crude = 0.25,						-- [default: 0.25]		crude (wooden chests)
			basic = 0.5,						-- [default: 0.5]		basic (iron chests)
			standard = 0.75,					-- [default: 0.75]		standard
			improved = 1,						-- [default: 1]			improved (steel chests)
			advanced = 1.25						-- [default: 1.25]		advanced (logistic chests)
		}
	},
	--[[
	These are all quite experimental and alter core behaviour of this mod
	Larger values mean checks are performed less often (improves performance at expense of functionality)
	Though the
	]]
	ticks_between_event = {
		update_players_using_access_shafts = 5,					-- [default: 5]		- Access shaft teleportation check
		check_player_collision_with_access_shafts = 2,			-- [default: 2]		- Access shaft collision check
		update_transport_chest_contents = 5,					-- [default: 5]		- Moves items from transport chests into paired receiver chests
		update_fluid_transport_contents = 5,					-- [default: 5]		- Equalizes fluid in fluid transport tanks
		execute_first_task_in_waiting_queue = 2					-- [default: 2]		- Used primarily in the creation of paired entities, lower values are better
	}
}
