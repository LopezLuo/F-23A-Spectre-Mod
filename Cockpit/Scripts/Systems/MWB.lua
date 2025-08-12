dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

local dev = GetSelf()

local update_time_step     = .01
local sensor_data          = get_base_data()
local MWB_current          = 0  -- Current MWB Door position
local MWB_target           = 0  -- MWB Door desired position
local SRB_current          = 0  -- Current SRB Door position
local SRB_target           = 0  -- SRB Door desired position
local MWB_deployment_speed = 3  -- Default in air Deployment Speed
local SRB_deployment_speed = 3  -- Default in air Deployment Speed
local gun_door_current     = 0  -- Current gun_door  position
local gun_door_target      = 0  -- gun_door desired position
local deployment_speed     = 10 -- Gun door deployment speed

make_default_activity(update_time_step)

local main_weapon_bay_select = get_param_handle("MWBSelect")
local short_range_bay_select = get_param_handle("SRBSelect")
local weap_bay_man_operation = get_param_handle("WBM OP")
local navigation_mode        = get_param_handle("navMode")
local arm_state              = get_param_handle("masterArm")
get_param_handle("masterMode"):set(1)
get_param_handle("AMRAAMCount"):set(6)     -- Placeholder for AIM-120 count.
get_param_handle("sidewinderCount"):set(2) -- Placeholder for AIM-9 count.
local nextAMRAAM = get_param_handle("nextAMRAAM")


main_weapon_bay_select:set(0)
short_range_bay_select:set(0)
weap_bay_man_operation:set(0)
navigation_mode:set(0)
arm_state:set(0)

dev:listen_command(deviceCommands.arm_switch)

dev:listen_command(keys.PlanePickleOn)
dev:listen_command(keys.PlanePickleOff)
dev:listen_command(keys.manual_bay_operation)
dev:listen_command(keys.weap_bay_select)
dev:listen_command(keys.SRBSelect)
dev:listen_command(keys.PlaneModeBVR)
dev:listen_command(keys.PlaneModeVS)
dev:listen_command(keys.PlaneModeNAV)
dev:listen_command(keys.PlaneModeBore)
dev:listen_command(keys.PlaneModeGround)
dev:listen_command(110) -- Longitudinal/FLOOD
dev:listen_command(keys.first_stage_trigger_on)
dev:listen_command(keys.first_stage_trigger_off)
dev:listen_command(keys.second_stage_trigger_on)
dev:listen_command(keys.second_stage_trigger_off)
dev:listen_command(keys.pickle_on)
dev:listen_command(keys.pickle_off)
dev:listen_command(keys.master_arm_switch)
dev:listen_command(keys.PlaneChangeWeapon)
dev:listen_command(84) -- PlaneFire
dev:listen_command(85)
dev:listen_command(350)
dev:listen_command(351)



function post_initialize()
	get_param_handle("MWBMoving"):set(0)
	get_param_handle("SRBMoving"):set(0)

	local birth = LockOn_Options.init_conditions.birth_place
	navigation_mode:set(1)
	if birth == "AIR_HOT" then
		MWB_current = 0
		SRB_current = 0
	elseif birth == "GROUND_HOT" then
		MWB_current = 0
		SRB_current = 0
	elseif birth == "GROUND_COLD" then
		MWB_current = 1
		SRB_current = 1
		MWB_target = 1
		SRB_target = 1
	end
end

