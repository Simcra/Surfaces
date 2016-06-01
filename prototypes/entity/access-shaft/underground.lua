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

local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.minable.result = "underground-entrance"
underground_entrance.pictures.filename = "__Surfaces__/graphics/entity/access-shaft/underground-entrance.png"
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.minable.result = "underground-exit"
underground_exit.pictures.filename = "__Surfaces__/graphics/entity/access-shaft/underground-exit.png"
data:extend({underground_exit})
