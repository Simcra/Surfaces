local transport_chest = {type = "recipe", group = "surfaces", subgroup = "surfaces-transport-chests", enabled = true}
local wood_chest = table.deepcopy(transport_chest)
wood_chest.ingredients = {{"wooden-chest", 2}}
local iron_chest = table.deepcopy(transport_chest)
iron_chest.ingredients = {{"iron-chest", 2}}
local steel_chest = table.deepcopy(transport_chest)
steel_chest.ingredients = {{"steel-chest", 2}}
local smart_chest = table.deepcopy(transport_chest)
smart_chest.ingredients = {{"smart-chest", 2}}
local logistic_chest = table.deepcopy(transport_chest)
logistic_chest.ingredients = {{"logistic-chest-requester", 1}, {"logistic-chest-passive-provider", 1}}

local wooden_transport_chest_up = table.deepcopy(wood_chest)
wooden_transport_chest_up.name = "wooden-transport-chest-up"
wooden_transport_chest_up.result = "wooden-transport-chest-up"
data:extend({wooden_transport_chest_up})

local wooden_transport_chest_down = table.deepcopy(wood_chest)
wooden_transport_chest_down.name = "wooden-transport-chest-down"
wooden_transport_chest_down.result = "wooden-transport-chest-down"
data:extend({wooden_transport_chest_down})

local iron_transport_chest_up = table.deepcopy(iron_chest)
iron_transport_chest_up.name = "iron-transport-chest-up"
iron_transport_chest_up.result = "iron-transport-chest-up"
data:extend({iron_transport_chest_up})

local iron_transport_chest_down = table.deepcopy(iron_chest)
iron_transport_chest_down.name = "iron-transport-chest-down"
iron_transport_chest_down.result = "iron-transport-chest-down"
data:extend({iron_transport_chest_down})

local steel_transport_chest_up = table.deepcopy(steel_chest)
steel_transport_chest_up.name = "steel-transport-chest-up"
steel_transport_chest_up.result = "steel-transport-chest-up"
data:extend({steel_transport_chest_up})

local steel_transport_chest_down = table.deepcopy(steel_chest)
steel_transport_chest_down.name = "steel-transport-chest-down"
steel_transport_chest_down.result = "steel-transport-chest-down"
data:extend({steel_transport_chest_down})

local smart_transport_chest_up = table.deepcopy(smart_chest)
smart_transport_chest_up.name = "smart-transport-chest-up"
smart_transport_chest_up.result = "smart-transport-chest-up"
data:extend({smart_transport_chest_up})

local smart_transport_chest_down = table.deepcopy(smart_chest)
smart_transport_chest_down.name = "smart-transport-chest-down"
smart_transport_chest_down.result = "smart-transport-chest-down"
data:extend({smart_transport_chest_down})

local logistic_transport_chest_up = table.deepcopy(logistic_chest)
logistic_transport_chest_up.name = "logistic-transport-chest-up"
logistic_transport_chest_up.result = "logistic-transport-chest-up"
data:extend({logistic_transport_chest_up})

local logistic_transport_chest_down = table.deepcopy(logistic_chest)
logistic_transport_chest_down.name = "logistic-transport-chest-down"
logistic_transport_chest_down.result = "logistic-transport-chest-down"
data:extend({logistic_transport_chest_down})