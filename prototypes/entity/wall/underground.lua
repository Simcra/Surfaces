data:extend({{
	type = "tree",
    name = "underground-wall",
	icon = "__Surfaces__/graphics/terrain/underground/wall2.png",
	flags = {"placeable-neutral"},
	minable = {mining_time = 0.1, mining_particle = "stone-particle", result="stone", count=2},
	corpse = "invisible-corpse",
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
},{
	type = "corpse",
	name = "invisible-corpse",
	flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
	icon = "__Surfaces__/graphics/icons/blank.png",
	collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selectable_in_game = false,
    dying_speed = 0.04,
    time_before_removed = 60,
    subgroup="corpses",
    order = "c[corpse]-b[invisible-corpse]",
    final_render_layer = "corpse",
  },
}})