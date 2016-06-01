local electric_pole_upper = table.deepcopy(data.raw["item"]["medium-electric-pole"])
electric_pole_upper.name = "electric-pole-upper"
electric_pole_upper.icon = "__Surfaces__/graphics/icons/transport/electric-pole-upper.png"
electric_pole_upper.place_result = "electric-pole-upper"
data:extend({electric_pole_upper})

local electric_pole_lower = table.deepcopy(data.raw["item"]["medium-electric-pole"])
electric_pole_lower.name = "electric-pole-lower"
electric_pole_lower.icon = "__Surfaces__/graphics/icons/transport/electric-pole-lower.png"
electric_pole_lower.place_result = "electric-pole-lower"
data:extend({electric_pole_lower})