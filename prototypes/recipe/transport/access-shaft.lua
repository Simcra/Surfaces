local access_shaft = {
	type = "recipe",
	enabled = true,
	group = "surfaces",
	subgroup = "surfaces-transport-player",
	ingredients = {{"wood", 48}, {"steel-plate", 16}},
	result_count = 1
}

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.result = sky_entrance.name
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.result = sky_exit.name
data:extend({sky_exit})
	
local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.result = underground_entrance.name
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.result = underground_exit.name
data:extend({underground_exit})