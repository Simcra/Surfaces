require("prototypes.prototype")

-- Components
local crude_connector = proto.definition({"item", "connector"}, "crude", true)
local basic_connector = proto.definition({"item", "connector"}, "basic", true)
local standard_connector = proto.definition({"item", "connector"}, "standard", true)
local improved_connector = proto.definition({"item", "connector"}, "improved", true)
local advanced_connector = proto.definition({"item", "connector"}, "advanced", true)
local crude_servo = proto.definition({"item", "servo"}, "crude", true)
local standard_servo = proto.definition({"item", "servo"}, "standard", true)
local improved_servo = proto.definition({"item", "servo"}, "improved", true)

-- Tiles
local wooden_floor = proto.definition({"item", "floor"}, "wood", true)

data:extend({crude_connector, basic_connector, standard_connector, improved_connector, advanced_connector, crude_servo, standard_servo, improved_servo, wooden_floor})