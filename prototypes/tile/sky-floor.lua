require("script.enum")
local gfxpath, prefix, filetype = "__Surfaces__/graphics/terrain/sky/", "floor-", ".png"
local enum_data = enum.prototype.tile.sky_floor

local sky_floor = table.deepcopy(data.raw.tile["out-of-map"])
sky_floor.name = enum_data.name
sky_floor.needs_correction = false
sky_floor.decorative_removal_probability = 1
sky_floor.layer = enum_data.layer
sky_floor.collision_mask = {"ground-tile", "resource-layer", "object-layer", "player-layer", "doodad-layer"}
sky_floor.variants = {
	main = {{picture = gfxpath .. prefix .. "main" .. filetype, count = 4, size = 1}},
	inner_corner = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	outer_corner = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	side = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	u_transition = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0},
	o_transition = {picture = gfxpath .. prefix .. "main" .. filetype, count = 0}}
sky_floor.map_color = enum_data.map_colour
data:extend({sky_floor})