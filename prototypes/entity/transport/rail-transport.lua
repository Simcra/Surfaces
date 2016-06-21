local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local train_stop_lower = table.deepcopy(data.raw["train-stop"]["train-stop"])
train_stop_lower.name = "train-stop-lower"
train_stop_lower.icon = iconpath .. train_stop_lower.name .. filetype
train_stop_lower.minable.result = train_stop_lower.name
data:extend({train_stop_lower})

local train_stop_upper = table.deepcopy(data.raw["train-stop"]["train-stop"])
train_stop_upper.name = "train-stop-upper"
train_stop_upper.icon = iconpath .. train_stop_upper.name .. filetype
train_stop_upper.minable.result = train_stop_upper.name
data:extend({train_stop_upper})