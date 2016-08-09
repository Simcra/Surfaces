require("script.proto")

local _ref = proto.reference.bobpower.entity

local energy_transport_2_lower = proto.get({"entity", "energy_transport", "standard_2"}, "lower", true, data.raw["accumulator"][_ref.accumulator_2])
local energy_transport_2_upper = proto.get({"entity", "energy_transport", "standard_2"}, "upper", true, data.raw["accumulator"][_ref.accumulator_2])
local energy_transport_3_lower = proto.get({"entity", "energy_transport", "standard_3"}, "lower", true, data.raw["accumulator"][_ref.accumulator_3])
local energy_transport_3_upper = proto.get({"entity", "energy_transport", "standard_3"}, "upper", true, data.raw["accumulator"][_ref.accumulator_3])
local energy_transport_4_lower = proto.get({"entity", "energy_transport", "standard_4"}, "lower", true, data.raw["accumulator"][_ref.accumulator_4])
local energy_transport_4_upper = proto.get({"entity", "energy_transport", "standard_4"}, "upper", true, data.raw["accumulator"][_ref.accumulator_4])

data:extend({energy_transport_2_lower, energy_transport_2_upper, energy_transport_3_lower, energy_transport_3_upper, energy_transport_4_lower,
	energy_transport_4_upper})