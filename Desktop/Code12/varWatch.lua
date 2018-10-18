-----------------------------------------------------------------------------------------
--
-- varWatch.lua
--
-- Implementation of the variable watch window for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Corona modules
local widget = require( "widget" )

-- Code12 app modules
local g = require( "Code12.globals" )
local ct = require( "Code12.ct" )
local app = require( "app" )
local checkJava = require( "checkJava" )


-- The varWatch module
local varWatch = {
	group = nil,              -- the varWatch display group
}

-- UI constants
local rowHeight = 20          -- height of each row in the variable display
local dropDownBtnSize = 10    -- width and height of the drop down buttons
local margin = app.margin     -- space between UI elements
local centerColWidth = 125    -- width of the center column of the variable display

-- Display state
local textObjRows = {}        -- table of rows of the variable display
local numDisplayRows = 0      -- number of rows currently displayed
local xCols                   -- table of x-values for the left of each column
local dropDownBtnsGroup       -- display group for drop down buttons
local charWidth               -- character width of the font used for text objects
local varWatchHeight          -- current height of the variable watch window

-- varWatch data
local vars         			 -- array of user program's global variables
local displayData = {}       -- array of data for displaying variables
local gameObjFields = { "x", "y", "width", "height", "xSpeed", "ySpeed", 
                        "lineWidth", "visible", "clickable", "autoDelete", "group" }
local numGameObjFields = #gameObjFields
local mapVtToTypeName = {
	[0]          = "int",
	[1]          = "double",
	[true]       = "boolean",
	["String"]   = "String",
	["GameObj"]  = "GameObj",
}


--- Internal Functions ---------------------------------------------------------

-- Update variable values displayed in the variable watch window
local function updateValues()
	if vars and ct.userVars then
		for i = 1, numDisplayRows do
			local d = displayData[i]
			local var = d.var
			local varType = var.varType
			local typeName = var.typeName
			local varName = var.varName
			local value = ct.userVars[varName]
			if not value then
				if typeName then
					textObjRows[i][2].text = typeName .. "[]"
					var.openBtn.isVisible = false
				else
					textObjRows[i][2].text = "null"
				end
			elseif not d.index and not d.field then
				-- row text = varName, value
				if varType == "String" then
					textObjRows[i][2].text = value
				elseif varType == "GameObj" then
					-- valueStr = value._code12.typeName
					textObjRows[i][2].text = value:toString()
				elseif varType == "array" then
					local prevLength = var.length
					local length = value.length
					var.length = length
					if not prevLength then
						-- Uninitialized array was initialized
						var.openBtn.isVisible = true
					elseif prevLength ~= length and var.isOpen then
						-- Open array was set equal to an array of different size
						varWatch.reset( varWatchHeight )
						return nil
					end
					textObjRows[i][2].text = typeName .. "[".. length .. "]"
				else
					textObjRows[i][2].text = tostring(value)
				end
			elseif not d.index and d.field then
				-- row text = field, value
				textObjRows[i][2].text = tostring(value[d.field])
			elseif d.index and not d.field then
				-- row text = [index], value
				local valueAtIndex = value[d.index]
				if not valueAtIndex then
					if typeName == "int" or typeName == "double" then
						textObjRows[i][2].text = "0"
					elseif typeName == "boolean" then
						textObjRows[i][2].text = "false"
					else
						textObjRows[i][2].text = "null"
					end
				elseif type(valueAtIndex) == "table" then
					textObjRows[i][2].text = valueAtIndex:toString()
				else
					textObjRows[i][2].text = tostring(valueAtIndex)
				end
			else
				-- d.index and d.field
				-- TODO
			end
		end
	end
end

-- Event handler for open variable buttons
local function onOpenVar( event )
	local openBtn = event.target
	local var = openBtn.var
	var.isOpen = true
	varWatch.reset( varWatchHeight )	
end

-- Event handler for close variable buttons 
local function onCloseVar( event )
	local closeBtn = event.target
	local var = closeBtn.var
	var.isOpen = false
	varWatch.reset( varWatchHeight )
	return true
