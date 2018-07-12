this = {}; _fn = {}   -- This file was generated by Code12 from "RandomWalk.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')

-- Random Walk
-- Code12 Programming Concepts 9: Function Definitions
-- An animation of a random walk.
-- Resizing the window restarts the random walk with a larger lattice.

-- Case use test for the following subset of the Code12 API:

-- Screen Management
-- -----------------
-- ct.setTitle( String title )
-- double ct.getWidth( )           // always 100.0
-- double ct.getHeight( )          // default 100.0
-- double ct.getPixelsPerUnit()    // scale factor to convert coordinate units to pixels
-- ct.clearScreen( )
-- ct.setBackColor( String color )

-- Math and Misc.
-- --------------
-- int ct.random( int min, int max )
-- int ct.round( double d )
-- double ct.round( double d, int numPlaces )
-- boolean ct.isError( double d )

-- Type Conversion
-- ---------------
-- int ct.toInt( double d )                // truncates




    
    
        
        
    
    -- TODO: fields where initialized in restart(); causes Code12 runtime to see them as unitialized before use
    this.pixelsPerSquare = 0
    this.xMax = 0.0
    this.yMax = 0.0
    this.pixelsPerUnit = 0.0
    this.unitsPerSquare = 0.0
    this.marker = nil
    this.rowCount = 0
    this.columnCount = 0
    
    function _fn.start()
        
        _fn.restart()
    end
    
    function _fn.update()
        
        -- Choose a random direction
        local direction = nil; 
        local column = ct.toInt(this.marker.x / this.unitsPerSquare + 0.5)
        local row = ct.toInt(this.marker.y / this.unitsPerSquare + 0.5)
        
        if row == 1 and column == 1 then
            
            -- Marker is in top left corner, can move down or right
            local n = ct.random(1, 2)
            if n == 1 then
                direction = "down"; 
            else 
                direction = "right"; end
        
        elseif row == 1 and column == this.columnCount then
            
            -- Marker is in top right corner, can move down or left
            local n = ct.random(1, 2)
            if n == 1 then
                direction = "down"; 
            else 
                direction = "left"; end
        
        elseif row == this.rowCount and column == 1 then
            
            -- Marker is in bottom left corner, can move up or right
            local n = ct.random(1, 2)
            if n == 1 then
                direction = "up"; 
            else 
                direction = "right"; end
        
        elseif row == this.rowCount and column == this.columnCount then
            
            -- Marker is in bottom right corner, can move up or left
            local n = ct.random(1, 2)
            if n == 1 then
                direction = "up"; 
            else 
                direction = "left"; end
        
        elseif row == 1 then
            
            -- Marker is at top of screen (not in a corner), can move down, left, right
            local n = ct.random(1, 3)
            if n == 1 then
                direction = "down"; 
            elseif n == 2 then
                direction = "left"; 
            else 
                direction = "right"; end
        
        elseif row == this.rowCount then
            
            -- Marker is at bottom of screen (not in a corner), can move up, left, right
            local n = ct.random(1, 3)
            if n == 1 then
                direction = "up"; 
            elseif n == 2 then
                direction = "left"; 
            else 
                direction = "right"; end
        
        elseif column == 1 then
            
            -- Marker is at left side of screen (not in a corner), can move up, down, right
            local n = ct.random(1, 3)
            if n == 1 then
                direction = "up"; 
            elseif n == 2 then
                direction = "down"; 
            else 
                direction = "right"; end
        
        elseif column == this.columnCount then
            
            -- Marker is at right side of screen (not in a corner), can move up, down, left
            local n = ct.random(1, 3)
            if n == 1 then
                direction = "up"; 
            elseif n == 2 then
                direction = "down"; 
            else 
                direction = "left"; end
        
        else 
            
            -- Marker can move in any direction.
            local n = ct.random(1, 4)
            if n == 1 then
                direction = "up"; 
            elseif n == 2 then
                direction = "down"; 
            elseif n == 3 then
                direction = "left"; 
            else 
                direction = "right"; end
        end
        
        -- Make marker path line
        local newX = 0; local newY = 0; 
        if (direction == "up") then
            
            newX = this.marker.x
            newY = this.marker.y - this.unitsPerSquare
        
        elseif (direction == "down") then
            
            newX = this.marker.x
            newY = this.marker.y + this.unitsPerSquare
        
        elseif (direction == "left") then
            
            newX = this.marker.x - this.unitsPerSquare
            newY = this.marker.y
        
        else 
            
            newX = this.marker.x + this.unitsPerSquare
            newY = this.marker.y
        end
        local pathLine = ct.line(this.marker.x, this.marker.y, newX, newY, "red")
        local lineWidth = ct.round(this.pixelsPerSquare / 3.0)
        if lineWidth > 0 then
            pathLine.lineWidth = lineWidth; end
        
        -- Move marker
        this.marker.x = newX
        this.marker.y = newY
    end
    
    function _fn.onResize()
        
        -- Clear the screen
        ct.clearScreen()
        
        -- Restart the random walk
        _fn.restart()
    end
    
    function _fn.restart()
        
        -- Set the title
        ct.setTitle("Random Walk")
        
        -- Initialize size variables
        this.pixelsPerSquare = 8
        
        -- Set background
        ct.setBackColor("light yellow")
        
        -- Set the lattice variables
        this.xMax = ct.getWidth()
        this.yMax = ct.getHeight()
        this.pixelsPerUnit = ct.getPixelsPerUnit()
        this.unitsPerSquare = this.pixelsPerSquare / this.pixelsPerUnit
        this.rowCount = ct.toInt(this.yMax / this.unitsPerSquare)
        this.columnCount = ct.toInt(this.xMax / this.unitsPerSquare)
        
        -- Draw horizontal lines
        local i = 0; while i < this.rowCount do
            
            local y = (i + 0.5) * this.unitsPerSquare
            ct.line(0, y, this.xMax, y)
        i = i + 1; end
        -- Draw vertical lines
        local i = 0; while i < this.columnCount do
            
            local x = (i + 0.5) * this.unitsPerSquare
            ct.line(x, 0, x, this.yMax)
        i = i + 1; end
        
        -- Make the walk marker
        local x = (ct.random(1, this.columnCount) - 0.5) * this.unitsPerSquare
        local y = (ct.random(1, this.rowCount) - 0.5) * this.unitsPerSquare
        
        this.marker = ct.circle(x, y, this.unitsPerSquare)
        
        -- Make the start marker
        local startMarker = ct.circle(this.marker.x, this.marker.y, this.unitsPerSquare, "green")
    end
