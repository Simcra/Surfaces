local train_stop_lower = table.deepcopy(data.raw["train-stop"]["train-stop"])
train_stop_lower.name="train-stop-lower"
train_stop_lower.minable.result="train-stop-lower"
train_stop_lower.icon="__Surfaces__/graphics/icons/transport/train-stop-lower.png"
data:extend({train_stop_lower})

local train_stop_upper = table.deepcopy(data.raw["train-stop"]["train-stop"])
train_stop_upper.name="train-stop-upper"
train_stop_upper.minable.result="train-stop-upper"
train_stop_upper.icon="__Surfaces__/graphics/icons/transport/train-stop-upper.png"
data:extend({train_stop_upper})