end

-- Makes an open and close variable button and attaches them to var
-- in var.openBtn and var.closeBtn
local function makeDropDownBtns( var )
	local openBtn = widget.newButton{
		onPress = onOpenVar,
		width = dropDownBtnSize,
		height = dropDownBtnSize,
		defaultFile = "images/drop-down-arrow-right.png",
	}
	openBtn:setFillColor( 0 )
	openBtn.isVisible = false
	openBtn.var = var
	var.openBtn = openBtn
	openBtn.anchorX = 1
	openBtn.anchorY = 0
	dropDownBtnsGroup:insert( openBtn )
	local closeBtn = widget.newButton{
		onPress = onCloseVar,
		width = dropDownBtnSize,
		height = dropDownBtnSize,
		defaultFile = "images/drop-down-arrow.png",
	}
	closeBtn:setFillColor( 0 )
	closeBtn.isVisible = false
	closeBtn.var = var
	var.closeBtn = closeBtn
	closeBtn.anchorX = 1
	closeBtn.anchorY = 0
	dropDownBtnsGroup:insert( closeBtn )
end

-- Shows the given var's appropriate open/close button and hides the other 
-- if given showBtns is true, if showBtns is false hides both the var's buttons
local function showDropDownBtns( var, showBtns )
	if showBtns then
		if var.isOpen then
			var.openBtn.isVisible = false
			var.closeBtn.isVisible = true
		else
			var.openBtn.isVisible = true
			var.closeBtn.isVisible = false
		end
	else
		var.openBtn.isVisible = false
		var.closeBtn.isVisible = false
	end
end

-- Positions given var's open and close buttons to the given x, y values
local function positionDropDownBtns( var, x, y )
	local openBtn = var.openBtn
	local closeBtn = var.closeBtn
	openBtn.x, openBtn.y = x, y
	closeBtn.x, closeBtn.y = x, y
end

--- Module Functions ---------------------------------------------------------

-- Init the variable watch window
function varWatch.init()
	Runtime:addEventListener( "enterFrame", updateValues )
end

-- Create the variable watch window display group and store it in varWatch.group
function varWatch.create( parent, x, y )
	varWatch.group = g.makeGroup( parent, x, y )
	charWidth = app.consoleFontCharWidth
end

-- Fill the vars array with the user program's global variables
function varWatch.getVars()
	if dropDownBtnsGroup then
		dropDownBtnsGroup:removeSelf( )
		dropDownBtnsGroup = nil
	end
	dropDownBtnsGroup = g.makeGroup( varWatch.group, 0, 0 )
	vars = checkJava.globalVars()
	if vars then
		local maxVarNameWidth = 100 -- minimum width to ensure space for GameObj fields
		for i = 1, #vars do
			local var = vars[i]
			local vt = var.vt
			local varName = var.nameID.str
			var.varName = varName
			local varNameWidth = string.len( varName ) * charWidth
			if maxVarNameWidth < varNameWidth then
				maxVarNameWidth = varNameWidth
			end
			if vt == 0 or vt == 1 or vt == true then
				var.varType = "primitive"
			elseif vt == "String" then
				var.varType = vt
			elseif vt == "GameObj" then
				var.varType = vt
				makeDropDownBtns( var )
			elseif type(vt) == "table" then
				var.varType = "array"
				var.typeName = mapVtToTypeName[vt.vt]
				makeDropDownBtns( var )
			end
		end
		xCols = { 0, maxVarNameWidth + margin, maxVarNameWidth + margin + centerColWidth }
	end
end

