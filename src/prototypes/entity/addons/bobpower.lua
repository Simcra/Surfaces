require("script.proto")

-- Electric poles
local _ref = proto.reference()
local medium_2_lower = proto.get({"entity", "electric_pole", "medium_2"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_2])
local medium_2_upper = proto.get({"entity", "electric_pole", "medium_2"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_2])
local medium_3_lower = proto.get({"entity", "electric_pole", "medium_3"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_3])
local medium_3_upper = proto.get({"entity", "electric_pole", "medium_3"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_3])
local medium_4_lower = proto.get({"entity", "electric_pole", "medium_4"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_4])
local medium_4_upper = proto.get({"entity", "electric_pole", "medium_4"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.medium_electric_pole_4])
local big_2_lower = proto.get({"entity", "electric_pole", "big_2"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_2])
local big_2_upper = proto.get({"entity", "electric_pole", "big_2"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_2])
local big_3_lower = proto.get({"entity", "electric_pole", "big_3"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_3])
local big_3_upper = proto.get({"entity", "electric_pole", "big_3"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_3])
local big_4_lower = proto.get({"entity", "electric_pole", "big_4"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_4])
local big_4_upper = proto.get({"entity", "electric_pole", "big_4"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.big_electric_pole_4])
local substation_2_lower = proto.get({"entity", "electric_pole", "substation_2"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.substation_2])
local substation_2_upper = proto.get({"entity", "electric_pole", "substation_2"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.substation_2])
local substation_3_lower = proto.get({"entity", "electric_pole", "substation_3"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.substation_3])
local substation_3_upper = proto.get({"entity", "electric_pole", "substation_3"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.substation_3])
local substation_4_lower = proto.get({"entity", "electric_pole", "substation_4"}, "lower", true, data.raw["electric-pole"][_ref.bobpower.substation_4])
local substation_4_upper = proto.get({"entity", "electric_pole", "substation_4"}, "upper", true, data.raw["electric-pole"][_ref.bobpower.substation_4])

data:extend({medium_2_lower, medium_2_upper, medium_3_lower, medium_3_upper, medium_4_lower, medium_4_upper,
	big_2_lower, big_2_upper, big_3_lower, big_3_upper, big_4_lower, big_4_upper,
	substation_2_lower, substation_2_upper, substation_3_lower, substation_3_upper, substation_4_lower, substation_4_upper})