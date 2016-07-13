--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.const")
require("script.lib.struct-base")
require("script.lib.util")

--[[
Note: This is NOT a configuration file! Data in this file is used to define prototypes during the loading sequence.
This data is referenced throughout the mod by use of the proto.get_field (during runtime) and proto.get (while loading) functions.
]]
proto = {}

local proto_data = {} -- Prototype data
local sorting_prefix = "a[surfaces]-"

proto_data.item_group = { -- Item Groups
	common = {type = "item-group"},
	surfaces = {name = "surfaces", icon = "__Surfaces__/graphics/item-group/surfaces.png", inventory_order = "surfaces", order = "surfaces"}
}

proto_data.item_subgroup = { -- Item Subgroups
	common = {type = "item-subgroup"},
	surfaces = {
		common = {group = proto_data.item_group.surfaces.name},
		component = {name = "surfaces-component", inventory_order = sorting_prefix .. "b[component]", order = sorting_prefix .. "b[component]"},
		transport = {
			player = {name = "surfaces-transport-player", inventory_order = sorting_prefix .. "a[transport]-a[player]", order = sorting_prefix .. "a[transport]-a[player]"},
			power = {name = "surfaces-transport-power", inventory_order = sorting_prefix .. "a[transport]-b[power]", order = sorting_prefix .. "a[transport]-b[power]"},
			chest = {name = "surfaces-transport-chest", inventory_order = sorting_prefix .. "a[transport]-c[chest]", order = sorting_prefix .. "a[transport]-c[chest]"},
			other = {name = "surfaces-transport-other", inventory_order = sorting_prefix .. "a[transport]-d[other]", order = sorting_prefix .. "a[transport]-d[other]"}
		},
		tile = {name = "surfaces-tile", inventory_order = sorting_prefix .. "c[tile]", order = sorting_prefix .. "c[tile]"}
	}
}

proto_data.corpse = { -- Corpses
	common = {type = "corpse"},
	invisible = {
		name = "invisible-corpse",
		icon = "__base__/graphics/terrain/blank.png",
		flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
		animation = {},
		time_before_removed = 60,
		order = "c[corpse]-a[biter]-b[invisible]"
	}
}

