require("prototypes.prototype")

-- transport chest
local wooden_transport_down = proto.definition({"recipe", "transport_chest", "wood"}, "down", true)
local wooden_transport_up = proto.definition({"recipe", "transport_chest", "wood"}, "up", true)
local iron_transport_down = proto.definition({"recipe", "transport_chest", "iron"}, "down", true)
local iron_transport_up = proto.definition({"recipe", "transport_chest", "iron"}, "up", true)
local steel_transport_down = proto.definition({"recipe", "transport_chest", "steel"}, "down", true)
local steel_transport_up = proto.definition({"recipe", "transport_chest", "steel"}, "up", true)
local logistic_transport_down = proto.definition({"recipe", "transport_chest", "logistic"}, "down", true)
local logistic_transport_up = proto.definition({"recipe", "transport_chest", "logistic"}, "up", true)

data:extend({wooden_transport_up, wooden_transport_down, iron_transport_up, iron_transport_down, steel_transport_up, steel_transport_down,
	logistic_transport_up, logistic_transport_down})