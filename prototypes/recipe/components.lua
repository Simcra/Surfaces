local servo_recipe = {
	type = "recipe",
	group = "surfaces",
	subgroup = "surfaces-components",
	enabled = true,
	result_count = 1
}

local simple_servo = table.deepcopy(servo_recipe)
simple_servo.name = "simple-servo"
simple_servo.ingredients = {{"iron-gear-wheel", 1}, {"iron-stick", 2}, {"copper-cable", 2}, {"electronic-circuit", 1}}
simple_servo.result = simple_servo.name
data:extend({simple_servo})

local basic_servo = table.deepcopy(servo_recipe)
basic_servo.name = "basic-servo"
basic_servo.ingredients = {{simple_servo.result, 2}, {"copper-cable", 3}, {"electronic-circuit", 1}}
basic_servo.result = basic_servo.name
data:extend({basic_servo})

local improved_servo = table.deepcopy(servo_recipe)
improved_servo.name = "improved-servo"
improved_servo.ingredients = {{basic_servo.result, 2}, {"copper-cable", 3}, {"advanced-circuit", 1}}
improved_servo.result = improved_servo.name
data:extend({improved_servo})

local advanced_servo = table.deepcopy(servo_recipe)
advanced_servo.name = "advanced-servo"
advanced_servo.ingredients = {{improved_servo.result, 2}, {"green-wire", 1}, {"red-wire", 1}, {"copper-cable", 1}, {"processing-unit", 1}}
advanced_servo.result = advanced_servo.name
data:extend({advanced_servo})

local fluid_servo = table.deepcopy(basic_servo)
fluid_servo.name = "fluid-servo"
fluid_servo.ingredients = {{"iron-gear-wheel", 1}, {"pipe", 1}, {basic_servo.result, 2}}
fluid_servo.result = fluid_servo.name
data:extend({fluid_servo})