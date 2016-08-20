--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016  Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util")
local struct = require("script.lib.struct-base")

--[[
Note: This is NOT a configuration file!
This data is referenced by many modules (for data loading purposes and during runtime).
]]

--[[--
Prototypes module, stores most if not all of the prototype data and is used during data loading phase to construct prototype defintions.
In addition, prototype information can be obtained during runtime with the <code>proto.get\_field(\_path\_to\_field, \_field)</code> function.

@module proto
]]
proto = {}

local _proto = {} -- Prototype data
local _data = {} -- stores call functions for prototype data access
local _ref = {} -- stores reference data for external prototypes (names of items/entities in data.raw)


--[[
Ordering strings
]]
local _order = {string = "a[surfaces]"}
_order.component = {string = _order.string .. "-b[component]"}
_order.component.connector = {string = _order.component.string .. "-b[connector]"}
_order.component.servo = {string = _order.component.string .. "-a[servo]"}
_order.tile = {string = _order.string .. "-c[tile]"}
_order.transport = {string = _order.string .. "-a[transport]"}
_order.transport.chest = {string = _order.transport.string .. "-c[chest]"}
_order.transport.energy = {string = _order.transport.string .. "-b[energy]"}
_order.transport.fluid = {string = _order.transport.string .. "-d[fluid]"}
_order.transport.other = {string = _order.transport.string .. "-f[other]"}
_order.transport.player = {string = _order.transport.string .. "-a[player]"}
_order.transport.rail = {string = _order.transport.string .. "-e[rail]"}


--[[
GFX variables
]]
local _gfx = {filetype = ".png", path = "__Surfaces__/graphics/"}
_gfx.icon = {path = _gfx.path .. "icons/"}
_gfx.group = {path = _gfx.path .. "item-group/"}
_gfx.terrain = {path = _gfx.path .. "terrain/"}
_gfx.entity = {path = _gfx.path .. "entity/"}

--[[
Reference data
]]
_ref.base = {} -- Factorio base game
_ref.base.entity = {accumulator = "accumulator", chest_iron = "iron-chest", chest_passive_provider = "logistic-chest-passive-provider", 
	chest_requester = "logistic-chest-requester", chest_steel = "steel-chest", chest_wood = "wooden-chest", storage_tank = "storage-tank", train_stop = "train-stop"}
_ref.base.item = {accumulator = _ref.base.entity.accumulator, chest_iron = _ref.base.entity.chest_iron,
	chest_passive_provider = _ref.base.entity.chest_passive_provider, chest_requester = _ref.base.entity.chest_requester, chest_steel = _ref.base.entity.chest_steel,
	chest_wood = _ref.base.entity.chest_wood, circuit_advanced = "advanced-circuit", circuit_electronic = "electronic-circuit", copper = "copper-plate",
	copper_cable = "copper-cable", iron = "iron-plate", iron_gear = "iron-gear-wheel", iron_stick = "iron-stick", steel = "steel-plate",
	storage_tank = _ref.base.entity.storage_tank, train_stop = _ref.base.entity.train_stop, wood = "wood", wood_raw = "raw-wood", wire_red = "red-wire",
	wire_green = "green-wire"}
_ref.base.fluid = {lubricant = "lubricant", oil = "crude-oil", oil_heavy = "heavy-oil", oil_light = "light-oil", water = "water"}
_ref.boblogistics = {} -- Bob's Logistics mod
_ref.boblogistics.item = {passive_provider_chest_2 = "logistic-chest-passive-provider-2", active_provider_chest_2 = "logistic-chest-active-provider-2", 
	requester_chest_2 = "logistic-chest-requester-2", storage_chest_2 = "logistic-chest-storage-2", storage_tank_2 = "storage-tank-2",
	storage_tank_3 = "storage-tank-3", storage_tank_4 = "storage-tank-4"}
_ref.bobpower = {} -- Bob's Power mod 
_ref.bobpower.item = {accumulator_2 = "large-accumulator", accumulator_3 = "large-accumulator-2", accumulator_4 = "large-accumulator-3"}
_ref.warehousing = {} -- Warehousing mod
_ref.warehousing.item = {active_provider_warehouse = "warehouse-active-provider", passive_provider_warehouse = "warehouse-passive-provider", 
	storage_warehouse = "warehouse-storage", requester_warehouse = "warehouse-requester", warehouse = "warehouse-basic", 
	active_provider_storehouse = "storehouse-active-provider", passive_provider_storehouse = "storehouse-passive-provider", 
	storage_storehouse = "storehouse-storage", requester_storehouse = "storehouse-requester", storehouse = "storehouse-basic"}
_ref.warehousing.technology = {logistics = "warehouse-logistics-research", warehouse = "warehouse-research"}
_ref.warehousing.entity = _ref.warehousing.item -- entity names and item names are identical, no point defining duplicate data
_ref.bobpower.entity = _ref.bobpower.item -- entity names and item names are identical, no point defining duplicate data
_ref.boblogistics.entity = _ref.boblogistics.item -- entity names and item names are identical, no point defining duplicate data

--[[
Prototype data
]]
_proto.item_group = { -- Item Groups
	common = {type = "item-group"},
	surfaces = {name = "surfaces", icon = _gfx.group.path .. "surfaces" .. _gfx.filetype, inventory_order = "surfaces", order = "surfaces"}
}

_proto.item_subgroup = { -- Item Subgroups
	common = {type = "item-subgroup"},
	surfaces = {
		common = {group = _proto.item_group.surfaces.name},
		component = {name = "surfaces-component", inventory_order = _order.component.string, order = _order.component.string},
		transport = {
			energy = {name = "surfaces-transport-energy", inventory_order = _order.transport.energy.string, order = _order.transport.energy.string},
			chest = {name = "surfaces-transport-chest", inventory_order = _order.transport.chest.string, order = _order.transport.chest.string},
			fluid = {name = "surfaces-transport-fluid", inventory_order = _order.transport.fluid.string, order = _order.transport.fluid.string},
			other = {name = "surfaces-transport-other", inventory_order = _order.transport.other.string, order = _order.transport.other.string},
			player = {name = "surfaces-transport-player", inventory_order = _order.transport.player.string, order = _order.transport.player.string},
			rail = {name = "surfaces-transport-rail", inventory_order = _order.transport.rail.string, order = _order.transport.rail.string}
		},
		tile = {name = "surfaces-tile", inventory_order = _order.tile.string, order = _order.tile.string}
	}
}

