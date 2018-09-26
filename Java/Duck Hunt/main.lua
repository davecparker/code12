this = {}; _fn = {}   -- This file was generated by Code12 from "DuckHunt.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
-- location and fire straight upwards towards the ducks.





-- public static void main( String[] args )
-- {
-- 	Code12.run( new DuckHunt() ); 
-- }

this.gun = nil   -- Gun at bottom of window that fires bullets
this.ducksHitDisplay = nil   -- Text display for percent of ducks hit
this.accuracyDisplay = nil   -- Text display for percent of shots on target   
this.yMax = 0   -- Maximum y-coordinate of the game window
this.maxSize = 0   -- Maximum array size
this.bulletsArr = nil   -- Array for accessing bullets on screen
this.ducksArr = nil   -- Array for accessing ducks on screen
this.duckYStartsArr = nil   -- Array for tracking center of ducks vertical movement
this.bulletsCount = 0   -- Count of how many bullets are on the screen
this.bulletsMissed = 0   -- Count of how many bullets have gone off screen without hitting a duck
this.ducksCount = 0   -- Count of how many ducks are currently on screen
this.ducksHit = 0   -- Count of how many ducks have been hit by a bullet
this.ducksMissed = 0   -- Count of how many ducks have gone off screen without being hit by a bullet
this.amplitude = 0   -- Amplitude of the ducks up and down motion
this.period = 0   -- Period of the ducs up and down motion

function _fn.start()

	-- Set title
	ct.setTitle("Duck Hunt")

	-- Set background
	ct.setHeight(ct.intDiv(100 * 9, 16))
	this.yMax = ct.getHeight()
	ct.setBackImage("stage.png")

	-- Initialize count variables
	this.bulletsCount = 0
	this.bulletsMissed = 0
	this.ducksCount = 0
	this.ducksHit = 0
	this.ducksMissed = 0

	-- Make ducksHitDisplay
	local scoreHeight = 5
	local scoreColor = "dark magenta"
	this.ducksHitDisplay = ct.text("Ducks hit: ", 0, this.yMax, scoreHeight, scoreColor)
	this.ducksHitDisplay:align("bottom left", true)

	-- Make accuracyDisplay
	this.accuracyDisplay = ct.text("Shot Accuracy: ", 100, this.yMax, scoreHeight, scoreColor)
	this.accuracyDisplay:align("bottom right", true)

	-- Make gun
	this.gun = ct.image("gun.png", 50, this.yMax - scoreHeight, 8)
	this.gun:align("bottom", true)

	-- Initialize arrays
	this.maxSize = 100
	this.bulletsArr = { length = this.maxSize, default = nil }
	this.ducksArr = { length = this.maxSize, default = nil }
	this.duckYStartsArr = { length = this.maxSize, default = 0 }

	-- Initialize amplitude and period for ducks' path
	this.amplitude = 5
	this.period = 100
end

function _fn.update()

	-- Make ducks at random times and positions
	if ct.random(1, 50) == 1 then

		local x = ct.random(110, 130)
		local y = ct.random(10, ct.toInt(this.yMax / 2))
		local duck = _fn.createDuck(x, y,  -0.5)
	end

	-- If a duck goes off screen, delete it
	-- Else make it move up/down on sinusoidal path
	local j = this.ducksCount - 1; while j >= 0 do

		local duck = ct.indexArray(this.ducksArr, j)
		local duckYStart = ct.indexArray(this.duckYStartsArr, j)
		if duck.x < 0 then

			_fn.deleteDuck(j)
			this.ducksMissed = this.ducksMissed + 1
		else


			--duck.ySpeed = ct.random( -1, 1 ) / 4.0;
			duck.y = ct.indexArray(this.duckYStartsArr, j) + this.amplitude * math.sin(2 * math.pi / this.period * duck.x); end; j = j - 1

	end

	-- Check for duck-bullet hits and going off screen
	local i = this.bulletsCount - 1; while i >= 0 do

		local bullet = ct.indexArray(this.bulletsArr, i)
		-- Delete bullet if it has gone off screen
		if bullet.y < 0 then

			_fn.deleteBullet(i)
			this.bulletsMissed = this.bulletsMissed + 1
			-- Don't check this bullet hitting ducks
			break
		end
		-- Check for bullet hitting any ducks
		local j = this.ducksCount - 1; while j >= 0 do

			local duck = ct.indexArray(this.ducksArr, j)
			if bullet:hit(duck) then

				ct.sound("quack.wav")
				_fn.makeDeadDuck(duck)

				-- Delete bullet and duck
				_fn.deleteBullet(i)
				_fn.deleteDuck(j)
				this.ducksHit = this.ducksHit + 1
				-- Don't let this bullet affect any more ducks
				break
			end; j = j - 1
		end; i = i - 1
	end

	-- Update ducksHitDisplay
	local percent = ct.round(100.0 * this.ducksHit / (this.ducksHit + this.ducksMissed))
	this.ducksHitDisplay:setText("Ducks hit: " .. tostring(percent) .. "%")

	-- Update accuracyDisplay
	percent = ct.round(100.0 * this.ducksHit / (this.ducksHit + this.bulletsMissed))
	this.accuracyDisplay:setText("Shot Accuracy: " .. tostring(percent) .. "%")
