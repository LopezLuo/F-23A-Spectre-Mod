dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "UFD/Indicator/UFD_Defs.lua")



local center = {0, 0, -.0001} -- TODO: Fix connectors please. They are a bit inside of the screen.
base = "UFD_Right_Base"



addUFDBox(nil, center, nil, nil, hcr.rw, lvls.noclip, {"UFDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["green"], true)  -- Mask for clipping.
addUFDBox(nil, center, nil, nil, hcr.incIf, lvls.noclip, {"UFDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["background"]) -- Mask for clipping and background.



addUFDSimple(base, center, nil, nil, nil, nil, {"UFDPower"}, {{ctrl.compareNum, 0, 1}})


addUFDTextParam(nil, {width / 2 - .010, -height / 2 + .004}, nil, base, nil, nil, {"leftUFDPage"}, {{ctrl.inRange, 0, -.1, 2}}, "clock", nil, {"%s"}, strdefs.xtraSmall)



dofile(LockOn_Options.script_path .. "UFD/Indicator/Right/UFD_Right_Indication_Page.lua")