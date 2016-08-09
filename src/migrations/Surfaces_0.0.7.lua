game.reload_script()
for k, v in pairs(game.players) do
	v.force.reset_recipes()
end