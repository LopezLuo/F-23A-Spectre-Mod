dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 0.01
make_default_activity(updateTimeStep)


local flcs = GetSelf()

flcs:listen_command(10163) -- Yaw axis
flcs:listen_command(10164) -- Roll axis
flcs:listen_command(10165) -- Pitch axis
flcs:listen_command(10013) -- FLCSTest
flcs:listen_command(keys.RudderLeft) 
flcs:listen_command(keys.RudderRight)
flcs:listen_command(keys.airBrakeOn)
flcs:listen_command(keys.airBrakeOff)
flcs:listen_command(keys.planeAirBrake)
flcs:listen_command(keys.FLCSTest)
flcs:listen_command(keys.nws_rate)
flcs:listen_command(deviceCommands.FLCS_Selector)


local baseData = get_base_data()


local yaw   = get_param_handle("yawOutput")
local roll  = get_param_handle("rollOutput")
local pitch = get_param_handle("pitchOutput")

local currentPhase = get_param_handle("currentPhase")

local APUBus = get_param_handle("APUBus")
local mainBus = get_param_handle("mainBus")


-- Control surface variables:
local OBFlapperonCurrent = .0
local OBFlapperonTarget = .0
local IB_flapperon_current = .0
local IB_flapperon_target = .0
local LEF_current = .0
local LEF_target = .0
local R_V_Tail = 0.0
local L_V_Tail = 0.0
local R_O_Flapperon = 0.0
local L_O_Flapperon = 0.0
local L_V_Tail_current = 0.00
local R_V_Tail_current = 0.00
local effective_rudder_input = 0
local aileron_input = 0
local elevator_input = .0

local OBFlapperonCurrent_left = .0
local OBFlapperonCurrent_right = .0
local IB_flapperon_current_left = .0
local IB_flapperon_current_right = .0

-- Other variables
local RAD_TO_DEGREE = 57.29577951308233
local AoA = .0
local Mach = .0
local ias = .0
local deployment_speed = 1.0
local air_brake_current = 0.0
local air_brake_target = 0.0
local air_brake_out = false
local rudder_input = 0.0
local last_nose_wheel_angle = 0.0
local min_turn_rate = 15
local max_turn_rate = 90
local high_gain_speed = 3
local self_ground_speed = 0.0

local v_tail_test_active = false
local v_tail_test_timer = 0

-- FLCS test variables
local flcs_test_active = false
local flcs_test_step = 0
local flcs_test_timer = .0

-- AoA limiter thresholds
local aoa_warning = 28.0    -- First warning threshold
local aoa_caution = 33.0    -- Caution threshold
local aoa_hard_limit = 38.0 -- Hard limit where maximum limiting occurs

-- G limiter thresholds
local g_threshold = 7.5  -- Warning threshold
local g_hard_limit = 9.0 -- Hard limit where maximum limiting occurs

-- NWS rate variables
local nws_rate_state = 2    -- 1 = low (20%), 2 = high (100%) - default
local nws_speed_scale = 1.0 -- Default to high rate (100%)

function post_initialize()
	get_param_handle("AoAWarning"):set(0)
	get_param_handle("nwsRateState"):set(2) -- Set to high rate by default
end

--- Updates sensor data.
function Sensor_data()
	Mach = baseData.getMachNumber()
	AoA = (baseData.getAngleOfAttack() * RAD_TO_DEGREE)
	get_param_handle("AoA"):set(AoA)

	ias = (baseData.getIndicatedAirSpeed() * 1.944)
end

