require("script.proto")

local fluid_transport_upper = proto.get({"recipe", "fluid_transport", "standard"}, "upper", true)
local fluid_transport_lower = proto.get({"recipe", "fluid_transport", "standard"}, "lower", true)
fluid_transport_lower.result = proto.get_field({"item", "fluid_transport", "standard", "lower"}, "name")
fluid_transport_upper.result = proto.get_field({"item", "fluid_transport", "standard", "upper"}, "name")

data:extend({fluid_transport_upper, fluid_transport_lower})
