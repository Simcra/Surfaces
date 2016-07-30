require("script.proto")

local fluid_transport_lower = proto.get({"entity", "fluid_transport", "standard"}, "lower", true)
local fluid_transport_upper = proto.get({"entity", "fluid_transport", "standard"}, "upper", true)
fluid_transport_lower.minable.result = proto.get_field({"item", "fluid_transport", "standard", "lower"}, "name")
fluid_transport_upper.minable.result = proto.get_field({"item", "fluid_transport", "standard", "upper"}, "name")

fluid_transport_lower.circuit_wire_connection_points = {}
fluid_transport_lower.circuit_connector_sprites = {}
fluid_transport_upper.circuit_wire_connection_points = {}
fluid_transport_upper.circuit_connector_sprites = {}
for i = 0, 3 do
	table.insert(fluid_transport_lower.circuit_wire_connection_points, data.raw["container"]["steel-chest"].circuit_wire_connection_point)
	table.insert(fluid_transport_upper.circuit_wire_connection_points, data.raw["container"]["steel-chest"].circuit_wire_connection_point)
	table.insert(fluid_transport_lower.circuit_connector_sprites, data.raw["container"]["steel-chest"].circuit_connector_sprites)
	table.insert(fluid_transport_upper.circuit_connector_sprites, data.raw["container"]["steel-chest"].circuit_connector_sprites)
end

data:extend({fluid_transport_lower, fluid_transport_upper})
