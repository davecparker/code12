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
local GameObj = require("Code12.GameObjAPI")


-- The varWatch module
local varWatch = {
	group = nil,              -- the varWatch display group
}

-- UI constants
local rowHeight = 20          -- height of each row in the variable display
local margin = app.margin     -- space between UI elements
local centerColWidth = 125    -- width of the center column of the variable display

-- Display state
local textObjRows = {}        -- table of rows of the variable display
local numDisplayRows = 0      -- number of rows currently displayed
local xCols                   -- table of x-values for the left of each column

-- varWatch data
local vars         			 -- array of user program's global variables
local displayData = {}       -- array of data for displaying variables
local gameObjFields = { "x", "y", "width", "height", "xSpeed", "ySpeed", 
                        "lineWidth", "visible", "clickable", "autoDelete", "group" }
local numGameObjFields = #gameObjFields

--- Internal Functions ---------------------------------------------------------

local mapVtToTypeName = {
	[0]          = "int",
	[1]          = "double",
	[true]       = "boolean",
	["String"]   = "String",
	["GameObj"]  = "GameObj",
}

local function updateValues()
	if vars and ct.userVars then
		for i = 1, numDisplayRows do
			local d = displayData[i]
			local varName = d.varName
			local value = ct.userVars[varName]
			if not d.index and not d.field then
				local valueStr
				if value == nil then
					if d.typeName then
						valueStr = d.typeName .. "[]"
					else
						valueStr = "null"
					end
				elseif d.varType == "String" then
					valueStr = value
				elseif d.varType == "GameObj" then
					-- valueStr = value._code12.typeName
					valueStr = value:toString()
				elseif d.varType == "array" then
					-- TODO: Remake variable display if length of array changes while open
					valueStr = d.typeName .. "[".. value.length .. "]"
				else
					valueStr = tostring(value)
				end
				textObjRows[i][2].text = valueStr
			elseif not d.index and d.field then
				-- TODO
			elseif d.index and not d.field then
				-- TODO
			elseif not d.field then
				-- TODO
			else
				-- d.index and d.field
				-- TODO
			end
		end
	end
end

local function resetTextObjs()
	if #textObjRows > #displayData then
		for i = #displayData + 1, #textObjRows do
			textObjRows[i]:removeSelf( )
			textObjRows[i] = nil
		end
	end
	for i = 1, #textObjRows do
		local row = textObjRows[i]
		row[1].text = displayData[i].initRowTexts[1]
		if xCols then
			for col = 2, 3 do
				row[col].x = xCols[col]
			end
		end
	end
 end

--- Module Functions ---------------------------------------------------------

-- Init the variable watch window
function varWatch.init()
	Runtime:addEventListener( "enterFrame", updateValues )
end

-- Create the variable watch window display group and store it in varWatch.group
function varWatch.create( parent, x, y )
	local group = g.makeGroup( parent, x, y )
	varWatch.group = group
end

-- Fill the vars array with the user program's global variables
function varWatch.getVars()
	vars = checkJava.globalVars()
end

-- Fill the displayData array with data for displaying the user program's global variables
function varWatch.makeDisplayData()
	displayData = {}
	if vars then
		local charWidth = app.consoleFontCharWidth
		local maxVarNameWidth = 0
		local iRow = 1
		for i = 1, #vars do
			local var = vars[i]
			local vt = var.vt
			local varName = var.nameID.str
			local varNameWidth = string.len( varName ) * charWidth
			if maxVarNameWidth < varNameWidth then
				maxVarNameWidth = varNameWidth
			end
			local value = ct.userVars[varName]
			local d = {}
			d.var = var
			d.varName = varName
			d.initRowTexts = { varName, "", "" }
			if vt == 0 or vt == 1 or vt == true then
				d.varType = "primitive"
			elseif vt == "String" or vt == "GameObj" then
				d.varType = vt
			elseif type(vt) == "table" then
				d.varType = "array"
				d.typeName = mapVtToTypeName[vt.vt]
			end
			displayData[iRow] = d
			iRow = iRow + 1
			if var.isOpen and d.varType == "GameObj" then
				-- add GameObj data fields / array elements
				if d.varType == "GameObj" then
					for j = 1, numGameObjFields do
						displayData[iRow] = { var = var, field = gameObjFields[j] }
						iRow = iRow + 1
					end
				elseif d.varType == "array" then
					local n = value.length
					for j = 1, n do
						displayData[iRow] = { var = var, index = j }
						iRow = iRow + 1
						if GameObj:isGameObj( value[j] ) and value[j].isOpen then
							for k = 1, numGameObjFields do
								displayData[iRow] = { var = var, index = j, field = gameObjFields[k] }
								iRow = iRow + 1
							end
						end
					end
				end
			end
		end
		xCols = { 0, maxVarNameWidth + margin, maxVarNameWidth + margin + centerColWidth }
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
			textObjRows[n] = g.makeGroup( varWatch.group, 0, (n - 1) * rowHeight )
			for col = 1, 3 do
				g.uiBlack ( display.newText{
					parent = textObjRows[n],
					text = displayData[n].initRowTexts[col],
					x = xCols[col],
					-- y = (n - 1) * rowHeight,
					y = 0,
					font = app.consoleFont,
					fontSize = app.consoleFontSize,
					align = "left",
				} )
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
end

function varWatch.startNewRun( height )
	varWatch.getVars()
	varWatch.makeDisplayData()
	varWatch.resize( height )
	resetTextObjs()
end

------------------------------------------------------------------------------

return varWatch
