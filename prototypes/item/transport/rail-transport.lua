local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local train_stop_lower = table.deepcopy(data.raw["item"]["train-stop"])
train_stop_lower.name = "train-stop-lower"
train_stop_lower.icon = iconpath .. train_stop_lower.name .. filetype
train_stop_lower.place_result = train_stop_lower.name
train_stop_lower.flags = {"goes-to-quickbar"}
data:extend({train_stop_lower})

local train_stop_upper = table.deepcopy(data.raw["item"]["train-stop"])
train_stop_upper.name = "train-stop-upper"
train_stop_upper.icon = iconpath .. train_stop_upper.name .. filetype
train_stop_upper.place_result = train_stop_upper.name
train_stop_lower.flags = {"goes-to-quickbar"}
data:extend({train_stop_upper})