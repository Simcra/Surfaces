require("script.proto")

-- Energy transport
local energy_transport_2_lower = proto.get({"item", "energy_transport", "standard_2"}, "lower", true)
local energy_transport_2_upper = proto.get({"item", "energy_transport", "standard_2"}, "upper", true)
local energy_transport_3_lower = proto.get({"item", "energy_transport", "standard_3"}, "lower", true)
local energy_transport_3_upper = proto.get({"item", "energy_transport", "standard_3"}, "upper", true)
local energy_transport_4_lower = proto.get({"item", "energy_transport", "standard_4"}, "lower", true)
local energy_transport_4_upper = proto.get({"item", "energy_transport", "standard_4"}, "upper", true)

data:extend({energy_transport_2_lower, energy_transport_2_upper, energy_transport_3_lower, energy_transport_3_upper, energy_transport_4_lower,
	energy_transport_4_upper})