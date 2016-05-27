--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

function get_tiles_in_area(area)
	return get_tiles_in_bounding_box(area.left_top.x, area.left_top.y, area.right_bottom.x, area.right_bottom.y)
end

function get_tiles_in_bounding_box(x1,y1,x2,y2)
	local result, pos_x, pos_y = {}, x1, y1
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

function get_player(identifier)
	return game.get_player(identifier) --pre 0.13
	--return game.players[identifier] --post 0.13
end

function get_surface(identifier)
	return game.get_surface(identifier) --pre 0.13
	--return game.surfaces[identifier] --post 0.13
end

function table.val_to_str(v)
	if type(v) == "string" then
		v = string.gsub(v, "\n", "\\n")
		if string.match(string.gsub(v,"[^'\"]",""), '^"+$') then
			return "'"..v.."'"
		end
		return '"'..string.gsub(v,'"', '\\"' )..'"'
	else
		return type(v) == "table" and table.tostring(v) or tostring(v)
	end
end

function table.key_to_str (k)
	if "string" == type (k) and string.match(k, "^[_%a][_%a%d]*$") then
		return k
	else
		return "["..table.val_to_str(k).."]"
	end
end

function table.tostring(tbl)
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end
	for k, v in pairs(tbl) do
		if not done[k] then
			table.insert(result, table.key_to_str(k).."="..table.val_to_str(v))
		end
	end
	return "{"..table.concat(result, ",").."}"
end