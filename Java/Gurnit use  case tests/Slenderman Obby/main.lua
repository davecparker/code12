this = {}; _fn = {}   -- This file was generated by Code12 from "MainProgram.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    this.blockRect = nil; this.rect1 = nil; this.rect2 = nil; this.rect3 = nil; this.circle = nil; this.blueRect = nil; this.redRect = nil; this.pinkRect = nil; this.deathBlock = nil; this.slider1 = nil; this.slider2 = nil; this.bar = nil; this.healthBar = nil; this.barText = nil; this.slenderman = nil; this.checkpoint = nil; 
    this.width = 0; this.height = 0; 
    
    
        
        
    
    function start()
        
        this.width = ct.getWidth()
        this.height = ct.getHeight()
        
        --winner screen
        ct.setScreen("win")
        ct.setBackImage("winner.jpg")
        ct.text("you win..", 50, 90, 10, "red")
        
        --Game over screen
        ct.setScreen("end")
        ct.setBackColor("black")
        ct.text("GAME OVER", 50, 50, 10, "red")
        
        --start screen
        ct.setScreen("start")
        
        --health bar
        this.bar = ct.rect(80, 10, 30, 2, "white")
        this.healthBar = ct.rect(65, 10, 30, 2, "green")
        this.healthBar:align("left")
        this.barText = ct.text("HEALTH", 87, 5, 5, "black")
        
        --obby course    
        this.rect1 = ct.rect(this.width / 10, this.height / 10 * 6, 10, 60, "black")
        this.rect2 = ct.rect(this.width / 3, this.height / 8, 43, 10, "black")
        this.rect3 = ct.rect(this.width / 2, this.height / 10 * 5, 9.5, 70, "black")
        this.slider1 = ct.rect(this.width / 3, this.height / 2.8, 10, 1, "black")
        this.slider2 = ct.rect(this.width / 3, this.height / 10 * 6, 10, 1, "black")
        this.deathBlock = ct.rect(this.width / 10 * 8, this.height / 10 * 6, 50, 30, "white")
        this.deathBlock:setLineColor("white")
        
        this.blueRect = ct.rect(this.width / 2 * 1.5, this.height / 10 * 5, 15, 10, "blue")
        this.redRect = ct.rect(this.width / 2 * 1.5, this.height / 10 * 6, 15, 10, "red")
        this.pinkRect = ct.rect(this.width / 2 * 1.5, this.height / 10 * 7, 15, 10, "pink")
        this.blueRect:setLineColor("blue")
        this.redRect:setLineColor("red")
        this.pinkRect:setLineColor("pink")
        
        this.slider1.xSpeed = -1
        this.slider2.xSpeed = 1
        this.blueRect.xSpeed = 2
        this.redRect.xSpeed = -1.5
        this.pinkRect.xSpeed = 1
        
        --player
        this.slenderman = ct.image("slender.png", this.width / 15, this.height / 10, 10)
        --checkpoint
        this.checkpoint = ct.image("flag.png", this.width / 10 * 8, this.height / 10 * 2, 20)
    end
    function update()
        
        -- moving slenderman   
        if ct.keyPressed("up") then
            
            this.slenderman.y = this.slenderman.y - (1)
        end
        if ct.keyPressed("down") then
            
            this.slenderman.y = this.slenderman.y + (1)
        end
        if ct.keyPressed("right") then
            
            this.slenderman.x = this.slenderman.x + (1)
        end
        if ct.keyPressed("left") then
            
            this.slenderman.x = this.slenderman.x - (1)
        end
        -- moving blue, pink, and red tiles
        if this.blueRect.x < 65 then
            
            this.blueRect.xSpeed = 1
        
        elseif this.blueRect.x > 95 then
            
            this.blueRect.xSpeed = -1
        end
        if this.pinkRect.x < 70 then
            
            this.pinkRect.xSpeed = 1
        
        elseif this.pinkRect.x > 95 then
            
            this.pinkRect.xSpeed = -1
        end
        if this.redRect.x < 60 then
            
            this.redRect.xSpeed = 1
        
        elseif this.redRect.x > 100 then
            
            this.redRect.xSpeed = -1
        end
        --sliders moving back and forth
        if this.slider1:hit(this.rect1) or this.slider1:hit(this.rect3) then
            this.slider1.xSpeed = -this.slider1.xSpeed; end
        
        if this.slider2:hit(this.rect1) or this.slider2:hit(this.rect3) then
            this.slider2.xSpeed = -this.slider2.xSpeed; end
        
        --switches to game over screen if slenderman touches death block or the black sliders
        if (this.slenderman:hit(this.deathBlock) or this.slenderman:hit(this.slider1) or this.slenderman:hit(this.slider2)) and not ((this.slenderman:hit(this.pinkRect)) or (this.slenderman:hit(this.redRect)) or (this.slenderman:hit(this.blueRect))) then
            ct.setScreen("end"); end
        --checks if slenderman hit any of the rectangles or the invisible deathblock
        if this.slenderman:hit(this.rect1) or this.slenderman:hit(this.rect2) or this.slenderman:hit(this.rect3) or this.slenderman:hit(this.slider1) or this.slenderman:hit(this.slider2) then
            this.healthBar.width = this.healthBar.width - (0.5); end
        -- colored tiles stop moving if touched               
        if this.slenderman:hit(this.pinkRect) then
            this.pinkRect.xSpeed = 0; end
        if this.slenderman:hit(this.redRect) then
            this.redRect.xSpeed = 0; end
        if this.slenderman:hit(this.blueRect) then
            this.blueRect.xSpeed = 0; end
        
        if this.slenderman:hit(this.checkpoint) then
            ct.setScreen("win"); end
        
        if this.healthBar.width <= 0 then
            ct.setScreen("end"); end
    end
