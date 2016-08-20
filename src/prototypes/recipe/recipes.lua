require("prototypes.prototype")

-- Connectors
local crude_connector = proto.definition({"recipe", "connector"}, "crude", true)
local basic_connector = proto.definition({"recipe", "connector"}, "basic", true)
local standard_connector = proto.definition({"recipe", "connector"}, "standard", true)
local improved_connector = proto.definition({"recipe", "connector"}, "improved", true)
local advanced_connector = proto.definition({"recipe", "connector"}, "advanced", true)

-- Servos
local crude_servo = proto.definition({"recipe", "servo"}, "crude", true)
local standard_servo = proto.definition({"recipe", "servo"}, "standard", true)
local improved_servo = proto.definition({"recipe", "servo"}, "improved", true)

-- Floor
local wooden_floor = proto.definition({"recipe", "floor"}, "wood", true)

data:extend({crude_connector, basic_connector, standard_connector, improved_connector, advanced_connector, crude_servo, standard_servo, improved_servo, wooden_floor})