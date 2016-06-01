local access_shaft = {type = "item", flags = {}, stack_size = 1}

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.icon = "__Surfaces__/graphics/icons/access-shaft/sky-access-shaft-lower.png"
sky_entrance.place_result = "sky-entrance"
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.icon = "__Surfaces__/graphics/icons/access-shaft/sky-access-shaft-upper.png"
sky_exit.place_result = "sky-exit"
data:extend({sky_exit})