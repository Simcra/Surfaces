require("script.proto")
local gfxpath, filetype = "__Surfaces__/graphics/terrain/sky/", ".png"

-- platform
local platform = table.deepcopy(data.raw["tile"]["concrete"])
for k, v in pairs(proto.tile.platform) do
	platform[k] = v
end
data:extend({platform})

-- sky
local sky = table.deepcopy(data.raw["tile"]["out-of-map"])
for k, v in pairs(proto.tile.sky) do
	sky[k] = v
end
sky.variants = {
	main = {{picture = gfxpath .. "floor-main" .. filetype, count = 4, size = 1}},
	inner_corner = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	outer_corner = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	side = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	u_transition = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	o_transition = {picture = gfxpath .. "floor-main" .. filetype, count = 0}}
data:extend({sky})