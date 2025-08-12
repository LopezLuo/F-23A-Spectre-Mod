addUFCDSimple("Right_Base", {width / 4}, nil, base)



-- ========== MENU page ==========
addUFCDSimple("Right_MENU_Base", nil, nil, "Right_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.compareNum, 0, 0}})


addUFCDText(nil, OSB6Text, nil, "Right_MENU_Base", nil, nil, nil, nil, "ADI")
addUFCDText(nil, OSB7Text, nil, "Right_MENU_Base", nil, nil, nil, nil, "TACT")



-- ========== ADI page ==========
addUFCDSimple("ADI_Base", nil, nil, "Right_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.compareNum, 0, 1}})


addUFCDTextBox(nil, OSB6Text, nil, "ADI_Base", nil, nil, nil, nil, true, nil, nil, nil, nil, "ADI")

local Radar_Select_Text = addUFCDText(nil, OSB7Text, nil, "ADI_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 1}}, "R")
addUFCDTextBox(nil, OSB7Text, nil, "ADI_Base", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 2}}, true, nil, nil, nil, nil, "R")

copyElement(Radar_Select_Text, {"init_pos", "element_params", "value"}, {OSB8Text, {"headingMode"}, "M"})
addUFCDTextBox(nil, OSB8Text, nil, "ADI_Base", nil, nil, {"headingMode"}, {{ctrl.compareNum, 0, 2}}, true, nil, nil, nil, nil, "M")



-- ADI
addUFCDSimple("ADI_Middle", {0, .002}, nil, "ADI_Base")

local ADIRadius = .027
addUFCDCircle(nil, nil, nil, "ADI_Middle", hcr.rw, lvls.mask2, nil, nil, ADIRadius, 0, 360, 42, materials["red"])
addUFCDCircle(nil, nil, nil, "ADI_Middle", nil, nil, nil, nil, ADIRadius + lineThickness, ADIRadius, 360, 42, materials["white"])


addUFCDSimple("ADI_Movement_Base", nil, nil, "ADI_Middle", nil, nil, {"roll", "pitch"}, {{ctrl.rotate, 0, math.rad(1)}, {ctrl.moveY, 1, -ADIRadius / 40}})

local ADIGround = addUFCDBox(nil, {0, -ADIRadius * 2}, nil, "ADI_Movement_Base", nil, lvls.mask2, nil, nil, ADIRadius * 4, ADIRadius * 4, materials["ADIGround"])
copyElement(ADIGround, {"init_pos", "material"}, {{0, ADIRadius * 2}, materials["ADIAir"]})


addUFCDSimpleLine(nil, nil, nil, "ADI_Middle", nil, lvls.mask2, nil, nil, lineThickness / 2, {{-.006}, {-.003}, {-.0015, -.003}, {0}, {.0015, -.003}, {.003}, {.006}}, materials["white"])


for i = -12, 12 do
	if i == 0 or math.abs(i) == 9 then
		addUFCDBox(nil, {0, (ADIRadius / 4) * i}, nil, "ADI_Movement_Base", nil, lvls.mask2, nil, nil, ADIRadius * 2, nil, materials["white"])
	else
		local pitch = i * 10
		local baseRot = (i < -9 or i > 9) and 180 or 0
		local lineRot = (i < -9 or i < 0) and 180 or 0
		local pitchText = (i < -9) and tostring(-pitch - 180) or (i < 0 or (i > 0 and i < 10)) and tostring(pitch) or (i > 9) and tostring(180 - pitch)


		addUFCDSimple("ADI_Pitch_" .. pitch, {0, (ADIRadius / 4) * i}, {baseRot}, "ADI_Movement_Base")

		local leftPitchLines = addUFCDSimpleLine(nil, nil, {0, 0, lineRot}, "ADI_Pitch_" .. pitch, nil, lvls.mask2, nil, nil, lineThickness / 2, {{-.004, -ADIRadius / 8}, {-.004}, {-ADIRadius / 3 * 2}}, materials["white"])
		copyElement(leftPitchLines, {"init_rot"}, {{0, 180, lineRot}})

		local LeftPitchText = addUFCDText(nil, {-(ADIRadius / 3 * 2 + .0005)}, nil, "ADI_Pitch_" .. pitch, nil, lvls.mask2, nil, nil, pitchText, align.RC, strdefs.xtraSmall)
		copyElement(LeftPitchText, {"init_pos", "alignment"}, {{ADIRadius / 3 * 2 + .0005}, align.LC})
	end
end



-- Flight data
addUFCDTextParamBox("Heading_Text_Box", {0, ADIRadius + .007}, nil, "ADI_Middle", nil, nil, nil, nil, true, nil, nil, nil, nil, "heading", 3, nil, {"%3.0f"}, strdefs.small)
local trueHeading = addUFCDText(nil, {-.0075}, nil, "Heading_Text_Box", nil, nil, {"headingMode"}, {{ctrl.compareNum, 0, 1}}, "T", nil, strdefs.small)
copyElement(trueHeading, {"init_pos", "controllers", "value"}, {{.0075}, {{ctrl.compareNum, 0, 2}}, "M"})


addUFCDTextParamBox("IAS_Text_Box", {-ADIRadius - .006, ADIRadius - .006}, nil, "ADI_Middle", nil, nil, {"IASWarning"},
					{{ctrl.changeColor, 0, 1, 1, 0, 0}}, true, nil, nil, nil, nil, "IAS", 3, nil, {"%3.0f"}, strdefs.small)

addUFCDTextParam(nil, {-.005, -.006}, nil, "IAS_Text_Box", nil, nil, nil, nil, "BASE_SENSOR_MACH", align.LC, {"%.2f"}, strdefs.small)


addUFCDTextParamBox("Altitude_Text_Box", {ADIRadius + .006, ADIRadius - .006}, nil, "ADI_Middle", nil, nil, {"altTextThousands"},
					{{ctrl.inRange, 0, 0.9, 99}}, true, nil, nil, nil, nil, "altTextThousands", 4.75, align.RC, {"%2.0f"}, strdefs.small)
addUFCDTextParam(nil, {.0065, -.0003}, nil, "Altitude_Text_Box", nil, nil, nil, nil, "altTextHundreds", align.RC, {"%03.0f"}, strdefs.xtraSmall)

addUFCDTextParam(nil, {.0065, .006}, nil, "Altitude_Text_Box", nil, nil, nil, nil, "VSI", align.RC, nil, strdefs.xtraSmall)

addUFCDText(nil, {.0065, -.006}, nil, "Altitude_Text_Box", nil, nil, {"altMode"}, {{ctrl.compareNum, 0, 2}}, "R", align.RC, strdefs.small)


-- addUFCDTextParam("G_Readout", {-ADIRadius - .011, ADIRadius + .0075}, nil, "ADI_Middle", nil, nil, {"GWarning"}, {{ctrl.changeColor,0, 1, 1, 0, 0}}, "BASE_SENSOR_VERTICAL_ACCEL", align.LC, {"G:%.1f"}, strdefs.small)
-- addUFCDTextParam(nil, {0, -.005}, nil, "G_Readout", nil, nil, {"AoAWarning"}, {{ctrl.changeColor,0, 1, 1, 0, 0}}, "AoA", align.LC, {"A:%.1f"}, strdefs.small)



addUFCDSimple("ADI_Yaw", {0, -ADIRadius - .008}, nil, "ADI_Middle")

addUFCDSimpleLine(nil, nil, nil, "ADI_Yaw", nil, nil, {"BASE_SENSOR_LATERAL_ACCEL"}, {{ctrl.moveX, 0, -.012}}, lineThickness / 2,
				  {{-.0035, -.0035}, {.0035, -.0035}, {.0035, .0035}, {-.0035, .0035}, {-.0035, -.0035}}, materials["white"])
local ADI_Yaw_Left_Line = addUFCDSimpleLine(nil, {-.006}, nil, "ADI_Yaw", nil, nil, nil, nil, lineThickness / 2, {{0, -.005}, {0, .005}}, materials["white"])
copyElement(ADI_Yaw_Left_Line, {"init_pos"}, {{.006}})


addUFCDTextParam("G_Readout", {-ADIRadius - .0075}, nil, "ADI_Yaw", nil, nil, {"GWarning"}, {{ctrl.changeColor, 0, 1, 1, 0, 0}},
				 "BASE_SENSOR_VERTICAL_ACCEL", align.LC, {"G:%.1f"}, strdefs.small)
addUFCDTextParam(nil, {ADIRadius - .005}, nil, "ADI_Yaw", nil, nil, {"AoAWarning"}, {{ctrl.changeColor, 0, 1, 1, 0, 0}}, "AoA", align.LC, {"A:%.1f"},
				 strdefs.small)



-- ========== TACT page ==========
addUFCDSimple("TACT_Base", nil, nil, "Right_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.inRange, 0, 1.9, 3}})


addUFCDTextBox(nil, OSB6Text, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.compareNum, 0, 2}}, true, nil, nil, nil, nil, "TACT")