proto_data.item = { -- Items
	common = {type = "item", place_result = "", order = sorting_prefix .. "z", stack_size = 50, group = proto_data.item_group.surfaces.name},
	connector = {
		common = {flags = {"goes-to-main-inventory"}, stack_size = 200, subgroup = proto_data.item_subgroup.surfaces.component.name},
		crude = {name = "crude-connector", icon = "__Surfaces__/graphics/icons/crude-connector.png", order = sorting_prefix .. "b[component]-b[connector]-b[crude]"},
		basic = {name = "basic-connector", icon = "__Surfaces__/graphics/icons/basic-connector.png", order = sorting_prefix .. "b[component]-b[connector]-c[basic]"},
		standard = {name = "standard-connector", icon = "__base__/graphics/icons/electronic-circuit.png", order = sorting_prefix .. "b[component]-b[connector]-d[standard]"},
		improved = {name = "improved-connector", icon = "__base__/graphics/icons/advanced-circuit.png", order = sorting_prefix .. "b[component]-b[connector]-e[improved]"},
		advanced = {name = "advanced-connector", icon = "__base__/graphics/icons/processing-unit.png", order = sorting_prefix .. "b[component]-b[connector]-f[advanced]"}
	},
	servo = {
		common = {flags = {"goes-to-main-inventory"}, stack_size = 50, subgroup = proto_data.item_subgroup.surfaces.component.name},
		crude = {name = "crude-servo", icon = "__base__/graphics/icons/engine-unit.png", order = sorting_prefix .. "b[component]-a[servo]-a[crude]"},
		standard = {name = "standard-servo", icon = "__base__/graphics/icons/engine-unit.png", order = sorting_prefix .. "b[component]-a[servo]-b[standard]"},
		improved = {name = "improved-servo", icon = "__base__/graphics/icons/electric-engine-unit.png", order = sorting_prefix .. "b[component]-a[servo]-c[improved]"}
	},
	electric_pole = {
		common = {flags = {"goes-to-quickbar"}, subgroup = proto_data.item_subgroup.surfaces.transport.power.name},
		small = {
			common = {order = sorting_prefix .. "a[transport]-b[power]-a[small]", fuel_value = "4MJ"},
			lower = {name = "small-electric-pole-lower", icon = "__Surfaces__/graphics/icons/small-electric-pole-lower.png"},
			upper = {name = "small-electric-pole-upper", icon = "__Surfaces__/graphics/icons/small-electric-pole-upper.png"}
		},
		medium = {
			common = {order = sorting_prefix .. "a[transport]-b[power]-b[medium]"},
			lower = {name = "medium-electric-pole-lower", icon = "__Surfaces__/graphics/icons/medium-electric-pole-lower.png"},
			upper = {name = "medium-electric-pole-upper", icon = "__Surfaces__/graphics/icons/medium-electric-pole-upper.png"}
		},
		big = {
			common = {order = sorting_prefix .. "a[transport]-b[power]-c[big]"},
			lower = {name = "big-electric-pole-lower", icon = "__Surfaces__/graphics/icons/big-electric-pole-lower.png"},
			upper = {name = "big-electric-pole-upper", icon = "__Surfaces__/graphics/icons/big-electric-pole-upper.png"}
		},
		substation = {
			common = {order = sorting_prefix .. "a[transport]-b[power]-d[substation]"},
			lower = {name = "substation-lower", icon = "__Surfaces__/graphics/icons/substation-lower.png"},
			upper = {name = "substation-upper", icon = "__Surfaces__/graphics/icons/substation-upper.png"}
		}
	},
	access_shaft = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 1, order = sorting_prefix .. "a[transport]-a[player]", fuel_value = "12MJ", subgroup = proto_data.item_subgroup.surfaces.transport.player.name},
		sky_entrance = {name = "sky-entrance", icon = "__Surfaces__/graphics/icons/sky-entrance.png"},
		sky_exit = {name = "sky-exit", icon = "__Surfaces__/graphics/icons/sky-exit.png"},
		underground_entrance = {name = "underground-entrance", icon = "__Surfaces__/graphics/icons/underground-entrance.png"},
		underground_exit = {name = "underground-exit", icon = "__Surfaces__/graphics/icons/underground-exit.png"}
	},
	rail_transport = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 10, order = sorting_prefix .. "a[transport]-d[other]", subgroup = proto_data.item_subgroup.surfaces.transport.other.name},
		standard = {
			upper = {name = "train-stop-upper", icon = "__Surfaces__/graphics/icons/train-stop-upper.png"},
			lower = {name = "train-stop-lower", icon = "__Surfaces__/graphics/icons/train-stop-lower.png"}
		}
	},
	fluid_transport = {
		common = {flags = {"goes-to-quickbar"}, order = sorting_prefix .. "a[transport]-d[other]", subgroup = proto_data.item_subgroup.surfaces.transport.other.name},
		standard = {
			upper = {name = "fluid-transport-upper", icon = "__Surfaces__/graphics/icons/fluid-transport-upper.png"},
			lower = {name = "fluid-transport-lower", icon = "__Surfaces__/graphics/icons/fluid-transport-lower.png"},
		}
	},
	transport_chest = {
		common = {flags = {"goes-to-quickbar"}, order = sorting_prefix .. "a[transport]-c[chest]", subgroup = proto_data.item_subgroup.surfaces.transport.chest.name},
		wood = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-a[wood]", fuel_value = "6MJ"},
			up = {name = "wooden-transport-chest-up", icon = "__Surfaces__/graphics/icons/wooden-transport-chest-up.png"},
			down = {name = "wooden-transport-chest-down", icon = "__Surfaces__/graphics/icons/wooden-transport-chest-down.png"}
		},
		iron = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-b[iron]"},
			up = {name = "iron-transport-chest-up", icon = "__Surfaces__/graphics/icons/iron-transport-chest-up.png"},
			down = {name = "iron-transport-chest-down", icon = "__Surfaces__/graphics/icons/iron-transport-chest-down.png"}
		},
		steel = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-c[steel]"},
			up = {name = "steel-transport-chest-up", icon = "__Surfaces__/graphics/icons/steel-transport-chest-up.png"},
			down = {name = "steel-transport-chest-down", icon = "__Surfaces__/graphics/icons/steel-transport-chest-down.png"}
		},
		logistic = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-e[logistic]"},
			up = {name = "logistic-transport-chest-up", icon = "__Surfaces__/graphics/icons/logistic-transport-chest-up.png"},
			down = {name = "logistic-transport-chest-down", icon = "__Surfaces__/graphics/icons/logistic-transport-chest-down.png"}
		},
		storehouse = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-f[warehousing]-a[storehouse]"},
			up = {name = "transport-storehouse-up", icon = "__Surfaces__/graphics/icons/transport-storehouse-up.png"},
			down = {name = "transport-storehouse-down", icon = "__Surfaces__/graphics/icons/transport-storehouse-down.png"}
		},
		logistic_storehouse = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-f[warehousing]-b[logistic-storehouse]"},
			up = {name = "logistic-transport-storehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-up.png"},
			down = {name = "logistic-transport-storehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-down.png"}
		},
		warehouse = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-f[warehousing]-c[warehouse]"},
			up = {name = "transport-warehouse-up", icon = "__Surfaces__/graphics/icons/transport-warehouse-up.png"},
			down = {name = "transport-warehouse-down", icon = "__Surfaces__/graphics/icons/transport-warehouse-down.png"}
		},
		logistic_warehouse = {
			common = {order = sorting_prefix .. "a[transport]-c[chest]-f[warehousing]-d[logistic-warehouse]"},
			up = {name = "logistic-transport-warehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-up.png"},
			down = {name = "logistic-transport-warehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-down.png"}
		}
	},
	floor = {
		common = {flags = {"goes-to-main-inventory"}, place_as_tile = {condition_size = 4, condition = {"water-tile"}}, stack_size = 100, order = sorting_prefix .. "c[tile]", subgroup = proto_data.item_subgroup.surfaces.tile.name},
		wood = {name = "wooden-floor", icon = "__Surfaces__/graphics/icons/wooden-floor.png", fuel_value = "8MJ"}
	}
}

