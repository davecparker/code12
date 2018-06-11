-- Generated by Code12 from Java code
-- Source file was: BasicTest.java

package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')

this = {}; _fn = {}


    this.circle = nil; this.fish = nil; this.wall = nil; 
    
    
    function start()
        ct.setTitle("Fish and Shapes Test")
        ct.setHeight(178)
        
        ct.println("Code 12 Version " .. ct.getVersion())
        ct.logm("Screen size:", ct.getWidth(), ct.getHeight())
        ct.logm("Scale factor:", ct.getPixelsPerUnit())
        ct.print("Testing the ")
        ct.print("API")
        ct.println()
        ct.log(ct.intDiv(9, 2))
        ct.log(ct.canParseInt("-3"), ct.canParseInt(" -3"), ct.canParseInt("-3 e2"))
        ct.log(ct.parseInt("-3"), ct.parseInt(" -3"), ct.parseInt("-3 e2"))
        ct.log(ct.canParseNumber("-3.14"), ct.canParseNumber(" -3.14"), ct.canParseNumber("-3e2g"))
        ct.log(ct.parseNumber("-3"), ct.parseNumber(" -3.14"), ct.parseNumber("-3e2"))
        
        -- Game Over screen
        ct.setScreen("end")
        ct.setBackColor("light yellow")
        local m = ct.text("Game Over!", 50, ct.getHeight() / 2, 10)
        m:align("center", true)
        
        -- Main screen
        ct.setScreen("main")
        ct.setBackImage("underwater.jpg")
        
        local t = ct.text("Hello!", 50, 50, 10, "purple")
        t:align("left")
        t:setLayer(2)
        ct.log(t)
        ct.log(t:getText())
        
        local r = ct.rect(50, 50, 50, 50, "pink")
        r.clickable = true
        
        this.circle = ct.circle(50, 20, 10, "orange")
        this.circle.clickable = true
        this.circle.group = "dots"
        
        local cc = ct.circle(50, 50, 10)
        cc.group = "dots"
        
        this.wall = ct.rect(50, ct.getHeight(), 10, 50)
        this.wall:align("bottom", true)
        this.wall:setLayer(0)
        ct.log(this.wall)
        
        local line = ct.line(0, 0, ct.getWidth(), ct.getHeight())
        line:setLineColorRGB(0, 100, 200)
        line.lineWidth = 5
        line:align("left", true)
        
        local x = 150
        if not ct.isError(x) then
            this.fish = ct.image("goldfish.png", x, 85, 20)
            -- fish.setText("Bob");
            this.fish.clickable = true
            ct.log(this.fish)
            this.fish.xSpeed = -1
            -- fish.autoDelete = true;
        end
        
        ct.setSoundVolume(0.7)
    end
    
    function update()
        if this.fish.x < -30 then
            this.fish.x = 130
        elseif this.fish.x > 130 then
            this.fish.x = -30
        end
        
        if this.fish:hit(this.wall) then
            this.fish.xSpeed = -this.fish.xSpeed
        end
        
        if this.circle:clicked() then
            ct.logm("Clicked", this.circle)
            ct.clearGroup("dots")
        elseif this.fish:clicked() then
            ct.log("Clicked " .. this.fish:toString())
            -- ct.clearScreen();
            ct.setScreen("end")
        elseif ct.clicked() then
            ct.log("Click at " .. ct.clickX(), ct.clickY())
            ct.sound("bubble.wav")
        end
        
        if ct.keyPressed("up") then
            this.fish.y = this.fish.y - 1
        elseif ct.keyPressed("down") then
            this.fish.y = this.fish.y + 1
        end
        
        local scale = 1.2
        if ct.charTyped("+") then
            this.fish:setSize(this.fish.width * scale, this.fish.height * scale)
        elseif ct.charTyped("-") then
            this.fish:setSize(this.fish.width / scale, this.fish.height / scale)
        end
        
    end
    
    --      
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
