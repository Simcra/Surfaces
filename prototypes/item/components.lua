require("script.proto")

-- Servos
local simple_servo, basic_servo, improved_servo, fluid_servo, advanced_servo = table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common)
for k, v in pairs(proto.item.servo.common) do
	simple_servo[k] = v
	basic_servo[k] = v
	improved_servo[k] = v
	fluid_servo[k] = v
	advanced_servo[k] = v
end
for k, v in pairs(proto.item.servo.simple) do
	simple_servo[k] = v
end
for k, v in pairs(proto.item.servo.basic) do
	basic_servo[k] = v
end
for k, v in pairs(proto.item.servo.improved) do
	improved_servo[k] = v
end
for k, v in pairs(proto.item.servo.fluid) do
	fluid_servo[k] = v
end
for k, v in pairs(proto.item.servo.advanced) do
	advanced_servo[k] = v
end
data:extend({simple_servo, basic_servo, improved_servo, fluid_servo, advanced_servo})