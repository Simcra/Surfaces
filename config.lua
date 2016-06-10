--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

config = {
	teleportation_check_range = 0.5,			-- distance (in tiles) that players must be from the center of an access shaft for it to transport them
	teleportation_time_waiting = 20,			-- time (in ticks, 60 ticks = 1 second) that players must stand still before teleportation will occur
	
	-- Larger values mean checks are performed less often (not always a good thing)
	ticks_between_event = { -- These are all quite experimental, I'd suggest against modifying them unless you are having significant lag.
		update_players_using_access_shafts = 5,					-- Access shaft teleportation check, should be set no lower than 5
		check_player_collision_with_access_shafts = 2,			-- Access shaft collision check, should be set as low as possible but no lower than 2
		update_transport_chest_contents = 5,						-- Moves items from transport chests into paired receiver chests, should be set to no lower than 3
		update_fluid_transport_contents = 5,						-- Equalizes fluid in fluid transport tanks, should be set to no lower than 5
		execute_first_task_in_waiting_queue = 2}					-- Used primarily in the creation of paired entities, should not be set any higher than 4
}