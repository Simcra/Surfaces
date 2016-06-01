local access_shaft = {type = "item", flags = {}, stack_size = 1}

local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.icon = "__Surfaces__/graphics/icons/access-shaft/underground-access-shaft-upper.png"
underground_entrance.place_result = "underground-entrance"
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.icon = "__Surfaces__/graphics/icons/access-shaft/underground-access-shaft-lower.png"
underground_exit.place_result = "underground-exit"
data:extend({underground_exit})