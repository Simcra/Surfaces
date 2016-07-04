require("script.proto")

local fluid_transport_lower, fluid_transport_upper = table.deepcopy(data.raw["storage-tank"]["storage-tank"]), table.deepcopy(data.raw["storage-tank"]["storage-tank"])
for k, v in pairs(proto.entity.fluid_transport.common) do
	fluid_transport_lower[k] = v
	fluid_transport_upper[k] = v
end
for k, v in pairs(proto.entity.fluid_transport.lower) do
	fluid_transport_lower[k] = v
end
for k, v in pairs(proto.entity.fluid_transport.upper) do
	fluid_transport_upper[k] = v
end
data:extend({fluid_transport_lower, fluid_transport_upper})