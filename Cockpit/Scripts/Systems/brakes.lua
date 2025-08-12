--[[=============================================================================================================================================================
												Original code credit to Gripen Mod Team. Used with permission
===============================================================================================================================================================]]
dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 0.024
make_default_activity(updateTimeStep)


local brakes = GetSelf()

-- You will need to create custom input commands for the brakes. Add them in Input and in command_defs.lua.
brakes:listen_command(10138)                       -- Brakes On	
brakes:listen_command(10139)                       -- Brakes Off	
brakes:listen_command(10156)                       -- Left axis
brakes:listen_command(10157)                       -- Right axis
brakes:listen_command(10158)                       -- Both axis
brakes:listen_command(10159)                       -- Parking brake
brakes:listen_command(deviceCommands.ParkingBrake) -- Parking brake: 1 = enabled, 0 = disabled.


local birth = nil

local brakeForce = get_param_handle("brakeForce")


local LAxisValue = 0
local RAxisValue = 0
local BAxisValue = 0

local brakesOn = nil
-- local brakesOff = nil



function post_initialize()
	brakeForce:set(0)

	LAxisValue = -1
	RAxisValue = -1
	BAxisValue = -1

	brakesOn = false

	birth = LockOn_Options.init_conditions.birth_place
	if birth == "AIR_HOT" then
		brakes:performClickableAction(deviceCommands.ParkingBrake, 0, true)
		LAxisValue = -1
		RAxisValue = -1
		brakesOn = false
	elseif birth == "GROUND_HOT" then
		brakes:performClickableAction(deviceCommands.ParkingBrake, 1, true)
		LAxisValue = 1
		RAxisValue = 1
		brakesOn = true
	elseif birth == "GROUND_COLD" then
		brakes:performClickableAction(deviceCommands.ParkingBrake, 1, true)
		LAxisValue = 1
		RAxisValue = 1
		brakesOn = true
	end
end

function update()
	if BAxisValue > 0.1 or (LAxisValue > 0.1 or RAxisValue > 0.1) then
		dispatch_action(nil, 74)
	else
		dispatch_action(nil, 75)
	end



	-- print_message_to_user(brakeForce:get()) -- Used for debugging.
end

function SetCommand(command, value)
	-- Axis commands:
	if command == 10156 then -- Left brake.
		LAxisValue = value
		brakeForce:set(value)
	elseif command == 10157 then -- Right brake.
		RAxisValue = value
		brakeForce:set(value)
	elseif command == 10158 then -- Both brakes.
		LAxisValue = value
		RAxisValue = value
		brakeForce:set(value)
	end

	-- Keyboard commands:
	if command == 10139 then -- and (brakesOn == false or brakesOff == true)
		-- brakesOn = true
		-- brakesOff = false
		LAxisValue = -1
		RAxisValue = -1
		brakeForce:set(-1)
	elseif command == 10138 then -- and (brakesOn == true or brakesOff == false)
		-- brakesOn = false
		-- brakesOff = true
		LAxisValue = 1
		RAxisValue = 1
		brakeForce:set(1)
	end

	-- Parking brake toggle:
	if command == 10159 and brakesOn == false then
		brakes:performClickableAction(deviceCommands.ParkingBrake, 1, true) -- Move switch to ON
		LAxisValue = 1                                                -- Apply brakes
		RAxisValue = 1
		brakesOn = true
		get_param_handle("parkingBrake"):set(1) -- Set parking brake to enabled.
	elseif command == 10159 and brakesOn == true then
		brakes:performClickableAction(deviceCommands.ParkingBrake, 0, true) -- Move switch to OFF
		LAxisValue = -1                                               -- Release brakes
		RAxisValue = -1
		brakesOn = false
		get_param_handle("parkingBrake"):set(0) -- Set parking brake to disabled.
	elseif command == deviceCommands.ParkingBrake then
		if value == 0 then -- Switch OFF
			LAxisValue = -1 -- Brakes released
			RAxisValue = -1
			brakesOn = false
			get_param_handle("parkingBrake"):set(0) -- Parking brake disabled
		elseif value == 1 then             -- Switch ON
			LAxisValue = 1                 -- Brakes applied
			RAxisValue = 1
			brakesOn = true
			get_param_handle("parkingBrake"):set(1) -- Parking brake enabled
		end
	end
end



need_to_be_closed = false