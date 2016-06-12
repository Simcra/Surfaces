local small_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
small_electric_pole_upper.name = "small-electric-pole-upper"
small_electric_pole_upper.icon = "__Surfaces__/graphics/icons/transport/small-electric-pole-upper.png"
small_electric_pole_upper.minable.result = "small-electric-pole-upper"
data:extend({small_electric_pole_upper})

local small_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
small_electric_pole_lower.name = "small-electric-pole-lower"
small_electric_pole_lower.icon = "__Surfaces__/graphics/icons/transport/small-electric-pole-lower.png"
small_electric_pole_lower.minable.result = "small-electric-pole-lower"
data:extend({small_electric_pole_lower})

local medium_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_upper.name = "medium-electric-pole-upper"
medium_electric_pole_upper.icon = "__Surfaces__/graphics/icons/transport/medium-electric-pole-upper.png"
medium_electric_pole_upper.minable.result = "medium-electric-pole-upper"
data:extend({medium_electric_pole_upper})

local medium_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["medium-electric-pole"])
medium_electric_pole_lower.name = "medium-electric-pole-lower"
medium_electric_pole_lower.icon = "__Surfaces__/graphics/icons/transport/medium-electric-pole-lower.png"
medium_electric_pole_lower.minable.result = "medium-electric-pole-lower"
data:extend({medium_electric_pole_lower})

local big_electric_pole_upper = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_upper.name = "big-electric-pole-upper"
big_electric_pole_upper.icon = "__Surfaces__/graphics/icons/transport/big-electric-pole-upper.png"
big_electric_pole_upper.minable.result = "big-electric-pole-upper"
data:extend({big_electric_pole_upper})

local big_electric_pole_lower = table.deepcopy(data.raw["electric-pole"]["big-electric-pole"])
big_electric_pole_lower.name = "big-electric-pole-lower"
big_electric_pole_lower.icon = "__Surfaces__/graphics/icons/transport/big-electric-pole-lower.png"
big_electric_pole_lower.minable.result = "big-electric-pole-lower"
data:extend({big_electric_pole_lower})

local substation_upper = table.deepcopy(data.raw["electric-pole"]["substation"])
substation_upper.name = "substation-upper"
substation_upper.icon = "__Surfaces__/graphics/icons/transport/substation-upper.png"
substation_upper.minable.result = "substation-upper"
data:extend({substation_upper})

local substation_lower = table.deepcopy(data.raw["electric-pole"]["substation"])
substation_lower.name = "substation-lower"
substation_lower.icon = "__Surfaces__/graphics/icons/transport/substation-lower.png"
substation_lower.minable.result = "substation-lower"
data:extend({substation_lower})