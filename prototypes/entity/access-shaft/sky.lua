local access_shaft = {
	type = "simple-entity",
    flags = {},
    minable = {mining_time = 5},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {priority = "high", width = 96, height = 96, direction_count = 1, shift = {0, 0}},
	resistances = {{type = "physical", percent = 20}, {type = "impact", percent = 20}, {type = "poison", percent = 100}},
	render_layer = "object",
	collision_mask = {"object-layer","player-layer"}
}

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.minable.result = "sky-entrance"
sky_entrance.pictures.filename = "__Surfaces__/graphics/entity/access-shaft/sky-entrance.png"
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.minable.result = "sky-exit"
sky_exit.pictures.filename = "__Surfaces__/graphics/entity/access-shaft/sky-exit.png"
data:extend({sky_exit})
