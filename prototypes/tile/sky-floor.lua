data:extend({{
	type = "tile",
	name = "sky-floor",
	needs_correction = true,
	mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
	collision_mask = {"ground-tile", "resource-layer", "object-layer", "player-layer", "doodad-layer"},
	decorative_removal_probability = 1,
	layer = 59,
	variants = {
		main = {{
			picture = "__Surfaces__/graphics/terrain/sky/floor.png",
			count = 4,
			size = 1
		}},
		inner_corner = {
			picture = "__Surfaces__/graphics/terrain/sky/wall.png",
			count = 0,
		},
		outer_corner = {
			picture = "__Surfaces__/graphics/terrain/sky/wall.png",
			count = 0,
		},
		side = {
			picture = "__Surfaces__/graphics/terrain/sky/wall.png",
			count = 0,
		},
		u_transition = {
			picture = "__Surfaces__/graphics/terrain/sky/wall.png",
			count = 0,
		},
		o_transition = {
			picture = "__Surfaces__/graphics/terrain/sky/wall.png",
			count = 0,
		}
	},
	map_color={r=0, g=0, b=0},
    ageing=0
}})