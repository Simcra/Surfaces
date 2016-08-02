--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util-base")

--[[--
Structures module, used to construct and validate data for use with the LuaAPI and surfaces mod.
Functions in this module may be used during the data loading phase.

@module struct_base
]]
local struct_base = {}

--[[--
contains default PicturePriority and a table of valid PicturePriorities
]]
local PicturePriority = {
	valid = table.reverse({"extra-low", "low", "medium", "high", "extra-high"}),
	default = "medium"
}

--[[--
Constructs Picture from provided parameters

@param _filename [Required] - the filename for the image, example: "__Surfaces__/graphics/terrain/underground-dirt-main.png"
@param _priority [Optional] - a PicturePriority
@param _width [Optional] - a number value, represents the width of the image (in pixels)
@param _height [Optional] - a number value, represents the height of the image (in pixels)
@param _frames [Optional] - a number value, represents the number of frames in the image
@param _direction_count [Optional] - a number value, represents the number of directions 
@param _shift [Optional] - a Position
@return Picture
]]
function struct_base.Picture(_filename, _priority, _width, _height, _frames, _direction_count, _shift)
	local _result = {filename = _filename, priority = struct_base.is_PicturePriority(_priority) == true and _priority or PicturePriority.default}
	if type(_width) == "number" and _width >= 1 then _result.width = math.round(_width) end
	if type(_height) == "number" and _height >= 1 then _result.height = math.round(_height) end
	if type(_frames) == "number" and _frames >= 1 then _result.frames = math.round(_frames) end
	if type(_direction_count) == "number" and _direction_count >= 1 then _result.direction_count = math.round(_direction_count) end
	if struct_base.is_Position(_shift) then _result.shift = _shift end
	return _result
end

--[[--
Constructs storage tank Pictures from provided Picture parameters

@param _picture_sheet [Optional] - a Picture construct, if not specified will be blank
@param _fluid_background [Optional] - a Picture construct, if not specified will be blank
@param _window_background [Optional] - a Picture construct, if not specified will be blank
@param _flow_sprite [Optional] - a Picture construct, if not specified will be blank
@return StorageTankPictures
]]
function struct_base.StorageTankPictures(_picture_sheet, _fluid_background, _window_background, _flow_sprite)
	return {
		picture = {sheet = struct_base.is_Picture(_picture_sheet) == true and _picture_sheet or const.pictures.blank},
		fluid_background = struct_base.is_Picture(_fluid_background) == true and _fluid_background or const.pictures.blank,
		window_background = struct_base.is_Picture(window_background) == true and window_background or const.pictures.blank,
		flow_sprite = struct_base.is_Picture(flow_sprite) == true and flow_sprite or const.pictures.blank
	}
end

