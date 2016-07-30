require("script.proto")

-- transport chest
local wooden_transport_down = proto.get({"entity", "transport_chest", "wood"}, "down", true, data.raw["container"]["wooden-chest"])
local wooden_transport_up = proto.get({"entity", "transport_chest", "wood"}, "up", true, data.raw["container"]["wooden-chest"])
local iron_transport_down = proto.get({"entity", "transport_chest", "iron"}, "down", true, data.raw["container"]["iron-chest"])
local iron_transport_up = proto.get({"entity", "transport_chest", "iron"}, "up", true, data.raw["container"]["iron-chest"])
local steel_transport_down = proto.get({"entity", "transport_chest", "steel"}, "down", true, data.raw["container"]["steel-chest"])
local steel_transport_up = proto.get({"entity", "transport_chest", "steel"}, "up", true, data.raw["container"]["steel-chest"])
local logistic_transport_down = proto.get({"entity", "transport_chest", "logistic"}, "down", true, data.raw["logistic-container"]["logistic-chest-requester"])
local logistic_transport_up = proto.get({"entity", "transport_chest", "logistic"}, "up", true, data.raw["logistic-container"]["logistic-chest-requester"])
wooden_transport_down.minable.result = proto.get_field({"item", "transport_chest", "wood", "down"}, "name")
wooden_transport_up.minable.result = proto.get_field({"item", "transport_chest", "wood", "up"}, "name")
iron_transport_down.minable.result = proto.get_field({"item", "transport_chest", "iron", "down"}, "name")
iron_transport_up.minable.result = proto.get_field({"item", "transport_chest", "iron", "up"}, "name")
steel_transport_down.minable.result = proto.get_field({"item", "transport_chest", "steel", "down"}, "name")
steel_transport_up.minable.result = proto.get_field({"item", "transport_chest", "steel", "up"}, "name")
logistic_transport_down.minable.result = proto.get_field({"item", "transport_chest", "logistic", "down"}, "name")
logistic_transport_up.minable.result = proto.get_field({"item", "transport_chest", "logistic", "up"}, "name")

-- receiver chest
local wooden_receiver_lower = proto.get({"entity", "receiver_chest", "wood"}, "lower", true, data.raw["container"]["wooden-chest"])
local wooden_receiver_upper = proto.get({"entity", "receiver_chest", "wood"}, "upper", true, data.raw["container"]["wooden-chest"])
local iron_receiver_lower = proto.get({"entity", "receiver_chest", "iron"}, "lower", true, data.raw["container"]["iron-chest"])
local iron_receiver_upper = proto.get({"entity", "receiver_chest", "iron"}, "upper", true, data.raw["container"]["iron-chest"])
local steel_receiver_lower = proto.get({"entity", "receiver_chest", "steel"}, "lower", true, data.raw["container"]["steel-chest"])
local steel_receiver_upper = proto.get({"entity", "receiver_chest", "steel"}, "upper", true, data.raw["container"]["steel-chest"])
local logistic_receiver_lower = proto.get({"entity", "receiver_chest", "logistic"}, "lower", true, data.raw["logistic-container"]["logistic-chest-passive-provider"])
local logistic_receiver_upper = proto.get({"entity", "receiver_chest", "logistic"}, "upper", true, data.raw["logistic-container"]["logistic-chest-passive-provider"])
wooden_receiver_lower.minable.result = proto.get_field({"item", "transport_chest", "wood", "down"}, "name")
wooden_receiver_upper.minable.result = proto.get_field({"item", "transport_chest", "wood", "up"}, "name")
iron_receiver_lower.minable.result = proto.get_field({"item", "transport_chest", "iron", "down"}, "name")
iron_receiver_upper.minable.result = proto.get_field({"item", "transport_chest", "iron", "up"}, "name")
steel_receiver_lower.minable.result = proto.get_field({"item", "transport_chest", "steel", "down"}, "name")
steel_receiver_upper.minable.result = proto.get_field({"item", "transport_chest", "steel", "up"}, "name")
logistic_receiver_lower.minable.result = proto.get_field({"item", "transport_chest", "logistic", "down"}, "name")
logistic_receiver_upper.minable.result = proto.get_field({"item", "transport_chest", "logistic", "up"}, "name")

data:extend({wooden_transport_down, wooden_transport_up, iron_transport_down, iron_transport_up, steel_transport_down, steel_transport_up, logistic_transport_down, logistic_transport_up, wooden_receiver_lower, wooden_receiver_upper, iron_receiver_lower, iron_receiver_upper, steel_receiver_lower, steel_receiver_upper, logistic_receiver_lower, logistic_receiver_upper})