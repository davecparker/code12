-----------------------------------------------------------------------------------------
--
-- Scrollbar.lua
--
-- Class to implement a vertical or horizontal scrollbar for the Code12 Desktop app.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

-- Code12 modules
local g = require( "Code12.globals" )


-- Layout constants
local margin = 2                             -- x and y margins for shuttle
local width = 12                             -- scrollbar width

-- Computed layout metrics
local radius = width / 2 - margin            -- radius of circlular parts
local diameter = radius * 2                  -- diameter of shuttle circular parts
local minLength = margin * 2 + diameter      -- don't show if shorter than this
local minShuttleLength = diameter * 3        -- minimum pixel length of shuttle

-- Gray shades
local trackShade = 0.94
local shuttleShade = 0.75


-- The scrollbar class
local Scrollbar = {
	width = width,                -- width of scrollbars, for app use
}


--- Internal Functions ---------------------------------------------------------

-- Layout the track elements 
function Scrollbar:layoutTrack()
	-- Hide scrollbar if not enought length to show
	local length = self.length
	if length < minLength then
		self.group.isVisible = false
		return
	end
	self.group.isVisible = true
	if self.horz then
		self.track.width = length
	else
		self.track.height = length
	end
end

-- Set a new scroll pos and notify the app
function Scrollbar:setPos( pos )
	-- Force pos in range and adjust the scrollbar
	pos = g.pinValue( pos, self.rangeMin, self.rangeMax ) 
	self:adjust( self.rangeMin, self.rangeMax, pos, self.ratio )

	-- Notify the app
	if self.onChangePos then
		self.onChangePos( pos )
	end
end

-- Handle touch events on the shuttle given phase and x within a horizontal scrollbar
function Scrollbar:touchShuttleHorz( phase, x )
	if phase == "began" then
		self.dragOffset = x - self.shuttleBegin.x
		g.setFocusObj( self.shuttleBegin )
	elseif g.focusObj == self.shuttleBegin and phase ~= "cancelled" then
		-- Compute new shuttle left
		local xLeft = x - self.dragOffset
		xLeft = g.pinValue( xLeft, self.xyMinShuttle , self.xyMaxShuttle )

		-- Move the graphics
		self.shuttleBegin.x = xLeft
		self.shuttleMiddle.x = xLeft + radius
		self.shuttleEnd.x = xLeft + self.shuttleMiddle.width

		-- Compute new pos and set it
		local range = self.rangeMax - self.rangeMin
		local xyRange = self.xyMaxShuttle - self.xyMinShuttle
		local newPos = self.rangeMin + math.round( 
				(xLeft - self.xyMinShuttle) * range / xyRange )
		self:setPos( newPos )
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Handle touch events on the shuttle given phase and y within a vertical scrollbar
function Scrollbar:touchShuttleVert( phase, y )
	if phase == "began" then
		self.dragOffset = y - self.shuttleBegin.y
		g.setFocusObj( self.shuttleBegin )
	elseif g.focusObj == self.shuttleBegin and phase ~= "cancelled" then
		-- Compute new shuttle top
		local yTop = y - self.dragOffset
		yTop = g.pinValue( yTop, self.xyMinShuttle , self.xyMaxShuttle )

		-- Move the graphics
		self.shuttleBegin.y = yTop
		self.shuttleMiddle.y = yTop + radius
		self.shuttleEnd.y = yTop + self.shuttleMiddle.height

		-- Compute new pos and set it
		local range = self.rangeMax - self.rangeMin
		local xyRange = self.xyMaxShuttle - self.xyMinShuttle
		local newPos = self.rangeMin + math.round( 
				(yTop - self.xyMinShuttle) * range / xyRange )
		self:setPos( newPos )
	end
	if phase == "ended" or phase == "cancelled" then
		g.setFocusObj(nil)
	end
	return true
end

-- Handle touch events on the shuttle given phase and xy within the scrollbar
function Scrollbar:touchTrack( phase, xy )
	-- Touch on track. Go up or down down one "page" on a click
	if phase == "began" then
		local pageSize = math.round( self.ratio * (self.rangeMax - self.rangeMin) )
		-- print(self.rangeMin, self.rangeMax, self.ratio, pageSize)
		local start = self.horz and self.shuttleBegin.x or self.shuttleBegin.y
		if xy <= start then
			self:setPos( self.pos - pageSize )
		else
			self:setPos( self.pos + pageSize )
		end
		g.setFocusObj( self.track )
	elseif phase ~= "moved" then
		g.setFocusObj( nil )
	end
	return true
end

-- Handle touch events on a scrollbar
function Scrollbar:touch( event )
	-- Which part got touched?
	local x, y = self.group:contentToLocal( event.x, event.y )
	if self.horz then
		if g.focusObj == self.shuttleBegin 
				or (x >= self.shuttleBegin.x and x <= self.shuttleEnd.x + diameter) then
			return self:touchShuttleHorz( event.phase, x )
		end
		return self:touchTrack( event.phase, x )
	else  -- vertical
		if g.focusObj == self.shuttleBegin 
				or (y >= self.shuttleBegin.y and y <= self.shuttleEnd.y + diameter) then
			return self:touchShuttleVert( event.phase, y )
		end
		return self:touchTrack( event.phase, y )
	end
