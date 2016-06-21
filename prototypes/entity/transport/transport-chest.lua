local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

-- Transport chests
local wooden_transport_chest_up = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_transport_chest_up.name = "wooden-transport-chest-up"
wooden_transport_chest_up.icon = iconpath .. wooden_transport_chest_up.name .. filetype
wooden_transport_chest_up.minable.result = wooden_transport_chest_up.name
data:extend({wooden_transport_chest_up})

local wooden_transport_chest_down = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_transport_chest_down.name = "wooden-transport-chest-down"
wooden_transport_chest_down.icon = iconpath .. wooden_transport_chest_down.name .. filetype
wooden_transport_chest_down.minable.result = wooden_transport_chest_down.name
data:extend({wooden_transport_chest_down})

local iron_transport_chest_up = table.deepcopy(data.raw["container"]["iron-chest"])
iron_transport_chest_up.name = "iron-transport-chest-up"
iron_transport_chest_up.icon = iconpath .. iron_transport_chest_up.name .. filetype
iron_transport_chest_up.minable.result = iron_transport_chest_up.name
data:extend({iron_transport_chest_up})

local iron_transport_chest_down = table.deepcopy(data.raw["container"]["iron-chest"])
iron_transport_chest_down.name = "iron-transport-chest-down"
iron_transport_chest_down.icon = iconpath .. iron_transport_chest_down.name .. filetype
iron_transport_chest_down.minable.result = iron_transport_chest_down.name
data:extend({iron_transport_chest_down})

local steel_transport_chest_up = table.deepcopy(data.raw["container"]["steel-chest"])
steel_transport_chest_up.name = "steel-transport-chest-up"
steel_transport_chest_up.icon = iconpath .. steel_transport_chest_up.name .. filetype
steel_transport_chest_up.minable.result = steel_transport_chest_up.name
data:extend({steel_transport_chest_up})

local steel_transport_chest_down = table.deepcopy(data.raw["container"]["steel-chest"])
steel_transport_chest_down.name = "steel-transport-chest-down"
steel_transport_chest_down.icon = iconpath .. steel_transport_chest_down.name .. filetype
steel_transport_chest_down.minable.result = steel_transport_chest_down.name
data:extend({steel_transport_chest_down})

local smart_transport_chest_up = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_transport_chest_up.name = "smart-transport-chest-up"
smart_transport_chest_up.icon = iconpath .. smart_transport_chest_up.name .. filetype
smart_transport_chest_up.minable.result = smart_transport_chest_up.name
data:extend({smart_transport_chest_up})

local smart_transport_chest_down = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_transport_chest_down.name = "smart-transport-chest-down"
smart_transport_chest_down.icon = iconpath .. smart_transport_chest_down.name .. filetype
smart_transport_chest_down.minable.result = smart_transport_chest_down.name
data:extend({smart_transport_chest_down})

local logistic_transport_chest_up = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_transport_chest_up.name = "logistic-transport-chest-up"
logistic_transport_chest_up.icon = iconpath .. logistic_transport_chest_up.name .. filetype
logistic_transport_chest_up.minable.result = logistic_transport_chest_up.name
data:extend({logistic_transport_chest_up})

local logistic_transport_chest_down = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_transport_chest_down.name = "logistic-transport-chest-down"
logistic_transport_chest_down.icon = iconpath .. logistic_transport_chest_down.name .. filetype
logistic_transport_chest_down.minable.result = logistic_transport_chest_down.name
data:extend({logistic_transport_chest_down})

-- Receiver chests
local wooden_receiver_chest_lower = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_receiver_chest_lower.name = "wooden-receiver-chest-lower"
wooden_receiver_chest_lower.minable.result = wooden_transport_chest_down.name
wooden_receiver_chest_lower.flags = {}
data:extend({wooden_receiver_chest_lower})

local wooden_receiver_chest_upper = table.deepcopy(data.raw["container"]["wooden-chest"])
wooden_receiver_chest_upper.name = "wooden-receiver-chest-upper"
wooden_receiver_chest_upper.minable.result = wooden_transport_chest_up.name
wooden_receiver_chest_upper.flags = {}
data:extend({wooden_receiver_chest_upper})

local iron_receiver_chest_lower = table.deepcopy(data.raw["container"]["iron-chest"])
iron_receiver_chest_lower.name = "iron-receiver-chest-lower"
iron_receiver_chest_lower.minable.result = iron_transport_chest_down.name
iron_receiver_chest_lower.flags = {}
data:extend({iron_receiver_chest_lower})

local iron_receiver_chest_upper = table.deepcopy(data.raw["container"]["iron-chest"])
iron_receiver_chest_upper.name = "iron-receiver-chest-upper"
iron_receiver_chest_upper.minable.result = iron_transport_chest_up.name
iron_receiver_chest_upper.flags = {}
data:extend({iron_receiver_chest_upper})

local steel_receiver_chest_lower = table.deepcopy(data.raw["container"]["steel-chest"])
steel_receiver_chest_lower.name = "steel-transport-chest-lower"
steel_receiver_chest_lower.minable.result = steel_transport_chest_down.name
steel_receiver_chest_lower.flags = {}
data:extend({steel_receiver_chest_lower})

local steel_receiver_chest_upper = table.deepcopy(data.raw["container"]["steel-chest"])
steel_receiver_chest_upper.name = "steel-receiver-chest-upper"
steel_receiver_chest_upper.minable.result = steel_transport_chest_up.name
steel_receiver_chest_upper.flags = {}
data:extend({steel_receiver_chest_upper})

local smart_receiver_chest_lower = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_receiver_chest_lower.name = "smart-receiver-chest-lower"
smart_receiver_chest_lower.minable.result = smart_transport_chest_down.name
smart_receiver_chest_lower.flags = {}
data:extend({smart_receiver_chest_lower})

local smart_receiver_chest_upper = table.deepcopy(data.raw["smart-container"]["smart-chest"])
smart_receiver_chest_upper.name = "smart-receiver-chest-upper"
smart_receiver_chest_upper.minable.result = smart_transport_chest_up.name
smart_receiver_chest_upper.flags = {}
data:extend({smart_receiver_chest_upper})

local logistic_receiver_chest_lower = table.deepcopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
logistic_receiver_chest_lower.name = "logistic-receiver-chest-lower"
logistic_receiver_chest_lower.minable.result = logistic_transport_chest_down.name
logistic_receiver_chest_lower.flags = {}
data:extend({logistic_receiver_chest_lower})

local logistic_receiver_chest_upper = table.deepcopy(data.raw["logistic-container"]["logistic-chest-passive-provider"])
logistic_receiver_chest_upper.name = "logistic-receiver-chest-upper"
logistic_receiver_chest_upper.minable.result = logistic_transport_chest_up.name
logistic_receiver_chest_upper.flags = {}
data:extend({logistic_receiver_chest_upper})