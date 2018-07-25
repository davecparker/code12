this = {}; _fn = {}   -- This file was generated by Code12 from "level10.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    --Global variables
    this.updates = 0
    this.screenWidth = 0; 
    this.screenHeight = 0; 
    --Player character
    this.bird = nil; 
    this.flap = "downflap"
    this.filename = nil; 
    this.BIRDHIEGHT = 10
    this.birdX = 0; 
    this.birdY = 0; 
    --Score
    this.score = nil; 
    this.scoreX = 0; 
    this.scoreY = 0; 
    --Background
    this.back1 = nil; 
    this.back2 = nil; 
    --Ground
    this.ground1 = nil; 
    this.ground2 = nil; 
    this.ground3 = nil; 
    
    
        
        
    
    
    function _fn.start()
        
        --sets the height of the sceen to match the height of the background
        this.screenHeight = 128
        ct.setHeight(this.screenHeight)
        this.screenWidth = ct.getWidth()
        
        this.back1 = ct.image("background-day.png", this.screenWidth / 2, this.screenHeight / 2, this.screenWidth)
        this.back2 = ct.image("background-day.png", 1.5 * this.screenWidth, this.screenHeight / 2, this.screenWidth)
        
        this.back1.xSpeed = -1
        this.back2.xSpeed = -1
        
        --draws the bird ct.image("filename", x, y, h)
        this.birdX = this.screenWidth / 2.0
        this.birdY = this.screenHeight / 2.0
        --height of the bird (the height of the bird)
        this.bird = ct.image("yellowbird-downflap.png", this.birdX, this.birdY, this.BIRDHIEGHT)
        
        --draws the count
        --the value of x does not change (the x position of the bird and number are equal)
        this.scoreY = this.screenHeight / 8.0
        this.scoreX = this.birdX
        this.score = ct.image("0.png", this.scoreX, this.scoreY, 5)
        
        --draws the ground
        local y = 122
        local h = 40
        --since the x position of each piece of the base is different it is not useful to use a variable
        ct.image("base.png", 20, y, h)
        ct.image("base.png", 60, y, h)
        ct.image("base.png", 100, y, h)
    end
    
    function _fn.update()
        
        --Handles the animation of the 
        this.updates = this.updates + 1
        local changed = false
        if this.updates == 10 then
            
            if (this.flap == "downflap") and not changed then
                
                this.flap = "midflap"
                changed = true
            end
            
            if (this.flap == "midflap") and not changed then
                
                this.flap = "upflap"
                changed = true
            end
            
            if (this.flap == "upflap") and not changed then
                
                this.flap = "downflap"
                changed = true
            end
            
            this.filename = "yellowbird-" .. this.flap .. ".png"
            
            this.birdX = this.bird.x
            this.birdY = this.bird.y
            this.bird:delete()
            this.bird = ct.image(this.filename, this.birdX, this.birdY, this.BIRDHIEGHT)
            this.updates = 0
        end
        
        if this.back1.x == -(this.screenWidth / 2) then
            
            this.back1.x = 1.5 * this.screenWidth
        end
        
        if this.back2.x == -(this.screenWidth / 2) then
            
            this.back2.x = 1.5 * this.screenWidth
        end
    end
    
