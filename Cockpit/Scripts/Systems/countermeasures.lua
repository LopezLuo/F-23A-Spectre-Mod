dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 1 / 30
make_default_activity(updateTimeStep)


local CM = GetSelf()

CM:listen_command(keys.PlaneDropFlareOnce)
CM:listen_command(keys.PlaneDropChaffOnce)
CM:listen_command(keys.countermeasuresDispense)
CM:listen_command(keys.countermeasuresDispenseOff)

CM:listen_event("WeaponRearmComplete")


local baseData = get_base_data()


local flareWarning = get_param_handle("flareWarning")
local chaffWarning = get_param_handle("chaffWarning")

local flareCount = get_param_handle("flareCount")
local chaffCount = get_param_handle("chaffCount")

local flareDispense = get_param_handle("flareDispense")
local chaffDispense = get_param_handle("chaffDispense")

local mainBus = get_param_handle("mainBus")


local STDFlareCount = 120 -- Default value is 120.
local STDChaffCount = 120 -- Default value is 120.

local greenFlare = nil
local redFlare = nil
local coloredFlareTime = .0
local coloredDuration = .15

local greenChaff = nil
local redChaff = nil
local coloredChaffTime = .0



function post_initialize()
	flareCount:set(STDFlareCount)
	chaffCount:set(STDChaffCount)
end

function update()
	if flareCount:get() <= 30 then
		flareWarning:set(1)
	else
		flareWarning:set(0)
	end

	if chaffCount:get() <= 15 then
		chaffWarning:set(1)
	else
		chaffWarning:set(0)
	end


	if greenFlare or redFlare then
		if coloredFlareTime >= coloredDuration then
			greenFlare = false
			redFlare = false
			coloredFlareTime = .0
			flareDispense:set(0)
		else
			coloredFlareTime = coloredFlareTime + updateTimeStep
			flareDispense:set(greenFlare and 1 or -1)
		end
	end

	if greenChaff or redChaff then
		if coloredChaffTime >= coloredDuration then
			greenChaff = false
			redChaff = false
			coloredChaffTime = 0
			chaffDispense:set(0)
		else
			coloredChaffTime = coloredChaffTime + updateTimeStep
			chaffDispense:set(greenChaff and 1 or -1)
		end
	end
end

function CockpitEvent(event, val)
	if event == "WeaponRearmComplete" then
		flareCount:set(STDFlareCount)
		chaffCount:set(STDChaffCount)
	end
end

function SetCommand(command, value)
	if command == keys.countermeasuresDispense and baseData.getWOW_NoseLandingGear() == 0 then
		dispatch_action(nil, keys.PlaneDropFlareOnce)
		dispatch_action(nil, keys.PlaneDropChaffOnce)
	end

	if command == keys.PlaneDropFlareOnce and mainBus:get() == 1 then
		if flareCount:get() <= 0 then
			redFlare = true
		else
			flareCount:set(flareCount:get() - 2)
			greenFlare = true
		end
	end

	if command == keys.PlaneDropChaffOnce and mainBus:get() == 1 then
		if chaffCount:get() <= 0 then
			redChaff = true
		else
			chaffCount:set(chaffCount:get() - 1)
			greenChaff = true
		end
	end
end



need_to_be_closed = false