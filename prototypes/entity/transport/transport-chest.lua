-- Transport chests
local wooden_transport_chest_up = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_transport_chest_up.name = "wooden-transport-chest-up"
wooden_transport_chest_up.icon = "__Surfaces__/graphics/icons/transport/wooden-transport-chest-up.png"
wooden_transport_chest_up.minable.result = "wooden-transport-chest-up"
data:extend({wooden_transport_chest_up})

local wooden_transport_chest_down = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_transport_chest_down.name = "wooden-transport-chest-down"
wooden_transport_chest_down.icon = "__Surfaces__/graphics/icons/transport/wooden-transport-chest-down.png"
wooden_transport_chest_down.minable.result = "wooden-transport-chest-down"
data:extend({wooden_transport_chest_down})

local iron_transport_chest_up = table.deepcopy(data.raw["container"]["iron-chest"])
iron_transport_chest_up.name = "iron-transport-chest-up"
iron_transport_chest_up.icon = "__Surfaces__/graphics/icons/transport/iron-transport-chest-up.png"
iron_transport_chest_up.minable.result = "iron-transport-chest-up"
data:extend({iron_transport_chest_up})

local iron_transport_chest_down = table.deepcopy(data.raw["container"]["iron-chest"])
iron_transport_chest_down.name = "iron-transport-chest-down"
iron_transport_chest_down.icon = "__Surfaces__/graphics/icons/transport/iron-transport-chest-down.png"
iron_transport_chest_down.minable.result = "iron-transport-chest-down"
data:extend({iron_transport_chest_down})

local steel_transport_chest_up = table.deepcopy(data.raw["container"]["steel-chest"])
steel_transport_chest_up.name = "steel-transport-chest-up"
steel_transport_chest_up.icon = "__Surfaces__/graphics/icons/transport/steel-transport-chest-up.png"
steel_transport_chest_up.minable.result = "steel-transport-chest-up"
data:extend({steel_transport_chest_up})

local steel_transport_chest_down = table.deepcopy(data.raw["container"]["steel-chest"])
steel_transport_chest_down.name = "steel-transport-chest-down"
steel_transport_chest_down.icon = "__Surfaces__/graphics/icons/transport/steel-transport-chest-down.png"
steel_transport_chest_down.minable.result = "steel-transport-chest-down"
data:extend({steel_transport_chest_down})

local smart_transport_chest_up = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_transport_chest_up.name = "smart-transport-chest-up"
smart_transport_chest_up.icon = "__Surfaces__/graphics/icons/transport/smart-transport-chest-up.png"
smart_transport_chest_up.minable.result = "smart-transport-chest-up"
data:extend({smart_transport_chest_up})

local smart_transport_chest_down = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_transport_chest_down.name = "smart-transport-chest-down"
smart_transport_chest_down.icon = "__Surfaces__/graphics/icons/transport/smart-transport-chest-down.png"
smart_transport_chest_down.minable.result = "smart-transport-chest-down"
data:extend({smart_transport_chest_down})

local logistic_transport_chest_up = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_transport_chest_up.name = "logistic-transport-chest-up"
logistic_transport_chest_up.icon = "__Surfaces__/graphics/icons/transport/logistic-transport-chest-up.png"
logistic_transport_chest_up.minable.result = "logistic-transport-chest-up"
data:extend({logistic_transport_chest_up})

local logistic_transport_chest_down = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_transport_chest_down.name = "logistic-transport-chest-down"
logistic_transport_chest_down.icon = "__Surfaces__/graphics/icons/transport/logistic-transport-chest-down.png"
logistic_transport_chest_down.minable.result = "logistic-transport-chest-down"
data:extend({logistic_transport_chest_down})

-- Receiver chests
local wooden_receiver_chest_lower = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_receiver_chest_lower.name = "wooden-receiver-chest-lower"
wooden_receiver_chest_lower.minable.result = "wooden-transport-chest-down"
wooden_receiver_chest_lower.flags = {}
data:extend({wooden_receiver_chest_lower})

local wooden_receiver_chest_upper = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_receiver_chest_upper.name = "wooden-receiver-chest-upper"
wooden_receiver_chest_upper.minable.result = "wooden-transport-chest-up"
wooden_receiver_chest_upper.flags = {}
data:extend({wooden_receiver_chest_upper})

local iron_receiver_chest_lower = table.deepcopy(data.raw["container"]["iron-chest"])
iron_receiver_chest_lower.name = "iron-receiver-chest-lower"
iron_receiver_chest_lower.minable.result = "iron-transport-chest-down"
iron_receiver_chest_lower.flags = {}
data:extend({iron_receiver_chest_lower})

local iron_receiver_chest_upper = table.deepcopy(data.raw["container"]["iron-chest"])
iron_receiver_chest_upper.name = "iron-receiver-chest-upper"
iron_receiver_chest_upper.minable.result = "iron-transport-chest-up"
iron_receiver_chest_upper.flags = {}
data:extend({iron_receiver_chest_upper})

local steel_receiver_chest_lower = table.deepcopy(data.raw["container"]["steel-chest"])
steel_receiver_chest_lower.name = "steel-transport-chest-lower"
steel_receiver_chest_lower.minable.result = "steel-transport-chest-down"
steel_receiver_chest_lower.flags = {}
data:extend({steel_receiver_chest_lower})

local steel_receiver_chest_upper = table.deepcopy(data.raw["container"]["steel-chest"])
steel_receiver_chest_upper.name = "steel-receiver-chest-upper"
steel_receiver_chest_upper.minable.result = "steel-transport-chest-up"
steel_receiver_chest_upper.flags = {}
data:extend({steel_receiver_chest_upper})

local smart_receiver_chest_lower = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_receiver_chest_lower.name = "smart-receiver-chest-lower"
smart_receiver_chest_lower.minable.result = "smart-transport-chest-down"
smart_receiver_chest_lower.flags = {}
data:extend({smart_receiver_chest_lower})

local smart_receiver_chest_upper = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_receiver_chest_upper.name = "smart-receiver-chest-upper"
smart_receiver_chest_upper.minable.result = "smart-transport-chest-up"
smart_receiver_chest_upper.flags = {}
data:extend({smart_receiver_chest_upper})

local logistic_receiver_chest_lower = table.deepcopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
logistic_receiver_chest_lower.name = "logistic-receiver-chest-lower"
logistic_receiver_chest_lower.minable.result = "logistic-transport-chest-down"
logistic_receiver_chest_lower.flags = {}
data:extend({logistic_receiver_chest_lower})

local logistic_receiver_chest_upper = table.deepcopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
logistic_receiver_chest_upper.name = "logistic-receiver-chest-upper"
logistic_receiver_chest_upper.minable.result = "logistic-transport-chest-up"
logistic_receiver_chest_upper.flags = {}
data:extend({logistic_receiver_chest_upper})