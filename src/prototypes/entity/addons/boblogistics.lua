require("script.proto")

local _ref = proto.reference()
local fluid_transport_2_lower = proto.get({"entity", "fluid_transport", "standard_2"}, "lower", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_2])
local fluid_transport_2_upper = proto.get({"entity", "fluid_transport", "standard_2"}, "upper", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_2])
local fluid_transport_3_lower = proto.get({"entity", "fluid_transport", "standard_3"}, "lower", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_3])
local fluid_transport_3_upper = proto.get({"entity", "fluid_transport", "standard_3"}, "upper", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_3])
local fluid_transport_4_lower = proto.get({"entity", "fluid_transport", "standard_4"}, "lower", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_4])
local fluid_transport_4_upper = proto.get({"entity", "fluid_transport", "standard_4"}, "upper", true, data.raw["storage-tank"][_ref.boblogistics.storage_tank_4])

data:extend({fluid_transport_2_lower, fluid_transport_2_upper, fluid_transport_3_lower, fluid_transport_3_upper, fluid_transport_4_lower, fluid_transport_4_upper})