proto_data.entity = { -- Entities
	common = {max_health = 100, corpse = "small-remnants", order = sorting_prefix .. "z"},
	underground_wall = {
		name = "underground-wall",
		type = "tree",
		icon = "__Surfaces__/graphics/icons/underground-wall.png",
		flags = {"placeable-neutral"},
		order = sorting_prefix .. "a[underground-wall]",
		collision_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
		selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
		minable = {hardness = 2, mining_time = 2, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 4}}},
		pictures = {struct.Picture("__Surfaces__/graphics/terrain/underground-wall-main.png", "extra-high", 32, 32)},
		resistances = struct.Resistances({{"impact", 80}, {"physical", 5}, {"poison", 100}, {"fire", 100}, {"acid", 95}, {"explosion", 5}}),
		corpse = "invisible-corpse",
		mined_sound = const.sounds.resource_mining,
		vehicle_impact_sound = struct.Sound("__base__/sound/car-stone-impact.ogg", 1.0),
		map_color = util.RGB(60, 52, 36),
	},
	access_shaft = {
		common = {
			type = "simple-entity",
			flags = {},
			collision_mask = {"object-layer", "player-layer"},
			order = sorting_prefix .. "a[access-shaft]",
			collision_box = struct.BoundingBox(-0.4, -0.4, 0.4, 0.4),
			selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
			resistances = struct.Resistances({{"impact", 20}, {"physical", 20}, {"poison", 100}, {"fire", 5}, {"acid", 15}}),
			minable = {hardness = 1, mining_time = 8},
			render_layer = "object",
			map_color = util.RGB(127, 88, 43, 50),
		},
		underground_entrance = {
			name = "underground-entrance",
			icon = "__Surfaces__/graphics/icons/underground-entrance.png",
			pictures = struct.Picture("__Surfaces__/graphics/entity/underground-entrance.png", "extra-high", 96, 96)
		},
		underground_exit = {
			name = "underground-exit",
			icon = "__Surfaces__/graphics/icons/underground-exit.png",
			pictures = struct.Picture("__Surfaces__/graphics/entity/underground-exit.png", "extra-high", 96, 96)
		},
		sky_entrance = {
			name = "sky-entrance",
			icon = "__Surfaces__/graphics/icons/sky-entrance.png",
			pictures = struct.Picture("__Surfaces__/graphics/entity/sky-entrance.png", "extra-high", 96, 96)
		},
		sky_exit = {
			name = "sky-exit",
			icon = "__Surfaces__/graphics/icons/sky-exit.png",
			pictures = struct.Picture("__Surfaces__/graphics/entity/sky-exit.png", "extra-high", 96, 96)
		}
	},
	fluid_transport = {
		standard = {
			common = {
				type = "storage-tank",
				flags = {"placeable-player", "player-creation"},
				max_health = 500,
				collision_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
				selection_box = struct.BoundingBox(-0.5, -0.5, 0.5, 0.5),
				order = sorting_prefix .. "a[fluid-transport]",
				minable = {hardness = 0.2, mining_time = 3},
				fluid_box = {
					base_area = 27.5,
					pipe_covers = const.pictures.pipecovers,
					pipe_connections = {{position = {0, 1}}, {position = {0,-1}}, {position = {1, 0}}, {position = {-1, 0}}}
				},
				window_bounding_box = struct.BoundingBox(0, 0, 0, 0),
				flow_length_in_ticks = 360,
				vehicle_impact_sound = struct.Sound("__base__/sound/car-metal-impact.ogg", 0.65),
				circuit_wire_max_distance = 7.5,
				circuit_wire_connection_points = {},
				circuit_connector_sprites = {}
			},
			upper = {
				name = "fluid-transport-upper",
				icon = "__Surfaces__/graphics/icons/fluid-transport-upper.png",
				pictures = struct.StorageTankPictures(struct.Picture("__Surfaces__/graphics/entity/fluid-transport-upper.png", "extra-high", 32, 32, 1, 1))
			},
			lower = {
				name = "fluid-transport-lower",
				icon = "__Surfaces__/graphics/icons/fluid-transport-lower.png",
				pictures = struct.StorageTankPictures(struct.Picture("__Surfaces__/graphics/entity/fluid-transport-lower.png", "extra-high", 32, 32, 1, 1))
			}
		}
	},
	electric_pole = {
		small = {
			upper = {name = "small-electric-pole-upper", icon = "__Surfaces__/graphics/icons/small-electric-pole-upper.png"},
			lower = {name = "small-electric-pole-lower", icon = "__Surfaces__/graphics/icons/small-electric-pole-lower.png"}
		},
		medium = {
			upper = {name = "medium-electric-pole-upper", icon = "__Surfaces__/graphics/icons/medium-electric-pole-upper.png"},
			lower = {name = "medium-electric-pole-lower", icon = "__Surfaces__/graphics/icons/medium-electric-pole-lower.png"}
		},
		big = {
			upper = {name = "big-electric-pole-upper", icon = "__Surfaces__/graphics/icons/big-electric-pole-upper.png"},
			lower = {name = "big-electric-pole-lower", icon = "__Surfaces__/graphics/icons/big-electric-pole-lower.png"}
		},
		substation = {
			upper = {name = "substation-upper", icon = "__Surfaces__/graphics/icons/substation-upper.png"},
			lower = {name = "substation-lower", icon = "__Surfaces__/graphics/icons/substation-lower.png"}
		}
	},
	rail_transport = {
		standard = {
			upper = {name = "train-stop-upper", icon = "__Surfaces__/graphics/icons/train-stop-upper.png"},
			lower = {name = "train-stop-lower", icon = "__Surfaces__/graphics/icons/train-stop-lower.png"}
		}
	},
	transport_chest = {
		common = {order = sorting_prefix .. "a[transport]-c[chest]"},
		wood = {
			up = {name = "wooden-transport-chest-up", icon = "__Surfaces__/graphics/icons/wooden-transport-chest-up.png"},
			down = {name = "wooden-transport-chest-down", icon = "__Surfaces__/graphics/icons/wooden-transport-chest-down.png"}
		},
		iron = {
			up = {name = "iron-transport-chest-up", icon = "__Surfaces__/graphics/icons/iron-transport-chest-up.png"},
			down = {name = "iron-transport-chest-down", icon = "__Surfaces__/graphics/icons/iron-transport-chest-down.png"}
		},
		steel = {
			up = {name = "steel-transport-chest-up", icon = "__Surfaces__/graphics/icons/steel-transport-chest-up.png"},
			down = {name = "steel-transport-chest-down", icon = "__Surfaces__/graphics/icons/steel-transport-chest-down.png"}
		},
		logistic = {
			up = {name = "logistic-transport-chest-up", icon = "__Surfaces__/graphics/icons/logistic-transport-chest-up.png"},
			down = {name = "logistic-transport-chest-down", icon = "__Surfaces__/graphics/icons/logistic-transport-chest-down.png"}
		},
		storehouse = {
			up = {name = "transport-storehouse-up", icon = "__Surfaces__/graphics/icons/transport-storehouse-up.png"},
			down = {name = "transport-storehouse-down", icon = "__Surfaces__/graphics/icons/transport-storehouse-down.png"}
		},
		logistic_storehouse = {
			up = {name = "logistic-transport-storehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-up.png"},
			down = {name = "logistic-transport-storehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-down.png"}
		},
		warehouse = {
			up = {name = "transport-warehouse-up", icon = "__Surfaces__/graphics/icons/transport-warehouse-up.png"},
			down = {name = "transport-warehouse-down", icon = "__Surfaces__/graphics/icons/transport-warehouse-down.png"}
		},
		logistic_warehouse = {
			up = {name = "logistic-transport-warehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-up.png"},
			down = {name = "logistic-transport-warehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-down.png"}
		},
	},
	receiver_chest = {
		common = {flags = {}},
		wood = {
			lower = {name = "wooden-receiver-chest-lower"},
			upper = {name = "wooden-receiver-chest-upper"}
		},
		iron = {
			lower = {name = "iron-receiver-chest-lower"},
			upper = {name = "iron-receiver-chest-upper"}
		},
		steel = {
			lower = {name = "steel-receiver-chest-lower"},
			upper = {name = "steel-receiver-chest-upper"}
		},
		logistic = {
			lower = {name = "logistic-receiver-chest-lower"},
			upper = {name = "logistic-receiver-chest-upper"}
		},
		storehouse = {
			lower = {name = "receiver-storehouse-lower"},
			upper = {name = "receiver-storehouse-upper"}
		},
		logistic_storehouse = {
			lower = {name = "logistic-receiver-storehouse-lower"},
			upper = {name = "logistic-receiver-storehouse-upper"}
		},
		warehouse = {
			lower = {name = "receiver-warehouse-lower"},
			upper = {name = "receiver-warehouse-upper"}
		},
		logistic_warehouse = {
			lower = {name = "logistic-receiver-warehouse-lower"},
			upper = {name = "logistic-receiver-warehouse-upper"}
		}
	}
}

