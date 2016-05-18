data:extend({
{
	type = "electric-pole",
    name = "underground-entrance",
    flags = {},
    minable = {mining_time = 5, result="underground-entrance"},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {
      filename = "__Surfaces__/graphics/entity/access-shaft/underground-entrance.png",
      priority = "high",
      width = 96,
      height = 96,
      direction_count = 1,
      shift = {0, 0},
    },
    connection_points = {{
        shadow = {
          copper = {0.5, -0.5},
          green = {0.49, -0.5},
          red = {0.51, -0.5},
        },
        wire = {
          copper = {0.4, -0.6},
          green = {0.39, -0.6},
          red = {0.41, -0.6},
        }
	}},
	resistances = {{
		type = "physical",
		percent = 20,
	}, {
		type = "poison",
		percent = 100,
	}},	
    radius_visualisation_picture = {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale",
    },
    circuit_wire_max_distance = 2.5,
    maximum_wire_distance = 2.5,
    supply_area_distance = 1.5
},{
	type = "electric-pole",
    name = "underground-exit",
    flags = {},
    minable = {mining_time = 5, result="underground-exit"},
    max_health = 100,
    corpse = "small-remnants",
    collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	pictures = {
      filename = "__Surfaces__/graphics/entity/access-shaft/underground-exit.png",
      priority = "high",
      width = 96,
      height = 96,
      direction_count = 1,
      shift = {0, 0},
    },
    connection_points = {{
        shadow = {
          copper = {0.5, -0.5},
          green = {0.49, -0.5},
          red = {0.51, -0.5},
        },
        wire = {
          copper = {0.4, -0.6},
          green = {0.39, -0.6},
          red = {0.41, -0.6},
        }
	}},
	resistances = {{
		type = "physical",
		percent = 20,
	}, {
		type = "poison",
		percent = 100,
	}},	
    radius_visualisation_picture = {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale",
    },
    circuit_wire_max_distance = 2.5,
    maximum_wire_distance = 2.5,
    supply_area_distance = 1.5,
}})