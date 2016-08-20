require("prototypes.prototype")

-- Terrain
local sky_void = proto.definition({"tile"}, "sky_void", true)
local underground_dirt = proto.definition({"tile"}, "underground_dirt", true)
local underground_wall = proto.definition({"tile"}, "underground_wall", true)
underground_dirt.walking_sound = table.deepcopy(data.raw["tile"]["dirt"].walking_sound)

-- Floor
local wooden_floor = proto.definition({"tile", "floor"}, "wood", true)
wooden_floor.walking_sound = table.deepcopy(data.raw["tile"]["concrete"].walking_sound)

data:extend({wooden_floor, sky_void, underground_dirt, underground_wall})