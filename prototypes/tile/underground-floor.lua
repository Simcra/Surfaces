require("script.enum")
local gfxpath, prefix, filetype = "__Surfaces__/graphics/terrain/underground/", "floor-", ".png"
local enum_data = enum.prototype.tile.underground_floor

local underground_floor = table.deepcopy(data.raw.tile["dirt"])
underground_floor.name = enum_data.name
underground_floor.needs_correction = false
underground_floor.collision_mask = {"ground-tile"--[[, "doodad-layer"]]}
underground_floor.decorative_removal_probability = 1
underground_floor.layer = enum_data.layer
underground_floor.variants = {
	main = {{picture = gfxpath .. prefix .. "main" .. filetype, count = 4, size = 1}},
	inner_corner = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	outer_corner = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	side = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	u_transition = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	o_transition = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0}}
underground_floor.walking_speed_modifier = enum_data.walking_speed_modifier
underground_floor.map_color = enum_data.map_colour
underground_floor.ageing = 0
data:extend({underground_floor})