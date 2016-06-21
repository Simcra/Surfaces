local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

-- Transport chests
local wooden_transport_chest_up = table.deepcopy(data.raw["item"]["wooden-chest"])
wooden_transport_chest_up.name = "wooden-transport-chest-up"
wooden_transport_chest_up.icon = iconpath .. wooden_transport_chest_up.name .. filetype
wooden_transport_chest_up.place_result = wooden_transport_chest_up.name
data:extend({wooden_transport_chest_up})

local wooden_transport_chest_down = table.deepcopy(data.raw["item"]["wooden-chest"])
wooden_transport_chest_down.name = "wooden-transport-chest-down"
wooden_transport_chest_down.icon = iconpath .. wooden_transport_chest_down.name .. filetype
wooden_transport_chest_down.place_result = wooden_transport_chest_down.name
data:extend({wooden_transport_chest_down})

local iron_transport_chest_up = table.deepcopy(data.raw["item"]["iron-chest"])
iron_transport_chest_up.name = "iron-transport-chest-up"
iron_transport_chest_up.icon = iconpath .. iron_transport_chest_up.name .. filetype
iron_transport_chest_up.place_result = iron_transport_chest_up.name
data:extend({iron_transport_chest_up})

local iron_transport_chest_down = table.deepcopy(data.raw["item"]["iron-chest"])
iron_transport_chest_down.name = "iron-transport-chest-down"
iron_transport_chest_down.icon = iconpath .. iron_transport_chest_down.name .. filetype
iron_transport_chest_down.place_result = iron_transport_chest_down.name
data:extend({iron_transport_chest_down})

local steel_transport_chest_up = table.deepcopy(data.raw["item"]["steel-chest"])
steel_transport_chest_up.name = "steel-transport-chest-up"
steel_transport_chest_up.icon = iconpath .. steel_transport_chest_up.name .. filetype
steel_transport_chest_up.place_result = steel_transport_chest_up.name
data:extend({steel_transport_chest_up})

local steel_transport_chest_down = table.deepcopy(data.raw["item"]["steel-chest"])
steel_transport_chest_down.name = "steel-transport-chest-down"
steel_transport_chest_down.icon = iconpath .. steel_transport_chest_down.name .. filetype
steel_transport_chest_down.place_result = steel_transport_chest_down.name
data:extend({steel_transport_chest_down})

local smart_transport_chest_up = table.deepcopy(data.raw["item"]["smart-chest"])
smart_transport_chest_up.name = "smart-transport-chest-up"
smart_transport_chest_up.icon = iconpath .. smart_transport_chest_up.name .. filetype
smart_transport_chest_up.place_result = smart_transport_chest_up.name
data:extend({smart_transport_chest_up})

local smart_transport_chest_down = table.deepcopy(data.raw["item"]["smart-chest"])
smart_transport_chest_down.name = "smart-transport-chest-down"
smart_transport_chest_down.icon = iconpath .. smart_transport_chest_down.name .. filetype
smart_transport_chest_down.place_result = smart_transport_chest_down.name
data:extend({smart_transport_chest_down})

local logistic_transport_chest_up = table.deepcopy(data.raw["item"]["logistic-chest-requester"])
logistic_transport_chest_up.name = "logistic-transport-chest-up"
logistic_transport_chest_up.icon = iconpath .. logistic_transport_chest_up.name .. filetype
logistic_transport_chest_up.place_result = logistic_transport_chest_up.name
data:extend({logistic_transport_chest_up})

local logistic_transport_chest_down = table.deepcopy(data.raw["item"]["logistic-chest-requester"])
logistic_transport_chest_down.name = "logistic-transport-chest-down"
logistic_transport_chest_down.icon = iconpath .. logistic_transport_chest_down.name .. filetype
logistic_transport_chest_down.place_result = logistic_transport_chest_down.name
data:extend({logistic_transport_chest_down})