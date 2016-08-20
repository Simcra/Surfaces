--[[
	Surfaces (Factorio Mod)
	Copyright (C) 2016	Simon Crawley

	This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("script.lib.api")
require("script.lib.util-base")

--[[--
Miscellaneous utilities

@module util
]]
util = {}

-- prints text to one player's screen
function util.message(player_id, text)
	local player = api.game.player(player_id)
	if player and (type(text) == "string" or type(text) == "table") then
		player.print(text)
	end
end

-- prints text to every player's screen
function util.broadcast(text)
	for k, v in pairs(api.game.players()) do
		util.message(k, text)
	end
end

-- used to print debug text to every player's screen
function util.debug(text)
	if const.debug == true then
		util.broadcast(text)
	end
end

-- transforms RGB colour (Red: 0-255, Green: 0-255, Blue: 0-255, Alpha: 0-100) into factorio colour format {r = [0-1], g = [0-1], b = [0-1], a = [0-1]}
function util.RGB(red, green, blue, alpha)
	red = red and (red > 255 and 255 or red) or 0
	green = green and (green > 255 and 255 or green) or 0
	blue = blue and (blue > 255 and 255 or blue) or 0
	alpha = alpha and (alpha > 100 and 100 or alpha) or 100
	return {r = (red / 255), g = (green / 255), b = (blue / 255), a = (alpha / 100)}
end

return util