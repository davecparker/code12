package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()   -- onMousePress()
-- onMouseDrag()
-- Level 10: User-defined Functions





this.currentColor = "blue"   -- Default color
this.highlite = "yellow"
this.brush = nil
-- circle to bound lines
this.c = nil
this.lastX = 0; this.lastY = 0
-- Rectangles to contain the colors
this.palette = nil
this.redRect = nil
this.orangeRect = nil
this.yellowRect = nil
this.greenRect = nil
this.blueRect = nil
this.indigoRect = nil
this.purpleRect = nil
this.magentaRect = nil
this.eraseRect = nil

-- Objects to be used to change brush size
this.small = nil
this.medium = nil
this.large = nil
this.size = 6   -- Default size is small






function _fn.start()

	local gameWidth = ct.getWidth()
	local gameHeight = ct.getHeight()
	ct.setTitle("Cheesy MS Paint")

	local offset = 3
	local spacing = gameHeight / 10

	local BOX_WIDTH = 17   -- 20 minus offset

	this.palette = ct.rect(10, gameHeight / 2, 20, gameHeight, "black")
	ct.rect(10, gameHeight / 2, BOX_WIDTH, gameHeight - offset, "gray")

	this.redRect = ct.rect(spacing, spacing - offset, BOX_WIDTH, spacing, "red")
	this.orangeRect = ct.rect(spacing, spacing * 2 - offset, BOX_WIDTH, spacing, "orange")
	this.yellowRect = ct.rect(spacing, spacing * 3 - offset, BOX_WIDTH, spacing, "yellow")
	this.greenRect = ct.rect(spacing, spacing * 4 - offset, BOX_WIDTH, spacing, "green")
	this.blueRect = ct.rect(spacing, spacing * 5 - offset, BOX_WIDTH, spacing, "blue")
	this.indigoRect = ct.rect(spacing, spacing * 6 - offset, BOX_WIDTH, spacing, "dark blue")
	this.purpleRect = ct.rect(spacing, spacing * 7 - offset, BOX_WIDTH, spacing, "purple")
	this.magentaRect = ct.rect(spacing, spacing * 8 - offset, BOX_WIDTH, spacing, "dark magenta")

	-- This will be pressed to activate the eraser
	this.eraseRect = ct.rect(spacing, spacing * 9 - offset, BOX_WIDTH, spacing, "pink")
	ct.text("Eraser", spacing, spacing * 9 - offset, 5)

	-- Squares to select brush size
	this.small = ct.rect(4.5, gameHeight - 5, BOX_WIDTH / 3, spacing - offset - 1, "white")
	ct.text("s", this.small.x, this.small.y, 4)
	this.medium = ct.rect(spacing, gameHeight - 5, BOX_WIDTH / 3, spacing - offset - 1, "white")
	ct.text("m", this.medium.x, this.medium.y, 4)
	this.large = ct.rect(15.7, gameHeight - 5, BOX_WIDTH / 3, spacing - offset - 1, "white")
	ct.text("l", this.large.x, this.large.y, 4)

end

function _fn.update()

	this.redRect.clickable = true
	this.orangeRect.clickable = true
	this.yellowRect.clickable = true
	this.greenRect.clickable = true
	this.blueRect.clickable = true
	this.indigoRect.clickable = true
	this.purpleRect.clickable = true
	this.magentaRect.clickable = true
	this.eraseRect.clickable = true

	this.small.clickable = true
	this.medium.clickable = true
	this.large.clickable = true
end


-- have all except selected (null) for obj.setLineColor
-- selected obj.setLineColor("yellow"

function _fn.onMousePress(obj, x, y)

	this.lastX = x
	this.lastY = y

	if obj ~= nil then

		if obj == this.redRect then
			this.currentColor = "red"
		elseif obj == this.orangeRect then
			this.currentColor = "orange"
		elseif obj == this.yellowRect then
			this.currentColor = "yellow"
		elseif obj == this.greenRect then
			this.currentColor = "green"
		elseif obj == this.blueRect then
			this.currentColor = "blue"
		elseif obj == this.indigoRect then
			this.currentColor = "dark blue"
		elseif obj == this.purpleRect then
			this.currentColor = "purple"
		elseif obj == this.magentaRect then
			this.currentColor = "dark magenta"
		elseif obj == this.eraseRect then
			this.currentColor = "white"
		end
		-- Whichever brush size selected gets highlighted
		if obj == this.small then

			this.size = 6
			this.small:setFillColor("light yellow")
			this.medium:setFillColor("white")
			this.large:setFillColor("white")
		elseif obj == this.medium then


			this.size = 8
			this.medium:setFillColor("light yellow")
			this.small:setFillColor("white")
			this.large:setFillColor("white")
		elseif obj == this.large then


			this.size = 16
			this.large:setFillColor("light yellow")
			this.small:setFillColor("white")
			this.medium:setFillColor("white"); end


	end
end

function _fn.onMouseDrag(obj, x, y)


	-- saves the last known click position coordinates (lastX, lastY from onMousePress() )
	-- then draw a line between those coordinates and the current 

	-- user can only draw on canvas(null space), not on other game objects
	if x > this.palette.width + 2 then

		this.brush = ct.line(this.lastX, this.lastY, x, y, this.currentColor)
		this.brush.lineWidth = ct.toInt(this.size)
		-- draw a bounding circle between lines (endpoints)
		if this.size == 6 or this.size == 8 then
			this.c = ct.circle(x, y, this.size / 10, this.currentColor)
		elseif this.size == 16 then
			this.c = ct.circle(x, y, this.size / 5, this.currentColor)
		end
		this.c:setLineColor(this.currentColor)
		-- update previous position
		this.lastX = x
		this.lastY = y
	end

end

require('Code12.api')
require('Code12.runtime').run()
