require("prototypes.prototype")

local _ref = proto.reference.base.entity
local fluid_transport_lower = proto.definition({"entity", "fluid_transport", "standard"}, "lower", true, data.raw["storage-tank"][_ref.storage_tank])
local fluid_transport_upper = proto.definition({"entity", "fluid_transport", "standard"}, "upper", true, data.raw["storage-tank"][_ref.storage_tank])

data:extend({fluid_transport_lower, fluid_transport_upper})