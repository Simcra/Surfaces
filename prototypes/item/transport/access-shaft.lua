require("script.proto")

local sky_entrance, sky_exit, underground_entrance, underground_exit = table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common)
for k, v in pairs(proto.item.access_shaft.common) do
	sky_entrance[k] = v
	sky_exit[k] = v
	underground_entrance[k] = v
	underground_exit[k] = v
end
for k, v in pairs(proto.item.access_shaft.sky_entrance) do
	sky_entrance[k] = v
end
for k, v in pairs(proto.item.access_shaft.sky_exit) do
	sky_exit[k] = v
end
for k, v in pairs(proto.item.access_shaft.underground_entrance) do
	underground_entrance[k] = v
end
for k, v in pairs(proto.item.access_shaft.underground_exit) do
	underground_exit[k] = v
end
data:extend({sky_entrance, sky_exit, underground_entrance, underground_exit})