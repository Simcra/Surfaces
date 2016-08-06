require("script.proto")

-- Transport warehouses & storehouses
local transport_storehouse_down = proto.get({"entity", "transport_chest", "storehouse"}, "down", true, data.raw["container"]["storehouse-basic"])
local transport_storehouse_up = proto.get({"entity", "transport_chest", "storehouse"}, "up", true, data.raw["container"]["storehouse-basic"])
local logistic_transport_storehouse_down = proto.get({"entity", "transport_chest", "logistic_storehouse"}, "down", true, data.raw["logistic-container"]["storehouse-requester"])
local logistic_transport_storehouse_up = proto.get({"entity", "transport_chest", "logistic_storehouse"}, "up", true, data.raw["logistic-container"]["storehouse-requester"])
local transport_warehouse_down = proto.get({"entity", "transport_chest", "warehouse"}, "down", true, data.raw["container"]["warehouse-basic"])
local transport_warehouse_up = proto.get({"entity", "transport_chest", "warehouse"}, "up", true, data.raw["container"]["warehouse-basic"])
local logistic_transport_warehouse_down = proto.get({"entity", "transport_chest", "logistic_warehouse"}, "down", true, data.raw["logistic-container"]["warehouse-requester"])
local logistic_transport_warehouse_up = proto.get({"entity", "transport_chest", "logistic_warehouse"}, "up", true, data.raw["logistic-container"]["warehouse-requester"])

local receiver_storehouse_upper = proto.get({"entity", "receiver_chest", "storehouse"}, "upper", true, data.raw["container"]["storehouse-basic"])
local receiver_storehouse_lower = proto.get({"entity", "receiver_chest", "storehouse"}, "lower", true, data.raw["container"]["storehouse-basic"])
local logistic_receiver_storehouse_upper = proto.get({"entity", "receiver_chest", "logistic_storehouse"}, "upper", true, data.raw["logistic-container"]["storehouse-passive-provider"])
local logistic_receiver_storehouse_lower = proto.get({"entity", "receiver_chest", "logistic_storehouse"}, "lower", true, data.raw["logistic-container"]["storehouse-passive-provider"])
local receiver_warehouse_upper = proto.get({"entity", "receiver_chest", "warehouse"}, "upper", true, data.raw["container"]["warehouse-basic"])
local receiver_warehouse_lower = proto.get({"entity", "receiver_chest", "warehouse"}, "lower", true, data.raw["container"]["warehouse-basic"])
local logistic_receiver_warehouse_upper = proto.get({"entity", "receiver_chest", "logistic_warehouse"}, "upper", true, data.raw["logistic-container"]["warehouse-passive-provider"])
local logistic_receiver_warehouse_lower = proto.get({"entity", "receiver_chest", "logistic_warehouse"}, "lower", true, data.raw["logistic-container"]["warehouse-passive-provider"])

data:extend({transport_storehouse_down, transport_storehouse_up, logistic_transport_storehouse_down, logistic_transport_storehouse_up, transport_warehouse_down,
	transport_warehouse_up, logistic_transport_warehouse_down, logistic_transport_warehouse_up, receiver_storehouse_upper, receiver_storehouse_lower,
	logistic_receiver_storehouse_upper, logistic_receiver_storehouse_lower, receiver_warehouse_upper, receiver_warehouse_lower, logistic_receiver_warehouse_upper,
	logistic_receiver_warehouse_lower})