dofile(LockOn_Options.script_path .. "clickable_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")


cursor_mode = {
	CUMODE_CLICKABLE            = 0,
	CUMODE_CLICKABLE_AND_CAMERA = 1,
	CUMODE_CAMERA               = 2
}
clickable_mode_initial_status = cursor_mode.CUMODE_CLICKABLE
use_pointer_name = true
anim_speed_default = 16

local gettext = require("i_18n")
_ = gettext.translate

elements = {}


-- ========= Left Side Panel ===============  >>>Device == vms<<<

elements["CONSOLE_PNT"]  = default_axis_limited(_("Console Brightness"), devices.lights, deviceCommands.Console_Brightness, 710)
elements["INST_PNL_PNT"] = default_axis_limited(_("INST Brightness"), devices.lights, deviceCommands.INST_Brightness, 711)
elements["DISPLAY_PNT"]  = default_axis_limited(_("Display Brightness"), devices.lights, deviceCommands.DISPLAY_Brightness, 712)
elements["FLOOD_PNT"]    = default_axis_limited(_("Flood Brightness"), devices.lights, deviceCommands.FLOOD_Brightness, 713)
elements["MODE_PNT"]     = default_3_position_tumb(_("Day/Night/NVG Mode"), devices.lights, deviceCommands.MODE_Selector, 714)    -- this probably isn't set up correctly
elements["POSITION_PNT"] = default_2_position_tumb(_("Position Lights"), devices.lights, deviceCommands.POSTITION_Selector, 715)
elements["BEACON_PNT"]   = default_2_position_tumb(_("Anti-Collision Lights"), devices.lights, deviceCommands.BEACON_Selector, 716)
elements["FORM_PNT"]     = default_axis_limited(_("Formation Brightness"), devices.lights, deviceCommands.FORM_Brightness, 717)

elements["MTR_PNT"]        = default_2_position_tumb(_("Motor Cover Guard"), devices.vms, deviceCommands.MTR_Selector, 718)
elements["MOTOR_PNT"]      = default_2_position_tumb(_("Motor Switch"), devices.vms, deviceCommands.MOTOR_Selector, 719)
elements["ENGINE_PNT"]     = default_3_position_tumb(_("Engine Selector"), devices.vms, deviceCommands.ENGINE_Selector, 720)
elements["TANKS_PNT"]      = default_2_position_tumb(_("EXT/INT Fuel Selector"), devices.vms, deviceCommands.TANKS_Selector, 721)
elements["AAR_LIGHT_PNT"]  = default_axis_limited(_("AAR Light"), devices.vms, deviceCommands.AAR_LIGHT_Brightness, 722)
elements["AAR_DOOR_PNT"]   = default_2_position_tumb(_("AAR Door"), devices.vms, deviceCommands.AAR_DOOR_Selector, 723)
elements["FLCS_COVER_PNT"] = default_2_position_tumb(_("FLCS Cover Guard"), devices.vms, deviceCommands.FLCS_COVER_Selector, 724)
elements["FLCS_PNT"]       = default_2_position_tumb(_("FLCS Test Switch"), devices.flcs, deviceCommands.FLCS_Selector, 725)
-- elements["FLCS_PNT"] 		= springloaded_2_position_tumb(_("FLCS Test Switch"),	devices.flcs,           deviceCommands.FLCS_Selector, 			    725)
elements["CAN_JET_PNT"]    = default_2_position_tumb(_("Canopy Jettison"), devices.vms, deviceCommands.CAN_JET_Selector, 726)

-- ========= Instrument Panel ===============

elements["LDG_LIGHT_PNT"] = default_3_position_tumb(_("Landing/Taxi Switch"), devices.lights, deviceCommands.LDG_LIGHT_Selector, 727)
-- elements["GEAR_PNT"]        = default_2_position_tumb(_("Gear Lever"),              devices.vms,            deviceCommands.gear_lever,                 1003)	-- feature put on hold for now

elements["PTJ_PNT"] = Mfd_button(_("Emergency Jettison"), devices.vms, deviceCommands.PTJ_Selector, 728)
elements["BAT_PNT"] = default_2_position_tumb(_("Battery Switch"), devices.electricalSystem, deviceCommands.batSwitch, 877)

elements["ARM_PNT"] = default_2_position_tumb(_("Master Arm"), devices.MWB, deviceCommands.arm_switch, 729)

