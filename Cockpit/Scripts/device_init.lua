dofile(LockOn_Options.common_script_path .. "tools.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



layoutGeometry = {}

MainPanel = {"ccMainPanel", LockOn_Options.script_path .. "mainpanel_init.lua"}

attributes = {"support_for_cws"}


creators = {}

creators[devices.KNEEBOARD]        = {"avKneeboard", LockOn_Options.common_script_path .. "KNEEBOARD/device/init.lua"}
creators[devices.electricalSystem] = {"avSimpleElectricSystem", LockOn_Options.script_path .. "Systems/Electrical_System.lua"}
creators[devices.MWB]              = {"avLuaDevice", LockOn_Options.script_path .. "Systems/MWB.lua"}
creators[devices.inst_pnl]         = {"avLuaDevice", LockOn_Options.script_path .. "Systems/inst_pnl.lua"}
creators[devices.nozzle]           = {"avLuaDevice", LockOn_Options.script_path .. "Systems/nozzle.lua"}
creators[devices.lights]           = {"avLuaDevice", LockOn_Options.script_path .. "Systems/lights.lua"}
creators[devices.brakes]           = {"avLuaDevice", LockOn_Options.script_path .. "Systems/brakes.lua"}
creators[devices.vms]              = {"avLuaDevice", LockOn_Options.script_path .. "Systems/vms.lua"}
creators[devices.displays]         = {"avLuaDevice", LockOn_Options.script_path .. "Systems/displays.lua"}
creators[devices.UFCD]             = {"avLuaDevice", LockOn_Options.script_path .. "UFCD/Device/UFCD_Device.lua"}
creators[devices.UFD]              = {"avLuaDevice", LockOn_Options.script_path .. "UFD/Device/UFD_Device.lua"}
creators[devices.flcs]             = {"avLuaDevice", LockOn_Options.script_path .. "Systems/flcs.lua"}
creators[devices.fuel]             = {"avLuaDevice", LockOn_Options.script_path .. "Systems/Fuel.lua"}
creators[devices.engine]           = {"avLuaDevice", LockOn_Options.script_path .. "Systems/engine.lua"}
creators[devices.FC3]              = {"avLuaDevice", LockOn_Options.script_path .. "Systems/FC3.lua"}
creators[devices.OP_Phases]        = {"avLuaDevice", LockOn_Options.script_path .. "Systems/Op_Phases.lua"}
creators[devices.countermeasures]  = {"avLuaDevice", LockOn_Options.script_path .. "Systems/countermeasures.lua"}


indicators = {}

indicators[#indicators+1] = {"ccKneeboard", LockOn_Options.common_script_path .. "KNEEBOARD/indicator/init.lua", devices.KNEEBOARD, {{}, {sx_l = -.65, sz_l = .15, sy_l = -.5, ry_l = 10, rz_l = 85, sw = .142 * .5 - .1, sh = .214 * .5 - .1}, nil}}

indicators[#indicators+1] = {"ccIndicator", LockOn_Options.script_path .. "UFCD/Indicator/UFCD_Init.lua", nil,
	{
		{"UFC-CENTER", "UFC-BOTTOM", "UFC-RIGHT"}, -- Initial geometry anchor, triple of connector names.
		{
			sx_l = 0, -- Center position correction in meters (+forward , -backward).
			sy_l = 0, -- Center position correction in meters (+up , -down).
			sz_l = 0, -- Center position correction in meters (-left , +right).
			sh   = 0, -- Half height correction.
			sw   = 0, -- Half width correction.
			rz_l = 0, -- Rotation corrections.
			rx_l = 0,
			ry_l = 0
		}
	}
}

indicators[#indicators+1] = {"ccIndicator", LockOn_Options.script_path .. "UFD/Indicator/Left/UFD_Left_Init.lua", nil,
	{
		{"L-UFD-CENTER", "L-UFD-BOTTOM", "L-UFD-RIGHT"}, -- Initial geometry anchor, triple of connector names.
		{
			sx_l = 0, -- Center position correction in meters (+forward , -backward).
			sy_l = 0, -- Center position correction in meters (+up , -down).
			sz_l = 0, -- Center position correction in meters (-left , +right).
			sh   = 0, -- Half height correction.
			sw   = 0, -- Half width correction.
			rz_l = 0, -- Rotation corrections.
			rx_l = 0,
			ry_l = 0
		}
	}
}

indicators[#indicators+1] = {"ccIndicator", LockOn_Options.script_path .. "UFD/Indicator/Right/UFD_Right_Init.lua", nil,
	{
		{"R-UFD-CENTER", "R-UFD-BOTTOM", "R-UFD-RIGHT"}, -- Initial geometry anchor, triple of connector names.
		{
			sx_l = 0, -- Center position correction in meters (+forward , -backward).
			sy_l = 0, -- Center position correction in meters (+up , -down).
			sz_l = 0, -- Center position correction in meters (-left , +right).
			sh   = 0, -- Half height correction.
			sw   = 0, -- Half width correction.
			rz_l = 0, -- Rotation corrections.
			rx_l = 0,
			ry_l = 0
		}
	}
}
--[[indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."avRadar_example/indicator/init.lua",--init script
 nil,
  {	
	{"RADAR-PLASHKA-CENTER","RADAR-PLASHKA-DOWN","RADAR-PLASHKA-RIGHT"}, -- initial geometry anchor , triple of connector names
	{sx_l =  -.10,  -- center position correction in meters (forward , backward)
	 sy_l =  0,  -- center position correction in meters (up , down)
	 sz_l =  0,  -- center position correction in meters (left , right)
	 sh   =  0,  -- half height correction
	 sw   =  0,  -- half width correction
	 rz_l =  0,  -- rotation corrections
	 rx_l =  0,
	 ry_l =  0}
  }
} ]]

--[[indicators[#indicators + 1] = 	{
	"ccIndicator",
	LockOn_Options.script_path.."avRWR_example/indicator/init.lua",
	nil,
	{	
		{"TEWS-PLASHKA-CENTER","TEWS-PLASHKA-DOWN","TEWS-PLASHKA-RIGHT"},
		{
		sz_l = 0.0,sx_l = 0.0, sy_l =  0.0, rz_1 = 40  -- -0.14	-- -0.3
		},
		1
	}
}		]]