this = {}; _fn = {}   -- This file was generated by Code12 from "LineClicksEfficiencyTest2.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    
        
        
    
    
    function _fn.start()
        
        local x = 50
        local y = 50
        local width = 20
        local height = 10
        local rect = ct.rect(x, y, width, height)
        local horizLine = ct.line(x + width / 2, y, x - width / 2, y)
        local vertLine = ct.line(x, y + height / 2, x, y - height / 2)
        local slantLine1 = ct.line(x + width / 2, y + height / 2, x - width / 2, y - height / 2)
        local slantLine2 = ct.line(x - width / 2, y + height / 2, x + width / 2, y - height / 2)
        
        ct.println("horizLine:  " .. _fn.containsPointTime(horizLine))
        ct.println("vertLine:   " .. _fn.containsPointTime(vertLine))
        ct.println("slantLine1: " .. _fn.containsPointTime(slantLine1))
        ct.println("slantLine2: " .. _fn.containsPointTime(slantLine1))
        ct.println("rect:       " .. _fn.containsPointTime(rect))
    end
    
    -- Returns the number of milliseconds for n calls of obj.containsPoint(x, y)
    function _fn.containsPointTime(obj)
        
        local dx = 0.1
        local dy = 0.1
        local startTime = ct.getTimer()
        local x = 0; while x <= 100 do
            
            local y = 0; while y <= 40 do
                
                obj:containsPoint(x, y)
            y = y + (dy); end
        x = x + (dx); end
        return ct.getTimer() - startTime
    end