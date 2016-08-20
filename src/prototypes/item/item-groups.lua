require("prototypes.prototype")

-- Item groups
local surfaces = proto.definition({"item_group"}, "surfaces", true)

-- Item subgroups
local surfaces_component = proto.definition({"item_subgroup", "surfaces"}, "component", true)
local surfaces_tile = proto.definition({"item_subgroup", "surfaces"}, "tile", true)
local surfaces_transport_chest = proto.definition({"item_subgroup", "surfaces", "transport"}, "chest", true)
local surfaces_transport_energy = proto.definition({"item_subgroup", "surfaces", "transport"}, "energy", true)
local surfaces_transport_fluid = proto.definition({"item_subgroup", "surfaces", "transport"}, "fluid", true)
local surfaces_transport_other = proto.definition({"item_subgroup", "surfaces", "transport"}, "other", true)
local surfaces_transport_rail = proto.definition({"item_subgroup", "surfaces", "transport"}, "rail", true)
local surfaces_transport_player = proto.definition({"item_subgroup", "surfaces", "transport"}, "player", true)

data:extend({surfaces, surfaces_component, surfaces_tile, surfaces_transport_chest, surfaces_transport_energy, surfaces_transport_fluid, surfaces_transport_other,
	surfaces_transport_rail, surfaces_transport_player})