--------------------------------------------
--F-23A mod 0.1 
--------------------------------------------

F_23A =  {
	Name 			= 'F-23A',
	DisplayName		= _('F-23A Blk 20'),													-- version.  First release Blk 20
	Picture 		= "F-23A.png",
	Rate 			= "50",
	Shape			= "F-23A",
	WorldID			=  WSTYPE_PLACEHOLDER, 
	
shape_table_data 	= 
{
	{
		file  	 	= 'F-23A';--AG
		life  	 	= 20; -- lifebar 
		vis   	 	= 2; -- visibility gain.
		desrt    	= 'F-23A_destr'; -- Name of destroyed object file name
		fire  	 	= { 300, 2}; -- Fire on the ground after destoyed: 300sec 2m
		username	= 'F-23A';--AG
		index       =  WSTYPE_PLACEHOLDER;
		classname   = "lLandPlane";
		positioning = "BYNORMAL";
	},
	{
		name  		= "F-23A_destr";
		file  		= "F-23A_destr";
		fire  		= { 240, 2};
	},
},



LandRWCategories = 
	{
	[1] = 
	{
		Name = "AircraftCarrier",
	},
	[2] = 
	{
		Name = "AircraftCarrier With Catapult",
	}, 
	[3] = 
	{
		Name = "AircraftCarrier With Tramplin",
	}, 
},
	TakeOffRWCategories = 
	{
	[1] = 
	{
		Name = "AircraftCarrier",
	},
	[2] = 
	{
		Name = "AircraftCarrier With Catapult",
	}, 
	[3] = 
	{
		Name = "AircraftCarrier With Tramplin",
	}, 
},

Countries = {"USA","USAF Aggressors"},


mapclasskey 		= "P0091000024",
--attribute  			= {wsType_Air, wsType_Airplane, wsType_Fighter, F_15, "Fighters", "Refuelable",},--AG WSTYPE_PLACEHOLDER
attribute  			= {wsType_Air, wsType_Airplane, wsType_Fighter, F_23A, "Fighters", "Refuelable", "Datalink", "Link16"},--AG WSTYPE_PLACEHOLDER
Categories= {"{78EFB7A2-FD52-4b57-A6A6-3BF0E1D6555F}", "Interceptor",},


	M_empty						=	19546, 		-- kg (with pilot and nose load)
	M_nominal					=	29345,  	-- kg (Empty Plus Full Internal Fuel)
	M_max						=	39507, 		-- kg (Maximum Take Off Weight)
	M_fuel_max					=	8870,   	-- kg (Internal Fuel Only)
	H_max						=	22865,  	-- m  (Maximum Operational Ceiling)
	average_fuel_consumption	=	0.2,   		
	CAS_min						=	58,			-- Minimum CAS speed (m/s) (for AI)
	V_opt						=	220,		-- Cruise speed (m/s) (for AI)
	V_take_off					=	61,			-- Take off speed in m/s (for AI)
	V_land						=	71,			-- Land speed in m/s (for AI)
	has_afteburner				=	true,
	has_speedbrake				=	true,
	radar_can_see_ground		=	true,

	
	
	nose_gear_pos 				                =  {6.703, -2.04, 0.0},  		-- nose gear coordiate	CORRECT: {6.703, -1.929, 0.0},
	nose_gear_amortizer_direct_stroke   		=  0.4,      					-- down from nose_gear_pos !!!
	nose_gear_amortizer_reversal_stroke  		= -0.2,      					-- up 
	nose_gear_amortizer_normal_weight_stroke 	= -0.2,      					-- down from nose_gear_pos
	nose_gear_wheel_diameter 	                =  0.533,  						-- in m CORRECT 0.533

	main_gear_pos 						 	    = {-1.876,	-2.24,	1.912},		--  main gear coord		CORRECT: {-1.876,	-2.124,	1.912},
	main_gear_amortizer_direct_stroke	 	    =   0.4,     					--  down from main_gear_pos !!!
	main_gear_amortizer_reversal_stroke  	    =  -0.35,     					--  up 
	main_gear_amortizer_normal_weight_stroke  	=  -0.2,     					--  down from main_gear_pos
	main_gear_wheel_diameter 				    =  0.913, 						--  in m CORRECT: 0.913, 
	

	effects_presets =   { 
						{effect = "OVERWING_VAPOR", file = current_mod_path.."/Effects/F-23A_overwingVapor.lua"},
						},
						

	AOA_take_off				=	0.16,									-- AoA in take off (for AI)
	stores_number				=	11,										-- TODO: correct stores numbers
	bank_angle_max				=	60,										-- Max bank angle (for AI)
	Ny_min						=	-3,										-- Min G (for AI)
	Ny_max						=	8,										-- Max G (for AI)
	tand_gear_max				=	3.73,									-- TODO figure out what this is for. "XX  FA18 3.73," 
	V_max_sea_level				=	411,									-- Max speed at sea level in m/s (for AI)
	V_max_h						=	700,									-- Max speed at max altitude in m/s (for AI)
	wing_area					=	88.26,  								-- wing area in m2
	thrust_sum_max				=	21318,  								-- thrust in kgf (64.3 kN)
	thrust_sum_ab				=	31751, 									-- thrust in kgf (95.1 kN)
	Vy_max						=	275,									-- Max climb speed in m/s (for AI)
	flaps_maneuver				=	1,
	Mach_max					=	2.25,									-- Max speed in Mach (for AI)
	range						=	2540,									-- Max range in km (for AI)
	RCS							=	0.0010,									-- Radar Cross Section m2 (-30 dBsm)
	Ny_max_e					=	8,										-- Max G (for AI)
	detection_range_max			=	900,    								-- Radar detection range against a large target. Range bumped to simulate AESA detection ranges.
	IR_emission_coeff			=	0.25,									-- Normal engine -- IR_emission_coeff = 1 is Su-27 without afterburner. It is reference..
	IR_emission_coeff_ab		=	0.5,									-- With afterburner
	tanker_type					=	1, 										-- F14=2/S33=4/M29=0/S27=0/F15=1/F16=1/To=0/F18=2/A10A=1/M29K=4/M2000=2/F4=0/F5=0/
	wing_span					=	13.28,									-- XX  wing span in m 
	wing_type 					= 	1, 										-- 0=FIXED_WING/ 1=VARIABLE_GEOMETRY/ 2=FOLDED_WING/ 3=ARIABLE_GEOMETRY_FOLDED
	length						=	20.99,									-- Length in meters (actual lenght is 21.47m. This allows more parking options)
	height						=	4.47,									-- Height in meters
	crew_size					=	1, 										-- XX
	engines_count				=	2, 										-- XX
	wing_tip_pos 				= 	{-1.87,	0.0, 6.647},					-- wingtip coords for visual effects
	bigParkingRamp = false,
	
	EPLRS 					    = true,
	TACAN_AA					= true,

	sound_name	=	"aircraft\F-23A\Sounds",
	
	engines_nozzles = 
	{
		[1] = 
		{
			pos = 	{-6.51,	0.200,	-0.89},
			elevation	=	-0.3,          									-- AB plume elevation  
			diameter	=	0.85,          									-- AB plume diameter
			azimuth 	= 	-1.5,											-- Does not work AB plume rotation
			exhaust_length_ab	=	7.5, 									-- Lenght in m
			exhaust_length_ab_K	=	0.7,  									-- AB animation
			smokiness_level     = 	0.01,
			afterburner_effect_texture = "afterburner_f-23",			-- AB Fuel Manifold Flame
		}, -- end of engine [1]
		[2] = 
		{
			pos = 	{-6.51,	0.200,	0.89},
			elevation	=	-0.3,
			diameter	=	0.85,
			azimuth 	= 	1.5,											-- AB plume rotation
			exhaust_length_ab	=	7.5,
			exhaust_length_ab_K	=	0.7,
			smokiness_level     = 	0.01, 
			afterburner_effect_texture = "afterburner_f-23",				-- AB Fuel Manifold Flame
		}, -- end of engine [2]
	}, -- end of engines_nozzles
	
	crew_members = 
	{
		[1] = 
		{
			ejection_seat_name	=	17,										-- Name of Ejection Seat 17 = FA-18 58 = F-15
			drop_canopy_name	=	"F-23A_Canopy";  						-- EDM of canopy for ejection animation
			pos = 	{3.3,	1.94,	0},
		},
	}, -- end crew_members
	
	brakeshute_name	=	0,
	is_tanker	=	false,
	air_refuel_receptacle_pos = 	{0.33,	0.345,	-1.924},				-- Estimated position of F-23A receptacle

	-----------------------------------------------------
	-- TODO: Below are fire positions that need to be tuned for F-23
	-----------------------------------------------------

	fires_pos = -- (X, Z, Y)	
	{
		[1] = 	{ 1.42,	 	1.0,	 0}, 									-- Center Top 
		[2] = 	{-1.322,	0.138, 	 3.221}, 								-- Wing Left In 
		[3] = 	{-1.322,	0.138,	-3.221}, 								-- Wing Right In
		[4] = 	{-1.51,	    0.106,	 4.556},								-- Wing Left Med
		[5] = 	{-1.51,	    0.106,	-4.556},								-- Wing Right Med
		[6] = 	{-2.196,    0.255,	 4.274},								-- Wing Left Out
		[7] = 	{-2.196,    0.255,	-4.274},								-- Wing Right Out
		[8] = 	{-6.887,	0.242,	 0.887}, 								-- Engine fire L
		[9] = 	{-6.887,	0.242,	-0.887}, 								-- Engine fire R
		--[10] = 	{-0.515,	0.807,	 0.7},
		--[11] = 	{-0.515,	0.807,	-0.7},
	}, -- end of fires_pos
	
	chaff_flare_dispenser = 
	{
		[1] = 
		{
			dir = 	{0,	0,	1},
			pos = 	{-4.47,	-0.406,	1.02}, 									--{-1.453,	-0.206,	1.467},
		}, 
		[2] = 
		{
			dir = 	{0,	0,	-1},
			pos = 	{-4.47,	-0.406,	-1.02}, 								--{-3.776,	-2.0,	0.422},
		}, 
	}, 

-- Countermeasures 
	passivCounterm = {
		CMDS_Edit = true,
		SingleChargeTotal = 240,
		-- RR-170
		chaff = {default = 120, increment = 30, chargeSz = 1},				-- Raptor uses AN/ALE-52 dispenser
		-- MJU-7
		flare = {default = 120, increment = 15, chargeSz = 2}				-- Raptor uses AN/ALE-52 dispenser
	},

	CanopyGeometry 	= {
		azimuth 	= {-145.0, 145.0},										-- pilot view horizontal (AI)
		elevation 	= {-50.0, 90.0}											-- pilot view vertical (AI)
	},

Sensors 		= {
RADAR 			= "AN/APG-63", 													-- Must be labeled AN/APG-63 in order for AI to employ AMRAAMs
RWR 			= "Abstract RWR"												-- FC3 F15
},
Countermeasures = {
ECM 			= "AN/ALQ-135"													-- FC3 F15
},
Failures = {
		{ id = 'asc', 		label = _('ASC'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'autopilot', label = _('AUTOPILOT'), enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hydro',  	label = _('HYDRO'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'l_engine',  label = _('L-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'r_engine',  label = _('R-ENGINE'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'radar',  	label = _('RADAR'), 	enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },		  
		{ id = 'mlws',  	label = _('MLWS'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'rws',  		label = _('RWS'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'ecm',   	label = _('ECM'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'hud',  		label = _('HUD'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },
		{ id = 'mfd',  		label = _('MFD'), 		enable = false, hh = 0, mm = 0, mmint = 1, prob = 100 },		
},
HumanRadio = {
	frequency 		= 124.0,  																		-- Radio Freq
	editable 		= true,
	minFrequency	= 30.000,
	maxFrequency 	= 399.900,
	modulation 		= MODULATION_AM
},


net_animation = {

	21,									-- air brake animation
	603,								-- Beacon Light animation
	604,								-- Beacon Light extension/retraction
	605,								-- APU Door Animation
	606,								-- LE Flap animation
	610,								-- Right engine nozzle start/shutdown animation
	611,								-- Left engine nozzle start/shutdown animation
	612,								-- Navigation lights
	614,								-- Gun Port Animation
	700,								-- Left Main Weapons door
	701,								-- Right Main Weapons door
	702,								-- Left Fwd Weapons door
	703,								-- Right Fwd Weapons door
	950,								-- animations for "F-23B"
	951,
	952,
	953,
	954,
	955,
	956,
	957,
	9999,
	10000,

  },

Guns = {gun_mount("M_61", { count = 500 },{muzzle_pos = {5.21600, 0.115000, 0.901000}})},   			-- M61A2 20mm cannon w/ 500 rounds

-----------------------------------------------------------------------------------------
--TODO: Figure out firing order for weapons pylons
-----------------------------------------------------------------------------------------

--pylons_enumeration = {1, 11, 10, 2, 3, 9, 4, 8, 5, 7, 6},
pylons_enumeration = {1, 10, 2, 9, 3, 7, 5, 4, 8, 6},												 

Pylons =     {

	pylon(1, 0, 4.891000, -0.200, -0.300, 															-- Left Forward Bay 4.737000, -0.139, -0.253
	{
		use_full_connector_position = true,
	},
	{
		{ CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}", attach_point_position = {0.0,  0.026,  0.0}, rotation= {0,180,0}}, 									-- AIM-9x
		{ CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}" ,attach_point_position = {0.0,  0.0508,  0.0}}, 	-- AIM-9M			
	}
	),		
	
	
	pylon(2, 0, 1.342000, 0.183859, -3.17000,														-- For pylons 2 & 9 need to decide on if it is warranted to add to the mod.
		{
			use_full_connector_position = true,
			
		},
		{
			--{ CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}" ,arg_value = 0,Cx_gain = 1/2.2}, 	-- AIM-9X
			--{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 								-- AIM-120C
			--{ CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}" ,arg_value = 0,Cx_gain = 1/2.2},	-- F-15C Fuel Tank 600 Gallons	
				
		}
	),		
	

	pylon(3, 1, 0.650, -0.205, -0.36825,															-- Left Lower Main Bay Launcher
		{
			use_full_connector_position = true,			
		},
		{		    				
			{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" ,}, 									-- AIM-120C				
		}
	),

	pylon(4, 1, 1.0516, 0.0254, -0.36825,															-- Left Upper Main Bay Launcher 
		{
			use_full_connector_position = true,
		},
		{                
			{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 									-- AIM-120c				
		}
	),

	pylon(5, 1, 0.650, -0.205, -0.000,																-- Center Lower Main Bay Launcher
		{
		use_full_connector_position = true,
		},
		{				
		{ 
			CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 									-- AIM-120C				
		}
	),

	pylon(6, 1, 1.0516, 0.0254, -0.000,																-- Center Mid Main Bay Launcher
		{
			use_full_connector_position = true,
		},
		{                
			{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 									-- AIM-120C				
		}
	),


	pylon(7, 1, 0.650, -0.205, 0.36825,																-- Right Lower Main Bay Launcher
		{
		use_full_connector_position = true,
		},
		{                
		{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 										-- AIM-120C
		
		}
	),        

	pylon(8, 1, 1.0516, 0.0254, 0.36825,															-- Right Upper Main Bay Launcher
		{
			use_full_connector_position = true,
		},
		{               
			{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 									-- AIM-120C				
		}
	),     

	pylon(9, 0, 1.342000, 0.183859, 3.17000,														-- Wing pylon for now 
		{
			use_full_connector_position = true,
		},
		{
			--{ CLSID = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}" }, 									-- AIM-120C	
			   --{ CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}" }, 									-- Aim 9X
			--{ CLSID = "{E1F29B21-F291-4589-9FD8-3272EEC69506}" ,arg_value = 0,Cx_gain = 1/2.2},		-- F-15C Fuel Tank 600 Gallons
		}
	),
	
	pylon(10, 0, 5.0000, -0.300, 0.300, 															-- Right Forward Bay  4.891000, -0.200, 0.300
		{
			use_full_connector_position = true,
		},
		{
			{ CLSID = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}", attach_point_position = {0.0,  0.026,  0.0}}, --aim 9M
			{ CLSID = "{5CE2FF2A-645A-4197-B48D-8720AC69394F}",attach_point_position = {0.0,  0.0260,  0.0}}, --Aim 9X				
			
		}
	),
	


},

Tasks = {
	aircraft_task(CAP),
	 aircraft_task(Escort),
	  aircraft_task(FighterSweep),
	aircraft_task(Intercept),
	aircraft_task(Reconnaissance),
},	
DefaultTask = aircraft_task(CAP),


SFM_Data = {
	aerodynamics = 															-- Cx = Cx_0 + Cy^2*B2 +Cy^4*B4
		{
			Cy0	=	0,														-- zero AoA lift coefficient
			Mzalfa	=	10, 												-- coefficients for pitch agility											
			Mzalfadt	=	1, 												-- coefficients for pitch agility (typo?)
			kjx = 2.95,														--- roll inertia
			kjz = 0.00125,													--- pitch inertia
			Czbe = -0.05,  													-- coefficient, along Z axis (perpendicular), affects yaw, negative value means force orientation in FC coordinate system
			cx_gear = 0.0268,												-- coefficient, drag, gear
			cx_flap = 0.06,													-- coefficient, drag, full flaps
			cy_flap = 0.26,   												-- coefficient, normal force, lift, flaps
			cx_brk = 0.09, 													-- coefficient, drag, breaks
			table_data = 
			{
				
				 {0.0,	0.0115,		0.060,		0.02,		0.22,	4.0,	40.0,	2.250 },
				 {0.2,	0.0115,		0.060,		0.02,		0.22,	4.25,	40.0,	2.250 },
				 {0.4,	0.0115,		0.06,		0.04,	   	0.22,	4.50,	40.0,	2.250 },
				 {0.6,	0.0115,		0.06,		0.04,		0.26,	5.20,	40.0,	2.250 },
				 {0.7,	0.0115,		0.06,		0.04,		0.26,	5.20,	40.0,	2.250 },
				 {0.8,	0.0115,		0.06,		0.05,		0.26,	5.20,	40.0,	2.250 },
				 {0.9,	0.0150,		0.06,		0.06,		0.18,	5.20,	40.0,	2.250 },
				 {1.0,	0.0200,		0.05,		0.07,		0.14,	5.20,	40.0,	2.250 },
				 {1.1,	0.0239,		0.050,	   	0.08,		0.10,	5.13,	40.0,	2.250 },
				 {1.2,	0.0245,		0.050,	   	0.09,		0.10,	4.41,	40.0,	2.250 },		
				 {1.3,	0.0239,		0.050,	   	0.10,		0.10,	4.00,	40.0,	2.250 },				
				 {1.4,	0.0230,		0.050,	   	0.11,		0.136,	4.00,	40.0,	2.250 },					
				 {1.6,	0.0230,		0.050,	   	0.13,		0.21,	4.00,	40.0,	2.250 },					
				 {1.8,	0.0230,		0.05,	   	0.15,		1.43,	4.00,	40.0,	2.250 },		
				 {2.2,	0.0230,		0.045,	   	0.19,		2.5,	4.00,	40.0,	2.250 },					
				 {2.5,	0.0230,		0.05,		0.22,		3.7,	4.00,	9.0,	2.250 },		
				 {3.9,	0.0230,		0.05,		0.36,		6.0,	4.00,	7.0,	2.250 },



				}, 
				-- M    - Mach number
				-- Cx0    - Coefficient, drag, profile, of the airplane
				-- Cya    - Normal force coefficient of the wing and body of the aircraft in the normal direction to that of flight. Inversely proportional to the available G-loading at any Mach value. (lower the Cya value, higher G available) per 1 degree AOA
				-- B    - Polar quad coeff
				-- B4    - Polar 4th power coeff
				-- Omxmax    - roll rate, rad/s
				-- Aldop    - Alfadop Max AOA at current M - departure threshold
				-- Cymax    - Coefficient, lift, maximum possible (ignores other calculations if current Cy > Cymax)-- end of table_data
		}, -- end of aerodynamics
		engine = 
		{
			Nmg	  	=	67.5, 											-- RPM at idle
			MinRUD	=	0,
			MaxRUD	=	1,
			MaksRUD	=	0.85,
			ForsRUD	=	0.91,
			type	=	"TurboJet",
			hMaxEng	=	27.0,    
			dcx_eng	=	0.0114,
			cemax	=	1.134,
			cefor	=	2.30,
			dpdh_m	=	5000, 
			dpdh_f	=	8000, --14000.0,
			table_data = {
			--   M		Pmax		 Pfor
					{0.0,	170000,		240000}, --138000
				{0.2,	170000,		240000},
				{0.4,	180000,		250000},
				{0.6,	190000,		260000},
				{0.7,	202000,		272000},
				{0.8,	214000,		284000},
				{0.9,	226000,		296000},
				{1.0,	238000,		308000},
				{1.1,	233000,		323000},
				{1.2,	207000,		338000},
				{1.3,	205000,		353000},
				{1.4,	204000,		355000},
				{1.6,	196000,		345000},
				{1.8,	190000,		325000},
				{2.2,	190000,		325000},
				{2.5,	090000,		325000},
				{3.9,	 	0,			0},
			}, -- end of table_data
		}, -- end of engine
	},



--damage , index meaning see in  Scripts\Aircrafts\_Common\Damage.lua
Damage = {
[0]  = {critical_damage = 5,  args = {146}}, -- nose center
[1]  = {critical_damage = 3,  args = {296}}, -- nose left
[2]  = {critical_damage = 3,  args = {297}}, -- nose right
[3]  = {critical_damage = 8, args = {65}}, -- cockpit
[4]  = {critical_damage = 2,  args = {298}}, -- cabin left
[5]  = {critical_damage = 2,  args = {301}}, -- cabin right
[7]  = {critical_damage = 2,  args = {249}}, -- gun
[8]  = {critical_damage = 3,  args = {265}}, -- front gear
[9]  = {critical_damage = 3,  args = {154}}, -- fuselage left
[10] = {critical_damage = 3,  args = {153}}, -- fuselage right
[11] = {critical_damage = 1,  args = {167}}, -- engine in left
[12] = {critical_damage = 1,  args = {161}}, -- engine in right
[13] = {critical_damage = 2,  args = {169}}, -- nacelle, left bottom
[14] = {critical_damage = 2,  args = {163}}, -- nacelle, right bottom
[15] = {critical_damage = 2,  args = {267}}, -- gear left
[16] = {critical_damage = 2,  args = {266}}, -- gear right
[17] = {critical_damage = 2,  args = {168}}, -- nacelle, left (left engine out, left ewu)
[18] = {critical_damage = 2,  args = {162}}, -- nacelle, right (right engine out, right ewu)
--[20] = {critical_damage = 2,  args = {183}}, -- airbrake right
[23] = {critical_damage = 5, args = {223}}, -- wing out left
[24] = {critical_damage = 5, args = {213}}, -- wing out right
[25] = {critical_damage = 2,  args = {226}}, -- aileron left
[26] = {critical_damage = 2,  args = {216}}, -- aileron right
[29] = {critical_damage = 5, args = {224}, deps_cells = {23, 25}}, -- wing centre left
[30] = {critical_damage = 5, args = {214}, deps_cells = {24, 26}}, -- wing centre right
[33] = {critical_damage = 5, args = {224}}, -- slat in left (remove deps_cells)
[34] = {critical_damage = 5, args = {214}}, -- slat in right (remove deps_cells)
[35] = {critical_damage = 6, args = {225}, deps_cells = {23, 29, 25, 37}}, -- wing in left
[36] = {critical_damage = 6, args = {215}, deps_cells = {24, 30, 26, 38}}, -- wing in right
[37] = {critical_damage = 2,  args = {228}}, -- flap in left
[38] = {critical_damage = 2,  args = {218}}, -- flap in right
[39] = {critical_damage = 2,  args = {244}, deps_cells = {53}}, -- fin top left
[40] = {critical_damage = 2,  args = {241}, deps_cells = {54}}, -- fin top right
[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}}, -- fin bottom left
[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}}, -- fin bottom right
[51] = {critical_damage = 2,  args = {240}}, -- elevator in left
[52] = {critical_damage = 2,  args = {238}}, -- elevator in right
--[53] = {critical_damage = 2,  args = {248}}, -- rudder left
--[54] = {critical_damage = 2,  args = {247}}, -- rudder right
[56] = {critical_damage = 2,  args = {158}}, -- tail left
[58] = {critical_damage = 2,  args = {157}}, -- tail bottom
[59] = {critical_damage = 3,  args = {148}}, -- nose bottom
[61] = {critical_damage = 2,  args = {147}}, -- fuel tank front (left)
[82] = {critical_damage = 2,  args = {152}}, -- fuselage bottom
[83] = {critical_damage = 2,  args = {152}}, -- wheel nose
[84] = {critical_damage = 2,  args = {148}}, -- wheel left
[85] = {critical_damage = 2,  args = {159}}, -- wheel right
},

DamageParts = 
{  
	--[[[1] = "F-23A-oblomok-wing-r", -- wing R
	[2] = "F-23A-oblomok-wing-l", -- wing L
	[3] = "F-23A-oblomok-noise", -- nose
	[4] = "F-23A-oblomok-tail-r", -- tail R
	[5] = "F-23A-oblomok-tail-l", -- tail L]]
},

	lights_data = { typename = "collection", lights = {

[1] = { typename = "collection", 
		lights = {	
		{typename = "argnatostrobelight", argument = 603, period = 1.2, phase_shift = 0},-- beacon lights
		}
	},
[2] = { typename = "collection",
		lights = {	
		{typename = "argumentlight", argument = 209, },					
		}
		},
[3]	= {	typename = "collection", -- nav_lights_default
				lights = {
					{typename  = "argumentlight", argument  =  612, },							--Nav Lights
					--{typename  = "omnilight",connector =  "BANO_2"  ,argument  =  191,color = {0, 0.894, 0.6}},-- Right Position(green)
					--{typename  = "omnilight",connector =  "BANO_0"  ,argument  =  192,color = {1, 1, 1}},-- Tail Position white)
						}
		},
[4] = { typename = "collection", -- formation_lights_default
				lights = {
					--{typename  = "argumentlight" ,argument  = 200,},--formation_lights_tail_1 = 200;
					{typename  = "argumentlight" ,argument  =  200,},--old aircraft arg =88
						}
		},
		
}},
}

add_aircraft(F_23A)