proto_data.technology = { -- Technology
	
}

proto_data.tile = { -- Tiles
	common = {type = "tile", decorative_removal_probability = 1, collision_mask = {"ground-tile"}, needs_correction = false, ageing = 0, subgroup = proto_data.item_group.surfaces.name},
	underground_dirt = {
		name = "underground-dirt",
		icon = "__Surfaces__/graphics/icons/underground-dirt.png",
		layer = 59,
		variants = {
			main = {struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 4, 1)},
			inner_corner = struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 0),
			outer_corner = struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 0),
			side = struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 0),
			u_transition = struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 0),
			o_transition = struct.Variant("__Surfaces__/graphics/terrain/underground-dirt-main.png", 0)
		},
		walking_speed_modifier = 0.8,
		map_color = util.RGB(107, 44, 4)
	},
	sky_void = {
		name = "sky-void",
		icon = "__Surfaces__/graphics/icons/sky-void.png",
		layer = 45,
		collision_mask = {"resource-layer", "floor-layer", "item-layer", "object-layer", "player-layer", "doodad-layer"},
		variants = {
			main = {struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 4, 1)},
			inner_corner = struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 0),
			outer_corner = struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 0),
			side = struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 0),
			u_transition = struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 0),
			o_transition = struct.Variant("__Surfaces__/graphics/terrain/sky-void-main.png", 0)
		},
		map_color = util.RGB(145, 212, 252)
	},
	floor = {
		common = {minable = {hardness = 0.2, mining_time = 0.5}, walking_speed_modifier = 1, subgroup = proto_data.item_subgroup.surfaces.tile.name},
		wood = {
			name = "wooden-floor",
			layer = 59,
			variants = {
				main = {struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-main.png", 1, 1)},
				inner_corner = struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-inner-corner.png", 1),
				outer_corner = struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-outer-corner.png", 1),
				side = struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-side.png", 1),
				u_transition = struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-u-transition.png", 1),
				o_transition = struct.Variant("__Surfaces__/graphics/terrain/wooden-floor-o-transition.png", 1)
			},
			map_color = util.RGB(153, 123, 86)
		}
	}
}
--[[
References to data from other mods
]]
proto_data.warehousing = { -- Warehousing mod
	entity = { -- Entities
		active_provider_warehouse = {name = "warehouse-active-provider"},
		passive_provider_warehouse = {name = "warehouse-passive-provider"},
		storage_warehouse = {name = "warehouse-storage"},
		requester_warehouse = {name = "warehouse-requester"},
		warehouse = {name = "warehouse-basic"},
		active_provider_storehouse = {name = "storehouse-active-provider"},
		passive_provider_storehouse = {name = "storehouse-passive-provider"},
		storage_storehouse = {name = "storehouse-storage"},
		requester_storehouse = {name = "storehouse-requester"},
		storehouse = {name = "storehouse-basic"}
	},
	item = { -- Items
		active_provider_warehouse = {name = "warehouse-active-provider"},
		passive_provider_warehouse = {name = "warehouse-passive-provider"},
		storage_warehouse = {name = "warehouse-storage"},
		requester_warehouse = {name = "warehouse-requester"},
		warehouse = {name = "warehouse-basic"},
		active_provider_storehouse = {name = "storehouse-active-provider"},
		passive_provider_storehouse = {name = "storehouse-passive-provider"},
		storage_storehouse = {name = "storehouse-storage"},
		requester_storehouse = {name = "storehouse-requester"},
		storehouse = {name = "storehouse-basic"}
	},
	technology = { -- Technology
		logistics = {name = "warehouse-logistics-research"},
		warehouse = {name = "warehouse-research"}
	}
}

