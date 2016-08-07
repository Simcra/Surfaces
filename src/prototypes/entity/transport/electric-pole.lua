require("script.proto")

local small_lower = proto.get({"entity", "electric_pole", "small"}, "lower", true, data.raw["electric-pole"]["small-electric-pole"])
local small_upper = proto.get({"entity", "electric_pole", "small"}, "upper", true, data.raw["electric-pole"]["small-electric-pole"])
local medium_lower = proto.get({"entity", "electric_pole", "medium"}, "lower", true, data.raw["electric-pole"]["medium-electric-pole"])
local medium_upper = proto.get({"entity", "electric_pole", "medium"}, "upper", true, data.raw["electric-pole"]["medium-electric-pole"])
local big_lower = proto.get({"entity", "electric_pole", "big"}, "lower", true, data.raw["electric-pole"]["big-electric-pole"])
local big_upper = proto.get({"entity", "electric_pole", "big"}, "upper", true, data.raw["electric-pole"]["big-electric-pole"])
local substation_lower = proto.get({"entity", "electric_pole", "substation"}, "lower", true, data.raw["electric-pole"]["substation"])
local substation_upper = proto.get({"entity", "electric_pole", "substation"}, "upper", true, data.raw["electric-pole"]["substation"])

data:extend({small_upper, small_lower, medium_upper, medium_lower, big_upper, big_lower, substation_upper, substation_lower})