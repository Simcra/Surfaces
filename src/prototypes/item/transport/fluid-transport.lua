require("prototypes.prototype")

local fluid_transport_upper = proto.definition({"item", "fluid_transport", "standard"}, "upper", true)
local fluid_transport_lower = proto.definition({"item", "fluid_transport", "standard"}, "lower", true)

data:extend({fluid_transport_upper, fluid_transport_lower})