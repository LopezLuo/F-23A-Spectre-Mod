-- ========== Loading page ==========
addUFCDSimple("Loading_Base", {0, -.003}, nil, base, nil, nil, {"UFCDLeftPage"}, {{ctrl.compareNum, 0, -1}})


addUFCDTextBox(nil, nil, nil, "Loading_Base", nil, nil, nil, nil, true, nil, .075, .075, materials["black"], "")
addUFCDText("Linux_Command_1", {-.0375, .0375}, nil, "Loading_Base", nil, nil, nil, nil, "UFCD.SPECTRE:-*", align.LC, strdefs.cmd, fonts["green"])
addUFCDText(nil, nil, nil, "Linux_Command_1", nil, nil, {"UFCDLoadingPercent"}, {{ctrl.inRange, 0, 7, 101}}, "                STARTUP", align.LC, strdefs.cmd)
local linuxCommands = {
	{PCTStart = 10, PCTDone = 28, text = " BIT      ... "},
	{PCTStart = 30, PCTDone = 56, text = " AVIONICS ... "},
	{PCTStart = 58, PCTDone = 64, text = " ENG PRIM ... "},
	{PCTStart = 66, PCTDone = 70, text = " CMD      ... "},
	{PCTStart = 72, PCTDone = 80, text = " ECM      ... "}
}

for i, cmd in ipairs(linuxCommands) do
	local name = "Linux_Command_" .. i + 1

	addUFCDText(name, {-.0375, .0325 - .005 * (i - 1)}, nil, "Loading_Base", nil, nil, {"UFCDLoadingPercent"}, {{ctrl.inRange, 0, cmd.PCTStart, 101}}, cmd.text, align.LC, strdefs.cmd)
	addUFCDText(nil, nil, nil, name, nil, nil, {"UFCDLoadingPercent"}, {{ctrl.inRange, 0, cmd.PCTDone, 101}}, "              DONE", align.LC, strdefs.cmd)
end
addUFCDText("Linux_Command_7", {-.0375, .0075}, nil, "Loading_Base", nil, nil, {"UFCDLoadingPercent"}, {{ctrl.inRange, 0, 82, 101}}, " WELCOME ABOARD PILOT", align.LC, strdefs.cmd)
addUFCDText(nil, {-.0375, .0025}, nil, "Loading_Base", nil, nil, {"UFCDLoadingPercent"}, {{ctrl.compareNum, 0, 100}}, "UFCD.SPECTRE:-*", align.LC, strdefs.cmd, fonts["green"])


local loadingBarWidth = width / 40 * 2
local loadingBarHeight = width / 40 * 10 + lineThickness * 2.865

addUFCDTextBox("Loading_Bar", {0, -.0075}, {-90}, "Loading_Base", nil, nil, nil, nil, true, nil, loadingBarWidth, loadingBarHeight, materials["black"], "")
addUFCDBox(nil, {-.000175, -loadingBarHeight - lineThickness * (2.865 / 2) - .0034}, nil, "Loading_Bar", hcr.rw, lvls.mask, nil, nil, loadingBarWidth, loadingBarHeight + .005, materials["red"], true)
addUFCDBox(nil, {-.000175, -loadingBarHeight - lineThickness * (2.865 / 2) - .003}, nil, "Loading_Bar", nil, nil, {"UFCDLoadingPercent"}, {{ctrl.moveY, 0, (loadingBarHeight + lineThickness * 5.1) / 100}}, loadingBarWidth, loadingBarHeight + .004, materials["white"])
addUFCDText(nil, nil, {90}, "Loading_Bar", nil, nil, nil, nil, "SPECTRE", nil, strdefs.loadingBar, fonts["black"])

addUFCDTextParam(nil, {-loadingBarWidth, loadingBarHeight - .02}, {90}, "Loading_Bar", nil, nil, nil, nil, "UFCDLoadingPercent", align.RC, {"%1.0f%%"}, strdefs.small)



addUFCDBox(nil, nil, nil, base, nil, nil, {"UFCDLeftPage"}, {{ctrl.inRange, 0, -.1, 3}}, nil, height) -- Vertical side divider line.



dofile(LockOn_Options.script_path .. "UFCD/Indicator/UFCD_Left_Side.lua")
dofile(LockOn_Options.script_path .. "UFCD/Indicator/UFCD_Right_Side.lua")



addUFCDBox(nil, nil, nil, base, hcr.rw, lvls.noclip, {"screenBrightness"}, {{ctrl.opacity, 0}}, width, height, materials["black"])