--[[--
Is this a valid PicturePriority?

@param _priority [Required] - the priority to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_PicturePriority(_priority)
	return _priority and (PicturePriority.valid[_priority] == true)
end

--[[--
Is this a valid Picture?

@param _picture [Required] - the picture to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_Picture(_picture)
	return (type(_picture) == "table" and type(_picture.filename) == "string" and struct_base.is_PicturePriority(_picture.priority) == true) and true or false
end

--[[--
Constructs picture Variant from provided parameters

@param _picture [Required] - the filename for the image, example: "__Surfaces__/graphics/terrain/underground-dirt-main.png"
@param _count [Optional] - a number value, represents the number of frames per row
@param _size [Optional] - a number value, represents the number of rows in the image
@param _probability [Optional] - a number value
@return Variant
]]
function struct_base.Variant(_picture, _count, _size, _probability)
	local _result = {picture = _picture}
	if type(_count) == "number" and _count >= 0 then _result.count = _count end
	if type(_size) == "number" and _size >= 0 then _result.size = _size end
	if type(_probability) == "number" and _probability > 0 and _probability <= 1 then _result.probability = _probability end
	return _result
end

--[[--
Constructs Sound data from provided parameters

@param _filename [Required] - the filename for the sound file, example: "__base__/sound/car-metal-impact.ogg"
@param _volume [Optional] - a number value, represents the volume of the sound for playback
@return Sound
]]
function struct_base.Sound(_filename, _volume)
	local _sound = {filename = _filename}
	if type(_volume) == "number" and _volume > 0 then _sound.volume = _volume end
	return _sound
end

--[[--
Constructs a BoundingBox from provided parameters

@param _x1 [Required] - a number value, represents the location of the top left corner on the x axis.
@param _y1 [Required] - a number value, represents the location of the top left corner on the y axis.
@param _x2 [Required] - a number value, represents the location of the bottom right corner on the x axis.
@param _y2 [Required] - a number value, represents the location of the bottom right corner on the y axis.
@return BoundingBox
]]
function struct_base.BoundingBox(_x1, _y1, _x2, _y2)
	local _result = nil
	if type(_x1) == "number" and type(_y1) == "number" and type(_x2) == "number" and type(_y2) == "number" then
		_result = {left_top = struct_base.Position(_x1, _y1), right_bottom = struct_base.Position(_x2, _y2)}
	end
	return _result
end

--[[--
Constructs a Position from provided parameters

@param _x [Required] - a number value, represents the location on the x axis.
@param _y [Required] - a number value, represents the location on the y axis.
@return Position
]]
function struct_base.Position(_x, _y)
	local _result = nil
	if type(_x) == "number" and type(_y) == "number" then
		_result = {x = _x, y = _y}
	end
	return _result
end

--[[--
Constructs a SimpleItemStack from provided parameters

@param _name [Required] - a valid item prototype name
@param _count [Optional] - a number value representing the number of items in this stack
@param _health [Optional] - a number value representing the durability of this item
@return SimpleItemStack
]]
function struct_base.SimpleItemStack(_name, _count, _health)
	return type(_name) == "string" and {name = _name, count = type(_count) == "number" and _count or 1, health = type(_health) == "number" and _health or 1} or nil
end

--[[--
Constructs a table of ResistancesProfiles from provided table

@param _resistances [Required] - a table of resistance profiles or shorthand, for example: {{"impact", 25, 4}}
@return Resistances
]]
function struct_base.Resistances(_resistances)
	if type(_resistances) == "table" then
		local _result = {}
		for k, v in pairs(_resistances) do
			if struct_base.is_ResistanceProfile(v) and v.type then
				_result[v.type] = struct_base.ResistanceProfile(v.type, v.percent, v.decrease)
			elseif type(v) == "table" and type(v[1]) == "string" then
				_result[v[1]] = struct_base.ResistanceProfile(v[1], v[2],v[3])
			end
		end
		return _result
	end
end

--[[--
Constructs a ResistanceProfile from provided parameters, only one of _decrease and _percentage is required, the other may be omitted if necessary. 

@param _type [Optional] - a string value associated with a damage type, for example: "impact", or nil.
@param _percentage [Optional] - a number value between 0 and 100, any values greater than 100 will be corrected.
@param _decrease [Optional] - a number value, used to provide a static decrease (prior to percentage calculation) for this resistance type
@return ResistanceProfile
]]
function struct_base.ResistanceProfile(_type, _percentage, _decrease)
	local _has_percentage, _has_decrease = (type(_percentage) == "number"), (type(_decrease) == "number")
	if _has_percentage or _has_decrease then
		local _resistance = {}
		if type(_type) == "string" then _resistance.type = _type end			
		if _has_percentage then _resistance.percent = (_percentage > 100) and 100 or _percentage end
		if _has_decrease then _resistance.decrease = _decrease end
		return _resistance
	end
end

--[[--
Is this a valid ResistanceProfile?

@param _resistance [Required] - a resistance profile to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_ResistanceProfile(_resistance)
	if type(_resistance) == "table" then
		return (type(_resistance.decrease) == "number" or (type(_resistance.percent) == "number"
			and _resistance.percent <= 100 and _resistance.percent > 0))
	end
	return false
end

--[[--
Is this a valid Position?

@param _position [Required] - a position to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_Position(_position)
	return (_position and type(_position.x) == "number" and type(_position.y) == "number")
end

--[[--
Is this a valid BoundingBox?

@param _boundingbox [Required] - a bounding box to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_BoundingBox(_boundingbox)
	return (_boundingbox and struct_base.is_Position(_boundingbox.left_top) and struct_base.is_Position(_boundingbox.right_bottom))
end

--[[--
Is this a valid SimpleItemStack?

@param _itemstack [Required] - an itemstack to test
@return <code>true</code> or <code>false</code>
]]
function struct_base.is_SimpleItemStack(_itemstack)
	return (_itemstack and type(_itemstack.name) == "string" and type(_itemstack.count) == "number")
end

return struct_base
