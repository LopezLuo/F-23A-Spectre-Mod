dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

local dev = GetSelf()

-- ===== Local variables =====
local updateTimeStep = .01
make_default_activity(updateTimeStep)
local sensor_data = get_base_data()

local left_throt_cutoff  = 0
local right_throt_cutoff = 0
local APU_start_stop     = 0
local APU_current        = 0
local APU_target         = 0
local RAD_TO_DEGREE      = 57.29577951308233 -- Radians to Degrees
local APU_speed          = 2.5               -- Default APU Door speed
local gear_target        = 0
local gear_current       = 0
local gear_speed         = 0.25
local gear_nose_up       = 0

local gear_handle_target  = 0 -- gear handle
local gear_handle_current = 0 -- gear handle

local l_throt_target  = 0
local r_throt_target  = 0
local l_throt_current = 0
local r_throt_current = 0
local animation_speed = 3

local LGenSwitch_state    = 0
local RGenSwitch_state    = 0
local l_gen_pwr_state     = 0
local r_gen_pwr_state     = 0
local previous_flap_state = false
local flap_posit          = 0

local frame_time_step          = .01                                -- Time step per frame
local delay_in_seconds         = 10                                 -- Desired delay in seconds
local frames_required          = delay_in_seconds / frame_time_step -- Calculate number of frames needed for the delay
local current_frame_count      = 0                                  -- Frame counter
local APU_running              = false                              -- Status of the APU
local spool_down_time          = 12                                 -- APU spool down time
local req_spool_down_frames    = spool_down_time / frame_time_step
local current_spool_down_frame = 0
local APU_spooling_down        = false
local flap_pos                 = 0
local rpm_left_eng             = 0
local rpm_right_eng            = 0
local ind_spd                  = 0
local AoA                      = 0
local Mach                     = 0
local gforce                   = 0
local wow_right_main           = 0
local wow_left_main            = 0
local peenTime = .0
--
-- local batCount = 0


local sndhost
local APUSTART
local APURUN
local APUSTOP
local PEENOR
local APU_sound_state = 0 -- 0: Off, 1: Starting, 2: Running, 3: Stopping


local APU_gen     = get_param_handle("APUGen")
local Eng1Running = get_param_handle("Eng1Running")
local Eng2Running = get_param_handle("Eng2Running")
local gear_lever  = get_param_handle("GEAR_LEVER")
local bat_power   = get_param_handle("batteryPower")

APU_gen:set(0.0)
Eng1Running:set(0.0)
Eng2Running:set(0.0)
gear_lever:set(0.0)



dev:listen_command(deviceCommands.AAR_DOOR_Selector)
dev:listen_command(deviceCommands.APU_switch)
dev:listen_command(deviceCommands.TANKS_Selector)
dev:listen_command(deviceCommands.gear_lever)
dev:listen_command(keys.l_engine_start)
dev:listen_command(keys.l_engine_stop)
dev:listen_command(keys.r_engine_start)
dev:listen_command(keys.r_engine_stop)
dev:listen_command(keys.bat_off)
dev:listen_command(keys.APU)
dev:listen_command(keys.PlaneFlapsOn)
dev:listen_command(keys.GearUp)   -- Gear up
dev:listen_command(keys.GearDown) -- Gear down


dev:listen_command(72)
dev:listen_command(145)
dev:listen_command(155)
dev:listen_command(315)
dev:listen_command(311)
dev:listen_command(312)
dev:listen_command(313)
dev:listen_command(314)
dev:listen_command(430)
dev:listen_command(431)


