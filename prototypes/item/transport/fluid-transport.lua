local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local fluid_transport_upper = table.deepcopy(data.raw["item"]["storage-tank"])
fluid_transport_upper.name = "fluid-transport-upper"
fluid_transport_upper.icon = iconpath .. fluid_transport_upper.name .. filetype
fluid_transport_upper.place_result = fluid_transport_upper.name
data:extend({fluid_transport_upper})

local fluid_transport_lower = table.deepcopy(data.raw["item"]["storage-tank"])
fluid_transport_lower.name = "fluid-transport-lower"
fluid_transport_lower.icon = iconpath .. fluid_transport_lower.name .. filetype
fluid_transport_lower.place_result = fluid_transport_lower.name
data:extend({fluid_transport_lower})