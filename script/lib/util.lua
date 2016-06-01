--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]


function get_tiles_in_area(area)
	return get_tiles_in_bounding_box(area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

function get_tiles_in_bounding_box(x1,y1,x2,y2)
	local result = {}
	for pos_y=y1, y2, 1 do
		for pos_x=x1, x2, 1 do
			table.insert(result, {x=pos_x, y=pos_y})
		end
	end
	return result
end

function find_nearby_entity_by_name(entity, radius, surface, entity_name)
	if surface then
		for k, v in pairs(surface.find_entities_filtered({area={{entity.position.x-radius,entity.position.y-radius},{entity.position.x+radius,entity.position.y+radius}},name=entity_name})) do
			return v
		end
	end
	return nil
end

function get_player(identifier)
	return game.get_player(identifier) --pre 0.13
	--return game.players[identifier] --post 0.13
end

function get_surface(identifier)
	return game.get_surface(identifier) --pre 0.13
	--return game.surfaces[identifier] --post 0.13
end

function table.tostring(t)
	result = "{"
	for k, v in pairs(t) do
		if type(v)=="table" then
			result=result..tostring(k).."="..table.tostring(v)..", "
		elseif type(v)=="string" then
			result=result..tostring(k).."="..v..", "
		else
			result=result..tostring(k).."="..tostring(v)..", "
		end
	end
	return result.."}"
end

function Set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end