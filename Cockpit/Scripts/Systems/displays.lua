dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "command_defs.lua")
dofile(LockOn_Options.script_path .. "devices.lua")
dofile(LockOn_Options.script_path .. "utils.lua")



local updateTimeStep = 1 / 60 -- Hz of the update() function.
make_default_activity(updateTimeStep)


local displays = GetSelf()

displays:listen_command(deviceCommands.U_osb_1)
displays:listen_command(deviceCommands.U_osb_2)
displays:listen_command(deviceCommands.U_osb_3)
displays:listen_command(deviceCommands.U_osb_4)
displays:listen_command(deviceCommands.U_osb_5)
displays:listen_command(deviceCommands.U_osb_6)
displays:listen_command(deviceCommands.U_osb_7)
displays:listen_command(deviceCommands.U_osb_8)
displays:listen_command(deviceCommands.U_osb_9)
displays:listen_command(deviceCommands.U_osb_10)
displays:listen_command(deviceCommands.L_ufd_1)
displays:listen_command(deviceCommands.L_ufd_2)
displays:listen_command(deviceCommands.L_ufd_3)
displays:listen_command(deviceCommands.R_ufd_1)
displays:listen_command(deviceCommands.R_ufd_2)
displays:listen_command(deviceCommands.R_ufd_3)
displays:listen_command(keys.PlaneModeNAV)
displays:listen_command(keys.PlaneModeBVR)
displays:listen_command(keys.PlaneModeVS)
displays:listen_command(keys.PlaneModeBore)
displays:listen_command(110) -- Longitudinal/FLOOD
displays:listen_command(keys.PlaneModeGround)


local baseData = get_base_data()


local leftUFDPage   = get_param_handle("leftUFDPage")
local rightUFDPage  = get_param_handle("rightUFDPage")
local UFDPower      = get_param_handle("UFDPower")
local UFCDLeftPage  = get_param_handle("UFCDLeftPage")
local UFCDRightPage = get_param_handle("UFCDRightPage")
local UFCDPower     = get_param_handle("UFCDPower")

local altMode     = get_param_handle("altMode")
local headingMode = get_param_handle("headingMode")

local IAS              = get_param_handle("IAS")
local altText          = get_param_handle("altText")
local altTextThousands = get_param_handle("altTextThousands")

local generalWARN      = get_param_handle("generalWARN")
local generalCaution   = get_param_handle("generalCaution")
local leftENGFireWARN  = get_param_handle("leftENGFireWARN")
local rightENGFireWARN = get_param_handle("rightENGFireWARN")
local leftOilPRESWARN  = get_param_handle("leftOilPRESWARN")
local rightOilPRESWARN = get_param_handle("rightOilPRESWARN")
local GEN1Caution      = get_param_handle("GEN1Caution")
local GEN2Caution      = get_param_handle("GEN2Caution")
local HYD1Caution      = get_param_handle("HYD1Caution")
local HYD2Caution      = get_param_handle("HYD2Caution")
local signatureCaution = get_param_handle("signatureCaution")
local weaponBaysState  = get_param_handle("weaponBaysState")

local SRBMoving = get_param_handle("SRBMoving")
local MWBMoving = get_param_handle("MWBMoving")
local MWBSelect = get_param_handle("MWBSelect")
local SRBSelect = get_param_handle("SRBSelect")

local masterArm = get_param_handle("masterArm")

local editChoice = get_param_handle("editChoice")

local AMRAAMColor     = get_param_handle("AMRAAMColor")
local sidewinderColor = get_param_handle("sidewinderColor")
local flareColor      = get_param_handle("flareColor")
local chaffColor      = get_param_handle("chaffColor")

local AMRAAMCount     = get_param_handle("AMRAAMCount")
local sidewinderCount = get_param_handle("sidewinderCount")
local flareCount      = get_param_handle("flareCount")
local chaffCount      = get_param_handle("chaffCount")

local WPNStatusMSG = get_param_handle("WPNStatusMSG")

local hourTime   = get_param_handle("hourTime")
local minuteTime = get_param_handle("minuteTime")
local secondTime = get_param_handle("secondTime")


local WARNs = {.0, .0, .0, .0}
local prevWARNs = {0, 0, 0, 0}
local warnActive = nil
local newWarningAppeared = nil
local warnAcknowledged = nil

local cautions = {.0, .0, .0, .0}
local prevCautions = {0, 0, 0, 0}
local cautionActive = nil
local newCautionAppeared = nil
local cautionAcknowledged = nil

local WPNStatus = ""


