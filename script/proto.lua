--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.struct-base")
require("script.lib.util")

--[[
Note: This is NOT a configuration file! Data in this file CAN and most probably WILL break your savegame if modified.
]]
proto = { -- Prototype data, referenced throughout this mod, including data definition
	entity = { -- Entities
		underground_wall = {
			name = "underground-wall",
			type = "tree",
			icon = "__Surfaces__/graphics/terrain/underground/wall2.png",
			flags = {"placeable-neutral"},
			order = "z-a[surfaces]-a[underground-wall]",
			collision_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
			selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
			minable = {hardness = 2, mining_time = 2, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 4}}},
			pictures = {struct.Picture("__Surfaces__/graphics/terrain/underground/wall.png", "extra-high", 32, 32)},
			resistances = struct.Resistances({{"impact", 80}, {"physical", 5}, {"poison", 100}, {"fire", 100}, {"acid", 95}, {"explosion", 5}}),
			max_health = 100,
			corpse = "invisible-corpse",
			mined_sound = struct.Sound("__base__/sound/deconstruct-bricks.ogg"),
			vehicle_impact_sound =	struct.Sound("__base__/sound/car-stone-impact.ogg", 1.0),
			map_color = util.RGB(60, 52, 36),
		},
		access_shaft = {
			common = {
				type = "simple-entity",
				flags = {},
				collision_mask = {"object-layer", "player-layer"},
				order = "z-a[surfaces]-a[access-shaft]",
				collision_box = struct.BoundingBox(-0.4, -0.4, 0.4, 0.4),
				selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
				resistances = struct.Resistances({{"impact", 20}, {"physical", 20}, {"poison", 100}, {"fire", 5}, {"acid", 15}}),
				max_health = 100,
				corpse = "small-remnants",
				render_layer = "object",
				map_color = util.RGB(127, 88, 43, 50),
			},
			underground_entrance = {
				name = "underground-entrance",
				icon = "__Surfaces__/graphics/icons/transport/underground-entrance.png",
				pictures = struct.Picture("__Surfaces__/graphics/entity/transport/underground-entrance.png", "extra-high", 96, 96),
				minable = {hardness = 1, mining_time = 8, result = "underground-entrance"},
			},
			underground_exit = {
				name = "underground-exit",
				icon = "__Surfaces__/graphics/icons/transport/underground-exit.png",
				pictures = struct.Picture("__Surfaces__/graphics/entity/transport/underground-exit.png", "extra-high", 96, 96),
				minable = {hardness = 1, mining_time = 8, result = "underground-exit"},
			},
			sky_entrance = {
				name = "sky-entrance",
				icon = "__Surfaces__/graphics/icons/transport/sky-entrance.png",
				pictures = struct.Picture("__Surfaces__/graphics/entity/transport/sky-entrance.png", "extra-high", 96, 96),
				minable = {hardness = 1, mining_time = 8, result = "sky-entrance"},
			},
			sky_exit = {
				name = "sky-exit",
				icon = "__Surfaces__/graphics/icons/transport/sky-exit.png",
				pictures = struct.Picture("__Surfaces__/graphics/entity/transport/sky-exit.png", "extra-high", 96, 96),
				minable = {hardness = 1, mining_time = 8, result = "sky-exit"},
			}
		},
		fluid_transport = {
			common = {
				type = "storage-tank",
				flags = {"placeable-player", "player-creation"},
				max_health = 500,
				collision_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
				selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
				corpse = "small-remnants",
				fluid_box = {
					base_area = 27.5,
					pipe_covers = const.pictures.pipecovers,
					pipe_connections = {{position = {0, 1}}, {position = {0,-1}}, {position = {1, 0}}, {position = {-1, 0}}}
				},
				window_bounding_box = struct.BoundingBox(0, 0, 0, 0),
				flow_length_in_ticks = 360,
				vehicle_impact_sound = struct.Sound("__base__/sound/car-metal-impact.ogg", 0.65),
				circuit_wire_max_distance = 7.5
			},
			upper = {
				name = "fluid-transport-upper",
				icon = "__Surfaces__/graphics/icons/transport/fluid-transport-upper.png",
				pictures = {
					picture = {sheet = struct.Picture("__Surfaces__/graphics/entity/transport/fluid-transport-upper.png", "low", 32, 32, 1)},
					fluid_background = const.pictures.blank,
					window_background = const.pictures.blank,
					flow_sprite = const.pictures.blank
				},
				minable = {hardness = 0.2, mining_time = 3, result = "fluid-transport-upper"}
			},
			lower = {
				name = "fluid-transport-lower",
				icon = "__Surfaces__/graphics/icons/transport/fluid-transport-lower.png",
				pictures = {
					picture = {sheet = struct.Picture("__Surfaces__/graphics/entity/transport/fluid-transport-lower.png", "low", 32, 32, 1)},
					fluid_background = const.pictures.blank,
					window_background = const.pictures.blank,
					flow_sprite = const.pictures.blank
				},
				minable = {hardness = 0.2, mining_time = 3, result = "fluid-transport-lower"}
			}
		}
	},
	tile = { -- Tiles
		underground_dirt = {
			name = "underground-dirt",
			layer = 57,
			collision_mask = {"ground-tile"},
			walking_speed_modifier = 0.8,
			decorative_removal_probability = 1,
			needs_correction = false,
			map_color = util.RGB(107, 44, 4),
			aging = 0
		},
		sky = {
			name = "sky-tile",
			layer = 58,
			collision_mask = {"ground-tile", "resource-layer", "object-layer", "player-layer", "doodad-layer"},
			decorative_removal_probability = 1,
			needs_correction = false,
			map_color = util.RGB(145, 212, 252)
		},
		platform = {
			name = "construction-platform",
			layer = 59,
			collision_mask = {"ground-tile", "floor-layer", "doodad-layer"},
			walking_speed_modifier = 1,
			decorative_removal_probability = 1,
			needs_correction = false
		}
	},
	corpse = { -- Corpses
		common = {
			type = "corpse",
		},
		invisible = {
			name = "invisible-corpse",
			icon = "__Surfaces__/graphics/icons/blank.png",
			flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
			animation = {},
			time_before_removed = 60,
			order = "c[corpse]-a[biter]-b[invisible]"
		}
	},
	item = { -- Items
		common = {
			type = "item"
		},
		servo = {
			common = {
				flags = {"goes-to-main-inventory"},
				stack_size = 200,
				place_result = ""
			},
			simple = {
				name = "simple-servo",
				icon = "__base__/graphics/icons/electronic-circuit.png",
				order = "z[servo]-a"
			},
			basic = {
				name = "basic-servo",
				icon = "__base__/graphics/icons/electronic-circuit.png",
				order = "z[servo]-b"
			},
			fluid = {
				name = "fluid-servo",
				icon = "__base__/graphics/icons/advanced-circuit.png",
				order = "z[servo]-b"
			},
			improved = {
				name = "improved-servo",
				icon = "__base__/graphics/icons/advanced-circuit.png",
				order = "z[servo]-c"
			},
			advanced = {
				name = "advanced-servo",
				icon = "__base__/graphics/icons/processing-unit.png",
				order = "z[servo]-d"
			}
		},
		electric_pole = {
			common = {
				flags = {"goes-to-quickbar"},
				stack_size = 50
			},
			small = {
				lower = {
					name = "small-electric-pole-lower",
					icon = "__Surfaces__/graphics/icons/transport/small-electric-pole-lower.png",
					place_result = "small-electric-pole-lower",
					order = "a[energy]-a[small-electric-pole]-[transport]"
				},
				upper = {
					name = "small-electric-pole-upper",
					icon = "__Surfaces__/graphics/icons/transport/small-electric-pole-upper.png",
					place_result = "small-electric-pole-upper",
					order = "a[energy]-a[small-electric-pole]-[transport]"
				}
			},
			medium = {
				lower = {
					name = "medium-electric-pole-lower",
					icon = "__Surfaces__/graphics/icons/transport/medium-electric-pole-lower.png",
					place_result = "medium-electric-pole-lower",
					order = "a[energy]-b[medium-electric-pole]-[transport]"
				},
				upper = {
					name = "medium-electric-pole-upper",
					icon = "__Surfaces__/graphics/icons/transport/medium-electric-pole-upper.png",
					place_result = "medium-electric-pole-upper",
					order = "a[energy]-b[medium-electric-pole]-[transport]"
				}
			},
			big = {
				lower = {
					name = "big-electric-pole-lower",
					icon = "__Surfaces__/graphics/icons/transport/big-electric-pole-lower.png",
					place_result = "big-electric-pole-lower",
					order = "a[energy]-c[big-electric-pole]-[transport]"
				},
				upper = {
					name = "big-electric-pole-upper",
					icon = "__Surfaces__/graphics/icons/transport/big-electric-pole-upper.png",
					place_result = "big-electric-pole-upper",
					order = "a[energy]-c[big-electric-pole]-[transport]"
				}
			},
			substation = {
				lower = {
					name = "substation-lower",
					icon = "__Surfaces__/graphics/icons/transport/substation-lower.png",
					place_result = "substation-lower",
					order = "a[energy]-d[substation]-[transport]"
				},
				upper = {
					name = "substation-upper",
					icon = "__Surfaces__/graphics/icons/transport/substation-upper.png",
					place_result = "substation-upper",
					order = "a[energy]-d[substation]-[transport]"
				}
			}
		},
		access_shaft = {
			common = {
				flags = {"goes-to-quickbar"},
				stack_size = 1
			},
			sky_entrance = {
				name = "sky-entrance",
				icon = "__Surfaces__/graphics/icons/transport/sky-entrance.png",
				place_result = "sky-entrance"
			},
			sky_exit = {
				name = "sky-exit",
				icon = "__Surfaces__/graphics/icons/transport/sky-exit.png",
				place_result = "sky-exit"
			},
			underground_entrance = {
				name = "underground-entrance",
				icon = "__Surfaces__/graphics/icons/transport/underground-entrance.png",
				place_result = "underground-entrance"
			},
			underground_exit = {
				name = "underground-exit",
				icon = "__Surfaces__/graphics/icons/transport/underground-exit.png",
				place_result = "underground-exit"
			}
		}
	},
	recipe = { -- Recipes
		servo = {
			common = {
				type = "recipe",
				group = "surfaces",
				subgroup = "surfaces-components",
				enabled = true,
				result_count = 1
			},
			simple = {
				name = "simple-servo",
				ingredients = {{"iron-gear-wheel", 1}, {"iron-stick", 2}, {"copper-cable", 2}, {"electronic-circuit", 1}},
				result = "simple-servo"
			},
			basic = {
				name = "basic-servo",
				ingredients = {{"simple-servo", 2}, {"copper-cable", 3}, {"electronic-circuit", 1}},
				result = "basic-servo"
			},
			fluid = {
				name = "fluid-servo",
				ingredients = {{"basic-servo", 2}, {"iron-gear-wheel", 1}, {"pipe", 1}},
				result = "fluid-servo"
			},
			improved = {
				name = "improved-servo",
				ingredients = {{"basic-servo", 2}, {"copper-cable", 3}, {"advanced-circuit", 1}},
				result = "improved-servo"
			},
			advanced = {
				name = "advanced-servo",
				ingredients = {{"advanced-servo", 2}, {"green-wire", 1}, {"red-wire", 1}, {"copper-cable", 1}, {"processing-unit", 1}},
				result = "advanced-servo"
			}
		}
	}
}