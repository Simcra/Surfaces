--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.api")

local tasks = const.taskmgr.task
local rl_valid = const.surface.rel_loc_valid

--[[--
Contains task manager data function and inherits task manager base functions.

@module taskmgr_data
]]
local taskmgr_data = {}
taskmgr_data = require("script.lib.taskmgr-base")

--[[--
constructs TaskData from provided data, data should be provided in a shorthand table without specified indexes, for example: {"a string", 4, {"a table with a string"}}

@param _id [Required] - the ID of the task, for example: <code>const.taskmgr.task.create\_paired\_entity</code>
@param _fields [Required] - the data to be formatted for usage, accepts a table of integer indexed entries
@return TaskData
]]
taskmgr_data.TaskData = function(_id,_fields)
	if _fields and taskmgr_data.is_TaskID(_id) then
		if _id == tasks.trigger_create_paired_entity then
			return api.valid({_fields[1]}) and {entity = _fields[1], player_index = _fields[2]} or nil
		elseif _id == tasks.trigger_create_paired_surface then
			return (api.valid({_fields[1], _fields[2]}) and rl_valid[_fields[2]]) and {entity = _fields[1], pair_location = _fields[2], player_index = _fields[3]} or nil
		elseif _id == tasks.create_paired_entity then
			return (api.valid({_fields[1], _fields[2]})) and {entity = _fields[1], paired_surface = _fields[2], player_index = _fields[3]} or nil
		elseif _id == tasks.finalize_paired_entity then
			return (api.valid({_fields[1], _fields[2]})) and {entity = _fields[1], paired_entity = _fields[2], player_index = _fields[3]} or nil
		elseif _id == tasks.remove_sky_tile then
			if api.valid({_fields[1], _fields[2]}) and type(_fields[3]) == "number" then
				local _entity = table.deepcopy(_fields[1])
				local _paired_entity = table.deepcopy(_fields[2])
				local _radius = table.deepcopy(_fields[3])
				return {entity = _entity, paired_entity = _paired_entity, position = api.position(_entity), _entity.surface, 
					paired_surface = _paired_entity and _paired_entity.surface or nil, radius = _radius}
			end
		elseif _id == tasks.spill_entity_result then
			if api.valid(_fields[1]) and type(_fields[2]) == "table" then
				local _entity = table.deepcopy(_fields[1])
				local _products = table.deepcopy(_fields[2])
				return {entity = _entity, surface = _entity.surface, position = api.position(_entity), products = _products}
			end
		end
	end
end

return taskmgr_data