local MS2KTS = 1.94384449
local M2FT = 3.280839895
local RAD2DEG = 57.29577951308233



function post_initialize()
	altMode:set(1)  -- Set to barometric altitude by default (1 = baro, 1 = radar).
	headingMode:set(1) -- Set to true heading by default (1 = true, 1 = magnetic).
end

function update()
	-- ========== UFD ==========
	UFDPower:set(get_param_handle("batteryBus"):get())
	if UFDPower:get() == 1 and leftUFDPage:get() ~= -1 and rightUFDPage:get() ~= -1 then
		updateClock()



		WARNs = {leftOilPRESWARN:get(), leftENGFireWARN:get(), rightENGFireWARN:get(), rightOilPRESWARN:get()}

		cautions = {GEN1Caution:get(), HYD1Caution:get(), GEN2Caution:get(), HYD2Caution:get(), ((get_param_handle("batteryPower"):get() == 0 and get_param_handle("batteryBus"):get() == 1) and 1 or 0)}


		-- Check if any warning/caution is active.
		warnActive = utils:tableContains(WARNs, 1) == true
		cautionActive = utils:tableContains(cautions, 1) == true

		-- If a new warning/caution appears, reset acknowledged.
		newWarningAppeared = false
		for i = 1, #WARNs do
			if WARNs[i] == 1 and prevWARNs[i] == 0 then
				newWarningAppeared = true
				break
			end
		end
		if warnActive and newWarningAppeared then
			warnAcknowledged = false
		end

		newCautionAppeared = false
		for i = 1, #cautions do
			if cautions[i] == 1 and prevCautions[i] == 0 then
				newCautionAppeared = true
				break
			end
		end
		if cautionActive and newCautionAppeared then
			cautionAcknowledged = false
		end

		-- If all warnings/cautions are cleared, reset acknowledged.
		if not warnActive then
			warnAcknowledged = false
		end
		if not cautionActive then
			cautionAcknowledged = false
		end


		generalWARN:set((warnActive and not warnAcknowledged) and 1 or 0)
		leftENGFireWARN:set(baseData.getEngineLeftTemperatureBeforeTurbine() * 1.32 >= 1500 and 1 or 0) -- TODO: Add logic for actual engine fire.
		leftOilPRESWARN:set(baseData.getEngineLeftRPM() < 45 and 1 or 0)
		GEN1Caution:set(get_param_handle("Eng1Gen"):get() == 0 and 1 or 0)
		HYD1Caution:set(baseData.getEngineLeftRPM() < 60 and 1 or 0)
		get_param_handle("formationLights"):set(get_aircraft_draw_argument_value(200) > 0 and 1 or 0)

		generalCaution:set((cautionActive and not cautionAcknowledged) and 1 or 0)
		rightENGFireWARN:set(baseData.getEngineRightTemperatureBeforeTurbine() * 1.32 >= 1500 and 1 or 0) -- TODO: Add logic for actual engine fire.
		rightOilPRESWARN:set(baseData.getEngineRightRPM() < 45 and 1 or 0)
		GEN2Caution:set(get_param_handle("Eng2Gen"):get() == 0 and 1 or 0)
		HYD2Caution:set(baseData.getEngineRightRPM() < 60 and 1 or 0)
		signatureCaution:set((get_param_handle("gearUp"):get() == 0 or get_param_handle("APUSignature"):get() ~= 0 or get_param_handle("beaconLights"):get() == 1 or SRBMoving:get() ~= 0 or MWBMoving:get() ~= 0 or get_param_handle("AARDoorState"):get() == 1 or get_param_handle("gunDoorMoving"):get() ~= 0) and 1 or 0)
		weaponBaysState:set((SRBMoving:get() ~= 0 or MWBMoving:get() ~= 0) and 1 or 0)
	end



	-- ========== UFCD ==========
	UFCDPower:set((get_param_handle("APUBus"):get() == 1 or get_param_handle("mainBus"):get() == 1) and 1 or 0)
	if UFCDPower:get() == 1 and UFCDLeftPage:get() ~= -1 and UFCDRightPage:get() ~= -1 then
		-- FAST
		get_param_handle("AARReady"):set((get_param_handle("AARDoorState"):get() == 1 and get_param_handle("currentPhaseCO"):get() == 1) and 1 or 0)



		-- ADI
		get_param_handle("pitch"):set(math.deg(baseData.getPitch()))
		get_param_handle("roll"):set(math.deg(baseData.getRoll()))

		IAS:set(baseData.getIndicatedAirSpeed() * MS2KTS)
		get_param_handle("IASToHigh"):set(IAS:get() >= 999.5 and 1 or 0)
		get_param_handle("IASWarning"):set((IAS:get() < 110 and (get_param_handle("CURRENT_PHASE_LO"):get() == 1 or get_param_handle("currentPhaseCO"):get() == 1 or get_param_handle("CURRENT_PHASE_PAL"):get() == 1)) and 1 or 0) -- Change this to the stall speed

		altText:set(altMode:get() == 1 and baseData.getBarometricAltitude() * M2FT or baseData.getRadarAltitude() * M2FT)
		altTextThousands:set(math.floor(altText:get() / 1000))
		get_param_handle("altTextHundreds"):set(altText:get() - altTextThousands:get() * 1000)
		get_param_handle("VSI"):set(baseData.getVerticalVelocity() * M2FT * 60)

		get_param_handle("heading"):set(headingMode:get() == 1 and 360 - math.deg(baseData.getHeading()) or -(baseData.getMagneticHeading() * -RAD2DEG))



		-- TACT
		if editChoice:get() == 1 then
			sidewinderColor:set(2)
		elseif SRBSelect:get() == 1 then
			sidewinderColor:set(1)
		else
			sidewinderColor:set(0)
		end

		if editChoice:get() == 2 then
			AMRAAMColor:set(2)
		elseif MWBSelect:get() == 1 then
			AMRAAMColor:set(1)
		else
			AMRAAMColor:set(0)
		end

		if editChoice:get() == 3 then
			chaffColor:set(2)
		elseif chaffCount:get() == 0 then
			chaffColor:set(-1)
		elseif get_param_handle("chaffDispense"):get() ~= 0 then
			chaffColor:set(1)
		else
			chaffColor:set(0)
		end

		if editChoice:get() == 4 then
			flareColor:set(2)
		elseif flareCount:get() == 0 then
			flareColor:set(-1)
		elseif get_param_handle("flareDispense"):get() ~= 0 then
			flareColor:set(1)
		else
			flareColor:set(0)
		end



		get_param_handle("ECMText"):set(get_param_handle("ECMState"):get() == 1 and "ON" or "OFF")



		if UFCDRightPage:get() == 2.1 then
			if editChoice:get() == 1 then
				WPNStatus = "9XX EDIT"
			elseif editChoice:get() == 2 then
				WPNStatus = "120 EDIT"
			elseif editChoice:get() == 3 then
				WPNStatus = "CHF EDIT"
			elseif editChoice:get() == 4 then
				WPNStatus = "FLR EDIT"
			end
		elseif MWBSelect:get() == 1 then
			if AMRAAMCount:get() ~= 0 then
				if masterArm:get() == 1 then
					if MWBMoving:get() ~= 0 then
						WPNStatus = "120 LNCH"
					else
						WPNStatus = "120 RDY"
					end
				else
					WPNStatus = "120 SAFE"
				end
			else
				WPNStatus = "120 EMPT"
			end
		elseif SRBSelect:get() == 1 then
			if sidewinderCount:get() ~= 0 then
				if masterArm:get() == 1 then
					if SRBMoving:get() ~= 0 then
						WPNStatus = "9XX LNCH"
					else
						WPNStatus = "9XX RDY"
					end
				else
					WPNStatus = "9XX SAFE"
				end
			else
				WPNStatus = "9XX EMPT"
			end
		elseif get_param_handle("gunMode"):get() == 1 then
			if masterArm:get() == 1 then
				if get_param_handle("gunDoorMoving"):get() ~= 0 then
					WPNStatus = "GUN FIRE"
				else
					WPNStatus = "GUN RDY"
				end
			else
				WPNStatus = "GUN SAFE"
			end
		else
			WPNStatus = "NO BAY"
		end

		WPNStatusMSG:set(WPNStatus)
	end
