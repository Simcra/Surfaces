require("script.proto")

local underground_entrance = proto.get({"entity", "access_shaft"}, "underground_entrance", true)
local underground_exit = proto.get({"entity", "access_shaft"}, "underground_exit", true)
local sky_entrance = proto.get({"entity", "access_shaft"}, "sky_entrance", true)
local sky_exit = proto.get({"entity", "access_shaft"}, "sky_exit", true)
underground_entrance.minable.result = proto.get_field({"item", "access_shaft", "underground_entrance"}, "name")
underground_exit.minable.result = proto.get_field({"item", "access_shaft", "underground_exit"}, "name")
sky_entrance.minable.result = proto.get_field({"item", "access_shaft", "sky_entrance"}, "name")
sky_exit.minable.result = proto.get_field({"item", "access_shaft", "sky_exit"}, "name")

data:extend({underground_entrance, underground_exit, sky_entrance, sky_exit})