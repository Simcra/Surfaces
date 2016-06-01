local transport_chest = {type = "recipe", group = "surfaces", subgroup = "surfaces-transport", enabled = true, ingredients = {{"logistic-chest-requester", 1}}}

local transport_chest_up = table.deepcopy(transport_chest)
transport_chest_up.name = "transport-chest-up"
transport_chest_up.result = "transport-chest-up"
data:extend({transport_chest_up})

local transport_chest_down = table.deepcopy(transport_chest)
transport_chest_down.name = "transport-chest-down"
transport_chest_down.result = "transport-chest-down"
data:extend({transport_chest_down})