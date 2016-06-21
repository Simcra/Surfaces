require("script.enum")
local enum_data = enum.prototype.entity.underground_wall
local gfxpath, filetype = "__Surfaces__/graphics/terrain/underground/", ".png"

local underground_wall = {
	name = enum_data.name,
	type = enum_data.type,
	icon = gfxpath .. "wall2" .. filetype,
	flags = {"placeable-neutral"},
	max_health = 100,
	corpse = "invisible-corpse",
	collision_box = {{-0.499, -0.499}, {0.499, 0.499}},
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	minable = {hardness = enum_data.hardness, mining_time = enum_data.mining_time, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 5}}},
	pictures = {{filename = gfxpath .. "wall" .. filetype, priority = "extra-high", width = 32, height = 32}},
	mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
	vehicle_impact_sound =	{filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
	resistances = enum_data.resistances,
	map_color = enum_data.map_colour,
	order = enum_data.order
}
data:extend({underground_wall})

local invisible_corpse = table.deepcopy(data.raw.corpse["medium-biter-corpse"])
invisible_corpse.name = "invisible-corpse"
invisible_corpse.icon = "__Surfaces__/graphics/icons/blank.png"
invisible_corpse.flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"}
invisible_corpse.animation = {}
invisible_corpse.time_before_removed = 60
invisible_corpse.order = "c[corpse]-a[biter]-b[invisible]"
data:extend({invisible_corpse})