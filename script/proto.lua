--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.util")

--[[
Note: This is NOT a configuration file, nor are any files other than config.lua! 

If you alter anything in this script you will most likely break your save game and/or your version of the mod.
]]
proto = { -- Prototype data, referenced throughout this mod, including data definition
	entity = { -- Entities
		underground_wall = {
			name = "underground-wall",
			type = "tree",
			icon = "__Surfaces__/graphics/terrain/underground/wall2.png",
			flags = {"placeable-neutral"},
			order = "z-a[surfaces]-a[underground-wall]",
			collision_box = {{-0.499, -0.499}, {0.499, 0.499}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			minable = {hardness = 2, mining_time = 2, mining_particle = "stone-particle", results = {{type = "item", name = "stone", probability = 1, amount_min = 1, amount_max = 4}}},
			pictures = {{filename = "__Surfaces__/graphics/terrain/underground/wall.png", priority = "extra-high", width = 32, height = 32}},
			resistances = {
				{type = "impact", percent = 80},
				{type = "physical", percent = 5},
				{type = "poison", percent = 100},
				{type = "fire", percent = 100},
				{type = "acid", percent = 95},
				{type = "explosion", percent = 5}
			},
			max_health = 100,
			corpse = "invisible-corpse",
			mined_sound = {filename = "__base__/sound/deconstruct-bricks.ogg"},
			vehicle_impact_sound =	{filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
			map_color = util.RGB(60, 52, 36),
		},
		access_shaft = { -- Used for all four access shafts
			type = "simple-entity",
			flags = {},
			collision_mask = {"object-layer", "player-layer"},
			order = "z-a[surfaces]-a[access-shaft]",
			collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			minable = {mining_time = 8},
			pictures = {priority = "high", width = 96, height = 96, direction_count = 1, shift = {0, 0}},
			resistances = {
				{type = "physical", percent = 20},
				{type = "impact", percent = 20},
				{type = "poison", percent = 100},
				{type = "fire", percent = 5},
				{type = "acid", percent = 15}
			},
			max_health = 100,
			corpse = "small-remnants",
			render_layer = "object",
			map_color = util.RGB(127, 88, 43, 50),
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
	corpse = {
		invisible = {
			name = "invisible-corpse",
			icon = "__Surfaces__/graphics/icons/blank.png",
			flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
			animation = {},
			time_before_removed = 60,
			order = "c[corpse]-a[biter]-b[invisible]"
		}
	}
}