end

-- Makes a bullet at position xStart, yStart that will then
-- move up the window and delete itself once outside the window
function _fn.fireBullet(xStart, yStart)

	local bullet = nil
	if this.bulletsCount < this.maxSize then

		--GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
		bullet = ct.rect(xStart, yStart, 0.5, 2, "blue")
		bullet.ySpeed =  -2
		ct.checkArrayIndex(this.bulletsArr, this.bulletsCount); this.bulletsArr[1+(this.bulletsCount)] = bullet
		this.bulletsCount = this.bulletsCount + 1
	else


		ct.println("Too many bullets on screen."); end

	return bullet
end

-- Deletes a bullet
function _fn.deleteBullet(index)

	local bullet = ct.indexArray(this.bulletsArr, index)
	bullet:delete()
	local i = index; while i < this.bulletsCount - 1 do

		ct.checkArrayIndex(this.bulletsArr, i); this.bulletsArr[1+(i)] = ct.indexArray(this.bulletsArr, i + 1); i = i + 1
	end
	this.bulletsCount = this.bulletsCount - 1
end

-- Makes a duck to the right of the window at y-coordinate yStart
-- that will then accross the window horizontally with speed xSpeed
function _fn.createDuck(xStart, yStart, xSpeed)

	local duck = nil
	if this.ducksCount < this.maxSize then

		duck = ct.image("rubber-duck.png", xStart, yStart, 5)
		duck.xSpeed = xSpeed
		ct.checkArrayIndex(this.ducksArr, this.ducksCount); this.ducksArr[1+(this.ducksCount)] = duck
		ct.checkArrayIndex(this.duckYStartsArr, this.ducksCount); this.duckYStartsArr[1+(this.ducksCount)] = yStart
		this.ducksCount = this.ducksCount + 1
	else


		ct.println("Too many ducks on screen."); end


	return duck
end

-- Deletes a duck
function _fn.deleteDuck(index)

	local duck = ct.indexArray(this.ducksArr, index)
	duck:delete()
	local i = index; while i < this.ducksCount - 1 do

		ct.checkArrayIndex(this.ducksArr, i); this.ducksArr[1+(i)] = ct.indexArray(this.ducksArr, i + 1)
		ct.checkArrayIndex(this.duckYStartsArr, i); this.duckYStartsArr[1+(i)] = ct.indexArray(this.duckYStartsArr, i + 1); i = i + 1
	end
	this.ducksCount = this.ducksCount - 1
end

-- Makes a dead duck at duck's position
function _fn.makeDeadDuck(duck)

	local deadDuck = ct.image("dead-duck.png", duck.x, duck.y, duck.height)
	deadDuck.autoDelete = true
	deadDuck.ySpeed = 1
	return deadDuck
end

-- Moves the gun horizontally and fires a bullet when the mouse
-- is clicked
function _fn.onMousePress(obj, x, y)

	-- Play squirt sound
	ct.sound("squirt.wav")

	-- Move the gun horizontally to match the click location
	this.gun.x = x

	-- Fire a new bullet
	local xStart = this.gun.x
	local yStart = this.gun.y - this.gun.height * 0.9
	_fn.fireBullet(xStart, yStart)
end