function post_initialize()
	local birth = LockOn_Options.init_conditions.birth_place

	if birth == "AIR_HOT" then
		dev:performClickableAction(deviceCommands.TANKS_Selector, 1, true)

		dispatch_action(nil, 430)
		Eng1Running:set(1)
		Eng2Running:set(1)

		gear_handle_target = 0.0
		gear_handle_current = 0.0
	elseif birth == "GROUND_HOT" then
		dev:performClickableAction(deviceCommands.TANKS_Selector, 1, true)

		dispatch_action(nil, 431)
		gear_current = 1.0
		gear_target = 1.0

		Eng1Running:set(1)
		Eng2Running:set(1)

		gear_current = 1
		gear_target = 1
		gear_handle_target = 1
		gear_handle_current = 1
	elseif birth == "GROUND_COLD" then
		dev:performClickableAction(deviceCommands.TANKS_Selector, 1, true)
		dispatch_action(nil, 431)
		gear_current = 1.0
		gear_target = 1.0
		gear_handle_target = 1.0
		gear_handle_current = 1.0
	end

	-- Initialize sound objects
	sndhost  = create_sound_host("COCKPIT_ARMS", "3D", 0, 0, 0)
	APUSTART = sndhost:create_sound("Aircrafts/F-23A/Cockpit/apu_start")
	APURUN   = sndhost:create_sound("Aircrafts/F-23A/Cockpit/apu_run")
	APUSTOP  = sndhost:create_sound("Aircrafts/F-23A/Cockpit/apu_stop")
	PEENOR   = sndhost:create_sound("Aircrafts/F-23A/Cockpit/peenor")

	-- print_message_to_user("DEBUG: APU sound objects created")
end


--- Updates the sensor data variables.
function Sensor_data()
	Mach = sensor_data.getMachNumber()
	AoA = sensor_data.getAngleOfAttack() * RAD_TO_DEGREE
	rpm_left_eng = sensor_data.getEngineLeftRPM()
	rpm_right_eng = sensor_data.getEngineRightRPM()
	flap_pos = sensor_data.getFlapsPos()
	ind_spd = sensor_data.getIndicatedAirSpeed() * 1.944
	flap_posit = get_aircraft_draw_argument_value(9)
	gforce = sensor_data.getVerticalAcceleration()
	gear_nose_up = sensor_data.getNoseLandingGearUp()
	wow_right_main = sensor_data.getWOW_RightMainLandingGear()
	wow_left_main = sensor_data.getWOW_LeftMainLandingGear()
end

function SetCommand(command, value)
	if command == deviceCommands.APU_switch then
		if value == 1 then
			get_param_handle("APUSwitch"):set(1)
			if bat_power:get() == 1 then
				if not APU_running and not APU_spooling_down then
					-- print_message_to_user("APU Start")
					APU_start_stop = 1
					APU_target = 1
					current_frame_count = 0 -- Reset the counter to start counting from zero
				end
			else
				print_message_to_user("Must Have Power On To Run APU")
			end
		elseif value == 0 then
			get_param_handle("APUSwitch"):set(0)
			if APU_running then
				-- print_message_to_user("APU Shutdown Initiated")
				APU_spooling_down = true
				APU_start_stop = 0 -- Prevent APU from starting
				current_spool_down_frame = 0 -- Start the spool down counter
				APU_running = false -- Immediately set running to false to initiate spool down
			end
		end
	end



	if command == keys.GearUp and ind_spd < 250 and wow_left_main == 0 and wow_right_main == 0 then
		-- dev:performClickableAction(device_commands.gear_lever, 0, true)	
		gear_target = 0.0
		gear_handle_target = 0.0
		dispatch_action(nil, 430)

	elseif command == keys.GearDown and ind_spd < 250 then
		-- dev:performClickableAction(device_commands.gear_lever, 1, true)
		gear_target = 1.0
		gear_handle_target = 1.0
		dispatch_action(nil, 431)
	end

	if command == keys.APU then
		if bat_power:get() == 1 then
			if not APU_running and not APU_spooling_down then
				if APU_start_stop == 0 then
					dev:performClickableAction(deviceCommands.APU_switch, 1, true)
				end
			elseif APU_running then
				dev:performClickableAction(deviceCommands.APU_switch, 0, true)
			end
		else
			print_message_to_user("Must Have Power On To Run APU")
		end
	end



	if command == keys.l_engine_start then
		if get_param_handle("APUGen"):get() == 1 and get_param_handle("batteryPower"):get() == 1 then
			dispatch_action(nil, 311)
			Eng1Running:set(1)
		else
			print_message_to_user("Must start APU to start engines")
		end
	end

	if command == keys.l_engine_stop then
		dispatch_action(nil, 313)
		-- print_message_to_user("Shutting down left engine")
		Eng1Running:set(0)
	end

	if command == keys.r_engine_start then
		if get_param_handle("APUGen"):get() == 1 and get_param_handle("batteryPower"):get() == 1 then
			dispatch_action(nil, 312)
			Eng2Running:set(1)
		else
			print_message_to_user("Must start APU to start engines")
		end
	end

	if command == keys.r_engine_stop then
		dispatch_action(nil, 314)
		-- print_message_to_user("Shutting down right engine")
		Eng2Running:set(0)
	end

	if command == deviceCommands.AAR_DOOR_Selector then
		if get_param_handle("mainBus"):get() == 1 then
			if value == 1 then
				dispatch_action(nil, 155)
				get_param_handle("AARDoorState"):set(1)
				-- print_message_to_user("AAR Door open")
			elseif value == 0 then
				dispatch_action(nil, 155)
				get_param_handle("AARDoorState"):set(0)
				-- print_message_to_user("AAR Door closed")
			end
		else
			print_message_to_user("Must have power on to open AAR door")
		end
	end