-- ========= Right Side Panel  ===============

elements["APU_PNT"]         = default_2_position_tumb(_("APU Switch"), devices.vms, deviceCommands.APU_switch, 874)
elements["L_GEN_PNT"]       = default_2_position_tumb(_("Left Gen"), devices.electricalSystem, deviceCommands.LGenSwitch, 873)
elements["R_GEN_PNT"]       = default_2_position_tumb(_("Right Gen"), devices.electricalSystem, deviceCommands.RGenSwitch, 875)
elements["PARK_BK_PNT"]     = default_3_position_tumb(_("Brake Switch"), devices.brakes, deviceCommands.ParkingBrake, 878)
elements["O2_PNT"]          = default_2_position_tumb(_("O2 Switch"), devices.inst_pnl, deviceCommands.O2, 880)
elements["OBOGS_PNT"]       = default_2_position_tumb(_("OBOGS Switch"), devices.inst_pnl, deviceCommands.OBOGS, 881)
elements["L_AUX_VOL_PNT"]   = default_axis_limited(_("Left AUX vol"), devices.inst_pnl, deviceCommands.L_aux_vol, 883)
elements["R_AUX_VOL_PNT"]   = default_axis_limited(_("Right AUX vol"), devices.inst_pnl, deviceCommands.R_aux_vol, 884)
elements["AUX_MODE_PNT"]    = default_axis_limited(_("AUX Mode Switch"), devices.inst_pnl, deviceCommands.aux_mode, 885)
elements["AUX_BRT_PNT"]     = default_axis_limited(_("AUX Brightness"), devices.inst_pnl, deviceCommands.aux_brt, 886)
elements["AUX_VOX_PNT"]     = default_axis_limited(_("AUX Vox Vol"), devices.inst_pnl, deviceCommands.aux_vox, 887)
elements["AUX_RCN_PNT"]     = default_axis_limited(_("AUX RCN"), devices.inst_pnl, deviceCommands.aux_rcn, 888)
elements["AUX_AUX_PNT"]     = default_axis_limited(_("AUX AUX"), devices.inst_pnl, deviceCommands.aux_aux, 889)
elements["ECS_TEMP_PNT"]    = default_axis_limited(_("ECS Temp"), devices.inst_pnl, deviceCommands.ecs_temp, 891)
elements["ECS_FLOW_PNT"]    = default_axis_limited(_("ECS Flow"), devices.inst_pnl, deviceCommands.ecs_flow, 892)
elements["ECS_AUT_MAN_PNT"] = default_2_position_tumb(_("ECS Auto/Manual"), devices.inst_pnl, deviceCommands.ecs_aut_man, 893)
elements["ECS_RATE_PNT"]    = default_axis_limited(_("ECS Rate"), devices.inst_pnl, deviceCommands.ecs_rate, 894)


