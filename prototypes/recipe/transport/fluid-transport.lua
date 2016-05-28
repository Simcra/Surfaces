data:extend({{
	type = "recipe",
	name = "fluid-transport-upper",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"storage-tank", 2}},
	result = "fluid-transport-upper",
},{
	type = "recipe",
	name = "fluid-transport-lower",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"storage-tank", 2}},
	result = "fluid-transport-lower",
},{
	type = "recipe",
	name = "storage-tank-2",
	enabled = true,
	ingredients = {{"fluid-transport-lower", 1}},
	result = "storage-tank",
	result_count = 2
},{
	type = "recipe",
	name = "storage-tank-3",
	enabled = true,
	ingredients = {{"fluid-transport-upper", 1}},
	result = "storage-tank",
	result_count = 2
}})