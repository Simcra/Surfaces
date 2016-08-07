require("script.proto")

-- Terrain
local sky_void = proto.get({"tile"}, "sky_void", true)
local underground_dirt = proto.get({"tile"}, "underground_dirt", true)
local underground_wall = proto.get({"tile"}, "underground_wall", true)
underground_dirt.walking_sound = table.deepcopy(data.raw["tile"]["dirt"].walking_sound)

-- Floor
local wooden_floor = proto.get({"tile", "floor"}, "wood", true)
wooden_floor.walking_sound = table.deepcopy(data.raw["tile"]["concrete"].walking_sound)

data:extend({wooden_floor, sky_void, underground_dirt, underground_wall})