proto_data.recipe = { -- Recipes
	common = {type = "recipe", result_count = 1, enabled = true},
	connector = {
		common = {energy_required = 1, subgroup = proto_data.item_subgroup.surfaces.component.name},
		crude = {name = "crude-connector", ingredients = {{proto_data.item.servo.crude.name, 1}, {"copper-cable", 2}, {"electronic-circuit", 1}}},
		basic = {name = "basic-connector", ingredients = {{proto_data.item.connector.crude.name, 1}, {proto_data.item.servo.crude.name, 1}, {"copper-cable", 2}, {"electronic-circuit", 2}}},
		standard = {name = "standard-connector", ingredients = {{proto_data.item.connector.basic.name, 1}, {proto_data.item.servo.standard.name, 1}, {"copper-cable", 6}, {"electronic-circuit", 4}}},
		improved = {name = "improved-connector", ingredients = {{proto_data.item.connector.standard.name, 1}, {proto_data.item.servo.standard.name, 1}, {"advanced-circuit", 2}}},
		advanced = {name = "advanced-connector", ingredients = {{proto_data.item.connector.improved.name, 1}, {proto_data.item.servo.improved.name, 2}, {"plastic-bar", 6}, {"advanced-circuit", 4}}}
	},
	servo = {
		common = {subgroup = proto_data.item_subgroup.surfaces.component.name},
		crude = {name = "crude-servo", ingredients = {{"copper-plate", 4}, {"iron-gear-wheel", 2}, {"iron-stick", 2}}, energy_required = 2},
		standard = {name = "standard-servo", ingredients = {{proto_data.item.servo.crude.name, 1}, {"iron-gear-wheel", 2}, {"steel-plate", 2}}, energy_required = 4},
		improved = {name = "improved-servo", category = "crafting-with-fluid", ingredients = {{proto_data.item.servo.standard.name, 1}, {type = "fluid", name = "lubricant", amount = 4}, {"steel-plate", 4}}, energy_required = 8}
	},
	access_shaft = {
		common = {ingredients = {{"raw-wood", 20}, {"steel-plate", 8}}, energy_required = 15, subgroup = proto_data.item_subgroup.surfaces.transport.player.name},
		sky_entrance = {name = "sky-entrance"},
		sky_exit = {name = "sky-exit"},
		underground_entrance = {name = "underground-entrance"},
		underground_exit = {name = "underground-exit"}
	},
	electric_pole = {
		common = {subgroup = proto_data.item_subgroup.surfaces.transport.power.name},
		big = {
			common = {ingredients = {{"big-electric-pole", 2}, {proto_data.item.connector.standard.name, 2}}},
			upper = {name = "big-electric-pole-upper"},
			lower = {name = "big-electric-pole-lower"}
		},
		medium = {
			common = {ingredients = {{"medium-electric-pole", 2}, {proto_data.item.connector.basic.name, 2}}},
			upper = {name = "medium-electric-pole-upper"},
			lower = {name = "medium-electric-pole-lower"}
		},
		small = {
			common = {ingredients = {{"small-electric-pole", 2}, {proto_data.item.connector.crude.name, 2}}},
			upper = {name = "small-electric-pole-upper"},
			lower = {name = "small-electric-pole-lower"}
		},
		substation = {
			common = {ingredients = {{"substation", 2}, {proto_data.item.connector.improved.name, 2}}},
			upper = {name = "substation-upper"},
			lower = {name = "substation-lower"}
		}
	},
	fluid_transport = {
		common = {subgroup = proto_data.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{"storage-tank", 2}, {proto_data.item.connector.standard.name, 2}}},
			upper = {name = "fluid-transport-upper"},
			lower = {name = "fluid-transport-lower"}
		}
	},
	transport_chest = {
		common = {subgroup = proto_data.item_subgroup.surfaces.transport.chest.name},
		wood = {
			common = {ingredients = {{"wooden-chest", 2}, {proto_data.item.connector.crude.name, 1}}},
			up = {name = "wooden-transport-chest-up"},
			down = {name = "wooden-transport-chest-down"}
		},
		iron = {
			common = {ingredients = {{"iron-chest", 2}, {proto_data.item.connector.basic.name, 1}}},
			up = {name = "iron-transport-chest-up"},
			down = {name = "iron-transport-chest-down"}
		},
		steel = {
			common = {ingredients = {{"steel-chest", 2}, {proto_data.item.connector.standard.name, 1}}},
			up = {name = "steel-transport-chest-up"},
			down = {name = "steel-transport-chest-down"}
		},
		logistic = {
			common = {ingredients = {{"logistic-chest-requester", 1}, {"logistic-chest-passive-provider", 1}, {proto_data.item.connector.advanced.name, 1}}},
			up = {name = "logistic-transport-chest-up"},
			down = {name = "logistic-transport-chest-down"}
		},
		storehouse = {
			common = {ingredients = {{proto_data.warehousing.item.storehouse.name, 2}, {proto_data.item.connector.standard.name, 2}}},
			up = {name = "transport-storehouse-up", icon = "__Surfaces__/graphics/icons/transport-storehouse-up.png"},
			down = {name = "transport-storehouse-down", icon = "__Surfaces__/graphics/icons/transport-storehouse-down.png"}
		},
		logistic_storehouse = {
			common = {ingredients = {{proto_data.warehousing.item.requester_storehouse.name, 1}, {proto_data.warehousing.item.passive_provider_storehouse.name, 1}, {proto_data.item.connector.advanced.name, 3}}},
			up = {name = "logistic-transport-storehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-up.png"},
			down = {name = "logistic-transport-storehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-storehouse-down.png"}
		},
		warehouse = {
			common = {ingredients = {{proto_data.warehousing.item.warehouse.name, 2}, {proto_data.item.connector.improved.name, 2}}},
			up = {name = "transport-warehouse-up", icon = "__Surfaces__/graphics/icons/transport-warehouse-up.png"},
			down = {name = "transport-warehouse-down", icon = "__Surfaces__/graphics/icons/transport-warehouse-down.png"}
		},
		logistic_warehouse = {
			common = {ingredients = {{proto_data.warehousing.item.requester_warehouse.name, 1}, {proto_data.warehousing.item.passive_provider_warehouse.name, 1}, {proto_data.item.connector.advanced.name, 3}}},
			up = {name = "logistic-transport-warehouse-up", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-up.png"},
			down = {name = "logistic-transport-warehouse-down", icon = "__Surfaces__/graphics/icons/logistic-transport-warehouse-down.png"}
		},
	},
	rail_transport = {
		common = {subgroup = proto_data.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{"train-stop", 2}, {proto_data.item.connector.advanced.name, 2}}},
			upper = {name = "train-stop-upper"},
			lower = {name = "train-stop-lower"}
		}
	},
	floor = {
		common = {subgroup = proto_data.item_subgroup.surfaces.tile.name},
		wood = {name = "wooden-floor", ingredients = {{"wood", 5}}}
	}
}

