-----------------------------------------------------------------------------------------
--
-- varWatch.lua
--
-- Implementation of the variable watch window for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 app modules
local g = require( "Code12.globals" )
local ct = require( "Code12.ct" )
local app = require( "app" )
local checkJava = require( "checkJava" )
local buttons = require( "buttons" )
local Scrollbar = require( "Scrollbar" )


-- The varWatch module
local varWatch = {
	group = nil,              -- the varWatch display group
}

-- UI constants
local topMargin = 5           -- margin for the top of the variable watch window
local rowHeight = 20          -- height of each row in the variable display
local dropDownBtnSize = 10    -- width and height of the drop down buttons
local trackVarBtnWidth = 10   -- width of the track variable buttons
local margin = app.margin     -- space between UI elements
local centerColWidth = 125    -- width of the center column of the variable display
local xCol1 = trackVarBtnWidth + dropDownBtnSize + margin -- x-value for the first column of text objects

-- Display state
local textObjRows             -- table of rows of the variable display
local numDisplayRows          -- number of rows that can currently be displayed
local numRowsToUpdate         -- number of text obj rows that need to be updated
local xCols                   -- table of x-values for the left of each column
local charWidth               -- character width of the font used for text objects
local showVarWatch            -- curent value of app.showVarWatch

-- varWatch data
local vars                    -- array of user program's global variables
local displayData             -- array of data for displaying variables
local scrollOffset = 0        -- starting line if scrolled back or nil if at end
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

-- Update column widths
local function updateColWidths()
	-- update text obj and button positions
	local xCol2 = xCols[2]
	local xCol3 = xCols[3]
	for i = 1, #textObjRows do
		local row = textObjRows[i]
		row[2].x = xCol2
		row.dropDownBtn2.x = xCol2
		row[3].x = xCol3
	end
end

-- Update variable names, array indices, GameObj fields, and buttons
-- in the variable watch window
local function updateConstants( iTextObjRowStart, iTextObjRowEnd )
	-- Adjust the scrollbar
	local numDisplayData = #displayData
	if numDisplayData > numDisplayRows then
		local rangeMax = math.max( 1, numDisplayData - numDisplayRows )
		local ratio = numDisplayRows / numDisplayData
		varWatch.scrollbar:adjust( 0, rangeMax, scrollOffset, ratio )
	else
		scrollOffset = 0
		varWatch.scrollbar:hide()
	end
	-- Update text obj texts and visibility of rows and buttons
	for i = iTextObjRowStart, iTextObjRowEnd do
		local row = textObjRows[i]
		local d = displayData[i + scrollOffset]
		if d then
			row.isVisible = true
			for col = 1, 3 do
				row[col].text = d.initRowTexts[col]
			end
			local btn1 = row.dropDownBtn1
			local btn2 = row.dropDownBtn2
			if not d.dropDownVisible then
				btn1.isVisible = false
				btn2.isVisible = false
			elseif d.dropDownVisible == 1 then
				btn1:setState{ isOn = d.var.isOpen or false }
				btn1.isVisible = true
				btn2.isVisible = false
			elseif d.dropDownVisible == 2 then
				btn2:setState{ isOn = d.var[d.index.."isOpen"] or false }
				btn1.isVisible = false				
				btn2.isVisible = true
			end
		else
			row.isVisible = false
		end
	end
	for i = numDisplayRows + 1, iTextObjRowEnd do
		textObjRows[i].isVisible = false
	end
	-- Update numRowsToUpdate
	numRowsToUpdate = math.min( numDisplayRows, numDisplayData - scrollOffset )
end

