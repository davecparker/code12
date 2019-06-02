-----------------------------------------------------------------------------------------
--
-- varWatch.lua
--
-- Implementation of the variable watch window for the Code 12 Desktop app
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------

-- Code12 app modules
local g = require( "Code12.globals" )
local ct = require( "Code12.ct" )
local runtime = require("Code12.runtime")
local app = require( "app" )
local javaTypes = require( "javaTypes" )
local checkJava = require( "checkJava" )
local codeGenJava = require( "codeGenJava" )
local buttons = require( "buttons" )
local Scrollbar = require( "Scrollbar" )


-- The varWatch module
local varWatch = {
	group = nil,              -- the varWatch display group
	table = nil,              -- the display group containing the variable watch table
}

-- UI constants
local gridShade = 0.8         -- shade for the table gridlines
local topMargin = 5           -- margin for the top of the variable watch window
local margin = app.margin     -- space between UI elements 
local padding = 3             -- min space between the end of text and a vertical gridline

-- Display state
local displayRows             -- table of rows of the variable display
local numDisplayableRows      -- number of rows that can currently be displayed
local xCols                   -- table of x-values for the left of each column
local charWidth               -- character width of the font used for text objects
local rowHeight               -- height of each row in the variable display
local maxGameObjFieldWidth    -- maximum space needed to fix longest GameObj field in the display
local dropDownBtnSize         -- width and height of the drop down buttons
local dropDownBtnYOffset      -- y-value for drop down buttons relative to their row
local stdIndents              -- indents for standard top-level variable display rows
local indexOrFieldIndents     -- indents for rows with an index xor a field
local indexAndFieldIndents    -- indents for rows with an index and a field
local centerColWidth          -- width of the center column of the variable display
local showVarWatch            -- true if variable watch is active

-- varWatch data
local vars                    -- array of user program's global variables
local localVars               -- array of { name = name, value = value } for local vars, if any
local displayData             -- array of data for displaying variables
local scrollbar               -- the varWatch scrollbar
local scrollOffset            -- starting line if scrolled back or nil if at end
local arrayAssigned           -- true when an array has been assigned and displayData needs to be updated 
local scrollOffsetChanged     -- true when scrollOffset has changed and displayRows needs to be updated

-- Names of GameObj public data fields to show
local gameObjFields = { 
	-- Public fields
	"x", "y", "visible", "id", "group",
	-- Additional fields
	"width", "height", "xSpeed", "ySpeed", "text", "fillColor", "lineColor", 
	"lineWidth", "layer", "clickable",
}
local numPublicGameObjFields = 4


--- Internal Functions ---------------------------------------------------------

