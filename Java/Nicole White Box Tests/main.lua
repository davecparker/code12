this = {}; _fn = {}   -- This file was generated by Code12 from "LogMethodsWhiteBoxTest.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    this.stationaryCircle = nil; 
    this.varCircle = nil; 
    this.expCircle = nil; 
    this.movingCircle = nil; 
    this.stationaryRect = nil; 
    this.rectangles = nil
    this.line = nil; 
    this.t = nil; 
    this.image = nil; 
    this.movingImage = nil; 
    this.s = nil; 
    
    this.circleOne = nil; 
    this.circleTwo = nil; 
    
    this.tempObj = nil; 
    this.count = 0
    
    
        
        
    
    
    function start()
        
        ct.setTitle("LogMethods, not to be confused with logarithms")
        
        this.s = "test"
        this.stationaryCircle = ct.circle(50, 50, 5)
        this.stationaryRect = ct.rect(75, 75, 10, 10)
        this.line = ct.line(0, ct.getHeight() / 2, ct.getWidth(), ct.getHeight() / 2)
        this.image = ct.image("sprite.png", 90, 10, 10)
        this.movingImage = ct.image("pikachu.png", 90, 90, 10)
        
        this.rectangles = { length = 10 }
        -- Some rectangles stored in an array
        local i = 0; while i < this.rectangles.length do
            
            this.rectangles[1+(i)] = ct.rect(ct.random(10, 100), ct.random(10, 100), 10, 10, "pink")
        i = i + 1; end
        
        -- Objs with variables as params
        local x = 10
        local y = 25
        local diam = 15
        this.varCircle = ct.circle(x, y, diam)
        
        -- Objs with expressions as params
        this.expCircle = ct.circle(x + 10, y * 2, diam / 3, "blue")
        
        -- Moving objs
        this.movingCircle = ct.circle(50, 50, 10, "purple")
        
        -- temporary logged objects
        this.tempObj = ct.rect(10, 10, 10, 10)
        
        -- Two circles in the same position/same size
        this.circleOne = ct.circle(40, 40, 10)
        this.circleTwo = ct.circle(40, 40, 10)
        
        -- Testing logging until a certain event happens
        -- count-controlled:
        repeat
            
            ct.logm("This object will be logged 5 times ", this.tempObj)
            -- java : this will compile + run concatenating
            -- ct.logm("message " + obj )
            this.count = this.count + 1
        
        until not (this.count <= 5)
    end
    
    function update()
        
        this.stationaryCircle:delete()
        -- only clears the screen of the object.
        this.movingCircle.xSpeed = 1
        this.movingImage.ySpeed = -2
        
        if this.movingCircle.x > ct.getWidth() then
            this.movingCircle.x = 0; end
        if this.movingImage.y < 0 then
            this.movingImage.y = ct.getHeight(); end
        
        
        -- Testing logging until logical events occur
        -- ex: start logging circles once movingCircle reaches max height
        if this.movingCircle.y <= 0 then
            _fn.logCircles(); end
        
        _fn.logCircleAlongLine()
        _fn.logRects()
        _fn.logRectArray()
        _fn.logLines()
        _fn.logMultiple()
        _fn.logOverlapping()
        _fn.genText()
        _fn.logText()
        _fn.logImage()
        
    end
    
    function _fn.logCircles()
        
        ct.println("Circle one: ")
        ct.log(this.stationaryCircle)
        ct.println("Circle two: ")
        ct.log(this.varCircle)
        ct.println("Circle three: ")
        ct.log(this.expCircle)
        
        -- Printing with a message using the .toString() method
        ct.println("There is a moving " .. this.movingCircle:toString())
        
        -- Test with public data fields in ct.println()
        ct.println("The moving circle's yPos is " .. this.movingCircle.y)
        ct.println("The moving circle's xPos is " .. this.movingCircle.x)
        ct.println("The moving circle's height is " .. this.movingCircle.height)
        ct.println("The moving circle's width is " .. this.movingCircle.width)
        ct.println("The circle is moving " .. this.movingCircle.xSpeed .. " pixels to the right.")
        
    end
    
    function _fn.logCircleAlongLine()
        
        local xValue = 0; while xValue < ct.getWidth() do
            
            -- Makeshift collsion detection for line
            if this.movingCircle:containsPoint(xValue, ct.getHeight() / 2) then
                ct.println("There is a " .. this.movingCircle:toString() .. " moving along a " .. this.line:toString()); end
            -- Issue? Logs only the most recent position of the circle, even if it continues to move
        xValue = xValue + 1; end
    end
    
    function _fn.logRects()
        
        ct.log(this.stationaryRect)
    end
    
    function _fn.logRectArray()
        
        local i = 0; while i < this.rectangles.length do
            
            ct.log(this.rectangles[1+(i)])
        i = i + 1; end
    end
    
    function _fn.logLines()
        
        ct.log(this.line)
    end
    
    function _fn.logMultiple()
        
        local one = 1
        local two = 2
        local three = 3
        
        ct.log(this.stationaryCircle, this.stationaryRect, this.line)
        -- ct.logm(" one " + stationaryCircle, "two " + stationaryRect, " three " + line );
        --       // The first one is logged as a message (which it should be)
        --       // With the following arguments - 
        --       //    when adding other strings alongside the String representation of a gameObj
        --       //    both those and the gameObj are printed as String literals
        -- 
        --       ct.logm( "one", "two", "three");
        -- Again, when using ct.logm to print, only the first argument is converted internally
        -- rest are represented as String literals
        
        -- Example of a potential use that would be caught as an error (incompatible data types)
        -- ct.logm( one + stationaryCircle, two + stationaryRect, three + line );
    end
    
    function _fn.logOverlapping()
        
        -- Test with two overlapping circles ( both conditions are true )
        if this.circleOne:containsPoint(this.circleTwo.x, this.circleTwo.y) then
            ct.println("Logging the first circle " .. this.circleOne:toString()); end
        if this.circleOne:hit(this.circleTwo) then
            ct.println("Logging the second circle " .. this.circleTwo:toString()); end
    end
    
    function _fn.genText()
        
        local row = 0; while row < ct.getWidth() do
            
            local column = 0; while column < ct.getHeight() do
                
                this.t = ct.text(" Lorem ipsem ", row, column, 5)
            column = column + (20); end
        row = row + (30); end
    end
    
    -- Logging text objects created in the function above
    function _fn.logText()
        
        ct.log(this.t)
        -- Logs the most recently generated text, since there is no reference to the others
    end
    
    function _fn.logImage()
        
        ct.log(this.image)
        ct.logm("There is a moving ", this.movingImage)
    end
    
