require("script.enum")

local iconpath, gfxpath, filetype = "__Surfaces__/graphics/icons/transport/", "__Surfaces__/graphics/entity/transport/", ".png"
local enum_data = enum.prototype.entity.access_shaft

local access_shaft = {
	type = enum_data.type,
    flags = {},
    minable = {mining_time = enum_data.mining_time},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {priority = "high", width = 96, height = 96, direction_count = 1, shift = {0, 0}},
	resistances = enum_data.resistances,
	render_layer = "object",
	collision_mask = {"object-layer", "player-layer"},
	order = enum_data.order,
	map_color = enum_data.map_colour
}

local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.minable.result = underground_entrance.name
underground_entrance.pictures.filename = gfxpath .. underground_entrance.name .. filetype
underground_entrance.icon = iconpath .. underground_entrance.name .. filetype
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.minable.result = underground_exit.name
underground_exit.pictures.filename = gfxpath .. underground_exit.name .. filetype
underground_exit.icon = iconpath .. underground_exit.name .. filetype
data:extend({underground_exit})

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.minable.result = sky_entrance.name
sky_entrance.pictures.filename = gfxpath .. sky_entrance.name .. filetype
sky_entrance.icon = iconpath .. sky_entrance.name .. filetype
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.minable.result = sky_exit.name
sky_exit.pictures.filename = gfxpath .. sky_exit.name .. filetype
sky_exit.icon = iconpath .. sky_exit.name .. filetype
data:extend({sky_exit})
