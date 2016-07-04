require("script.proto")
local iconpath, filetype = "__Surfaces__/graphics/icons/transport/", ".png"

local small_electric_pole_upper, small_electric_pole_lower, medium_electric_pole_upper, medium_electric_pole_lower, big_electric_pole_upper, big_electric_pole_lower, substation_upper, substation_lower = table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common), table.deepcopy(proto.item.common)
for k, v in pairs(proto.item.electric_pole.common) do
	small_electric_pole_lower[k] = v
	small_electric_pole_upper[k] = v
	medium_electric_pole_lower[k] = v
	medium_electric_pole_upper[k] = v
	big_electric_pole_lower[k] = v
	big_electric_pole_upper[k] = v
	substation_lower[k] = v
	substation_upper[k] = v
end

-- small electric pole
for k, v in pairs(proto.item.electric_pole.small.lower) do
	small_electric_pole_lower[k] = v
end
for k, v in pairs(proto.item.electric_pole.small.upper) do
	small_electric_pole_upper[k] = v
end
data:extend({small_electric_pole_lower, small_electric_pole_upper})

-- medium electric pole
for k, v in pairs(proto.item.electric_pole.medium.lower) do
	medium_electric_pole_lower[k] = v
end
for k, v in pairs(proto.item.electric_pole.medium.upper) do
	medium_electric_pole_upper[k] = v
end
data:extend({medium_electric_pole_lower, medium_electric_pole_upper})

-- big electric pole
for k, v in pairs(proto.item.electric_pole.big.lower) do
	big_electric_pole_lower[k] = v
end
for k, v in pairs(proto.item.electric_pole.big.upper) do
	big_electric_pole_upper[k] = v
end
data:extend({big_electric_pole_lower, big_electric_pole_upper})

-- substation
for k, v in pairs(proto.item.electric_pole.substation.lower) do
	substation_lower[k] = v
end
for k, v in pairs(proto.item.electric_pole.substation.upper) do
	substation_upper[k] = v
end
data:extend({substation_lower, substation_upper})