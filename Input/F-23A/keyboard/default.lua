local cockpit = folder .. "../../../Cockpit/Scripts/"
dofile(cockpit .. "devices.lua")
dofile(cockpit .. "command_defs.lua")
local res = external_profile("Config/Input/Aircrafts/base_keyboard_binding.lua")

-- Brakes
local BrakesON      = 10138
local BrakesOFF     = 10139
local L_BRAKE       = 11056
local R_BRAKE       = 10157
local B_BRAKE       = 10158
local Brakes        = 10123 
local P_BRAKE	    = 10159

ignore_features(res.keyCommands, {"dragchute"})

join(res.keyCommands, {
 
--F-23A Weapons

{down = keys.first_stage_trigger_on, up = keys.first_stage_trigger_off,         name = _('First Stage Trigger'),	    category = _('F-23A Weapons')},	
{down = keys.second_stage_trigger_on, up = keys.second_stage_trigger_off,       name = _('Second Stage Trigger'),	    category = _('F-23A Weapons')},	
{down = keys.pickle_on, up = keys.pickle_off,                                   name = _('Weapons Release'),	        category = _('F-23A Weapons')},
{down = keys.weap_bay_select,                                                   name = _('Weapons Bay Select'),         category = _('F-23A Weapons')},
{down = keys.manual_bay_operation,	                                            name = _('Manual Bay Operation'),       category = _('F-23A Weapons')},
{down = keys.master_arm_switch,	                                                name = _('Master Arm'),                 category = _('F-23A Weapons')},
{down = keys.countermeasuresDispense, up = keys.countermeasuresDispenseOff,     name = _("Countermeasures Dispence (Both)"), category = _('F-23A Weapons')},


------------------------------------------------------------------------------------------------------------------------------------------------------

--F-23A Systems
{down = keys.formation_lights,	        name = _('Formation Lights'), 			                        category = _('F-23A Systems')},
{down = keys.beacon_lights,	            name = _('Beacon Lights'), 			                            category = _('F-23A Systems')},
{down = keys.back_lights,	            name = _('Cockpit Back Lighting'), 			                    category = _('F-23A Systems')},
{down = keys.flood_lights,	            name = _('Cockpit Flood Lighting'), 		                    category = _('F-23A Systems')},
{down = P_BRAKE, 						name = _('Parking Brake - Toggle'), 	                        category = _('F-23A Systems')},			
{down = BrakesON, up = BrakesOFF,   	name = _('Wheel Brakes - Both'), 	               		        category = _('F-23A Systems')},
{down = keys.batToggle,	                name = _('Battery On'), 			                            category = _('F-23A Systems')},
{down = keys.bat_off,	                name = _('Battery Off'), 			                            category = _('F-23A Systems')},
{down = keys.landing_on,	            name = _('Landing Light On'), 			                        category = _('F-23A Systems')},
{down = keys.taxi_on,	                name = _('Taxi Light On'), 			                            category = _('F-23A Systems')},
{down = keys.land_taxi_off,	            name = _('Landing and Taxi light Off'), 			            category = _('F-23A Systems')},
{down = keys.APU,	                    name = _('APU Start/Stop'), 			                        category = _('F-23A Systems')},
{down = keys.l_engine_start,	        name = _('Left Engine Start'), 			                        category = _('F-23A Systems')},
{down = keys.l_engine_stop,	            name = _('Left Engine Stop'), 			                        category = _('F-23A Systems')},
{down = keys.r_engine_start,	        name = _('Right Engine Start'), 			                    category = _('F-23A Systems')},
{down = keys.r_engine_stop,	            name = _('Right Engine Stop'), 			                        category = _('F-23A Systems')},
{down = keys.FLCSTest,	                name = _('FLCS Test'), 			                                category = _('F-23A Systems')},
{down = keys.air_brake,	    		    name = _('F-23 Airbrake'),	    								category = _('F-23A Systems')},
{down = keys.airBrakeOn,	   		    name = _('F-23 Airbrake On'),	    							category = _('F-23A Systems')},
{down = keys.airBrakeOff,	   	    	name = _('F-23 Airbrake Off'),	    							category = _('F-23A Systems')},
{down = keys.position_on,	            name = _('Position Lights On'), 			                    category = _('F-23A Systems')},
{down = keys.position_off,	            name = _('Position Lights Off'), 			                    category = _('F-23A Systems')},
{down = keys.form_on,	                name = _('Formation Lights On'), 			                    category = _('F-23A Systems')}, 
{down = keys.form_off,	                name = _('Formation Lights Off'), 			                    category = _('F-23A Systems')},
{down = keys.nws_rate,	   	    	    name = _('NWS Rate'),	    							        category = _('F-23A Systems')},
--Assigned key custom key binds

{combos = {{key = 'G', reformers = {'RCtrl'}}}, 	down = keys.GearUp,	    				 name = _('Gear Up'),                    category = _('F-23A Systems')},
{combos = {{key = 'G', reformers = {'RShift'}}}, 	down = keys.GearDown,                    name = _('Gear Down'),                  category = _('F-23A Systems')},


		
-------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Autopilot
    {combos = {{key = 'A'}, {key = '1', reformers = {'LAlt'}}}, down = iCommandPlaneAutopilot, name = _('Autopilot - Attitude Hold'), category = _('Autopilot')},
    {combos = {{key = 'H'}, {key = '2', reformers = {'LAlt'}}}, down = iCommandPlaneStabHbar, name = _('Autopilot - Altitude Hold'), category = _('Autopilot')},
    {combos = {{key = '9', reformers = {'LAlt'}}}, down = iCommandPlaneStabCancel, name = _('Autopilot Disengage'), category = _('Autopilot')},    
    --Flight Control
    {combos = {{key = 'T', reformers = {'LAlt'}}}, down = iCommandPlaneTrimOn, up = iCommandPlaneTrimOff, name = _('T/O Trim'), category = _('Flight Control')},
        -- Systems
    {combos = {{key = 'R', reformers = {'LCtrl'}}}, down = iCommandPlaneAirRefuel, name = _('Refueling Boom'), category = _('Systems')},
    
    {combos = {{key = 'R', reformers = {'LAlt'}}}, down = iCommandPlaneJettisonFuelTanks, name = _('Jettison Fuel Tanks'), category = _('Systems')},
    {combos = {{key = 'S'}}, down = iCommandPlane_HOTAS_NoseWheelSteeringButton, up = iCommandPlane_HOTAS_NoseWheelSteeringButton, name = _('Nose Gear Maneuvering Range'), category = _('Systems')},
    {combos = {{key = 'Q', reformers = {'LAlt'}}}, down = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, up = iCommandPlane_HOTAS_NoseWheelSteeringButtonOff, name = _('Nose Wheel Steering'), category = _('Systems')},
    {combos = {{key = 'A', reformers = {'LCtrl'}}}, down = iCommandPlaneWheelBrakeLeftOn, up = iCommandPlaneWheelBrakeLeftOff, name = _('Wheel Brake Left On/Off'), category = _('Systems')},
    {combos = {{key = 'A', reformers = {'LAlt'}}}, down = iCommandPlaneWheelBrakeRightOn, up = iCommandPlaneWheelBrakeRightOff, name = _('Wheel Brake Right On/Off'), category = _('Systems')},
    {combos = {{key = 'T', reformers = {'LShift'}}}, down = iCommandClockElapsedTimeReset, name = _('Elapsed Time Clock Start/Stop/Reset'), category = _('Systems')},
        -- Modes
    {combos = {{key = '2'}}, down = iCommandPlaneModeBVR, name = _('(2) Beyond Visual Range Mode'), category = _('Modes')},
    {combos = {{key = '3'}}, down = iCommandPlaneModeVS, name = _('(3) Close Air Combat Vertical Scan Mode'), category = _('Modes')},
    {combos = {{key = '4'}}, down = iCommandPlaneModeBore, name = _('(4) Close Air Combat Bore Mode'), category = _('Modes')},
    --{combos = {{key = '5'}}, down = iCommandPlaneModeHelmet, name = _('(5) Close Air Combat HMD Helmet Mode'), category = _('Modes')},
    {combos = {{key = '6'}}, down = iCommandPlaneModeFI0, name = _('(6) Longitudinal Missile Aiming Mode/FLOOD mode'), category = _('Modes')},
    {combos = {{key = '7'}}, down = iCommandPlaneModeGround, name = _('(7) Air-To-Ground Mode'), category = _('Modes')},
    --{combos = {{key = '8'}}, down = iCommandPlaneModeGrid, name = _('(8) Gunsight Reticle Switch'), category = _('Modes')},
        -- Sensors
    {combos = {{key = 'Enter'}}, down = iCommandPlaneChangeLock, up = iCommandPlaneChangeLockUp, name = _('Target Lock'), category = _('Sensors')},
    {combos = {{key = 'Back'}}, down = iCommandSensorReset, name = _('Radar - Return To Search/NDTWS'), category = _('Sensors')},
    {down = iCommandRefusalTWS, name = _('Unlock TWS Target'), category = _('Sensors')},
    {combos = {{key = 'I'}}, down = iCommandPlaneRadarOnOff, name = _('Radar On/Off'), category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RAlt'}}}, down = iCommandPlaneRadarChangeMode, name = _('Radar RWS/TWS Mode Select'), category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RCtrl'}}}, down = iCommandPlaneRadarCenter, name = _('Target Designator To Center'), category = _('Sensors')},
    {combos = {{key = 'I', reformers = {'RShift'}}}, down = iCommandPlaneChangeRadarPRF, name = _('Radar Pulse Repeat Frequency Select'), category = _('Sensors')},
    {combos = {{key = 'O'}}, down = iCommandPlaneEOSOnOff, name = _('Electro-Optical System On/Off'), category = _('Sensors')},
    {combos = {{key = 'O', reformers = {'RShift'}}}, down = iCommandPlaneLaserRangerOnOff, name = _('Laser Ranger On/Off'), category = _('Sensors')},
    {combos = {{key = 'O', reformers = {'RCtrl'}}}, down = iCommandPlaneNightTVOnOff, name = _('Night Vision (FLIR or LLTV) On/Off'), category = _('Sensors')},
    {combos = {{key = ';'}}, pressed = iCommandPlaneRadarUp, up = iCommandPlaneRadarStop, name = _('Target Designator Up'), category = _('Sensors')},
    {combos = {{key = '.'}}, pressed = iCommandPlaneRadarDown, up = iCommandPlaneRadarStop, name = _('Target Designator Down'), category = _('Sensors')},
    {combos = {{key = ','}}, pressed = iCommandPlaneRadarLeft, up = iCommandPlaneRadarStop, name = _('Target Designator Left'), category = _('Sensors')},
    {combos = {{key = '/'}}, pressed = iCommandPlaneRadarRight, up = iCommandPlaneRadarStop, name = _('Target Designator Right'), category = _('Sensors')},
    {combos = {{key = ';', reformers = {'RShift'}}}, pressed = iCommandSelecterUp, up = iCommandSelecterStop, name = _('Scan Zone Up'), category = _('Sensors')},
    {combos = {{key = '.', reformers = {'RShift'}}}, pressed = iCommandSelecterDown, up = iCommandSelecterStop, name = _('Scan Zone Down'), category = _('Sensors')},
    {combos = {{key = ',', reformers = {'RShift'}}}, pressed = iCommandSelecterLeft, up = iCommandSelecterStop, name = _('Scan Zone Left'), category = _('Sensors')},
    {combos = {{key = '/', reformers = {'RShift'}}}, pressed = iCommandSelecterRight, up = iCommandSelecterStop, name = _('Scan Zone Right'), category = _('Sensors')},
    {combos = {{key = '='}}, down = iCommandPlaneZoomIn, name = _('Display Zoom In'), category = _('Sensors')},
    {combos = {{key = '-'}}, down = iCommandPlaneZoomOut, name = _('Display Zoom Out'), category = _('Sensors')},
    {combos = {{key = '-', reformers = {'RCtrl'}}}, down = iCommandDecreaseRadarScanArea, name = _('Radar Scan Zone Decrease'), category = _('Sensors')},
    {combos = {{key = '=', reformers = {'RCtrl'}}}, down = iCommandIncreaseRadarScanArea, name = _('Radar Scan Zone Increase'), category = _('Sensors')},
    {combos = {{key = '=', reformers = {'RAlt'}}}, pressed = iCommandPlaneIncreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Increase'), category = _('Sensors')},
    {combos = {{key = '-', reformers = {'RAlt'}}}, pressed = iCommandPlaneDecreaseBase_Distance, up = iCommandPlaneStopBase_Distance, name = _('Target Specified Size Decrease'), category = _('Sensors')},
    {combos = {{key = 'R', reformers = {'RShift'}}}, down = iCommandChangeRWRMode, name = _('RWR/SPO Mode Select'), category = _('Sensors')},
    {combos = {{key = ',', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeDown, name = _('RWR/SPO Sound Signals Volume Down'), category = _('Sensors')},
    {combos = {{key = '.', reformers = {'RAlt'}}}, down = iCommandPlaneThreatWarnSoundVolumeUp, name = _('RWR/SPO Sound Signals Volume Up'), category = _('Sensors')},
        -- Weapons                                                                        
    {combos = {{key = 'V', reformers = {'LCtrl'}}}, down = iCommandPlaneSalvoOnOff, name = _('Salvo Mode'), category = _('Weapons')},
    {combos = {{key = 'Space', reformers = {'RAlt'}}}, down = iCommandPlanePickleOn,	up = iCommandPlanePickleOff, name = _('Weapon Release'), category = _('Weapons')},
    {combos = {{key = 'C', reformers = {'LShift'}}}, down = iCommandChangeGunRateOfFire, name = _('Cannon Rate Of Fire / Cut Of Burst select'), category = _('Weapons')},
    })
    return res