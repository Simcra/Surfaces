require("prototypes.prototype")

local _ref = proto.reference.base.entity
local train_stop_lower = proto.definition({"entity", "rail_transport", "standard"}, "lower", true, data.raw["train-stop"][_ref.train_stop])
local train_stop_upper = proto.definition({"entity", "rail_transport", "standard"}, "upper", true, data.raw["train-stop"][_ref.train_stop])

data:extend({train_stop_lower, train_stop_upper})