function SetCommand(command, value)
	if currentPhase:get() >= 6 and currentPhase:get() <= 8 then
		if command == keys.planeAirBrake then
			-- print_message_to_user("Airbrake toggled")
			if air_brake_out == false then
				air_brake_target = 1
				air_brake_out = true
			else
				air_brake_target = 0
				air_brake_out = false
			end
		end

		if command == keys.airBrakeOn then
			air_brake_target = 1
			air_brake_out = true
		end

		if command == keys.airBrakeOff then
			air_brake_target = 0
			air_brake_out = false
		end
	end

	if mainBus:get() == 1 then
		if command == 10013 then -- FLCSTest
			-- flcs:performClickableAction(device_commands.FLCS_Selector, 1, true)
			start_flcs_test()
		end

		if command == deviceCommands.FLCS_Selector then
			if value == 1 then
				start_flcs_test()
			elseif value == 0 then
				if flcs_test_active then
					flcs_test_active = false
					print_message_to_user("FLCS test cancelled")
					-- Don't reset any values - let normal flight control logic
					-- gradually move surfaces to their appropriate positions
				end
			end
		end

		if command == keys.RudderLeft then 
			if rudder_input == 0.0 then
				rudder_input = -1
			else
				rudder_input = 0.0
			end
		end

		if command == keys.RudderRight then 
			if rudder_input == 0.0 then
				rudder_input = 1.0
			else
				rudder_input = 0
			end
		end

		if command == 10163 then
			rudder_input = value
		end

		if command == 10164 then
			aileron_input = value
		end

		if command == 10165 then
			elevator_input = value
		end
	end

	if APUBus:get() == 1 then
		if command == keys.nws_rate then
			-- Check if nose wheel is on ground before allowing NWS rate change
			local nose_wow = baseData.getWOW_NoseLandingGear()

			if nose_wow == 1 then
				-- Nose wheel is on ground - allow rate change
				-- Cycle through NWS rates: high -> low -> high
				if nws_rate_state == 2 then -- high -> low
					nws_rate_state = 1
					nws_speed_scale = 0.2
					-- print_message_to_user("NWS Rate: LOW (20%)")
				else -- low -> high
					nws_rate_state = 2
					nws_speed_scale = 1.0
					-- print_message_to_user("NWS Rate: HIGH (100%)")
				end
				get_param_handle("nwsRateState"):set(nws_rate_state)
			else
				-- Nose wheel is off ground - cannot change NWS rate
				print_message_to_user("NWS Rate change not available - nose wheel airborne")
			end
		end
	end
end


--- Calculates the alpha movement based on AoA.
--- @return number: The alpha movement value.
function alpha_movement()
	return AoA / 30
end


--- Calculates the outboard flapperon movement based on AoA.
--- @return number: The outboard flapperon movement value.
function OB_alpha_movement()
	return AoA >= 0 and AoA / 40 or 0
end


--- Calculates the inboard flapperon movement based on AoA.
--- @return number: The inboard flapperon movement value.
function IB_alpha_movement()
	return AoA >= 0 and AoA / 20 or 0
end


--- Calculates the AoA limiter based on the provided AoA.
--- @param aoa number: The angle of attack to evaluate.
--- @return number: The limiting factor for the AoA.
function calculate_aoa_limiter(aoa)
	local warning_threshold = aoa_warning
	local caution_threshold = aoa_caution
	local hard_limit = aoa_hard_limit
	local min_multiplier = 0.3 -- Maximum 70% reduction

	if aoa <= warning_threshold then
		return 1.0 -- No limiting
	elseif aoa >= hard_limit then
		get_param_handle("AoAWarning"):set(1)
		return min_multiplier -- Maximum limiting
	else
		get_param_handle("AoAWarning"):set(0)
		-- Progressive limiting between warning and hard limit
		local range = hard_limit - warning_threshold
		local excess = aoa - warning_threshold
		local factor = excess / range
		local result = 1.0 - (factor * (1.0 - min_multiplier))
		return result
	end
end

--- Calculates the G limiter based on the provided G force.
--- @param g_force number: The G force to evaluate.
--- @return number: The limiting factor for the G force.
function calculate_g_limiter(g_force)
	local warning_threshold = g_threshold
	local hard_limit = g_hard_limit
	local min_multiplier = 0.2 -- Maximum 80% reduction

	-- Only limit positive G forces
	if g_force <= warning_threshold then
		return 1.0 -- No limiting
	elseif g_force >= hard_limit then
		return min_multiplier -- Maximum limiting
	else
		-- Progressive limiting between warning and hard limit
		local range = hard_limit - warning_threshold
		local excess = g_force - warning_threshold
		local factor = excess / range
		local result = 1.0 - (factor * (1.0 - min_multiplier))
		return result
	end
end

--- Animates a control surface from its current position to a target position.
--- @param current number: The current position of the control surface.
--- @param target number: The target position of the control surface.
--- @param speed number: The speed of the animation.
--- @return number: The new position of the control surface.
function animate_surface(current, target, speed)
	local change = speed * updateTimeStep
	if math.abs(target - current) <= change then
		return target
	elseif target > current then
		return current + change
	else
		return current - change
	end