end


--- Updates the APU state.
function APU_state()
	if APU_start_stop == 1 and current_frame_count < frames_required then
		get_param_handle("APUState"):set(1) -- Set APU state to starting
		current_frame_count = current_frame_count + 1
		local elapsed_time = current_frame_count * frame_time_step
	elseif current_frame_count >= frames_required and not APU_spooling_down then
		APU_running = true
		-- print_message_to_user("APU is now running and available to provide power.")
		get_param_handle("APUGen"):set(1)
		get_param_handle("APUState"):set(2) -- Set APU state to running
		APU_start_stop = 0
		current_frame_count = 0
	end

	if APU_spooling_down then
		get_param_handle("APUState"):set(3) -- Set APU state to shutting down
		if current_spool_down_frame < req_spool_down_frames then
			current_spool_down_frame = current_spool_down_frame + 1
			local elapsed_time = current_spool_down_frame * frame_time_step
		else
			APU_spooling_down = false
			APU_running = false
			get_param_handle("APUGen"):set(0)
			APU_target = 0
			-- print_message_to_user("APU is now shut down.")
			current_spool_down_frame = 0
			get_param_handle("APUState"):set(0)
		end
	end
	manage_APU_sounds()
end


--- Manages the APU sounds based on its current state.
function manage_APU_sounds()
	if APU_start_stop == 1 and current_frame_count < frames_required then
		if APU_sound_state ~= 1 then
			-- print_message_to_user("DEBUG: Attempting to play APU Start sound")
			APUSTART:play_once()
			APU_sound_state = 1
			-- print_message_to_user("DEBUG: APU sound state set to Starting")
		end
	elseif APU_running and not APU_spooling_down then
		if APU_sound_state ~= 2 then
			-- print_message_to_user("DEBUG: Stopping APU Start sound, playing APU Run sound")
			APUSTART:stop()
			APURUN:play_continue()
			APU_sound_state = 2
			-- print_message_to_user("DEBUG: APU sound state set to Running")
		end
	elseif APU_spooling_down then
		if APU_sound_state ~= 3 then
			-- print_message_to_user("DEBUG: Stopping APU Run sound, playing APU Stop sound")
			APURUN:stop()
			APUSTOP:play_once()
			APU_sound_state = 3
			-- print_message_to_user("DEBUG: APU sound state set to Stopping")
		end
	else
		if APU_sound_state ~= 0 then
			-- print_message_to_user("DEBUG: Stopping all APU sounds")
			APUSTART:stop()
			APURUN:stop()
			APUSTOP:stop()
			APU_sound_state = 0
			-- print_message_to_user("DEBUG: APU sound state set to Off")
		end
	end
end

--- Animates the APU from its current position to the target position.
--- @param APU_target number: The target position of the APU.
--- @param APU_speed number: The speed of the APU animation.
function animate_APU(APU_target, APU_speed)
	local change_per_frame = APU_speed *
		updateTimeStep -- Calculate the change in MWB per frame to achieve the desired speed

	local delta = APU_target -
		APU_current -- Calculate the difference between current and target MWB

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		APU_current = APU_target
	else
		APU_current = APU_current + (delta > 0 and change_per_frame or -change_per_frame)
	end