end


--- Module Functions ---------------------------------------------------------

-- Construct and return a scrollbar at the given position and size in parent.
-- The onChangePos function will be called passing the new pos value when the 
-- user changes the scroll position. If horizontal is true then the scrollbar
-- is horizontal else (default) vertical. Call the adjust method to set the range.
function Scrollbar:new( parent, x, y, length, onChangePos, horizontal )
	-- Make a group for the scrollbar
	local group = g.makeGroup( parent, x, y )
	group.isVisible = false

	-- Create a new instance
	local xy = margin                -- offset for shuttle parts
	local dxy = width - margin * 2   -- width of shuttle
	local sb = {
		-- Layout metrics
		rangeMin = 0,        -- range minimum from app, set by adjust
		rangeMax = 0,        -- range minimum from app, set by adjust
		pos = 0,             -- current position, set by adjust
		ratio = 1,           -- shuttle size relative to range (0-1), set by adjust
		length = length,     -- pixel length of scrollbar
		horz = horizontal,   -- true if horizontal
		xyMinShuttle = 0,    -- min pixel pos for shuttle (x if horz, y if vert)
		xyMaxShuttle = 0,    -- max pixel pos for shuttle (x if horz, y if vert)
		dragOffset = 0,      -- mouse pixel offset when dragging shuttle

		-- Display parts (finished in layoutTrack)
		group = group,   -- display group for the scrollbar
		track = g.uiItem( display.newRect( group, 0, 0, width, width ), trackShade ),
		shuttleBegin = g.uiItem( display.newCircle( group, xy, xy, radius ), shuttleShade ),
		shuttleMiddle = g.uiItem( display.newRect( group, xy, xy, dxy, dxy ), shuttleShade ),
		shuttleEnd = g.uiItem( display.newCircle( group, xy, xy, radius ), shuttleShade ),

		-- Change callback function
		onChangePos = onChangePos,
	}

	-- Set touch listeners for the shuttle and extra space
	sb.track:addEventListener( "touch", sb )
	sb.shuttleBegin:addEventListener( "touch", sb )
	sb.shuttleMiddle:addEventListener( "touch", sb )
	sb.shuttleEnd:addEventListener( "touch", sb )

	-- Set the object's metatable
	setmetatable( sb, self)
	self.__index = self

	-- Do the track layout then return it
	sb:layoutTrack()
	return sb
end

-- Set the range and position within it of a scrollbar. 
-- The ratio is the size for the shuttle relative to the range (0-1).
-- If ratio is >= 1 then the scrollbar is hidden.
-- Return the resulting position pinned within rangeMin to rangeMax.
function Scrollbar:adjust( rangeMin, rangeMax, pos, ratio )
	-- Store the metrics
	pos = g.pinValue( pos, rangeMin, rangeMax )  -- force pos inside range
	self.rangeMin = rangeMin
	self.rangeMax = rangeMax
	self.pos = pos
	self.ratio = ratio

	-- Determine the shuttle range and hide the scrollbar if not needed
	if ratio >= 1 or self.length < minLength then
		self.group.isVisible = false
		return pos
	end
	self.group.isVisible = true
	local range = rangeMax - rangeMin

	-- Determine the shuttle size
	local dxyShuttle = math.max( ratio * self.length, minShuttleLength )
	self.xyMinShuttle = margin
	local dyRangeShuttle = self.length - margin * 2 - dxyShuttle
	self.xyMaxShuttle = self.xyMinShuttle + dyRangeShuttle

	-- Position the parts
	local xyShuttle = (pos - rangeMin) * dyRangeShuttle / range + margin
	if self.horz then
		self.shuttleBegin.x = xyShuttle
		self.shuttleMiddle.x = xyShuttle + radius
		self.shuttleMiddle.width = dxyShuttle - diameter
		self.shuttleEnd.x = xyShuttle + self.shuttleMiddle.width
	else
		self.shuttleBegin.y = xyShuttle
		self.shuttleMiddle.y = xyShuttle + radius
		self.shuttleMiddle.height = dxyShuttle - diameter
		self.shuttleEnd.y = xyShuttle + self.shuttleMiddle.height
	end
	return pos
end 
	
-- Change the display position and/or length of the scrollbar
function Scrollbar:setPosition( x, y, length )
	self.group.x = x
	self.group.y = y
	self.length = length

	self:layoutTrack()
	self:adjust( self.rangeMin, self.rangeMax, self.pos, self.ratio )
end

-- Return true if the scrollbar is at the end of its scroll range
function Scrollbar:atRangeMax()
	return self.pos == self.rangeMax
end

-- Hide the scrollbar
function Scrollbar:hide()
	self:adjust( 0, 0, 0, 1 )
end

-- Move the scrollbar to the front of its parent group
function Scrollbar:toFront()
	self.group:toFront()
end


------------------------------------------------------------------------------
return Scrollbar

