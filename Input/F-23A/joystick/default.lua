local cockpit = folder.."../../../Cockpit/Scripts/"
dofile(cockpit.."devices.lua")
dofile(cockpit.."command_defs.lua")
local res = external_profile("Config/Input/Aircrafts/base_joystick_binding.lua")

--Brakes
local BrakesON      = 10138
local BrakesOFF     = 10139
local L_BRAKE       = 10156
local R_BRAKE       = 10157
local B_BRAKE       = 10158
local Brakes        = 10123 
local P_BRAKE	    = 10159
local YAW_AXIS      = 10163
local ROLL_INPUT	= 10164
local PITCH_INPUT  	= 10165


ignore_features(res.keyCommands,{"dragchute"})

join(res.keyCommands,{      

--F-23A Weapons

{down = keys.first_stage_trigger_on, up = keys.first_stage_trigger_off,         name = _('First Stage Trigger'),	         category = _('F-23A Weapons')},	
{down = keys.second_stage_trigger_on, up = keys.second_stage_trigger_off,       name = _('Second Stage Trigger'),	         category = _('F-23A Weapons')},	
{down = keys.pickle_on, up = keys.pickle_off,                                   name = _('Weapons Release'),	             category = _('F-23A Weapons')},
{down = keys.weap_bay_select,                                                   name = _('Weapons Bay Select'),              category = _('F-23A Weapons')},
{down = keys.manual_bay_operation,	                                            name = _('Manual Bay Operation'),            category = _('F-23A Weapons')},
{down = keys.master_arm_switch,	                                                name = _('Master Arm'),                      category = _('F-23A Weapons')},
{down = keys.countermeasuresDispense, up = keys.countermeasuresDispenseOff,     name = _("Countermeasures Dispence (Both)"), category = _('F-23A Weapons')},
--{down = keys.U_aa,	   	    	                                                name = _('Fuck it Mode'),	             	 	 category = _('F-23A Weapons')}, redundent and not needed



------------------------------------------------------------------------------------------------------------------------------------------------------

--F-23A Systems
{down = keys.formation_lights,	        name = _('Formation Lights'), 			                        category = _('F-23A Systems')},
{down = keys.beacon_lights,	            name = _('Beacon Lights'), 			                            category = _('F-23A Systems')},
{down = keys.back_lights,	            name = _('Cockpit Back Lighting'), 			                    category = _('F-23A Systems')},
{down = keys.flood_lights,	            name = _('Cockpit Flood Lighting'), 		                    category = _('F-23A Systems')},
{down = P_BRAKE, 						name = _('Parking Brake - Toggle'), 	                        category = _('F-23A Systems')},		                        -- Brake code from Gripen Mod	
{down = BrakesON, up = BrakesOFF,   	name = _('Wheel Brakes - Both'), 	               		        category = _('F-23A Systems')},                             -- Brake code from Gripen Mod
{down = keys.batToggle,	                name = _('Battery On'), 			                            category = _('F-23A Systems')},
{down = keys.bat_off,	                name = _('Battery Off'), 			                            category = _('F-23A Systems')},
{down = keys.landing_on,	            name = _('Landing Light On'), 			                        category = _('F-23A Systems')},
{down = keys.position_on,	            name = _('Position Lights On'), 		                        category = _('F-23A Systems')},
{down = keys.position_off,	            name = _('Position Lights Off'), 			                    category = _('F-23A Systems')},
{down = keys.form_on,	                name = _('Formation Light On'), 			                    category = _('F-23A Systems')},
{down = keys.form_off,	                name = _('Formation Light Off'), 			                    category = _('F-23A Systems')},
{down = keys.con_bright_on,	            name = _('Console Back Lighting On'), 		                    category = _('F-23A Systems')},
{down = keys.con_bright_off,	        name = _('Console Back Lighting Off'), 			                category = _('F-23A Systems')},
{down = keys.taxi_on,	                name = _('Taxi Light On'), 			                            category = _('F-23A Systems')},
{down = keys.land_taxi_off,	            name = _('Landing and Taxi light Off'), 			            category = _('F-23A Systems')},
{down = keys.APU,	                    name = _('APU Start/Stop'), 			                        category = _('F-23A Systems')},
{down = keys.l_engine_start,	        name = _('Left Engine Start'), 			                        category = _('F-23A Systems')},
{down = keys.l_engine_stop,	            name = _('Left Engine Stop'), 			                        category = _('F-23A Systems')},
{down = keys.r_engine_start,	        name = _('Right Engine Start'), 			                    category = _('F-23A Systems')},
{down = keys.r_engine_stop,	            name = _('Right Engine Stop'), 			                        category = _('F-23A Systems')},		
{down = keys.GearUp,	    			name = _('Gear Up'),                    		        	    category = _('F-23A Systems')},
{down = keys.GearDown,                  name = _('Gear Down'),                  		        	    category = _('F-23A Systems')},
{down = keys.FLCSTest,	                name = _('FLCS Test'), 			                                category = _('F-23A Systems')},	
{down = keys.air_brake,	    		    name = _('F-23 Airbrake'),	    								category = _('F-23A Systems')},
{down = keys.airBrakeOn,	   		    name = _('F-23 Airbrake On'),	    							category = _('F-23A Systems')},
{down = keys.airBrakeOff,	   	    	name = _('F-23 Airbrake Off'),	    							category = _('F-23A Systems')},
{down = keys.nws_rate,	   	    	    name = _('NWS Rate'),	    							        category = _('F-23A Systems')},

------------------------------------------------------------------------------------------------------------------------------------------------------

--F-23A Systems
{down = keys.RudderLeft,               name = _('Left Rudder'),                                        category = _('F-23A FlightControls')},
{down = keys.RudderRight,              name = _('Right Rudder'),                                       category = _('F-23A FlightControls')},

-------------------------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------------------------
    --Autopilot
    {down = iCommandPlaneAutopilot,     name = _('Autopilot - Attitude Hold'),          category = _('Autopilot')},
    {down = iCommandPlaneStabHbar,      name = _('Autopilot - Altitude Hold'),          category = _('Autopilot')},
    {down = iCommandPlaneStabCancel,    name = _('Autopilot Disengage'),                category = _('Autopilot')},
 
    -- Systems
    {down = iCommandPowerOnOff, 												name = _('Electric Power Switch'),		category = _('Systems')},
    {down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
    {down = iCommandPlaneJettisonFuelTanks, name = _('Jettison Fuel Tanks'), category = _('Systems')},
    {down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton, name = _('Nose Gear Maneuvering Range'), category = _('Systems')},
    {down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Wheel Steering'), category = _('Systems')},
    {down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff, name = _('Wheel Brake Left On/Off'), category = _('Systems')},
    {down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff, name = _('Wheel Brake Right On/Off'), category = _('Systems')},  
    -- Modes
    {down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
    {down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
    {down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
    {down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'), category = _('Modes')},

    -- Sensors
    {down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
    {down = iCommandSensorReset, name = _('Radar - Return To Search/NDTWS'), category = _('Sensors')},
    {down = iCommandRefusalTWS, name = _('Unlock TWS Target'), category = _('Sensors')},
    {down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
    {down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
    {down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
    {down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},

    {pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
    {pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
    {pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
    {pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
    {pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
    {down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
    {down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
  
    {down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
    {down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
 
    {down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},

    
    -- Weapons                                                                        

    --{down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},

    })
    -- joystick axes 
    join(res.axisCommands,{
    
    -- F-23A axis commands
    
    {action = B_BRAKE,		                        name = _('F-23A Wheel Brake Both')},
    {action = L_BRAKE,		                        name = _('F-23A Wheel Brake Left')},
    {action = R_BRAKE,		                        name = _('F-23A Wheel Brake Right')},
    {action = YAW_AXIS,		                        name = _('F-23A Yaw Axis')},
    {action = PITCH_INPUT,							name = _('F-23A Pitch Axis')}, 		
    {action = ROLL_INPUT,                           name = _('F-23A Roll Axis')}, 		


    --Core
    {action = iCommandPlaneSelecterHorizontalAbs,   name = _('TDC Slew Horizontal')},
    {action = iCommandPlaneSelecterVerticalAbs,     name = _('TDC Slew Vertical')},
    {action = iCommandPlaneRadarHorizontalAbs,      name = _('Radar Horizontal')},
    {action = iCommandPlaneRadarVerticalAbs,        name = _('Radar Vertical')},
    {action = iCommandPlaneMFDZoomAbs,              name = _('MFD Range')},
    {action = iCommandPlaneBase_DistanceAbs,        name = _('Base/Distance')},
    {action = iCommandWheelBrake,		            name = _('Wheel Brake')},
    {action = iCommandLeftWheelBrake,	            name = _('Wheel Brake Left')},
    {action = iCommandRightWheelBrake,	            name = _('Wheel Brake Right')},
    })
    return res