require("script.proto")

local invisible_corpse = table.deepcopy(proto.corpse.common)
for k, v in pairs(proto.corpse.invisible) do
	invisible_corpse[k] = v
end
data:extend({proto.entity.underground_wall, invisible_corpse})