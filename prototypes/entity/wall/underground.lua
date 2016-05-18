data:extend({{
	type = "tree",
    name = "underground-wall",
	icon = "__Surfaces__/graphics/terrain/underground/wall2.png",
	flags = {"placeable-neutral"},
	minable = {mining_time = 0.1, mining_particle = "stone-particle", result="stone", count=2},
	corpse = "wall-remnants",
    max_health = 100,
    collision_box = {{-0.499, -0.499}, {0.499, 0.499}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	order = "a",
	pictures = {{filename = "__Surfaces__/graphics/terrain/underground/wall.png", priority = "extra-high", width = 32, height = 32}},
	mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
    vehicle_impact_sound =  {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
	resistances = {{
		type = "physical",
		percent = 80,
	}, {
		type = "poison",
		percent = 100,
	}, {
		type = "fire",
		percent = 100,
	}, {
		type = "acid",
		percent = 95,
	}, {
		type = "explosion",
		percent = 5
	}},
}--[[,{
	type = "item",
	name = "fake-wall",
	icon = "__Surfaces__/graphics/terrain/underground/wall2.png",
	flags = {},
	place_result = "underground-wall",
	order = "z",
	stack_size=100
}]]})