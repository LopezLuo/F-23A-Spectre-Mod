dofile(LockOn_Options.common_script_path .. "Fonts/symbols_locale.lua")
dofile(LockOn_Options.common_script_path .. "Fonts/fonts_cmn.lua")
dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Common_Defs.lua")



height = GetHalfHeight() * 2
width  = GetHalfWidth() * 2

edgeOSBTextX = GetHalfWidth() / 3 * 2 - .001
OSBTextY     = -GetHalfHeight() + .006
OSB1Text = {-edgeOSBTextX, OSBTextY}
OSB2Text = {0, OSBTextY}
OSB3Text = {edgeOSBTextX, OSBTextY}


lvls = { -- Levels
	def    = 2, 
	mask   = 3, 
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
--- @return Element: The created "ceSimple" element.
function addUFDSimple(name, pos, rot, parentElement, hClip, level, elementParams, controllers)
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
function addUFDMeshPoly(name, pos, rot, parentElement, hClip, level, elementParams, controllers, vertices, indices, material, isMask)
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
function addUFDCircle(name, pos, rot, parentElement, hClip, level, elementParams, controllers, outerRadius, innerRadius, arc, res, material, isMask)
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
function addUFDSimpleLine(name, pos, rot, parentElement, hClip, level, elementParams, controllers, iWidth, vertices, material, isMask)
	return addSimpleLine(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, iWidth or width * lineThickness, vertices, material, isMask)
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
function addUFDBox(name, pos, rot, parentElement, hClip, level, elementParams, controllers, iWidth, iHeight, material, isMask)
	return addBox(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, iWidth or width * lineThickness * 2, iHeight or width * lineThickness * 2, material, isMask)
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
function addUFDText(name, pos, rot, parentElement, hClip, level, elementParams, controllers, text, alignment, stringdef, font)
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
function addUFDTextParam(name, pos, rot, parentElement, hClip, level, elementParams, controllers, textParam, alignment, format, stringdef, font)
	return addTextParam(name, pos, rot, parentElement, hClip, level or lvls.def, elementParams, controllers, textParam, alignment, format, stringdef or strdefs.std, font or fonts["white"])
end


--- Adds a box with text inside it.
--- @param name string: The name of the element.
--- @param pos table: The initial position of the element.
--- @param rot table: The initial rotation of the element.
--- @param parentElement string|userdata: The parent element of the element.
--- @param hClip string: The clipping relation of the element.
--- @param level number: The level of the element.
--- @param elementParams table: The parameters of the element.
--- @param controllers table: The controllers of the element.
--- @param edge boolean: Whether to add an edge around the box.
--- @param outerMaterial string: The material of the edge (defualt is materials["white"]).
--- @param iInnerWidth number: The inner width of the box (nil will default to text width).
--- @param iInnerHeight number: The inner height of the box (nil will default to text height).
--- @param innerMaterial string: The material of the inner box (default is materials["background"]).
--- @param text string: The text to display inside the box.
--- @param alignment string: The alignment of the text (default is align.CC).
--- @param iStringdef table: The text size for the text (default is strdefs.std).
--- @param font string: The font to use for the text (default is fonts["white"]).
--- @return table: The "ceSimple" element which is parent to the box and text.
function addUFDTextBox(name, pos, rot, parentElement, hClip, level, elementParams, controllers, edge, outerMaterial, iInnerWidth, iInnerHeight, innerMaterial, text, alignment, iStringdef, font)
	local stringdef = iStringdef or strdefs.std

	local innerHeight = .0
	local innerWidth  = .0
	local margin = .0006
	local lengthMult = stringdef[1] / 2 + margin
	local height = stringdef[1]
	local boxXOffset = -.00015

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



	local parent = addUFDSimple(name, pos, rot, parentElement, hClip, level, elementParams, controllers)
	if edge then
		addUFDBox(nil, {boxXOffset}, rot, parent, hClip, level, nil, nil, innerWidth + lineThickness * 2, innerHeight + lineThickness * 2, outerMaterial or materials["white"])
	end
	addUFDBox(nil, {boxXOffset}, rot, parent, hClip, level, nil, nil, innerWidth, innerHeight, innerMaterial or materials["background"])
	addUFDText(nil, nil, rot, parent, hClip, level, nil, nil, text, alignment, stringdef, font)

	return parent
end