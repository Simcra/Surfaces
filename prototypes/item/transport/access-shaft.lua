local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local access_shaft = {type = "item", flags = {}, stack_size = 1}

local access_shaft_components = table.deepcopy(data.raw["item"]["electronic-circuit"])
access_shaft_components.place_result = ""
access_shaft_components.flags = {}
access_shaft_components.name = "access-shaft-components"
data:extend({access_shaft_components})

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.icon = iconpath .. sky_entrance.name .. filetype
sky_entrance.place_result = sky_entrance.name
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.icon = iconpath .. sky_exit.name .. filetype
sky_exit.place_result = sky_exit.name
data:extend({sky_exit})

local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.icon = iconpath .. underground_entrance.name .. filetype
underground_entrance.place_result = underground_entrance.name
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.icon = iconpath .. underground_exit.name .. filetype
underground_exit.place_result = underground_exit.name
data:extend({underground_exit})