end

--- Animates the gear from its current position to the target position.
--- @param gear_target number: The target position of the gear.
--- @param gear_speed number: The speed of the gear animation.
function animate_gear(gear_target, gear_speed)
	local change_per_frame = gear_speed * updateTimeStep -- Calculate the change in MWB per frame to achieve the desired speed

	local delta = gear_target - gear_current -- Calculate the difference between current and target MWB

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		gear_current = gear_target
	else
		gear_current = gear_current + (delta > 0 and change_per_frame or -change_per_frame)
	end
end


--- Sets the left throttle cutoff based on the engine run state.
function set_l_throttle_cutoff()
	if get_param_handle("Eng1Running"):get() == 1 then
		l_throt_target = 1
	else
		l_throt_target = -1
	end
end

--- Sets the right throttle cutoff based on the engine run state.
function set_r_throttle_cutoff()
	if get_param_handle("Eng2Running"):get() == 1 then
		r_throt_target = 1
	else
		r_throt_target = -1
	end
end


--- Animates the gear handle from its current position to the target position.
--- @param gear_handle_target number: The target position of the gear handle.
--- @param animation_speed number: The speed of the gear handle animation.
function animate_gear_handle(gear_handle_target, animation_speed)
	local change_per_frame = animation_speed * updateTimeStep
	local delta = gear_handle_target - gear_handle_current

	if math.abs(delta) <= change_per_frame then
		gear_handle_current = gear_handle_target
		-- print_message_to_user(gear_handle_current)
	else
		gear_handle_current = gear_handle_current + (delta > 0 and change_per_frame or -change_per_frame)
		-- print_message_to_user(gear_handle_current)
	end
end

--- Animates the left throttle from its current position to the target position.
--- @param l_throt_target number: The target position of the left throttle.
--- @param animation_speed number: The speed of the left throttle animation.
function animate_l_throt(l_throt_target, animation_speed)
	local change_per_frame = animation_speed * updateTimeStep

	local delta = l_throt_target - l_throt_current

	if math.abs(delta) <= change_per_frame then
		l_throt_current = l_throt_target
	else
		l_throt_current = l_throt_current + (delta > 0 and change_per_frame or -change_per_frame)
	end
end

--- Animates the right throttle from its current position to the target position.
--- @param r_throt_target number: The target position of the right throttle.
--- @param animation_speed number: The speed of the right throttle animation.
function animate_r_throt(r_throt_target, animation_speed)
	local change_per_frame = animation_speed * updateTimeStep

	local delta = r_throt_target - r_throt_current

	if math.abs(delta) <= change_per_frame then
		r_throt_current = r_throt_target
	else
		r_throt_current = r_throt_current + (delta > 0 and change_per_frame or -change_per_frame)
	end
end