-- ========= Instrument Panel [Keypad] ===============
elements["KB_1_PNT"]    = Mfd_button(_("AP"), devices.inst_pnl, deviceCommands.KB_1, 730)
elements["KB_2_PNT"]    = Mfd_button(_("Mark"), devices.inst_pnl, deviceCommands.KB_2, 731)
elements["KB_3_PNT"]    = Mfd_button(_("GREC"), devices.inst_pnl, deviceCommands.KB_3, 732)
elements["KB_4_PNT"]    = Mfd_button(_("A/1"), devices.inst_pnl, deviceCommands.KB_4, 733)
elements["KB_5_PNT"]    = Mfd_button(_("N/2"), devices.inst_pnl, deviceCommands.KB_5, 734)
elements["KB_6_PNT"]    = Mfd_button(_("B/3"), devices.inst_pnl, deviceCommands.KB_6, 735)
elements["KB_7_PNT"]    = Mfd_button(_("W/4"), devices.inst_pnl, deviceCommands.KB_7, 736)
elements["KB_8_PNT"]    = Mfd_button(_("M/5"), devices.inst_pnl, deviceCommands.KB_8, 737)
elements["KB_9_PNT"]    = Mfd_button(_("E/6"), devices.inst_pnl, deviceCommands.KB_9, 738)
elements["KB_10_PNT"]   = Mfd_button(_(":/7"), devices.inst_pnl, deviceCommands.KB_10, 739)
elements["KB_11_PNT"]   = Mfd_button(_("S/8"), devices.inst_pnl, deviceCommands.KB_11, 740)
elements["KB_12_PNT"]   = Mfd_button(_("C/9"), devices.inst_pnl, deviceCommands.KB_12, 741)
elements["KB_13_PNT"]   = Mfd_button(_("."), devices.inst_pnl, deviceCommands.KB_13, 742)
elements["KB_14_PNT"]   = Mfd_button(_("-/0"), devices.inst_pnl, deviceCommands.KB_14, 743)
elements["KB_15_PNT"]   = Mfd_button(_("CLR"), devices.inst_pnl, deviceCommands.KB_15, 744)
elements["KB_16_PNT"]   = Mfd_button(_("I/P"), devices.inst_pnl, deviceCommands.KB_16, 745)
elements["KB_17_PNT"]   = Mfd_button(_("SHF"), devices.inst_pnl, deviceCommands.KB_17, 746)
elements["KB_18_PNT"]   = Mfd_button(_("GREC"), devices.inst_pnl, deviceCommands.KB_18, 747)
elements["KB_19_PNT"]   = Mfd_button(_("DATA"), devices.inst_pnl, deviceCommands.KB_19, 748)
elements["KB_20_PNT"]   = Mfd_button(_("MENU"), devices.inst_pnl, deviceCommands.KB_20, 749)
elements["KB_KB_1_PNT"] = default_axis(_("L Tune"), devices.inst_pnl, deviceCommands.KB_21, 750)
elements["KB_KB_2_PNT"] = default_axis(_("R Tune"), devices.inst_pnl, deviceCommands.KB_22, 751)

-- ========= Instrument Panel [Left Sub-panel] ===============

elements["L_SP_DN_PNT"]  = default_2_position_tumb(_("Day/Night"), devices.inst_pnl, deviceCommands.day_night_switch, 774)
elements["L_SP_OVK_PNT"] = default_axis(_("R1 Vol"), devices.inst_pnl, deviceCommands.r1_vol_knob, 775)
elements["L_SP_IVK_PNT"] = default_axis(_("R3 Vol"), devices.inst_pnl, deviceCommands.r3_vol_knob, 776)

-- ========= Instrument Panel [Left Sub-panel] ===============

elements["R_SP_OVK_PNT"] = default_axis(_("R2 Vol"), devices.inst_pnl, deviceCommands.r2_vol_knob, 800)
elements["R_SP_IVK_PNT"] = default_axis(_("R4 Vol"), devices.inst_pnl, deviceCommands.r4_vol_knob, 801)
elements["R_SP_HB_PNT"]  = default_axis_limited(_("Brightness"), devices.inst_pnl, deviceCommands.hud_bright, 802)

-- ========= Displays [Left MFD] ===============

elements["L_MFD_1_PNT"]  = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.l_osb_1, 805)
elements["L_MFD_2_PNT"]  = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.l_osb_2, 806)
elements["L_MFD_3_PNT"]  = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.l_osb_3, 807)
elements["L_MFD_4_PNT"]  = Mfd_button(_("OSB 4"), devices.displays, deviceCommands.l_osb_4, 808)
elements["L_MFD_5_PNT"]  = Mfd_button(_("OSB 5"), devices.displays, deviceCommands.l_osb_5, 809)
elements["L_MFD_6_PNT"]  = Mfd_button(_("OSB 6"), devices.displays, deviceCommands.l_osb_6, 810)
elements["L_MFD_7_PNT"]  = Mfd_button(_("OSB 7"), devices.displays, deviceCommands.l_osb_7, 811)
elements["L_MFD_8_PNT"]  = Mfd_button(_("OSB 8"), devices.displays, deviceCommands.l_osb_8, 812)
elements["L_MFD_9_PNT"]  = Mfd_button(_("OSB 9"), devices.displays, deviceCommands.l_osb_9, 813)
elements["L_MFD_10_PNT"] = Mfd_button(_("OSB 10"), devices.displays, deviceCommands.l_osb_10, 814)
elements["L_MFD_11_PNT"] = Mfd_button(_("OSB 11"), devices.displays, deviceCommands.l_osb_11, 815)
elements["L_MFD_12_PNT"] = Mfd_button(_("OSB 12"), devices.displays, deviceCommands.l_osb_12, 816)
elements["L_MFD_13_PNT"] = Mfd_button(_("OSB 13"), devices.displays, deviceCommands.l_osb_13, 817)
elements["L_MFD_14_PNT"] = Mfd_button(_("OSB 14"), devices.displays, deviceCommands.l_osb_14, 818)
elements["L_MFD_15_PNT"] = Mfd_button(_("OSB 15"), devices.displays, deviceCommands.l_osb_15, 819)
elements["L_MFD_16_PNT"] = Mfd_button(_("OSB 16"), devices.displays, deviceCommands.l_osb_16, 820)
elements["L_MFD_17_PNT"] = Mfd_button(_("OSB 17"), devices.displays, deviceCommands.l_osb_17, 821)
elements["L_MFD_18_PNT"] = Mfd_button(_("OSB 18"), devices.displays, deviceCommands.l_osb_18, 822)
-- elements["L_MFD_2_PNT"] 	= Mfd_button(_("OSB 2"), 				                 devices.displays,       deviceCommands.l_osb_2, 		        823)   -- TODO: this should be a two position switch


