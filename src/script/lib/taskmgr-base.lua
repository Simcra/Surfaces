--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.api")

--[[--
Contains common task manager functions.

@module taskmgr_base
]]

local taskmgr_base = {}

function taskmgr_base.insert(_id, _data)
	global.task_queue = global.task_queue or {}
	if taskmgr_base.is_TaskID(_id) then
		table.insert(global.task_queue, {task = _id, data = taskmgr_base.TaskData(_id, _data)})
	end
end

--[[--
is this a valid Task ID?

@param _id [Required] - the Task ID to test
@return <code>true</code> or <code>false</code>
]]
function taskmgr_base.is_TaskID(_id)
	return (type(_id) == "number" and const.taskmgr.task_valid[_id] ~= nil)
end

--[[--
<b>[Abstract] </b>
constructs TaskData from provided data, data should be provided in a shorthand table without specified indexes, for example: {"a string", 4, {"a table with a string"}}

@param _id [Required] - the ID of the task, for example: <code>const.taskmgr.task.create\_paired\_entity</code>
@param _fields [Required] - the data to be formatted for usage, accepts a table of integer indexed entries
@return TaskData
]]
function taskmgr_base.TaskData(_id, _fields)

end

return taskmgr_base