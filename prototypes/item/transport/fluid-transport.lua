require("script.proto")

local fluid_transport_upper = proto.get({"item", "fluid_transport", "standard"}, "upper", true)
local fluid_transport_lower = proto.get({"item", "fluid_transport", "standard"}, "lower", true)
fluid_transport_lower.place_result = proto.get_field({"entity", "fluid_transport", "standard", "lower"}, "name")
fluid_transport_upper.place_result = proto.get_field({"entity", "fluid_transport", "standard", "upper"}, "name")

data:extend({fluid_transport_upper, fluid_transport_lower})