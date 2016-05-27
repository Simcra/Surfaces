data:extend({{
	type = "electric-pole",
	name = "electric-pole-upper",
	icon = "__Surfaces__/graphics/icons/transport/electric-pole-upper.png",
	flags = {"placeable-neutral", "player-creation"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "electric-pole-upper"},
	max_health = 100,
	corpse = "small-remnants",
	resistances = {{type = "fire", percent = 100}},
	collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	drawing_box = {{-0.5, -2.8}, {0.5, 0.5}},
	maximum_wire_distance = 9,
	supply_area_distance = 3.5,
	vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
	pictures = {filename = "__base__/graphics/entity/medium-electric-pole/medium-electric-pole.png", priority = "high", width = 136, height = 122, direction_count = 4, shift = {1.4, -1.0}},
	connection_points = {{	
		shadow = {copper = {2.55, 0.4}, green = {2.0, 0.4}, red = {3.05, 0.4}},
		wire = {copper = {-0.03, -2.5}, green = {-0.35,-2.5}, red = {0.25,-2.5}}
	}, {
		shadow = {copper = {2.9, 0.1}, green = {2.6, -0.15}, red = {3.25, 0.35}},
		wire = {copper = {0.05, -2.75}, green = {-0.15, -2.9}, red = {0.25, -2.55}}
	}, {
		shadow = {copper = {1.5, -0.2}, green = {1.5, -0.55}, red = {1.5, 0.1}},
		wire = {copper = {-0.43, -2.4}, green = {-0.43, -2.63}, red = {-0.43, -2.2}}
	}, {
		shadow = {copper = {2.88, 0.2}, green = {3.2, -0.1}, red = {2.45, 0.4}},
		wire = {copper = {0, -2.7}, green = {0.22, -2.85}, red = {-0.24, -2.55}}
	}},
	radius_visualisation_picture = {filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png", width = 12, height = 12, priority = "extra-high-no-scale"}
},{
	type = "electric-pole",
	name = "electric-pole-lower",
	icon = "__Surfaces__/graphics/icons/transport/electric-pole-lower.png",
	flags = {"placeable-neutral", "player-creation"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "electric-pole-lower"},
	max_health = 100,
	corpse = "small-remnants",
	resistances = {{type = "fire", percent = 100}},
	collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	drawing_box = {{-0.5, -2.8}, {0.5, 0.5}},
	maximum_wire_distance = 9,
	supply_area_distance = 3.5,
	vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
	pictures = {filename = "__base__/graphics/entity/medium-electric-pole/medium-electric-pole.png", priority = "high", width = 136, height = 122, direction_count = 4, shift = {1.4, -1.0}},
	connection_points = {{	
		shadow = {copper = {2.55, 0.4}, green = {2.0, 0.4}, red = {3.05, 0.4}},
		wire = {copper = {-0.03, -2.5}, green = {-0.35,-2.5}, red = {0.25,-2.5}}
	}, {
		shadow = {copper = {2.9, 0.1}, green = {2.6, -0.15}, red = {3.25, 0.35}},
		wire = {copper = {0.05, -2.75}, green = {-0.15, -2.9}, red = {0.25, -2.55}}
	}, {
		shadow = {copper = {1.5, -0.2}, green = {1.5, -0.55}, red = {1.5, 0.1}},
		wire = {copper = {-0.43, -2.4}, green = {-0.43, -2.63}, red = {-0.43, -2.2}}
	}, {
		shadow = {copper = {2.88, 0.2}, green = {3.2, -0.1}, red = {2.45, 0.4}},
		wire = {copper = {0, -2.7}, green = {0.22, -2.85}, red = {-0.24, -2.55}}
	}},
	radius_visualisation_picture = {filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png", width = 12, height = 12, priority = "extra-high-no-scale"}
}})