
local keywordsCT = { "print", "println", "log", "logm", "setoutputfile", "showalert",
                    "inputint", "inputnumber", "inputyesno", "inputstring", "settitle", "setheight",
                    "getwidth", "getheight", "getpixelsperunit", "getscreen", "setscreen", "setscreenorigin",
                    "clearscreen", "cleargroup", "setbackcolor", "setbackcolorrgb", "setbackimage", "circle",
                    "rect", "line", "text", "image", "clicked", "clickx", "clicky", "objectclicked", "keypressed",
                    "chartyped", "loadsound", "sound", "setsoundvolume", "random", "round", "rounddecimal",
                    "intdiv", "iserror", "distance", "gettimer", "getversion", "pause", "stop", "restart",
                    "toint", "parseint", "canparseint", "parsenumber", "canparsenumber", "formatdecimal", "formatint" }

local keywordsGameObj = { "x", "y", "width", "height", "xspeed", "yspeed", "linewidth", "visible", "clickable",
                    "autodelete", "group", "gettype", "settext", "tostring", "setsize", "align", "setfillcolor",
                    "setfillcolorrgb", "setlinecolor", "setlinecolorrgb", "getlayer", "setlayer", "delete",
                    "clicked", "containspoint", "hit", "objecthitingroup" }
local keywordsMath = { "e", "pi", "abs", "acos", "asin", "atan", "atan2", "ceil", "cos", "cosh", "exp", "floor", "log",
                        "log10", "max", "min", "pow", "sin", "sinh", "sqrt", "tan", "tanh" }
                        
local keywordsString = { "compareto", "equals", "indexof", "length", "subtring", "tolowercase", "touppercase", "trim" }



function levenshtein_distance(str1, str2)
    str1 = string.lower(str1)
    str2 = string.lower(str2)
    local len1, len2 = #str1, #str2
    local char1, char2, distance = {}, {}, {}
    str1:gsub('.', function (c) table.insert(char1, c) end)
    str2:gsub('.', function (c) table.insert(char2, c) end)
    for i = 0, len1 do distance[i] = {} end
    for i = 0, len1 do distance[i][0] = i end
    for i = 0, len2 do distance[0][i] = i end
    for i = 1, len1 do
        for j = 1, len2 do
            distance[i][j] = math.min(
                distance[i-1][j  ] + 1,
                distance[i  ][j-1] + 1,
                distance[i-1][j-1] + (char1[i] == char2[j] and 0 or 1)
                )
        end
    end
    return distance[len1][len2]
end



local testWords = { "thisisareallylongtringanditis123456" }




--Calls l_d on the word and all words in the associated keyword table and returns potential matches
   
for word = 1, #testWords do
    local result = {}

    for i = 1, #keywordsCT do
        table.insert( result, levenshtein_distance( testWords[word], keywordsCT[i]) ) 
    end

    minScore = math.min( unpack(result) )
    if minScore < 5 then
        for i = 1, #result do
            if minScore == result[i] then
                return keywordsCT[i]
            end
        end
    end
end

