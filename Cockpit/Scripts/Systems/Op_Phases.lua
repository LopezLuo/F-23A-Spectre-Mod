-- The Operational phases:

-- Engine off				STATIONARY                              1
-- Engine start up			PARKED                                  2
-- Speed above 27 kts		TAXI                                    3
-- Speed above 39 kts		TGR			Take Off Ground Roll        4
-- Nose gear lift off		ROT			Rotate                      5
-- Main gear lift off		LO			Lift Off                    6
-- Gear up					CO			Combat                      7
-- Gear down				PAL (*)		Power Approach and Landing  8
-- Main gear touch down		TD (*)		Touch Down                  9
-- Nose gear touch down		LR (*)		Landing Roll                10
-- Speed below 39 kts		TAXI                                    3
-- Speed below 27 kts		PARKED                                  2
-- Engine off				STATIONARY                              1

-- (*) requires Landing Mode enabled

local dev = GetSelf()

dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

local update_time_step = .01
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local current_phase_STATIONARY = get_param_handle("CURRENT_PHASE_STATIONARY")
local current_phase_PARKED = get_param_handle("CURRENT_PHASE_PARKED")
local current_phase_TAXI = get_param_handle("CURRENT_PHASE_TAXI")
local current_phase_TGR = get_param_handle("CURRENT_PHASE_TGR")
local current_phase_ROT = get_param_handle("CURRENT_PHASE_ROT")
local current_phase_LO = get_param_handle("CURRENT_PHASE_LO")
local currentPhaseCO = get_param_handle("currentPhaseCO")
local current_phase_PAL = get_param_handle("CURRENT_PHASE_PAL")
local current_phase_TD = get_param_handle("CURRENT_PHASE_TD")
local current_phase_LR = get_param_handle("CURRENT_PHASE_LR")
local landing_mode = get_param_handle("LANDING_MODE")
local currentPhase = get_param_handle("currentPhase")

current_phase_STATIONARY:set(0.0)
current_phase_PARKED:set(0.0)
current_phase_TAXI:set(0.0)
current_phase_TGR:set(0.0)
current_phase_ROT:set(0.0)
current_phase_LO:set(0.0)
currentPhaseCO:set(0.0)
current_phase_PAL:set(0.0)
current_phase_TD:set(0.0)
landing_mode:set(0.0)

dev:listen_command(10060) -- Listen for Landing mode

function SetCommand(command, value) -- Set Landing mode
	if command == 10060 then
		if get_param_handle("LANDING_MODE"):get() == 0 then
			landing_mode:set(1.0)
			-- 		print_message_to_user("LANDING MODE: ENABLED")
		elseif get_param_handle("LANDING_MODE"):get() == 1 then
			landing_mode:set(0.0)
			-- 		print_message_to_user("LANDING MODE: DISABLED")
		end
	end
end

--- Prints a debug message to the user.
--- @param x any: The message to print.
function debug_print(x)
	debug_status = 0 -- Display Operational Phase: 0 = Disable, 1 = Enable
	if debug_status == 1 then
		print_message_to_user(tostring(x)) -- Print message to user
	else
	end
end

