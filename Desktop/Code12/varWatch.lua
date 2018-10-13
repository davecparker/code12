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
local varWatch = {}


-- UI constants
local rowHeight = 20          -- height of each row
local font = app.consoleFont
local fontSize = app.consoleFontSize
local margin = app.margin
local centerColWidth = 100

-- Display state
local displayRows             -- table of rows of 2 or 3 text display objects
local varsTableGroup
local displayData = {}

-- varWatch data
local vars         			 -- array of user program's global variables
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
		for i = 1, #displayData do
			local d = displayData[i]
			local varName = d.varName
			local value = ct.userVars[varName]
			if not d.index and not d.field then
				local valueStr
				if d.varType == "primitive" then
					valueStr = tostring(value)
				elseif d.varType == "String" then
					valueStr = value or "null"
				elseif d.varType == "GameObj" then
					if value then
						valueStr = value._code12.typeName
					else
						valueStr = "null"
					end
					if d.valueStr == valueStr then
						-- don't need to update display text
						valueStr = nil
					else
						d.valueStr = valueStr
					end
				elseif d.varType == "array" then
					if value then
						if value.length == d.length then
							-- don't need to update display text
						elseif d.var.isOpen then
							-- length of array changed while display was open
							varWatch.makeVarsTable()
							return nil
						else
							valueStr = d.typeName .. "[".. value.length .. "]"
						end
					else
						valueStr = d.typeName .. "[]"
						if d.valueStr == valueStr then
							-- don't need to update display text
							valueStr = nil
						else
							-- array was set equal to an uninitiallize array while display was open
							varWatch.makeVarsTable()
							return nil
						end
					end
				end
				if valueStr then
					displayRows[i][2].text = valueStr
				end
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

-- Make the display data and text object tables
function varWatch.makeVarsTable()
	-- make varsTableGroup
	if varsTableGroup then
		varsTableGroup:removeSelf()
		varsTableGroup = nil
		displayRows = nil
	end
	varsTableGroup = g.makeGroup( varWatch.group )
	-- make displayData
	displayData = {}
	local iRow = 1
	if vars then
		for i = 1, #vars do
			local var = vars[i]
			local vt = var.vt
			local varName = var.nameID.str
			local value = ct.userVars[varName]
			local d = {}
			d.var = var
			d.varName = varName
			if vt == 0 or vt == 1 or vt == true then
				d.varType = "primitive"
			elseif vt == "String" then
				d.varType = vt
			elseif vt == "GameObj" then
				d.varType = vt
				if value then
					d.valueStr = value._code12.typeName
				else
					d.valueStr = "null"
				end
			elseif type(vt) == "table" then
				d.varType = "array"
				d.typeName = mapVtToTypeName[vt.vt]
				if value then
					d.length = value.length
					d.valueStr = d.typeName .. "[" .. d.length .. "]"
				else
					d.length = -1
					d.valueStr = d.typeName .. "[]"
				end
			end
			displayData[iRow] = d
			iRow = iRow + 1
			if var.isOpen and type(value) == "table" then
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
		-- make displayRows
		displayRows = {}
		for i = 1, #displayData do
			local d = displayData[i]
			local row = {}
			local rowTexts
			if not d.index and not d.field then
				rowTexts = { d.varName, d.valueStr or "", "" }
			elseif not d.index and d.field then
				rowTexts = { d.field, "", "" }
			elseif d.index and not d.field then
				rowTexts = { " [" .. d.index .. "]", "", "" }
			else
				-- d.field and d.index
				rowTexts = { " [".. d.index .. "]", " " .. d.field, "" }
			end
			local yRow = (i - 1) * rowHeight
			for col = 1, 3 do
				row[col] = g.uiBlack ( display.newText{
					parent = varsTableGroup,
					text = rowTexts[col],
					x = 0,
					y = yRow,
					font = font,
					fontSize = fontSize,
				} )
			end
			displayRows[i] = row
		end
		-- Determine width of first column
		local maxWidth = 0
		for i = 1, #displayRows do
			local width = displayRows[i][1].width
			if maxWidth < width then
				maxWidth = width
			end
		end
		-- Position columns 2 and 3 horizontally
		local xCol2 = maxWidth + margin
		local xCol3 = xCol2 + centerColWidth
		for i = 1, #displayRows do
			local row = displayRows[i]
			row[2].x = xCol2
			row[3].x = xCol3
		end
	end
end


------------------------------------------------------------------------------

return varWatch
