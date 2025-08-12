dofile(LockOn_Options.common_script_path .. "ViewportHandling.lua")
dofile(LockOn_Options.common_script_path .. "devices_defs.lua")



indicator_type = indicator_types.COMMON
purposes       = {render_purpose.GENERAL, render_purpose.MFD_ONLY_VIEW}


base = 1

page_subsets = {[base] = LockOn_Options.script_path .. "UFD/Indicator/Right/UFD_Right_Base_Page.lua"}
pages        = {{base}}



init_pageID = 1