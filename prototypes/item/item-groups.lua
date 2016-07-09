require("script.proto")

local surfaces = proto.get({"item_group"}, "surfaces", true)
local surfaces_component = proto.get({"item_subgroup", "surfaces"}, "component", true)
local surfaces_tile = proto.get({"item_subgroup", "surfaces"}, "tile", true)
local surfaces_transport_player = proto.get({"item_subgroup", "surfaces", "transport"}, "player", true)
local surfaces_transport_power = proto.get({"item_subgroup", "surfaces", "transport"}, "power", true)
local surfaces_transport_chest = proto.get({"item_subgroup", "surfaces", "transport"}, "chest", true)
local surfaces_transport_other = proto.get({"item_subgroup", "surfaces", "transport"}, "other", true)

data:extend({surfaces, surfaces_component, surfaces_tile, surfaces_transport_player, surfaces_transport_power, surfaces_transport_chest, surfaces_transport_other})