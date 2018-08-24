this = {}; _fn = {}   -- This file was generated by Code12 from "SimplePlatformer.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    this.background = nil; 
    this.playerLeft = nil; 
    this.playerRight = nil; 
    this.platforms = nil; 
    this.items = nil; 
    this.clouds = nil; 
    this.ladder = nil; 
    this.gravity = 0.5
    this.onGround = true
    
    
    this.isJumping = false   --Is the player in a jump?
    this.wasJumping = false   --Did the player just exit a jump?
    this.jumpTime = 0   --Time the player has been in a jump (Useful for adding a power curve or to max out on jump height)
    
    this.maxJumpTime = .8   --If you want to max out a jump, otherwise remove the relevant parts of the code
    this.jumpLaunchVelocity = -3000.0   --How
    
    
        
        
    
    
    function _fn.start()
        
        
        local width = ct.getWidth()
        local height = ct.getHeight()
        
        this.platforms = { length = 15, default = nil }
        
        ct.setBackColorRGB(0, 100, 100)
        
        -- Background objects in the game
        local tree = ct.image("tree.png", 15, height - 14, 15)
        tree:setLayer(0)
        
        local sun = ct.image("sun.png", width - 10, 10, 10)
        this.clouds = { length = 5, default = nil }
        ct.checkArrayIndex(this.clouds, 0); this.clouds[1+(0)] = ct.image("cloud3.png", -35, 10, 20)
        ct.checkArrayIndex(this.clouds, 1); this.clouds[1+(1)] = ct.image("cloud2.png", -15, 20, 25)
        ct.checkArrayIndex(this.clouds, 2); this.clouds[1+(2)] = ct.image("cloud1.png", 20, 10, 20)
        ct.checkArrayIndex(this.clouds, 3); this.clouds[1+(3)] = ct.image("cloud2.png", 50, 30, 25)
        ct.checkArrayIndex(this.clouds, 4); this.clouds[1+(4)] = ct.image("cloud3.png", 30, 20, 20)
        
        -- Platforms, platforms[0] is the ground
        ct.checkArrayIndex(this.platforms, 0); this.platforms[1+(0)] = ct.rect(width / 4, height, 40, 10, "dark green")
        ct.checkArrayIndex(this.platforms, 1); this.platforms[1+(1)] = ct.rect(30, height - 10, 20, 10, "dark green")
        ct.checkArrayIndex(this.platforms, 2); this.platforms[1+(2)] = ct.rect(60, height - 20, 25, 20, "dark green")
        ct.checkArrayIndex(this.platforms, 3); this.platforms[1+(3)] = ct.rect(90, height - 20, 15, 10, "orange")
        ct.checkArrayIndex(this.platforms, 4); this.platforms[1+(4)] = ct.rect(110, height - 10, 10, 10, "orange")
        ct.checkArrayIndex(this.platforms, 5); this.platforms[1+(5)] = ct.rect(130, height - 15, 20, 10, "orange")
        ct.checkArrayIndex(this.platforms, 6); this.platforms[1+(6)] = ct.rect(155, height - 20, 10, 10, "orange")
        ct.checkArrayIndex(this.platforms, 7); this.platforms[1+(7)] = ct.rect(175, height - 25, 20, 20, "orange")
        ct.checkArrayIndex(this.platforms, 8); this.platforms[1+(8)] = ct.rect(190, height - 45, 15, 15, "orange")
        ct.checkArrayIndex(this.platforms, 9); this.platforms[1+(9)] = ct.rect(175, 35, 10, 2, "yellow")
        ct.checkArrayIndex(this.platforms, 10); this.platforms[1+(10)] = ct.rect(155, 25, 10, 15, "yellow")
        ct.checkArrayIndex(this.platforms, 11); this.platforms[1+(11)] = ct.rect(135, 15, 15, 20, "yellow")
        
        this.ladder = ct.image("ladder.png", 135, 0, 10)
        
        -- TODO: solid platforms
        -- use variables to store your old location and sends you back there if there is a wall collision.
        -- or where the player rectangle OVERLAPS with platform rect
        -- while ( player != colliding with platform) ? 
        
        
        -- Two "twin" players (one facing left, one facing right)
        -- Only one is visible at a time
        this.playerLeft = ct.image("stickmanleft.png", 10, 10, 8)
        this.playerLeft.visible = false
        this.playerRight = ct.image("stickmanright.png", 10, 10, 8)
        
        
        
        
        
        
        
    end
    
    function _fn.update()
        
        local width = ct.getWidth()
        local height = ct.getHeight()
        
        -- Using ct.setScreenOrigin to adjust viewpoint of the "world"
        
        -- Moving the origin to the left
        --if ( playerRight.x < 100 || playerLeft.x  < 100 )
        --ct.setScreenOrigin(-100,0);
        
        -- Moving the origin to the right
        if this.playerRight.x > 100 or this.playerLeft.x > 100 then
            ct.setScreenOrigin(100, 0); end
        if this.playerRight.x > 200 or this.playerLeft.x > 200 then
            ct.setScreenOrigin(200, 0); end
        
        -- Move the origin upwards
        if this.playerRight.y <= 0 or this.playerLeft.y <= 0 then
            ct.setScreenOrigin(100, 100); end
        
        if this.playerRight.y >= height then
            
            ct.clearScreen()
            ct.println("You died!")
        end
        
        -- Simple gravity mechanics
        this.playerRight.ySpeed = this.playerRight.ySpeed + (this.gravity)
        this.playerLeft.ySpeed = this.playerLeft.ySpeed + (this.gravity)
        
        this.playerRight.x = this.playerRight.x + (this.playerRight.xSpeed)
        this.playerLeft.x = this.playerLeft.x + (this.playerLeft.xSpeed)
        
        this.playerRight.y = this.playerRight.y + (this.playerRight.ySpeed)
        this.playerLeft.y = this.playerLeft.y + (this.playerLeft.ySpeed)
        
        for _, platform in ipairs(this.platforms) do
            
            -- Check to see if player hit a platform
            if this.playerRight:hit(platform) or this.playerLeft:hit(platform) then
                
                this.playerRight.ySpeed = 0.0
                this.playerLeft.ySpeed = 0.0
                -- so we've established that the player collided with a platform, but from which side?
                local from = _fn.hitFrom(this.playerLeft)
                
                -- if hit from top of platform, this occurs
                if this.playerRight.y < (platform.y - platform.height / 2) or this.playerLeft.y < (platform.y - platform.height / 2) then
                    
                    
                    this.playerRight.y = platform.y - (platform.height / 2 + this.playerRight.height / 2)
                    this.playerLeft.y = platform.y - (platform.height / 2 + this.playerLeft.height / 2)
                    this.onGround = true
                
                elseif (from == "bottom") then
                    
                    _fn.endJump()
                    
                -- reverse player's direction if collision with the side of a platform
                elseif (from == "left") then
                    
                    this.playerLeft.visible = false
                    this.playerRight.visible = true
                    
                    this.playerLeft.x = platform.x + platform.width
                    this.playerRight.x = platform.x + platform.width
                    
                
                elseif (from == "right") then
                    
                    this.playerRight.visible = false
                    this.playerLeft.visible = true
                    
                    this.playerLeft.x = platform.x - platform.width
                    this.playerRight.x = platform.x - platform.width
                end
            end
        end
        
        if this.playerRight:hit(this.ladder) or this.playerLeft:hit(this.ladder) then
            
            this.playerRight.ySpeed = -0.25
            this.playerLeft.ySpeed = -0.25
            
            if this.playerRight.y <= 0 then
                
                this.playerRight.ySpeed = 0
                this.playerLeft.ySpeed = 0
            end
            
        end
        
    end
    -- Collision detection to detect from which side the rectangle collision occurred
    -- Minkowski sum of the two original rectangles (A and B), 
    -- which is a new rectangle, and then checks where the center
    -- of A lies relatively that new rectangle
    -- (to know whether a collision is happening) 
    -- and to its diagonals (to know where the collision is happening):
    
    function _fn.hitFrom(player)
        
        for _, platform in ipairs(this.platforms) do
            
            -- Detect whether the collision between player and platform occurred 
            -- from the right, left, top, or bottom
            local w = 0.5 * (player.width + platform.width)
            local h = 0.5 * (player.height + platform.height)
            local dx = player.x - platform.x
            local dy = player.y - platform.y
            
            if math.abs(dx) <= w and math.abs(dy) <= h then
                
                -- collision has occurred
                local wy = w * dy
                local hx = h * dx
                if wy > hx then
                    
                    if wy > -hx then
                        
                        --ct.println("collsion from bottom");
                        return "bottom"
                    
                    else 
                        
                        ct.println("collsion from right")
                        return "right"
                    end
                
                else 
                    
                    if wy > -hx then
                        
                        ct.println("collision from left")
                        return "left"
                    
                    else 
                        
                        --ct.println("collison from top");
                        return "top"
                    end
                end
            end
        end
        
    end
    
    function _fn.startJump()
        
        if this.onGround then
            
            this.playerRight.ySpeed = -6.0
            this.playerLeft.ySpeed = -6.0
            
            this.playerRight.xSpeed = 1.5
            this.playerLeft.xSpeed = 1.5
            
            this.onGround = false
        end
    end
    
    function _fn.endJump()
        
        if this.playerRight.ySpeed < -3.0 or this.playerLeft.ySpeed < -3.0 then
            
            this.playerRight.ySpeed = -3.0
            this.playerLeft.ySpeed = -3.0
            this.playerRight.xSpeed = 0
            this.playerLeft.xSpeed = 0
        end
    end
    
    
    
    
    function _fn.onKeyRelease(keyName)
        
        if (keyName == "left") then
            
            this.playerRight.xSpeed = 0
            this.playerLeft.xSpeed = 0
        end
        
        if (keyName == "right") then
            
            this.playerRight.xSpeed = 0
            this.playerLeft.xSpeed = 0
        end
    end
    
    
    function _fn.onKeyPress(keyName)
        
        
        if (keyName == "space") then
            
            _fn.startJump()
            ct.sound("retro_jump.wav")
            _fn.endJump()
            --isJumping = true;
            --playerRight.ySpeed = doJump(playerRight.ySpeed, ct.getTimer() );
            
        end
        
        if (keyName == "left") then
            
            this.playerRight.visible = false
            this.playerLeft.visible = true
            this.playerRight.xSpeed = this.playerRight.xSpeed - (1)
            this.playerLeft.xSpeed = this.playerLeft.xSpeed - (1)
        end
        
        if (keyName == "right") then
            
            this.playerRight.visible = true
            this.playerLeft.visible = false
            this.playerRight.xSpeed = this.playerRight.xSpeed + (1)
            this.playerLeft.xSpeed = this.playerLeft.xSpeed + (1)
            local i = 0; while i < this.clouds.length do
                
                ct.checkArrayIndex(this.clouds, i); this.clouds[1+(i)].xSpeed = ct.indexArray(this.clouds, i).xSpeed + (0.001)
                
            i = i + 1; end
        end
        
    end