_proto.corpse = { -- Corpses
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

_proto.item = { -- Items
	common = {type = "item", place_result = "", order = _order.string .. "z", stack_size = 50, group = _proto.item_group.surfaces.name},
	connector = {
		common = {flags = {"goes-to-main-inventory"}, stack_size = 200, subgroup = _proto.item_subgroup.surfaces.component.name,
			order = _order.component.connector.string .. "-z"},
		crude = {name = "crude-connector", icon = _gfx.icon.path .. "crude-connector" .. _gfx.filetype, order = _order.component.connector.string .. "-a[crude]"},
		basic = {name = "basic-connector", icon = _gfx.icon.path .. "basic-connector" .. _gfx.filetype, order = _order.component.connector.string .. "-b[basic]"},
		standard = {name = "standard-connector", icon = "__base__/graphics/icons/electronic-circuit.png", order = _order.component.connector.string .. "-c[standard]"},
		improved = {name = "improved-connector", icon = "__base__/graphics/icons/advanced-circuit.png", order = _order.component.connector.string .. "-d[improved]"},
		advanced = {name = "advanced-connector", icon = "__base__/graphics/icons/processing-unit.png", order = _order.component.connector.string .. "-e[advanced]"}
	},
	servo = {
		common = {flags = {"goes-to-main-inventory"}, subgroup = _proto.item_subgroup.surfaces.component.name,
			order = _order.component.servo.string .. "-z"},
		crude = {name = "crude-servo", icon = "__base__/graphics/icons/engine-unit.png", order = _order.component.servo.string .. "-a[crude]"},
		standard = {name = "standard-servo", icon = "__base__/graphics/icons/engine-unit.png", order = _order.component.servo.string .. "-b[standard]"},
		improved = {name = "improved-servo", icon = "__base__/graphics/icons/electric-engine-unit.png", order = _order.component.servo.string .. "-c[improved]"}
	},
	energy_transport = {
		common = {flags = {"goes-to-quickbar"}, subgroup = _proto.item_subgroup.surfaces.transport.energy.name, order = _order.transport.energy.string .. "-z",
			override = true},
		standard = {
			common = {order = _order.transport.energy.string .. "-a[standard]-a"},
			lower = {name = "energy-transport-lower", icon = _gfx.icon.path .. "energy-transport-lower" .. _gfx.filetype},
			upper = {name = "energy-transport-upper", icon = _gfx.icon.path .. "energy-transport-upper" .. _gfx.filetype}
		},
		standard_2 = {
			common = {order = _order.transport.energy.string .. "-a[standard]-b"},
			lower = {name = "energy-transport-2-lower", icon = _gfx.icon.path .. "energy-transport-lower" .. _gfx.filetype},
			upper = {name = "energy-transport-2-upper", icon = _gfx.icon.path .. "energy-transport-upper" .. _gfx.filetype}
		},
		standard_3 = {
			common = {order = _order.transport.energy.string .. "-a[standard]-c"},
			lower = {name = "energy-transport-3-lower", icon = _gfx.icon.path .. "energy-transport-lower" .. _gfx.filetype},
			upper = {name = "energy-transport-3-upper", icon = _gfx.icon.path .. "energy-transport-upper" .. _gfx.filetype}
		},
		standard_4 = {
			common = {order = _order.transport.energy.string .. "-a[standard]-d"},
			lower = {name = "energy-transport-4-lower", icon = _gfx.icon.path .. "energy-transport-lower" .. _gfx.filetype},
			upper = {name = "energy-transport-4-upper", icon = _gfx.icon.path .. "energy-transport-upper" .. _gfx.filetype}
		},
		advanced = {
			common = {order = _order.transport.energy.string .. "-b[advanced]-a"},
			lower = {name = "adv-energy-transport-lower", icon = _gfx.icon.path .. "adv-energy-transport-lower" .. _gfx.filetype},
			upper = {name = "adv-energy-transport-upper", icon = _gfx.icon.path .. "adv-energy-transport-upper" .. _gfx.filetype}
		}
	},
	access_shaft = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 1, order = _order.transport.player.string, fuel_value = "12MJ",
			subgroup = _proto.item_subgroup.surfaces.transport.player.name, override = true},
		sky_entrance = {name = "platform-access-shaft-lower", icon = _gfx.icon.path .. "platform-access-shaft-lower" .. _gfx.filetype},
		sky_exit = {name = "platform-access-shaft-upper", icon = _gfx.icon.path .. "platform-access-shaft-upper" .. _gfx.filetype},
		underground_entrance = {name = "cavern-access-shaft-upper", icon = _gfx.icon.path .. "cavern-access-shaft-upper" .. _gfx.filetype},
		underground_exit = {name = "cavern-access-shaft-lower", icon = _gfx.icon.path .. "cavern-access-shaft-lower" .. _gfx.filetype}
	},
	rail_transport = {
		common = {flags = {"goes-to-quickbar"}, stack_size = 10, order = _order.transport.rail.string .. "-z",
			subgroup = _proto.item_subgroup.surfaces.transport.rail.name, override = true},
		standard = {
			upper = {name = "train-stop-upper", icon = _gfx.icon.path .. "train-stop-upper" .. _gfx.filetype},
			lower = {name = "train-stop-lower", icon = _gfx.icon.path .. "train-stop-lower" .. _gfx.filetype}
		}
	},
	fluid_transport = {
		common = {flags = {"goes-to-quickbar"}, order = _order.transport.fluid.string .. "-z", 
			subgroup = _proto.item_subgroup.surfaces.transport.fluid.name, override = true},
		standard = {
			common = {order = _order.transport.fluid.string .. "-a[standard]-a"},
			upper = {name = "fluid-transport-upper", icon = _gfx.icon.path .. "fluid-transport-upper" .. _gfx.filetype},
			lower = {name = "fluid-transport-lower", icon = _gfx.icon.path .. "fluid-transport-lower" .. _gfx.filetype}
		},
		standard_2 = {
			common = {order = _order.transport.fluid.string .. "-a[standard]-b"},
			upper = {name = "fluid-transport-2-upper", icon = _gfx.icon.path .. "fluid-transport-upper" .. _gfx.filetype},
			lower = {name = "fluid-transport-2-lower", icon = _gfx.icon.path .. "fluid-transport-lower" .. _gfx.filetype}		
		},
		standard_3 = {
			common = {order = _order.transport.fluid.string .. "-a[standard]-c"},
			upper = {name = "fluid-transport-3-upper", icon = _gfx.icon.path .. "fluid-transport-upper" .. _gfx.filetype},
			lower = {name = "fluid-transport-3-lower", icon = _gfx.icon.path .. "fluid-transport-lower" .. _gfx.filetype}		
		},
		standard_4 = {
			common = {order = _order.transport.fluid.string .. "-a[standard]-d"},
			upper = {name = "fluid-transport-4-upper", icon = _gfx.icon.path .. "fluid-transport-upper" .. _gfx.filetype},
			lower = {name = "fluid-transport-4-lower", icon = _gfx.icon.path .. "fluid-transport-lower" .. _gfx.filetype}		
		}
	},
	transport_chest = {
		common = {flags = {"goes-to-quickbar"}, order = _order.transport.chest.string .. "-z", subgroup = _proto.item_subgroup.surfaces.transport.chest.name,
			override = true},
		wood = {
			common = {order = _order.transport.chest.string .. "-a[wood]", fuel_value = "6MJ"},
			up = {name = "wooden-transport-chest-up", icon = _gfx.icon.path .. "wooden-transport-chest-up" .. _gfx.filetype},
			down = {name = "wooden-transport-chest-down", icon = _gfx.icon.path .. "wooden-transport-chest-down" .. _gfx.filetype}
		},
		iron = {
			common = {order = _order.transport.chest.string .. "-b[iron]"},
			up = {name = "iron-transport-chest-up", icon = _gfx.icon.path .. "iron-transport-chest-up" .. _gfx.filetype},
			down = {name = "iron-transport-chest-down", icon = _gfx.icon.path .. "iron-transport-chest-down" .. _gfx.filetype}
		},
		steel = {
			common = {order = _order.transport.chest.string .. "-c[steel]"},
			up = {name = "steel-transport-chest-up", icon = _gfx.icon.path .. "steel-transport-chest-up" .. _gfx.filetype},
			down = {name = "steel-transport-chest-down", icon = _gfx.icon.path .. "steel-transport-chest-down" .. _gfx.filetype}
		},
		logistic = {
			common = {order = _order.transport.chest.string .. "-d[logistic]-a"},
			up = {name = "logistic-transport-chest-up", icon = _gfx.icon.path .. "logistic-transport-chest-up" .. _gfx.filetype},
			down = {name = "logistic-transport-chest-down", icon = _gfx.icon.path .. "logistic-transport-chest-down" .. _gfx.filetype}
		},
		logistic_2 = {
			common = {order = _order.transport.chest.string .. "-d[logistic]-b"},
			up = {name = "logistic-transport-chest-2-up", icon = _gfx.icon.path .. "logistic-transport-chest-2-up" .. _gfx.filetype},
			down = {name = "logistic-transport-chest-2-down", icon = _gfx.icon.path .. "logistic-transport-chest-2-down" .. _gfx.filetype}
		},
		storehouse = {
			common = {order = _order.transport.chest.string .. "-e[warehousing]-a[storehouse]-a"},
			up = {name = "transport-storehouse-up", icon = _gfx.icon.path .. "transport-storehouse-up" .. _gfx.filetype},
			down = {name = "transport-storehouse-down", icon = _gfx.icon.path .. "transport-storehouse-down" .. _gfx.filetype}
		},
		logistic_storehouse = {
			common = {order = _order.transport.chest.string .. "-e[warehousing]-a[storehouse]-b"},
			up = {name = "logistic-transport-storehouse-up", icon = _gfx.icon.path .. "logistic-transport-storehouse-up" .. _gfx.filetype},
			down = {name = "logistic-transport-storehouse-down", icon = _gfx.icon.path .. "logistic-transport-storehouse-down" .. _gfx.filetype}
		},
		warehouse = {
			common = {order = _order.transport.chest.string .. "-e[warehousing]-b[warehouse]-a"},
			up = {name = "transport-warehouse-up", icon = _gfx.icon.path .. "transport-warehouse-up" .. _gfx.filetype},
			down = {name = "transport-warehouse-down", icon = _gfx.icon.path .. "transport-warehouse-down" .. _gfx.filetype}
		},
		logistic_warehouse = {
			common = {order = _order.transport.chest.string .. "-e[warehousing]-b[warehouse]-b"},
			up = {name = "logistic-transport-warehouse-up", icon = _gfx.icon.path .. "logistic-transport-warehouse-up" .. _gfx.filetype},
			down = {name = "logistic-transport-warehouse-down", icon = _gfx.icon.path .. "logistic-transport-warehouse-down" .. _gfx.filetype}
		}
	},
	floor = {
		common = {flags = {"goes-to-main-inventory"}, place_as_tile = {condition_size = 4, condition = {"water-tile"}}, stack_size = 100,
			order = _order.tile.string, subgroup = _proto.item_subgroup.surfaces.tile.name, override = true},
		wood = {name = "wooden-floor", icon = _gfx.icon.path .. "wooden-floor" .. _gfx.filetype, fuel_value = "8MJ"}
	}
}

