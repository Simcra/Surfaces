--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.struct")
require("script.lib.util")

api.entity = {}
api.entity_prototype = {}
api.equipment = {}
api.equipment_grid = {}
api.fluid_prototype = {}
api.force = {}
api.game = {}
api.group = {}
api.gui = {}
api.gui_element = {}
api.inventory = {}
api.item_prototype = {}
api.item_stack = {}
api.logistic_cell = {}
api.logistic_network = {}
api.player = {}
api.recipe = {}
api.style = {}
api.surface = {}
api.technology = {}
api.tile = {}
api.train = {}
api.transport_line = {}
api.unit_group = {}

--[[
The below functions are referenced heavily throughout this mod and serve as middle-man between my mod and the LuaAPI.
This allows fixes for mod-breaking changes in Factorio to be created much faster and easier.
Each section contains a header specifying which LuaAPI class the below functions belong to, the first section is for generic shared functions.
]]

-- api.valid(object) should be here but circular references prevent that, instead it can be found in util.lua

function api.name(object)
	return object and (type(object) == "string" and object or ((api.valid(object) and object.name) and object.name or tostring(object))) or nil
end

function api.type(object)
	return api.valid(object) and object.type or nil
end

function api.prototype(object)
	return api.valid(object) and object.prototype or nil
end

function api.destroy(entity)
	if type(entity) == "table" then
		if entity.valid == nil then
			for k, v in pairs(entity) do
				if api.valid(v) then
					v.destroy()
				end
			end
		elseif api.valid(entity) then
			entity.destroy()
		end
	end
end

