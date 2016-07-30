require("script.proto")

local invisible_corpse = proto.get({"corpse"}, "invisible", true)
local underground_wall = proto.get({"entity"}, "underground_wall", true)
data:extend({underground_wall, invisible_corpse})
