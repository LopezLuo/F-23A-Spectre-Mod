dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")

local pnl = GetSelf()

-- ===== Local variables =====
local update_time_step = .01
make_default_activity(update_time_step)
local sensor_data = get_base_data()

pnl:listen_command(deviceCommands.OBOGS)
pnl:listen_command(deviceCommands.ecs_temp)
pnl:listen_command(deviceCommands.ecs_rate)
pnl:listen_command(deviceCommands.day_night_switch)


function post_initialize()
	birth = LockOn_Options.init_conditions.birth_place
	if birth == "AIR_HOT" then
		pnl:performClickableAction(deviceCommands.OBOGS, 1, true)
		pnl:performClickableAction(deviceCommands.ecs_temp, 0.5, true)
		pnl:performClickableAction(deviceCommands.ecs_rate, 1, true)
		if math.floor(get_absolute_model_time() / 3600) > 19 or math.floor(get_absolute_model_time() / 3600) < 7 then
			pnl:performClickableAction(deviceCommands.day_night_switch, 1, true)
		else
			pnl:performClickableAction(deviceCommands.day_night_switch, 0, true)
		end
	elseif birth == "GROUND_HOT" then
		pnl:performClickableAction(deviceCommands.OBOGS, 1, true)
		pnl:performClickableAction(deviceCommands.ecs_temp, 0.5, true)
		pnl:performClickableAction(deviceCommands.ecs_rate, 1, true)
	elseif birth == "GROUND_COLD" then
		pnl:performClickableAction(deviceCommands.OBOGS, 1, true)
		pnl:performClickableAction(deviceCommands.ecs_temp, 0.5, true)
		pnl:performClickableAction(deviceCommands.ecs_rate, 1, true)
	end
end

function update()

end

function SetCommand(command, value)
	if command == deviceCommands.day_night_switch then
		if value == 1 then
			get_param_handle("screenBrightness"):set(.75)
		elseif value == 0 then
			get_param_handle("screenBrightness"):set(0)
		end
	end
end



need_to_be_closed = false