--- Checks the flap positions and adjusts them based on airspeed and AoA.
function check_flaps()
	-- Configuration variables
	local gear_down_max_speed = 250 -- Max speed with landing gear down
	local gear_down_min_speed = 200 -- Speed for full flap deployment with gear down
	local gear_down_initial_flap = 0.2 -- Initial flap deployment at max gear down speed (5.9%)

	local aoa_target = 2.0 -- Target AoA we want to maintain
	local aoa_max_flap = 12.0 -- AoA where we reach maximum flap deployment
	local aoa_flap_max = 0.5 -- Maximum flap deployment during AoA with gear up (50%)

	local g_flap_max = 1.0 -- Maximum flap deployment (100%)

	-- Initialize flap_position with the current flap position to prevent retractions
	local current_flap_left = get_aircraft_draw_argument_value(9)
	local current_flap_right = get_aircraft_draw_argument_value(10)
	local flap_position = .0

	-- Calculate constants
	local gear_down_speed_range = gear_down_max_speed - gear_down_min_speed

	-- Check engine RPM first - no flaps if engines aren't running sufficiently
	if rpm_left_eng <= 65 then
		set_aircraft_draw_argument_value(9, 0)
		set_aircraft_draw_argument_value(10, 0)
		return
	end

	-- Get landing gear state
	local gear_down = get_aircraft_draw_argument_value(0) > 0.5 -- Assuming draw argument 0 represents gear state

	if gear_down then
		-- LANDING GEAR DOWN LOGIC
		if ind_spd <= gear_down_min_speed then
			-- Full flaps at or below the minimum speed with gear down
			flap_position = g_flap_max
		elseif ind_spd <= gear_down_max_speed then
			-- Linear deployment between min and max speeds with gear down
			-- Start at gear_down_initial_flap (5.9%) at max speed
			-- End at g_flap_max (100%) at min speed
			local speed_factor = (gear_down_max_speed - ind_spd) / gear_down_speed_range
			flap_position = gear_down_initial_flap + (speed_factor * (g_flap_max - gear_down_initial_flap))
		else
			-- Above maximum gear down speed
			-- Keep minimum flap position
			flap_position = gear_down_initial_flap
		end
	else
		-- LANDING GEAR UP LOGIC (AoA minimization strategy)
		-- We want to deploy flaps to help reduce AoA, with more flaps as AoA increases
		-- Only activate if AoA is greater than our target
		if AoA <= aoa_target then
			-- Below target AoA, no flaps needed
			flap_position = 0
		elseif AoA >= aoa_max_flap then
			-- At or above max AoA threshold, use maximum allowed flaps
			flap_position = aoa_flap_max
		else
			-- Between target and max AoA, deploy flaps proportionally
			-- The further we are from target, the more flaps we deploy
			local excess_aoa = AoA - aoa_target
			local max_excess = aoa_max_flap - aoa_target
			local aoa_factor = excess_aoa / max_excess

			-- Ensure factor is between a minimum value and 1.0
			aoa_factor = math.max(0, math.min(1.0, aoa_factor))
			flap_position = aoa_factor * aoa_flap_max
		end
	end

	-- Non-decreasing flap logic for gear down only
	-- For gear up, we want flaps to follow AoA changes in both directions
	-- No non-decreasing logic for either gear state
	-- Both will now respond to their respective inputs (AoA or airspeed)

	-- Apply the flap position
	set_aircraft_draw_argument_value(9, flap_position)
	set_aircraft_draw_argument_value(10, flap_position)

	-- Debug output - uncomment if needed
	-- print(string.format("IAS: %.1f, AoA: %.1f, Gear: %s, FlapsPos: %.2f",
	--                    ind_spd, AoA, gear_down and "DOWN" or "UP", flap_position))
end


function update()
	get_param_handle("gearUp"):set((get_aircraft_draw_argument_value(0) == 0 and get_aircraft_draw_argument_value(3) == 0 and get_aircraft_draw_argument_value(5) == 0) and 1 or 0)
	get_param_handle("APUSignature"):set(get_aircraft_draw_argument_value(605) > 0 and 1 or 0)

	Sensor_data()
	check_flaps()
	set_l_throttle_cutoff()
	set_r_throttle_cutoff()
	APU_state() -- This now includes manage_APU_sounds()

	animate_APU(APU_target, APU_speed)
	animate_gear(gear_target, gear_speed)
	animate_l_throt(l_throt_target, animation_speed)
	animate_r_throt(r_throt_target, animation_speed)
	animate_gear_handle(gear_handle_target, animation_speed)

	set_aircraft_draw_argument_value(605, APU_current)
	set_aircraft_draw_argument_value(0, gear_current)
	set_aircraft_draw_argument_value(3, gear_current)
	set_aircraft_draw_argument_value(5, gear_current)

	get_param_handle("LEFT_THROTTLE_CUTOFF"):set(l_throt_current)
	get_param_handle("RIGHT_THROTTLE_CUTOFF"):set(r_throt_current)
	get_param_handle("GEAR_LEVER"):set(gear_handle_current)



	if math.floor(get_param_handle("IAS"):get()) == 420 then
		peenTime = peenTime + updateTimeStep
		if peenTime >= 6.9 then
			PEENOR:play_once()
			peenTime = 0
		end
	end
end



need_to_be_closed = false