--[[
LuaEntity (http://lua-api.factorio.com/0.12.35/LuaEntity.html)
]]
function api.entity.teleport(entity, position, surface)
	if api.valid(entity) and api.valid(surface) and struct.is_Position(position) then
		entity.teleport(position, surface)
	end
end

function api.entity.get_inventory(entity, inventory_id)
	return (api.valid(entity) and inventory_id) and entity.get_inventory(inventory_id) or nil
end

function api.entity.fluidbox(entity, index)
	return (api.valid(entity) and type(entity.fluidbox) == "table") and entity.fluidbox[index or 1] or nil
end

function api.entity.set_fluidbox(entities, new_fluidbox, index)
	if type(entities) == "table" and api.valid(new_fluidbox) and (entities.fluidbox ~= nil or (entities[1] ~= nil and entities[1].fluidbox ~= nil)) then
		if entities.fluidbox ~= nil then
			entities.fluidbox[index or 1] = new_fluidbox
		else
			for k, v in pairs(entities) do
				if v.fluidbox ~= nil then
					v.fluidbox[index or 1] = new_fluidbox
				end
			end
		end
	end
end

function api.entity.direction(entity)
	if api.valid(entity) then
		return entity.direction
	end
end

function api.entity.set_direction(entity, new_direction)
	if api.valid(entity) and struct.is_Direction(new_direction) and api.type(entity) ~= "simple-entity" then
		entity.direction = new_direction
	end
end

function api.entity.connect_neighbour(entity_a, entity_b, wire)
	if api.valid({entity_a, entity_b}) then
		if wire == enum.wire.copper then
			entity_a.connect_neighbour(entity_b)
		elseif wire == enum.wire.red then
			entity_a.connect_neighbour{wire = defines.circuitconnector.red, target_entity = entity_b}
		elseif wire == enum.wire.green then
			entity_a.connect_neighbour{wire = defines.circuitconnector.green, target_entity = entity_b}
		elseif wire == enum.wire.all then
			entity_a.connect_neighbour(entity_b)
			entity_a.connect_neighbour{wire = defines.circuitconnector.red, target_entity = entity_b}
			entity_a.connect_neighbour{wire = defines.circuitconnector.green, target_entity = entity_b}
		end
	end
end

--[[
LuaEntityPrototype (http://lua-api.factorio.com/0.12.35/LuaEntityPrototype.html)
]]

--[[
LuaEquipment (http://lua-api.factorio.com/0.12.35/LuaEquipment.html)
]]

--[[
LuaEquipmentGrid (http://lua-api.factorio.com/0.12.35/LuaEquipmentGrid.html)
]]

--[[
LuaFluidPrototype (http://lua-api.factorio.com/0.12.35/LuaFluidPrototype.html)
]]

--[[
LuaForce (http://lua-api.factorio.com/0.12.35/LuaForce.html)
]]

--[[
LuaGameScript (http://lua-api.factorio.com/0.12.35/LuaGameScript.html)
]]
function api.game.player(id)
	return id and game.get_player(id) or nil --pre 0.13
	--return id and game.players[id] --post 0.13
end

function api.game.players()
	return game.players
end

function api.game.surface(id)
	return id and game.get_surface(id) or nil --pre 0.13
	--return id and game.surfaces[id] or nil --post 0.13
end

function api.game.force(id)
	return game.forces[id]
end

function api.game.entity_prototypes()
	return game.entity_prototypes
end

function api.game.tile_prototypes() -- will not work until 0.13
	--return game.tile_prototypes 
end

function api.game.tick()
	return game.tick
end

function api.game.create_surface(name, mapgensettings)
	return (type(name) == "string" and struct.is_MapGenSettings(mapgensettings)) and game.create_surface(name, mapgensettings) or nil
end

--[[
LuaGroup (http://lua-api.factorio.com/0.12.35/LuaGroup.html)
]]

--[[
LuaGui (http://lua-api.factorio.com/0.12.35/LuaGui.html)
]]

--[[
LuaGuiElement (http://lua-api.factorio.com/0.12.35/LuaGuiElement.html)
]]

--[[
LuaInventory (http://lua-api.factorio.com/0.12.35/LuaInventory.html)
]]
function api.inventory.get_contents(inventory)
	return api.valid(inventory) and inventory.get_contents() or nil
end

function api.inventory.can_insert(inventory, itemstack)
	return (api.valid(inventory) and struct.is_ItemStack(itemstack)) and inventory.can_insert(itemstack) or false
end

function api.inventory.insert(inventory, itemstack)
	return (api.valid(inventory) and struct.is_ItemStack(itemstack) and itemstack.count > 0) and inventory.insert(itemstack) or 0
end

function api.inventory.remove(inventory, itemstack)
	return (api.valid(inventory) and struct.is_ItemStack(itemstack) and itemstack.count > 0) and inventory.remove(itemstack) or 0
end

--[[
LuaItemPrototype (http://lua-api.factorio.com/0.12.35/LuaItemPrototype.html)
]]

--[[
LuaItemStack (http://lua-api.factorio.com/0.12.35/LuaItemStack.html)
]]

--[[
LuaLogisticCell (http://lua-api.factorio.com/0.12.35/LuaLogisticCell.html)
]]

--[[
LuaLogisticNetwork (http://lua-api.factorio.com/0.12.35/LuaLogisticNetwork.html)
]]

--[[
LuaPlayer (http://lua-api.factorio.com/0.12.35/LuaPlayer.html)
]]

--[[
LuaRecipe (http://lua-api.factorio.com/0.12.35/LuaRecipe.html)
]]

--[[
LuaRemote (http://lua-api.factorio.com/0.12.35/LuaRemote.html)
]]

--[[
LuaStyle (http://lua-api.factorio.com/0.12.35/LuaStyle.html)
]]

--[[
LuaSurface (http://lua-api.factorio.com/0.12.35/LuaSurface.html)
]]
function api.surface.can_place_entity(surface, entity_data) -- entity_data is name, position, direction and force
	return (api.valid(surface) and entity_data and entity_data.name and struct.is_Position(entity_data.position)) and surface.can_place_entity(entity_data) or false
end

function api.surface.create_entity(surface, entity_data) -- entity_data is name, position and other optional entity parameters (see LuaAPI docs)
	return (api.valid(surface) and entity_data and entity_data.name and struct.is_Position(entity_data.position)) and surface.create_entity(entity_data) or nil
end

function api.surface.count_entities(surface, area, entity_name, entity_type, entity_force)
	return (api.valid(surface) and struct.is_BoundingBox(area)) and surface.count_entities_filtered({area=area, name=entity_name, type=entity_type, force=entity_force}) or nil
end

function api.surface.find_entities(surface, area, entity_name, entity_type, entity_force)
	return (api.valid(surface) and struct.is_BoundingBox(area)) and surface.find_entities_filtered({area=area, name=entity_name, type=entity_type, force=entity_force}) or nil
end

function api.surface.find_non_colliding_position(surface, prototype, center, radius, precision)
	return (api.valid(surface) and prototype and api.game.entity_prototypes()[prototype] and struct.is_Position(center) and radius and precision) and surface.find_non_colliding_position(prototype, center, radius, precision) or nil
end

function api.surface.get_tile(surface, position)
	return (api.valid(surface) and struct.is_Position(position)) and surface.get_tile(position.x, position.y) or nil
end

function api.surface.get_tile_properties(surface, position)
	return (api.valid(surface) and struct.is_Position(position)) and surface.get_tileproperties(position.x, position.y) or nil
end

function api.surface.chunk_iterator(surface)
	return api.valid(surface) and surface.get_chunks() or nil
end

function api.surface.request_generate_chunks(surface, position, radius)
	if api.valid(surface) and struct.is_Position(position) then
		surface.request_to_generate_chunks(position, radius or 0)
	end
end

function api.surface.get_pollution(surface, position)
	return (api.valid(surface) and struct.is_Position(position)) and surface.get_pollution(position) or nil
end

function api.surface.pollute(surface, position, amount)
	if api.valid(surface) and struct.is_Position(position) and amount then
		surface.pollute(position, amount)
	end
end

function api.surface.set_tiles(surface, tiles)
	if api.valid(surface) and struct.is_Tiles(tiles) then
		surface.set_tiles(tiles)
	end
end

function api.surface.map_gen_settings(surface)
	return (surface and api.valid(surface)) and surface.map_gen_settings
end
--[[
LuaTechnology (http://lua-api.factorio.com/0.12.35/LuaTechnology.html)
]]

--[[
LuaTile (http://lua-api.factorio.com/0.12.35/LuaTile.html)
]]

--[[
LuaTrain (http://lua-api.factorio.com/0.12.35/LuaTrain.html)
]]
function api.train.state(train)
	return (api.valid(train)) and train.state
end

function api.train.front_rail(train)
	return (api.valid(train)) and train.front_rail
end

function api.train.back_rail(train)
	return (api.valid(train)) and train.back_rail
end

function api.train.speed(train)
	return (api.valid(train)) and train.speed
end

function api.train.carriages(train)
	return (api.valid(train)) and train.carriages
end

function api.train.locomotives(train)
	return (api.valid(train)) and train.locomotives
end

function api.train.cargo_wagons(train)
	return (api.valid(train)) and train.cargo_wagons
end

function api.train.schedule(train)
	return (api.valid(train)) and train.schedule
end

--[[
LuaTransportLine (http://lua-api.factorio.com/0.12.35/LuaTransportLine.html)
]]

--[[
LuaUnitGroup (http://lua-api.factorio.com/0.12.35/LuaUnitGroup.html)
]]