_proto.entity = {
	common = {max_health = 100, corpse = "small-remnants", order = _order.string .. "z"},
	underground_wall = {
		name = "underground-wall",
		type = "tree",
		max_health = 50,
		icon = _gfx.icon.path .. "underground-wall" .. _gfx.filetype,
		flags = {"placeable-neutral"},
		order = _order.string .. "a[underground-wall]",
		collision_box = {{-0.499, -0.499}, {0.499, 0.499}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		minable = {hardness = 2, mining_time = 2, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 4}}},
		pictures = {
			struct.Picture(_gfx.terrain.path .. "underground-wall-main-1" .. _gfx.filetype, "medium", 32, 32),
			struct.Picture(_gfx.terrain.path .. "underground-wall-main-2" .. _gfx.filetype, "medium", 32, 32),
			struct.Picture(_gfx.terrain.path .. "underground-wall-main-3" .. _gfx.filetype, "medium", 32, 32),
			struct.Picture(_gfx.terrain.path .. "underground-wall-main-4" .. _gfx.filetype, "medium", 32, 32)
		},
		mined_sound = struct.Sound("__base__/sound/deconstruct-bricks.ogg"),
		resistances = struct.Resistances({{"impact", 80, 5}, {"fire", 100}, {"explosion", 15, 2}}),
		corpse = _proto.corpse.invisible.name,
		vehicle_impact_sound = struct.Sound("__base__/sound/car-stone-impact.ogg", 1.0),
		map_color = util.RGB(60, 51, 36)
	},
	access_shaft = {
		common = {
			type = "car", 
			flags = {},
			collision_mask = {"object-layer", "player-layer"},
			order = _proto.item.access_shaft.common.order,
			subgroup = _proto.item.access_shaft.common.subgroup,
			collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			resistances = struct.Resistances({{"impact", 20, 2}, {"fire", 10, 3}}),
			minable = {hardness = 1, mining_time = 8},
			render_layer = "object",
			map_color = util.RGB(127, 88, 43, 50),
			acceleration_per_energy = 1,
			breaking_speed = 0,
			energy_per_hit_point = 1,
			effectivity = 0.01,
			burner = {effectivity = 0.01, fuel_inventory_size = 1},
			braking_power = "1W",
			consumption = "0W",
			friction = 0,
			rotation_speed = 0,
			weight = 100,
			inventory_size = 0,
			animation = {layers = {{width = 96, height = 96, frame_count = 1, direction_count = 1, animation_speed = 0, max_advance = 0}}},
			override = true,
		},
		underground_entrance = {name = _proto.item.access_shaft.underground_entrance.name, icon = _proto.item.access_shaft.underground_entrance.icon,
			pictures = struct.Picture(_gfx.entity.path .. _proto.item.access_shaft.underground_entrance.name .. _gfx.filetype, "medium", 96, 96),
			animation = {layers = {{filename = _gfx.entity.path .. _proto.item.access_shaft.underground_entrance.name .. _gfx.filetype}}}
		},
		underground_exit = {name = _proto.item.access_shaft.underground_exit.name, icon = _proto.item.access_shaft.underground_exit.icon,
			pictures = struct.Picture(_gfx.entity.path .. _proto.item.access_shaft.underground_exit.name .. _gfx.filetype, "medium", 96, 96),
			animation = {layers = {{filename = _gfx.entity.path .. _proto.item.access_shaft.underground_exit.name .. _gfx.filetype}}}
		},
		sky_entrance = {name = _proto.item.access_shaft.sky_entrance.name, icon = _proto.item.access_shaft.sky_entrance.icon,
			pictures = struct.Picture(_gfx.entity.path .. _proto.item.access_shaft.sky_entrance.name .. _gfx.filetype, "medium", 96, 96),
			animation = {layers = {{filename = _gfx.entity.path .. _proto.item.access_shaft.sky_entrance.name .. _gfx.filetype}}}
		},
		sky_exit = {name = _proto.item.access_shaft.sky_exit.name, icon = _proto.item.access_shaft.sky_exit.icon,
			pictures = struct.Picture(_gfx.entity.path .. _proto.item.access_shaft.sky_exit.name .. _gfx.filetype, "medium", 96, 96),
			animation = {layers = {{filename = _gfx.entity.path .. _proto.item.access_shaft.sky_exit.name .. _gfx.filetype}}}
		}
	},
	energy_transport = {
		common = {order = _proto.item.energy_transport.common.order, subgroup = _proto.item.energy_transport.common.subgroup, override = true},
		standard = {
			common = {order = _proto.item.energy_transport.standard.common.order, energy_source = {buffer_capacity = "5MJ", input_flow_limit = "2.5MW",
				output_flow_limit = "2.5MW"}},
			lower = {name = _proto.item.energy_transport.standard.lower.name, icon = _proto.item.energy_transport.standard.lower.icon},
			upper = {name = _proto.item.energy_transport.standard.upper.name, icon = _proto.item.energy_transport.standard.upper.icon}
		},
		standard_2 = {
			common = {order = _proto.item.energy_transport.standard_2.common.order, energy_source = {buffer_capacity = "10MJ", input_flow_limit = "5MW",
				output_flow_limit = "5MW"}},
			lower = {name = _proto.item.energy_transport.standard_2.lower.name, icon = _proto.item.energy_transport.standard_2.lower.icon},
			upper = {name = _proto.item.energy_transport.standard_2.upper.name, icon = _proto.item.energy_transport.standard_2.upper.icon}
		},
		standard_3 = {
			common = {order = _proto.item.energy_transport.standard_3.common.order, energy_source = {buffer_capacity = "15MJ", input_flow_limit = "7.5MW",
				output_flow_limit = "7.5MW"}},
			lower = {name = _proto.item.energy_transport.standard_3.lower.name, icon = _proto.item.energy_transport.standard_3.lower.icon},
			upper = {name = _proto.item.energy_transport.standard_3.upper.name, icon = _proto.item.energy_transport.standard_3.upper.icon}
		},
		standard_4 = {
			common = {order = _proto.item.energy_transport.standard_4.common.order, energy_source = {buffer_capacity = "22.5MJ", input_flow_limit = "11.25MW",
				output_flow_limit = "11.25MW"}},
			lower = {name = _proto.item.energy_transport.standard_4.lower.name, icon = _proto.item.energy_transport.standard_4.lower.icon},
			upper = {name = _proto.item.energy_transport.standard_4.upper.name, icon = _proto.item.energy_transport.standard_4.upper.icon}
		},
		advanced = {
			common = {order = _proto.item.energy_transport.advanced.common.order, energy_source = {buffer_capacity = "30MJ", input_flow_limit = "15MW",
				output_flow_limit = "15MW"}},
			lower = {name = _proto.item.energy_transport.advanced.lower.name, icon = _proto.item.energy_transport.advanced.lower.icon},
			upper = {name = _proto.item.energy_transport.advanced.upper.name, icon = _proto.item.energy_transport.advanced.upper.icon}
		}
	},
	fluid_transport = {
		common = {order = _proto.item.fluid_transport.common.order, subgroup = _proto.item.fluid_transport.common.subgroup, override = true},
		standard = {
			common = {order = _proto.item.fluid_transport.standard.common.order},
			upper = {name = _proto.item.fluid_transport.standard.upper.name, icon = _proto.item.fluid_transport.standard.upper.icon},
			lower = {name = _proto.item.fluid_transport.standard.lower.name, icon = _proto.item.fluid_transport.standard.lower.icon}
		},
		standard_2 = {
			common = {order = _proto.item.fluid_transport.standard_2.common.order},
			upper = {name = _proto.item.fluid_transport.standard_2.upper.name, icon = _proto.item.fluid_transport.standard_2.upper.icon},
			lower = {name = _proto.item.fluid_transport.standard_2.lower.name, icon = _proto.item.fluid_transport.standard_2.lower.icon}
		},
		standard_3 = {
			common = {order = _proto.item.fluid_transport.standard_3.common.order},
			upper = {name = _proto.item.fluid_transport.standard_3.upper.name, icon = _proto.item.fluid_transport.standard_3.upper.icon},
			lower = {name = _proto.item.fluid_transport.standard_3.lower.name, icon = _proto.item.fluid_transport.standard_3.lower.icon}
		},
		standard_4 = {
			common = {order = _proto.item.fluid_transport.standard_4.common.order},
			upper = {name = _proto.item.fluid_transport.standard_4.upper.name, icon = _proto.item.fluid_transport.standard_4.upper.icon},
			lower = {name = _proto.item.fluid_transport.standard_4.lower.name, icon = _proto.item.fluid_transport.standard_4.lower.icon}
		}
	},
	rail_transport = {
		common = {order = _proto.item.rail_transport.common.order, subgroup = _proto.item.rail_transport.common.subgroup, override = true},
		standard = {
			upper = {name = _proto.item.rail_transport.standard.upper.name, icon = _proto.item.rail_transport.standard.upper.icon},
			lower = {name = _proto.item.rail_transport.standard.lower.name, icon = _proto.item.rail_transport.standard.lower.icon}
		}
	},
	transport_chest = {
		common = {order = _proto.item.transport_chest.common.order, subgroup = _proto.item.transport_chest.common.subgroup, override = true},
		wood = {
			common = {order = _proto.item.transport_chest.wood.common.order},
			down = {name = _proto.item.transport_chest.wood.down.name, icon = _proto.item.transport_chest.wood.down.icon},
			up = {name = _proto.item.transport_chest.wood.up.name, icon = _proto.item.transport_chest.wood.up.icon}
		},
		iron = {
			common = {order = _proto.item.transport_chest.iron.common.order},
			down = {name = _proto.item.transport_chest.iron.down.name, icon = _proto.item.transport_chest.iron.down.icon},
			up = {name = _proto.item.transport_chest.iron.up.name, icon = _proto.item.transport_chest.iron.up.icon}
		},
		steel = {
			common = {order = _proto.item.transport_chest.steel.common.order},
			down = {name = _proto.item.transport_chest.steel.down.name, icon = _proto.item.transport_chest.steel.down.icon},
			up = {name = _proto.item.transport_chest.steel.up.name, icon = _proto.item.transport_chest.steel.up.icon}
		},
		logistic = {
			common = {order = _proto.item.transport_chest.logistic.common.order},
			down = {name = _proto.item.transport_chest.logistic.down.name, icon = _proto.item.transport_chest.logistic.down.icon},
			up = {name = _proto.item.transport_chest.logistic.up.name, icon = _proto.item.transport_chest.logistic.up.icon}
		},
		logistic_2 = {
			common = {order = _proto.item.transport_chest.logistic_2.common.order},
			down = {name = _proto.item.transport_chest.logistic_2.down.name, icon = _proto.item.transport_chest.logistic_2.down.icon},
			up = {name = _proto.item.transport_chest.logistic_2.up.name, icon = _proto.item.transport_chest.logistic_2.up.icon}
		},
		storehouse = {
			common = {order = _proto.item.transport_chest.storehouse.common.order},
			down = {name = _proto.item.transport_chest.storehouse.down.name, icon = _proto.item.transport_chest.storehouse.down.icon},
			up = {name = _proto.item.transport_chest.storehouse.up.name, icon = _proto.item.transport_chest.storehouse.up.icon}
		},
		logistic_storehouse = {
			common = {order = _proto.item.transport_chest.logistic_storehouse.common.order},
			down = {name = _proto.item.transport_chest.logistic_storehouse.down.name, icon = _proto.item.transport_chest.logistic_storehouse.down.icon},
			up = {name = _proto.item.transport_chest.logistic_storehouse.up.name, icon = _proto.item.transport_chest.logistic_storehouse.up.icon}
		},
		warehouse = {
			common = {order = _proto.item.transport_chest.warehouse.common.order},
			down = {name = _proto.item.transport_chest.warehouse.down.name, icon = _proto.item.transport_chest.warehouse.down.icon},
			up = {name = _proto.item.transport_chest.warehouse.up.name, icon = _proto.item.transport_chest.warehouse.up.icon}
		},
		logistic_warehouse = {
			common = {order = _proto.item.transport_chest.logistic_warehouse.common.order},
			down = {name = _proto.item.transport_chest.logistic_warehouse.down.name, icon = _proto.item.transport_chest.logistic_warehouse.down.icon},
			up = {name = _proto.item.transport_chest.logistic_warehouse.up.name, icon = _proto.item.transport_chest.logistic_warehouse.up.icon}
		},
	},
	receiver_chest = {
		common = {flags = {}, override = true},
		wood = {
			lower = {name = "wooden-receiver-chest-lower", override_result = _proto.item.transport_chest.wood.down.name},
			upper = {name = "wooden-receiver-chest-upper", override_result = _proto.item.transport_chest.wood.up.name}
		},
		iron = {
			lower = {name = "iron-receiver-chest-lower", override_result = _proto.item.transport_chest.iron.down.name},
			upper = {name = "iron-receiver-chest-upper", override_result = _proto.item.transport_chest.iron.up.name}
		},
		steel = {
			lower = {name = "steel-receiver-chest-lower", override_result = _proto.item.transport_chest.steel.down.name},
			upper = {name = "steel-receiver-chest-upper", override_result = _proto.item.transport_chest.steel.up.name}
		},
		logistic = {
			lower = {name = "logistic-receiver-chest-lower", override_result = _proto.item.transport_chest.logistic.down.name},
			upper = {name = "logistic-receiver-chest-upper", override_result = _proto.item.transport_chest.logistic.up.name}
		},
		logistic_2 = {
			lower = {name = "logistic-receiver-chest-2-lower", override_result = _proto.item.transport_chest.logistic_2.down.name},
			upper = {name = "logistic-receiver-chest-2-upper", override_result = _proto.item.transport_chest.logistic_2.up.name}
		},
		storehouse = {
			lower = {name = "receiver-storehouse-lower", override_result = _proto.item.transport_chest.storehouse.down.name},
			upper = {name = "receiver-storehouse-upper", override_result = _proto.item.transport_chest.storehouse.up.name}
		},
		logistic_storehouse = {
			lower = {name = "logistic-receiver-storehouse-lower", override_result = _proto.item.transport_chest.logistic_storehouse.down.name},
			upper = {name = "logistic-receiver-storehouse-upper", override_result = _proto.item.transport_chest.logistic_storehouse.up.name}
		},
		warehouse = {
			lower = {name = "receiver-warehouse-lower", override_result = _proto.item.transport_chest.warehouse.down.name},
			upper = {name = "receiver-warehouse-upper", override_result = _proto.item.transport_chest.warehouse.up.name}
		},
		logistic_warehouse = {
			lower = {name = "logistic-receiver-warehouse-lower", override_result = _proto.item.transport_chest.logistic_warehouse.down.name},
			upper = {name = "logistic-receiver-warehouse-upper", override_result = _proto.item.transport_chest.logistic_warehouse.up.name}
		}
	}
}

