require("prototypes.prototype")

-- Energy transport
local energy_transport_2_lower = proto.definition({"item", "energy_transport", "standard_2"}, "lower", true)
local energy_transport_2_upper = proto.definition({"item", "energy_transport", "standard_2"}, "upper", true)
local energy_transport_3_lower = proto.definition({"item", "energy_transport", "standard_3"}, "lower", true)
local energy_transport_3_upper = proto.definition({"item", "energy_transport", "standard_3"}, "upper", true)
local energy_transport_4_lower = proto.definition({"item", "energy_transport", "standard_4"}, "lower", true)
local energy_transport_4_upper = proto.definition({"item", "energy_transport", "standard_4"}, "upper", true)

data:extend({energy_transport_2_lower, energy_transport_2_upper, energy_transport_3_lower, energy_transport_3_upper, energy_transport_4_lower,
	energy_transport_4_upper})