dofile(LockOn_Options.script_path .. "command_defs.lua")

local dev = GetSelf()


local mainBus = get_param_handle("mainBus") -- Main bus power


local update_time_step = 0.01
local sensor_data      = get_base_data()
local gun_door_current = .0                -- Current gun_door  position
local gun_door_target  = 0                 -- gun_door desired position
local RAD_TO_DEGREE    = 57.29577951308233 -- Radians to Degrees
local deployment_speed = 10.0              -- Degrees per second

make_default_activity(update_time_step)


dev:listen_command(keys.TriggerFirstStage)
dev:listen_command(keys.TriggerFirstStageOff)

function SetCommand(command, value)
	local wow_right_main = sensor_data.getWOW_RightMainLandingGear() -- Right main gear weight on wheel

	if mainBus:get() == 1 then
		if command == keys.TriggerFirstStage then -- Open door
			if wow_right_main == 0 then
				dev:performClickableAction(keys.TriggerFirstStage, 1, true)
				gun_door_target = 1
			end
		end
		if command == keys.TriggerFirstStageOff then -- Close door
			dev:performClickableAction(keys.TriggerFirstStageOff, 1, true)
			gun_door_target = 0

		end
	end

	return gun_door_target -- ???
end

--- Animates the gun door from its current position to the target position.
--- @param gun_door_target number: The target position of the gun door.
--- @return number: The new position of the gun door.
function animate_gun_door(gun_door_target)

	local change_per_frame = deployment_speed *
		update_time_step -- Calculate the change in MWB per frame to achieve the desired speed

	local delta = gun_door_target -
		gun_door_current -- Calculate the difference between current and target MWB

	if math.abs(delta) <= change_per_frame then -- Check if we've reached the target or if delta is very small (consider it reached)
		gun_door_current = gun_door_target
	else
		gun_door_current = gun_door_current +
			(delta > 0 and change_per_frame or -change_per_frame) -- Increment or decrement MWB_current based on the sign of delta
	end

	return gun_door_current
end


function update()
	if mainBus:get() == 1 then
		animate_gun_door(gun_door_target)
		set_aircraft_draw_argument_value(614, gun_door_current) -- MWB draw call
	end
end


need_to_be_closed = false