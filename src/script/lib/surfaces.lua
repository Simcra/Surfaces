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
local get_relative_surface, create_relative_surface, get_mapname, get_mapgensettings, create_surface

-- declaring local variables
local mapgensettings = nil
local ss_separator, ss_prefix = const.surface.separator, const.surface.prefix
local rl_above, rl_below = const.surface.rel_loc.above, const.surface.rel_loc.below
local st_und, st_sky = const.surface.type.underground, const.surface.type.sky
local et_acc_shaft = proto.get_field({"entity", "access_shaft", "common"}, "type")
local tn_und_dirt, tn_sky_void = proto.get_field({"tile", "underground_dirt"}, "name"), proto.get_field({"tile", "sky_void"}, "name")

--[[--
was this surface created by this mod?

@param _surface [Required] - the surface to test
@param _separator [Optional] - separator character, versions of this mod prior to 0.0.7 use "_", newer versions use ss_separator
@return <code>true</code> or <code>false</code>
]] 
function surfaces.is_mod_surface(_surface, _separator)
	if _surface then
		if type(_separator) ~= "string" then _separator = ss_separator end
		local _surface_name = api.name(_surface)
		return string.find(_surface_name, ss_prefix .. _separator, 0, true) ~= nil
	end
	return nil
end

--[[--
returns the layer of this surface relative to the nauvis layer. (the first underground surface is layer one and the first platform surface is also layer one)

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@param _separator [Optional] - separator character, versions of this mod prior to 0.0.7 use "\_", newer versions use ss_separator
@return surface layer
]]
function surfaces.get_layer(_surface, _separator)
	if _surface then
		if type(_separator) ~= "string" then _separator = ss_separator end
		local _surface_name = api.name(_surface)
		if _surface_name == "nauvis" then
			return 0
		else
			local _surface_string = ss_prefix .. _separator .. const.surface.type[const.surface.type_valid[surfaces.get_type(_surface_name, _separator)]].name .. _separator
			return tonumber(string.sub(_surface_name, string.find(_surface_name, _surface_string, 0, true) + string.len(_surface_string)))
		end
	end
	return nil
end

--[[--
returns the type of this surface (the unique ID of the surface type, not the name)

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@param _separator [Optional] - separator character, versions of this mod prior to 0.0.7 use "_", newer versions use ss_separator
@return surface type ID
]]
function surfaces.get_type(_surface, _separator)
	if _surface then
		if type(_separator) ~= "string" then _separator = ss_separator end
		local _surface_name = api.name(_surface)
		local _surface_string = ss_prefix .. _separator
		if string.find(_surface_name, _surface_string, 0, true) then
			for k, v in pairs(const.surface.type) do
				if v.id ~= const.surface.type.all.id and string.find(_surface_name, _surface_string .. v.name .. _separator, 0, true) then
					return v.id
				end
			end
		end
	end
	return nil
end

--[[--
is this surface below the nauvis layer?

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return <code>true</code> or <code>false</code>
]]
function surfaces.is_below_nauvis(_surface)
	return surfaces.get_type(_surface) == st_und.id
end

--[[--
is this surface above the nauvis layer?

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@return <code>true</code> or <code>false</code>
]]
function surfaces.is_above_nauvis(_surface)
	return surfaces.get_type(_surface) == st_sky.id
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
triggers name-change migrations for a surface created prior to this version, if they are necessary

@param _surface [Required] - a valid surface, gathered from <code>game.surfaces["surface"]</code>
@param _separator [Required] - separator character, versions of this mod prior to 0.0.7 use "_", newer versions will use ss_separator
]]
function surfaces.migrate_surface(_surface, _separator)
	if api.valid(_surface) and surfaces.is_mod_surface(_surface, _separator) and _separator ~= ss_separator then
		local _surface_layer = surfaces.get_layer(_surface, _separator) 
		local _surface_type = surfaces.get_type(_surface, _separator)
		local _surface_name = ss_prefix .. const.surface.separator .. const.surface.type[const.surface.type_valid[_surface_type]].name .. const.surface.separator .. _surface_layer
		
		api.game.create_surface(_surface_name, api.surface.map_gen_settings(_surface)) -- create the new surface
		local _new_surface = api.game.surface(_surface_name)
		for _chunk in api.surface.get_chunks(_surface) do
			api.surface.request_generate_chunks(_new_surface, _chunk) -- request generation of all chunks in the new surface
		end
		global.surfaces_to_migrate = global.surfaces_to_migrate or {}
		global.surfaces_to_migrate[api.name(_surface)] = {surface = _surface, new_surface = _new_surface, underground = surfaces.is_below_nauvis(_surface),
			platform = surfaces.is_above_nauvis(_surface), migrated = false}
		global.surfaces_to_migrate[_surface_name] = true -- used for determining whether surface is being migrated or not in on_chunk_generated event
	end