addUFCDText("TACT_OSB_Text", OSB6Text, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.inRange, 0, 2, 2.2}}, "TACT")
addUFCDTextBox(nil, {0, .008}, nil, "TACT_OSB_Text", nil, nil, nil, nil, true, nil, nil, nil, nil, "SMS")

addUFCDText(nil, {width / 4 - .0015, medSideOSBTextY}, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.compareNum, 0, 2}}, [[S
M
S]], align.RC)

addUFCDText(nil, {width / 4 - .0015, medSideOSBTextY}, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.inRange, 0, 2, 2.2}}, [[S
W
C
H]], align.RC)
addUFCDText(nil, {width / 4 - .0015, highSideOSBTextY - .0035}, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.inRange, 0, 2, 2.2}}, [[I
N
C]], align.RC)
-- The DEC OSB button text is after the aircraft outline to clip it.



addUFCDTextBox(nil, {-width / 5, height / 3 + .002}, nil, "TACT_Base", nil, nil, {"masterArm"}, {{ctrl.compareNum, 0, 0}}, false, nil, nil, nil, materials["orange"], "ARM", nil, nil, fonts["black"])


addUFCDTextParamBox(nil, {width / 6 - .0035, height / 3 + .002}, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.changeColor, 0, 2.1, 0, 0, 1}}, true, nil, nil, nil, nil, "WPNStatusMSG", 8, nil, {"%s"}, strdefs.small)



