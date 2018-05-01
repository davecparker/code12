-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

package.path = package.path .. ';../?.lua'
local ct = require("Code12.api")


local fish, wall


ct.log(3, 4, "Dave")

ct.println(5 + 6)

ct.print("Data")
ct.print(4)
ct.print("You")
ct.println("")


function start()
	ct.setTitle("Code 12 Test")
	ct.setHeight(150)
	ct.logm("Screen size:", ct.getWidth(), ct.getHeight())
    ct.logm("Scale factor:", ct.getPixelsPerUnit())

	ct.setScreen("Main")
	ct.setBackColor("pink")
	ct.setBackColorRGB(0, 100, 200)
	ct.setBackImage("underwater.jpg")

	local c = ct.circle(50, 50, 100, "pink")
	c:setFillColor("orange")
	c:setLineColorRGB(0, 0, 200)
	c.lineWidth = 3
	c.clickable = true

	local r = ct.rect(50, 50, 50, 50)
	ct.log(r)

	local t = ct.text("Hey", 50, 50, 10)
	t:setText("Hello!")
	t:setFillColor("purple")
	t:align("left")
	ct.log("Text width", t.width)
	t:setLayer(2)

	local cc = ct.circle(50, 50, 10)
	cc.group = "dots"

	local topCircle = ct.circle(50, 50 - r.height / 2, 10)
	topCircle:align("bottom")
	topCircle.group = "dots"

	wall = ct.rect(50, ct.getHeight(), 10, 40)
	wall:align("bottom", true)
	wall:setLayer(0)

	fish = ct.image("goldfish.png", -50, 120, 30)
	fish.xSpeed = -1
	-- fish.autoDelete = true
	fish.clickable = true
	ct.log(fish)

	local line = ct.line(0, 0, ct.getWidth(), ct.getHeight())
	line.lineWidth = 5
	line:setLineColor("red")
	line:align("left", true)

	ct.log(ct.getTimer())

	ct.setSoundVolume(0.25)
	ct.sound("bubble.wav")
end

function update()
	-- ct.log(ct.getTimer())

	if fish.x < -50 then
		fish.x = 150
	elseif fish.x > 150 then
		fish.x = -50
	end

	if fish:clicked() then
		ct.sound("bubble.wav")
		ct.log("You got the fish!")
		ct.clearGroup("dots")
	end

	if fish:hit(wall) then
		fish.xSpeed = -fish.xSpeed
	end

	if ct.clicked() then
		-- ct.logm("Click at", ct.clickX(), ct.clickY())
	end

	if ct.keyPressed("up") then
		fish.y = fish.y - 1
	elseif ct.keyPressed("down") then
		fish.y = fish.y + 1
	end

	local scale = 1.2
    if ct.charTyped("+") then
    	fish:setSize(fish.width * scale, fish.height * scale)
    elseif ct.charTyped("-") then
        fish:setSize(fish.width / scale, fish.height / scale)
    end

end

function onMousePress(obj, x, y)
	ct.logm("Press event for", obj, x, y)
end

function onCharTyped(ch)
	ct.print(ch)
end

