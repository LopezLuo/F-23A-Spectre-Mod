dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

local dev = GetSelf()

-- ===== Local variables =====
local update_time_step = .01
make_default_activity(update_time_step)
local sensor_data = get_base_data()

local form_lights_on_off      = 0
local beacon_target           = 0
local beacon_deployment_speed = 2
local beacon_current          = .0
local beacon_illuminate       = 0
local receptacle_illuminate   = 0
local bck_lts_on_off          = 0
local fld_on_off              = 0
local landing_lights_state    = 0
local taxi_lights_state       = 0
local beacon_state            = 0
local temp_flood              = 0
local temp_back               = 0
local temp_form               = 0
local position_on_off         = 0
local position_state          = 0
local temp_land               = 0
local temp_taxi               = 0

local flash_timer = .0
local flash_rate  = .7 -- Flash timing. Lower number is faster rate
local flash_state = 0

local form_on_off      = get_param_handle("FORM_LIGHTS")
local beacon_on_off    = get_param_handle("beaconLights")
local back_on_off      = get_param_handle("BACK_LIGHTING")
local flood_on_off     = get_param_handle("FLOOD_LIGHTING")
local left_gear_light  = get_param_handle("LEFT_GEAR_LIGHT")
local right_gear_light = get_param_handle("RIGHT_GEAR_LIGHT")
local nose_gear_light  = get_param_handle("NOSE_GEAR_LIGHT")


form_on_off:set(0.0)
beacon_on_off:set(0.0)
back_on_off:set(0.0)
flood_on_off:set(0.0)
left_gear_light:set(0.0)
right_gear_light:set(0.0)
nose_gear_light:set(0.0)

dev:listen_command(deviceCommands.Console_Brightness)
dev:listen_command(deviceCommands.batSwitch)
dev:listen_command(deviceCommands.BEACON_Selector)
dev:listen_command(deviceCommands.LDG_LIGHT_Selector)
dev:listen_command(deviceCommands.FLOOD_Brightness)
dev:listen_command(deviceCommands.FORM_Brightness)
dev:listen_command(deviceCommands.POSTITION_Selector)

dev:listen_command(keys.formation_lights)
dev:listen_command(keys.beacon_lights)
dev:listen_command(keys.back_lights)
dev:listen_command(keys.cockpit_lights)
dev:listen_command(keys.landing_on)
dev:listen_command(keys.taxi_on)
dev:listen_command(keys.land_taxi_off)
dev:listen_command(keys.position_on)
dev:listen_command(keys.position_off)
dev:listen_command(keys.form_on)
dev:listen_command(keys.form_off)
dev:listen_command(keys.con_bright_off)
dev:listen_command(keys.con_bright_on)