end


--- Starts the FLCS test sequence.
function start_flcs_test()
	local on_ground = baseData.getWOW_NoseLandingGear() == 1 and baseData.getWOW_LeftMainLandingGear() == 1 and baseData.getWOW_RightMainLandingGear() == 1

	local parking_brake_set = get_param_handle("parkingBrake"):get() == 1
	local engines_running = baseData.getEngineLeftRPM() > 50 and baseData.getEngineRightRPM() > 50

	if on_ground and parking_brake_set and engines_running then
		print_message_to_user("FLCS test started")
		flcs_test_active = true
		flcs_test_step = 1
		flcs_test_timer = .0
	else
		if not on_ground then
			print_message_to_user("FLCS test cannot start: Aircraft not on ground")
		elseif not parking_brake_set then
			print_message_to_user("FLCS test cannot start: Parking Brake not set")
		elseif not engines_running then -- Fixed: removed the stray "-"
			print_message_to_user("FLCS test cannot start: Engines not running")
		end
	end
end


--- Updates the FLCS test.
--- @param delta_time number: The time since the last update in seconds.
function update_flcs_test(delta_time)
	if not flcs_test_active then return end

	flcs_test_timer = flcs_test_timer + delta_time

	if flcs_test_step == 1 then
		local movement_speed = 0.75 -- Slower speed for step 1
		-- Step 1: LE flaps down, outboard flapperons up, inboard flapperons down (4 seconds)
		LEF_current = animate_surface(LEF_current, 1.0, movement_speed)
		OBFlapperonCurrent_right = animate_surface(OBFlapperonCurrent_right, 1.0, movement_speed) -- Right wing up
		IB_flapperon_current_right = animate_surface(IB_flapperon_current_right, 1.0, movement_speed) -- Right wing up
		OBFlapperonCurrent_left = animate_surface(OBFlapperonCurrent_left, 1.0, movement_speed) -- Left wing down
		IB_flapperon_current_left = animate_surface(IB_flapperon_current_left, 1.0, movement_speed) -- Left wing down

		if flcs_test_timer > 2.5 then
			flcs_test_step = 2
			flcs_test_timer = 0
		end
	elseif flcs_test_step == 2 then
		local movement_speed = 1.5 -- Adjust this value to control the speed of V-tail movement
		-- Step 2: V-tails movement (12 seconds total: two complete cycles)
		local vtail_target
		if flcs_test_timer <= 1 then
			vtail_target = 1.0 -- Move to full up position
		elseif flcs_test_timer <= 3.25 then
			vtail_target = -1.0 -- Move to full down position
		elseif flcs_test_timer <= 4.5 then
			vtail_target = 0 -- Return to neutral position
		elseif flcs_test_timer <= 6.0 then
			vtail_target = 1.0 -- Move to full up position (second cycle)
		elseif flcs_test_timer <= 7.5 then
			vtail_target = -1.0 -- Move to full down position (second cycle)
		elseif flcs_test_timer <= 12 then
			vtail_target = 0 -- Return to neutral position (second cycle)
		else
			vtail_target = 0 -- Ensure neutral position at the end
		end

		L_V_Tail_current = animate_surface(L_V_Tail_current, vtail_target, movement_speed)
		R_V_Tail_current = animate_surface(R_V_Tail_current, vtail_target, movement_speed)

		if flcs_test_timer > 9.0 then
			flcs_test_step = 3
			flcs_test_timer = 0
		end
	elseif flcs_test_step == 3 then
		local movement_speed = 1.0 -- Moderate speed for step 3
		-- Step 3: Maximum right roll effort position (3 seconds)
		OBFlapperonCurrent_right = animate_surface(OBFlapperonCurrent_right, 0.7, 2.5) -- Right wing up
		IB_flapperon_current_right = animate_surface(IB_flapperon_current_right, 0.7, 2.5) -- Right wing up
		OBFlapperonCurrent_left = animate_surface(OBFlapperonCurrent_left, -0.7, 2.5) -- Left wing down
		IB_flapperon_current_left = animate_surface(IB_flapperon_current_left, -0.7, 2.5) -- Left wing down
		L_V_Tail_current = animate_surface(L_V_Tail_current, 0.5, movement_speed)
		R_V_Tail_current = animate_surface(R_V_Tail_current, -0.5, movement_speed)

		if flcs_test_timer > 3 then
			flcs_test_step = 4
			flcs_test_timer = 0
		end
	elseif flcs_test_step == 4 then
		local movement_speed = 1.0 -- Moderate speed for step 4
		-- Step 4: Opposite roll direction (left roll, 3 seconds)
		OBFlapperonCurrent_right = animate_surface(OBFlapperonCurrent_right, -0.7, 2.5) -- Right wing down
		IB_flapperon_current_right = animate_surface(IB_flapperon_current_right, -0.7, 2.5) -- Right wing down
		OBFlapperonCurrent_left = animate_surface(OBFlapperonCurrent_left, 0.7, 2.5)  -- Left wing up
		IB_flapperon_current_left = animate_surface(IB_flapperon_current_left, 0.7, 2.5) -- Left wing up
		L_V_Tail_current = animate_surface(L_V_Tail_current, -0.5, movement_speed)
		R_V_Tail_current = animate_surface(R_V_Tail_current, 0.5, movement_speed)

		if flcs_test_timer > 3.5 then
			flcs_test_step = 5
			flcs_test_timer = 0
		end
	elseif flcs_test_step == 5 then
		local movement_speed = 1.0 -- Slower speed for step 5
		-- Step 5: Return all surfaces to neutral (3 seconds)
		OBFlapperonCurrent_right = animate_surface(OBFlapperonCurrent_right, -0.65, movement_speed) -- Right wing up
		IB_flapperon_current_right = animate_surface(IB_flapperon_current_right, 0.35, movement_speed) -- Right wing up
		OBFlapperonCurrent_left = animate_surface(OBFlapperonCurrent_left, -0.65, movement_speed) -- Left wing down
		IB_flapperon_current_left = animate_surface(IB_flapperon_current_left, 0.35, movement_speed) -- Left wing down
		L_V_Tail_current = animate_surface(L_V_Tail_current, 0, movement_speed)
		R_V_Tail_current = animate_surface(R_V_Tail_current, 0, movement_speed)

		if flcs_test_timer > 4 then
			flcs_test_step = 6
			flcs_test_timer = 0
		end

	elseif flcs_test_step == 6 then
		local movement_speed = 1.0 -- Slower speed for step 6
		-- Step 6: Return all surfaces to neutral (3 seconds)
		LEF_current = animate_surface(LEF_current, 0, movement_speed)
		OBFlapperonCurrent_right = animate_surface(OBFlapperonCurrent_right, 0, movement_speed)
		IB_flapperon_current_right = animate_surface(IB_flapperon_current_right, 0, movement_speed)
		OBFlapperonCurrent_left = animate_surface(OBFlapperonCurrent_left, 0, movement_speed)
		IB_flapperon_current_left = animate_surface(IB_flapperon_current_left, 0, movement_speed)
		L_V_Tail_current = animate_surface(L_V_Tail_current, 0, movement_speed)
		R_V_Tail_current = animate_surface(R_V_Tail_current, 0, movement_speed)

		if flcs_test_timer > 3 then
			flcs_test_active = false
			print_message_to_user("FLCS test completed")
		end
	end
