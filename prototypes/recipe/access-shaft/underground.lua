local access_shaft_components = {type = "recipe", group = "surfaces", subgroup = "surfaces-components", enabled = true, result = "access-shaft-components", result_count = 16}
	
local access_shaft = table.deepcopy(access_shaft_components)
access_shaft.subgroup = "access-shaft"
access_shaft.ingredients = {{"access-shaft-components", 16}}
access_shaft.result_count = 1

local underground_entrance = table.deepcopy(access_shaft)
underground_entrance.name = "underground-entrance"
underground_entrance.result = "underground-entrance"
data:extend({underground_entrance})

local underground_exit = table.deepcopy(access_shaft)
underground_exit.name = "underground-exit"
underground_exit.result = "underground-exit"
data:extend({underground_exit})

local access_shaft_components_2 = table.deepcopy(access_shaft_components)
access_shaft_components_2.name = "access-shaft-components-3"
access_shaft_components_2.ingredients = {{"underground-exit", 1}}
data:extend({access_shaft_components_2})

local access_shaft_components_3 = table.deepcopy(access_shaft_components)
access_shaft_components_3.name = "access-shaft-components-4"
access_shaft_components_3.ingredients = {{"underground-entrance", 1}}
data:extend({access_shaft_components_3})