require("script.proto")

local energy_transport_lower = proto.get({"recipe", "energy_transport", "standard"}, "lower", true)
local energy_transport_upper = proto.get({"recipe", "energy_transport", "standard"}, "upper", true)

data:extend({energy_transport_lower, energy_transport_upper})