function SetCommand(command, value)
	local wow_right_main = sensor_data.getWOW_RightMainLandingGear() -- Right main gear weight on wheel
	local rpm_right_eng = sensor_data.getEngineRightRPM()         -- Right Engine RPM
	local rpm_left_eng = sensor_data.getEngineLeftRPM()           -- Left Engine RPM

	if get_param_handle("APUBus"):get() == 1 then
		if command == keys.PlaneModeNAV then
			get_param_handle("masterMode"):set(1)
		elseif command == keys.PlaneModeBVR then
			get_param_handle("masterMode"):set(2)
		elseif command == keys.PlaneModeVS then
			get_param_handle("masterMode"):set(3)
		elseif command == keys.PlaneModeBore then
			get_param_handle("masterMode"):set(4)
		elseif command == 110 then
			get_param_handle("masterMode"):set(6)
		elseif command == keys.PlaneModeGround then
			get_param_handle("masterMode"):set(7)
		end


		if command == keys.weap_bay_select then                                    -- Weapons Bay selection
			if main_weapon_bay_select:get() == 0 and short_range_bay_select:get() == 0 then -- Default ot the Main Weapons Bay
				-- print_message_to_user("Main Weapons Bay Selected")
				main_weapon_bay_select:set(1)
				short_range_bay_select:set(0)
			elseif main_weapon_bay_select:get() == 1 then -- Switch to Short Range Bay if Main Weapons Bay is selected
				dispatch_action(nil, 101)
			else
				dispatch_action(nil, 101)
			end
			navigation_mode:set(0)
		end


		if command == keys.PlaneChangeWeapon then
			if main_weapon_bay_select:get() == 1 and get_param_handle("sidewinderCount"):get() > 0 then
				main_weapon_bay_select:set(0)
				short_range_bay_select:set(1)
			elseif short_range_bay_select:get() == 1 and get_param_handle("AMRAAMCount"):get() > 0 then
				main_weapon_bay_select:set(1)
				short_range_bay_select:set(0)
			end
		end

		if command == keys.PlaneModeNAV then -- If player switches the Nav mode, deselect both bays and neither will open with the pickple button
			main_weapon_bay_select:set(0)
			short_range_bay_select:set(0)
			navigation_mode:set(1)
		elseif command == keys.PlaneModeBVR then -- Selects Main Weapons Bays by default
			main_weapon_bay_select:set(1)
			short_range_bay_select:set(0)
			navigation_mode:set(0)
		elseif command == keys.PlaneModeVS then
			if short_range_bay_select:get() == 1 then
				main_weapon_bay_select:set(0)
				short_range_bay_select:set(1)
			else
				main_weapon_bay_select:set(1)
				short_range_bay_select:set(0)
			end

			navigation_mode:set(0)
		elseif command == keys.PlaneModeBore then
			if short_range_bay_select:get() == 1 then
				main_weapon_bay_select:set(0)
				short_range_bay_select:set(1)
			else
				main_weapon_bay_select:set(1)
				short_range_bay_select:set(0)
			end

			navigation_mode:set(0)
		elseif command == 110 then
			main_weapon_bay_select:set(0)
			short_range_bay_select:set(1)
			navigation_mode:set(0)
		end
	end

	if get_param_handle("mainBus"):get() == 1 then
		if command == keys.manual_bay_operation then
			local engine_running = (rpm_left_eng >= 50 or rpm_right_eng >= 50)

			if weap_bay_man_operation:get() == 0 then -- Open maually all WBDs for ground servicing. Doors open at a slow speed
				if wow_right_main == 1 and engine_running then
					MWB_target = MWB_target == 1 and 0 or 1
					SRB_target = SRB_target == 1 and 0 or 1
					MWB_deployment_speed = 0.15
					SRB_deployment_speed = 0.13
				elseif wow_right_main == 0 and engine_running then -- Open all weapons bay doors manually in flight
					MWB_target = MWB_target == 1 and 0 or 1
					SRB_target = SRB_target == 1 and 0 or 1
					MWB_deployment_speed = 3.0
					SRB_deployment_speed = 3.3
				end
				weap_bay_man_operation:set(1.0)
			elseif weap_bay_man_operation:get() == 1 then -- Close maually for all WBDs ground servicing. Doors close at a slow speed
				if wow_right_main == 1 and engine_running then
					MWB_target = MWB_target == 1 and 0 or 1
					SRB_target = SRB_target == 1 and 0 or 1
					MWB_deployment_speed = 0.15
					SRB_deployment_speed = 0.13
				elseif wow_right_main == 0 and engine_running then -- Close door manually in flight
					MWB_target = MWB_target == 1 and 0 or 1
					SRB_target = SRB_target == 1 and 0 or 1
					MWB_deployment_speed = 3.0
					SRB_deployment_speed = 3.3
				end
				weap_bay_man_operation:set(0.0)
			end
		end

		if command == keys.PlanePickleOn then -- Opens doors for weapons employment depending on which bays are selected
			dev:performClickableAction(keys.PlanePickleOn, 1, true)
			if value == 1 and get_param_handle("MWBSelect"):get() == 1 and wow_right_main == 0 then
				MWB_target = 1
				MWB_deployment_speed = 3
			elseif value == 1 and get_param_handle("SRBSelect"):get() == 1 and wow_right_main == 0 then
				SRB_target = 1
				SRB_deployment_speed = 3.3
			end
		elseif command == keys.PlanePickleOff then -- Close selected bay doors
			dev:performClickableAction(keys.PlanePickleOff, 1, true)

			MWB_target = 0
			MWB_deployment_speed = 3.0
			SRB_target = 0
			SRB_deployment_speed = 3.3
		end

		if command == keys.first_stage_trigger_on then -- Open door
			if wow_right_main == 0 and get_param_handle("masterArm"):get() == 1 then
				gun_door_target = 1
			end
		end

		if command == keys.first_stage_trigger_off then -- Close door
			gun_door_target = 0
		end

		if command == keys.second_stage_trigger_on then
			if wow_right_main == 0 and get_param_handle("masterArm"):get() == 1 then
				dispatch_action(nil, 84)
			end
		end

		if command == keys.second_stage_trigger_off then
			dispatch_action(nil, 85)
		end


		if command == keys.pickle_on then -- Weapons release.
			if wow_right_main == 0 and get_param_handle("masterArm"):get() == 1 then
				dispatch_action(nil, 350)
				pickleHeld = true
			end
		end

		if command == keys.pickle_off then
			dispatch_action(nil, 351)
			pickleHeld = false
		end
	end

	if command == deviceCommands.arm_switch then
		if value == 1 then
			arm_state:set(1)
			-- print_message_to_user("Master Arm On")
		elseif value == 0 then
			arm_state:set(0)
			-- print_message_to_user("Master Arm Off")	
		end
	end

	if command == keys.master_arm_switch then
		if arm_state:get() == 0 then
			dev:performClickableAction(deviceCommands.arm_switch, 1, true)
		elseif arm_state:get() == 1 then
			dev:performClickableAction(deviceCommands.arm_switch, 0, true)
		end
	end

	return MWB_target, MWB_deployment_speed, SRB_target, SRB_deployment_speed, gun_door_target -- ???
