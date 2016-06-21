local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local small_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
small_electric_pole_upper.name = "small-electric-pole-upper"
small_electric_pole_upper.icon = iconpath .. small_electric_pole_upper.name .. filetype
small_electric_pole_upper.minable.result = small_electric_pole_upper.name
data:extend({small_electric_pole_upper})

local small_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
small_electric_pole_lower.name = "small-electric-pole-lower"
small_electric_pole_lower.icon = iconpath .. small_electric_pole_lower.name .. filetype
small_electric_pole_lower.minable.result = small_electric_pole_lower.name
data:extend({small_electric_pole_lower})

local medium_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_upper.name = "medium-electric-pole-upper"
medium_electric_pole_upper.icon = iconpath .. medium_electric_pole_upper.name .. filetype
medium_electric_pole_upper.minable.result = medium_electric_pole_upper.name
data:extend({medium_electric_pole_upper})

local medium_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_lower.name = "medium-electric-pole-lower"
medium_electric_pole_lower.icon = iconpath .. medium_electric_pole_lower.name .. filetype
medium_electric_pole_lower.minable.result = medium_electric_pole_lower.name
data:extend({medium_electric_pole_lower})

local big_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_upper.name = "big-electric-pole-upper"
big_electric_pole_upper.icon = iconpath .. big_electric_pole_upper.name .. filetype
big_electric_pole_upper.minable.result = big_electric_pole_upper.name
data:extend({big_electric_pole_upper})

local big_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_lower.name = "big-electric-pole-lower"
big_electric_pole_lower.icon = iconpath .. big_electric_pole_lower.name .. filetype
big_electric_pole_lower.minable.result = big_electric_pole_lower.name
data:extend({big_electric_pole_lower})

local substation_upper = table.deepcopy(data.raw["electric-pole"]["substation"])
substation_upper.name = "substation-upper"
substation_upper.icon = iconpath .. substation_upper.name .. filetype
substation_upper.minable.result = substation_upper.name
data:extend({substation_upper})

local substation_lower = table.deepcopy(data.raw["electric-pole"]["substation"])
substation_lower.name = "substation-lower"
substation_lower.icon = iconpath .. substation_lower.name .. filetype
substation_lower.minable.result = substation_lower.name
data:extend({substation_lower})