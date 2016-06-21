require("script.enum")
local enum_data = enum.prototype.tile.sky_concrete

local sky_concrete = table.deepcopy(data.raw["tile"]["concrete"])
sky_concrete.name = enum_data.name
sky_concrete.needs_correction = false
sky_concrete.collision_mask = {"ground-tile", "floor-layer", "doodad-layer"}
sky_concrete.layer = enum_data.layer
sky_concrete.decorative_removal_probability = 1
data:extend({sky_concrete})