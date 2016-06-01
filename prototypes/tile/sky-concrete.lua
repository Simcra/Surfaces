data:extend({{
	type = "tile",
	name = "sky-concrete",
	needs_correction = false,
	mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
	collision_mask = {"ground-tile", "floor-layer", "doodad-layer"},
	walking_speed_modifier = 1.4,
	layer = 58,
	decorative_removal_probability = 1,
	variants = {
		main = {
			{picture = "__base__/graphics/terrain/concrete/concrete1.png", count = 16, size = 1},
			{picture = "__base__/graphics/terrain/concrete/concrete2.png", count = 4, size = 2, probability = 0.39},
			{picture = "__base__/graphics/terrain/concrete/concrete4.png", count = 4, size = 4, probability = 1}},
		inner_corner = {picture = "__base__/graphics/terrain/concrete/concrete-inner-corner.png", count = 8},
		outer_corner = {picture = "__base__/graphics/terrain/concrete/concrete-outer-corner.png", count = 8},
		side = {picture = "__base__/graphics/terrain/concrete/concrete-side.png", count = 8},
		u_transition = {picture = "__base__/graphics/terrain/concrete/concrete-u.png", count = 8},
		o_transition = {picture = "__base__/graphics/terrain/concrete/concrete-o.png", count = 1}},
	walking_sound = {{filename = "__base__/sound/walking/concrete-01.ogg", volume = 1.2},
		{filename = "__base__/sound/walking/concrete-02.ogg", volume = 1.2},
		{filename = "__base__/sound/walking/concrete-03.ogg", volume = 1.2},
		{filename = "__base__/sound/walking/concrete-04.ogg", volume = 1.2}},
	map_color={r=100, g=100, b=100},
	ageing=0,
	vehicle_friction_modifier = 0.8
}})