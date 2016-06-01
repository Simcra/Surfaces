local rail_transport_lower = table.deepcopy(data.raw["item"]["train-stop"])
rail_transport_lower.name = "rail-transport-lower"
rail_transport_lower.icon = "__Surfaces__/graphics/icons/transport/rail-transport-lower.png"
rail_transport_lower.place_result = "rail-transport-lower"
data:extend({rail_transport_lower})

local rail_transport_upper = table.deepcopy(data.raw["item"]["train-stop"])
rail_transport_upper.name = "rail-transport-upper"
rail_transport_upper.icon = "__Surfaces__/graphics/icons/transport/rail-transport-upper.png"
rail_transport_upper.place_result = "rail-transport-upper"
data:extend({rail_transport_upper})