-- Fill the displayData array with data for displaying the user program's global variables
function varWatch.makeDisplayData()
	displayData = {}
	if vars then
		local iRow = 1
		for i = 1, #vars do
			local var = vars[i]
			local isOpen = var.isOpen
			local varType = var.varType
			local varName = var.varName
			local value = ct.userVars[varName]
			local d = {}
			d.var = var
			d.openBtn = var.openBtn
			d.initRowTexts = { varName, "", "" }
			displayData[iRow] = d
			iRow = iRow + 1
			if isOpen and varType == "GameObj" then
				-- add GameObj data fields
				for j = 1, numGameObjFields do
					local gameObjField = gameObjFields[j]
					d = { var = var, field = gameObjField }
					d.initRowTexts = { " "..gameObjField, "", "" }
					displayData[iRow] = d
					iRow = iRow + 1
				end
			elseif isOpen and varType == "array" then
				local typeName = d.typeName
				-- add array indices
				local len = value.length
				for j = 1, len do
					d = { var = var, index = j }
					d.initRowTexts = { " ["..j.."]", "", "" }
					displayData[iRow] = d
					iRow = iRow + 1
					if typeName == "GameObj" and value[j].isOpen then
						for k = 1, numGameObjFields do
							local gameObjField = gameObjFields[k]
							d = { var = var, index = j, field = gameObjField }
							d.initRowTexts = { "", gameObjField, "" }
							displayData[iRow] = d
							iRow = iRow + 1
						end
					end
				end
			end
		end
	end
end

-- Resize the variable watch window to fit the given size
function varWatch.resize( height )
	local prevNumDisplayRows = numDisplayRows
	-- Determine the new number of display rows
	numDisplayRows = math.floor( height / rowHeight )
	numDisplayRows = math.min( numDisplayRows, #displayData )
	local n = #textObjRows
	if prevNumDisplayRows < numDisplayRows then
		-- Make sure we have enough text objects
		while n < numDisplayRows do
			n = n + 1
			local row = g.makeGroup( varWatch.group, 0, (n - 1) * rowHeight )
			local d = displayData[n]
			if d.openBtn then
				local var = d.var
				positionDropDownBtns( var, row.x, row.y )
				showDropDownBtns( var, true )
			end 
			for col = 1, 3 do
				g.uiBlack ( display.newText{
					parent = row,
					text = displayData[n].initRowTexts[col],
					x = xCols[col],
					y = 0,
					font = app.consoleFont,
					fontSize = app.consoleFontSize,
					align = "left",
				} )
			end
			textObjRows[n] = row			
		end
		if n > prevNumDisplayRows then
		-- Show rows in output area previously hidden
			for i = prevNumDisplayRows + 1, numDisplayRows do
				textObjRows[i].isVisible = true
				local d = displayData[i]
				if d.openBtn then
					showDropDownBtns( d.var, true )
				end
			end
		end
	elseif prevNumDisplayRows > numDisplayRows and n > numDisplayRows then
		-- Hide any rows below the output area
		for i = numDisplayRows + 1, prevNumDisplayRows do
			textObjRows[i].isVisible = false
			local d = displayData[i]
			if d.openBtn then
				showDropDownBtns( d.var, false )
			end
		end
	end
	varWatchHeight = height
end

-- Remakes the display data, deletes any extra text objs, resets the text values and 
-- column positions, hides any dropDownBtns outside the output area, and resizes the 
-- variable watch window
function varWatch.reset( height )
	varWatch.makeDisplayData()
	for i = 1, dropDownBtnsGroup.numChildren do
		dropDownBtnsGroup[i].isVisible = false
	end
	if #textObjRows > #displayData then
		for i = #displayData + 1, #textObjRows do
			textObjRows[i]:removeSelf( )
			textObjRows[i] = nil
		end
	end
	for i = 1, #textObjRows do
		local row = textObjRows[i]
		local d = displayData[i]
		local var = d.var
		row[1].text = d.initRowTexts[1]
		if d.openBtn then
			positionDropDownBtns( var, row.x, row.y )
			showDropDownBtns( var, i <= numDisplayRows )
		end
		if xCols then
			for col = 2, 3 do
				row[col].x = xCols[col]
			end
		end
	end
	varWatch.resize( height )
end

-- Starts a new run of the varWatch window based on the given height
function varWatch.startNewRun( height )
	varWatch.getVars()
	varWatch.reset( height )
end

------------------------------------------------------------------------------

return varWatch
