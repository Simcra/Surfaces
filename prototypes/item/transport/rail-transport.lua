local train_stop_lower = table.deepcopy(data.raw["item"]["train-stop"])
train_stop_lower.name = "train-stop-lower"
train_stop_lower.icon = "__Surfaces__/graphics/icons/transport/train-stop-lower.png"
train_stop_lower.place_result = "train-stop-lower"
data:extend({train_stop_lower})

local train_stop_upper = table.deepcopy(data.raw["item"]["train-stop"])
train_stop_upper.name = "train-stop-upper"
train_stop_upper.icon = "__Surfaces__/graphics/icons/transport/train-stop-upper.png"
train_stop_upper.place_result = "train-stop-upper"
data:extend({train_stop_upper})