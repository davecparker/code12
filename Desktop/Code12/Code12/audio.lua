-----------------------------------------------------------------------------------------
--
-- audio.lua
--
-- Implementation of the audio APIs for the Code12 Lua runtime.
--
-- Copyright (c) 2018-2019 Code12
-----------------------------------------------------------------------------------------


-- Runtime support modules
local ct = require("Code12.ct")
local runtime = require("Code12.runtime")


-- Data for this module
local sounds = {}           -- Cached loaded sounds, indexed by filename
local soundVolume = 1.0     -- Sound volume from 0.0 to 1.0


---------------- Internal Functions ------------------------------------

-- Load the sound file if necessary, and return the sound or nil if failure.
local function getSound(filename)
	-- Is this sound already loaded?
	if filename == nil then
		return nil
	end
	local sound = sounds[filename]
	if sound then
		return sound
	end

	-- If an app context tells us the media directory then use it, else current dir.
	local baseDir, path
	local appContext = runtime.appContext
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
		runtime.warning("Cannot find sound file", filename)
	end
	return sound
end


---------------- Audio API ---------------------------------------------

-- API
function ct.loadSound(filename)
	-- Load and cache the sound
	return (getSound(filename) ~= nil)
end

-- API
function ct.sound(filename)
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
function ct.setSoundVolume(volume)
	-- Set sound volume for future audio
	soundVolume = volume
end

