-----------------------------------------------------------------------------------------
--
-- console.lua
--
-- Implementation of the console window for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local app = require( "app" )
local Scrollbar = require( "Scrollbar" )


-- The console module
local console = {
	group = nil,             -- the console display group
	scrollbar = nil,         -- the console scrollbar (a Scrollbar)
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
local scrollStartLine        -- starting line if scrolled back or nil if at end
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

		-- Use scrollStartLine if any, otherwise use scroll position 
		-- so that the end is showing.
		local lastStartLine = math.max( numLines - numDisplayLines + 1, 1 )
		local startLine = scrollStartLine or lastStartLine
		local ratio = numDisplayLines / numLines
		console.scrollbar:adjust( 1, lastStartLine, startLine, ratio )

		-- Assemble the text and update the text object
		local endLine = math.min( startLine + numDisplayLines, numLines )
		textObj.text = table.concat( lines, "\n", startLine, endLine )

		-- Take the current line back out if we added it
		if #currentLineStrings > 0 then
			lines[numLines] = nil
		end

		-- Done until the next change
		changed = false
	end
end

-- Scroll callback for the console scrollbar
local function onScroll( newPos )
	scrollStartLine = newPos
	changed = true
end

-- Add raw text to the console. The text should not contain any newlines.
local function addText( text )
	-- Ignore this if the current line is really long and will clip anyway
	if text and currentLineLength < maxLineLength then
		currentLineStrings[#currentLineStrings + 1] = text
		currentLineLength = currentLineLength + string.len( text )
		changed = true
	end
end

-- End the current line in the console
local function endLine()
	if #currentLineStrings > 0 then	
		completedLines[#completedLines + 1] = table.concat( currentLineStrings )
		currentLineStrings = {}
	else
		completedLines[#completedLines + 1] = ""
	end
	currentLineLength = 0
	changed = true
end


--- Module Functions ---------------------------------------------------------

-- Print text to the console
function console.print( text )
	addText( text )
end

-- Print text plus a newline to the console
function console.println( text )
	addText( text )
	endLine()
end

-- Clear the console data and view
function console.clear()
	completedLines = {}
	currentLineStrings = {}
	currentLineLength = 0
	scrollStartLine = nil
	changed = true
end

-- Resize the console to fit the given size
function console.resize( width, height )
	bg.width = width
	bg.height = height
	console.scrollbar:setPosition( width - Scrollbar.width, 0, height )
	numDisplayLines = math.floor( (height - textMargin ) / fontHeight )
	changed = true
end

-- Create the console display group and store it in console.group
function console.create( parent, x, y, width, height )
	local group = app.makeGroup( parent, x, y )
	console.group = group

	-- White background and multi-line text box
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

	-- Scrollbar
	console.scrollbar = Scrollbar:new( group, width - Scrollbar.width, 0, 
								height, onScroll )
	console.scrollbar:adjust( 0, 100, 10, 25 )
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

