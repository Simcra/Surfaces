require("prototypes.prototype")

local invisible_corpse = proto.definition({"corpse"}, "invisible", true)
local underground_wall = proto.definition({"entity"}, "underground_wall", true)

data:extend({underground_wall, invisible_corpse})