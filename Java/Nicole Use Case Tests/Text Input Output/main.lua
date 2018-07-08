this = {}; _fn = {}   -- This file was generated by Code12 from "TextSort.java"
package.path = package.path .. ';../../Desktop/Code12/?.lua;../../../Desktop/Code12/?.lua'
require('Code12.api')
    
    this.rows = nil; 
    this.row0 = nil; 
    this.row1 = nil; 
    this.row2 = nil; 
    this.row3 = nil; 
    this.row4 = nil; 
    this.row5 = nil; 
    this.row6 = nil; 
    this.row7 = nil; 
    this.row8 = nil; 
    this.row9 = nil; 
    
    this.max = 0; 
    
    
        
        
    
    
    function _fn.start()
        
        this.row0 = "***"
        this.row1 = "*******"
        this.row2 = "**"
        this.row3 = "***********"
        this.row4 = "*"
        this.row5 = "****"
        this.row6 = "****************"
        this.row7 = "******"
        this.row8 = "***"
        this.row9 = "*********"
        
        this.rows = { length = 10, default = nil }
        
        -- Assign elements to array
        ct.checkArrayIndex(this.rows, 0); this.rows[1+(0)] = this.row0
        ct.checkArrayIndex(this.rows, 1); this.rows[1+(1)] = this.row1
        ct.checkArrayIndex(this.rows, 2); this.rows[1+(2)] = this.row2
        ct.checkArrayIndex(this.rows, 3); this.rows[1+(3)] = this.row3
        ct.checkArrayIndex(this.rows, 4); this.rows[1+(4)] = this.row4
        ct.checkArrayIndex(this.rows, 5); this.rows[1+(5)] = this.row5
        ct.checkArrayIndex(this.rows, 6); this.rows[1+(6)] = this.row6
        ct.checkArrayIndex(this.rows, 7); this.rows[1+(7)] = this.row7
        ct.checkArrayIndex(this.rows, 8); this.rows[1+(8)] = this.row8
        ct.checkArrayIndex(this.rows, 9); this.rows[1+(9)] = this.row9
        
        ct.println("-------------------")
        -- Print the initial array, unsorted
        _fn.printArray(this.rows)
        
        -- Uncomment each one seperately
        --bubbleSort( rows );
        _fn.insertionSort(this.rows)
        --selectionSort( rows );
    end
    
    -- Helper function to print array and the number of asterisks in each row
    function _fn.printArray(arr)
        
        local i = 0; while i < arr.length do
            
            ct.println(ct.indexArray(arr, i) .. " [" .. string.len(ct.indexArray(arr, i)) .. "]")
        i = i + 1; end
    end
    
    function _fn.insertionSort(arr)
        
        local temp = nil; 
        
        local j = 1; while j < arr.length do
            
            temp = ct.indexArray(arr, j)
            local i = j - 1
            while i >= 0 do
                
                if ct.stringCompare(temp, ct.indexArray(arr, i)) > 0 then
                    break; end
                ct.checkArrayIndex(arr, i + 1); arr[1+(i + 1)] = ct.indexArray(arr, i)
                i = i - 1
                ct.println("----------------------------")
                _fn.printArray(this.rows)
            end
            ct.checkArrayIndex(arr, i + 1); arr[1+(i + 1)] = temp
        j = j + 1; end
    end
    
    function _fn.bubbleSort(arr)
        
        local j = 0; 
        local needsSorting = true
        local temp = nil; 
        
        while needsSorting do
            
            ct.println("----------------------------")
            needsSorting = false
            -- this will exit the loop after the final pass
            j = 0; while j < arr.length - 1 do
                
                if string.len(ct.indexArray(arr, j)) > string.len(ct.indexArray(arr, j + 1)) then
                    
                    temp = ct.indexArray(arr, j)
                    ct.checkArrayIndex(arr, j); arr[1+(j)] = ct.indexArray(arr, j + 1)
                    ct.checkArrayIndex(arr, j + 1); arr[1+(j + 1)] = temp
                    needsSorting = true
                end
            j = j + 1; end
            
            _fn.printArray(arr)
        end
    end
    
    function _fn.selectionSort(arr)
        
        local min = 0; 
        local temp = nil; 
        --  The beginning of the array ( arr[0] ) to arr.length - 1
        local i = 0; while i < arr.length - 1 do
            
            -- assume the shortest string is the first element 
            min = string.len(ct.indexArray(arr, i))
            -- test against elements after j to find the shortest 
            -- index out of bounds
            local j = i + 1; while j <= arr.length do
                
                -- if this string element is shorter, then it is the new minimum
                if ct.stringCompare(ct.indexArray(arr, j), ct.indexArray(arr, min)) < 0 then
                    min = j; end
            j = j + 1; end
            if string.len(ct.indexArray(arr, min)) ~= string.len(ct.indexArray(arr, i)) then
                
                -- swap(a[i], a[iMin]) to go from shortest to longest
                temp = ct.indexArray(arr, i)
                ct.checkArrayIndex(arr, i); arr[1+(i)] = ct.indexArray(arr, min)
                ct.checkArrayIndex(arr, min); arr[1+(min)] = temp
            end
            
            _fn.printArray(arr)
        i = i + 1; end
    end
    
    