end

--- Animates the gun door from its current position to the target position.
--- @param gun_door_target number: The target position of the gun door.
--- @return number: The new position of the gun door.
function animate_gun_door(gun_door_target)
	local change_per_frame = deployment_speed *
		update_time_step -- Calculate the change in MWB per frame to achieve the desired speed

	local delta = gun_door_target -
		gun_door_current -- Calculate the difference between current and target MWB

	if math.abs(delta) <= change_per_frame then                          -- Check if we've reached the target or if delta is very small (consider it reached)
		get_param_handle("gunDoorMoving"):set(gun_door_target == 1 and 1 or 0) -- Set the gun door moving parameter to indicate the state
		gun_door_current = gun_door_target
	else
		get_param_handle("gunDoorMoving"):set(1)
		gun_door_current = gun_door_current + (delta > 0 and change_per_frame or -change_per_frame) -- Increment or decrement MWB_current based on the sign of delta
	end

	return gun_door_current
end

--- Animates the MWB from its current position to the target position.
--- @param MWB_target number: The target position of the MWB.
--- @param MWB_deployment_speed number: The speed of the MWB animation.
function animate_MWB(MWB_target, MWB_deployment_speed)
	local change_per_frame = MWB_deployment_speed * update_time_step -- Calculate the change in MWB per frame to achieve the desired speed

	local delta = MWB_target - MWB_current -- Calculate the difference between current and target MWB

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		get_param_handle("MWBMoving"):set(MWB_target == 1 and 2 or 0)
		MWB_current = MWB_target
	else
		get_param_handle("MWBMoving"):set(1)
		MWB_current = MWB_current + (delta > 0 and change_per_frame or -change_per_frame) -- Increment or decrement MWB_current based on the sign of delta
	end
end


--- Animates the SRB from its current position to the target position.
--- @param SRB_target number: The target position of the SRB.
--- @param SRB_deployment_speed number: The speed of the SRB animation.
function animate_SRB(SRB_target, SRB_deployment_speed)
	local change_per_frame = SRB_deployment_speed * update_time_step -- Calculate the change in SRB per frame to achieve the desired speed

	local delta = SRB_target - SRB_current -- Calculate the difference between current and target SRB

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		get_param_handle("SRBMoving"):set(SRB_target == 1 and 2 or 0)
		SRB_current = SRB_target
	else
		get_param_handle("SRBMoving"):set(1)
		SRB_current = SRB_current + (delta > 0 and change_per_frame or -change_per_frame) -- Increment or decrement SRB_current based on the sign of delta
	end
end

