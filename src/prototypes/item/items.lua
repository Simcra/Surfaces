require("script.proto")

-- Servos
local crude_connector = proto.get({"item", "connector"}, "crude", true)
local basic_connector = proto.get({"item", "connector"}, "basic", true)
local standard_connector = proto.get({"item", "connector"}, "standard", true)
local improved_connector = proto.get({"item", "connector"}, "improved", true)
local advanced_connector = proto.get({"item", "connector"}, "advanced", true)
local crude_servo = proto.get({"item", "servo"}, "crude", true)
local standard_servo = proto.get({"item", "servo"}, "standard", true)
local improved_servo = proto.get({"item", "servo"}, "improved", true)

-- Tiles
local wooden_floor = proto.get({"item", "floor"}, "wood", true)
wooden_floor.place_as_tile.result = proto.get_field({"tile", "floor", "wood"}, "name")

data:extend({crude_connector, basic_connector, standard_connector, improved_connector, advanced_connector, crude_servo, standard_servo, improved_servo, wooden_floor})