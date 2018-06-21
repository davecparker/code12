this = {}; _fn = {}   -- This file was generated by Code12 from "Zelda.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')

-- Zelda
-- Case use for ct.getScreen(), ct.setScreen(), and using ct.distance() for hit testing.



    
    
        
        
    
    
    this.screenWidth = 0; this.screenHeight = 0; 
    this.link = nil; 
    this.zelda = nil; 
    this.linkWidth = 0; 
    this.wallWidth = 0; 
    this.linkSpeed = 0; 
    this.xMin = 0; 
    this.xMax = 0; 
    this.yMin = 0; 
    this.yMax = 0; 
    this.treasuresRemaining = 0; 
    
    this.greenObjs = nilthis.orangeObjs = nilthis.blueObjs = nilthis.yellowObjs = nilthis.redObjs = nil
    
    function start()
        
        ct.setHeight(150)
        this.screenWidth = ct.getWidth()
        this.screenHeight = ct.getHeight()
        
        this.linkWidth = 10
        this.wallWidth = 5
        this.linkSpeed = 2
        this.treasuresRemaining = 4
        local doorSize = 20
        local treasureWidth = 10
        local treasureMargin = this.wallWidth + treasureWidth / 2
        local wallColor = "light gray"
        
        local roomColor = nil; local doorColor = nil; 
        local leftWall = nil; local rightWall = nil; local topWall = nil; local bottomWall = nil; 
        local wall = nil; local door = nil; local treasure = nil; 
        local treasureX = 0; local treasureY = 0; 
        local objsCount = 0; 
        
        -- Make green room --------------------------------------------------------------------------------
        roomColor = "green"
        ct.setScreen(roomColor)
        ct.setBackColor(roomColor)
        
        -- Make walls
        leftWall = ct.rect(this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        rightWall = ct.rect(this.screenWidth - this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        topWall = ct.rect(this.screenWidth / 2, this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        bottomWall = ct.rect(this.screenWidth / 2, this.screenHeight - this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        
        -- Initialize greenObjs
        this.greenObjs = { length = 5 }
        objsCount = 0
        
        -- Make doors
        -- orange door on top wall
        doorColor = "orange"
        wall = topWall
        door = ct.rect(wall.x, wall.y, doorSize, this.wallWidth, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.greenObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- blue door on right wall
        doorColor = "blue"
        wall = rightWall
        door = ct.rect(wall.x, wall.y, this.wallWidth, doorSize, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.greenObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- yellow door on bottom wall
        doorColor = "yellow"
        wall = bottomWall
        door = ct.rect(wall.x, wall.y, doorSize, this.wallWidth, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.greenObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- red door on left wall
        doorColor = "red"
        wall = leftWall
        door = ct.rect(wall.x, wall.y, this.wallWidth, doorSize, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.greenObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- Make treasure in center of room
        treasureX = ct.random(ct.round(treasureMargin), ct.round(this.screenWidth - treasureMargin))
        treasureY = ct.random(ct.round(treasureMargin), ct.round(this.screenHeight - treasureMargin))
        treasure = ct.image("treasure.png", treasureX, treasureY, treasureWidth)
        treasure.group = "treasure"
        treasure:setText(roomColor)
        this.greenObjs[1+(objsCount)] = treasure
        objsCount = objsCount + 1
        
        -- Make orange room --------------------------------------------------------------------------------
        roomColor = "orange"
        ct.setScreen(roomColor)
        ct.setBackColor(roomColor)
        
        -- Make walls
        leftWall = ct.rect(this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        rightWall = ct.rect(this.screenWidth - this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        topWall = ct.rect(this.screenWidth / 2, this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        bottomWall = ct.rect(this.screenWidth / 2, this.screenHeight - this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        
        -- Initialize orangeObjs[]
        this.orangeObjs = { length = 2 }
        objsCount = 0
        
        -- Make doors     
        -- green door on bottom wall
        doorColor = "green"
        wall = bottomWall
        door = ct.rect(wall.x, wall.y, doorSize, this.wallWidth, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.orangeObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- Make treasure in center of room
        treasureX = ct.random(ct.round(treasureMargin), ct.round(this.screenWidth - treasureMargin))
        treasureY = ct.random(ct.round(treasureMargin), ct.round(this.screenHeight - treasureMargin))
        treasure = ct.image("treasure.png", treasureX, treasureY, treasureWidth)
        treasure.group = "treasure"
        treasure:setText(roomColor)
        this.orangeObjs[1+(objsCount)] = treasure
        objsCount = objsCount + 1
        
        -- Make blue room --------------------------------------------------------------------------------
        roomColor = "blue"
        ct.setScreen(roomColor)
        ct.setBackColor(roomColor)
        
        -- Make walls
        leftWall = ct.rect(this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        rightWall = ct.rect(this.screenWidth - this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        topWall = ct.rect(this.screenWidth / 2, this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        bottomWall = ct.rect(this.screenWidth / 2, this.screenHeight - this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        
        -- Initialize blueObjs[]
        this.blueObjs = { length = 2 }
        objsCount = 0
        
        -- Make doors
        -- green door on left wall
        doorColor = "green"
        wall = leftWall
        door = ct.rect(wall.x, wall.y, this.wallWidth, doorSize, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.blueObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- Make treasure in center of room
        treasureX = ct.random(ct.round(treasureMargin), ct.round(this.screenWidth - treasureMargin))
        treasureY = ct.random(ct.round(treasureMargin), ct.round(this.screenHeight - treasureMargin))
        treasure = ct.image("treasure.png", treasureX, treasureY, treasureWidth)
        treasure.group = "treasure"
        treasure:setText(roomColor)
        this.blueObjs[1+(objsCount)] = treasure
        objsCount = objsCount + 1
        
        -- Make yellow room --------------------------------------------------------------------------------
        roomColor = "yellow"
        ct.setScreen(roomColor)
        ct.setBackColor(roomColor)
        
        -- Make walls
        leftWall = ct.rect(this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        rightWall = ct.rect(this.screenWidth - this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        topWall = ct.rect(this.screenWidth / 2, this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        bottomWall = ct.rect(this.screenWidth / 2, this.screenHeight - this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        
        -- Initialize yellowObjs[]
        this.yellowObjs = { length = 2 }
        objsCount = 0
        
        -- Make doors
        -- green door on top wall
        doorColor = "green"
        wall = topWall
        door = ct.rect(wall.x, wall.y, doorSize, this.wallWidth, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.yellowObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- Make treasure in center of room
        treasureX = ct.random(ct.round(treasureMargin), ct.round(this.screenWidth - treasureMargin))
        treasureY = ct.random(ct.round(treasureMargin), ct.round(this.screenHeight - treasureMargin))
        treasure = ct.image("treasure.png", treasureX, treasureY, treasureWidth)
        treasure.group = "treasure"
        treasure:setText(roomColor)
        this.yellowObjs[1+(objsCount)] = treasure
        objsCount = objsCount + 1
        
        -- Make red room --------------------------------------------------------------------------------
        roomColor = "red"
        ct.setScreen(roomColor)
        ct.setBackColor(roomColor)
        
        -- Make walls
        leftWall = ct.rect(this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        rightWall = ct.rect(this.screenWidth - this.wallWidth / 2, this.screenHeight / 2, this.wallWidth, this.screenHeight, wallColor)
        topWall = ct.rect(this.screenWidth / 2, this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        bottomWall = ct.rect(this.screenWidth / 2, this.screenHeight - this.wallWidth / 2, this.screenWidth, this.wallWidth, wallColor)
        
        -- Initialize redObjs[]
        this.redObjs = { length = 1 }
        objsCount = 0
        
        -- Make doors
        -- green door on right wall
        doorColor = "green"
        wall = rightWall
        door = ct.rect(wall.x, wall.y, this.wallWidth, doorSize, doorColor)
        door.group = "door"
        door:setText(doorColor)
        this.redObjs[1+(objsCount)] = door
        objsCount = objsCount + 1
        
        -- Make Link
        this.link = ct.image("link.png", this.screenWidth / 2, this.screenHeight / 2, this.linkWidth)
        
        -- Set bounds for Link's x and y values
        this.xMin = this.link.width / 2 + this.wallWidth
        this.xMax = this.screenWidth - (this.link.width / 2 + this.wallWidth)
        this.yMin = this.link.height / 2 + this.wallWidth
        this.yMax = this.screenHeight - (this.link.height / 2 + this.wallWidth)
    end
    
    function update()
        
        local screenName = ct.getScreen()
        local screenObjs = nil
        
        if screenName:equals("green") then
            
            screenObjs = this.greenObjs
        
        elseif screenName:equals("orange") then
            
            screenObjs = this.orangeObjs
        
        elseif screenName:equals("blue") then
            
            screenObjs = this.blueObjs
        
        elseif screenName:equals("yellow") then
            
            screenObjs = this.yellowObjs
        
        else 
            
            screenObjs = this.redObjs
        end
        
        local numObjs = screenObjs.length
        local noHits = true
        
        local i = 0; while i < numObjs and noHits do
            
            local obj = screenObjs[1+(i)]
            
            local horizDist = ct.distance(this.link.x, 0, obj.x, 0)
            local vertDist = ct.distance(0, this.link.y, 0, obj.y)
            local horizHitDist = (this.link.width + obj.width) / 2
            local vertHitDist = (this.link.height + obj.height) / 2
            if obj.visible and (horizDist < horizHitDist and vertDist < vertHitDist) then
                
                noHits = false
                local group = obj.group
                local objText = obj:getText()
                ct.println(objText .. " " .. group .. " hit")
                
                if group:equals("treasure") then
                    
                    obj.visible = false
                    this.treasuresRemaining = this.treasuresRemaining - 1
                    if this.treasuresRemaining == 0 then
                        
                        -- Make Zelda appear
                        local sign = 0; 
                        if this.link.x < 100 - this.link.x then
                            
                            -- Link is closer to the left wall, put Zelda on his right
                            sign = 1
                        
                        else 
                            
                            -- Put Zelda on his left
                            sign = -1
                        end
                        local zeldaX = this.link.x + sign * this.link.width
                        local zeldaY = this.link.y
                        this.zelda = ct.image("zelda.png", zeldaX, zeldaY, this.link.width)
                    end
                
                elseif group:equals("door") then
                    
                    -- Save Link's data and delete him
                    local xSpeed = this.link.xSpeed
                    local ySpeed = this.link.ySpeed
                    local x = this.link.x
                    local y = this.link.y
                    this.link:delete()
                    
                    -- Go to the screen that the door leads to
                    ct.setScreen(objText)
                    
                    -- Make a new Link
                    this.link = ct.image("link.png", this.screenWidth / 2, this.screenHeight / 2, this.linkWidth)
                    
                    -- Put link in the appropriate spot 
                    if xSpeed > 0 then
                        
                        -- went through a right door, set him at left side of new screen
                        this.link.x = this.wallWidth / 2 + horizHitDist
                        this.link.y = y
                        this.link.xSpeed = xSpeed
                    
                    elseif xSpeed < 0 then
                        
                        -- went through a left door, set him at the right side of new screen
                        this.link.x = this.screenWidth - (this.wallWidth / 2 + horizHitDist)
                        this.link.y = y
                        this.link.xSpeed = xSpeed
                    
                    elseif ySpeed > 0 then
                        
                        -- went through a top door, set him at bottom of new screen
                        this.link.y = this.wallWidth / 2 + vertHitDist
                        this.link.x = x
                        this.link.ySpeed = ySpeed
                    
                    elseif ySpeed < 0 then
                        
                        -- went through a bottom door, set him at top of new screen
                        this.link.y = this.screenHeight - (this.wallWidth / 2 + vertHitDist)
                        this.link.x = x
                        this.link.ySpeed = ySpeed
                    end
                end
            end
        i = i + 1; end
        if noHits then
            
            -- Don't let Link go through the walls               
            if this.link.x < this.xMin then
                
                this.link.x = this.xMin
                this.link.xSpeed = 0
            
            elseif this.link.x > this.xMax then
                
                this.link.x = this.xMax
                this.link.xSpeed = 0
            end
            
            if this.link.y < this.yMin then
                
                this.link.y = this.yMin
                this.link.ySpeed = 0
            
            elseif this.link.y > this.yMax then
                
                this.link.y = this.yMax
                this.link.ySpeed = 0
            end
        end
    end
    
    function onKeyPress(keyName)
        
        if keyName:equals("g") then
            
            ct.setScreen("green")
        
        elseif keyName:equals("o") then
            
            ct.setScreen("orange")
        
        elseif keyName:equals("b") then
            
            ct.setScreen("blue")
        
        elseif keyName:equals("y") then
            
            ct.setScreen("yellow")
        
        elseif keyName:equals("r") then
            
            ct.setScreen("red")
        end
        
        if keyName:equals("up") and this.link.y > this.yMin then
            
            this.link.xSpeed = 0
            this.link.ySpeed = -this.linkSpeed
        
        elseif keyName:equals("down") and this.link.y < this.yMax then
            
            this.link.xSpeed = 0
            this.link.ySpeed = this.linkSpeed
        
        elseif keyName:equals("left") and this.link.x > this.xMin then
            
            this.link.xSpeed = -this.linkSpeed
            this.link.ySpeed = 0
        
        elseif keyName:equals("right") and this.link.x < this.xMax then
            
            this.link.xSpeed = this.linkSpeed
            this.link.ySpeed = 0
        end
    end
    
    function onKeyRelease(keyName)
        
        if keyName:equals("up") or keyName:equals("down") or keyName:equals("left") or keyName:equals("right") then
            
            this.link.xSpeed = 0
            this.link.ySpeed = 0
        end
    end
