data:extend({{
	type = "tile",
	name = "underground-floor",
	needs_correction = false,
	mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
	collision_mask = {"ground-tile", "doodad-layer"},
	decorative_removal_probability = 1,
	layer = 59,
	variants = {
		main = {{picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 4, size = 1}},
		inner_corner = {picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 0},
		outer_corner = {picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 0},
		side = {picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 0},
		u_transition = {picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 0},
		o_transition = {picture = "__Surfaces__/graphics/terrain/underground/floor.png", count = 0}},
	walking_sound = {{filename = "__base__/sound/walking/dirt-02.ogg", volume = 0.8}, {filename = "__base__/sound/walking/dirt-03.ogg", volume = 0.8}, {filename = "__base__/sound/walking/dirt-04.ogg", volume = 0.8}},
	map_color={r=0, g=0, b=0},
	ageing=0
}})