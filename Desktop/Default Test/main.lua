this = {}; _fn = {}   -- This file was generated by Code12 from "UserCode.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    -- instance variables
    this.ball = nil; this.bigBall = nil; 
    this.moreBalls = { length = 10, default = nil }
    -- GameObj tooSoon = ct.circle(50, 50, 50);
    this.count = 0; this.total = 0; 
    this.gameOver = false
    this.LIMIT = 120
    -- int count = 5;
    this.speed = 0.3
    this.frameCount = 0
    this._function = "Test"
    
    function _fn.start()
        
        -- int oops = count;
        -- double nope = ball.x;
        -- ct.circle(50, 50, LIMIT);
        local x = (10 + 50 * 5 + (45 / 3 * 2)) / 5.0
        local xInt = ct.toInt(x)
        local name = "Dave" .. " " .. "Parker"
        local done = false; local _end = false; 
        -- boolean _end = false;
        -- int $java = 5;
        _end = true
        
        local nums = { length = 10, default = 0 }
        -- nums[10] = 4;
        -- ct.println( nums[10] );
        
        -- Try some console output
        ct.println(this._function)
        ct.println("This is the default Code12 test app")
        ct.println("This is console output")
        ct.print("Beginning of line")
        ct.print(" - Middle - ")
        ct.println("End")
        ct.print("This\nis\nmultiple\nlines")
        ct.print(" of text")
        ct.println( "" )
        ct.println("Here's a blank line:")
        ct.print("\n")
        ct.print("And another:")
        ct.println("\n")
        ct.print("Here's an unitialized GameObj: ")
        ct.println(ct.indexArray(this.moreBalls, 3))
        ct.println("Done")
        local test = false
        if test then
            
            this.count = ct.inputInt("Enter count:")
            local i = 1; while i <= this.count do
                
                ct.println("Line " .. i)
            i = i + 1; end
        end
        
        -- Draw some circles
        this.ball = ct.circle(x + 6, 15, 5)
        ct.circle(ct.intDiv(xInt, 2) + 10, 40, 5)
        this.bigBall = ct.circle(x, 80, 40)
        -- bigBall.setFillColorRGB(400, 127, -50);
        this.bigBall:setFillColor(nil)
        this.bigBall.clickable = true
        
        -- Add a fish
        ct.image("goldfish.png", 50, 50, 15)
        local filename = nil
        -- ct.image(filename, 50, 20, 15);
        
        -- Make a line
        local line1 = ct.line(20, 80, 80, 80, "red")
        line1:setLineColor("MAGENTA")
        line1:setFillColor("red")
        
        local z = this.ball.x + 1
        if this.ball == this.bigBall or this.bigBall ~= nil then
            z = 2; end
        
        local ok = 9.0 / 5
        local ok2 = 10 / 5
        -- double notOk =  1 / 2;
        --double notOK2 = x / 3;
    end
    
    function _fn.update()
        
        local factor = 2
        local name = nil; 
        local tooFast = false; local tooSlow = false; 
        
        -- frameCount++;
        -- if (frameCount < 100)
        --     ct.println(ct.getTimer());
        
        -- Move ball
        local xNew = _fn.moveBall(true)
        xNew = xNew + 1
        _fn.moveBall(false)
        
        -- Move bigBall
        factor = factor + 0
        this.bigBall.x = this.bigBall.x + (this.speed)
        if this.bigBall.x > this.LIMIT then
            
            local localX = 1.1 + 5
            this.bigBall.x = this.bigBall.x - 1
            this.bigBall.width = this.bigBall.width / (factor)
            this.bigBall.height = this.bigBall.height * ((1 / factor))
            this.speed = -this.speed
        
        elseif this.bigBall.x < 0 then
            this.speed = -this.speed; 
        else 
            
            local localX = 3
        end
    end
    
    -- Move the ball
    function _fn.moveBall(wrap)
        
        -- int wrap = 5;
        local hack = false; 
        -- String hack;
        
        -- hack = 6;
        this.ball.x = this.ball.x + 1
        this.ball.x = this.ball.x - 1
        this.ball.x = this.ball.x + (0.5)
        if wrap and this.ball.x >= this.LIMIT then
            this.ball.x = 0; end
        
        this.ball.x = this.ball.x - 1
        this.ball.x = this.ball.x + 1
        return this.ball.x
    end
    
    function _fn.onMousePress(obj, x, y)
        
        if obj ~= nil then
            ct.println(obj:toString() .. " was clicked"); 
        else 
            ct.println("Mouse was pressed at (" .. x .. ", " .. y .. ")"); end
    end
    
    function _fn.loopAndArrayTest()
        
        while not this.gameOver do
            
            this.speed = this.speed + (3)
            if this.speed > 10 then
                break; end
        end
        while this.speed < 3 do
            this.speed = this.speed + 1; end
        
        repeat
            this.speed = this.speed - 1; 
        until not (this.speed > 4)
        
        repeat
            
            this.speed = this.speed + (3)
            this.speed = this.speed - 1
        
        until not (this.speed < 2)
        
        local scores = { length = 10, default = 0 }
        local questions = { length = 20, default = false }
        local strings = { length = 5, default = nil }
        
        local counts = { 2, 4, 5 + 6, 3, length = 4, default = 0 }
        local c = ct.indexArray(counts, 0)
        
        local sum = 0
        for _, cnt in ipairs(counts) do
            sum = sum + (cnt); end
        
        for _, score in ipairs(scores) do
            
            sum = sum + (ct.toInt(score))
        end
        
        while true do
            
            sum = sum + (ct.indexArray(counts, c))
        end
        
        local i = 0; while i < counts.length do
            sum = sum + (ct.indexArray(counts, i)); i = i + 1; end
        
        local aTest = nil; 
        aTest = { length = 10, default = 0 }
        local as = nil; local bs = nil; local cs = nil; 
        
        as = { length = 10, default = nil }
        local myX = ct.indexArray(as, 4).x
        ct.checkArrayIndex(as, sum - 1); as[1+(sum - 1)].y = myX
        as = _fn.makeCircles()
        
        -- int [] ai = { 1, 2, 3.3 };
        local ad = { 1.1, 2.2, 0, length = 3, default = 0 }
        
        _fn._local()
    end
    
    function _fn._local()
        
    end
    
    function _fn.makeCircles()
        
        local circles = { length = 10, default = nil }
        return circles
    end
    
    function _fn.onKeyPress(key)
        
        if (key == "b") then
            ct.println("b was pressed"); 
        elseif string.len(key) > 1 then
            ct.println("Long key"); end
        
        local s = "  Dave "
        ct.println(ct.stringCompare(s, "Parker"))
        ct.log(s, ct.trimString(s), string.upper(s), ct.substring(s, 2), ct.substring(s, 2, 6), ct.indexOfString(s, "D"))
        
        -- Some common errors:
        -- if (speed = 0)
        --     ct.println("Still");
        
        -- if (key == "n")
        --     ct.print("n key");        
    end
