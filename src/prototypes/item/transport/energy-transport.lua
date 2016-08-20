require("prototypes.prototype")

local energy_transport_lower = proto.definition({"item", "energy_transport", "standard"}, "lower", true)
local energy_transport_upper = proto.definition({"item", "energy_transport", "standard"}, "upper", true)

data:extend({energy_transport_lower, energy_transport_upper})