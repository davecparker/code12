-----------------------------------------------------------------------------------------
--
-- console.lua
--
-- Implementation of the console window for the Code 12 Desktop app
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local g = require( "Code12.globals" )
local app = require( "app" )
local Scrollbar = require( "Scrollbar" )


-- The console module
local console = {}

-- UI constants
local textMargin = 5                 -- margin for text items
local maxLineLength = 500            -- max line length to allow
local rgbTextDefault = { 0, 0, 0 }   -- default text color is black

-- Computed metrics
local fontHeight             -- measured font height
local fontCharWidth          -- measured font char width

-- Display objects
local consoleGroup           -- display group for the console
local textGroup              -- display group for text lines within consoleGroup
local scrollbarV             -- vertical scrollbar
local scrollbarH             -- horizontal scrollbar
local bg                     -- background rect
local textObjs = {}          -- array of text display objects

-- Console data
local completedLines         -- array of strings for completed text lines
local rgbForLine             -- map line number to color to use (rgb 3-array) if any
local currentLineStrings     -- array of strings making up the current line
local currentLineLength      -- number of chars in current line
local longestLineLength      -- number of chars in longest line

-- Console display state
local numDisplayLines        -- number of text lines we can display 
local scrollStartLine        -- starting line if scrolled back or nil if at end
local changed = false        -- true when contents have changed since last update
local resized = false        -- true if update needs to consider text area resize 


--- Internal Functions ---------------------------------------------------------