function update()
	-- local mach = sensor_data.getMachNumber()									-- Speed in MACH
	local self_vel_l, self_vel_v, self_vel_h = sensor_data.getSelfAirspeed()          -- Prereq for ground speed in kts
	local self_gs = math.sqrt(math.pow(self_vel_h, 2) + math.pow(self_vel_l, 2)) * 1.944 -- Ground speed in kts
	local rpm = sensor_data.getEngineLeftRPM()                                        -- Engine rpm
	local wow_n = sensor_data.getWOW_NoseLandingGear()                                -- Nose gear weight on wheels
	local wow_l = sensor_data.getWOW_LeftMainLandingGear()                            -- Left main gear weight on wheels
	local wow_r = sensor_data.getWOW_RightMainLandingGear()                           -- Right main gear weight on wheels
	-- local gear_handle_pos = sensor_data.getLandingGearHandlePos()				-- Gear handle position
	local gear_n_up = sensor_data.getNoseLandingGearUp() -- Nose gear up
	-- local gear_n_down = sensor_data.getNoseLandingGearDown()					-- Nose gear down
	-- local gear_l_up = sensor_data.getLeftMainLandingGearUp()					-- Main gear left up
	-- local gear_l_down = sensor_data.getLeftMainLandingGearDown()				-- Main gear left down
	-- local gear_r_up = sensor_data.getRightMainLandingGearUp()					-- Main gear right up
	-- local gear_l_down = sensor_data.getRightMainLandingGearDown()				-- Main gear right down
	-- local vertical_vel = sensor_data.getVerticalVelocity()						-- Vertical velocity in m/s

	-- ======================== Stationary =====================================		
	if (rpm < 60) and (self_gs <= 27) and (wow_n == 1) and (wow_l == 1) and (gear_n_up == 0) and (wow_r == 1) then -- nytt				
		current_phase_STATIONARY:set(1.0)
		debug_print("Current operational phase: STATIONARY")
		get_param_handle("currentPhase"):set(1)
	else
		current_phase_STATIONARY:set(0.0)
	end

	-- ======================== Parked =========================================			
	if (rpm >= 60) and (self_gs <= 27) and (wow_n == 1) and (wow_l == 1) and (gear_n_up == 0) and (wow_r == 1) then -- nytt			
		current_phase_PARKED:set(1.0)
		debug_print("Current operational phase: PARKED")
		get_param_handle("currentPhase"):set(2)
	else
		current_phase_PARKED:set(0.0)
	end

	-- ======================== Taxi ===========================================
	if (self_gs > 27) and (self_gs <= 39) and (wow_n == 1) and (wow_l == 1) and (gear_n_up == 0) and (wow_r == 1) then
		current_phase_TAXI:set(1.0)
		debug_print("Current operational phase: TAXI")
		get_param_handle("currentPhase"):set(3)
	else
		current_phase_TAXI:set(0.0)
	end

	-- ======================== Take off Ground Roll ===========================		
	if (self_gs > 39) and (wow_n == 1) and (wow_l == 1) and (wow_r == 1) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 0) then
		current_phase_TGR:set(1.0)
		debug_print("Current operational phase: TGR")
		get_param_handle("currentPhase"):set(4)
	else
		current_phase_TGR:set(0.0)
	end

	-- ======================== Rotation =======================================	
	if (self_gs > 39) and (wow_n == 0) and (wow_r == 1) and (wow_l == 1) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 0) then
		current_phase_ROT:set(1.0)
		debug_print("Current operational phase: ROT")
		get_param_handle("currentPhase"):set(5)
	else
		current_phase_ROT:set(0.0)
	end

	-- ======================== Lift Off =======================================	
	if (self_gs > 39) and (wow_n == 0) and (wow_l == 0) and (wow_r == 0) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 0) then
		current_phase_LO:set(1.0)
		debug_print("Current operational phase: LO")
		get_param_handle("currentPhase"):set(6)
	else
		current_phase_LO:set(0.0)
	end

	-- ======================== Combat =========================================	
	if (wow_n == 0) and (wow_l == 0) and (wow_r == 0) and (gear_n_up == 1) and (get_param_handle("LANDING_MODE"):get() < 2) then
		currentPhaseCO:set(1.0)
		debug_print("Current operational phase: CO")
		get_param_handle("currentPhase"):set(7)
	else
		currentPhaseCO:set(0.0)
	end

	-- ======================== Powered Approach and Landing ===================	
	if (self_gs > 39) and (wow_n == 0) and (wow_l == 0) and (wow_r == 0) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 1) then
		current_phase_PAL:set(1.0)
		debug_print("Current operational phase: PAL")
		get_param_handle("currentPhase"):set(8)
	else
		current_phase_PAL:set(0.0)
	end

	-- ======================== Touch Down =====================================	
	if (self_gs > 39) and (wow_n == 0) and (wow_l == 1) and (wow_r == 1) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 1) then
		current_phase_TD:set(1.0)
		debug_print("Current operational phase: TD")
		get_param_handle("currentPhase"):set(9)
	else
		current_phase_TD:set(0.0)
	end

	-- ======================== Landing Roll ===================================	
	if (self_gs > 39) and (wow_n == 1) and (wow_l == 1) and (wow_r == 1) and (gear_n_up == 0) and (get_param_handle("LANDING_MODE"):get() == 1) then
		current_phase_LR:set(1.0)
		debug_print("Current operational phase: LR")
		get_param_handle("currentPhase"):set(10)
	else
		current_phase_LR:set(0.0)
	end

end

need_to_be_closed = false