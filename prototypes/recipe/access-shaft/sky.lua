local access_shaft_components = {type = "recipe", group = "surfaces", subgroup = "surfaces-components", enabled = true, result = "access-shaft-components", result_count = 16}
	
local access_shaft = table.deepcopy(access_shaft_components)
access_shaft.subgroup = "surfaces-transport-player"
access_shaft.ingredients = {{"access-shaft-components", 16}}
access_shaft.result_count = 1

local sky_entrance = table.deepcopy(access_shaft)
sky_entrance.name = "sky-entrance"
sky_entrance.result = "sky-entrance"
data:extend({sky_entrance})

local sky_exit = table.deepcopy(access_shaft)
sky_exit.name = "sky-exit"
sky_exit.result = "sky-exit"
data:extend({sky_exit})

local access_shaft_components_2 = table.deepcopy(access_shaft_components)
access_shaft_components_2.name = "access-shaft-components"
access_shaft_components_2.ingredients = {{"sky-exit", 1}}
data:extend({access_shaft_components_2})

local access_shaft_components_3 = table.deepcopy(access_shaft_components)
access_shaft_components_3.name = "access-shaft-components-2"
access_shaft_components_3.ingredients = {{"sky-entrance", 1}}
data:extend({access_shaft_components_3})