-- Fill the vars array with the user program's known variables
local function getVars()
	local globalVars = checkJava.globalVars()
	if not globalVars and not localVars then
		vars = nil
		return
	end
	-- Initialize vars table
	vars = {}
	if globalVars then
		-- Add global variables to vars table
		for i = 1, #globalVars do
			local var = globalVars[i]
			var.name = var.nameID.str
			if type( var.vt ) == "table" then
				var.arrayType = javaTypes.typeNameFromVt( var.vt.vt )
			end
			vars[#vars + 1] = var
		end
	end
	if localVars and #localVars > 0 then
		-- Add divider between global and local variables
		vars[#vars + 1] = { isDivider = true, name = "" }
		-- Add local variables to vars table
		for i = 1, #localVars do
			local var = localVars[i]
			if var.value == nil then -- Can't tell what it is, treat it as a null string
				var.vt = "String"
			else
				local typeVarValue = type( var.value )				
				if typeVarValue == "number" then
					-- Can't tell int from double, treat it as a double
					var.vt = 1
				elseif typeVarValue == "boolean" then
					var.vt = true
				elseif typeVarValue == "string" then
					var.vt = "String"
				elseif typeVarValue == "table" then
					if var.value.vt then
						var.arrayType = javaTypes.typeNameFromVt( var.value.vt )
					else
						var.vt = "GameObj"
					end
				end
			end
			var.isLocal = true
			vars[#vars + 1] = var
		end
	end
	-- Determine values for varWatch column x-values
	local maxVarNameWidth = dropDownBtnSize + maxGameObjFieldWidth -- minimum width to ensure space for GameObj fields
	for i = 1, #vars do
		local var = vars[i]
		local varNameWidth = math.ceil( string.len( var.name ) * charWidth )
		if maxVarNameWidth < varNameWidth then
			maxVarNameWidth = varNameWidth
		end
	end
	xCols = { margin, margin + maxVarNameWidth + padding, margin + maxVarNameWidth + padding + centerColWidth }
end

-- Returns a string for the given (int, double, or boolean) value
local function textForPrimitiveValue( value )
	return tostring( value )
end

-- Returns a string for the given String value
local function textForStringValue( value )
	if value then
		return '"' .. value .. '"'
	end
	return "null"
end

-- Returns a string for the given GameObj value
local function textForGameObjValue( value )
	if value == nil then
		return "null"
	elseif value.deleted then
		return "(deleted GameObj)"
	end
	return value:toString()
end

-- Returns a string for the given array value and type
local function textForArrayValue( value, arrayType )
	if value == nil then
		return "null"
	end
	return tostring( arrayType ) .. "[" .. tostring( value.length ) .. "]"
end

-- Returns a string for the given GameObj value and field
local function textForGameObjField( value, field )
	if value then
		local v = value[field]
		local t = type(v)
		if t == "nil" then
			return "null"
		elseif t == "string" then
			return '"' .. v .. '"'
		elseif t == "table" then   -- { r, g, b }
			return "(" .. v[1] .. "," .. v[2] .. "," .. v[3] .. ")"
		end
		return tostring(v)
	end
	return "-"
end

-- Fill the displayData array with data for displaying the user program's global variables
local function makeDisplayData()
	displayData = {}
	if vars then
		local iRow = 1
		for i = 1, #vars do
			local var = vars[i]
			if var.isDivider then
				displayData[iRow] = var
				iRow = iRow + 1
			else
				local d = { var = var }
				-- Add display data for this var to d
				local isOpen = var.isOpen
				local vt = var.vt
				local arrayType = var.arrayType
				local varName = var.name
				local value = (var.isLocal and var.value) or ct.userVars[codeGenJava.luaName( var.name )]
				d.initRowTexts = { varName, "" }
				d.textIndents = stdIndents
				-- Determine d.textForValue from vt
				if vt == "String" then
					d.textForValue = textForStringValue
				elseif vt == "GameObj" then
					d.textForValue = textForGameObjValue
					d.dropDownVisible = 1
				elseif arrayType then
					d.textForValue = textForArrayValue
					if value and value.length then
						d.dropDownVisible = 1
					end
				else
					d.textForValue = textForPrimitiveValue
				end
				-- Add d to displayData table
				displayData[iRow] = d
				iRow = iRow + 1
				-- Add GameObj or array data for open drop-down buttons
				if isOpen and vt == "GameObj" then
					-- add GameObj data fields
					for j = 1, #gameObjFields do
						local gameObjField = gameObjFields[j]
						d = { var = var, field = gameObjField }
						if j <= numPublicGameObjFields then
							d.initRowTexts = { "." .. gameObjField, "" }
						else
							d.initRowTexts = { gameObjField, "" }
						end
						d.textIndents = indexOrFieldIndents
						d.textForValue = textForGameObjField
						displayData[iRow] = d
						iRow = iRow + 1
					end
				elseif isOpen and arrayType then
					-- add array indices
					if value then
						for j = 1, value.length do
							d = { var = var, index = j }
							d.initRowTexts = { "["..(j - 1).."]", "" }
							d.textIndents = indexOrFieldIndents
							if arrayType == "String" then
								d.textForValue = textForStringValue
							elseif arrayType == "GameObj" then
								d.textForValue = textForGameObjValue
								d.dropDownVisible = 2
							else
								d.textForValue = textForPrimitiveValue
							end
							displayData[iRow] = d
							iRow = iRow + 1
							if arrayType == "GameObj" and var[j.."isOpen"] then
								-- add GameObj fields for this open GameObj in array
								for k = 1, #gameObjFields do
									local gameObjField = gameObjFields[k]
									d = { var = var, index = j, field = gameObjField, }
									if k <= numPublicGameObjFields then
										d.initRowTexts = { "", "." .. gameObjField, "" }
									else
										d.initRowTexts = { "", gameObjField, "" }
									end
									d.textIndents = indexAndFieldIndents
									d.textForValue = textForGameObjField
									displayData[iRow] = d
									iRow = iRow + 1
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Adjust the scrollbar
local function adjustScrollbar()
	-- Adjust the scrollbar
	local numDisplayData = #displayData
	local numDisplayRows = #displayRows
	if numDisplayData > numDisplayRows then
		local rangeMax = math.max( 0, numDisplayData - numDisplayRows )
		local ratio = numDisplayRows / numDisplayData
		scrollbar:adjust( 0, rangeMax, scrollOffset, ratio )
	else
		scrollOffset = 0
		scrollbar:hide()
	end
	scrollbar:toFront()
end

-- Clears the variable watch window table of display rows
local function clearVarWatchTable()
	if varWatch.table then
		varWatch.table:removeSelf()
		varWatch.table = nil
	end
	displayRows = {}
	varWatch.table = g.makeGroup( varWatch.group )
end

-- Remakes the varWatch display rows using the given width and height
local function remakeDisplayRows()
	clearVarWatchTable()
	varWatch.addDisplayRows()
end

-- Event handler for variable drop down buttons on top-level variables
local function onDropDownBtn1( event )
	local btn = event.target
	displayData[btn.rowNumber + scrollOffset].var.isOpen = btn.isOn
	makeDisplayData()
	remakeDisplayRows()
	adjustScrollbar()
end

-- Event handler for variable drop down buttons on GameObjs in arrays
local function onDropDownBtn2( event )
	local btn = event.target
	local d = displayData[btn.rowNumber + scrollOffset]
	d.var[d.index.."isOpen"] = btn.isOn
	makeDisplayData()
	remakeDisplayRows()
	adjustScrollbar()
end

-- Update variable values displayed in the variable watch window
local function updateValues()
	if vars then
		for i = 1, #displayRows do
			local d = displayData[i + scrollOffset]
			if not d.isDivider then
				local index = d.index
				local field = d.field
				local var = d.var
				local value
				if var.isLocal then
					value = var.value
				else
					value = ct.userVars[codeGenJava.luaName( var.name )]
				end
				local textForValue = d.textForValue
				if index then
					if field then  -- Value of a GameObj field of a GameObj in an array
						displayRows[i][3].text = textForValue( value[index], field )
					else           -- Value of an indexed array
						local elementValue = value[index]
						if elementValue == nil then
							elementValue = value.default
						end 
						displayRows[i][2].text = textForValue( elementValue  )
					end
				elseif field then  -- Value of a field of a GameObj
					displayRows[i][2].text = textForValue( value, field )
				else               -- Value of a top-level variable
					displayRows[i][2].text = textForValue( value, var.arrayType )
				end
			end
		end
	end
end

-- Update the variable watch window if it is on in the user's settings
local function onNewFrame()
	if showVarWatch then
		-- Update local vars if they changed
		local localVarsNew = runtime.userLocals()
		if arrayAssigned or localVarsNew ~= localVars then
			-- save top row data if scrolled
			local topData
			if scrollOffset > 0 then
				topData = displayData[scrollOffset + 1]
			end
			if arrayAssigned then
				arrayAssigned = false
			else -- localVarsNew ~= localVars
				localVars = localVarsNew
				-- Update vars to include localVars
				getVars()
			end
			-- remake display data
			makeDisplayData()
			if topData then
				-- set scrollOffset to make the first row as close as we can to the prev first row before the change to displayData
				local topVarFound = false
				scrollOffset = 0
				for i = 1, #displayData do
					local d = displayData[i]
					if displayData[i].var == topData.var then
						topVarFound = true
						scrollOffset = i - 1
						if not topData.index and not topData.field or 
								topData.index and not topData.field and d.index and d.index == topData.index or
								not topData.index and topData.field and d.field and d.field == topData.field or
								d.index and d.index == topData.index and d.field and d.field == topData.field then
							break
						end
					elseif topVarFound then
						break
					end
				end
			end
			-- remake display rows
			remakeDisplayRows()
			adjustScrollbar()
		end
		if scrollOffsetChanged then
			remakeDisplayRows()
			scrollbar:toFront()
			scrollOffsetChanged = false
		end
		updateValues()
	end
end

-- Event handler for the variable watch window scrollbar
local function onScroll( newPos )
	local numDisplayData = #displayData
	local numDisplayRows = #displayRows
	if scrollOffset ~= newPos then
		scrollOffset = newPos
		scrollOffsetChanged = true
	end
	if newPos == 0 and numDisplayData <= numDisplayRows then
		scrollbar:hide()
	end
end


--- Module Functions ---------------------------------------------------------

-- Init the variable watch window
function varWatch.init()
	displayRows = {}
	displayData = {}
	numDisplayableRows = 0
	scrollOffset = 0
	charWidth = app.consoleFontCharWidth
	rowHeight = app.consoleFontHeight + 2
	dropDownBtnSize = rowHeight * 0.6
	dropDownBtnYOffset = (rowHeight - dropDownBtnSize) / 2
	stdIndents = { 0, dropDownBtnSize }
	indexOrFieldIndents = { dropDownBtnSize, dropDownBtnSize * 2 }
	indexAndFieldIndents = { 0, dropDownBtnSize * 3, dropDownBtnSize }

	maxGameObjFieldWidth = math.ceil( charWidth * string.len("clickable") )
	centerColWidth = dropDownBtnSize * 3 + maxGameObjFieldWidth + padding
	Runtime:addEventListener( "enterFrame", onNewFrame )
end

-- Create the variable watch window display group and store it in varWatch.group
function varWatch.create( parent, x, y, width, height )
	local group = g.makeGroup( parent, x, y )
	varWatch.group = group
	varWatch.table = g.makeGroup( group )
	varWatch.width = width
	varWatch.height = height
	-- Scrollbar
	scrollbar = Scrollbar:new( group, width - Scrollbar.width, 0, height, onScroll )
end

-- Adds rows to displayRows until the varWatch window is filled and return #displayRows
-- Assumes numDisplayableRows is up to date since last resize
function varWatch.addDisplayRows()
	local gridlineLength = 2000
	local n = #displayRows
	while n < numDisplayableRows do
		n = n + 1
		local iDisplay = n + scrollOffset
		local d = displayData[iDisplay]
		if not d then
			return n - 1		
		end
		local row = g.makeGroup( varWatch.table, 0, topMargin + (n - 1) * rowHeight )
		if d.isDivider then
			local dividerWidth = gridlineLength
			local dividerHeight = 3
			local dividerRect = display.newRect( row, xCols[1], rowHeight / 2, dividerWidth, dividerHeight )
			dividerRect:setFillColor( gridShade )
			dividerRect.anchorX = 0
		else
			local numColumns = #d.initRowTexts
			-- Make row text objs
			for colNum = 1, numColumns do
				g.uiBlack( display.newText{
					parent = row,
					text = d.initRowTexts[colNum],
					x = xCols[colNum] + d.textIndents[colNum],
					y = app.consoleFontYOffset,
					font = app.consoleFont,
					fontSize = app.consoleFontSize,
				} )
			end
			-- Make row gridlines
			local gridline
			local x1 = xCols[1]
			local y1 = rowHeight
			local nextData = displayData[iDisplay + 1]
			if nextData and not nextData.isDivider then
				-- make horizontal gridline on bottom of row
				gridline = display.newLine( row, x1, y1, x1 + gridlineLength, y1 )
				gridline:setStrokeColor( gridShade )
			end
			-- make vertical gridlines
			for i = 2, numColumns do
				x1 = xCols[i]
				gridline = display.newLine( row, x1, y1, x1, y1 - rowHeight )
				gridline:setStrokeColor( gridShade )
			end
			-- Make drop down button if needed
			if d.dropDownVisible then
				if d.dropDownVisible == 1 then
					local btn1 = buttons.newDropDownButton( row, row[2].x, dropDownBtnYOffset, dropDownBtnSize, dropDownBtnSize, onDropDownBtn1 )
					btn1.rowNumber = n
					btn1:setState{ isOn = d.var.isOpen or false }
					row.dropDownBtn1 = btn1
				else
					local btn2 = buttons.newDropDownButton( row, row[2].x, dropDownBtnYOffset, dropDownBtnSize, dropDownBtnSize, onDropDownBtn2 )
					btn2.rowNumber = n
					btn2:setState{ isOn = d.var[d.index.."isOpen"] or false }
					row.dropDownBtn2 = btn2
				end
			end
		end
		displayRows[n] = row
	end
	return n
end

-- Resize the variable watch window to fit the given size
function varWatch.resize( width, height )
	-- Determine the new number of display rows
	numDisplayableRows = math.floor( (height - topMargin) / rowHeight )
	if numDisplayableRows <= 0 then
		numDisplayableRows = 0
	end
	if showVarWatch then
		-- Make sure we have enough display rows
		local n = varWatch.addDisplayRows()
		-- Make sure we don't have too many display rows
		while n > numDisplayableRows do
			displayRows[n]:removeSelf( )
			displayRows[n] = nil
			n = n - 1
		end
		-- Reposition the scrollbar
		scrollbar:setPosition( width - Scrollbar.width, 0, height )
		adjustScrollbar()
	end
	if width < Scrollbar.width then
		scrollbar:hide()
	end
end

-- Starts a new run of the varWatch window based on the given width and height
function varWatch.startNewRun( width, height )
	clearVarWatchTable()
	getVars()
	makeDisplayData()
	scrollOffset = 0
	varWatch.resize( width, height )
end

-- Show the variable watch window if show, else hide it
function varWatch.setVisible( show )
	varWatch.group.isVisible = show
	showVarWatch = show
end

-- Handles runtime event of array assigned
function varWatch.arrayAssigned()
	arrayAssigned = true
end


------------------------------------------------------------------------------

return varWatch
