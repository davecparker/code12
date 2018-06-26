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
local textObjs = {}          -- array of text display objects
local numDisplayLines = 0    -- number of lines we can display
local fontHeight             -- measured font height
local fontCharWidth          -- measured font char width

-- Console data
local completedLines         -- array of strings for completed text lines
local currentLineStrings     -- array of strings making up the current line
local currentLineLength      -- number of chars in current line
local scrollStartLine        -- starting line if scrolled back or nil if at end
local changed = false        -- true when contents have changed since last update 


--- Internal Functions ---------------------------------------------------------

-- Update the console if needed
local function onNewFrame()
	-- Do we need to update?
	if not changed then
		return
	end
	changed = false

	-- Determine number of lines we have to display
	local numCompletedLines = #completedLines
	local hasIncompleteLine = (#currentLineStrings > 0)
	local numLines = numCompletedLines
	if hasIncompleteLine then
		numLines = numLines + 1
	end

	-- Load text lines into the text objects
	local iText = 1
	if numLines == 0 then
		console.scrollbar:hide()
	else
		-- Use scrollStartLine if any, otherwise use the scroll position 
		-- that shows the end of the output.
		local lastStartLine = math.max( numLines - numDisplayLines + 1, 1 )
		local startLine = scrollStartLine or lastStartLine
		local ratio = numDisplayLines / numLines
		console.scrollbar:adjust( 1, lastStartLine, startLine, ratio )

		-- Load the completed lines
		local iLine = startLine
		while iText <= numDisplayLines and iLine <= numCompletedLines do
			textObjs[iText].text = completedLines[iLine]
			iText = iText + 1
			iLine = iLine + 1
		end

		-- Add the incomplete line if any
		if hasIncompleteLine and iText <= numDisplayLines then
			textObjs[iText].text = table.concat( currentLineStrings )
			iText = iText + 1
		end
	end

	-- Clear any remaining text objects
	while iText <= #textObjs do
		textObjs[iText].text = ""
		iText = iText + 1
	end
end

-- Scroll callback for the console scrollbar
local function onScroll( newPos )
	scrollStartLine = newPos
	changed = true
end

-- Add raw text to the console. The text should not contain any newlines.
local function addText( text )
	-- Ignore if the current line is really long and will clip anyway
	if currentLineLength < maxLineLength then
		currentLineStrings[#currentLineStrings + 1] = text
		currentLineLength = currentLineLength + string.len( text )
		changed = true
	end
end

-- End the current line in the console
local function endLine()
	local n = #currentLineStrings
	if n == 1 then
		completedLines[#completedLines + 1] = currentLineStrings[1]
		currentLineStrings[1] = nil
	elseif n == 0 then	
		completedLines[#completedLines + 1] = ""
	else
		completedLines[#completedLines + 1] = table.concat( currentLineStrings )
		currentLineStrings = {}
	end
	currentLineLength = 0
	changed = true
end

-- Handle touch events on the console
local function onTouchConsole( event )
	return true
end


--- Module Functions ---------------------------------------------------------

-- Print text to the console
function console.print( text )
	if text then
		-- Check for newlines and break up if necessary
		local iNewline = string.find( text, "\n", 1, true )
		if iNewline == nil then
			addText( text )
		else
			local iStart = 1
			repeat
				if iNewline > iStart then
					console.println( string.sub( text, iStart, iNewline - 1 ) )
				else
					endLine()  -- blank line 
				end
				iStart = iNewline + 1   -- pass the newline
				iNewline = string.find( text, "\n", iStart, true )
			until iNewline == nil	
			addText( string.sub( text, iStart ) )  -- last incomplete line if any
		end
	end
end

-- Print text plus a newline to the console
function console.println( text )		
	console.print( text )
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

-- Input a string from the console and return the string. 
-- This call will effectively block until the input is received, although
-- it will yield to the caller of the runtime coroutine while waiting.
function console.inputString()
end

-- Resize the console to fit the given size
function console.resize( width, height )
	-- Size the background rect
	bg.width = width
	bg.height = height

	-- Determine number of display lines and adjust the scrollbar
	numDisplayLines = math.floor( (height - textMargin ) / fontHeight )
	console.scrollbar:setPosition( width - Scrollbar.width, 0, height )

	-- Make sure we have enough text objects
	local n = #textObjs 
	while n < numDisplayLines do
		n = n + 1
		textObjs[n] = app.uiBlack ( display.newText{
			parent = console.group,
			text = "",
			x = textMargin,
			y = textMargin + (n - 1) * fontHeight,
			font = app.consoleFont,
			fontSize = app.consoleFontSize,
			align = "left",
		} )
	end
	console.scrollbar:toFront()
	changed = true  -- may need to display additional lines
end

-- Create the console display group and store it in console.group
function console.create( parent, x, y, width, height )
	local group = app.makeGroup( parent, x, y )
	console.group = group

	-- White background
	bg = app.uiWhite( display.newRect( group, 0, 0, width, height ) )
	bg:addEventListener( "touch", onTouchConsole )

	-- Scrollbar
	console.scrollbar = Scrollbar:new( group, width - Scrollbar.width, 0, height, onScroll )
	console.scrollbar:adjust( 0, 100, 10, 25 )

	-- Set the initial size
	console.resize( width, height )
end

-- Init the console
function console.init()
	-- Get actual font metrics by measuring a text object (font metrics seem unreliable)
	local str = "1234567890"
	local temp = display.newText( str, 0, 0, app.consoleFont, app.consoleFontSize )
	fontCharWidth = temp.contentWidth / string.len( str )
	fontHeight = math.ceil( temp.contentHeight )   -- try to keep text pixel-aligned
	temp:removeSelf()
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
