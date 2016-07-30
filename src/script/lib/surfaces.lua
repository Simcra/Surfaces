--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.const")
require("script.lib.api")
require("script.lib.pair-data")
require("script.lib.struct")
require("script.lib.util")
require("script.proto")

--[[--
Surfaces module, used for all surface related functionality

@module surfaces
]]
surfaces = {}

-- declaring local functions, these are defined at the bottom of the file
local get_relative_surface, create_relative_surface, get_mapname, is_valid, is_valid_type, get_map_gen_settings, create_surface, get_type

-- declaring local variables
local mapgensettings = nil
local rl_above, rl_below = const.surface.rel_loc.above, const.surface.rel_loc.below
local st_und, st_sky = const.surface.type.underground, const.surface.type.sky
local et_acc_shaft = proto.get_field({"entity", "access_shaft", "common"}, "type")

--[[--
was this surface created by this mod?

@param _surface [Required] - the surface to test
@return <code>true</code> or <code>false</code>
]] 
function surfaces.is_from_this_mod(_surface)
	return _surface and string.find(api.name(_surface), const.prefix .. "-", 0, true) ~= nil or nil
end

--[[--
returns the layer of this surface relative to the nauvis layer. (the first underground surface is layer one and the first platform surface is also layer one)

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return surface layer
]]
function surfaces.get_layer(_surface)
	local _surface_name = api.name(_surface)
	if _surface_name == "nauvis" then
		return 0
	else
		local _surface_string = const.prefix .. "-" .. const.surface.type[const.surface.type_valid[get_type(_surface_name)]].name .. "-"
		return tonumber(string.sub(_surface_name, string.find(_surface_name, _surface_string, 0, true) + string.len(_surface_string)))
	end
end

--[[--
is this surface below the nauvis layer?

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return <code>true</code> or <code>false</code>
]]
function surfaces.is_below_nauvis(_surface)
	return get_type(_surface) == st_und.id
end

--[[--
is this surface above the nauvis layer?

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return <code>true</code> or <code>false</code>
]]
function surfaces.is_above_nauvis(_surface)
	return get_type(_surface) == st_sky.id
end

--[[--
returns the surface below this surface, assuming that one exists.

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return surface
]]
function surfaces.get_surface_below(_surface)
	return get_relative_surface(_surface, rl_below)
end

--[[--
returns the surface above this surface, assuming that one exists.

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return surface
]]
function surfaces.get_surface_above(_surface)
	return get_relative_surface(_surface, rl_above)
end

--[[--
creates a surface below this surface and returns the created surface.

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return surface
]]
function surfaces.create_surface_below(_surface)
	return create_relative_surface(_surface, rl_below)
end

--[[--
creates a surface above this surface and returns the created surface.

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return surface
]]
function surfaces.create_surface_above(_surface)
	return create_relative_surface(_surface, rl_above)
end

--[[--
map-through function for <code>surfaces.transport\_player(_player, _surface, _position, _radius, _precision)</code>, transports the player to the access shaft provided

@param _player [Required] - a valid player reference, gathered from <code>game.players["player"]</code>
@param _entity [Required] - a valid entity reference
@return surface
]]
function surfaces.transport_player_to_entity(_player, _entity)
	surfaces.transport_player(_player, _entity.surface, _entity.position, 2)
end

function surfaces.transport_player(_player, _surface, _position, _radius, _precision)
	if api.valid({_player, _surface}) and struct.is_Position(_position) then
		local _new_position = api.surface.find_non_colliding_position(_surface, api.name(api.prototype(_player.character)), _position,
			(type(_radius) == "number" and _radius >= 0) and _radius or 0, (type(_precision) == "number" and _precision > 0) and _precision or 1
		)
		if _new_position ~= nil then
			api.entity.teleport(_player, _new_position, _surface)
		end
	end
end

function surfaces.find_nearby_access_shaft(_entity, _radius, _surface)
	return surfaces.find_nearby_paired_entity(_entity, _radius, _surface, pairclass.get("access-shaft"), et_acc_shaft)
end

function surfaces.find_nearby_paired_entity(_entity, _radius, _surface, _pairclass, _target_type)
	if _radius and api.valid({_entity, _surface}) then
		local _position = api.position(_entity)
		local _area = struct.BoundingBox(_position.x - _radius, _position.y - _radius, _position.x + _radius, _position.y + _radius)
		for k, v in pairs(api.surface.find_entities(_surface, _area, nil, _target_type or nil)) do
			if pairdata.exists(v) then
				local _pairdata = pairdata.get(v)
				if _pairdata.class == _pairclass then
					return v
				end
			end
		end
	end
