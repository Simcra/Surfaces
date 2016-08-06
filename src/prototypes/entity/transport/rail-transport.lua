require("script.proto")

local train_stop_lower = proto.get({"entity", "rail_transport", "standard"}, "lower", true, data.raw["train-stop"]["train-stop"])
local train_stop_upper = proto.get({"entity", "rail_transport", "standard"}, "upper", true, data.raw["train-stop"]["train-stop"])

data:extend({train_stop_lower, train_stop_upper})
