this = {}; _fn = {}   -- This file was generated by Code12 from "UserCode.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    -- instance variables
    this.ball = nil; this.bigBall = nil; 
    -- GameObj tooSoon = ct.circle(50, 50, 50);
    this.count = 0; this.total = 0; 
    this.gameOver = false; 
    this.LIMIT = 120
    -- int count = 5;
    this.speed = 0.3
    
    function start()
        
        -- int oops = count;
        -- double nope = ball.x;
        local x = (10 + 50 * 5 + (45 / 3 * 2)) / 5.0
        local xInt = ct.toInt(x)
        local name = "Dave" .. " " .. "Parker"
        local done = false; 
        
        -- Draw some circles
        this.ball = ct.circle(x + 6, 15, 5)
        ct.circle(ct.intDiv(xInt, 2) + 10, 40, 5)
        this.bigBall = ct.circle(x, 80, 40)
        this.bigBall:setFillColor("blue")
        this.bigBall.clickable = true
        
        -- Add a fish
        ct.image("goldfish.png", 50, 50, 15)
        
        local z = this.ball.x + 1
        if this.ball == this.bigBall or this.bigBall ~= nil then
            z = 2; end
        
        local ok = 9.0 / 5
        local ok2 = 10 / 5
        -- double notOk =  1 / 2;
        --double notOK2 = x / 3;
    end
    
    function update()
        
        local factor = 2
        local name = nil; 
        local tooFast = false; local tooSlow = false; 
        
        -- Move ball
        local xNew = _fn.moveBall(true)
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
    
    function onMousePress(obj, x, y)
        
        if obj ~= nil then
            ct.println(obj:toString() .. " was clicked"); 
        else 
            ct.println("Mouse was pressed at (" .. x .. ", " .. y .. ")"); end
    end