_proto.technology = { -- Technology

}

_proto.tile = { -- Tiles
	common = {type = "tile", decorative_removal_probability = 1, needs_correction = false, ageing = 0, group = _proto.item_group.surfaces.name},
	underground_dirt = {
		name = "underground-dirt",
		icon = _gfx.icon.path .. "underground-dirt" .. _gfx.filetype,
		layer = 45,
		collision_mask = {"ground-tile"},
		variants = struct.Variants(_gfx.terrain.path, "underground-dirt", {4,0,0,0,0,0}, {1}),
		walking_speed_modifier = 0.8,
		map_color = util.RGB(107, 44, 4)
	},
	sky_void = {
		name = "sky-void",
		icon = _gfx.icon.path .. "sky-void" .. _gfx.filetype,
		layer = 45,
		collision_mask = {"ground-tile", "resource-layer", "floor-layer", "item-layer", "object-layer", "player-layer", "doodad-layer"},
		variants = struct.Variants(_gfx.terrain.path, "sky-void", {2,0,0,0,0,0}, {1}),
		map_color = util.RGB(4, 172, 251)
	},
	underground_wall = {
		name = "underground-wall",
		icon = _gfx.icon.path .. "underground-wall" .. _gfx.filetype,
		layer = 46,
		collision_mask = {"floor-layer", "item-layer", "doodad-layer"},
		variants = struct.Variants(_gfx.terrain.path, "underground-wall", {4,0,0,0,0,0}, {1}, nil, nil, 4),
		map_color = util.RGB(60, 51, 36)
	},
	floor = {
		common = {minable = {hardness = 0.2, mining_time = 0.5}, walking_speed_modifier = 1, subgroup = _proto.item_subgroup.surfaces.tile.name,
			collision_mask = {"ground-tile"}, override = true},
		wood = {
			name = _proto.item.floor.wood.name,
			layer = 59,
			variants = struct.Variants(_gfx.terrain.path, _proto.item.floor.wood.name, {1,1,1,1,1,1}, {1}),
			map_color = util.RGB(193, 140, 89)
		}
	}
}