end


--- Calculates the sign of a number.
--- @param x number: The number to evaluate.
--- @return integer: Returns 1 if x is positive, -1 if x is negative, and 0 if x is zero.
function math.sign(x)
	return x > 0 and 1 or (x < 0 and -1 or 0)
end


--- Calculates the deflection factor based on the provided Mach number.
--- @param mach_number number: The Mach number to evaluate.
--- @return number: The deflection factor for the given Mach number.
function calculate_mach_deflection_factor(mach_number)
	-- Constants for the exponential curve
	local max_deflection = 0.75 -- Maximum deflection at low speeds
	local min_deflection = 0.1 -- Minimum deflection at high speeds
	local decay_rate = 3.0   -- Controls how quickly deflection reduces as Mach increases

	-- Ensure we have a valid Mach number (prevent negative values)
	local mach = math.max(0.01, mach_number)

	-- Calculate deflection factor using exponential decay
	-- Formula: min_deflection + (max_deflection - min_deflection) * e^(-decay_rate * mach)
	local deflection_factor = min_deflection + (max_deflection - min_deflection) * math.exp(-decay_rate * mach)

	-- Ensure the result stays within our defined bounds
	return math.max(min_deflection, math.min(max_deflection, deflection_factor))
end

function update()
	local self_vel_l, self_vel_v, self_vel_h = baseData.getSelfAirspeed()
	local self_ground_speed = math.sqrt(math.pow(self_vel_h, 2) + math.pow(self_vel_l, 2)) * 1.944
	local wow_nose = baseData.getWOW_NoseLandingGear()
	local wow_left_main = baseData.getWOW_LeftMainLandingGear()
	local wow_right_main = baseData.getWOW_RightMainLandingGear()
	local gear_nose_up = baseData.getNoseLandingGearUp()



	if APUBus:get() == 1 then
		get_param_handle("FLCSTestState"):set(flcs_test_active and 1 or 0)
		get_param_handle("GWarning"):set(baseData.getVerticalAcceleration() > 9 and 1 or 0)
		get_param_handle("airbrakeState"):set(air_brake_out and 1 or 0)
		get_param_handle("flapState"):set((OBFlapperonTarget >= 0.3 and IB_flapperon_target >= 0.5) and 1 or 0)



		Sensor_data()

		get_param_handle("Ground_Speed"):set(self_ground_speed)



		-- NWS automatic high rate when nose wheel is airborne
		if wow_nose == 0 then
			-- Nose wheel is off ground - automatically set to HIGH rate
			if nws_rate_state ~= 2 then
				nws_rate_state = 2
				nws_speed_scale = 1.0
				get_param_handle("nwsRateState"):set(nws_rate_state)
				-- Optionally notify user (uncomment if desired)
				-- print_message_to_user("NWS Rate: AUTO HIGH (airborne)")
			end
		end
	end

	if mainBus:get() == 1 then
		-- Auto-retract air brake when either engine is above 50%
		local left_engine_rpm = baseData.getEngineLeftRPM()
		local right_engine_rpm = baseData.getEngineRightRPM()
		local max_rpm = 100   -- Assuming 100% is maximum RPM
		local engine_threshold = 84 -- 84% threshold

		if air_brake_out == true and (left_engine_rpm > engine_threshold or right_engine_rpm > engine_threshold) then
			air_brake_target = 0
			air_brake_out = false
			set_aircraft_draw_argument_value(21, 0)
			print_message_to_user("Airbrake auto-retracted: Engine power above 84%")
		end



		local deflection_factor = calculate_mach_deflection_factor(Mach)

		update_flcs_test(updateTimeStep)



		-- Apply AoA and G limiters to positive (pull) elevator inputs
		local aoa_limiter = calculate_aoa_limiter(AoA)
		local current_g = baseData.getVerticalAcceleration()
		local g_limiter = current_g > 0 and calculate_g_limiter(current_g) or 1.0 -- Only limit positive G

		local limited_elevator = elevator_input
		if elevator_input > 0 then
			-- Apply both limiters, using the most restrictive one
			local combined_limiter = math.min(aoa_limiter, g_limiter)
			limited_elevator = elevator_input * combined_limiter
		end



		if flcs_test_active then
			-- Apply FLCS test values directly
			set_aircraft_draw_argument_value(606, LEF_current)
			set_aircraft_draw_argument_value(953, OBFlapperonCurrent_left)
			set_aircraft_draw_argument_value(951, IB_flapperon_current_left)
			set_aircraft_draw_argument_value(955, L_V_Tail_current)
			set_aircraft_draw_argument_value(954, R_V_Tail_current)
			set_aircraft_draw_argument_value(950, IB_flapperon_current_right)
			set_aircraft_draw_argument_value(952, OBFlapperonCurrent_right)
		else
			-- Normal flight control logic
			local is_on_ground = wow_left_main == 1 and wow_right_main == 1
			local is_airborne = wow_left_main == 0 and wow_right_main == 0 and wow_nose == 0

			if is_on_ground and wow_nose == 1 and self_ground_speed <= 60 then
				-- Full stop on ground
				OBFlapperonTarget = 0
				IB_flapperon_target = 0
				LEF_target = 0
			elseif is_on_ground and (wow_nose == 1 or wow_nose == 0) and self_ground_speed > 60 then
				-- Moving on ground or rotation
				OBFlapperonTarget = .3
				IB_flapperon_target = .5
				LEF_target = .5
			elseif is_airborne and gear_nose_up == 0 then
				if air_brake_out == true then
					-- Airborne with gear down
					if ias < 199 then -- Mach < 0.319
						-- automatically close airbrake if airspeed decays below 195kts
						OBFlapperonTarget = 0.3
						IB_flapperon_target = 0.5
						LEF_target = 0.5
						set_aircraft_draw_argument_value(21, 0)
						air_brake_out = false
						-- print_message_to_user("Airbrake automatically closed: ")
					elseif ias >= 200 then -- Mach >= 0.32
						if AoA < 22 then
							-- Air brake above 200kts
							OBFlapperonTarget = -0.63
							IB_flapperon_target = 0.63
							LEF_target = 0.5
							set_aircraft_draw_argument_value(21, 1)
						else
							-- < 200kts and above 22* AOA
							OBFlapperonTarget = 0.3
							IB_flapperon_target = 0.5
							LEF_target = 0.5
							set_aircraft_draw_argument_value(21, 1)
						end
					end

				elseif air_brake_out == false then
					-- close airbrake and resume gear down flapperon movement
					OBFlapperonTarget = 0.3
					IB_flapperon_target = 0.5
					LEF_target = 0.5
					set_aircraft_draw_argument_value(21, 0)
				end

			elseif is_airborne and gear_nose_up == 1 then
				-- Airborne with gear up
				if ias < 199 and air_brake_out == true then -- Mach < 0.319
					-- automatically close airbrake if airspeed decays below 200kts
					OBFlapperonTarget = math.min(OB_alpha_movement(), 0.2)
					IB_flapperon_target = math.min(IB_alpha_movement(), 0.4)
					LEF_target = alpha_movement()
					set_aircraft_draw_argument_value(21, 0)
					air_brake_out = false
					-- print_message_to_user("Airbrake automatically closed: ")
				elseif air_brake_out == true then
					-- Air brake deployed
					if Mach >= 1 then
						OBFlapperonTarget = -math.min(air_brake_target, 0.35)
						IB_flapperon_target = math.min(air_brake_target, 0.35)
						set_aircraft_draw_argument_value(21, 1)
						-- print_message_to_user("Airbrake Open")
					elseif ias >= 200 then -- Mach >= 0.32
						OBFlapperonTarget = -math.min(air_brake_target, 0.65)
						IB_flapperon_target = math.min(air_brake_target, 0.65)
						set_aircraft_draw_argument_value(21, 1)
						-- print_message_to_user("Airbrake Open")
					end
				else -- air_brake_out == false
					-- Normal flight
					if Mach >= 1 then
						OBFlapperonTarget = 0
						IB_flapperon_target = 0
						LEF_target = 0
						set_aircraft_draw_argument_value(21, 0)
					else
						OBFlapperonTarget = math.min(OB_alpha_movement(), 0.2)
						IB_flapperon_target = math.min(IB_alpha_movement(), 0.4)
						LEF_target = alpha_movement()
						set_aircraft_draw_argument_value(21, 0)
					end
				end
			end

			OBFlapperonCurrent = animate_surface(OBFlapperonCurrent, OBFlapperonTarget, deployment_speed)
			IB_flapperon_current = animate_surface(IB_flapperon_current, IB_flapperon_target, deployment_speed)
			LEF_current = animate_surface(LEF_current, LEF_target, deployment_speed)

			-- Apply V-Tail controls with AoA limiter for positive elevator inputs
			R_V_Tail = limited_elevator * deflection_factor
			L_V_Tail = limited_elevator * deflection_factor
			R_O_Flapperon = aileron_input * deflection_factor
			L_O_Flapperon = -aileron_input * deflection_factor

			set_aircraft_draw_argument_value(954, R_V_Tail)
			set_aircraft_draw_argument_value(955, L_V_Tail)
			set_aircraft_draw_argument_value(953, R_O_Flapperon + OBFlapperonCurrent)
			set_aircraft_draw_argument_value(952, L_O_Flapperon + OBFlapperonCurrent)
			set_aircraft_draw_argument_value(951, R_O_Flapperon + IB_flapperon_current)
			set_aircraft_draw_argument_value(950, L_O_Flapperon + IB_flapperon_current)
			set_aircraft_draw_argument_value(606, LEF_current)
		end



		-- NWS logic with manual rate selection and automatic high rate when airborne					
		local scaled_rudder_input = rudder_input * nws_speed_scale

		-- Use this scaled input for the steering
		dispatch_action(nil, 2003, scaled_rudder_input)
		set_aircraft_draw_argument_value(957, -rudder_input)

		roll:set(aileron_input)
		dispatch_action(nil, 2002, aileron_input)

		-- Apply the AoA-limited elevator input
		pitch:set(limited_elevator)
		dispatch_action(nil, 2001, limited_elevator)

		-- Display AoA status when approaching limits (uncomment for debugging)
		-- if AoA > aoa_warning then
		--     print_message_to_user(string.format("AoA: %.1f, Limiter: %.2f", AoA, aoa_limiter))
		-- end
	end
