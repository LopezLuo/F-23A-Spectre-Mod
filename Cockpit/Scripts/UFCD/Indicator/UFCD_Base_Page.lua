dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "UFCD/Indicator/UFCD_Defs.lua")



addUFCDBox(nil, nil, nil, nil, hcr.rw, lvls.noclip, {"UFCDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["green"], true)  -- Mask for clipping.
addUFCDBox(nil, nil, nil, nil, hcr.incIf, lvls.noclip, {"UFCDPower"}, {{ctrl.compareNum, 0, 1}}, width, height, materials["background"]) -- Mask for clipping and background.



addUFCDSimple(base, center, nil, nil, nil, nil, {"UFCDPower"}, {{ctrl.compareNum, 0, 1}}) -- Base for both sides.



dofile(LockOn_Options.script_path .. "UFCD/Indicator/UFCD_Indication_Page.lua")