function proto.get(_path_to_field, _field, _common, _inherit)
	if game == nil then -- Only allow this function to be used before game is loaded
		local _data = {}
		local _path = proto_data
		if type(_inherit) == "table" then
			_data = table.deepcopy(_inherit)
		end
		if type(_common) == "boolean" and _common == true and type(_path_to_field) == "table" then
			for k, v in pairs(_path_to_field) do
				v = string.lower(v)
				if _path[v] then
					_path = _path[v]
					if type(_path["common"]) == "table" then
						for k, v in pairs(_path["common"]) do
							_data[k] = table.deepcopy(v)
						end
					end
				else
					local _path_string = "proto_data"
					for k, v in pairs(_path_to_field) do
						_path_string = _path_string .. "." .. tostring(v)
					end
					_path_string = _path_string .. "." .. _field
					error("prototype data at " .. _path_string .. " does not exist, unable to load.")
					return nil
				end
			end
		end
		_field = string.lower(_field)
		if type(_path[_field]) == "table" then
			for k, v in pairs(_path[_field]) do
				_data[k] = table.deepcopy(v)
			end
		end
		return _data
	end
end

function proto.get_field(_path_to_field, _field)
	local _path = proto_data
	if type(_path_to_field) == "table" then
		for k, v in pairs(_path_to_field) do
			v = string.lower(v)
			if _path[v] then
				_path = _path[v]
			else
				return nil
			end
		end
	end
	_field = string.lower(_field)
	if _path[_field] then
		return table.deepcopy(_path[_field])
	end
end