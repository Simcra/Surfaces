data:extend({{
	type = "recipe",
	name = "transport-chest-up",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"logistic-chest-requester", 1}},
	result = "transport-chest-up",
},{
	type = "recipe",
	name = "transport-chest-down",
	group = "surfaces",
	subgroup = "surfaces-transport",
	enabled = true,
	ingredients = {{"logistic-chest-requester", 1}},
	result = "transport-chest-down",
},{
	type = "recipe",
	name = "logistic-chest-requester-2",
	enabled = true,
	ingredients = {{"transport-chest-up", 1}},
	result = "logistic-chest-requester",
},{
	type = "recipe",
	name = "logistic-chest-requester-3",
	enabled = true,
	ingredients = {{"transport-chest-down", 1}},
	result = "logistic-chest-requester",
}})