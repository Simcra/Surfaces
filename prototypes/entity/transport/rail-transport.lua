local rail_transport_lower = table.deepcopy(data.raw["train-stop"]["train-stop"])
rail_transport_lower.name="rail-transport-lower"
rail_transport_lower.minable.result="rail-transport-lower"
rail_transport_lower.icon="__Surfaces__/graphics/icons/transport/rail-transport-lower.png"
data:extend({rail_transport_lower})

local rail_transport_upper = table.deepcopy(data.raw["train-stop"]["train-stop"])
rail_transport_upper.name="rail-transport-upper"
rail_transport_upper.minable.result="rail-transport-upper"
rail_transport_upper.icon="__Surfaces__/graphics/icons/transport/rail-transport-upper.png"
data:extend({rail_transport_upper})