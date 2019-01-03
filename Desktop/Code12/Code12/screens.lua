-----------------------------------------------------------------------------------------
--
-- screens.lua
--
-- Implementation of the screen management APIs for the Code12 Lua runtime.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- Runtime support modules
local ct = require("Code12.ct")
local g = require("Code12.globals")
local runtime = require("Code12.runtime")
local GameObj = require("Code12.GameObj")


---------------- Screen Management API ---------------------------------------

-- API
function ct.setTitle(title)
	native.setProperty("windowTitleText", title or "Code12")
end

-- API
function ct.setHeight(height)
	-- Pin height to a reasonable range
	height = g.pinValue(height, 1, 10000)

	-- Are we embedded in an external app window?
	local appContext = runtime.appContext
	if appContext then
		-- (Embedded) Make sure we show the whole output, scaling as necessary
		local windowAspect = appContext.widthP / appContext.heightP
		local aspect = g.WIDTH / height
		if aspect > windowAspect then
			g.window.width = appContext.widthP             -- use the full width
			g.window.height = appContext.widthP / aspect   -- extra room below
		else
			g.window.height = appContext.heightP           -- use the full height
			g.window.width = appContext.heightP * aspect   -- extra room to the right
		end
		appContext.setClipSize(g.window.width, g.window.height)
	else
		-- (Standalone or mobile)
		-- Unfortunately a Corona desktop app cannot change the window size via software,
		-- and a Corona mobile app can't affect the screen size at all, so height here
		-- only determines whether we switch to landscape on mobile.
		if g.isMobile and height < g.WIDTH then
			-- Landscape mobile: ignore height, rotate 90 degrees, and use the entire device
			g.window.width = g.device.height
			g.window.height = g.device.width
			g.mainGroup.rotation = 90
			g.mainGroup.x = g.device.width
		else
			-- Portrait mobile or standalone: ignore height and use the entire device
			g.window.width = g.device.width
			g.window.height = g.device.height
			g.mainGroup.rotation = 0
			g.mainGroup.x = 0
		end
	end

	-- Compute new actual logical height and scaling factor
	g.height = g.WIDTH * g.window.height / g.window.width
	g.scale = g.window.width / g.WIDTH
	g.window.resized = true

	-- Adjust the screen origin if any
	local screen = g.screen
	if screen then
		ct.setScreenOrigin(screen.originX, screen.originY)
	end
end

-- API
function ct.getWidth()
	return g.WIDTH
end

-- API
function ct.getHeight()
	return g.height
end

-- API
function ct.getPixelsPerUnit()
	return g.scale
end

-- API
function ct.setScreen(name)
	-- Make nil name same as empty string
	name = name or ""

	-- Hide old screen if any
	if g.screen then
		g.screen.group.isVisible = false
	end

	-- Does this screen name already exist?
	local screen = g.screens[name]
	if screen then
		-- Switch to existing screen
		g.screen = screen
	else
		-- Create a new screen with its own display group
		screen = {
			name = name,
			group = display.newGroup(),
			objs = display.newGroup(),   -- layer above background obj
			originX = 0,
			originY = 0,
			-- backObj = nil,      -- background object, set below
			-- hasSpeed = nil,     -- true if any objs use xSpeed/ySpeed
			-- objsWarning = nil,  -- true when we have given an object count warning
		}
		g.mainGroup:insert(screen.group)
		screen.group:insert(screen.objs)
		g.screens[name] = screen
		g.screen = screen

		-- Add default white background
		ct.setBackColor("white")    -- sets backObj
	end

	-- Show new screen and make sure it does a full resize at next update
	screen.group.isVisible = true
	g.window.resized = true
end

-- API
function ct.getScreen()
	return g.screen.name
end

-- API
function ct.setScreenOrigin(x, y)
	-- Save the origin in the current screen
	local screen = g.screen
	screen.originX = x
	screen.originY = y	

	-- Offset the screen's objects group
	local group = screen.objs
	group.x = -x * g.scale
	group.y = -y * g.scale
end

-- API
function ct.clearScreen()
	-- Delete all objects in the screen group, from top down
	local screenGroup = g.screen.objs
	for i = screenGroup.numChildren, 1, -1 do
		screenGroup[i].code12GameObj:removeAndDelete()
	end
end

-- API
function ct.clearGroup(group)
	-- Delete objects with matching group name, from top down
	group = group or ""
	local screenGroup = g.screen.objs
	for i = screenGroup.numChildren, 1, -1 do
		local gameObj = screenGroup[i].code12GameObj
		if gameObj.group == group then
			gameObj:removeAndDelete()
		end
	end
end

-- API
function ct.setBackColor(colorName)
	-- Delete previous background object if any
	local backObj = g.screen.backObj
	if backObj then
		backObj:delete()
		g.screen.backObj = nil
	end

	-- Calling with nil just removes the background
	if colorName == nil then
		return
	end

	-- Make a rect big enough to cover the screen without needing to scale it
	backObj = GameObj:newRect(g.screen.group, 0, 0, 100000, 100000, colorName)
	backObj.updateBackObj = function () end
	local obj = backObj.obj
	obj:removeEventListener("touch", g.onTouchGameObj)
	obj:addEventListener("touch", g.onTouchBackObj)

	-- Put the rect behind the objs layer in the screen group
	obj:toBack()
	g.screen.backObj = backObj
end

-- API
function ct.setBackColorRGB(red, green, blue)
	-- Pin color components to the allowed range
	red = g.pinValue(red, 0, 255)
	green = g.pinValue(green, 0, 255)
	blue = g.pinValue(blue, 0, 255)

	-- Make a default background rect first, then set its color
	ct.setBackColor("white")
	g.screen.backObj:setFillColorRGB(red, green, blue)
end

-- API
function ct.setBackImage(filename)
	-- Delete previous background object if any
	local backObj = g.screen.backObj
	if backObj then
		backObj:delete()
		g.screen.backObj = nil
	end

	-- Calling with nil or empty filename just removes the background
	if filename == nil or filename == "" then
		return
	end

	-- Make an image object with temporary position and size for now
	backObj = GameObj:newImage(g.screen.group, filename, 0, 0, g.WIDTH)
	local img = backObj.obj
	img:removeEventListener("touch", g.onTouchGameObj)
	img:addEventListener("touch", g.onTouchBackObj)

	-- Install special update method to position and crop properly
	backObj.updateBackObj = 
			function (gameObj)
				local obj = gameObj.obj
				local scale = g.scale

				-- Center it in the window
				obj.x = (g.WIDTH / 2) * scale
				obj.y = (g.height / 2) * scale

				-- Use as much of the image as possible while filling 
				-- the window and retaining the image aspect ratio.
				local aspect = obj.width / obj.height
				if aspect > (g.WIDTH / g.height) then
					obj.width = g.height * aspect * scale
					obj.height = g.height * scale
				else
					obj.width = g.WIDTH * scale
					obj.height = (g.WIDTH / aspect) * scale
				end
			end

	-- Put the image behind the objs layer in the screen group
	img:toBack()
	g.screen.backObj = backObj
	backObj:updateBackObj()
end

