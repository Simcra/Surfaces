require("script.proto")
local iconpath, gfxpath, filetype = "__Surfaces__/graphics/icons/transport/", "__Surfaces__/graphics/entity/transport/", ".png"

local underground_entrance = table.deepcopy(proto.entity.access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.minable.result = underground_entrance.name
underground_entrance.pictures.filename = gfxpath .. underground_entrance.name .. filetype
underground_entrance.icon = iconpath .. underground_entrance.name .. filetype
data:extend({underground_entrance})

local underground_exit = table.deepcopy(proto.entity.access_shaft)
underground_exit.name = "underground-exit"
underground_exit.minable.result = underground_exit.name
underground_exit.pictures.filename = gfxpath .. underground_exit.name .. filetype
underground_exit.icon = iconpath .. underground_exit.name .. filetype
data:extend({underground_exit})

local sky_entrance = table.deepcopy(proto.entity.access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.minable.result = sky_entrance.name
sky_entrance.pictures.filename = gfxpath .. sky_entrance.name .. filetype
sky_entrance.icon = iconpath .. sky_entrance.name .. filetype
data:extend({sky_entrance})

local sky_exit = table.deepcopy(proto.entity.access_shaft)
sky_exit.name = "sky-exit"
sky_exit.minable.result = sky_exit.name
sky_exit.pictures.filename = gfxpath .. sky_exit.name .. filetype
sky_exit.icon = iconpath .. sky_exit.name .. filetype
data:extend({sky_exit})