function SetCommand(command, value)
	if command == keys.landing_on then
		dev:performClickableAction(deviceCommands.LDG_LIGHT_Selector, 1, true)
		temp_land = 1
		temp_taxi = 0
	end

	if command == keys.land_taxi_off then
		dev:performClickableAction(deviceCommands.LDG_LIGHT_Selector, 0, true)
		temp_land = 0
		temp_taxi = 0
	end

	if command == keys.taxi_on then
		dev:performClickableAction(deviceCommands.LDG_LIGHT_Selector, -1, true)
		temp_land = 0
		temp_taxi = 1
	end

	if command == deviceCommands.LDG_LIGHT_Selector then
		if value == -1 then
			temp_land = 0
			temp_taxi = 1
		elseif value == 0 then
			temp_land = 0
			temp_taxi = 0
		elseif value == 1 then
			temp_land = 1
			temp_taxi = 0
		end
	end


	if command == deviceCommands.POSTITION_Selector then
		if value == 1 then
			-- print_message_to_user("Navigation Lights On")
			position_on_off = 1
			position_state = 1 -- TODO: create keyboard bind for position light.
			get_param_handle("positionLights"):set(1)
		elseif value == 0 then
			-- print_message_to_user("Navigation Lights Off")
			position_on_off = 0
			position_state = 0
			get_param_handle("positionLights"):set(0)
		end
	end

	if command == keys.position_on then
		if position_state == 0 then
			dev:performClickableAction(deviceCommands.POSTITION_Selector, 1, true)
			position_on_off = 1
			position_state = 1
			get_param_handle("positionLights"):set(1)
		end
	end

	if command == keys.position_off then
		if position_state == 1 then
			dev:performClickableAction(deviceCommands.POSTITION_Selector, 0, true)
			position_on_off = 0
			position_state = 0
			get_param_handle("positionLights"):set(0)
		end
	end

	if command == deviceCommands.BEACON_Selector then
		if value == 1 then
			-- print_message_to_user("Anti-Collision Lights On")
			beacon_target = 1
			beacon_on_off:set(1.0)
			beacon_state = 1
		elseif value == 0 then
			-- print_message_to_user("Anti-Collision Lights Off")
			beacon_target = 0
			beacon_on_off:set(0.0)
			beacon_state = 0
		end

		return beacon_state -- ???
	end

	if command == keys.beacon_lights then
		if beacon_state == 0 then
			dev:performClickableAction(deviceCommands.BEACON_Selector, 1, true)
			beacon_on_off:set(1.0)
			beacon_target = 1
			beacon_state = 1
		elseif beacon_state == 1 then
			dev:performClickableAction(deviceCommands.BEACON_Selector, 0, true)
			beacon_on_off:set(0)
			beacon_target = 0
			beacon_state = 0
		end
	end

	if command == keys.form_on then
		dev:performClickableAction(deviceCommands.FORM_Brightness, 0.1, true) -- Set brightness to full
		temp_form = 1
	end

	if command == keys.form_off then
		dev:performClickableAction(deviceCommands.FORM_Brightness, 0.0, true) -- Set brightness to zero
		temp_form = 0
	end

	if command == keys.con_bright_on then
		dev:performClickableAction(deviceCommands.Console_Brightness, 0.1, true) -- Set brightness to full
		temp_back = 1
	end

	if command == keys.con_bright_off then
		dev:performClickableAction(deviceCommands.Console_Brightness, 0.0, true) -- Set brightness to zero
		temp_back = 0
	end


	if command == deviceCommands.FLOOD_Brightness then
		temp_flood = value
	end

	if command == deviceCommands.Console_Brightness then
		temp_back = value
	end

	if command == deviceCommands.FORM_Brightness then
		temp_form = value
	end

end

--- Updates the cockpit lights based on the current battery state.
function cockpit_lights() -- TODO: the exterior lights need to be connected to APU + Gen 1 or 2
	if get_param_handle("batteryBus"):get() == 1 then
		flood_on_off:set(temp_flood)
		back_on_off:set(temp_back)
		form_on_off:set(temp_form)
	elseif get_param_handle("batteryBus"):get() == 0 then
		flood_on_off:set(0)
		back_on_off:set(0)
		form_on_off:set(0)
	end
end

--- Sets the gear indication lights based on the current gear states.
function set_gear_indication()
	local left_gear_up    = sensor_data.getLeftMainLandingGearUp()
	local left_gear_down  = sensor_data.getLeftMainLandingGearDown()
	local right_gear_up   = sensor_data.getRightMainLandingGearUp()
	local right_gear_down = sensor_data.getRightMainLandingGearDown()
	local nose_gear_up    = sensor_data.getNoseLandingGearUp()
	local nose_gear_down  = sensor_data.getNoseLandingGearDown()

	if get_param_handle("APUBus"):get() == 1 then
		if left_gear_up == 1 then
			left_gear_light:set(0.0)
		elseif left_gear_down == 1 then
			left_gear_light:set(1.0)
		else
			left_gear_light:set(0.5)
		end
	else
		left_gear_light:set(0.0)
	end

	if get_param_handle("APUBus"):get() == 1 then
		if right_gear_up == 1 then
			right_gear_light:set(0.0)
		elseif right_gear_down == 1 then
			right_gear_light:set(1.0)
		else
			right_gear_light:set(0.5)
		end
	else
		right_gear_light:set(0.0)
	end

	if get_param_handle("APUBus"):get() == 1 then
		if nose_gear_up == 1 then
			nose_gear_light:set(0.0)
		elseif nose_gear_down == 1 then
			nose_gear_light:set(1.0)
		else
			nose_gear_light:set(0.5)
		end
	else
		nose_gear_light:set(0.0)
	end
