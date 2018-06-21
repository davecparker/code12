this = {}; _fn = {}   -- This file was generated by Code12 from "KoopaLoopa.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')

-- Koopa Loopa
-- Code12 Programming Concepts 11: Loops
-- An animation of a koopa troopa going down tower of blocks.
-- Press the space bar to start/pause the animation.
-- When the koopa troopa goes off the screen it should loop back
-- to it's starting location.




    
    
        
        
    
    
    this.koopa = nil; 
    this.numberOfLevels = 8
    this.tileSize = 100.0 / 16
    this.yGround = 100 - this.tileSize * 2
    this.paused = true
    
    function start()
        
        -- Make the title and background
        ct.setTitle("Koopa Loopa")
        ct.setBackColorRGB(104, 136, 255)
        ct.image("cloud.png", 25, 25, 19)
        
        -- Make the staircase
        local level = 0; while level < this.numberOfLevels do
            
            local i = 0; while i < this.numberOfLevels + 1 - level do
                
                local block = ct.image("block.png", 100 - i * this.tileSize, this.yGround - level * this.tileSize, this.tileSize)
                block:align("bottom right")
            i = i + 1; end
        level = level + 1; end
        
        -- Make the ground
        local numberOfTiles = ct.toInt(100 / this.tileSize) + 1
        local i = 0; while i < numberOfTiles do
            
            local j = 0; while j < 2 do
                
                local block = ct.image("ground-tile.png", 100 - i * this.tileSize, 100 - j * this.tileSize, this.tileSize)
                block:align("bottom right")
            j = j + 1; end
        i = i + 1; end
        
        -- Make the koopa troopa
        local yStart = this.yGround - this.tileSize * this.numberOfLevels
        this.koopa = ct.image("koopa.png", 100, yStart, this.tileSize)
        this.koopa:align("bottom right")
    end
    
    function update()
        
        if not this.paused then
            
            if this.koopa.x < 0 then
                
                -- Reset koopa to top of staircase
                this.koopa.y = this.yGround - this.tileSize * this.numberOfLevels
                this.koopa.x = 100 + this.koopa.width
            
            else 
                
                -- Calculate the y-value of the step koopa should be on
                local yStep = this.yGround
                local i = 0; while i <= this.numberOfLevels do
                    
                    if this.koopa.x >= 100 - this.tileSize * (2 + i) then
                        
                        yStep = this.yGround - this.tileSize * (this.numberOfLevels - i)
                        break
                    end
                i = i + 1; end
                -- If koopa is above the step, make it fall
                if this.koopa.y < yStep then
                    
                    this.koopa.y = this.koopa.y + 1
                    this.koopa.x = this.koopa.x - (0.1)
                
                else 
                    
                    this.koopa.x = this.koopa.x - 0.2
                end
            end
        end
    end
    
    function onKeyPress(keyName)
        
        if keyName == "space" then
            this.paused = not this.paused; end
    end


