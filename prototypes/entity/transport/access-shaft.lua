require("script.proto")

local underground_entrance, underground_exit, sky_entrance, sky_exit = table.deepcopy(proto.entity.access_shaft.common), table.deepcopy(proto.entity.access_shaft.common), table.deepcopy(proto.entity.access_shaft.common), table.deepcopy(proto.entity.access_shaft.common)
for k, v in pairs(proto.entity.access_shaft.underground_entrance) do
	underground_entrance[k] = v
end
for k, v in pairs(proto.entity.access_shaft.underground_exit) do
	underground_exit[k] = v
end
for k, v in pairs(proto.entity.access_shaft.sky_entrance) do
	sky_entrance[k] = v
end
for k, v in pairs(proto.entity.access_shaft.sky_exit) do
	sky_exit[k] = v
end
data:extend({underground_entrance, underground_exit, sky_entrance, sky_exit})