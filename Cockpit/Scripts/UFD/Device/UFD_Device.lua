dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 1 / 30
make_default_activity(updateTimeStep)


local UFD = GetSelf()


local birth = LockOn_Options.init_conditions.birth_place


local UFDPower          = get_param_handle("UFDPower")
local leftUFDPage       = get_param_handle("leftUFDPage")
local rightUFDPage      = get_param_handle("rightUFDPage")
local UFDLoadingPercent = get_param_handle("UFDLoadingPercent")


local prevUFDState = 0
local loadingScreen = false
local duration = 0
local loadingTime = 0
local tmpLoadingPercent = 0



function post_initialize()
	if birth == "AIR_HOT" or birth == "GROUND_HOT" then
		prevUFDState = 1
		leftUFDPage:set(1) -- Set to WARN page by default (-1 = loading, 0 = MENU, 1 = WARN).
		rightUFDPage:set(1) -- Set to WARN page by default (-1 = loading, 0 = MENU, 1 = WARN).
	else
		leftUFDPage:set(-1) -- Set to loading screen by default.
		rightUFDPage:set(-1) -- Set to loading screen by default.
	end
end

function update()
	math.randomseed(os.clock()^10)


	if (prevUFDState == 0 and UFDPower:get() == 1) or loadingScreen == true then
		loadingScreen = true
		duration = duration == 0 and math.random(5, 10) or duration
		loadingTime = loadingTime + updateTimeStep
		tmpLoadingPercent = (loadingTime / (duration - .75)) * 100
		UFDLoadingPercent:set(tmpLoadingPercent < 100 and tmpLoadingPercent or 100)
		leftUFDPage:set(-1)
		rightUFDPage:set(-1)

		if loadingTime >= duration then
			loadingScreen = false
			loadingTime = 0
			duration = 0
			UFDLoadingPercent:set(100)
			leftUFDPage:set(1)
			rightUFDPage:set(1)
		end
	end

	prevUFDState = UFDPower:get()
end

function SetCommand()

end



need_to_be_closed = false