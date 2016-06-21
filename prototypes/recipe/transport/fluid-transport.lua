local fluid_transport = {
	type = "recipe",
	group = "surfaces",
	subgroup = "surfaces-transport-other",
	enabled = true,
	ingredients = {{"storage-tank", 2}, {"fluid-servo", 1}}
}

local fluid_transport_upper = table.deepcopy(fluid_transport)
fluid_transport_upper.name = "fluid-transport-upper"
fluid_transport_upper.result = fluid_transport_upper.name
data:extend({fluid_transport_upper})

local fluid_transport_lower = table.deepcopy(fluid_transport)
fluid_transport_lower.name = "fluid-transport-lower"
fluid_transport_lower.result = fluid_transport_lower.name
data:extend({fluid_transport_lower})