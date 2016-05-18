--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

function get_tiles_in_area(area)
	return get_tiles_in_area_coordinates(area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

function get_tiles_in_area_coordinates(x1,y1,x2,y2)
	local result = {}
	local pos_x=x1
	local pos_y=y1
	while pos_y <= y2 do
		pos_x=x1
		while pos_x <= x2 do
			table.insert(result, {x=pos_x, y=pos_y})
			pos_x=pos_x+1
		end
		pos_y=pos_y+1
	end
	return result
end

function find_nearby_entity_by_name(entity, radius, surface, entity_name)
	for k, v in pairs(surface.find_entities_filtered({area={{entity.position.x-radius,entity.position.y-radius},{entity.position.x+radius,entity.position.y+radius}},name=entity_name})) do
		return v
	end
	return nil
end