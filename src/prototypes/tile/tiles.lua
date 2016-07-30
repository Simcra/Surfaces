require("script.proto")

local wooden_floor = proto.get({"tile", "floor"}, "wood", true)
local sky_void = proto.get({"tile"}, "sky_void", true)
local underground_dirt = proto.get({"tile"}, "underground_dirt", true)
local underground_wall = proto.get({"tile"}, "underground_wall", true)
wooden_floor.minable.result = proto.get_field({"item", "floor", "wood"}, "name")
wooden_floor.walking_sound = table.deepcopy(data.raw["tile"]["concrete"].walking_sound)
underground_dirt.walking_sound = table.deepcopy(data.raw["tile"]["dirt"].walking_sound)

data:extend({wooden_floor, sky_void, underground_dirt, underground_wall})