-- Update variable values displayed in the variable watch window
local function updateValues()
	if vars and (g.runState == "running" or g.runState == "paused") then
		for i = 1, numRowsToUpdate do
			local d = displayData[i + scrollOffset]
			local row = textObjRows[i]
			local var = d.var
			local vt = var.vt
			local arrayType = var.arrayType
			local varName = var.nameID.str
			local value = ct.userVars[varName]
			if not value then
				row.dropDownBtn1.isVisible = false
				var.wasNull = true
				if var.isOpen then
					-- Open GameObj became nil
					var.isOpen = false
					if d.field then
						scrollOffset = var.iDisplayData - 1
					end
					varWatch.reset()
					return nil
				elseif arrayType then
					row[2].text = arrayType.."[]"
				else
					row[2].text = "null"
				end
			elseif not d.index and not d.field then
				-- Value of a top-level variable
				if vt == "String" then
					row[2].text = value
				elseif vt == "GameObj" then
					-- row[2].text = value._code12.typeName
					row[2].text = value:toString()
					if var.wasNull then
						row.dropDownBtn1.isVisible = true
					end
				elseif arrayType then
					local prevLength = var.length
					local length = value.length
					var.length = length
					if not prevLength then
						-- Uninitialized array was initialized
						row.dropDownBtn1.isVisible = true
					elseif prevLength ~= length and var.isOpen then
						-- Open array was set equal to an array of different size
						varWatch.reset()
						return nil
					end
					row[2].text = arrayType.."["..length.."]"
				else
					row[2].text = tostring(value)
				end
			elseif not d.index and d.field then
				-- Value of a field of a GameObj
				row[2].text = " "..tostring(value[d.field])
			elseif d.index and not d.field then
				-- Value of an indexed array
				local valueAtIndex = value[d.index]
				if not valueAtIndex then
					if arrayType == "int" or arrayType == "double" then
						row[2].text = " 0"
					elseif arrayType == "boolean" then
						row[2].text = " false"
					else
						if arrayType == "GameObj" then
							var[d.index.."wasNull"] = true
							if var[d.index.."isOpen"] then
								-- Open GameObj in array was set to null
								var[d.index.."isOpen"] = false
								varWatch.reset()
								return nil
							else
								row.dropDownBtn2:setState{ isOn = false }
								row.dropDownBtn2.isVisible = false
							end
						end
						row[2].text = " null"
					end
				elseif type(valueAtIndex) == "table" then
					-- valueAtIndex is a GameObj
					row[2].text = " "..valueAtIndex:toString()
					if var[d.index.."wasNull"] then
						var[d.index.."wasNull"] = false
						row.dropDownBtn2.isVisible = true
					end
				else
					row[2].text = tostring(valueAtIndex)
				end
			else
				-- d.index and d.field
				-- Value of a GameObj field of a GameObj in an array
				local valueAtIndex = value[d.index]
				if valueAtIndex then
					row[3].text = " "..tostring(valueAtIndex[d.field])
				else
					row[3].text = " null"
				end
			end
		end
	end
end

-- Event handler for variable drop down buttons in the first column
local function onDropDownBtn1( event )
	local btn = event.target
	displayData[btn.rowNumber + scrollOffset].var.isOpen = btn.isOn
	varWatch.reset()
end

-- Event handler for variable drop down buttons in the second column
local function onDropDownBtn2( event )
	local btn = event.target
	local d = displayData[btn.rowNumber + scrollOffset]
	d.var[d.index.."isOpen"] = btn.isOn
	varWatch.reset()
end

