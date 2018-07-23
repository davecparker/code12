this = {}; _fn = {}   -- This file was generated by Code12 from "TestProgram.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')







this.xOrigin = 50
this.yOrigin = 0
this.dot = nil; 


    
    


function _fn.start()
    
    ct.setBackImage("underwater.jpg")
    this.dot = ct.circle(50, 50, 10)
    local t = ct.rect(25, 75, 10, 50)
    t.group = "targets"
    t = ct.rect(75, 75, 10, 50)
    t.group = "targets"
    t = ct.text("Hello", 50, 25, 10)
    t.group = "targets"
    ct.setScreenOrigin(this.xOrigin, 0)
end

function _fn.update()
    
    if ct.keyPressed("tab") then
        
        ct.println("ct.keyPressed(\"tab\")")
    
    elseif ct.keyPressed("a") then
        
        this.xOrigin = this.xOrigin - 1
        ct.setScreenOrigin(this.xOrigin, this.yOrigin)
    
    elseif ct.keyPressed("d") then
        
        this.xOrigin = this.xOrigin + 1
        ct.setScreenOrigin(this.xOrigin, this.yOrigin)
    
    elseif ct.keyPressed("w") then
        
        this.yOrigin = this.yOrigin - 1
        ct.setScreenOrigin(this.xOrigin, this.yOrigin)
    
    elseif ct.keyPressed("s") then
        
        this.yOrigin = this.yOrigin + 1
        ct.setScreenOrigin(this.xOrigin, this.yOrigin)
    end
    
    local SPEED = 0.2
    if ct.keyPressed("left") then
        this.dot.x = this.dot.x - (SPEED); 
    elseif ct.keyPressed("right") then
        this.dot.x = this.dot.x + (SPEED); 
    elseif ct.keyPressed("up") then
        this.dot.y = this.dot.y - (SPEED); 
    elseif ct.keyPressed("down") then
        this.dot.y = this.dot.y + (SPEED); end
    
    local hit = this.dot:objectHitInGroup("targets")
    if hit ~= nil then
        hit:delete(); end
    
    local clicked = ct.objectClicked()
    if clicked ~= nil then
        clicked:delete(); end
    
    if ct.clicked() then
        ct.log(ct.clickX(), ct.clickY()); end
end

