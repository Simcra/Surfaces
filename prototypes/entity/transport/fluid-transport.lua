data:extend({{
	type = "storage-tank",
	name = "fluid-transport-upper",
	icon = "__Surfaces__/graphics/icons/transport/fluid-transport-upper.png",
	flags = {"placeable-neutral", "player-creation"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "fluid-transport-upper"},
	max_health = 100,
	corpse = "small-remnants",
	collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	fluid_box = {
		base_area = 25,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {{position = {0, 1}}, {position = {0, -1}}, {position = {1, 0}}, {position = {-1, 0}}}},
	window_bounding_box = {{0, 0}, {0, 0}},
	pictures = {
		picture = {sheet = {filename = "__Surfaces__/graphics/entity/transport/fluid-transport-upper.png", priority = "extra-high", frames = 1, width = 32, height = 32, shift = {0, 0}}},
		fluid_background = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32},
		window_background = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32},
		flow_sprite = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32}},
	flow_length_in_ticks = 360,
	vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
	working_sound = {sound = {filename = "__base__/sound/storage-tank.ogg", volume = 0.8}, apparent_volume = 1.5, max_sounds_per_type = 3},
	circuit_wire_connection_points = {{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	}},
	circuit_wire_max_distance = 7.5
}, {
	type = "storage-tank",
	name = "fluid-transport-lower",
	icon = "__Surfaces__/graphics/icons/transport/fluid-transport-lower.png",
	flags = {"placeable-neutral", "player-creation"},
	minable = {hardness = 0.2, mining_time = 0.5, result = "fluid-transport-lower"},
	max_health = 100,
	corpse = "small-remnants",
	collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	fluid_box = {
		base_area = 25,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {{position = {0, 1}}, {position = {0, -1}}, {position = {1, 0}}, {position = {-1, 0}}}},
	window_bounding_box = {{-0.4, -0.4}, {0.4, 0.4}},
	pictures = {
		picture = {sheet = {filename = "__Surfaces__/graphics/entity/transport/fluid-transport-lower.png", priority = "extra-high", frames = 1, width = 32, height = 32, shift = {0, 0}}},
		fluid_background = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32},
		window_background = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32},
		flow_sprite = {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", width = 32, height = 32}},
	flow_length_in_ticks = 360,
	vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
	working_sound = {sound = {filename = "__base__/sound/storage-tank.ogg", volume = 0.8}, apparent_volume = 1.5, max_sounds_per_type = 3},
	circuit_wire_connection_points = {{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	},{
		shadow = {red = {0.2, 0.5}, green = {0.2, 0.5}},
		wire = {red = {0, 0}, green = {0, 0}}
	}},
	circuit_wire_max_distance = 7.5
}})