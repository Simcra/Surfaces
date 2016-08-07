require("script.proto")

-- Storage tanks
local fluid_transport_2_lower = proto.get({"recipe", "fluid_transport", "standard_2"}, "lower", true)
local fluid_transport_2_upper = proto.get({"recipe", "fluid_transport", "standard_2"}, "upper", true)
local fluid_transport_3_lower = proto.get({"recipe", "fluid_transport", "standard_3"}, "lower", true)
local fluid_transport_3_upper = proto.get({"recipe", "fluid_transport", "standard_3"}, "upper", true)
local fluid_transport_4_lower = proto.get({"recipe", "fluid_transport", "standard_4"}, "lower", true)
local fluid_transport_4_upper = proto.get({"recipe", "fluid_transport", "standard_4"}, "upper", true)

-- Transport chests
local logistic_transport_2_down = proto.get({"recipe", "transport_chest", "logistic_2"}, "down", true)
local logistic_transport_2_up = proto.get({"recipe", "transport_chest", "logistic_2"}, "up", true)

data:extend({fluid_transport_2_lower, fluid_transport_2_upper, fluid_transport_3_lower, fluid_transport_3_upper, fluid_transport_4_lower, fluid_transport_4_upper,
	logistic_transport_2_down, logistic_transport_2_up})