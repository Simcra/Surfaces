data:extend({{
	type = "recipe",
	name = "transport-chest-up",
	group = "surfaces",
	subgroup = "transport-chest",
	enabled = true,
	ingredients = {
		{"logistic-chest-requester", 1},
	},
	result = "transport-chest-up",
},{
	type = "recipe",
	name = "transport-chest-up-2",
	group = "surfaces",
	subgroup = "transport-chest",
	enabled = true,
	ingredients = {
		{"transport-chest-down", 1},
	},
	result = "transport-chest-up",
},{
	type = "recipe",
	name = "transport-chest-down",
	group = "surfaces",
	subgroup = "transport-chest",
	enabled = true,
	ingredients = {
		{"logistic-chest-requester", 1},
	},
	result = "transport-chest-down",
},{
	type = "recipe",
	name = "transport-chest-down-2",
	group = "surfaces",
	subgroup = "transport-chest",
	enabled = true,
	ingredients = {
		{"transport-chest-up", 1},
	},
	result = "transport-chest-down",
}})