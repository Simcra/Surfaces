--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.util-base")
require("script.lib.struct")

--[[--
This module is provides "patch through" functions which hook into the LuaAPI.

@module api
]]
api = {}

--[[--
This function accepts a singular object or a table of objects and will return true only if all the objects are valid.

@param _objects [Required] - May be either a singular object or a table of objects
@return <code>true</code> or <code>false</code>
]]
function api.valid(_objects)
	if (type(_objects) == "table") then				-- check if _objects is a table value
		if (_objects.valid == nil) then				-- is this a table of objects?
			for k, v in pairs(_objects) do			-- if so, iterate over the objects
				if (api.valid(v) == false) then		-- check each object for validity
					return false					-- one of the objects is invalid, return false
				end
			end
			return true								-- all objects are valid, return true
		else
			return (_objects.valid == true)			-- return true only if the singular object provided is valid.
		end
	end
end

--[[--
This function accepts a singular object or a table of objects and will destroy each object providing that it exists and is valid.

@param _objects [Required] - May be either a singular object or a table of objects
]]
function api.destroy(_objects)
	if (type(_objects) == "table") then				-- check if _objects is a table value
		if (_objects.valid == nil) then				-- is this a table of objects or a single object?
			for k, v in pairs(_objects) do			-- if so, iterate over the objects
				if (api.valid(v) == true) then
					v.destroy()						-- this object is valid, destroy it.
				end
			end
		elseif (api.valid(_objects) == true) then	-- _objects is a single object
			_objects.destroy()						-- this object is valid, destroy it.
		end
	end
end

--[[--
Returns the localised name string for a tile or entity assuming it is valid, nil otherwise.

@param _object [Required] - Must be a valid object
@return <code>localised\_name</code> string if it exists and <code>_object</code> is valid, nil otherwise.
]]
function api.localised_name(_object)
	return (_object and ((api.prototype(_object)) and api.prototype(_object).localised_name or nil) or nil)
end

--[[--
Returns the name of an entity or tile assuming it is valid, nil otherwise.

@param _object [Required] - Must be a valid object
@return the <code>name</code> of <code>_object</code>, or <code>nil</code>
]]
function api.name(_object)
	return (_object and ((type(_object) == "string") and _object or ((api.valid(_object) and _object.name) and _object.name or tostring(_object))) or nil)
end

--[[--
Returns the type of an entity assuming it is valid, nil otherwise.

@param _entity [Required] - Must be a valid entity
@return the <code>name</code> of <code>_object</code>, or <code>nil</code>
]]
function api.type(_entity)
	return (api.valid(_entity) and _entity.type or nil)
end

--[[--
Returns the position of an entity or tile assuming it is valid, nil otherwise.

@param _object [Required] - Must be a valid tile or entity
]]
function api.position(_object)
	return (api.valid(_object) and _object.position or nil)
end

--[[--
Returns the prototype of an object assuming it is valid, nil otherwise.

@param _object [Required] - Must be a valid tile or entity
]]
function api.prototype(_object)
	return (api.valid(_object) and _object.prototype or nil)
end

