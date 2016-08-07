require("script.proto")

-- Connectors
local crude_connector = proto.get({"recipe", "connector"}, "crude", true)
local basic_connector = proto.get({"recipe", "connector"}, "basic", true)
local standard_connector = proto.get({"recipe", "connector"}, "standard", true)
local improved_connector = proto.get({"recipe", "connector"}, "improved", true)
local advanced_connector = proto.get({"recipe", "connector"}, "advanced", true)

-- Servos
local crude_servo = proto.get({"recipe", "servo"}, "crude", true)
local standard_servo = proto.get({"recipe", "servo"}, "standard", true)
local improved_servo = proto.get({"recipe", "servo"}, "improved", true)

-- Floor
local wooden_floor = proto.get({"recipe", "floor"}, "wood", true)

data:extend({crude_connector, basic_connector, standard_connector, improved_connector, advanced_connector, crude_servo, standard_servo, improved_servo, wooden_floor})