end		

--[[--
map-through function for <code>surfaces.transport\_player(\_player, \_surface, \_position, \_radius, \_precision)</code>, transports the player to the entity provided

@param _player [Required] - a valid player reference, gathered from <code>game.players["player"]</code> or <code>entity.player</code>
@param _entity [Required] - a valid entity reference
]]
function surfaces.transport_player_to_entity(_player, _entity)
	if api.valid(_entity) then surfaces.transport_player(_player, _entity.surface, _entity.position, 2) end
end

--[[--
Transports the player to the nearest non-colliding position, using parameters provided
]]
function surfaces.transport_player(_player, _surface, _position, _radius, _precision)
	if api.valid({_player, _surface}) and struct.is_Position(_position) then
		local _new_position = api.surface.find_non_colliding_position(_surface, api.name(api.prototype(api.player.character(_player))), _position,
			(type(_radius) == "number" and _radius >= 0) and _radius or 0, (type(_precision) == "number" and _precision > 0) and _precision or 1)
		if _new_position ~= nil then
			api.entity.teleport(_player, _new_position, _surface)
		end
	end
end

function surfaces.find_nearby_paired_entity(_entity, _radius, _surface, _pairclass, _target_type)
	if _radius and api.valid({_entity, _surface}) then
		local _position = api.position(_entity)
		local _area = struct.BoundingBox(_position.x - _radius, _position.y - _radius, _position.x + _radius, _position.y + _radius)
		for k, v in pairs(api.surface.find_entities(_surface, _area, nil, _target_type or nil, nil, 1)) do
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
		local _entities = api.surface.find_entities(_surface, _area, _target_name, _target_type, nil, 1) or {}
		for _, _entity in pairs(_entities) do
			return _entity
		end
	end
end

--[[--
Is this tile valid in this surface?

@param _tile [Required] - the tile to test
@return <code>true</code> or <code>false</code>
]] 
function surfaces.is_tile_placement_valid(_tile, _surface, _override_tiles)
	if api.valid({_tile, _surface}) then
		_override_tiles = type(_override_tiles) == "table" and _override_tiles or const.surface.override_tiles
		local _tile_name = api.name(_tile)
		local _is_underground, _is_platform = surfaces.is_below_nauvis(_surface), surfaces.is_above_nauvis(_surface)
		if not(_override_tiles[_tile_name]) and ((_is_underground) or (_is_platform and (skytiles.get(_tile_name) or _tile.collides_with("ground-tile")))) then
			return true
		else
			return false
		end
	end
end

--[[
The below functions are all specific to the surfaces module, they should not be called by external scripts.
]]

get_mapname = function(_surface_type, _surface_layer, _separator)
	if ((type(_surface_layer) == "number" and (_surface_layer >= 1)) and const.surface.type_valid[_surface_type] ~= nil) then
		if type(_separator) ~= "string" then _separator = ss_separator end 
		local _mapname = ss_prefix .. _separator .. const.surface.type[const.surface.type_valid[_surface_type]].name .. _separator .. _surface_layer
		return _mapname
	end
	return nil
end

get_mapgensettings = function(_surface_type)
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
	if ((type(_surface_layer) == "number" and (_surface_layer >= 1)) and const.surface.type_valid[_surface_type] ~= nil) then
		local _surface_name = get_mapname(_surface_type, _surface_layer)
		return api.game.surface(_surface_name) or api.game.create_surface(_surface_name, get_mapgensettings(_surface_type))
	end
	return false	-- failed to create surface, inputs were invalid
end

get_relative_surface = function(_surface, _relative_location)
	if _surface and (surfaces.is_mod_surface(_surface) or api.name(_surface) == "nauvis") then
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
	if _surface and (surfaces.is_mod_surface(_surface) or api.name(_surface) == "nauvis") then
		local _surface_name = api.name(_surface)
		if _relative_location == rl_below and (surfaces.is_below_nauvis(_surface_name) or _surface_name == "nauvis") then
			return create_surface(st_und.id, surfaces.get_layer(_surface_name) + 1)
		elseif _relative_location == rl_above and (surfaces.is_above_nauvis(_surface_name) or _surface_name == "nauvis") then
			return create_surface(st_sky.id, surfaces.get_layer(_surface_name) + 1)
		end
		return get_relative_surface(_surface, _relative_location)
	end
end

return surfaces