package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
local ct, this, _fn = require('Code12.ct').getTables()





-- extends Code12Program

-- instance variables
this.fish = nil; this.ball = nil; this.bigBall = nil
-- GameObj[] moreBalls = new GameObj[10];
this.count = 0; this.total = 0
this.gameOver = false

-- More instance variables

this.LIMIT = 120 + 4
this.speed = 0.3
this.frameCount = 0
this.newCount = this.frameCount + 2 *  -this.frameCount
this.str = "Testing" .. tostring(3)

-- public static void main(String[] args)
-- { 
-- 	Code12.run(new StructureTest());
-- }

function _fn.start()

	local X = 50
	local y = 0
	y = X
	ct.rect(X, 10, 50, 10)
	this.ball = ct.circle(X, y, 30)
	this.ball:setFillColor("blue")
	this.frameCount = _fn.foo(this.LIMIT, this.speed * 2)
	ct.println("Program started")
end

function _fn.foo(i, d)

	-- Scanner scanner = new Scanner(System.in);
	i = 8
	return 0
end

function _fn.test(i, d)

	local whILEe = 3
	local z = 0; local y = 0; local w = 0

	i = _fn.foo(3, 4)
	if i < 0 then
		return i + 1
	else

		i = i + (3)
		d = d * (2)
	end

	if d < i then

		i = 0
		d = 1
	else

		i = 1; end

	if d == i then
		d = i
	elseif d < i then
		d =  -i
	else
		return 0
	end
	repeat
		i = i + 1
	until not (i < 0)

	-- return 0;

	d = 13

	while i > 10 do

		i = i - 1
		if i > 10 then
			break
		end; i = i + 1
	end

	d = 24
	d = d * (1.0 - ct.toInt(math.pow(d / d, i)))

	local j = i; while j < 10 do

		d = d + (i)
		i = i - 1; j = j + 1
	end

	i = ct.toInt(math.pi) * _fn.foo(1, 3.1)

	if d == 1 then

		if i < 0 then
			return 0
		else
			return 1
		end
	else
		return 9; end
end

function _fn.update()

	_fn.moveBall(false)
	return 
end

function _fn.onMousePress(obj, x, y)

	ct.logm("Press", obj, x, y)
-- if (obj != null)
-- {
-- 	obj.xSpeed = .1;
-- 	ct.println( obj.toString() + " was clicked" );
-- }
-- else
-- 	ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
end

function _fn.onMouseRelease(obj, x, y)

	ct.logm("Release", obj, x, y)
	if x == 0 then
		return 
	end; end

-- Move the ball
function _fn.moveBall(wrap)

	this.ball.x = this.ball.x + 1
	if wrap then

		local checked = true
		if this.ball.x > 100 then
			this.ball.x = 0
		end; end
	local _in = nil
	return ct.toInt(this.ball.x)
end

function _fn.makeCircles()

	local circles = { length = 10, default = nil }
	-- GameObj goo = new GameObj(10, 20, 30);
	for _, c in ipairs(circles) do
		c:setFillColor("black")
	end; local scores = { 10, 20, 30, length = 3 }
	local ratios = { 0, 1, 2, length = 3 }
	local coins = { nil, ct.indexArray(circles, 1), nil, ct.indexArray(circles, 2), length = 4 }
	return circles
end

require('Code12.api')
require('Code12.runtime').run()
