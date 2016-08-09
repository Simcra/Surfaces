require("script.proto")

local energy_transport_lower = proto.get({"entity", "energy_transport", "standard"}, "lower", true, data.raw["accumulator"]["accumulator"])
local energy_transport_upper = proto.get({"entity", "energy_transport", "standard"}, "upper", true, data.raw["accumulator"]["accumulator"])

data:extend({energy_transport_lower, energy_transport_upper})