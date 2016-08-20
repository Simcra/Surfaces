require("prototypes.prototype")

local _ref = proto.reference.base.entity
local energy_transport_lower = proto.definition({"entity", "energy_transport", "standard"}, "lower", true, data.raw["accumulator"][_ref.accumulator])
local energy_transport_upper = proto.definition({"entity", "energy_transport", "standard"}, "upper", true, data.raw["accumulator"][_ref.accumulator])

data:extend({energy_transport_lower, energy_transport_upper})