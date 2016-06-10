--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.struct")
require("script.lib.util")

--[[
The below functions are referenced heavily throughout this mod and serve as middle-man between my mod and the LuaAPI.
This allows fixes for mod-breaking changes in Factorio to be created much faster and easier.
Each section contains a header specifying which LuaAPI class the below functions belong to, the first section is for generic shared functions.
]]

-- util.is_valid(object) should be here but circular references prevent that, instead it can be found in util.lua

function util.get_name(object)
	return object and (type(object) == "string" and object or ((util.is_valid(object) and object.name) and object.name or tostring(object))) or nil
end

function util.get_type(object)
	return util.is_valid(object) and object.type or nil
end

function util.get_inventory(entity, inventory_id)
	return (util.is_valid(entity) and inventory_id) and entity.get_inventory(inventory_id) or nil
end

function util.destroy(entity)
	if entity ~= nil then
		entity.destroy()
	end
end

--[[
LuaEntity (http://lua-api.factorio.com/0.12.35/LuaEntity.html)
]]
function util.teleport(entity, position, surface)
	if util.is_valid(entity) and util.is_valid(surface) and struct.is_Position(position) then
		entity.teleport(position, surface)
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
LuaFluidBox (http://lua-api.factorio.com/0.12.35/LuaFluidBox.html)
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
function util.get_player(id)
	return id and game.get_player(id) or nil --pre 0.13
	--return id and game.players[id] --post 0.13
end

function util.get_surface(id)
	return id and game.get_surface(id) or nil --pre 0.13
	--return id and game.surfaces[id] or nil --post 0.13
end

function util.get_entity_prototypes()
	return game.entity_prototypes
end

function util.get_tile_prototypes() -- will not work until 0.13
	--return game.tile_prototypes 
end

function util.game_tick()
	return game.tick
end

function util.create_surface(name, mapgensettings)
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
function util.get_contents(inventory)
	return util.is_valid(inventory) and inventory.get_contents() or nil
end

function util.can_insert(inventory, itemstack)
	return (util.is_valid(inventory) and struct.is_ItemStack(itemstack)) and inventory.can_insert(itemstack) or false
end

function util.insert_itemstack(inventory, itemstack)
	return (util.is_valid(inventory) and struct.is_ItemStack(itemstack) and itemstack.count > 0) and inventory.insert(itemstack) or 0
end

function util.remove_itemstack(inventory, itemstack)
	return (util.is_valid(inventory) and struct.is_ItemStack(itemstack) and itemstack.count > 0) and inventory.remove(itemstack) or 0
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
function util.can_place_entity(surface, entity_data) -- entity_data is name, position, direction and force
	return (util.is_valid(surface) and entity_data and entity_data.name and struct.is_Position(entity_data.position)) and surface.can_place_entity(entity_data) or false
end

function util.create_entity(surface, entity_data) -- entity_data is name, position and other optional entity parameters (see LuaAPI docs)
	return (util.is_valid(surface) and entity_data and entity_data.name and struct.is_Position(entity_data.position)) and surface.create_entity(entity_data) or nil
end

function util.count_entities(surface, area, entity_name, entity_type, entity_force)
	return (util.is_valid(surface) and struct.is_BoundingBox(area)) and surface.count_entities_filtered({area=area, name=entity_name, type=entity_type, force=entity_force}) or nil
end

function util.find_entities(surface, area, entity_name, entity_type, entity_force)
	return (util.is_valid(surface) and struct.is_BoundingBox(area)) and surface.find_entities_filtered({area=area, name=entity_name, type=entity_type, force=entity_force}) or nil
end

function util.find_non_colliding_position(surface, prototype, center, radius, precision)
	return (util.is_valid(surface) and prototype and util.get_entity_prototypes()[prototype] and struct.is_Position(center) and radius and precision) and surface.find_non_colliding_position(prototype, center, radius, precision) or nil
end

function util.get_tile(surface, position)
	return (util.is_valid(surface) and struct.is_Position(position)) and surface.get_tile(position.x, position.y) or nil
end

function util.get_tile_properties(surface, position)
	return (util.is_valid(surface) and struct.is_Position(position)) and surface.get_tileproperties(position.x, position.y) or nil
end

function util.get_chunk_iterator(surface)
	return util.is_valid(surface) and surface.get_chunks() or nil
end

function util.request_generate_chunks(surface, position, radius)
	if util.is_valid(surface) and struct.is_Position(position) then
		surface.request_to_generate_chunks(position, radius or 0)
	end
end

function util.get_pollution(surface, position)
	return (util.is_valid(surface) and struct.is_Position(position)) and surface.get_pollution(position) or nil
end

function util.create_pollution(surface, position, amount)
	if util.is_valid(surface) and struct.is_Position(position) and amount then
		surface.pollute(position, amount)
	end
end

function util.set_tiles(surface, tiles)
	if util.is_valid(surface) and struct.is_Tiles(tiles) then
		surface.set_tiles(tiles)
	end
end

function util.get_map_gen_settings(surface)
	return (surface and util.is_valid(surface)) and surface.map_gen_settings
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

--[[
LuaTransportLine (http://lua-api.factorio.com/0.12.35/LuaTransportLine.html)
]]

--[[
LuaUnitGroup (http://lua-api.factorio.com/0.12.35/LuaUnitGroup.html)
]]
