local transport_chest_up = table.deepcopy(data.raw["item"]["logistic-chest-requester"])
transport_chest_up.name = "transport-chest-up"
transport_chest_up.icon = "__Surfaces__/graphics/entity/transport/input-chest-up.png"
transport_chest_up.place_result = "transport-chest-up"
data:extend({transport_chest_up})

local transport_chest_down = table.deepcopy(data.raw["item"]["logistic-chest-requester"])
transport_chest_down.name = "transport-chest-down"
transport_chest_down.icon = "__Surfaces__/graphics/entity/transport/input-chest-down.png"
transport_chest_down.place_result = "transport-chest-down"
data:extend({transport_chest_down})