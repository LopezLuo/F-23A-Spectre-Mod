dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "UFD/Indicator/UFD_Defs.lua")



base = "UFD_Left_Base"



addUFDBox(nil, nil, nil, nil, hcr.rw, lvls.noclip, {"UFDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["green"], true)  -- Mask for clipping.
addUFDBox(nil, nil, nil, nil, hcr.incIf, lvls.noclip, {"UFDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["background"]) -- Mask for clipping and background.



addUFDSimple(base, nil, nil, nil, nil, nil, {"UFDPower"}, {{ctrl.compareNum, 0, 1}})


addUFDTextParam(nil, {width / 2 - .010, -height / 2 + .004}, nil, base, nil, nil, {"leftUFDPage"}, {{ctrl.inRange, 0, -.1, 2}}, "clock", nil, {"%s"}, strdefs.xtraSmall)



dofile(LockOn_Options.script_path .. "UFD/Indicator/Left/UFD_Left_Indication_Page.lua")