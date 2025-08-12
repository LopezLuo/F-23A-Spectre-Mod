dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 1 / 30
make_default_activity(updateTimeStep)


local UFCD = GetSelf()


local birth = LockOn_Options.init_conditions.birth_place


local UFCDPower          = get_param_handle("UFCDPower")
local UFCDLeftPage       = get_param_handle("UFCDLeftPage")
local UFCDRightPage      = get_param_handle("UFCDRightPage")
local UFCDLoadingPercent = get_param_handle("UFCDLoadingPercent")


local prevUFCDState = 0
local loadingScreen = false
local duration = 0
local loadingTime = 0
local tmpLoadingPercent = 0



function post_initialize()
	-- show_param_handles_list(true) -- For debugging.



	if birth == "AIR_HOT" or birth == "GROUND_HOT" then
		prevUFCDState = 1
		UFCDLeftPage:set(1) -- Set to FAST page by default (0 = MENU, 1 = FAST).
		UFCDRightPage:set(1) -- Set to ADI page by default (0 = MENU, 1 = ADI, 2 = TACT, 2.1 = TACT:SMS).
	else
		UFCDLeftPage:set(-1) -- Set to loading screen by default.
		UFCDRightPage:set(-1) -- Set to loading screen by default.
	end
end

function update()
	math.randomseed(os.clock()^10)


	if (prevUFCDState == 0 and UFCDPower:get() == 1) or loadingScreen == true then
		loadingScreen = true
		duration = duration == 0 and math.random(7, 12) or duration
		loadingTime = loadingTime + updateTimeStep
		tmpLoadingPercent = (loadingTime / (duration - .75)) * 100
		UFCDLoadingPercent:set(tmpLoadingPercent < 100 and tmpLoadingPercent or 100)
		UFCDLeftPage:set(-1)
		UFCDRightPage:set(-1)

		if loadingTime >= duration then
			loadingScreen = false
			loadingTime = 0
			duration = 0
			UFCDLoadingPercent:set(100)
			UFCDLeftPage:set(1)
			UFCDRightPage:set(1)
		end
	end

	prevUFCDState = UFCDPower:get()
end

function SetCommand()

end



need_to_be_closed = false
