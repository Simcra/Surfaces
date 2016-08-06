require("script.proto")

local fluid_transport_lower = proto.get({"entity", "fluid_transport", "standard"}, "lower", true, data.raw["storage-tank"]["storage-tank"])
local fluid_transport_upper = proto.get({"entity", "fluid_transport", "standard"}, "upper", true, data.raw["storage-tank"]["storage-tank"])

data:extend({fluid_transport_lower, fluid_transport_upper})