--[[--
LuaEntity [<a href=http://lua-api.factorio.com/latest/LuaEntity.html>http://lua-api.factorio.com/latest/LuaEntity.html</a>],
LuaEntityPrototype [<a href=http://lua-api.factorio.com/latest/LuaEntityPrototype.html>http://lua-api.factorio.com/latest/LuaEntityPrototype.html</a>]
]]
api.entity = {}

function api.entity.teleport(_entity, _position, _surface)
	if api.valid({_entity, _surface}) and struct.is_Position(_position) then
		_entity.teleport(_position, _surface)
	end
end

function api.entity.get_inventory(_entity, _inventory_id)
	return ((api.valid(_entity) and _inventory_id) and _entity.get_inventory(_inventory_id) or nil)
end

function api.entity.fluidbox(_entity, _index)
	return ((api.valid(_entity) and type(_entity.fluidbox) == "table") and _entity.fluidbox[_index or 1] or nil)
end

function api.entity.set_fluidbox(_entities, _new_fluidbox, _index)
	if _entities and api.valid(_new_fluidbox) and (_entities.fluidbox or (_entities[1] and _entities[1].fluidbox)) then
		if _entities.fluidbox then
			_entities.fluidbox[_index or 1] = _new_fluidbox
		else
			for k, v in pairs(_entities) do
				if v.fluidbox then
					v.fluidbox[_index or 1] = _new_fluidbox
				end
			end
		end
	end
end

function api.entity.minable(_entity)
	return (api.valid(_entity) and _entity.minable or false)
end

function api.entity.minable_result(_entity)
	if api.entity.minable(_entity) then
		local _results = {}
		for k, v in pairs(api.prototype(_entity).mineable_properties.products) do -- for each product of the entity
			local _prob, _rand = 1, 1
			if v.probability and v.probability < 1 then
				_prob = math.round(v.probability, 14) -- round probability to 14 decimal places
				_rand = math.round(math.random(), 14) -- round randomized number to 14 decimal places
			end
			if _prob >= _rand then -- if random result is  less than probability
				if v.amount_min and v.amount_max then -- and, if product does not have a fixed yield
					local _amount = math.round(v.amount_min + (math.random() * (v.amount_max - v.amount_min))) -- determine the yield for this drop
					table.insert(_results, struct.SimpleItemStack(v.name, _amount)) -- insert SimpleItemStack data into results table after calculations
				else
					table.insert(_results, struct.SimpleItemStack(v.name, v.amount)) -- insert SimpleItemStack data into results table
				end
			end
		end
		return _results -- return the results
	end
end

function api.entity.direction(_entity)
	return (api.valid(_entity) and _entity.direction or nil)
end

function api.entity.force(_entity)
	return (api.valid(_entity) and _entity.force or nil)
end

function api.entity.set_direction(_entity, _direction)
	if api.valid(_entity) and struct.is_Direction(_direction) and _entity.direction then
		_entity.direction = _direction
	end
end

function api.entity.connect_neighbour(_entity, _neighbour, _wire)
	if api.valid({_entity, _neighbour}) then
		local _wires = const.wire
		if _wire == _wires.copper then
			_entity.connect_neighbour(_neighbour)
		elseif _wire == _wires.red then
			_entity.connect_neighbour{wire = defines.wire_type.red, target_entity = _neighbour}
		elseif _wire == _wires.green then
			_entity.connect_neighbour{wire = defines.wire_type.green, target_entity = _neighbour}
		elseif _wire == _wires.circuit then
			_entity.connect_neighbour{wire = defines.wire_type.red, target_entity = _neighbour}
			_entity.connect_neighbour{wire = defines.wire_type.green, target_entity = _neighbour}
		elseif _wire == _wires.all then
			_entity.connect_neighbour(_neighbour)
			_entity.connect_neighbour{wire = defines.wire_type.red, target_entity = _neighbour}
			_entity.connect_neighbour{wire = defines.wire_type.green, target_entity = _neighbour}
		end
	end
end

--[[--
LuaEquipment [<a href=http://lua-api.factorio.com/latest/LuaEquipment.html>http://lua-api.factorio.com/latest/LuaEquipment.html</a>]
]]
api.equipment = {}

--[[--
LuaEquipmentGrid [<a href=http://lua-api.factorio.com/latest/LuaEquipmentGrid.html>http://lua-api.factorio.com/latest/LuaEquipmentGrid.html</a>]
]]
api.equipment_grid = {}

--[[--
LuaFluidPrototype [<a href=http://lua-api.factorio.com/latest/LuaFluidPrototype.html>http://lua-api.factorio.com/latest/LuaFluidPrototype.html</a>]
]]
api.fluid_prototype = {}

--[[--
LuaForce [<a href=http://lua-api.factorio.com/latest/LuaForce.html>http://lua-api.factorio.com/latest/LuaForce.html</a>]
]]
api.force = {}

--[[--
LuaGameScript [<a href=http://lua-api.factorio.com/latest/LuaGameScript.html>http://lua-api.factorio.com/latest/LuaGameScript.html</a>]
]]
api.game = {}

function api.game.player(_id)
	return _id and api.game.players()[_id] or nil
end

function api.game.players()
	return game.players
end

function api.game.surface(_id)
	return _id and api.game.surfaces()[_id] or nil
end

function api.game.surfaces()
	return game.surfaces
end

function api.game.force(_id)
	return _id and api.game.forces()[_id]
end

function api.game.forces()
	return game.forces
end

function api.game.active_mod(_id)
	return _id and api.game.active_mods()[_id]
end

function api.game.active_mods()
	return game.active_mods
end

function api.game.entity_prototype(_id)
	return _id and api.game.entity_prototypes()[_id]
end

function api.game.entity_prototypes()
	return game.entity_prototypes
end

function api.game.tile_prototype(_id)
	return _id and api.game.tile_prototypes()[_id]
end

function api.game.tile_prototypes()
	return game.tile_prototypes
end

function api.game.tick()
	return game.tick
end

function api.game.create_surface(_name, _mapgensettings)
	return (type(_name) == "string" and struct.is_MapGenSettings(_mapgensettings)) and game.create_surface(_name, _mapgensettings) or nil
end

function api.game.delete_surface(_surface)
	if type(_surface) == "string" or type(_surface) == "number" or api.valid(_surface) then
		game.delete_surface(_surface)
	end
end

function api.game.raise_event(_id, _data)
	return (type(_id) == "number") and game.raise_event(_id, _data or {}) or nil
end

--[[--
LuaGroup [<a href=http://lua-api.factorio.com/latest/LuaGroup.html>http://lua-api.factorio.com/latest/LuaGroup.html</a>]
]]
api.group = {}

--[[--
LuaGui [<a href=http://lua-api.factorio.com/latest/LuaGui.html>http://lua-api.factorio.com/latest/LuaGui.html</a>]
]]
api.gui = {}

--[[--
LuaGuiElement [<a href=http://lua-api.factorio.com/latest/LuaGuiElement.html>http://lua-api.factorio.com/latest/LuaGuiElement.html</a>]
]]
api.gui_element = {}

--[[--
LuaInventory [<a href=http://lua-api.factorio.com/latest/LuaInventory.html>http://lua-api.factorio.com/latest/LuaInventory.html</a>]
]]
api.inventory = {}

function api.inventory.get_contents(_inventory)
	return api.valid(_inventory) and _inventory.get_contents() or nil
end

function api.inventory.can_insert(_inventory, _itemstack)
	return (api.valid(_inventory) and struct.is_SimpleItemStack(_itemstack)) and _inventory.can_insert(_itemstack) or false
end

function api.inventory.insert(_inventory, _itemstack)
	return (api.valid(_inventory) and struct.is_SimpleItemStack(_itemstack) and _itemstack.count > 0) and _inventory.insert(_itemstack) or 0
end

function api.inventory.remove(_inventory, _itemstack)
	return (api.valid(_inventory) and struct.is_SimpleItemStack(_itemstack) and _itemstack.count > 0) and _inventory.remove(_itemstack) or 0
end

--[[--
LuaItemPrototype [<a href=http://lua-api.factorio.com/latest/LuaItemPrototype.html>http://lua-api.factorio.com/latest/LuaItemPrototype.html</a>]
]]
api.item_prototype = {}

--[[--
LuaItemStack [<a href=http://lua-api.factorio.com/latest/LuaItemStack.html>http://lua-api.factorio.com/latest/LuaItemStack.html</a>]
]]
api.item_stack = {}

--[[--
LuaLogisticCell [<a href=http://lua-api.factorio.com/latest/LuaLogisticCell.html>http://lua-api.factorio.com/latest/LuaLogisticCell.html</a>]
]]
api.logistic_cell = {}

--[[--
LuaLogisticNetwork [<a href=http://lua-api.factorio.com/latest/LuaLogisticNetwork.html>http://lua-api.factorio.com/latest/LuaLogisticNetwork.html</a>]
]]
api.logistic_network = {}

--[[--
LuaPlayer [<a href=http://lua-api.factorio.com/latest/LuaPlayer.html>http://lua-api.factorio.com/latest/LuaPlayer.html</a>]
]]
api.player = {}

--[[--
LuaRecipe [<a href=http://lua-api.factorio.com/latest/LuaRecipe.html>http://lua-api.factorio.com/latest/LuaRecipe.html</a>]
]]
api.recipe = {}

--[[--
LuaRemote [<a href=http://lua-api.factorio.com/latest/LuaRemote.html>http://lua-api.factorio.com/latest/LuaRemote.html</a>]
]]

--[[--
LuaStyle [<a href=http://lua-api.factorio.com/latest/LuaStyle.html>http://lua-api.factorio.com/latest/LuaStyle.html</a>]
]]
api.style = {}

--[[--
LuaSurface [<a href=http://lua-api.factorio.com/latest/LuaSurface.html>http://lua-api.factorio.com/latest/LuaSurface.html</a>]
]]
api.surface = {}
function api.surface.can_place_entity(_surface, _entity_data) -- entity_data is name, position, direction and force
	return (api.valid(_surface) and _entity_data and _entity_data.name and struct.is_Position(_entity_data.position)) and _surface.can_place_entity(_entity_data) or false
end

function api.surface.create_entity(_surface, _entity_data) -- entity_data is name, position and other optional entity parameters (see LuaAPI docs)
	return (api.valid(_surface) and _entity_data and _entity_data.name and struct.is_Position(_entity_data.position)) and _surface.create_entity(_entity_data) or nil
end

function api.surface.count_entities(_surface, _area, _entity_name, _entity_type, _entity_force)
	if (api.valid(_surface)) then
		if (struct.is_BoundingBox(_area)) then
			if (_area.left_top.x == _area.right_bottom.x and _area.left_top.y == _area.right_bottom.y) then
				return _surface.find_entities_filtered({position = _area.left_top, name = _entity_name, type = _entity_type, force = _entity_force})
			else
				return _surface.find_entities_filtered({area = _area, name = _entity_name, type = _entity_type, force = _entity_force})
			end
		elseif (struct.is_Position(_area)) then
			return _surface.find_entities_filtered({position = _area, name = _entity_name, type = _entity_type, force = _entity_force})
		end
	end
	return nil
end

function api.surface.find_entities(_surface, _area, _entity_name, _entity_type, _entity_force)
	if (api.valid(_surface)) then
		if (struct.is_BoundingBox(_area)) then
			if (_area.left_top.x == _area.right_bottom.x and _area.left_top.y == _area.right_bottom.y) then
				return _surface.find_entities_filtered({position = _area.left_top, name = _entity_name, type = _entity_type, force = _entity_force})
			else
				return _surface.find_entities_filtered({area = _area, name = _entity_name, type = _entity_type, force = _entity_force})
			end
		elseif (struct.is_Position(_area)) then
			return _surface.find_entities_filtered({position = _area, name = _entity_name, type = _entity_type, force = _entity_force})
		else
			return _surface.find_entities_filtered({name = _entity_name, type = _entity_type, force = _entity_force})
		end
	end
	return nil
end

function api.surface.find_non_colliding_position(_surface, _prototype, _center, _radius, _precision)
	return (api.valid(_surface) and _prototype and api.game.entity_prototypes()[_prototype] and struct.is_Position(_center) and _radius and _precision) and _surface.find_non_colliding_position(_prototype, _center, _radius, _precision) or nil
end

function api.surface.get_tile(_surface, _position)
	return (api.valid(_surface) and struct.is_Position(_position)) and _surface.get_tile(_position.x, _position.y) or nil
end

function api.surface.get_tile_properties(_surface, _position)
	return (api.valid(_surface) and struct.is_Position(_position)) and _surface.get_tileproperties(_position.x, _position.y) or nil
end

function api.surface.is_chunk_generated(_surface, _position, _using_chunk_position)
	if api.valid(_surface) and struct.is_Position(_position) then
		if _using_chunk_position then
			return _surface.is_chunk_generated(_position)
		else
			local _chunk_x, _chunk_y = math.floor(_position.x/32), math.floor(_position.y/32) 
			return _surface.is_chunk_generated(struct.Position(_chunk_x, _chunk_y))
		end
	end
	return nil
end

function api.surface.get_chunks(_surface)
	return api.valid(_surface) and _surface.get_chunks() or nil
end

function api.surface.request_generate_chunks(_surface, _position, _radius)
	if api.valid(_surface) and struct.is_Position(_position) then
		_surface.request_to_generate_chunks(_position, _radius or 0)
	end
end

function api.surface.get_pollution(_surface, _position)
	return (api.valid(_surface) and struct.is_Position(_position)) and _surface.get_pollution(_position) or nil
end

function api.surface.pollute(_surface, _position, _amount)
	if api.valid(_surface) and struct.is_Position(_position) and _amount then
		_surface.pollute(_position, _amount)
	end
end

function api.surface.set_tiles(_surface, _tiles)
	if api.valid(_surface) and struct.is_Tiles(_tiles) then
		_surface.set_tiles(_tiles)
	end
end

function api.surface.map_gen_settings(_surface)
	return (_surface and api.valid(_surface)) and _surface.map_gen_settings
end

function api.surface.spill_items(_surface, _position, _itemstack)
	if api.valid(_surface) and struct.is_SimpleItemStack(_itemstack) and struct.is_Position(_position) then
		_surface.spill_item_stack(_position, _itemstack)
	end
end
--[[--
LuaTechnology [<a href=http://lua-api.factorio.com/latest/LuaTechnology.html>http://lua-api.factorio.com/latest/LuaTechnology.html</a>]
]]
api.technology = {}

--[[--
LuaTile [<a href=http://lua-api.factorio.com/latest/LuaTile.html>http://lua-api.factorio.com/latest/LuaTile.html</a>],
LuaTilePrototype [<a href=http://lua-api.factorio.com/latest/LuaTilePrototype.html>http://lua-api.factorio.com/latest/LuaTilePrototype.html</a>]
]]
api.tile = {}

--[[--
LuaTrain [<a href=http://lua-api.factorio.com/latest/LuaTrain.html>http://lua-api.factorio.com/latest/LuaTrain.html</a>]
]]
api.train = {}
function api.train.state(_train)
	return (api.valid(_train)) and _train.state
end

function api.train.front_rail(_train)
	return (api.valid(_train)) and _train.front_rail
end

function api.train.back_rail(_train)
	return (api.valid(_train)) and _train.back_rail
end

function api.train.speed(_train)
	return (api.valid(_train)) and _train.speed
end

function api.train.carriages(_train)
	return (api.valid(_train)) and _train.carriages
end

function api.train.locomotives(_train)
	return (api.valid(_train)) and _train.locomotives
end

function api.train.cargo_wagons(_train)
	return (api.valid(_train)) and _train.cargo_wagons
end

function api.train.schedule(_train)
	return (api.valid(_train)) and _train.schedule
end

--[[--
LuaTransportLine [<a href=http://lua-api.factorio.com/latest/LuaTransportLine.html>http://lua-api.factorio.com/latest/LuaTransportLine.html</a>]
]]
api.transport_line = {}

--[[--
LuaUnitGroup [<a href=http://lua-api.factorio.com/latest/LuaUnitGroup.html>http://lua-api.factorio.com/latest/LuaUnitGroup.html</a>]
]]
api.unit_group = {}

return api