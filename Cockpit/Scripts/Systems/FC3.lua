dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 1 / 30
make_default_activity(updateTimeStep)


local FC3 = GetSelf()

FC3:listen_command(keys.ActiveJamming)
FC3:listen_command(keys.PlaneModeCannon)
FC3:listen_command(keys.U_aa)
FC3:listen_command(keys.U_ag)
FC3:listen_command(keys.U_nav)
FC3:listen_command(keys.U_inst)
FC3:listen_command(keys.PlaneStabHbar)   -- Altitude hold.
FC3:listen_command(keys.PlaneAutopilot)  -- Attitude hold.
FC3:listen_command(keys.PlaneStabCancel) -- Autopilot disengage.

FC3:listen_command(deviceCommands.U_aa)
FC3:listen_command(deviceCommands.U_ag)
FC3:listen_command(deviceCommands.U_nav)
FC3:listen_command(deviceCommands.U_inst)

FC3:listen_command(105) -- NAV
FC3:listen_command(106) -- BVR
FC3:listen_command(107) -- VS
FC3:listen_command(108) -- BORE
FC3:listen_command(111) -- Ground
FC3:listen_command(156) -- ILS


local ECMState = get_param_handle("ECMState")
local gunMode = get_param_handle("gunMode")

local APMode = get_param_handle("APMode")

local aaMode = get_param_handle("aaMode") -- Tracks AA modes


local aaModes = {106, 107, 108} -- BVR, VS, BORE



function SetCommand(command, value)
	if command == keys.ActiveJamming then
		ECMState:set(ECMState:get() == 0 and 1 or 0)
	end


	if get_param_handle("currentPhaseCO"):get() == 1 then
		if command == keys.PlaneStabHbar then
			APMode:set(APMode:get() == 0 and 1 or 0)
		end

		if command == keys.PlaneAutopilot then
			APMode:set(APMode:get() == 0 and 2 or 0)
		end

		if command == keys.PlaneStabCancel then
			APMode:set(0)
		end
	end


	if get_param_handle("APUBus"):get() == 1 then
		if command == keys.PlaneModeCannon then
			gunMode:set(gunMode:get() == 0 and 1 or 0)
		end


		if command == deviceCommands.U_aa then
			local currentIndex = aaMode:get() -- Get current mode index (default to 1 if not set)
			if currentIndex == 0 then
				currentIndex = 1
			end


			local nextIndex = currentIndex + 1 -- Cycle to next mode
			if nextIndex > #aaModes then
				nextIndex = 1            -- Wrap back to first mode
			end


			aaMode:set(nextIndex) -- Set the new mode
			dispatch_action(nil, aaModes[nextIndex])
		end


		if command == deviceCommands.U_ag then
			if value == 1 then
				dispatch_action(nil, 111)
			end
		end

		if command == deviceCommands.U_nav then
			if value == 1 then
				dispatch_action(nil, 105)
			end
		end

		if command == deviceCommands.U_inst then
			if value == 1 then
				dispatch_action(nil, 156)
			end
		end
	end
end



need_to_be_closed = false