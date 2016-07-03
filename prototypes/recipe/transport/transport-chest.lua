local transport_chest = {
	type = "recipe",
	group = "surfaces",
	subgroup = "surfaces-transport-chests",
	enabled = true
}

-- wooden transport chest recipes
local wooden_chest = table.deepcopy(transport_chest)
wooden_chest.ingredients = {{"wooden-chest", 2}, {"simple-servo", 1}, {"burner-inserter", 1}}

local wooden_transport_chest_up = table.deepcopy(wooden_chest)
wooden_transport_chest_up.name = "wooden-transport-chest-up"
wooden_transport_chest_up.result = wooden_transport_chest_up.name
data:extend({wooden_transport_chest_up})

local wooden_transport_chest_down = table.deepcopy(wooden_chest)
wooden_transport_chest_down.name = "wooden-transport-chest-down"
wooden_transport_chest_down.result = wooden_transport_chest_down.name
data:extend({wooden_transport_chest_down})

-- iron transport chest recipes
local iron_chest = table.deepcopy(transport_chest)
iron_chest.ingredients = {{"iron-chest", 2}, {"basic-servo", 1}, {"inserter", 1}}

local iron_transport_chest_up = table.deepcopy(iron_chest)
iron_transport_chest_up.name = "iron-transport-chest-up"
iron_transport_chest_up.result = iron_transport_chest_up.name
data:extend({iron_transport_chest_up})

local iron_transport_chest_down = table.deepcopy(iron_chest)
iron_transport_chest_down.name = "iron-transport-chest-down"
iron_transport_chest_down.result = iron_transport_chest_down.name
data:extend({iron_transport_chest_down})

-- steel transport chest recipes
local steel_chest = table.deepcopy(transport_chest)
steel_chest.ingredients = {{"steel-chest", 2}, {"improved-servo", 1}, {"fast-inserter", 1}}

local steel_transport_chest_up = table.deepcopy(steel_chest)
steel_transport_chest_up.name = "steel-transport-chest-up"
steel_transport_chest_up.result = steel_transport_chest_up.name
data:extend({steel_transport_chest_up})

local steel_transport_chest_down = table.deepcopy(steel_chest)
steel_transport_chest_down.name = "steel-transport-chest-down"
steel_transport_chest_down.result = steel_transport_chest_down.name
data:extend({steel_transport_chest_down})

-- smart transport chest recipes
--[[local smart_chest = table.deepcopy(transport_chest)
smart_chest.ingredients = {{"smart-chest", 2}, {"advanced-servo", 1}, {"fast-inserter", 1}}

local smart_transport_chest_up = table.deepcopy(smart_chest)
smart_transport_chest_up.name = "smart-transport-chest-up"
smart_transport_chest_up.result = smart_transport_chest_up.name
data:extend({smart_transport_chest_up})

local smart_transport_chest_down = table.deepcopy(smart_chest)
smart_transport_chest_down.name = "smart-transport-chest-down"
smart_transport_chest_down.result = smart_transport_chest_down.name
data:extend({smart_transport_chest_down})]]

-- logistic transport chest recipes
local logistic_chest = table.deepcopy(transport_chest)
logistic_chest.ingredients = {{"logistic-chest-requester", 1}, {"logistic-chest-passive-provider", 1}, {"advanced-servo", 1}, {"stack-inserter", 1}}

local logistic_transport_chest_up = table.deepcopy(logistic_chest)
logistic_transport_chest_up.name = "logistic-transport-chest-up"
logistic_transport_chest_up.result = logistic_transport_chest_up.name
data:extend({logistic_transport_chest_up})

local logistic_transport_chest_down = table.deepcopy(logistic_chest)
logistic_transport_chest_down.name = "logistic-transport-chest-down"
logistic_transport_chest_down.result = logistic_transport_chest_down.name
data:extend({logistic_transport_chest_down})