-- Event handler for the variable watch window scrollbar
local function onScroll( newPos )
	scrollOffset = newPos or #displayData - numDisplayRows
	updateConstants( 1, #textObjRows )
	updateValues()
end

-- Update the variable watch window if it is on in the user's settings
local function onNewFrame()
	if showVarWatch then
		updateValues()
	end
end

--- Module Functions ---------------------------------------------------------

-- Init the variable watch window
function varWatch.init()
	textObjRows = {}
	displayData = {}
	numDisplayRows = 0
	charWidth = app.consoleFontCharWidth
	Runtime:addEventListener( "enterFrame", onNewFrame )
end

-- Create the variable watch window display group and store it in varWatch.group
function varWatch.create( parent, x, y, width, height )
	local group = g.makeGroup( parent, x, y )
	varWatch.group = group
	varWatch.width = width
	varWatch.height = height

	-- Scrollbar
	varWatch.scrollbar = Scrollbar:new( group, width - Scrollbar.width, 0, height, onScroll )
	varWatch.scrollbar:adjust( 1, 100, 1, 0.1 )
end

-- Fill the vars array with the user program's global variables
function varWatch.getVars()
	vars = checkJava.globalVars()
	if vars then
		local maxVarNameWidth = 100 -- minimum width to ensure space for GameObj fields
		for i = 1, #vars do
			local var = vars[i]
			local varNameWidth = string.len( var.nameID.str ) * charWidth
			if maxVarNameWidth < varNameWidth then
				maxVarNameWidth = varNameWidth
			end
			local vt = var.vt
			if type(vt) == "table" then
				var.arrayType = mapVtToTypeName[vt.vt]
			end
		end
		local xCol2 = xCol1 + maxVarNameWidth + dropDownBtnSize + margin
		xCols = { xCol1, xCol2, xCol2 + centerColWidth }
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
			local vt = var.vt
			local arrayType = var.arrayType
			local varName = var.nameID.str
			local value = ct.userVars[varName]
			local d = {}
			d.var = var
			d.initRowTexts = { varName, "", "" }
			if vt == "GameObj" or arrayType then
				d.dropDownVisible = 1
			end
			var.iDisplayData = iRow
			displayData[iRow] = d
			iRow = iRow + 1
			if isOpen and vt == "GameObj" then
				if not value then
					var.isOpen = false
				else
					-- add GameObj data fields
					for j = 1, numGameObjFields do
						local gameObjField = gameObjFields[j]
						d = { var = var, field = gameObjField }
						d.initRowTexts = { " "..gameObjField, "", "" }
						displayData[iRow] = d
						iRow = iRow + 1
					end
				end
			elseif isOpen and arrayType then
				-- add array indices
				local len = value.length
				for j = 1, len do
					d = { var = var, index = j }
					d.initRowTexts = { " ["..(j - 1).."]", "", "" }
					if arrayType == "GameObj" then 
						d.dropDownVisible = 2
					end
					displayData[iRow] = d
					iRow = iRow + 1
					if arrayType == "GameObj" and var[j.."isOpen"] then
						if not value[j] then
							var[j.."isOpen"] = false
						else
							for k = 1, numGameObjFields do
								local gameObjField = gameObjFields[k]
								d = { var = var, index = j, field = gameObjField }
								d.initRowTexts = { "", "  "..gameObjField, "" }
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

-- Resize the variable watch window to fit the given size
function varWatch.resize( width, height )
	local prevNumDisplayRows = numDisplayRows
	-- Determine the new number of display rows
	numDisplayRows = math.floor( (height - topMargin) / rowHeight )
	if numDisplayRows <= 0 then
		numDisplayRows = 0
		for i = 1, prevNumDisplayRows do
			textObjRows[i].isVisible = false
		end
		return nil
	end
	-- Make sure we have enough text objects
	local n = #textObjRows
	while n < numDisplayRows do
		n = n + 1
		local row = g.makeGroup( varWatch.group, 0, topMargin + (n - 1) * rowHeight )
		for col = 1, 3 do
			g.uiBlack( display.newText{
				parent = row,
				text = "",
				x = xCol1 + 100 * ( col - 1 ),
				y = 0,
				font = app.consoleFont,
				fontSize = app.consoleFontSize,
		} )
		end
		-- make drop down buttons for first and second columns
		local yBtn = row[1].y + row[1].height / 2
		local btn1 = buttons.newDropDownButton( row, row[1].x, yBtn, dropDownBtnSize, dropDownBtnSize, onDropDownBtn1 )
		btn1.rowNumber = n
		row.dropDownBtn1 = btn1
		local btn2 = buttons.newDropDownButton( row, row[2].x + dropDownBtnSize, yBtn, dropDownBtnSize, dropDownBtnSize, 
		                                        onDropDownBtn2 )
		btn2.rowNumber = n
		row.dropDownBtn2 = btn2
		textObjRows[n] = row
	end
	-- Update display constants (variable names, buttons, etc)
	if prevNumDisplayRows < numDisplayRows then
		updateConstants( prevNumDisplayRows + 1, n )
	elseif prevNumDisplayRows > numDisplayRows then
		updateConstants( numDisplayRows, prevNumDisplayRows )
	end
	-- Reposition the scrollbar
	local scrollbar = varWatch.scrollbar
	scrollbar:setPosition( width - Scrollbar.width, 0, height )
	scrollbar:toFront()
end

-- Remakes the varWatch window after getting new display data
function varWatch.reset()
	varWatch.makeDisplayData()
	updateConstants( 1, #textObjRows )
	updateValues()
end

-- Starts a new run of the varWatch window based on the given width and height
function varWatch.startNewRun()
	showVarWatch = true
	varWatch.group.isVisible = true
	varWatch.getVars()
	updateColWidths()
	varWatch.reset()
end

function varWatch.hide()
	showVarWatch = false
	varWatch.group.isVisible = false
end

------------------------------------------------------------------------------

return varWatch
