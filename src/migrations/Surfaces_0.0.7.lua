require("script.lib.api")
require("script.lib.surfaces")

game.reload_script()
for k, v in pairs(api.game.surfaces()) do
	surfaces.migrate_surface(v, "_")
end