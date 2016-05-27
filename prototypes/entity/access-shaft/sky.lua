data:extend({{
	type = "simple-entity",
    name = "sky-entrance",
    flags = {},
    minable = {mining_time = 5, result = "sky-entrance"},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {filename = "__Surfaces__/graphics/entity/access-shaft/sky-entrance.png", priority = "high", width = 96, height = 96, direction_count = 1, shift = {0, 0}},
	resistances = {{type = "physical", percent = 20}, {type = "impact", percent = 20}, {type = "poison", percent = 100}},
	render_layer = "object",
	collision_mask = {"object-layer","player-layer"}
},{
	type = "simple-entity",
    name = "sky-exit",
    flags = {},
    minable = {mining_time = 5, result="sky-exit"},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {filename = "__Surfaces__/graphics/entity/access-shaft/sky-exit.png", priority = "high", width = 96, height = 96, direction_count = 1, shift = {0, 0}},
	resistances = {{type = "physical", percent = 20}, {type = "impact", percent = 20}, {type = "poison", percent = 100}},
	render_layer = "object",
	collision_mask = {"object-layer","player-layer"}
}})