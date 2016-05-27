data:extend({{
	type = "recipe",
	name = "electric-pole-lower",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"medium-electric-pole", 2}},
	result = "electric-pole-lower",
},{
	type = "recipe",
	name = "electric-pole-lower-2",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"electric-pole-upper", 1}},
	result = "electric-pole-lower",
},{
	type = "recipe",
	name = "electric-pole-upper",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"medium-electric-pole", 2}},
	result = "electric-pole-upper",
},{
	type = "recipe",
	name = "electric-pole-upper-2",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"electric-pole-lower", 1}},
	result = "electric-pole-upper",
},{
	type = "recipe",
	name = "medium-electric-pole-2",
	enabled = true,
	ingredients = {{"electric-pole-lower", 1}},
	result = "medium-electric-pole",
	result_count = 2
},{
	type = "recipe",
	name = "medium-electric-pole-3",
	enabled = true,
	ingredients = {{"electric-pole-upper", 1}},
	result = "medium-electric-pole",
	result_count = 2
}})