addUFCDSimpleLine(nil, nil, nil, "TACT_Base", nil, nil, nil, nil, nil, {{-width / 4, -height / 3}, {-width / 12}, {0, 1.5 * height}, {width / 12}, {width / 4, -height / 3}}) -- width / 24 + .0006 + lineThickness * 4
addUFCDTextBox(nil, {width / 4 - .0015, lowSideOSBTextY}, nil, "TACT_Base", nil, nil, {"UFCDRightPage"}, {{ctrl.inRange, 0, 2, 2.2}}, false, nil, -(width / 24 + .0006), .010 - .0006 + lineThickness * 4, nil, [[D
E
C]], align.RC) -- Has to be after the aircraft outline to clip it.


-- Gun icon
local gunWidth         = height / 16
local gunHeight        = width / 11
local gunHalfBoxWidth  = gunWidth / 2 - lineThickness * 2
local gunHalfBoxHeight = gunHeight / 2 - lineThickness * 2
addUFCDBox("Gun_Background", {width / 12 - .001, height / 12 * 2}, nil, "TACT_Base", nil, nil, nil, nil, gunWidth, gunHeight, materials["background"])

addUFCDSimpleLine(nil, nil, nil, "Gun_Background", nil, nil, {"gunMode", "gunDoorMoving"},
				  {{ctrl.changeColor, 0, 1, 0, 1, 0}, {ctrl.changeColor, 1, 1, 1, .3529, 0}}, nil,
				  {{-gunHalfBoxWidth, -gunHalfBoxHeight}, {-gunHalfBoxWidth, gunHalfBoxHeight}, {gunHalfBoxWidth, gunHalfBoxHeight}, {gunHalfBoxWidth, -gunHalfBoxHeight}, {-gunHalfBoxWidth, -gunHalfBoxHeight}},
				  materials["white"])
