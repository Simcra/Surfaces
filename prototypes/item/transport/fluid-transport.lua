local fluid_transport_upper = table.deepcopy(data.raw["item"]["storage-tank"])
fluid_transport_upper.name = "fluid-transport-upper"
fluid_transport_upper.icon = "__Surfaces__/graphics/icons/transport/fluid-transport-upper.png"
fluid_transport_upper.place_result = "fluid-transport-upper"
data:extend({fluid_transport_upper})

local fluid_transport_lower = table.deepcopy(data.raw["item"]["storage-tank"])
fluid_transport_lower.name = "fluid-transport-lower"
fluid_transport_lower.icon = "__Surfaces__/graphics/icons/transport/fluid-transport-lower.png"
fluid_transport_lower.place_result = "fluid-transport-lower"
data:extend({fluid_transport_lower})