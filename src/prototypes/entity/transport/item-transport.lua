require("prototypes.prototype")

local _ref = proto.reference.base.entity
-- transport chest
local wooden_transport_down = proto.definition({"entity", "transport_chest", "wood"}, "down", true, data.raw["container"][_ref.chest_wood])
local wooden_transport_up = proto.definition({"entity", "transport_chest", "wood"}, "up", true, data.raw["container"][_ref.chest_wood])
local iron_transport_down = proto.definition({"entity", "transport_chest", "iron"}, "down", true, data.raw["container"][_ref.chest_iron])
local iron_transport_up = proto.definition({"entity", "transport_chest", "iron"}, "up", true, data.raw["container"][_ref.chest_iron])
local steel_transport_down = proto.definition({"entity", "transport_chest", "steel"}, "down", true, data.raw["container"][_ref.chest_steel])
local steel_transport_up = proto.definition({"entity", "transport_chest", "steel"}, "up", true, data.raw["container"][_ref.chest_steel])
local logistic_transport_down = proto.definition({"entity", "transport_chest", "logistic"}, "down", true, data.raw["logistic-container"][_ref.chest_requester])
local logistic_transport_up = proto.definition({"entity", "transport_chest", "logistic"}, "up", true, data.raw["logistic-container"][_ref.chest_requester])

-- receiver chest
local wooden_receiver_lower = proto.definition({"entity", "receiver_chest", "wood"}, "lower", true, data.raw["container"][_ref.chest_wood])
local wooden_receiver_upper = proto.definition({"entity", "receiver_chest", "wood"}, "upper", true, data.raw["container"][_ref.chest_wood])
local iron_receiver_lower = proto.definition({"entity", "receiver_chest", "iron"}, "lower", true, data.raw["container"][_ref.chest_iron])
local iron_receiver_upper = proto.definition({"entity", "receiver_chest", "iron"}, "upper", true, data.raw["container"][_ref.chest_iron])
local steel_receiver_lower = proto.definition({"entity", "receiver_chest", "steel"}, "lower", true, data.raw["container"][_ref.chest_steel])
local steel_receiver_upper = proto.definition({"entity", "receiver_chest", "steel"}, "upper", true, data.raw["container"][_ref.chest_steel])
local logistic_receiver_lower = proto.definition({"entity", "receiver_chest", "logistic"}, "lower", true, data.raw["logistic-container"][_ref.chest_passive_provider])
local logistic_receiver_upper = proto.definition({"entity", "receiver_chest", "logistic"}, "upper", true, data.raw["logistic-container"][_ref.chest_passive_provider])

data:extend({wooden_transport_down, wooden_transport_up, iron_transport_down, iron_transport_up, steel_transport_down, steel_transport_up, logistic_transport_down,
	logistic_transport_up, wooden_receiver_lower, wooden_receiver_upper, iron_receiver_lower, iron_receiver_upper, steel_receiver_lower, steel_receiver_upper,
	logistic_receiver_lower, logistic_receiver_upper})