addUFCDCircle(nil, {0, -gunHalfBoxHeight + gunHalfBoxWidth + lineThickness}, nil, "Gun_Background", nil, nil, {"gunMode"},
			  {{ctrl.changeColor, 0, 1, 0, 1, 0}}, gunHalfBoxWidth + lineThickness * 1.5, gunHalfBoxWidth, 360, 15, materials["white"])



local SWXOffset = width / 60
local SWHalfHeight = height / 7
local SWHalfInnerBoxWidth = SWXOffset * 2 + lineThickness / 2
local SWHalfInnerBoxHeight = SWHalfHeight + lineThickness * 1.5
local SWHalfOuterBoxWidth = SWHalfInnerBoxWidth + lineThickness * 1.5
local SWHalfOuterBoxHeight = SWHalfInnerBoxHeight + lineThickness * 1.5

addUFCDSimple("SW_Base", {0, height / 9 - lineThickness * 2}, nil, "TACT_Base")

addUFCDTex(nil, {-SWXOffset}, nil, "SW_Base", nil, nil, {"leftSWColor"}, {{ctrl.inRange, 0, -.1, 2.1}, {ctrl.changeColor, 0, 1, 0, 1, 0}}, missileIcons, 845, 1, 1001, 1040, .45)
addUFCDTex(nil, {-SWXOffset}, nil, "SW_Base", nil, nil, {"nextSW", "leftSWColor"}, {{ctrl.compareNum, 0, 1}, {ctrl.changeColor, 0, 1, 0, 1, 0}, {ctrl.changeColor, 1, 2, 1, .3529, 0}}, missileIcons, 577, 1, 733, 1040, .45)
local leftSWText = addUFCDText(nil, {-SWXOffset}, nil, "SW_Base", nil, nil, {"leftSWColor"}, {{ctrl.compareNum, 0, -1}}, "0", nil, nil, fonts["red"])

addUFCDTex(nil, {SWXOffset}, nil, "SW_Base", nil, nil, {"rightSWColor"}, {{ctrl.inRange, 0, -.1, 2.1}, {ctrl.changeColor, 0, 1, 0, 1, 0}}, missileIcons, 845, 1, 1001, 1040, .45)
addUFCDTex(nil, {SWXOffset}, nil, "SW_Base", nil, nil, {"nextSW", "rightSWColor"}, {{ctrl.compareNum, 0, 2}, {ctrl.changeColor, 0, 2, 0, 1, 0}, {ctrl.changeColor, 1, 2, 1, .3529, 0}}, missileIcons, 577, 1, 733, 1040, .45)
copyElement(leftSWText, {"init_pos", "element_params"}, {{SWXOffset}, {"rightSWColor"}})


local SWInnerBox = addUFCDSimpleLine(nil, nil, nil, "SW_Base", nil, nil, {"SRBMoving"}, {{ctrl.inRange, 0, 0.9, 2.1}}, nil, {{-SWHalfInnerBoxWidth, -SWHalfInnerBoxHeight}, {-SWHalfInnerBoxWidth, SWHalfInnerBoxHeight}, {SWHalfInnerBoxWidth, SWHalfInnerBoxHeight}, {SWHalfInnerBoxWidth, -SWHalfInnerBoxHeight}, {-SWHalfInnerBoxWidth, -SWHalfInnerBoxHeight}}, materials["orange"])
copyElement(SWInnerBox, {"controllers", "vertices"}, {{{ctrl.compareNum, 0, 2}}, {{-SWHalfOuterBoxWidth, -SWHalfOuterBoxHeight}, {-SWHalfOuterBoxWidth, SWHalfOuterBoxHeight}, {SWHalfOuterBoxWidth, SWHalfOuterBoxHeight}, {SWHalfOuterBoxWidth, -SWHalfOuterBoxHeight}, {-SWHalfOuterBoxWidth, -SWHalfOuterBoxHeight}}})


