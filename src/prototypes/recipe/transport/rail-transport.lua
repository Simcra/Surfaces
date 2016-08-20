require("prototypes.prototype")

local train_stop_upper = proto.definition({"recipe", "rail_transport", "standard"}, "upper", true)
local train_stop_lower = proto.definition({"recipe", "rail_transport", "standard"}, "lower", true)

data:extend({train_stop_upper, train_stop_lower})