end

function surfaces.find_nearby_entity(_entity, _radius, _surface, _target_name, _target_type)
	if _radius and api.valid({_surface, _entity}) then
		local _position = api.position(_entity)
		local _area = struct.BoundingBox(_position.x - _radius, _position.y - _radius, _position.x + _radius, _position.y + _radius)
		for k, v in pairs(api.surface.find_entities(_surface, _area, _target_name, _target_type)) do
			return v
		end
	end
end

--[[
The below functions are all specific to the surfaces module, they should not be called by external scripts.
]]

get_mapname = function(_surface_type, _surface_layer)
	return (is_valid(_surface_type, _surface_layer) and (const.prefix .. "-" .. const.surface.type[const.surface.type_valid[_surface_type]].name .. 
		"-" .. _surface_layer) or "nauvis")
end

is_valid_type = function(_surface_type)
	return (const.surface.type_valid[_surface_type] ~= nil)
end

is_valid = function(_surface_type, _surface_layer)
	return ((_surface_layer >= 1) and is_valid_type(_surface_type)) == true
end

get_map_gen_settings = function(_surface_type)
	if mapgensettings == nil then
		mapgensettings = {}
		mapgensettings.nauvis = api.surface.map_gen_settings(api.game.surface("nauvis"))
		mapgensettings.underground = struct.MapGenSettings_copy(mapgensettings.nauvis, false, true, nil, "none")
		mapgensettings.sky = struct.MapGenSettings_copy(mapgensettings.nauvis, true, true, nil, "none")
	end
	if _surface_type == st_und.id then
		return mapgensettings.underground
	elseif _surface_type == st_sky.id then
		return mapgensettings.sky
	end
end

create_surface = function(_surface_type, _surface_layer)
	if is_valid(_surface_type, _surface_layer) then
		local _surface_name = get_mapname(_surface_type, _surface_layer)
		return api.game.surface(_surface_name) or api.game.create_surface(_surface_name, get_map_gen_settings(_surface_type))
	end
	return false	-- failed to create surface, inputs were invalid
end

get_relative_surface = function(_surface, _relative_location)
	if _surface and (surfaces.is_from_this_mod(_surface) or api.name(_surface) == "nauvis") then
		local _surface_name = api.name(_surface)	-- gather and store the name of the surface
		if type(_surface) == "string" then
			_surface = api.game.surface(_surface_name) -- if provided input was a string and not the surface, attempt to get the surface from game surfaces table
		end
		if api.valid(_surface) then		-- if the surface exists and is valid
			if _relative_location == rl_below then
				if surfaces.is_above_nauvis(_surface_name) then
					return surfaces.get_layer(_surface_name) > 1 and api.game.surface(get_mapname(st_sky.id, surfaces.get_layer(_surface_name) - 1))
						or api.game.surface("nauvis")
				else
					return api.game.surface(get_mapname(st_und.id, surfaces.get_layer(_surface_name) + 1))			
				end
			elseif _relative_location == rl_above then
				if surfaces.is_below_nauvis(_surface_name) then
					return surfaces.get_layer(_surface_name) > 1 and api.game.surface(get_mapname(st_und.id, surfaces.get_layer(_surface_name) - 1))
						or api.game.surface("nauvis")
				else
					return api.game.surface(get_mapname(st_sky.id, surfaces.get_layer(_surface_name) + 1))			
				end
			end
		end
	end
end

create_relative_surface = function(_surface, _relative_location)
	if _surface and (surfaces.is_from_this_mod(_surface) or api.name(_surface) == "nauvis") then
		local _surface_name = api.name(_surface)
		if _relative_location == rl_below and (surfaces.is_below_nauvis(_surface_name) or _surface_name == "nauvis") then
			return create_surface(st_und.id, surfaces.get_layer(_surface_name) + 1)
		elseif _relative_location == rl_above and (surfaces.is_above_nauvis(_surface_name) or _surface_name == "nauvis") then
			return create_surface(st_sky.id, surfaces.get_layer(_surface_name) + 1)
		end
		return get_relative_surface(_surface, _relative_location)
	end
end

get_type = function(_surface)
	local _surface_name = api.name(_surface)
	if string.find(_surface_name, const.prefix .. "-" .. st_und.name .. "-", 0, true) then
		return st_und.id
	elseif string.find(_surface_name, const.prefix .. "-" .. st_sky.name .. "-", 0, true) then
		return st_sky.id
	end
end

return surfaces