local AMRAAMXOffset = SWXOffset * 2
local AMRAAMHalfHeight = height / 6
local AMRAAMHalfInnerBoxWidth = AMRAAMXOffset * 1.5 + lineThickness
local AMRAAMHalfInnerBoxHeight = AMRAAMHalfHeight + lineThickness * 3.5
local AMRAAMHalfOuterBoxWidth = AMRAAMHalfInnerBoxWidth + lineThickness * 1.5
local AMRAAMHalfOuterBoxHeight = AMRAAMHalfInnerBoxHeight + lineThickness * 1.5

addUFCDSimple("AMRAAM_Base", {0, -height / 4 - .0025}, nil, "TACT_Base")

addUFCDTex(nil, {-AMRAAMXOffset}, nil, "AMRAAM_Base", nil, nil, {"leftAMRAAMNext", "leftAMRAAMColor"}, {{ctrl.inRange, 0, 0}, {ctrl.inRange, 1, -.1, 2.1}}, missileIcons, 52, 1, 197, 1040, .575)
addUFCDTex(nil, {-AMRAAMXOffset}, nil, "AMRAAM_Base", nil, nil, {"nextAMRAAM", "leftAMRAAMColor"}, {{ctrl.compareNum, 0, 1}, {ctrl.changeColor, 0, 1, 0, 1, 0}, {ctrl.changeColor, 1, 2, 1, .3529, 0}}, missileIcons, 310, 1, 463, 1040, .575)
local leftAMRAAMText      = addUFCDTextParam(nil, {-AMRAAMXOffset, -.00025}, nil, "AMRAAM_Base", nil, nil, {"leftAMRAAMCount"}, {{ctrl.inRange, 0, 0, 2.1}, {ctrl.changeColor, 0, 0, 1, 0, 0}}, "leftAMRAAMCount", nil, nil, strdefs.AMRAAMCount)
local leftAMRAAMEmptyText = addUFCDText(nil, {-AMRAAMXOffset, -.00025}, nil, "AMRAAM_Base", nil, nil, {"leftAMRAAMCount"}, {{ctrl.compareNum, 0, 0}}, "0", nil, nil, fonts["red"])

addUFCDTex(nil, nil, nil, "AMRAAM_Base", nil, nil, {"centerAMRAAMNext", "centerAMRAAMColor"}, {{ctrl.compareNum, 0, 0}, {ctrl.inRange, 1, -.1, 2.1}, {ctrl.changeColor, 1, 1, 0, 1, 0}}, missileIcons, 52, 1, 197, 1040, .575)
addUFCDTex(nil, nil, nil, "AMRAAM_Base", nil, nil, {"nextAMRAAM", "centerAMRAAMColor"}, {{ctrl.compareNum, 0, 2}, {ctrl.changeColor, 0, 2, 0, 1, 0}, {ctrl.changeColor, 1, 2, 1, .3529, 0}}, missileIcons, 310, 1, 463, 1040, .575)
copyElement(leftAMRAAMText, {"init_pos", "element_params"}, {{0, -.00025}, {"centerAMRAAMCount", "centerAMRAAMCount"}})
copyElement(leftAMRAAMEmptyText, {"init_pos", "element_params"}, {{0, -.00025}, {"centerAMRAAMCount"}})

addUFCDTex(nil, {AMRAAMXOffset}, nil, "AMRAAM_Base", nil, nil, {"rightAMRAAMNext", "rightAMRAAMColor"}, {{ctrl.compareNum, 0, 0}, {ctrl.inRange, 1, -.1, 2.1}, {ctrl.changeColor, 1, 1, 0, 1, 0}}, missileIcons, 52, 1, 197, 1040, .575)
addUFCDTex(nil, {AMRAAMXOffset}, nil, "AMRAAM_Base", nil, nil, {"nextAMRAAM", "rightAMRAAMColor"}, {{ctrl.compareNum, 0, 3}, {ctrl.changeColor, 0, 3, 0, 1, 0}, {ctrl.changeColor, 1, 2, 1, .3529, 0}}, missileIcons, 310, 1, 463, 1040, .575)
copyElement(leftAMRAAMText, {"init_pos", "element_params"}, {{AMRAAMXOffset, -.00025}, {"rightAMRAAMCount", "rightAMRAAMCount"}})
copyElement(leftAMRAAMEmptyText, {"init_pos", "element_params"}, {{AMRAAMXOffset, -.00025}, {"rightAMRAAMCount"}})