_proto.recipe = { -- Recipes
	common = {type = "recipe", result_count = 1, enabled = true, override = true},
	connector = {
		common = {energy_required = 1, subgroup = _proto.item_subgroup.surfaces.component.name},
		crude = {name = _proto.item.connector.crude.name, ingredients = {{_proto.item.servo.crude.name, 1}, {_ref.base.item.wood, 4}}},
		basic = {name = _proto.item.connector.basic.name, ingredients = {{_proto.item.servo.crude.name, 2}, {_ref.base.item.copper_cable, 2},
			{_ref.base.item.circuit_electronic, 1}}},
		standard = {name = _proto.item.connector.standard.name, ingredients = {{_proto.item.servo.standard.name, 1}, {_ref.base.item.copper_cable, 4},
			{_ref.base.item.circuit_electronic, 2}}},
		improved = {name = _proto.item.connector.improved.name, ingredients = {{_proto.item.servo.standard.name, 2}, {_ref.base.item.copper_cable, 2},
			{_ref.base.item.circuit_advanced, 1}}},
		advanced = {name = _proto.item.connector.advanced.name, ingredients = {{_proto.item.servo.improved.name, 2}, {_ref.base.item.copper_cable, 2},
			{_ref.base.item.wire_green, 2}, {_ref.base.item.wire_red, 2}, {_ref.base.item.circuit_advanced, 2}}}
	},
	servo = {
		common = {subgroup = _proto.item_subgroup.surfaces.component.name},
		crude = {name = _proto.item.servo.crude.name, ingredients = {{_ref.base.item.copper, 4}, {_ref.base.item.iron_gear, 2}, {_ref.base.item.iron_stick, 2}}, energy_required = 2},
		standard = {name = _proto.item.servo.standard.name, ingredients = {{_proto.item.servo.crude.name, 1}, {_ref.base.item.iron_gear, 2}, {_ref.base.item.steel, 2}},
			energy_required = 4},
		improved = {name = _proto.item.servo.improved.name, category = "crafting-with-fluid", ingredients = {{_proto.item.servo.standard.name, 1},
			{type = "fluid", name = _ref.base.fluid.lubricant, amount = 4}, {_ref.base.item.steel, 4}}, energy_required = 8}
	},
	access_shaft = {
		common = {ingredients = {{_ref.base.item.wood_raw, 20}, {_ref.base.item.steel, 8}}, energy_required = 15, subgroup = _proto.item_subgroup.surfaces.transport.player.name},
		sky_entrance = {name = _proto.item.access_shaft.sky_entrance.name},
		sky_exit = {name = _proto.item.access_shaft.sky_exit.name},
		underground_entrance = {name = _proto.item.access_shaft.underground_entrance.name},
		underground_exit = {name = _proto.item.access_shaft.underground_exit.name}
	},
	energy_transport = {
		common = {subgroup = _proto.item_subgroup.surfaces.transport.energy.name},
		standard = {
			common = {ingredients = {{_ref.base.item.accumulator, 2}, {_proto.item.connector.standard.name, 2}}},
			upper = {name = _proto.item.energy_transport.standard.upper.name},
			lower = {name = _proto.item.energy_transport.standard.lower.name}
		},
		standard_2 = {
			common = {ingredients = {{_ref.bobpower.item.accumulator_2, 2}, {_proto.item.connector.improved.name, 2}}},
			upper = {name = _proto.item.energy_transport.standard_2.upper.name},
			lower = {name = _proto.item.energy_transport.standard_2.lower.name}
		},
		standard_3 = {
			common = {ingredients = {{_ref.bobpower.item.accumulator_3, 2}, {_proto.item.connector.improved.name, 2}}},
			upper = {name = _proto.item.energy_transport.standard_3.upper.name},
			lower = {name = _proto.item.energy_transport.standard_3.lower.name}
		},
		standard_4 = {
			common = {ingredients = {{_ref.bobpower.item.accumulator_4, 2}, {_proto.item.connector.advanced.name, 4}}},
			upper = {name = _proto.item.energy_transport.standard_4.upper.name},
			lower = {name = _proto.item.energy_transport.standard_4.lower.name}
		},
		advanced = {
			common = {ingredients = {{_ref.base.item.accumulator, 20}, {_proto.item.connector.advanced.name, 8}}},
			upper = {name = _proto.item.energy_transport.advanced.upper.name},
			lower = {name = _proto.item.energy_transport.advanced.lower.name}
		},
	},
	fluid_transport = {
		common = {subgroup = _proto.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{_ref.base.item.storage_tank, 2}, {_proto.item.connector.basic.name, 2}}},
			upper = {name = _proto.item.fluid_transport.standard.upper.name},
			lower = {name = _proto.item.fluid_transport.standard.lower.name}
		},
		standard_2 = {
			common = {ingredients = {{_ref.boblogistics.item.storage_tank_2, 2}, {_proto.item.connector.standard.name, 2}}},
			upper = {name = _proto.item.fluid_transport.standard_2.upper.name},
			lower = {name = _proto.item.fluid_transport.standard_2.lower.name}
		},
		standard_3 = {
			common = {ingredients = {{_ref.boblogistics.item.storage_tank_3, 2}, {_proto.item.connector.standard.name, 2}}},
			upper = {name = _proto.item.fluid_transport.standard_3.upper.name},
			lower = {name = _proto.item.fluid_transport.standard_3.lower.name}
		},
		standard_4 = {
			common = {ingredients = {{_ref.boblogistics.item.storage_tank_4, 2}, {_proto.item.connector.improved.name, 2}}},
			upper = {name = _proto.item.fluid_transport.standard_4.upper.name},
			lower = {name = _proto.item.fluid_transport.standard_4.lower.name}
		}
	},
	transport_chest = {
		common = {subgroup = _proto.item_subgroup.surfaces.transport.chest.name},
		wood = {
			common = {ingredients = {{_ref.base.item.chest_wood, 2}, {_proto.item.connector.crude.name, 1}}},
			up = {name = _proto.item.transport_chest.wood.up.name},
			down = {name = _proto.item.transport_chest.wood.down.name}
		},
		iron = {
			common = {ingredients = {{_ref.base.item.chest_iron, 2}, {_proto.item.connector.basic.name, 1}}},
			up = {name = _proto.item.transport_chest.iron.up.name},
			down = {name = _proto.item.transport_chest.iron.down.name}
		},
		steel = {
			common = {ingredients = {{_ref.base.item.chest_steel, 2}, {_proto.item.connector.standard.name, 1}}},
			up = {name = _proto.item.transport_chest.steel.up.name},
			down = {name = _proto.item.transport_chest.steel.down.name}
		},
		logistic = {
			common = {ingredients = {{_ref.base.item.chest_requester, 1}, {_ref.base.item.chest_passive_provider, 1}, {_proto.item.connector.advanced.name, 1}}},
			up = {name = _proto.item.transport_chest.logistic.up.name},
			down = {name = _proto.item.transport_chest.logistic.down.name}
		},
		logistic_2 = {
			common = {ingredients = {{_ref.boblogistics.item.requester_chest_2, 1}, {_ref.boblogistics.item.passive_provider_chest_2, 1},
				{_proto.item.connector.advanced.name, 2}}},
			up = {name = _proto.item.transport_chest.logistic_2.up.name},
			down = {name = _proto.item.transport_chest.logistic_2.down.name}
		},
		storehouse = {
			common = {ingredients = {{_ref.warehousing.item.storehouse, 2}, {_proto.item.connector.standard.name, 2}}},
			up = {name = _proto.item.transport_chest.storehouse.up.name},
			down = {name = _proto.item.transport_chest.storehouse.down.name}
		},
		logistic_storehouse = {
			common = {ingredients = {{_ref.warehousing.item.requester_storehouse, 1}, {_ref.warehousing.item.passive_provider_storehouse, 1}, {_proto.item.connector.advanced.name, 3}}},
			up = {name = _proto.item.transport_chest.logistic_storehouse.up.name},
			down = {name = _proto.item.transport_chest.logistic_storehouse.down.name}
		},
		warehouse = {
			common = {ingredients = {{_ref.warehousing.item.warehouse, 2}, {_proto.item.connector.improved.name, 2}}},
			up = {name = _proto.item.transport_chest.warehouse.up.name},
			down = {name = _proto.item.transport_chest.warehouse.down.name}
		},
		logistic_warehouse = {
			common = {ingredients = {{_ref.warehousing.item.requester_warehouse, 1}, {_ref.warehousing.item.passive_provider_warehouse, 1}, {_proto.item.connector.advanced.name, 3}}},
			up = {name = _proto.item.transport_chest.logistic_warehouse.up.name},
			down = {name = _proto.item.transport_chest.logistic_warehouse.down.name}
		},
	},
	rail_transport = {
		common = {subgroup = _proto.item_subgroup.surfaces.transport.other.name},
		standard = {
			common = {ingredients = {{_ref.base.item.train_stop, 2}, {_proto.item.connector.advanced.name, 2}}},
			upper = {name = _proto.item.rail_transport.standard.upper.name},
			lower = {name = _proto.item.rail_transport.standard.lower.name}
		}
	},
	floor = {
		common = {subgroup = _proto.item_subgroup.surfaces.tile.name},
		wood = {name = _proto.item.floor.wood.name, ingredients = {{_ref.base.item.wood, 5}}}
	}
}

