require("script.proto")

-- Servos
local crude_connector = proto.get({"recipe", "connector"}, "crude", true)
local basic_connector = proto.get({"recipe", "connector"}, "basic", true)
local standard_connector = proto.get({"recipe", "connector"}, "standard", true)
local improved_connector = proto.get({"recipe", "connector"}, "improved", true)
local advanced_connector = proto.get({"recipe", "connector"}, "advanced", true)
local crude_servo = proto.get({"recipe", "servo"}, "crude", true)
local standard_servo = proto.get({"recipe", "servo"}, "standard", true)
local improved_servo = proto.get({"recipe", "servo"}, "improved", true)
crude_connector.result = proto.get_field({"item", "connector", "crude"}, "name")
basic_connector.result = proto.get_field({"item", "connector", "basic"}, "name")
standard_connector.result = proto.get_field({"item", "connector", "standard"}, "name")
improved_connector.result = proto.get_field({"item", "connector", "improved"}, "name")
advanced_connector.result = proto.get_field({"item", "connector", "advanced"}, "name")
crude_servo.result = proto.get_field({"item", "servo", "crude"}, "name")
standard_servo.result = proto.get_field({"item", "servo", "standard"}, "name")
improved_servo.result = proto.get_field({"item", "servo", "improved"}, "name")

-- Floor
local wooden_floor = proto.get({"recipe", "floor"}, "wood", true)
wooden_floor.result = proto.get_field({"item", "floor", "wood"}, "name")

data:extend({crude_connector, basic_connector, standard_connector, improved_connector, advanced_connector, crude_servo, standard_servo, improved_servo, wooden_floor})
