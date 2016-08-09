require("script.proto")

local underground_entrance = proto.get({"item", "access_shaft"}, "underground_entrance", true)
local underground_exit = proto.get({"item", "access_shaft"}, "underground_exit", true)
local sky_entrance = proto.get({"item", "access_shaft"}, "sky_entrance", true)
local sky_exit = proto.get({"item", "access_shaft"}, "sky_exit", true)

data:extend({underground_entrance, underground_exit, sky_entrance, sky_exit})