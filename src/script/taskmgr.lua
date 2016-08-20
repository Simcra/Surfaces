--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.api")
require("script.lib.struct-base")
require("script.lib.surfaces")
require("script.lib.util")
require("script.pair-util")

--[[--
Contains all task manager related functions.

@module taskmgr
]]
taskmgr = {}
taskmgr = require("script.taskmgr-data") -- inherit functions/variables from taskmgr-data

local tasks = const.taskmgr.task
local tasks_valid = const.taskmgr.task_valid

function taskmgr.exec()
	global.task_queue = global.task_queue or {}
	for k, v in pairs(global.task_queue) do
		util.debug("[taskmgr.exec()] task: " .. tasks_valid[v.task] .. ", data: " .. table.tostring(v.data, true))
		if v.task == tasks.trigger_create_paired_entity then										-- Validates the entity prior to creation of it's pair, gathering the relative location for the paired entity
			local _entity, _player_index = v.data.entity, v.data.player_index
			local _dest_surface = pairutil.validate_paired_entity(_entity, _player_index)
			if _dest_surface then
				taskmgr.insert(tasks.trigger_create_paired_surface, {_entity, _dest_surface,
					_player_index})																	-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.trigger_create_paired_surface then									-- Validates the paired surface, creating it if it does not yet exist
			local _entity, _pair_loc, _player_index = v.data.entity, v.data.pair_location, v.data.player_index
			local _surface = pairutil.create_paired_surface(_entity, _pair_loc)
			if _surface == nil then																	-- If the surface has not yet been created
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			elseif _surface ~= false then															-- Ensures that data passed is valid and if not, the task is simply removed from the queue
				api.surface.request_generate_chunks(_surface, api.position(_entity), 0)				-- Fixes a small bug with chunk generation
				taskmgr.insert(tasks.create_paired_entity, {_entity, _surface, _player_index})		-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.create_paired_entity then											-- Creates the paired entity
			local _entity, _surface, _player_index = v.data.entity, v.data.paired_surface, v.data.player_index
			local _pair_entity = pairutil.create_paired_entity(_entity, _surface)
			if _pair_entity == nil or _pair_entity == false then									-- If the pair fails to be created for some unknown reason
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			else																					-- Otherwise
				taskmgr.insert(tasks.finalize_paired_entity, {_entity, _pair_entity,_player_index})	-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.finalize_paired_entity then											-- Performs final processing for the paired entity (example: intersurface electric poles are connected to one another)
			pairutil.finalize_paired_entity(v.data.entity, v.data.paired_entity, v.data.player_index)
		elseif v.task == tasks.remove_sky_tile then													-- Remove tiles created by paired entities in sky surfaces, called after destruction of paired entities
			if not(api.valid(v.data.entity)) and not(api.valid(v.data.paired_entity)) then			-- Check if the two entities have been destroyed yet.
				pairutil.remove_tiles(v.data.position, v.data.surface, v.data.radius)				-- If they have, call remove tiles function with appropriate data for both.
				pairutil.remove_tiles(v.data.position, v.data.paired_surface, v.data.radius)
			else
				table.insert(global.task_queue, v)
			end
		elseif v.task == tasks.spill_entity_result then												-- Spill an itemstack on the ground, used to drop entity results on the ground where an invalid entity was placed
			if api.valid(v.data.entity) == false then
				for key, value in pairs(v.data.products) do
					if struct.is_SimpleItemStack(value) then
						api.surface.spill_items(v.data.surface, v.data.position, value)
					end
				end
			else
				table.insert(global.task_queue, v)
			end
		end
		table.remove(global.task_queue, k)															-- Remove the current task from the queue, it has finished executing
		break																						-- Exit loop, we have finished processing the first task in the queue
	end
end

return taskmgr