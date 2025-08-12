dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")



local updateTimeStep = 1 / 60
make_default_activity(updateTimeStep)


local engines = GetSelf()


local baseData = get_base_data()


local leftEngineRPM   = 0
local rightEngineRPM  = 0
local leftDisplayRPM  = 0
local rightDisplayRPM = 0

local normalRPMMax    = 0
local actualABMax     = 0
local displayABMax    = 0



function post_initialize()
	normalRPMMax = 99 -- Where normal operation ends.
	actualABMax = 110 -- Maximum actual afterburner value.
	displayABMax = 150 -- Maximum displayed afterburner value.
end

function update()
	leftEngineRPM = baseData.getEngineLeftRPM()
	rightEngineRPM = baseData.getEngineRightRPM()

	leftDisplayRPM = convertAfterburnerRPM(leftEngineRPM)
	rightDisplayRPM = convertAfterburnerRPM(rightEngineRPM)


	get_param_handle("L_rpm"):set(math.floor(leftDisplayRPM) .. "%")
	get_param_handle("R_rpm"):set(math.floor(rightDisplayRPM) .. "%")
	get_param_handle("L_egt"):set(math.floor(baseData.getEngineLeftTemperatureBeforeTurbine() * 1.32))
	get_param_handle("R_egt"):set(math.floor(baseData.getEngineRightTemperatureBeforeTurbine() * 1.32))
	get_param_handle("L_AB"):set(leftEngineRPM > 101.9 and 1 or 0)
	get_param_handle("R_AB"):set(rightEngineRPM > 101.9 and 1 or 0)
end


--- Converts the actual RPM value to a display value, adjusting for afterburner ranges.
--- @param actualRPM number: The actual RPM value to convert.
--- @return number: The converted display RPM value.
function convertAfterburnerRPM(actualRPM)
	-- If we're in normal operating range (below 99%), return the value unchanged.
	if actualRPM <= normalRPMMax then
		return actualRPM
	end

	-- Cap the input to the maximum value to prevent exceeding display range.
	local capped_rpm = math.min(actualRPM, actualABMax)

	-- We're in afterburner range, remap from [99-110] to [99-150].
	local ab_percent = (capped_rpm - normalRPMMax) / (actualABMax - normalRPMMax)
	local display_rpm = normalRPMMax + ab_percent * (displayABMax - normalRPMMax)

	return display_rpm
end



need_to_be_closed = false