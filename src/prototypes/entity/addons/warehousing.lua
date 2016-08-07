require("script.proto")

local _ref = proto.reference.warehousing.entity

-- Transport warehouses & storehouses
local transport_storehouse_down = proto.get({"entity", "transport_chest", "storehouse"}, "down", true, data.raw["container"][_ref.storehouse])
local transport_storehouse_up = proto.get({"entity", "transport_chest", "storehouse"}, "up", true, data.raw["container"][_ref.storehouse])
local logistic_transport_storehouse_down = proto.get({"entity", "transport_chest", "logistic_storehouse"}, "down", true, data.raw["logistic-container"][_ref.requester_storehouse])
local logistic_transport_storehouse_up = proto.get({"entity", "transport_chest", "logistic_storehouse"}, "up", true, data.raw["logistic-container"][_ref.requester_storehouse])
local transport_warehouse_down = proto.get({"entity", "transport_chest", "warehouse"}, "down", true, data.raw["container"][_ref.warehouse])
local transport_warehouse_up = proto.get({"entity", "transport_chest", "warehouse"}, "up", true, data.raw["container"][_ref.warehouse])
local logistic_transport_warehouse_down = proto.get({"entity", "transport_chest", "logistic_warehouse"}, "down", true, data.raw["logistic-container"][_ref.requester_warehouse])
local logistic_transport_warehouse_up = proto.get({"entity", "transport_chest", "logistic_warehouse"}, "up", true, data.raw["logistic-container"][_ref.requester_warehouse])

-- Receiver warehouses & storehouses
local receiver_storehouse_upper = proto.get({"entity", "receiver_chest", "storehouse"}, "upper", true, data.raw["container"][_ref.storehouse])
local receiver_storehouse_lower = proto.get({"entity", "receiver_chest", "storehouse"}, "lower", true, data.raw["container"][_ref.storehouse])
local logistic_receiver_storehouse_upper = proto.get({"entity", "receiver_chest", "logistic_storehouse"}, "upper", true, data.raw["logistic-container"][_ref.passive_provider_storehouse])
local logistic_receiver_storehouse_lower = proto.get({"entity", "receiver_chest", "logistic_storehouse"}, "lower", true, data.raw["logistic-container"][_ref.passive_provider_storehouse])
local receiver_warehouse_upper = proto.get({"entity", "receiver_chest", "warehouse"}, "upper", true, data.raw["container"][_ref.warehouse])
local receiver_warehouse_lower = proto.get({"entity", "receiver_chest", "warehouse"}, "lower", true, data.raw["container"][_ref.warehouse])
local logistic_receiver_warehouse_upper = proto.get({"entity", "receiver_chest", "logistic_warehouse"}, "upper", true, data.raw["logistic-container"][_ref.passive_provider_warehouse])
local logistic_receiver_warehouse_lower = proto.get({"entity", "receiver_chest", "logistic_warehouse"}, "lower", true, data.raw["logistic-container"][_ref.passive_provider_warehouse])

data:extend({transport_storehouse_down, transport_storehouse_up, logistic_transport_storehouse_down, logistic_transport_storehouse_up, transport_warehouse_down,
	transport_warehouse_up, logistic_transport_warehouse_down, logistic_transport_warehouse_up, receiver_storehouse_upper, receiver_storehouse_lower,
	logistic_receiver_storehouse_upper, logistic_receiver_storehouse_lower, receiver_warehouse_upper, receiver_warehouse_lower, logistic_receiver_warehouse_upper,
	logistic_receiver_warehouse_lower})