-- ===== Displays [Primary MFD] ===============

elements["P_MFD_1_PNT"]  = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.P_osb_1, 827)
elements["P_MFD_2_PNT"]  = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.P_osb_2, 828)
elements["P_MFD_3_PNT"]  = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.P_osb_3, 829)
elements["P_MFD_4_PNT"]  = Mfd_button(_("OSB 4"), devices.displays, deviceCommands.P_osb_4, 830)
elements["P_MFD_5_PNT"]  = Mfd_button(_("OSB 5"), devices.displays, deviceCommands.P_osb_5, 831)
elements["P_MFD_6_PNT"]  = Mfd_button(_("OSB 6"), devices.displays, deviceCommands.P_osb_6, 832)
elements["P_MFD_7_PNT"]  = Mfd_button(_("OSB 7"), devices.displays, deviceCommands.P_osb_7, 833)
elements["P_MFD_8_PNT"]  = Mfd_button(_("OSB 8"), devices.displays, deviceCommands.P_osb_8, 834)
elements["P_MFD_9_PNT"]  = Mfd_button(_("OSB 9"), devices.displays, deviceCommands.P_osb_9, 835)
elements["P_MFD_10_PNT"] = Mfd_button(_("OSB 10"), devices.displays, deviceCommands.P_osb_10, 836)
elements["P_MFD_11_PNT"] = Mfd_button(_("OSB 11"), devices.displays, deviceCommands.P_osb_11, 837)
elements["P_MFD_12_PNT"] = Mfd_button(_("OSB 12"), devices.displays, deviceCommands.P_osb_12, 838)
elements["P_MFD_13_PNT"] = Mfd_button(_("OSB 13"), devices.displays, deviceCommands.P_osb_13, 839)
elements["P_MFD_14_PNT"] = Mfd_button(_("OSB 14"), devices.displays, deviceCommands.P_osb_14, 840)
elements["P_MFD_15_PNT"] = Mfd_button(_("OSB 15"), devices.displays, deviceCommands.P_osb_15, 841)
elements["P_MFD_16_PNT"] = Mfd_button(_("OSB 16"), devices.displays, deviceCommands.P_osb_16, 842)
elements["P_MFD_17_PNT"] = Mfd_button(_("OSB 17"), devices.displays, deviceCommands.P_osb_17, 843)
elements["P_MFD_18_PNT"] = Mfd_button(_("OSB 18"), devices.displays, deviceCommands.P_osb_18, 844)
elements["P_MFD_19_PNT"] = Mfd_button(_("OSB 19"), devices.displays, deviceCommands.P_osb_19, 845)
elements["P_MFD_20_PNT"] = Mfd_button(_("OSB 20"), devices.displays, deviceCommands.P_osb_20, 846)

-- ===== Displays [Right MFD] ===============

