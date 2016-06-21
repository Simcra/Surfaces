local elec_pole = {
	type = "recipe",
	group = "surfaces",
	subgroup = "surfaces-transport-power",
	enabled = true
}

-- big electric pole recipes
local big_elec_pole = table.deepcopy(elec_pole)
big_elec_pole.ingredients = {{"big-electric-pole", 2}, {"red-wire", 1}, {"green-wire", 1}, {"copper-cable", 1}}

local big_electric_pole_upper = table.deepcopy(big_elec_pole)
big_electric_pole_upper.name = "big-electric-pole-upper"
big_electric_pole_upper.result = big_electric_pole_upper.name
data:extend({big_electric_pole_upper})

local big_electric_pole_lower = table.deepcopy(big_elec_pole)
big_electric_pole_lower.name = "big-electric-pole-lower"
big_electric_pole_lower.result = big_electric_pole_lower.name
data:extend({big_electric_pole_lower})

-- small electric pole recipes
local small_elec_pole = table.deepcopy(elec_pole)
small_elec_pole.ingredients = {{"small-electric-pole", 2}, {"red-wire", 1}, {"green-wire", 1}, {"copper-cable", 1}}

local small_electric_pole_upper = table.deepcopy(small_elec_pole)
small_electric_pole_upper.name = "small-electric-pole-upper"
small_electric_pole_upper.result = small_electric_pole_upper.name
data:extend({small_electric_pole_upper})

local small_electric_pole_lower = table.deepcopy(small_elec_pole)
small_electric_pole_lower.name = "small-electric-pole-lower"
small_electric_pole_lower.result = small_electric_pole_lower.name
data:extend({small_electric_pole_lower})

-- medium electric pole recipes
local med_elec_pole = table.deepcopy(elec_pole)
med_elec_pole.ingredients = {{"medium-electric-pole", 2}, {"red-wire", 1}, {"green-wire", 1}, {"copper-cable", 1}}

local medium_electric_pole_upper = table.deepcopy(med_elec_pole)
medium_electric_pole_upper.name = "medium-electric-pole-upper"
medium_electric_pole_upper.result = medium_electric_pole_upper.name
data:extend({medium_electric_pole_upper})

local medium_electric_pole_lower = table.deepcopy(med_elec_pole)
medium_electric_pole_lower.name = "medium-electric-pole-lower"
medium_electric_pole_lower.result = medium_electric_pole_lower.name
data:extend({medium_electric_pole_lower})

-- substation recipes
local substation_elec = table.deepcopy(elec_pole)
substation_elec.ingredients = {{"substation", 2}, {"red-wire", 1}, {"green-wire", 1}, {"copper-cable", 1}}

local substation_lower = table.deepcopy(substation_elec)
substation_lower.name = "substation-lower"
substation_lower.result = substation_lower.name
data:extend({substation_lower})

local substation_upper = table.deepcopy(substation_elec)
substation_upper.name = "substation-upper"
substation_upper.result = substation_upper.name
data:extend({substation_upper})