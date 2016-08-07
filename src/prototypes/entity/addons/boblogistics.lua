require("script.proto")

local _ref = proto.reference.boblogistics.entity

-- Storage tanks
local fluid_transport_2_lower = proto.get({"entity", "fluid_transport", "standard_2"}, "lower", true, data.raw["storage-tank"][_ref.storage_tank_2])
local fluid_transport_2_upper = proto.get({"entity", "fluid_transport", "standard_2"}, "upper", true, data.raw["storage-tank"][_ref.storage_tank_2])
local fluid_transport_3_lower = proto.get({"entity", "fluid_transport", "standard_3"}, "lower", true, data.raw["storage-tank"][_ref.storage_tank_3])
local fluid_transport_3_upper = proto.get({"entity", "fluid_transport", "standard_3"}, "upper", true, data.raw["storage-tank"][_ref.storage_tank_3])
local fluid_transport_4_lower = proto.get({"entity", "fluid_transport", "standard_4"}, "lower", true, data.raw["storage-tank"][_ref.storage_tank_4])
local fluid_transport_4_upper = proto.get({"entity", "fluid_transport", "standard_4"}, "upper", true, data.raw["storage-tank"][_ref.storage_tank_4])

-- Transport chests
local logistic_transport_2_down = proto.get({"entity", "transport_chest", "logistic_2"}, "down", true, data.raw["logistic-container"][_ref.requester_chest_2])
local logistic_transport_2_up = proto.get({"entity", "transport_chest", "logistic_2"}, "up", true, data.raw["logistic-container"][_ref.requester_chest_2])

-- Receiver chests
local logistic_receiver_2_lower = proto.get({"entity", "receiver_chest", "logistic_2"}, "lower", true, data.raw["logistic-container"][_ref.passive_provider_chest_2])
local logistic_receiver_2_upper = proto.get({"entity", "receiver_chest", "logistic_2"}, "upper", true, data.raw["logistic-container"][_ref.passive_provider_chest_2])

data:extend({fluid_transport_2_lower, fluid_transport_2_upper, fluid_transport_3_lower, fluid_transport_3_upper, fluid_transport_4_lower, fluid_transport_4_upper,
	logistic_transport_2_down, logistic_transport_2_up, logistic_receiver_2_lower, logistic_receiver_2_upper})