function proto.definition(_path_to_field, _field, _common, _inherit)
	if game == nil then -- Only allow this function to be used before game is loaded
		local _data, _path = (type(_inherit) == "table") and table.copy(_inherit, true) or {}, _proto
		if type(_path_to_field) ~= "table" or type(_field) ~= "string" then
			error("Unable to fetch prototype definition, path to field is not a table or field is not a string value. [proto.get("..tostring(_path_to_field)..", "..tostring(_field)..", "..tostring(_common)..", "..tostring(_inherit)..")]")
		else
			for k, v in pairs(_path_to_field) do
				if type(v) == "string" and _path[string.lower(v)] then
					_path = _path[string.lower(v)]
					if _common and type(_path["common"]) == "table" then
						for k, v in pairs(_path["common"]) do
							_data[k] = (type(_data[k]) == "table") and table.merge(_data[k], v) or table.copy(v, true)
						end
					end
				else
					error("Unable to fetch prototype definition, path to field leads through invalid or undefined table space. [proto.get("..table.tostring(_path_to_field, true)..", "..tostring(_field)..", "..tostring(_common)..", "..tostring(_inherit)..")]")
				end
			end
			if type(_path[string.lower(_field)]) == "table" then
				for k, v in pairs(_path[string.lower(_field)]) do
					_data[k] = (type(_data[k]) == "table") and table.merge(_data[k], v) or table.copy(v, true)
				end
			end
			if _data.override or (_type == "recipe" and type(_data.result) ~= "string") or
				(_type == "entity" and (type(_data.minable) ~= "table" or (type(_data.minable.result) ~= "string" and type(_data.minable.results) ~= "table"))
			) then
				local _type = _path_to_field[1]
				if _type == "entity" then
					_data.minable = _data.minable or {}
					_data.minable.results = _data.override_results or nil
					if _data.override_result then _data.minable.result = _data.override_result
					elseif _data.override_results then _data.minable.results = _data.override_results
					else _data.minable.result = _data.name end
				elseif _type == "recipe" then
					_data.result = _data.override_result or _data.name
				elseif _type == "item" then
					if _data.place_as_tile then _data.place_as_tile.result = _data.override_result or _data.name 
					else _data.place_result = _data.override_result or _data.name end
				elseif _type == "tile" and _data.minable then
					_data.minable.results = _data.override_results or _data.minable.results or nil
					if not(_data.minable.results) then _data.minable.result = _data.override_result or _data.minable.result or _data.name end
				end
			end
			_data.override_result = nil
			_data.override_results = nil
			_data.override = nil
			return _data
		end
	end
end

-- Workaround for autocomplete in LDT
proto.reference = _ref -- Stores reference data for identifying prototypes from other mods and the base game 
proto.corpse = _proto.corpse -- Prototype data for corpses
proto.entity = _proto.entity -- Prototype data for entities
proto.item = _proto.item -- Prototype data for items
proto.item_group = _proto.item_group -- Prototype data for item groups
proto.item_subgroup = _proto.item_subgroup -- Prototype data for item subgroups
proto.recipe = _proto.recipe -- Prototype data for recipes
proto.technology = _proto.technology -- Prototype data for technology
proto.tile = _proto.tile -- Prototype data for tiles
for k, v in pairs(_proto) do -- make tables readonly to prevent external modification
	proto[k] = table.readonly(v) -- return a readonly copy of the prototype tables
end
proto.reference = table.readonly(_ref) -- make table readonly to prevent external modification

return proto