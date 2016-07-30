require("script.proto")

local train_stop_upper = proto.get({"item", "rail_transport", "standard"}, "upper", true)
local train_stop_lower = proto.get({"item", "rail_transport", "standard"}, "lower", true)
train_stop_lower.place_result = proto.get_field({"entity", "rail_transport", "standard", "lower"}, "name")
train_stop_upper.place_result = proto.get_field({"entity", "rail_transport", "standard", "upper"}, "name")

data:extend({train_stop_upper, train_stop_lower})