local AMRAAMInnerBox = addUFCDSimpleLine(nil, nil, nil, "AMRAAM_Base", nil, nil, {"MWBMoving"}, {{ctrl.inRange, 0, 0.9, 2.1}}, nil, {{-AMRAAMHalfInnerBoxWidth, -AMRAAMHalfInnerBoxHeight}, {-AMRAAMHalfInnerBoxWidth, AMRAAMHalfInnerBoxHeight}, {AMRAAMHalfInnerBoxWidth, AMRAAMHalfInnerBoxHeight}, {AMRAAMHalfInnerBoxWidth, -AMRAAMHalfInnerBoxHeight}, {-AMRAAMHalfInnerBoxWidth, -AMRAAMHalfInnerBoxHeight}}, materials["orange"])
copyElement(AMRAAMInnerBox, {"controllers", "vertices"}, {{{ctrl.compareNum, 0, 2}}, {{-AMRAAMHalfOuterBoxWidth, -AMRAAMHalfOuterBoxHeight}, {-AMRAAMHalfOuterBoxWidth, AMRAAMHalfOuterBoxHeight}, {AMRAAMHalfOuterBoxWidth, AMRAAMHalfOuterBoxHeight}, {AMRAAMHalfOuterBoxWidth, -AMRAAMHalfOuterBoxHeight}, {-AMRAAMHalfOuterBoxWidth, -AMRAAMHalfOuterBoxHeight}}})



-- CMs
addUFCDTextParamBox("ECM_Box", {0, height / 2.7}, nil, "TACT_Base", nil, nil, {"ECMState"}, {{ctrl.changeColor, 0, 1, 1, .3529, 0}}, true,
					materials["green"], nil, 3 * (.002 / 2 + .0006) + .0012 - lineThickness * 2, nil, "ECMText", 3, nil, {"%s"}, strdefs.small)
local ECMText = addUFCDText(nil, {0, -(3 * (.002 / 2 + .0006)) - .003}, nil, "ECM_Box", nil, nil, nil, nil, "ECM", nil, strdefs.small)


addUFCDTextParamBox("Chaff_Box", {-width / 9, -height / 5}, nil, "TACT_Base", nil, nil, {"chaffColor"},
					{{ctrl.changeColor, 0, -1, 1, 0, 0}, {ctrl.changeColor, 0, 2, 0, 0, 1}}, true, materials["green"], nil,
					3 * (.002 / 2 + .0006) + .0012 - lineThickness * 2, nil, "chaffCount", 3, nil, nil, strdefs.small)
copyElement(ECMText, {"parent_element", "value"}, {"Chaff_Box", "CHF"})

addUFCDTextParamBox("Flare_Box", {width / 9, -height / 5}, nil, "TACT_Base", nil, nil, {"flareColor"},
					{{ctrl.changeColor, 0, -1, 1, 0, 0}, {ctrl.changeColor, 0, 2, 0, 0, 1}}, true, materials["green"], nil,
					3 * (.002 / 2 + .0006) + .0012 - lineThickness * 2, nil, "flareCount", 3, nil, nil, strdefs.small)
copyElement(ECMText, {"parent_element", "value"}, {"Flare_Box", "FLR"})



local modes = {"NAV", "BVR", "VS", "BORE", "HMD", "LGNT", "A/G"}
for i = 1, #modes do
	addUFCDText(nil, {width / 4 - .0005, -height / 2 + .003}, nil, "TACT_Base", nil, nil, {"masterMode"}, {{ctrl.compareNum, 0, i}}, modes[i], align.RC)
end