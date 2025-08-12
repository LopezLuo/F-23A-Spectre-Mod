-- This code is part from the F-22A mod by Grinnelli Designs (including the font).
dofile(LockOn_Options.common_script_path .. "Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path .. "Fonts/fonts_cmn.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Materials.lua")



local fontPath = LockOn_Options.script_path .. "Indicator/Textures/Fonts/"


local stdFont = {
	texture    = fontPath .. "F-22A_Font.dds",
	size       = {8, 8},
	resolution = {2048, 2048},
	default    = {141, 256},
	chars      =
	{
		[1]  = {32, 141, 256}, -- [space]
		[2]  = {42, 141, 256}, -- *
		[3]  = {43, 141, 256}, -- +
		[4]  = {45, 141, 256}, -- -
		[5]  = {46, 141, 256}, -- .
		[6]  = {47, 141, 256}, -- /
		[7]  = {48, 141, 256}, -- 0
		[8]  = {49, 141, 256}, -- 1
		[9]  = {50, 141, 256}, -- 2
		[10] = {51, 141, 256}, -- 3
		[11] = {52, 141, 256}, -- 4
		[12] = {53, 141, 256}, -- 5
		[13] = {54, 141, 256}, -- 6
		[14] = {55, 141, 256}, -- 7
		[15] = {56, 141, 256}, -- 8
		[16] = {57, 141, 256}, -- 9
		[17] = {58, 141, 256}, -- :
		[18] = {65, 141, 256}, -- A
		[19] = {66, 141, 256}, -- B
		[20] = {67, 141, 256}, -- C
		[21] = {68, 141, 256}, -- D
		[22] = {69, 141, 256}, -- E
		[23] = {70, 141, 256}, -- F
		[24] = {71, 141, 256}, -- G
		[25] = {72, 141, 256}, -- H
		[26] = {73, 141, 256}, -- I
		[27] = {74, 141, 256}, -- J
		[28] = {75, 141, 256}, -- K
		[29] = {76, 141, 256}, -- L
		[30] = {77, 141, 256}, -- M
		[31] = {78, 141, 256}, -- N
		[32] = {79, 141, 256}, -- O
		[33] = {80, 141, 256}, -- P
		[34] = {81, 141, 256}, -- Q
		[35] = {82, 141, 256}, -- R
		[36] = {83, 141, 256}, -- S
		[37] = {84, 141, 256}, -- T
		[38] = {85, 141, 256}, -- U
		[39] = {86, 141, 256}, -- V
		[40] = {87, 141, 256}, -- W
		[41] = {88, 141, 256}, -- X
		[42] = {89, 141, 256}, -- Y
		[43] = {90, 141, 256}, -- Z
		[44] = {37, 141, 256}, -- %
		[45] = {100, 141, 256} -- "°", use "d".
	}
}


fonts = {}

for name, icolor in pairs(colors) do
	fonts[name] = MakeFont(stdFont, icolor)
end