-- local iconpath, filetype = "__Surfaces__/graphics/icons/components/", ".png"

-- Servos
local simple_servo = table.deepcopy(data.raw.item["electronic-circuit"])
simple_servo.name = "simple-servo"
simple_servo.place_result = ""
simple_servo.stack_size = 200
simple_servo.order = "z[servo]-a"
simple_servo.flags = {"goes-to-main-inventory"}
data:extend({simple_servo})

local basic_servo = table.deepcopy(data.raw.item["electronic-circuit"])
basic_servo.name = "basic-servo"
basic_servo.place_result = ""
basic_servo.stack_size = 200
basic_servo.order = "z[servo]-b"
basic_servo.flags = {"goes-to-main-inventory"}
data:extend({basic_servo})

local improved_servo = table.deepcopy(data.raw.item["advanced-circuit"])
improved_servo.name = "improved-servo"
improved_servo.place_result = ""
improved_servo.stack_size = 200
improved_servo.order = "z[servo]-c"
improved_servo.flags = {"goes-to-main-inventory"}
data:extend({improved_servo})

local fluid_servo = table.deepcopy(improved_servo)
fluid_servo.name = "fluid-servo"
data:extend({fluid_servo})

local advanced_servo = table.deepcopy(data.raw.item["processing-unit"])
advanced_servo.name = "advanced-servo"
advanced_servo.place_result = ""
advanced_servo.stack_size = 200
advanced_servo.order = "z[servo]-d"
advanced_servo.flags = {"goes-to-main-inventory"}
data:extend({advanced_servo})