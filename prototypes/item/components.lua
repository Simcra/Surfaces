-- local iconpath, filetype = "__Surfaces__/graphics/icons/components/", ".png"

-- Servos
local basic_servo = table.deepcopy(data.raw.item["electronic-circuit"])
basic_servo.name = "basic-servo"
basic_servo.place_result = ""
basic_servo.stack_size = 200
data:extend({basic_servo})

local improved_servo = table.deepcopy(data.raw.item["advanced-circuit"])
improved_servo.name = "improved-servo"
improved_servo.place_result = ""
improved_servo.stack_size = 200
data:extend({improved_servo})

local advanced_servo = table.deepcopy(data.raw.item["processing-unit"])
advanced_servo.name = "advanced-servo"
advanced_servo.place_result = ""
advanced_servo.stack_size = 200
data:extend({advanced_servo})

local fluid_servo = table.deepcopy(basic_servo)
fluid_servo.name = "fluid-servo"
data:extend({fluid_servo})