end

--[[function update()
	get_param_handle("GWarning"):set(baseData.getVerticalAcceleration() > 9 and 1 or 0)
	get_param_handle("airbrakeState"):set(air_brake_out and 1 or 0)
	get_param_handle("flapState"):set((OBFlapperonTarget >= 0.3 and IB_flapperon_target >= 0.5) and 1 or 0)



    Sensor_data()

    local self_vel_l, self_vel_v, self_vel_h = baseData.getSelfAirspeed()
    local self_ground_speed = math.sqrt(math.pow(self_vel_h, 2) + math.pow(self_vel_l, 2)) * 1.944
    local wow_nose = baseData.getWOW_NoseLandingGear()
    local wow_left_main = baseData.getWOW_LeftMainLandingGear()
    local wow_right_main = baseData.getWOW_RightMainLandingGear()
    local gear_nose_up = baseData.getNoseLandingGearUp()

    local deflection_factor = calculate_mach_deflection_factor(Mach)

    get_param_handle("Ground_Speed"):set(self_ground_speed)

    update_flcs_test(updateTimeStep)

 -- Apply AoA and G limiters to positive (pull) elevator inputs
local aoa_limiter = calculate_aoa_limiter(AoA)
local current_g = baseData.getVerticalAcceleration()
local g_limiter = current_g > 0 and calculate_g_limiter(current_g) or 1.0  -- Only limit positive G

local limited_elevator = elevator_input
    if elevator_input > 0 then
    -- Apply both limiters, using the most restrictive one
    local combined_limiter = math.min(aoa_limiter, g_limiter)
    limited_elevator = elevator_input * combined_limiter
    end

    if flcs_test_active then
        -- Apply FLCS test values directly
        set_aircraft_draw_argument_value(606, LEF_current)
        set_aircraft_draw_argument_value(953, OBFlapperonCurrent_left)
        set_aircraft_draw_argument_value(951, IB_flapperon_current_left)
        set_aircraft_draw_argument_value(955, L_V_Tail_current)
        set_aircraft_draw_argument_value(954, R_V_Tail_current)
        set_aircraft_draw_argument_value(950, IB_flapperon_current_right)
        set_aircraft_draw_argument_value(952, OBFlapperonCurrent_right)
    else
        -- Normal flight control logic
        local is_on_ground = wow_left_main == 1 and wow_right_main == 1
        local is_airborne = wow_left_main == 0 and wow_right_main == 0 and wow_nose == 0

        if is_on_ground and wow_nose == 1 and self_ground_speed <= 60 then
            -- Full stop on ground
            OBFlapperonTarget = 0
            IB_flapperon_target = 0
            LEF_target = 0
        elseif is_on_ground and (wow_nose == 1 or wow_nose == 0) and self_ground_speed > 60 then
            -- Moving on ground or rotation
            OBFlapperonTarget = 0.3
            IB_flapperon_target = 0.5
            LEF_target = 0.5
        elseif is_airborne and gear_nose_up == 0 then
            if air_brake_out == true then
                -- Airborne with gear down
                if ias < 199 then --Mach < 0.319
                    -- automatically close airbrake if airspeed decays below 195kts
                    OBFlapperonTarget = 0.3
                    IB_flapperon_target = 0.5
                    LEF_target = 0.5
                    set_aircraft_draw_argument_value(21, 0)
                    air_brake_out = false
                    --print_message_to_user("Airbrake automatically closed: ")
                elseif  ias >= 200 then -- Mach >= 0.32
                    if AoA < 22 then
                        -- Air brake above 200kts
                        OBFlapperonTarget = -0.63
                        IB_flapperon_target = 0.63
                        LEF_target = 0.5
                        set_aircraft_draw_argument_value(21, 1)
                    else
                        -- < 200kts and above 22* AOA
                        OBFlapperonTarget = 0.3
                        IB_flapperon_target = 0.5
                        LEF_target = 0.5
                        set_aircraft_draw_argument_value(21, 1)
                    end
                end

            elseif air_brake_out == false then
                -- close airbrake and resume gear down flapperon movement
                    OBFlapperonTarget = 0.3
                    IB_flapperon_target = 0.5
                    LEF_target = 0.5
                    set_aircraft_draw_argument_value(21, 0)

            end

        elseif is_airborne and gear_nose_up == 1 then
            -- Airborne with gear up
            if ias < 199 and air_brake_out == true then -- Mach < 0.319
                -- automatically close airbrake if airspeed decays below 200kts
                OBFlapperonTarget = math.min(OB_alpha_movement(), 0.2)
                IB_flapperon_target = math.min(IB_alpha_movement(), 0.4)
                LEF_target = alpha_movement()
                set_aircraft_draw_argument_value(21, 0)
                air_brake_out = false
                --print_message_to_user("Airbrake automatically closed: ")
            elseif air_brake_out == true then
                -- Air brake deployed
                if Mach >= 1 then
                    OBFlapperonTarget = -math.min(air_brake_target, 0.35)
                    IB_flapperon_target = math.min(air_brake_target, 0.35)
                    set_aircraft_draw_argument_value(21, 1)
                    --print_message_to_user("Airbrake Open")
                elseif ias >= 200 then -- Mach >= 0.32
                    OBFlapperonTarget = -math.min(air_brake_target, 0.65)
                    IB_flapperon_target = math.min(air_brake_target, 0.65)
                    set_aircraft_draw_argument_value(21, 1)
                    --print_message_to_user("Airbrake Open")
                end
            else -- air_brake_out == false
                -- Normal flight
                if Mach >= 1 then
                    OBFlapperonTarget = 0
                    IB_flapperon_target = 0
                    LEF_target = 0
                    set_aircraft_draw_argument_value(21, 0)
                else
                    OBFlapperonTarget = math.min(OB_alpha_movement(), 0.2)
                    IB_flapperon_target = math.min(IB_alpha_movement(), 0.4)
                    LEF_target = alpha_movement()
                    set_aircraft_draw_argument_value(21, 0)
                end
            end
        end

        OBFlapperonCurrent = animate_surface(OBFlapperonCurrent, OBFlapperonTarget, deployment_speed)
        IB_flapperon_current = animate_surface(IB_flapperon_current, IB_flapperon_target, deployment_speed)
        LEF_current = animate_surface(LEF_current, LEF_target, deployment_speed)

        -- Apply V-Tail controls with AoA limiter for positive elevator inputs
        R_V_Tail = limited_elevator * deflection_factor
        L_V_Tail = limited_elevator * deflection_factor
        R_O_Flapperon = aileron_input * deflection_factor
        L_O_Flapperon = -aileron_input * deflection_factor

        set_aircraft_draw_argument_value(954, R_V_Tail)
        set_aircraft_draw_argument_value(955, L_V_Tail)
        set_aircraft_draw_argument_value(953, R_O_Flapperon + OBFlapperonCurrent)
        set_aircraft_draw_argument_value(952, L_O_Flapperon + OBFlapperonCurrent)
        set_aircraft_draw_argument_value(951, R_O_Flapperon + IB_flapperon_current)
        set_aircraft_draw_argument_value(950, L_O_Flapperon + IB_flapperon_current)
        set_aircraft_draw_argument_value(606, LEF_current)
    end


    -- NWS logic with manual rate selection
    local scaled_rudder_input = rudder_input * nws_speed_scale

    -- Use this scaled input for the steering
    dispatch_action(nil, 2003, scaled_rudder_input)
    set_aircraft_draw_argument_value(957,-rudder_input)

    roll:set(aileron_input)
    dispatch_action(nil, 2002, aileron_input)

    -- Apply the AoA-limited elevator input
    pitch:set(limited_elevator)
    dispatch_action(nil, 2001, limited_elevator)

    -- Display AoA status when approaching limits (uncomment for debugging)
    -- if AoA > aoa_warning then
    --     print_message_to_user(string.format("AoA: %.1f, Limiter: %.2f", AoA, aoa_limiter))
    -- end
end]]