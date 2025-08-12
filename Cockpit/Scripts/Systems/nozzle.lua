dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

-- local dev = GetSelf()

-- ===== Local variables =====
local update_time_step = .01
make_default_activity(update_time_step)
local sensor_data = get_base_data()

local leftThrottle = 0
local rightThrottle = 0

local left_noz_current = 0  -- left nozzle current position
local right_noz_current = 0 -- right nozzle current position
local left_noz_target = 0   -- left nozzle target
local right_noz_target = 0  -- right nozzle target
local noz_speed = .2       -- actuation speed

local wow_right_main = 0
local rpm_left_eng = 0
local rpm_right_eng = 0



function Sensor_data()
	wow_right_main = sensor_data.getWOW_RightMainLandingGear()  -- Right main gear weight on wheel
	rpm_left_eng = sensor_data.getEngineLeftRPM()               -- Left Engine RPM
	rpm_right_eng = sensor_data.getEngineRightRPM()             -- Right Engine RPM
end


function left_eng_noz()
	if rpm_left_eng >= 45 and wow_right_main == 1 then
		left_noz_target = 0
	elseif rpm_left_eng <= 44 and wow_right_main == 1 then
		left_noz_target = 1
	end
end

function right_eng_noz()
	if rpm_right_eng >= 45 and wow_right_main == 1 then
		right_noz_target = 0
	elseif rpm_right_eng <= 44 and wow_right_main == 1 then
		right_noz_target = 1
	end
end



function animate_nozzle(current_position, target_position, noz_speed)
	local change_per_frame = noz_speed * update_time_step

	local delta = target_position - current_position

	if math.abs(delta) <= change_per_frame then
		return target_position
	else
		return current_position + (delta > 0 and change_per_frame or -change_per_frame)
	end

end

function update()
	Sensor_data()
	left_eng_noz()
	right_eng_noz()

	-- Animate nozzles using the single function
	left_noz_current = animate_nozzle(left_noz_current, left_noz_target, noz_speed)
	right_noz_current = animate_nozzle(right_noz_current, right_noz_target, noz_speed)

	set_aircraft_draw_argument_value(610, right_noz_current) -- Nozzle draw call
	set_aircraft_draw_argument_value(611, left_noz_current)

	-- Convert baseData to sensor_data for consistency
	leftThrottle = sensor_data.getThrottleLeftPosition()
	rightThrottle = sensor_data.getThrottleRightPosition()
	get_param_handle("rightNozPos"):set(get_aircraft_draw_argument_value(89) * 360) -- Right now just the throttle.
	get_param_handle("leftNozPos"):set(get_aircraft_draw_argument_value(90) * 360)
	-- get_param_handle("leftNozPos"):set(180)
end



need_to_be_closed = false