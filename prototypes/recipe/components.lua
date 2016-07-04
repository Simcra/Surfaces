require("script.proto")

-- Servos
local simple_servo = proto.recipe.servo.simple
local basic_servo = proto.recipe.servo.basic
local improved_servo = proto.recipe.servo.improved
local fluid_servo = proto.recipe.servo.fluid
local advanced_servo = proto.recipe.servo.advanced
for k, v in pairs(proto.recipe.servo.common) do
	simple_servo[k] = v
	basic_servo[k] = v
	improved_servo[k] = v
	fluid_servo[k] = v
	advanced_servo[k] = v
end
data:extend({simple_servo, basic_servo, improved_servo, fluid_servo, advanced_servo})