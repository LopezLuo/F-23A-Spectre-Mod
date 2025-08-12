addUFCDSimple("Left_Base", {-width / 4}, nil, base)



-- ========== MENU page ==========
addUFCDSimple("Left_MENU_Base", nil, nil, "Left_Base", nil, nil, {"UFCDLeftPage"}, {{ctrl.compareNum, 0, 0}})


addUFCDText(nil, OSB5Text, nil, "Left_MENU_Base", nil, nil, nil, nil, "FAST")



-- ========== FAST page ==========
addUFCDSimple("FAST_Base", nil, nil, "Left_Base", nil, nil, {"UFCDLeftPage"}, {{ctrl.compareNum, 0, 1}})
addUFCDSimple("FAST_Bottom_Base", {0, -height / 2}, nil, "FAST_Base") -- Just makes positioning a lot easier.


addUFCDTextBox(nil, OSB5Text, nil, "FAST_Base", nil, nil, nil, nil, true, nil, nil, nil, nil, "FAST")



-- Engine Data:
addUFCDSimple("Engine_Data_Base", {0, height / 4 * 2.75 + (height - ((height / 4) * 2.75)) / 2}, nil, "FAST_Bottom_Base")


addUFCDText("RPM_Text", {0, .001}, nil, "Engine_Data_Base", nil, nil, nil, nil, "RPM", nil, strdefs.big)
addUFCDText("EGT_Text", {0, -.007}, nil, "Engine_Data_Base", nil, nil, nil, nil, "EGT")

local engineDataX = width / 10 - lineThickness

local leftRPM = addUFCDTextParam(nil, {-engineDataX}, nil, "RPM_Text", nil, nil, {"L_AB"}, {{ctrl.changeColor, 0, 1, 1, 165 / 255, 0}}, "L_rpm", nil, {"%s"}, strdefs.bold)
local leftEGT = addUFCDTextParam(nil, {-engineDataX}, nil, "EGT_Text", nil, nil, nil, nil, "L_egt", nil, {"%.0fd"})
local leftDivider = addUFCDBox(nil, {-engineDataX * 1.5 - lineThickness * 2}, nil, "Engine_Data_Base", nil, nil, nil, nil, nil, ((height - ((height / 4) * 2.75)) / 2.5) * 2)

for i = 0, 360, 10 do
	local nozIndX = width / 20 + engineDataX * 1.5 + lineThickness * 1.865

	local leftNoz = addUFCDCircle(nil, {-nozIndX, -.0025}, {0, 180}, "Engine_Data_Base", nil, nil, {"leftNozPos"}, {{ctrl.inRange, 0, i - 11, i + 11}}, .005, 0, i, (20 / 360) * i)
	copyElement(leftNoz, {"init_pos", "element_params"}, {{nozIndX, -.0025}, {"rightNozPos"}})
end

copyElement(leftRPM, {"init_pos", "element_params"}, {{engineDataX}, {"R_AB", "R_rpm"}}) -- Right RPM
copyElement(leftEGT, {"init_pos", "element_params"}, {{engineDataX}, {"R_egt"}})         -- Right EGT
copyElement(leftDivider, {"init_pos"}, {{engineDataX * 1.5 + lineThickness * 2}})


addUFCDBox(nil, {0, -(height - ((height / 4) * 2.75)) / 2.5}, nil, "Engine_Data_Base", nil, nil, nil, nil, width / 2)



-- Fuel Bar:
local fuelBarWidth = width / 40 * 2
local fuelBarHeight = width / 40 * 10 + lineThickness * 2.865

addUFCDTextBox("Fuel_Bar", {-width / 4 + fuelBarWidth, fuelBarHeight / 2 + .006}, nil, "FAST_Bottom_Base", nil, nil, nil, nil, true, nil, fuelBarWidth, fuelBarHeight, nil, "")
addUFCDBox(nil, {-.000175, -fuelBarHeight - lineThickness * (2.865 / 2) - .0009}, nil, "Fuel_Bar", hcr.rw, lvls.mask, nil, nil, fuelBarWidth, fuelBarHeight, materials["red"], true)
addUFCDBox(nil, {-.000175, -fuelBarHeight - lineThickness * (2.865 / 2) - .003}, nil, "Fuel_Bar", nil, nil, {"fuelPCT", "fuelIndWarning"}, {{ctrl.moveY, 0, fuelBarHeight + lineThickness * 5.1}, {ctrl.changeColor, 1, 1, 1, 0.647058, 0}, {ctrl.changeColor, 1, 2, 1, 0, 0}}, fuelBarWidth, fuelBarHeight + .004, materials["green"])

addUFCDText("Fuel_Total_Text", {.002, fuelBarHeight / 2 + .014}, nil, "Fuel_Bar", nil, nil, nil, nil, "T:", align.RC)
addUFCDTextParam(nil, {0, -.0004}, nil, "Fuel_Total_Text", nil, nil, nil, nil, "fuelInd", align.LC, {"%.1f"}, strdefs.small)

addUFCDText("Fuel_Fuel_Flow_Text", {.002, fuelBarHeight / 2 + .007}, nil, "Fuel_Bar", nil, nil, nil, nil, "FF:", align.RC)
addUFCDTextParam(nil, {0, -.0004}, nil, "Fuel_Fuel_Flow_Text", nil, nil, nil, nil, "totalFuelFlow", align.LC, {"%.0f"}, strdefs.small)


local jokerLine = addUFCDBox(nil, {-.00055 + lineThickness * 2, -fuelBarHeight / 2}, nil, "Fuel_Bar", nil, nil, {"jokerFuel"}, {{ctrl.moveY, 0, fuelBarHeight / 100}}, fuelBarWidth + lineThickness * 6.5, nil, materials["magenta"])
copyElement(jokerLine, {"element_params", "material"}, {{"bingoFuel"}, materials["red"]})

local jokerReadout = addUFCDTextParam(nil, {fuelBarWidth, -fuelBarHeight / 2 + .005}, nil, "Fuel_Bar", nil, nil, nil, nil, "jokerFuel", align.LC, {"J:%1.1f"}, strdefs.small)
copyElement(jokerReadout, {"init_pos", "element_params", "formats"}, {{fuelBarWidth, -fuelBarHeight / 2}, {"bingoFuel"}, {"B:%1.1f"}})



-- Status Lights:
addUFCDSimple("Status_Bar", {width / 6, height / 2 * 1.3}, nil, "FAST_Bottom_Base")


local lights = {
	{text = {"AAR RDY"}, param = {"AARReady"}},
	{text = {"AAR XFR"}, param = {"fuelFlow"}},
	{text = {" "},       param = {"zero"}},
	{text = {"AIR BRK"}, param = {"airbrakeState"}},
	{text = {" FLAPS "}, param = {"flapState"}},
	{text = {"A/P ALT", "A/P ATT"}, param = {"APMode"}},
	{text = {"NWS LOW"}, param = {"nwsRateState"}},
	{text = {"FCS TST"}, param = {"FLCSTestState"}}
}
local slot = 1
local pos = {.0, .0}

for i = 1, #lights do
	slot = i == 6 and 2 or slot

	if slot == 1 then
		pos = {0, (i - 1) * -.01}
	elseif slot == 2 then
		pos = {-.027, (i - 5) * -.01}
	end


	for j = 1, #lights[i].text do
		addUFCDTextBox(nil, pos, nil, "Status_Bar", nil, nil, lights[i].param, {{ctrl.compareNum, 0, j}}, true, materials["green"], nil, nil, nil, lights[i].text[j])
	end
end