function update()
	if pickleHeld then
		if get_param_handle("MWBSelect"):get() == 1 and get_param_handle("MWBMoving"):get() == 2 then
			get_param_handle("AMRAAMCount"):set(get_param_handle("AMRAAMCount"):get() - 1 > 0 and get_param_handle("AMRAAMCount"):get() - 1 or 0)
			pickleHeld = false
		elseif get_param_handle("SRBSelect"):get() == 1 and get_param_handle("SRBMoving"):get() == 2 then
			get_param_handle("sidewinderCount"):set(get_param_handle("sidewinderCount"):get() - 1 > 0 and get_param_handle("sidewinderCount"):get() - 1 or 0)
			pickleHeld = false
		end
	end


	local SWCount = get_param_handle("sidewinderCount"):get()
	local SRBSelected = get_param_handle("SRBSelect"):get() == 1

	get_param_handle("leftSWColor"):set(
		SWCount < 2 and -1 or
		((SRBSelected and SWCount == 2 and pickleHeld) and 2) or
		(SRBSelected and SWCount == 2 and 1) or
		(SRBSelected and SWCount == 1 and -1) or 0
	)
	get_param_handle("rightSWColor"):set(
		SWCount == 0 and -1 or
		((SRBSelected and SWCount == 1 and pickleHeld) and 2) or
		(SRBSelected and SWCount > 0 and 1) or 0
	)
	get_param_handle("nextSW"):set(
		SWCount == 0 and 0 or
		(SRBSelected and SWCount == 2 and 1) or
		(SRBSelected and SWCount == 1 and 2) or 0
	)


	local AMRAAMCount = get_param_handle("AMRAAMCount"):get()
	local MWBSelected = get_param_handle("MWBSelect"):get() == 1

	get_param_handle("leftAMRAAMColor"):set(
		AMRAAMCount < 5 and -1 or
		((MWBSelected and (AMRAAMCount == 6 or AMRAAMCount == 5) and pickleHeld) and 2) or
		(MWBSelected and 1) or 0
	)
	get_param_handle("leftAMRAAMCount"):set(
		AMRAAMCount == 0 and 0 or (AMRAAMCount == 6 and 2) or
		(AMRAAMCount == 5 and 1) or 0
	)
	get_param_handle("centerAMRAAMColor"):set(
		AMRAAMCount < 1 and -1 or
		((MWBSelected and (AMRAAMCount == 2 or AMRAAMCount == 1) and pickleHeld) and 2) or
		(MWBSelected and 1) or 0
	)
	get_param_handle("centerAMRAAMCount"):set(
		AMRAAMCount == 0 and 0 or (AMRAAMCount >= 2 and 2) or
		(AMRAAMCount == 1 and 1) or 0
	)
	get_param_handle("rightAMRAAMColor"):set(
		AMRAAMCount < 3 and -1 or
		((MWBSelected and (AMRAAMCount == 4 or AMRAAMCount == 3) and pickleHeld) and 2) or
		(MWBSelected and 1) or 0
	)
	get_param_handle("rightAMRAAMCount"):set(
		AMRAAMCount == 0 and 0 or (AMRAAMCount >= 4 and 2) or
		(AMRAAMCount == 3 and 1) or 0
	)
	nextAMRAAM:set(
		AMRAAMCount == 0 and 0 or
		(MWBSelected and (AMRAAMCount == 6 or AMRAAMCount == 5) and 1) or
		(MWBSelected and (AMRAAMCount == 4 or AMRAAMCount == 3) and 3) or
		(MWBSelected and (AMRAAMCount == 2 or AMRAAMCount == 1) and 2) or 4
	)
	get_param_handle("leftAMRAAMNext"):set(nextAMRAAM:get() == 1 and 1 or 0)
	get_param_handle("centerAMRAAMNext"):set(nextAMRAAM:get() == 2 and 1 or 0)
	get_param_handle("rightAMRAAMNext"):set(nextAMRAAM:get() == 3 and 1 or 0)


	local wow_right_main = sensor_data.getWOW_RightMainLandingGear() -- Right main gear weight on wheel
	local rpm_right_eng = sensor_data.getEngineRightRPM()         -- Right Engine RPM
	local rpm_left_eng = sensor_data.getEngineLeftRPM()           -- Left Engine RPM

	animate_gun_door(gun_door_target)
	animate_MWB(MWB_target, MWB_deployment_speed)
	animate_SRB(SRB_target, SRB_deployment_speed)
	set_aircraft_draw_argument_value(700, MWB_current) -- MWB draw call
	set_aircraft_draw_argument_value(701, MWB_current)
	set_aircraft_draw_argument_value(702, SRB_current) -- SRB draw call
	set_aircraft_draw_argument_value(703, SRB_current)
	set_aircraft_draw_argument_value(614, gun_door_current) -- MWB draw call
end


need_to_be_closed = false