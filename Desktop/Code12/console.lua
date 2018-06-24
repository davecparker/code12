-----------------------------------------------------------------------------------------
--
-- console.lua
--
-- Implementation of the console window for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- App globals
local app = require( "app" )


-- The console module
local console = {
	group = nil,             -- the console display group
}

-- Layout metrics
local textMargin = 5         -- margin for text items
local maxLineLength = 500    -- max line length (since we clip and don't wrap)

-- Display state
local bg                     -- background rect
local textObj                -- text display object
local fontHeight             -- measured font height
local fontCharWidth          -- measured font char width
local numDisplayLines        -- number of lines we can display

-- Console data
local completedLines         -- array of strings for completed text lines
local currentLineStrings     -- array of strings making up the current line
local currentLineLength      -- number of chars in current line
local changed = false        -- true when contents have changed since last update 


--- Internal Functions ---------------------------------------------------------

-- Update the console if needed
local function onNewFrame()
	-- Do we need to update and is the display ready?
	if changed and textObj and numDisplayLines then
		local lines = completedLines
		local numLines = #lines

		-- Add the current line if any
		if #currentLineStrings > 0 then
			numLines = numLines + 1
			lines[numLines] = table.concat( currentLineStrings )
		end

		-- Find scroll position so that the end is showing
		local start = 1
		if numLines > numDisplayLines then
			start = numLines - numDisplayLines + 1
		end

		-- Assemble the text and update the text object
		textObj.text = table.concat( lines, "\n", start )

		-- Take the current line back out if we added it
		if #currentLineStrings > 0 then
			lines[numLines] = nil
		end

		-- Done until the next change
		changed = false
	end
end


--- Module Functions ---------------------------------------------------------

-- Add text to the last line in the console
function console.print( text )
	-- Ignore this if the current line is really long and will clip anyway
	if text and currentLineLength < maxLineLength then
		currentLineStrings[#currentLineStrings + 1] = text
		currentLineLength = currentLineLength + string.len( text )
		changed = true
	else
		print("console.print ignored")
	end
end

-- Print a line to the console
function console.println( text )
	-- Is there a line in progress to complete?
	if #currentLineStrings > 0 then	
		console.print( text )
		completedLines[#completedLines + 1] = table.concat( currentLineStrings )
		currentLineStrings = {}
		currentLineLength = 0
	else
		completedLines[#completedLines + 1] = text
	end
	changed = true
end

-- Clear the console data and view
function console.clear()
	completedLines = {}
	currentLineStrings = {}
	currentLineLength = 0
	changed = true
end

-- Resize the console to fit the given size
function console.resize( width, height )
	bg.width = width
	bg.height = height
	numDisplayLines = math.floor( (height - textMargin ) / fontHeight )
	changed = true
end

-- Create the console display group and store it in console.group
function console.create( parent, x, y, width, height )
	local group = app.makeGroup( parent, x, y )
	bg = app.uiItem( display.newRect( group, 0, 0, width, height ), 1, app.borderShade )
	textObj = app.uiBlack ( display.newText{
		parent = group,
		text = "",
		x = textMargin,
		y = textMargin,
		-- width = ui.width - textMargin * 2,   -- no wrapping for now
		font = app.consoleFont,
		fontSize = app.consoleFontSize,
		align = "left",
	} )
	console.group = group
end

-- Init the console
function console.init()
	-- Get actual font metrics by measuring text objects
	local str1 = "1234567890"
	local str2 = "1\n2"
	local str10 = "1\n2\n3\n4\n5\n6\n7\n8\n9\n0"
	local temp1 = display.newText( str1, 0, 0, 
						app.consoleFont, app.consoleFontSize )
	fontCharWidth = temp1.contentWidth / string.len( str1 )
	local temp2 = display.newText( str2, 0, 0, 1000, 0, 
						app.consoleFont, app.consoleFontSize )
	local temp10 = display.newText( str10, 0, 0, 1000, 0, 
						app.consoleFont, app.consoleFontSize )
	fontHeight = (temp10.contentHeight - temp2.contentHeight) / 8
	temp1:removeSelf()
	temp2:removeSelf()
	temp10:removeSelf()

	-- TODO
	app.consoleFontCharWidth = fontCharWidth
	app.consoleFontHeight = fontHeight

	-- Start out empty
	console.clear()
	changed = false

	-- Update the console as needed up to once per frame
	Runtime:addEventListener( "enterFrame", onNewFrame )
end


------------------------------------------------------------------------------
return console

