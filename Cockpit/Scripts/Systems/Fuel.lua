dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local fuel = GetSelf()


local updateTimeStep = .2
make_default_activity(updateTimeStep)


local baseData = get_base_data()


local fuelPCT = get_param_handle("fuelPCT")
local fuelIndWarning = get_param_handle("fuelIndWarning")


local totalFuelWeight = .0
local previousTotalFuelWeight = 0



function post_initialize()
	get_param_handle("jokerFuel"):set(10)
	get_param_handle("bingoFuel"):set(2.8)
end

function update()
	totalFuelWeight = baseData.getTotalFuelWeight()

	get_param_handle("fuelInd"):set((totalFuelWeight * 2.205) / 1000)
	fuelPCT:set(totalFuelWeight / 8870)

	fuelIndWarning:set((fuelPCT:get() <= 0.14 and 2) or (fuelPCT:get() <= 0.24 and 1) or 0)


	get_param_handle("totalFuelFlow"):set((baseData.getEngineLeftFuelConsumption() * 2.205 + baseData.getEngineRightFuelConsumption() * 2.205) * 60)



	get_param_handle("fuelFlow"):set((totalFuelWeight > previousTotalFuelWeight and get_param_handle("AARReady"):get() == 1) and 1 or 0)
	previousTotalFuelWeight = totalFuelWeight
end

function SetCommand(command, value)

end



need_to_be_closed = false