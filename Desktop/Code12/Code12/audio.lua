-----------------------------------------------------------------------------------------
--
-- audio.lua
--
-- Implementation of the audio APIs for the Code 12 Lua runtime.
--
-- (c)Copyright 2018 by David C. Parker
-----------------------------------------------------------------------------------------

local g = require("Code12.globals")
require("Code12.runtime")


-- Data for this module
local sounds = {}           -- Cached loaded sounds, indexed by filename
local soundVolume = 1.0     -- Sound volume from 0.0 to 1.0


---------------- Internal Functions ------------------------------------

-- Load the sound file if necessary, and return the sound or nil if failure.
local function getSound(filename)
	-- Is this sound already loaded?
	local sound = sounds[filename]
	if sound then
		return sound
	end

	-- If an app context tells us the media directory then use it, else current dir.
	local baseDir, path
	local appContext = ct._appContext
	if appContext and appContext.mediaDir then
		path = appContext.mediaDir .. filename
		baseDir = appContext.mediaBaseDir
	else
		path = filename
		baseDir = system.ResourceDirectory
	end

	-- Load and cache the sound
	sound = audio.loadSound(path, baseDir)
	if sound then 
		sounds[filename] = sound   -- cache it
	else
		g.warning("Cannot find sound file", filename)
	end
	return sound
end


---------------- Audio API ---------------------------------------------

-- API
function ct.loadSound(filename, ...)
	-- Check parameters
	if filename == nil then
		return
	end
	if g.checkAPIParams("ct.loadSound") then
		g.check1Param("string", filename, ...)
	end

	-- Load and cache the sound
	return (getSound(filename) ~= nil)
end

-- API
function ct.sound(filename, ...)
	-- Check parameters
	if filename == nil then
		return
	end
	if g.checkAPIParams("ct.sound") then
		g.check1Param("string", filename, ...)
	end

	-- Load then play sound if found
	local sound = getSound(filename)
	if sound then
		-- Find an available channel, set the volume, and play it
		local channel = audio.findFreeChannel()
		if channel then
			local options = { channel = channel }
			audio.setVolume(soundVolume, options)
			audio.play(sound, options)
		end
	end
end

-- API
function ct.setSoundVolume(volume, ...)
	-- Check parameters
	if g.checkAPIParams("ct.setSoundVolume") then
		g.check1Param("number", volume, ...)
	end

	-- Set sound volume for future audio
	soundVolume = volume
end