-- Update the console as necessary
local function updateConsole()
	-- Determine number of data lines we have to display
	local numCompletedLines = #completedLines
	local numLines = numCompletedLines
	local hasIncompleteLine = (#currentLineStrings > 0)
	if hasIncompleteLine then
		numLines = numLines + 1
	end

	-- Load text lines into the text objects and adjust scrollbars
	local iText = 1
	if numLines == 0 then
		numDisplayLines = 0
	else
		-- Check horizontal scroll state if needed
		if resized then
			local dyLongestLine = longestLineLength * fontCharWidth + textMargin * 2
			local textWidth = bg.width - Scrollbar.width
			local textHeight = bg.height
			if dyLongestLine <= textWidth then
				scrollbarH:hide()
				textGroup.x = 0
			else
				textGroup.x = -scrollbarH:adjust( 0, dyLongestLine - textWidth, 
						-textGroup.x, textWidth / dyLongestLine )
				textHeight = textHeight - Scrollbar.width
				scrollbarH:setPosition( 0, textHeight, textWidth )
			end
			scrollbarV:setPosition( textWidth, 0, textHeight )
			numDisplayLines = math.floor( (textHeight - textMargin ) / fontHeight )
		end

		-- Make sure we have enough text objects
		local n = #textObjs 
		while n < numDisplayLines do
			n = n + 1
			textObjs[n] = g.uiBlack ( display.newText{
				parent = textGroup,
				text = "",
				x = textMargin,
				y = textMargin + (n - 1) * fontHeight,
				font = app.consoleFont,
				fontSize = app.consoleFontSize,
				align = "left",
			} )
		end

		-- Use scrollStartLine if any, otherwise use the vertical scroll position 
		-- that shows the end of the output.
		local lastStartLine = math.max( numLines - numDisplayLines + 1, 1 )
		local startLine = scrollStartLine or lastStartLine
		local ratio = numDisplayLines / numLines
		scrollbarV:adjust( 1, lastStartLine, startLine, ratio )

		-- Load the completed lines
		local iLine = startLine
		while iText <= numDisplayLines and iLine <= numCompletedLines do
			local textObj = textObjs[iText]
			textObj.text = completedLines[iLine]
			local rgb = rgbForLine[iLine] or rgbTextDefault
			textObj:setFillColor( rgb[1], rgb[2], rgb[3] )
			iText = iText + 1
			iLine = iLine + 1
		end

		-- Add the incomplete line if any
		if hasIncompleteLine and iText <= numDisplayLines then
			local textObj = textObjs[iText]
			textObj.text = table.concat( currentLineStrings )
			local rgb = rgbTextDefault
			textObj:setFillColor( rgb[1], rgb[2], rgb[3] )
			iText = iText + 1
		end
	end

	-- Clear any remaining text objects
	while iText <= #textObjs do
		textObjs[iText].text = ""
		iText = iText + 1
	end
end

-- Update the console if needed
local function onNewFrame()
	if changed and consoleGroup then
		updateConsole()
		changed = false
		resized = false
	end
end

-- Scroll callback for the vertical scrollbar
local function onScrollVert( newPos )
	if scrollbarV:atRangeMax() then
		scrollStartLine = nil
	else
		scrollStartLine = newPos
	end
	changed = true
end

-- Scroll callback for the horizontal scrollbar
local function onScrollHorz( newPos )
	textGroup.x = -newPos
end

-- Add raw text to the console. The text should not contain any newlines.
local function addText( text )
	-- Ignore if the current line is really long
	if currentLineLength < maxLineLength then
		currentLineStrings[#currentLineStrings + 1] = text
		currentLineLength = currentLineLength + string.len( text )
		if currentLineLength > longestLineLength then
			longestLineLength = currentLineLength
			resized = true
		end
		changed = true
	end
end

-- End the current line in the console, assigning the color rgb if given.
local function endLine( rgb )
	local n = #currentLineStrings
	local iLine = #completedLines + 1
	if n == 1 then
		completedLines[iLine] = currentLineStrings[1]
		currentLineStrings[1] = nil
	elseif n == 0 then	
		completedLines[iLine] = ""
	else
		completedLines[iLine] = table.concat( currentLineStrings )
		currentLineStrings = {}
	end
	rgbForLine[iLine] = rgb
	currentLineLength = 0
	changed = true
end

-- Handle touch events on the console
local function onTouchConsole()
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
			local ending = string.sub( text, iStart )
			if ending then
				addText( ending )  -- last incomplete line
			end
		end
	end
end

-- Print text plus a newline to the console.
-- if rgb is included then it is an array {r, g, b} (each 0-1) for the 
-- color to assign to the line.
function console.println( text, rgb )		
	console.print( text )
	endLine( rgb )
end

-- Clear the console data and view
function console.clear()
	-- Init/clear console data
	completedLines = {}
	rgbForLine = {}
	currentLineStrings = {}
	currentLineLength = 0
	longestLineLength = 0

	-- Reset display state
	numDisplayLines = 0
	scrollStartLine = nil
	changed = true
	resized = true

	-- Adjust display objects if necessary
	if textGroup then
		textGroup.x = 0
	end
	if scrollbarV then
		scrollbarV:hide()
	end
	if scrollbarH then
		scrollbarH:hide()
	end
end

-- Resize the console to fit the given size
function console.resize( width, height )
	-- Size the background rect
	bg.width = width
	bg.height = height

	-- Request full update
	changed = true
	resized = true
	updateConsole()
end

-- Create the console display group and store it in consoleGroup
function console.create( parent, x, y, width, height )
	-- Make the console group
	consoleGroup = g.makeGroup( parent, x, y )

	-- White background
	bg = g.uiWhite( display.newRect( consoleGroup, 0, 0, width, height ) )
	bg:addEventListener( "touch", onTouchConsole )

	-- Text group and scrollbars
	textGroup = g.makeGroup( consoleGroup, 0, 0 )
	scrollbarV = Scrollbar:new( consoleGroup, width - Scrollbar.width, 0, 
								height, onScrollVert )
	scrollbarH = Scrollbar:new( consoleGroup, 0, height - Scrollbar.width, 
								width, onScrollHorz, true )
end

-- Do one-time initialization for the console
function console.init()
	-- Get height of console font
	local metrics = graphics.getFontMetrics( app.consoleFont, app.consoleFontSize )
	fontHeight = math.round( metrics.height ) + 2   -- leading is reported as 0 for our font
	app.consoleFontHeight = fontHeight

	-- Get char width by measuring a text object since not in font metrics
	local temp1 = display.newText( "-", 0, 0, app.consoleFont, app.consoleFontSize )
	local temp11 = display.newText( "-1234567890", 0, 0, app.consoleFont, app.consoleFontSize )
	fontCharWidth = (temp11.contentWidth - temp1.contentWidth) / 10
	temp1:removeSelf()
	temp11:removeSelf()
	app.consoleFontCharWidth = fontCharWidth

	-- Start out empty
	console.clear()
	changed = false

	-- Update the console as needed up to once per frame
	Runtime:addEventListener( "enterFrame", onNewFrame )
end


------------------------------------------------------------------------------
return console

