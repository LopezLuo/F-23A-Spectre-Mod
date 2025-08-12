dofile(LockOn_Options.common_script_path .. "Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path .. "Fonts/fonts_cmn.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")



colors = {
	red        = {255, 0, 0, 255},
	green      = {0, 255, 0, 255},
	blue       = {0, 0, 255, 255},
	lightBlue  = {0, 255 * .5, 255, 255},
	white      = {255, 255, 255, 255},
	black      = {0, 0, 0, 255},
	gray       = {128, 128, 128, 255},
	yellow     = {255, 255, 0, 255},
	cyan       = {0, 255, 255, 255},
	magenta    = {255, 0, 255, 255},
	orange     = {255, 255 * .3529, 0, 255},
	ADIGround  = {255 * .467783, 255 * .318546, 255 * .072271, 255},
	ADIAir     = {255 * .022173, 255 * .019382, 255 * .132868, 255},
	background = {(.000607 / 4 * 3) * 255, (.010960 / 4 * 3) * 255, (.042311 / 4 * 3) * 255, 255}, -- To make colors accurate. Take the RGB here (as sRGB_8): https://davengrace.com/dave/cspace/
	primary    = {.246201 * 255, .496932 * 255, .921581 * 255, 255}                                -- And take the numbers of sRGB [0,1] (liniear) and multiply by 255. The alpha is always 255.
}


materials = {}

for name, color in pairs(colors) do
	materials[name] = MakeMaterial("", color)
end


local texturePath = LockOn_Options.script_path .. "Indicator/Textures/Displays/"

missileIcons = MakeMaterial(texturePath .. "/F_23_Missile_Icons", colors.white)