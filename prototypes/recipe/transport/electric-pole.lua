local trans_elec_pole = {type = "recipe", group = "surfaces", subgroup = "surfaces-transport", enabled = true, ingredients = {{"medium-electric-pole", 2}}}

local electric_pole_lower = table.deepcopy(trans_elec_pole)
electric_pole_lower.name = "electric-pole-lower"
electric_pole_lower.result = "electric-pole-lower"
data:extend({electric_pole_lower})

local electric_pole_upper = table.deepcopy(trans_elec_pole)
electric_pole_upper.name = "electric-pole-upper"
electric_pole_upper.result = "electric-pole-upper"
data:extend({electric_pole_upper})