end


--- Animates the beacon light from its current position to the target position.
--- @param beacon_target number: The target position of the beacon light.
--- @param beacon_deployment_speed number: The speed of the beacon light animation.
function animate_beacon(beacon_target, beacon_deployment_speed)
	if get_param_handle("APUBus"):get() == 0 then
		beacon_current = 0
		return
	end
	local change_per_frame = beacon_deployment_speed *
		update_time_step -- Calculate the change in beacon position per frame to achieve the desired speed

	local delta = beacon_target - beacon_current -- Calculate the difference between current and target beacon position

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		beacon_current = beacon_target
	else
		beacon_current = beacon_current + (delta > 0 and change_per_frame or -change_per_frame) -- Increment or decrement beacon_current based on the sign of delta
	end
end


--- Illuminates the boom area light. (???)
function illuminate_boom()
	if get_param_handle("APUBus"):get() == 1 then
		if get_aircraft_draw_argument_value(22) == 1 then
			receptacle_illuminate = 1
		else
			receptacle_illuminate = 0
		end
	else
		receptacle_illuminate = 0
	end
end

--- Controls the external light power state.
function light_power()
	if get_param_handle("APUBus"):get() == 0 then
		form_lights_on_off = 0
		bck_lts_on_off = 0
		beacon_target = 0
		position_state = 0
	end
end

--- Updates the landing and taxi light states based on the current gear states.
function land_taxi_state()
	local nose_gear_down = sensor_data.getNoseLandingGearDown()
	if get_param_handle("APUBus"):get() == 1 then
		if nose_gear_down == 1 then -- and get_param_handle("batteryPower"):get() == 0 then
			landing_lights_state = temp_land
			taxi_lights_state = temp_taxi
		elseif nose_gear_down == 0 then
			landing_lights_state = 0
			taxi_lights_state = 0
		end
	elseif get_param_handle("APUBus"):get() == 0 then
		landing_lights_state = 0
		taxi_lights_state = 0
	end
end

function update()
	get_param_handle("taxiLandingLights"):set(get_aircraft_draw_argument_value(208) == 1 and 1 or get_aircraft_draw_argument_value(209) == 1 and 2 or 0)

	animate_beacon(beacon_target, beacon_deployment_speed)
	set_gear_indication()



	if beacon_current == 1 then
		flash_timer = flash_timer + update_time_step
		if flash_timer >= flash_rate then
			flash_timer = 0      -- Reset timer
			flash_state = 1 - flash_state -- Toggle the flash state between 0 and 1
		end

		set_aircraft_draw_argument_value(603, flash_state)
	else

		set_aircraft_draw_argument_value(603, 0) -- Turn off the flashing light if beacon_current is not 1
		flash_timer = 0                    -- Reset timer to ensure proper timing when turned back on
	end

	cockpit_lights()
	illuminate_boom()
	light_power()
	land_taxi_state()
	set_aircraft_draw_argument_value(604, beacon_current)
	set_aircraft_draw_argument_value(200, form_on_off:get())
	set_aircraft_draw_argument_value(210, receptacle_illuminate)
	set_aircraft_draw_argument_value(208, taxi_lights_state) -- Landing lights
	set_aircraft_draw_argument_value(209, landing_lights_state) -- Taxi lights
	set_aircraft_draw_argument_value(612, position_state)    -- Position lights
end



need_to_be_closed = false