end

function SetCommand(command, value)
	-- ========== UFD ==========
	if UFDPower:get() == 1 and leftUFDPage:get() ~= -1 and rightUFDPage:get() ~= -1 then
		if command == deviceCommands.L_ufd_1 then
			if leftUFDPage:get() ~= 0 then
				leftUFDPage:set(0)
			elseif leftUFDPage:get() == 0 then
				leftUFDPage:set(1)
			end
		end

		if command == deviceCommands.L_ufd_2 then
			for i = 1, #WARNs do
				prevWARNs[i] = WARNs[i]
			end
			warnAcknowledged = true
		end


		if command == deviceCommands.R_ufd_1 then
			if rightUFDPage:get() ~= 0 then
				rightUFDPage:set(0)
			elseif rightUFDPage:get() == 0 then
				rightUFDPage:set(1)
			end
		end

		if command == deviceCommands.R_ufd_2 then
			for i = 1, #cautions do
				prevCautions[i] = cautions[i]
			end
			cautionAcknowledged = true
		end
	end


	-- ========== UFCD ==========
	if UFCDPower:get() == 1 and UFCDLeftPage:get() ~= -1 and UFCDRightPage:get() ~= -1 then
		if command == keys.PlaneModeNAV then
			UFCDRightPage:set(1)
			editChoice:set(0)
		elseif command == keys.PlaneModeBVR or command == keys.PlaneModeVS or command == keys.PlaneModeBore or command == 110 or command == keys.PlaneModeGround then
			if UFCDRightPage:get() < 2 or UFCDRightPage:get() >= 3 then
				UFCDRightPage:set(2)
			end
		end


		if command == deviceCommands.U_osb_5 then
			if UFCDLeftPage:get() ~= 0 then
				UFCDLeftPage:set(0)
			elseif UFCDLeftPage:get() == 0 then
				UFCDLeftPage:set(1)
			end
		end


		if command == deviceCommands.U_osb_6 then
			if UFCDRightPage:get() ~= 0 and UFCDRightPage:get() ~= 2.1 then
				UFCDRightPage:set(0)
			elseif UFCDRightPage:get() == 0 then
				UFCDRightPage:set(1)
			elseif UFCDRightPage:get() == 2.1 then
				UFCDRightPage:set(2)
				editChoice:set(0)
			end
		end

		if command == deviceCommands.U_osb_7 then
			if UFCDRightPage:get() == 0 then
				UFCDRightPage:set(2)
			elseif UFCDRightPage:get() == 1 then
				altMode:set(altMode:get() == 1 and 2 or 1)
			end
		end

		if command == deviceCommands.U_osb_8 then
			if UFCDRightPage:get() == 1 then
				headingMode:set(headingMode:get() == 1 and 2 or 1)
			elseif UFCDRightPage:get() == 2.1 then
				if editChoice:get() == 1 then
					sidewinderCount:set(sidewinderCount:get() > 0 and sidewinderCount:get() - 1 or 0)
				elseif editChoice:get() == 2 then
					AMRAAMCount:set(AMRAAMCount:get() > 0 and AMRAAMCount:get() - 1 or 0)
				elseif editChoice:get() == 3 then
					chaffCount:set(chaffCount:get() >= 30 and chaffCount:get() - 30 or chaffCount:get())
				elseif editChoice:get() == 4 then
					flareCount:set(flareCount:get() >= 15 and flareCount:get() - 15 or flareCount:get())
				end
			end
		end

		if command == deviceCommands.U_osb_9 then
			if UFCDRightPage:get() == 2 then
				UFCDRightPage:set(2.1)
				editChoice:set(1)
			elseif UFCDRightPage:get() == 2.1 then
				editChoice:set(editChoice:get() ~= 4 and editChoice:get() + 1 or 1)
			end
		end

		if command == deviceCommands.U_osb_10 then
			if UFCDRightPage:get() == 2.1 then
				if editChoice:get() == 1 then
					sidewinderCount:set(sidewinderCount:get() < 2 and sidewinderCount:get() + 1 or 2)
				elseif editChoice:get() == 2 then
					AMRAAMCount:set(AMRAAMCount:get() < 6 and AMRAAMCount:get() + 1 or 6)
				elseif editChoice:get() == 3 then
					chaffCount:set(chaffCount:get() <= 90 and chaffCount:get() + 30 or chaffCount:get())
				elseif editChoice:get() == 4 then
					flareCount:set(flareCount:get() <= 105 and flareCount:get() + 15 or flareCount:get())
				end
			end
		end
	end
end


--- Updates the digital clock on the screens.
function updateClock()                     -- By the Gripen team
	local absTime = get_absolute_model_time() -- gives local time of day in seconds
	local hour = absTime / 3600
	local CorrectedHour = math.floor(hour)
	local _tmp, frac = math.modf(hour)
	local _tmp2, frac1 = math.modf(frac * 60)


	if CorrectedHour < 24 then
		hourTime:set(CorrectedHour)
	elseif CorrectedHour < 48 then
		hourTime:set(CorrectedHour - 24)
	elseif CorrectedHour < 72 then
		hourTime:set(CorrectedHour - 48)
	end

	minuteTime:set(math.floor(frac * 60))
	secondTime:set(frac1 * 59.49)

	get_param_handle("clock"):set(string.format("%02d:%02d:%02d", hourTime:get(), minuteTime:get(), secondTime:get()))
end



need_to_be_closed = false