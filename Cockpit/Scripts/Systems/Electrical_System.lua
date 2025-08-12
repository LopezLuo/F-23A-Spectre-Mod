dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "utils.lua")



local updateTimeStep = 1 / 24
make_default_activity(updateTimeStep)

local ES = GetSelf()

ES:listen_command(keys.batToggle)

ES:listen_command(deviceCommands.batSwitch)
ES:listen_command(deviceCommands.LGenSwitch)
ES:listen_command(deviceCommands.RGenSwitch)


local baseData = get_base_data()

local birth = ""


local batteryPower = get_param_handle("batteryPower")
local batteryBus = get_param_handle("batteryBus")

local APUGen = get_param_handle("APUGen")
local APUBus = get_param_handle("APUBus")

local Eng1Gen = get_param_handle("Eng1Gen")
local Eng2Gen = get_param_handle("Eng2Gen")
local mainBus = get_param_handle("mainBus")

local currentPhase = get_param_handle("currentPhase")


local APUBusState = 0
local prevAPUBusState = 0

local LGenSwitchState = 0
local RGenSwitchState = 0



function post_initialize()
	birth = LockOn_Options.init_conditions.birth_place

	if birth == "AIR_HOT" or birth == "GROUND_HOT" then
		ES:performClickableAction(deviceCommands.batSwitch, 1, true)
		dispatch_action(nil, 315, 1)
		ES:performClickableAction(deviceCommands.LGenSwitch, 1, true)
		ES:performClickableAction(deviceCommands.RGenSwitch, 1, true)
	end
end

function update()
	if batteryPower:get() == 1 or APUBus:get() == 1 or mainBus:get() == 1 then
		batteryBus:set(1)
	else
		batteryBus:set(0)
	end


	if LGenSwitchState == 1 then
		if baseData.getEngineLeftRPM() >= 60 then
			Eng1Gen:set(1)
		else
			Eng1Gen:set(0)
		end
	elseif LGenSwitchState == 0 or baseData.getEngineLeftRPM() <= 59.9 then
		Eng1Gen:set(0)
	end

	if RGenSwitchState == 1 then
		if baseData.getEngineRightRPM() >= 60 then
			Eng2Gen:set(1)
		else
			Eng2Gen:set(0)
		end
	elseif RGenSwitchState == 0 or baseData.getEngineLeftRPM() <= 59.9 then
		Eng2Gen:set(0)
	end

	-- Main bus logic: powered by engine generators, or by APU if APU is running and in flight (phases 6-8)
	if Eng1Gen:get() == 1 or Eng2Gen:get() == 1 then
		mainBus:set(1)
	elseif currentPhase:get() >= 6 and currentPhase:get() <= 8 and APUGen:get() == 1 then
		mainBus:set(1)
	else
		mainBus:set(0)
	end

	-- APUBus logic: only powered by APU generator
	if APUGen:get() == 1 then
		APUBus:set(1)
	else
		APUBus:set(0)
	end


	APUBusState = (APUGen:get() == 1 or mainBus:get() == 1) and 1 or 0
	APUBus:set(APUBusState)

	if APUBusState ~= prevAPUBusState then
		if APUBusState == 1 then
			dispatch_action(nil, 315)
		else
			dispatch_action(nil, 315, 0)
		end
		prevAPUBusState = APUBusState
	end



	if currentPhase:get() >= 6 and currentPhase:get() <= 8 and (math.floor(baseData.getEngineLeftRPM()) < 67 or math.floor(baseData.getEngineRightRPM()) < 67) and get_param_handle("APUSwitch"):get() == 0 and batteryPower:get() == 1 then
		GetDevice(devices["vms"]):performClickableAction(deviceCommands.APU_switch, 1, true)
	end



	-- avSimpleElectricSystem fields
	ES:DC_Battery_on(batteryBus:get() == 1)
	ES:AC_Generator_1_on(Eng1Gen:get() == 1)
	ES:AC_Generator_2_on(Eng2Gen:get() == 1)
end

function release()

end


function SetCommand(command, value)
	if command == keys.batToggle then
		if batteryPower:get() == 0 then
			ES:performClickableAction(deviceCommands.batSwitch, 1, true)
			batteryPower:set(1)
		else
			ES:performClickableAction(deviceCommands.batSwitch, 0, true)
			batteryPower:set(0)
		end
	end

	if command == deviceCommands.batSwitch then
		if value == 1 then
			batteryPower:set(1)
		elseif value == 0 then
			batteryPower:set(0)
		end
	end


	if command == deviceCommands.LGenSwitch then
		LGenSwitchState = value
	end

	if command == deviceCommands.RGenSwitch then
		RGenSwitchState = value
	end
end

function CockpitEvent(event, val)

end



need_to_be_closed = false