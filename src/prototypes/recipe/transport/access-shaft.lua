require("script.proto")

local sky_entrance = proto.get({"recipe", "access_shaft"}, "sky_entrance", true)
local sky_exit = proto.get({"recipe", "access_shaft"}, "sky_exit", true)
local underground_entrance = proto.get({"recipe", "access_shaft"}, "underground_entrance", true)
local underground_exit = proto.get({"recipe", "access_shaft"}, "underground_exit", true)
sky_entrance.result = proto.get_field({"item", "access_shaft", "sky_entrance"}, "name")
sky_exit.result = proto.get_field({"item", "access_shaft", "sky_exit"}, "name")
underground_entrance.result = proto.get_field({"item", "access_shaft", "underground_entrance"}, "name")
underground_exit.result = proto.get_field({"item", "access_shaft", "underground_exit"}, "name")

data:extend({sky_entrance, sky_exit, underground_entrance, underground_exit})
