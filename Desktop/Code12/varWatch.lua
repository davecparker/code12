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
local textObjRows             -- table of rows of the variable display
local numDisplayRows          -- number of rows currently displayed
local xCols                   -- table of x-values for the left of each column
local charWidth               -- character width of the font used for text objects
local varWatchHeight          -- current height of the variable watch window

-- varWatch data
local vars                   -- array of user program's global variables
local displayData            -- array of data for displaying variables
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
	if vars and (g.runState == "running" or g.runState == "paused") then
		for i = 1, numDisplayRows do
			local d = displayData[i]
			if not d then
				break
				-- TODO: Handle changes to vars mid update?
			end
			local row = textObjRows[i]
			local var = d.var
			local varType = var.varType
			local typeName = var.typeName
			local varName = var.varName
			local value = ct.userVars[varName]
			if not value then
				row.dropDownBtn1.isVisible = false
				var.wasNull = true
				if var.isOpen then
					-- Open GameObj became nil
					var.isOpen = false
					varWatch.reset( varWatchHeight )
				elseif typeName then
					row[2].text = typeName.."[]"
				else
					row[2].text = "null"
				end
			elseif not d.index and not d.field then
				-- Value of a top-level variable
				if varType == "String" then
					row[2].text = value
				elseif varType == "GameObj" then
					-- row[2].text = value._code12.typeName
					row[2].text = value:toString()
					if var.wasNull then
						row.dropDownBtn1.isVisible = true
					end
				elseif varType == "array" then
					local prevLength = var.length
					local length = value.length
					var.length = length
					if not prevLength then
						-- Uninitialized array was initialized
						row.dropDownBtn1.isVisible = true
					elseif prevLength ~= length and var.isOpen then
						-- Open array was set equal to an array of different size
						varWatch.reset( varWatchHeight )
						return nil
					end
					row[2].text = typeName.."["..length.."]"
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
					if typeName == "int" or typeName == "double" then
						row[2].text = " 0"
					elseif typeName == "boolean" then
						row[2].text = " false"
					else
						if typeName == "GameObj" then
							if var[d.index.."isOpen"] then
								-- Open GameObj in array was set to null
								var[d.index.."isOpen"] = false
								varWatch.reset( varWatchHeight )
								return nil
							end
							var[d.index.."wasNull"] = true
							row.dropDownBtn2:setState{ isOn = false }
							row.dropDownBtn2.isVisible = false
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
	displayData[btn.rowNumber].var.isOpen = btn.isOn
	varWatch.reset( varWatchHeight )
end

-- Event handler for variable drop down buttons in the second column
local function onDropDownBtn2( event )
	local btn = event.target
	local d = displayData[btn.rowNumber]
	d.var[d.index.."isOpen"] = btn.isOn
	varWatch.reset( varWatchHeight )
end 

--- Module Functions ---------------------------------------------------------

-- Init the variable watch window
function varWatch.init()
	textObjRows = {}
	displayData = {}
	numDisplayRows = 0
	charWidth = app.consoleFontCharWidth
	Runtime:addEventListener( "enterFrame", updateValues )
end

-- Create the variable watch window display group and store it in varWatch.group
function varWatch.create( parent, x, y )
	varWatch.group = g.makeGroup( parent, x, y )
end

-- Fill the vars array with the user program's global variables
function varWatch.getVars()
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
			elseif type(vt) == "table" then
				var.varType = "array"
				var.typeName = mapVtToTypeName[vt.vt]
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
			d.initRowTexts = { varName, "", "" }
			d.rowAligns = { "left", "left", nil }
			if varType == "GameObj" or varType == "array" then
				d.dropDownVisible = 1
			end
			displayData[iRow] = d
			iRow = iRow + 1
			if isOpen and varType == "GameObj" then
				-- add GameObj data fields
				for j = 1, numGameObjFields do
					local gameObjField = gameObjFields[j]
					d = { var = var, field = gameObjField }
					d.initRowTexts = { " "..gameObjField, "", "" }
					d.rowAligns = { "center", "center", nil }
					displayData[iRow] = d
					iRow = iRow + 1
				end
			elseif isOpen and varType == "array" then
				local typeName = var.typeName
				-- add array indices
				local len = value.length
				for j = 1, len do
					d = { var = var, index = j }
					d.initRowTexts = { " ["..j.."]", "", "" }
					d.rowAligns = { "center", "left", nil }
					if typeName == "GameObj" then 
						d.dropDownVisible = 2
					end
					displayData[iRow] = d
					iRow = iRow + 1
					if typeName == "GameObj" and var[d.index.."isOpen"] then
						for k = 1, numGameObjFields do
							local gameObjField = gameObjFields[k]
							d = { var = var, index = j, field = gameObjField }
							d.initRowTexts = { "", "  "..gameObjField, "" }
							d.rowAligns = { "left", "center", "center" }
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
			for col = 1, 3 do
				g.uiBlack( display.newText{
					parent = row,
					text = d.initRowTexts[col],
					x = xCols[col],
					y = 0,
					font = app.consoleFont,
					fontSize = app.consoleFontSize,
				} )
			end
			-- make drop down buttons for first and second columns
			local yBtn = row[1].y + row[1].height / 2
			local btn1 = buttons.newDropDownButton( row, 0, yBtn, dropDownBtnSize, dropDownBtnSize, onDropDownBtn1 )
			btn1.rowNumber = n
			row.dropDownBtn1 = btn1
			local btn2 = buttons.newDropDownButton( row, row[2].x + dropDownBtnSize, yBtn, dropDownBtnSize, dropDownBtnSize, 
			                                        onDropDownBtn2 )
			btn2.rowNumber = n
			row.dropDownBtn2 = btn2
			textObjRows[n] = row
			-- hide/show the buttons depending on the type of variable tracked in the textObjs
			local var = d.var
			if not d.dropDownVisible then
				btn1.isVisible = false
				btn2.isVisible = false
			elseif d.dropDownVisible == 1 then
				btn1:setState{ isOn = var.isOpen or false }
				btn1.isVisible = true
				btn2.isVisible = false
			elseif d.dropDownVisible == 2 then
				btn2:setState{ isOn = var[d.index.."isOpen"] or false }
				btn1.isVisible = false				
				btn2.isVisible = true
			end
		end
		if n > prevNumDisplayRows then
			-- Show rows in output area previously hidden
			for i = prevNumDisplayRows + 1, numDisplayRows do
				textObjRows[i].isVisible = true
			end
		end
	elseif prevNumDisplayRows > numDisplayRows and n > numDisplayRows then
		-- Hide any rows below the output area
		for i = numDisplayRows + 1, prevNumDisplayRows do
			textObjRows[i].isVisible = false
		end
	end
	varWatchHeight = height
end

-- Remakes the varWatch window after getting new display data
function varWatch.reset( height )
	for i = #textObjRows, 1, -1 do
		textObjRows[i]:removeSelf()
		textObjRows[i] = nil
	end
	varWatch.makeDisplayData()
	numDisplayRows = 0
	varWatch.resize( height )
end

-- Starts a new run of the varWatch window based on the given height
function varWatch.startNewRun( height )
	varWatch.getVars()
	varWatch.reset( height )
end

------------------------------------------------------------------------------

return varWatch
