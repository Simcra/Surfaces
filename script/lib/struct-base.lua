--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util-base")

struct = {}

function struct.Picture(_filename, _priority, _width, _height, _frame_count, _direction_count, _shift)
	local result = {filename = _filename, priority = _priority, width = _width, height = _height}
	if type(_frame_count) == "number" and _frame_count >= 1 then result.frame_count = _frame_count end
	if type(_direction_count) == "number" and _direction_count >= 1 then result.direction_count = _direction_count end
	if struct.is_Position(_shift) then result.shift = _shift end
	return result
end

function struct.Sound(_filename, _volume)
	local sound = {filename = _filename}
	if type(_volume) == "number" and _volume > 0 then sound.volume = _volume end
	return sound
end

function struct.BoundingBox(_x1, _y1, _x2, _y2)
	return (_x1 and _y1 and _x2 and _y2) and {left_top = struct.Position(_x1, _y1), right_bottom = struct.Position(_x2, _y2)} or nil
end

function struct.Position(_x, _y)
	return (_x and _y) and {x = _x, y = _y} or nil
end

function struct.ItemStack(_name, _count, _health)
	return _name and {name = _name, count = _count or 1, health = _health or 1} or nil
end

function struct.Resistances(_data)
	if type(_data) == "table" then
		local _resistances = {}
		for k, v in pairs(_data) do
			if struct.is_ResistanceProfile(v) then
				table.insert(_resistances, v)
			elseif type(v) == "table" and type(v[1]) == "string" then
				table.insert(_resistances, struct.ResistanceProfile(v[1], v[2], v[3]))
			end
		end
		return _resistances
	end
end

function struct.ResistanceProfile(_type, _percent, _decrease)
	if type(_type) == "string" then
		local _resistance = {type = _type}
		if type(_percent) == "number" then _resistance.percent = (_percent > 100) and 100 or _percent end
		if type(_decrease) == "number" then _resistance.decrease = _decrease end
		return _resistance
	end
end

function struct.is_ResistanceProfile(_resistance)
	if type(_resistance) == "table" then
		local has_percent, has_decrease = _resistance.percent ~= nil, _resistance.decrease ~= nil
		if _resistance.type ~= nil and (has_percent or has_decrease) then
			if has_percent and has_decrease then
				if type(_resistance.percent) ~= "number" or _resistance.percent > 100 then return false end
				if type(_resistance.decrease) ~= "number" then return false end
			elseif has_percent then
				if type(_resistance.percent) ~= "number" or _resistance.percent > 100 then return false end
			elseif has_decrease then
				if type(_resistance.decrease) ~= "number" then return false end
			else
				return false
			end
			return true
		end
	end
	return false
end

function struct.is_Position(_position)
	return (_position and type(_position.x) == "number" and type(_position.y) == "number")
end

function struct.is_BoundingBox(_area)
	return (_area and struct.is_Position(_area.left_top) and struct.is_Position(_area.right_bottom))
end

function struct.is_ItemStack(_itemstack)
	return (_itemstack and type(_itemstack.name) == "string" and type(_itemstack.count) == "number")
end