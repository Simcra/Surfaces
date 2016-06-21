local servo_recipe = {
	type = "recipe",
	group = "surfaces",
	subgroup = "surfaces-components",
	enabled = true,
	result_count = 1
}

local basic_servo = table.deepcopy(servo_recipe)
basic_servo.name = "basic-servo"
basic_servo.ingredients = {{"iron-gear-wheel", 1}, {"iron-stick", 2}, {"electronic-circuit", 1}, {"copper-cable", 2}}
basic_servo.result = basic_servo.name
data:extend({basic_servo})

local improved_servo = table.deepcopy(servo_recipe)
improved_servo.name = "improved-servo"
improved_servo.ingredients = {{basic_servo.result, 1}, {"advanced-circuit", 1}}
improved_servo.result = improved_servo.name
data:extend({improved_servo})

local advanced_servo = table.deepcopy(servo_recipe)
advanced_servo.name = "advanced-servo"
advanced_servo.ingredients = {{improved_servo.result, 1}, {"green-wire", 2}, {"red-wire", 2}, {"advanced-circuit", 1}}
advanced_servo.result = advanced_servo.name
data:extend({advanced_servo})

local fluid_servo = table.deepcopy(basic_servo)
fluid_servo.name = "fluid-servo"
fluid_servo.ingredients = {{"iron-gear-wheel", 1}, {"pipe", 1}, {basic_servo.result, 1}}
fluid_servo.result = fluid_servo.name
data:extend({fluid_servo})