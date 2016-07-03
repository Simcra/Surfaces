require("script.proto")
local gfxpath, filetype = "__Surfaces__/graphics/terrain/underground/", ".png"

-- underground floor
local dirt = table.deepcopy(data.raw["tile"]["dirt"])
for k, v in pairs(proto.tile.underground_dirt) do
	dirt[k] = v
end
dirt.variants = {
	main = {{picture = gfxpath .. "floor-main" .. filetype, count = 4, size = 1}},
	inner_corner = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	outer_corner = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	side = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	u_transition = {picture = gfxpath .. "floor-main" .. filetype, count = 0},
	o_transition = {picture = gfxpath .. "floor-main" .. filetype, count = 0}}
data:extend({dirt})