require("prototypes.prototype")

local underground_entrance = proto.definition({"entity", "access_shaft"}, "underground_entrance", true)
local underground_exit = proto.definition({"entity", "access_shaft"}, "underground_exit", true)
local sky_entrance = proto.definition({"entity", "access_shaft"}, "sky_entrance", true)
local sky_exit = proto.definition({"entity", "access_shaft"}, "sky_exit", true)

data:extend({underground_entrance, underground_exit, sky_entrance, sky_exit})