elements["R_MFD_1_PNT"]  = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.R_osb_1, 851)
elements["R_MFD_2_PNT"]  = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.R_osb_2, 852)
elements["R_MFD_3_PNT"]  = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.R_osb_3, 853)
elements["R_MFD_4_PNT"]  = Mfd_button(_("OSB 4"), devices.displays, deviceCommands.R_osb_4, 854)
elements["R_MFD_5_PNT"]  = Mfd_button(_("OSB 5"), devices.displays, deviceCommands.R_osb_5, 855)
elements["R_MFD_6_PNT"]  = Mfd_button(_("OSB 6"), devices.displays, deviceCommands.R_osb_6, 856)
elements["R_MFD_7_PNT"]  = Mfd_button(_("OSB 7"), devices.displays, deviceCommands.R_osb_7, 857)
elements["R_MFD_8_PNT"]  = Mfd_button(_("OSB 8"), devices.displays, deviceCommands.R_osb_8, 858)
elements["R_MFD_9_PNT"]  = Mfd_button(_("OSB 9"), devices.displays, deviceCommands.R_osb_9, 859)
elements["R_MFD_10_PNT"] = Mfd_button(_("OSB 10"), devices.displays, deviceCommands.R_osb_10, 860)
elements["R_MFD_11_PNT"] = Mfd_button(_("OSB 11"), devices.displays, deviceCommands.R_osb_11, 861)
elements["R_MFD_12_PNT"] = Mfd_button(_("OSB 12"), devices.displays, deviceCommands.R_osb_12, 862)
elements["R_MFD_13_PNT"] = Mfd_button(_("OSB 13"), devices.displays, deviceCommands.R_osb_13, 863)
elements["R_MFD_14_PNT"] = Mfd_button(_("OSB 14"), devices.displays, deviceCommands.R_osb_14, 864)
elements["R_MFD_15_PNT"] = Mfd_button(_("OSB 15"), devices.displays, deviceCommands.R_osb_15, 865)
elements["R_MFD_16_PNT"] = Mfd_button(_("OSB 16"), devices.displays, deviceCommands.R_osb_16, 866)
elements["R_MFD_17_PNT"] = Mfd_button(_("OSB 17"), devices.displays, deviceCommands.R_osb_17, 867)
elements["R_MFD_18_PNT"] = Mfd_button(_("OSB 18"), devices.displays, deviceCommands.R_osb_18, 868)

-- ===== Displays [Left UFD] ===============

elements["L_UFD_1_PNT"] = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.L_ufd_1, 770)
elements["L_UFD_2_PNT"] = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.L_ufd_2, 771)
elements["L_UFD_3_PNT"] = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.L_ufd_3, 772)

-- ===== Displays [Right UFD] ===============

elements["R_UFD_1_PNT"] = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.R_ufd_1, 797)
elements["R_UFD_2_PNT"] = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.R_ufd_2, 798)
elements["R_UFD_3_PNT"] = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.R_ufd_3, 799)

-- ===== Displays [Up Front Controller] ===============

elements["UFC_1_PNT"]    = Mfd_button(_("OSB 1"), devices.displays, deviceCommands.U_osb_1, 780)
elements["UFC_2_PNT"]    = Mfd_button(_("OSB 2"), devices.displays, deviceCommands.U_osb_2, 781)
elements["UFC_3_PNT"]    = Mfd_button(_("OSB 3"), devices.displays, deviceCommands.U_osb_3, 782)
elements["UFC_4_PNT"]    = Mfd_button(_("OSB 4"), devices.displays, deviceCommands.U_osb_4, 783)
elements["UFC_5_PNT"]    = Mfd_button(_("OSB 5"), devices.displays, deviceCommands.U_osb_5, 784)
elements["UFC_6_PNT"]    = Mfd_button(_("OSB 6"), devices.displays, deviceCommands.U_osb_6, 785)
elements["UFC_7_PNT"]    = Mfd_button(_("OSB 7"), devices.displays, deviceCommands.U_osb_7, 786)
elements["UFC_8_PNT"]    = Mfd_button(_("OSB 8"), devices.displays, deviceCommands.U_osb_8, 787)
elements["UFC_9_PNT"]    = Mfd_button(_("OSB 9"), devices.displays, deviceCommands.U_osb_9, 788)
elements["UFC_10_PNT"]   = Mfd_button(_("OSB 10"), devices.displays, deviceCommands.U_osb_10, 789)
elements["UFC_AA_PNT"]   = Mfd_button(_("A/A"), devices.FC3, deviceCommands.U_aa, 790)
elements["UFC_AG_PNT"]   = Mfd_button(_("A/G"), devices.FC3, deviceCommands.U_ag, 791)
elements["UFC_NAV_PNT"]  = Mfd_button(_("NAV"), devices.FC3, deviceCommands.U_nav, 792)
elements["UFC_INST_PNT"] = Mfd_button(_("INST"), devices.FC3, deviceCommands.U_inst, 793)