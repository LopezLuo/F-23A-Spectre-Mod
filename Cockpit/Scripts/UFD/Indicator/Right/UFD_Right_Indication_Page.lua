-- ========== Loading page ==========
addUFDSimple("Loading_Base", nil, nil, base, nil, nil, {"leftUFDPage"}, {{ctrl.compareNum, 0, -1}})


addUFDTextBox(nil, nil, nil, "Loading_Base", nil, nil, nil, nil, true, nil, nil, nil, nil, "LOADING")

addUFDTextParam(nil, {0, -.01}, nil, "Loading_Base", nil, nil, nil, nil, "UFDLoadingPercent", nil, {"%1.0f%%"}, strdefs.small)



-- ========== Choose page ==========
addUFDSimple("Menu_Base", nil, nil, base, nil, nil, {"rightUFDPage"}, {{ctrl.compareNum, 0, 0}})


addUFDText(nil, OSB1Text, nil, "Menu_Base", nil, nil, nil, nil, "WARN")



-- ========== WARN page ==========
addUFDSimple("WARN_Base", nil, nil, base, nil, nil, {"rightUFDPage"}, {{ctrl.compareNum, 0, 1}})


addUFDTextBox(nil, OSB1Text, nil, "WARN_Base", nil, nil, nil, nil, true, nil, nil, nil, nil, "WARN")

addUFDText(nil, OSB2Text, nil, "WARN_Base", nil, nil, nil, nil, "RSET")



light = 0
lights = {
	{text = "CAUTION ",                           param = {"generalCaution"},   color = materials["orange"]},
	{text = "ENG FIRE",                           param = {"rightENGFireWARN"}, color = materials["red"]},
	{text = "OIL PRES",                           param = {"rightOilPRESWARN"}, color = materials["red"]},
	{text = " GEN: 2 ",                           param = {"GEN2Caution"},      color = materials["orange"]},
	{text = " HYD: 2 ",                           param = {"HYD2Caution"},      color = materials["orange"]},
	{text = " SIGNAT ",                           param = {"signatureCaution"}, color = materials["orange"]},
	{text = "PARK BRK",                           param = {"parkingBrake"},     color = materials["green"]},
	{text = {"APU STRT", " APU RN ", "APU SHUT"}, param = {"APUState"},         color = {materials["green"], materials["lightBlue"], materials["orange"]}},
	{text = " WP BAY ",                           param = {"weaponBaysState"},  color = materials["orange"]}
}

for i = 2, 0, -1 do
	for j = -1, 1 do
		light = light + 1
		local color = lights[light].color

		if type(lights[light].text) == "table" then
			for k = 1, #lights[light].text do
				addUFDTextBox(nil, {j * (width / 3 - .00325), i * ((height - .0125) / 3) - .007}, nil, "WARN_Base", nil, nil, lights[light].param, {{ctrl.compareNum, 0, k}}, color[k] == materials["green"] and true or false, color[k] == materials["green"] and materials["green"] or nil, .001, .001, color[k] == materials["green"] and materials["background"] or color[k], lights[light].text[k], nil, strdefs.big, color[k] == materials["green"] and fonts["white"] or color[k] == materials["red"] and fonts["white"] or fonts["black"])
			end
		else
			addUFDTextBox(nil, {j * (width / 3 - .00325), i * ((height - .0125) / 3) - .007}, nil, "WARN_Base", nil, nil, lights[light].param, {{ctrl.compareNum, 0, 1}}, color == materials["green"] and true or false, color == materials["green"] and materials["green"] or nil, .001, .001, color == materials["green"] and materials["background"] or color, lights[light].text, nil, strdefs.big, color == materials["green"] and fonts["white"] or color == materials["red"] and fonts["white"] or fonts["black"])
		end
	end
end



addUFDBox(nil, nil, nil, base, hcr.rw, lvls.noclip, {"screenBrightness"}, {{ctrl.opacity, 0}}, width, height, materials["black"])