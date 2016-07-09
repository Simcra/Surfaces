--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.struct")
require("script.lib.util-base")

--[[
This module provides functions that "patch through" to the Factorio LuaAPI
In situation that LuaAPI changes due to Factorio updates, this significantly reduces work required to update mod for compatibility.
]]
api = {}
function api.valid(objects)
	if objects ~= nil and type(objects) == "table" then
		if objects.valid == nil then
			for k, v in pairs(objects) do
				if api.valid(v) == false then
					return false
				end
			end
			return true
		else
			return objects.valid == true
		end
	end
end

function api.localised_name(object)
	return object and (api.prototype(object) and api.prototype(object).localised_name[1] or nil) or nil
end

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
LuaEntity
LuaEntityPrototype
]]
api.entity = {}
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
	if entities ~= nil and api.valid(new_fluidbox) and (entities.fluidbox ~= nil or (entities[1] ~= nil and entities[1].fluidbox ~= nil)) then
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

function api.entity.minable(entity)
	return api.valid(entity) and (entity.minable ~= nil and entity.minable == true) or false
end

function api.entity.minable_result(entity)
	if api.entity.minable(entity) == true then
		local results = {}
		for k, v in pairs(api.prototype(entity).mineable_properties.products) do -- for each product of the entity
			local prob, rand = 1, 1
			if v.probability ~= nil and v.probability < 1 then
				prob = math.round(v.probability, 14) -- round probability to 14 decimal places
				rand = math.round(math.random(), 14) -- round randomized number to 14 decimal places
			end
			if prob >= rand then -- if random result less than or equal to probability
				if v.amount_min ~= nil and v.amount_max ~= nil then -- and, if product does not have a fixed yield
					local amount = math.round(v.amount_min + (math.random() * (v.amount_max - v.amount_min))) -- determine the yield for this drop
					table.insert(results, struct.ItemStack(v.name, amount)) -- insert ItemStack data into results table after calculations
				else
					table.insert(results, struct.ItemStack(v.name, v.amount)) -- insert ItemStack data into results table
				end
			end
		end
		return results -- return the results
	end
end

function api.entity.direction(entity)
	return api.valid(entity) and entity.direction or nil
end

function api.entity.set_direction(entity, new_direction)
	if api.valid(entity) and struct.is_Direction(new_direction) and entity.direction ~= nil then
		entity.direction = new_direction
	end
end

function api.entity.connect_neighbour(entity_a, entity_b, wire)
	if api.valid({entity_a, entity_b}) then
		if wire == const.wire.copper then
			entity_a.connect_neighbour(entity_b)
		elseif wire == const.wire.red then
			entity_a.connect_neighbour{wire = defines.wire_type.red, target_entity = entity_b}
		elseif wire == const.wire.green then
			entity_a.connect_neighbour{wire = defines.wire_type.green, target_entity = entity_b}
		elseif wire == const.wire.circuit then
			entity_a.connect_neighbour{wire = defines.wire_type.red, target_entity = entity_b}
			entity_a.connect_neighbour{wire = defines.wire_type.green, target_entity = entity_b}
		elseif wire == const.wire.all then
			entity_a.connect_neighbour(entity_b)
			entity_a.connect_neighbour{wire = defines.wire_type.red, target_entity = entity_b}
			entity_a.connect_neighbour{wire = defines.wire_type.green, target_entity = entity_b}
		end
	end
end

--[[
LuaEquipment
]]
api.equipment = {}

--[[
LuaEquipmentGrid
]]
api.equipment_grid = {}

--[[
LuaFluidPrototype
]]
api.fluid_prototype = {}

--[[
LuaForce
]]
api.force = {}

--[[
LuaGameScript
]]
api.game = {}
function api.game.player(id)
	return id and game.players[id] or nil
end

function api.game.players()
	return game.players
end

function api.game.surface(id)
	return id and game.surfaces[id] or nil
end

function api.game.surfaces()
	return game.surfaces
end

function api.game.force(id)
	return id and game.forces[id]
end

function api.game.forces()
	return game.forces
end

function api.game.active_mod(id)
	return id and game.active_mods[id]
end

function api.game.active_mods()
	return game.active_mods
end

function api.game.entity_prototype(id)
	return id and game.entity_prototypes[id]
end

function api.game.entity_prototypes()
	return game.entity_prototypes
end

function api.game.tile_prototype(id)
	return id and game.tile_prototypes[id]
end

function api.game.tile_prototypes()
	return game.tile_prototypes
end

function api.game.tick()
	return game.tick
end

function api.game.create_surface(name, mapgensettings)
	return (type(name) == "string" and struct.is_MapGenSettings(mapgensettings)) and game.create_surface(name, mapgensettings) or nil
end

--[[
LuaGroup
]]
api.group = {}

--[[
LuaGui
]]
api.gui = {}

--[[
LuaGuiElement
]]
api.gui_element = {}

--[[
LuaInventory
]]
api.inventory = {}

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
LuaItemPrototype
]]
api.item_prototype = {}

--[[
LuaItemStack
]]
api.item_stack = {}

--[[
LuaLogisticCell
]]
api.logistic_cell = {}

--[[
LuaLogisticNetwork
]]
api.logistic_network = {}

--[[
LuaPlayer
]]
api.player = {}

--[[
LuaRecipe
]]
api.recipe = {}

--[[
LuaRemote
]]

--[[
LuaStyle
]]
api.style = {}

--[[
LuaSurface
]]
api.surface = {}
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

function api.surface.spill_items(surface, position, itemstack)
	if api.valid(surface) and struct.is_ItemStack(itemstack) and struct.is_Position(position) then
		surface.spill_item_stack(position, itemstack)
	end
end
--[[
LuaTechnology
]]
api.technology = {}

--[[
LuaTile,
LuaTilePrototype
]]
api.tile = {}

--[[
LuaTrain
]]
api.train = {}
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
LuaTransportLine
]]
api.transport_line = {}

--[[
LuaUnitGroup
]]
api.unit_group = {}