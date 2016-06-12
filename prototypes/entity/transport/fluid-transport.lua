local fluid_transport = table.deepcopy(data.raw["storage-tank"]["storage-tank"])
local blank = function() return {filename = "__Surfaces__/graphics/icons/blank.png", priority = "extra-high", frames = 1, width = 32, height = 32, shift = {0, 0}} end
fluid_transport.collision_box = {{-0.5, -0.5}, {0.5, 0.5}}
fluid_transport.selection_box = {{-0.5, -0.5}, {0.5, 0.5}}
fluid_transport.corpse = "small-remnants"
fluid_transport.fluid_box.base_area = 2.75
fluid_transport.fluid_box.pipe_connections = {{position = {0, 1}}, {position = {0,-1}}, {position = {1, 0}}, {position = {-1, 0}}}
fluid_transport.window_bounding_box = {{0, 0}, {0, 0}}
fluid_transport.pictures.picture.sheet = blank()
fluid_transport.pictures.fluid_background = blank()
fluid_transport.pictures.window_background = blank()
fluid_transport.pictures.flow_sprite = blank()
fluid_transport.circuit_wire_connection_point = table.deepcopy(data.raw["smart-container"]["smart-chest"].circuit_wire_connection_point)

local fluid_transport_lower = table.deepcopy(fluid_transport)
fluid_transport_lower.name = "fluid-transport-lower"
fluid_transport_lower.icon = "__Surfaces__/graphics/icons/transport/fluid-transport-lower.png"
fluid_transport_lower.minable.result = "fluid-transport-lower"
data:extend({fluid_transport_lower})

local fluid_transport_upper = table.deepcopy(fluid_transport)
fluid_transport_upper.name = "fluid-transport-upper"
fluid_transport_upper.icon = "__Surfaces__/graphics/icons/transport/fluid-transport-upper.png"
fluid_transport_upper.minable.result = "fluid-transport-upper"
data:extend({fluid_transport_upper})