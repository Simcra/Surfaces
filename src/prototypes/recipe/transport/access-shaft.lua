require("prototypes.prototype")

local sky_entrance = proto.definition({"recipe", "access_shaft"}, "sky_entrance", true)
local sky_exit = proto.definition({"recipe", "access_shaft"}, "sky_exit", true)
local underground_entrance = proto.definition({"recipe", "access_shaft"}, "underground_entrance", true)
local underground_exit = proto.definition({"recipe", "access_shaft"}, "underground_exit", true)

data:extend({sky_entrance, sky_exit, underground_entrance, underground_exit})