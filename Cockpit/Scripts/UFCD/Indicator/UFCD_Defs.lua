dofile(LockOn_Options.common_script_path .. "Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path .. "Fonts/fonts_cmn.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Common_Defs.lua")



base = "UFCD_Base"

height = GetHalfHeight() * 2
width  = GetHalfWidth() * 2


innerBottomOSBTextX = GetHalfWidth() / 3 - .0035
outerBottomOSBTextX = -GetHalfWidth() / 8
edgeOSBTextX = -width / 4 + .004

bottomOSBTextY = -GetHalfHeight() + .006
lowSideOSBTextY = -height / 5 - .0015
medSideOSBTextY = height / 9
highSideOSBTextY = height / 3 + .0065

OSB5Text = {innerBottomOSBTextX, bottomOSBTextY}
OSB6Text = {-innerBottomOSBTextX, bottomOSBTextY}
OSB7Text = {-outerBottomOSBTextX, bottomOSBTextY}
OSB8Text = {-edgeOSBTextX, lowSideOSBTextY}
OSB9Text = {-edgeOSBTextX, medSideOSBTextY}


lvls = { -- Levels
	def = 2,
	mask = 3,
	mask2 = 4,
	noclip = 1
}



--- Adds a "ceSimple" element.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @return table: The created "ceSimple" element.
function addUFCDSimple(name, pos, rot, parentElement, hClip, level, elementParams, controllers)
	return addSimple(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers)
end


--- Adds a "ceMeshPoly" element.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param vertices table: The vertices of the mesh.
--- @param indices table: The indices of the mesh.
--- @param material string: The material of the mesh.
--- @param isMask boolean: Whether the element is invisible or not.
--- @return table: The created "ceMeshPoly" element.
function addUFCDMeshPoly(name, pos, rot, parentElement, hClip, level, elementParams, controllers, vertices, indices, material, isMask)
	return addMeshPoly(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, vertices, indices, material, isMask)
end

--- Adds a "ceMeshPoly" element with a circle shape.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param outerRadius number: The outer radius of the circle.
--- @param innerRadius number: The inner radius of the circle.
--- @param arc number: The arc of the circle in degrees.
--- @param res number: The resolution of the circle (number of segments).
--- @param material string: The material of the mesh.
--- @param isMask boolean: Whether the element is invisible or not.
--- @return table: The created "ceMeshPoly" element with a circle shape.
function addUFCDCircle(name, pos, rot, parentElement, hClip, level, elementParams, controllers, outerRadius, innerRadius, arc, res, material, isMask)
	return addCircle(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, outerRadius, innerRadius, arc, res, material, isMask)
end

--- Adds a "ceSimpleLineObject" element.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param iWidth number: The width of the line.
--- @param vertices table: The vertices of the line.
--- @param material string: The material of the line.
--- @param isMask boolean: Whether the element is invisible or not.
--- @return table: The created "ceSimpleLineObject" element.
function addUFCDSimpleLine(name, pos, rot, parentElement, hClip, level, elementParams, controllers, iWidth, vertices, material, isMask)
	return addSimpleLine(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, iWidth or lineThickness / 2, vertices, material, isMask)
end

--- Adds a "ceSimpleLineObject" element with a width and height instead of vertices.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param iWidth number: The width of the box.
--- @param iHeight number: The height of the box.
--- @param material string: The material of the box.
--- @param isMask boolean: Whether the element is invisible or not.
--- @return table: The created "ceSimpleLineObject" element with a width and height.
function addUFCDBox(name, pos, rot, parentElement, hClip, level, elementParams, controllers, iWidth, iHeight, material, isMask)
	return addBox(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, iWidth or lineThickness, iHeight or lineThickness, material, isMask)
end


--- Adds a "ceStringPoly" element with static text.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param text string: The text to display in the element.
--- @param alignment string: The alignment of the text (default is align.CC).
--- @param stringdef table: The text size for the text (default is strdefs.std).
--- @param font string: The font to use for the text (default is fonts["white"]).
--- @return table: The created "ceStringPoly" element.
function addUFCDText(name, pos, rot, parentElement, hClip, level, elementParams, controllers, text, alignment, stringdef, font)
	return addText(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, text or "Lorem Ipsum", alignment, stringdef or strdefs.std, font or fonts["white"])
end

--- Adds a "ceStringPoly" element with a changable text (parameter).
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param textParam string: The parameter to use for the text.
--- @param alignment string: The alignment of the text (default is align.CC).
--- @param format table: The formats for the text (default is {"%.0f"}, use {"%s"} for parameters that are strings).
--- @param stringdef table: The text size for the text (default is strdefs.std).
--- @param font string: The font to use for the text (default is fonts["white"]).
--- @return table: The created "ceStringPoly" element.
function addUFCDTextParam(name, pos, rot, parentElement, hClip, level, elementParams, controllers, textParam, alignment, format, stringdef, font)
	return addTextParam(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, textParam, alignment, format, stringdef or strdefs.std, font or fonts["white"])
end


--- Adds a box with static text inside it.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param edge boolean: Whether to add an edge around the box.
--- @param outerMaterial string: The material of the edge (default is materials["white"]).
--- @param iInnerWidth number: The inner width of the box (nil will default to text width).
--- @param iInnerHeight number: The inner height of the box (nil will default to text height).
--- @param innerMaterial string: The material of the inner box (default is materials["background"]).
--- @param text string: The text to display inside the box.
--- @param alignment string: The alignment of the text (default is align.CC).
--- @param iStringdef table: The text size for the text (default is strdefs.std).
--- @param font string: The font to use for the text (default is fonts["white"]).
--- @return table: The "ceSimple" element which is parent to the box and text.
function addUFCDTextBox(name, pos, rot, parentElement, hClip, level, elementParams, controllers, edge, outerMaterial, iInnerWidth, iInnerHeight, innerMaterial, text, alignment, iStringdef, font)
	local stringdef = iStringdef or strdefs.std

	local innerHeight = .0
	local innerWidth  = .0
	local margin      = .0006
	local lengthMult  = stringdef[1] / 2 + margin
	local height      = stringdef[1]
	local boxXOffset  = -.00015

	if iInnerHeight then
		innerHeight = height + iInnerHeight + margin
	else
		innerHeight = height + margin
	end

	if iInnerWidth then
		innerWidth = string.len(text) * lengthMult + iInnerWidth + margin * 2
	else
		innerWidth = string.len(text) * lengthMult + margin * 2
	end



	local parent = addUFCDSimple(name, pos, rot, parentElement, hClip, level, elementParams, controllers)
	if edge then
		addUFCDBox(nil, {boxXOffset}, nil, parent, hClip, level, nil, nil, innerWidth + lineThickness * 2, innerHeight + lineThickness * 2, outerMaterial or materials["white"])
	end
	addUFCDBox(nil, {boxXOffset}, nil, parent, hClip, level, nil, nil, innerWidth, innerHeight, innerMaterial or materials["background"])
	addUFCDText(nil, nil, nil, parent, hClip, level, nil, nil, text, alignment, stringdef, font)

	return parent
end

--- Adds a box with changable text inside it.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param edge boolean: Whether to add an edge around the box.
--- @param outerMaterial string: The material of the edge (default is materials["white"]).
--- @param iInnerWidth number: The inner width of the box (nil will default to text width).
--- @param iInnerHeight number: The inner height of the box (nil will default to text height).
--- @param innerMaterial string: The material of the inner box (default is materials["background"]).
--- @param textParam string: The text to display inside the box.
--- @param textLen number: The length of the text.
--- @param alignment string: The alignment of the text (default is align.CC).
--- @param format table: The formats for the text (default is {"%.0f"}, use {"%s"} for parameters that are strings).
--- @param iStringdef table: The text size for the text (default is strdefs.std).
--- @param font string: The font to use for the text (default is fonts["white"]).
--- @return table: The "ceSimple" element which is parent to the box and text.
function addUFCDTextParamBox(name, pos, rot, parentElement, hClip, level, elementParams, controllers, edge, outerMaterial, iInnerWidth, iInnerHeight, innerMaterial, textParam, textLen, alignment, format, iStringdef, font)
	local stringdef = iStringdef or strdefs.std

	local innerHeight = .0
	local innerWidth  = .0
	local margin      = .0006
	local lengthMult  = stringdef[1] / 2 + margin
	local height      = stringdef[1]
	local boxXOffset  = -.00015

	if iInnerHeight then
		innerHeight = height + iInnerHeight + margin
	else
		innerHeight = height + margin
	end

	if iInnerWidth then
		innerWidth = textLen * lengthMult + iInnerWidth + margin * 2
	else
		innerWidth = textLen * lengthMult + margin * 2
	end



	local parent = addUFCDSimple(name, pos, rot, parentElement, hClip, level, nil, nil)
	if edge then
		addUFCDBox(nil, {boxXOffset}, rot, parent, hClip, level, nil, nil, innerWidth + lineThickness * 2, innerHeight + lineThickness * 2, outerMaterial or materials["white"])
	end
	addUFCDBox(nil, {boxXOffset}, rot, parent, hClip, level, nil, nil, innerWidth, innerHeight, innerMaterial or materials["background"])
	addUFCDTextParam(nil, nil, rot, parent, hClip, level, elementParams, controllers, textParam, alignment, format, stringdef, font)

	return parent
end


--- Adds a "ceTexPoly" element from a texture file.
--- @param name string The name of the element.
--- @param pos table The initial position of the element.
--- @param rot table The initial rotation of the element.
--- @param parentElement string|userdata The parent element of the element.
--- @param hClip string The clipping relation of the element.
--- @param level number The level of the element.
--- @param elementParams table The parameters of the element.
--- @param controllers table The controllers of the element.
--- @param texture table The material defined texture.
--- @param upperLeftX integer The upper left X coordinate of the texture.
--- @param upperLeftY integer The upper left Y coordinate of the texture.
--- @param lowerRightX integer The lower right X coordinate of the texture.
--- @param lowerRightY integer The lower right Y coordinate of the texture.
--- @param scale number The scale of the texture (default is 1).
--- @param centerX integer The center X coordinate of the texture (default is the center of the texture).
--- @param centerY integer The center Y coordinate of the texture (default is the center of the texture).
--- @param isMask boolean Whether the texture is a mask (default is false).
--- @return table The created "ceTexPoly" element.
function addUFCDTex(name, pos, rot, parentElement, hClip, level, elementParams, controllers, texture, upperLeftX, upperLeftY, lowerRightX, lowerRightY, scale, centerX, centerY, isMask)
	return addTex(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, texture, upperLeftX, upperLeftY, lowerRightX, lowerRightY, scale, centerX, centerY, isMask)
end