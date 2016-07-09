--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util-base")

struct = {}

function struct.Picture(_filename, _priority, _width, _height, _frames, _direction_count, _shift)
	local _result = {filename = _filename, priority = _priority, width = _width, height = _height}
	if type(_frames) == "number" and _frames >= 1 then _result.frames = _frames end
	if type(_direction_count) == "number" and _direction_count >= 1 then _result.direction_count = _direction_count end
	if struct.is_Position(_shift) then _result.shift = _shift end
	return _result
end

function struct.Variant(_picture, _count, _size, _probability)
	local _result = {picture = _picture}
	if type(_count) == "number" and _count >= 0 then _result.count = _count end
	if type(_size) == "number" and _size >= 0 then _result.size = _size end
	if type(_probability) == "number" and _probability > 0 and _probability <= 1 then _result.probability = _probability end
	return _result
end

function struct.Sound(_filename, _volume)
	local _sound = {filename = _filename}
	if type(_volume) == "number" and _volume > 0 then _sound.volume = _volume end
	return _sound
end

function struct.BoundingBox(_x1, _y1, _x2, _y2)
	return (type(_x1) == "number" and type(_y1) == "number" and type(_x2) == "number" and type(_y2) == "number") and {left_top = struct.Position(_x1, _y1), right_bottom = struct.Position(_x2, _y2)} or nil
end

function struct.Position(_x, _y)
	return (type(_x) == "number" and type(_y)=="number") and {x = _x, y = _y} or nil
end

function struct.ItemStack(_name, _count, _health)
	return type(_name) == "string" and {name = _name, count = type(_count) == "number" and _count or 1, health = type(_health) == "number" and _health or 1} or nil
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
		local _percent, _decrease, _type = _resistance.percent, _resistance.decrease, _resistance.type
		if type(_type) == "string" and (_decrease or _percent) then
			if type(_percent) == "number" and _percent <= 100 and (_decrease == nil or type(decrease) == "number") then
				return true
			elseif type(_decrease) == "number" and (_percent == nil or (type(_percent) == "number" and _percent <= 100 and _percent > 0)) then
				return true
			end
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