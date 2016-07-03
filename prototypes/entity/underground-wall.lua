require("script.proto")

local underground_wall = proto.entity.underground_wall
data:extend({underground_wall})

local invisible_corpse = table.deepcopy(data.raw["corpse"]["medium-biter-corpse"])
for k, v in pairs(proto.corpse.invisible) do
	invisible_corpse[k] = v
end
data:extend({invisible_corpse})