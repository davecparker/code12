-- Code12 API tables
-- *** DO NOT EDIT *** This file is generated by the Make API tool.

return {

["ct"] = {
    name = "ct",
    fields = {
    },
    methods = {
        ["print"] = { vt = false, params = {{ name = "value", vt = nil}} },
        ["println"] = { vt = false, min = 0, params = {{ name = "value", vt = nil}} },
        ["log"] = { vt = false, variadic = true, params = {{ name = "values", vt = nil}} },
        ["logm"] = { vt = false, variadic = true, params = {{ name = "message", vt = "String"},{ name = "values", vt = nil}} },
        ["inputInt"] = { vt = 0, params = {{ name = "message", vt = "String"}} },
        ["inputint"] = "inputInt",
        ["inputNumber"] = { vt = 1, params = {{ name = "message", vt = "String"}} },
        ["inputnumber"] = "inputNumber",
        ["inputBoolean"] = { vt = true, params = {{ name = "message", vt = "String"}} },
        ["inputboolean"] = "inputBoolean",
        ["inputString"] = { vt = "String", params = {{ name = "message", vt = "String"}} },
        ["inputstring"] = "inputString",
        ["setTitle"] = { vt = false, params = {{ name = "title", vt = "String"}} },
        ["settitle"] = "setTitle",
        ["setHeight"] = { vt = false, params = {{ name = "height", vt = 1}} },
        ["setheight"] = "setHeight",
        ["getWidth"] = { vt = 1, params = {} },
        ["getwidth"] = "getWidth",
        ["getHeight"] = { vt = 1, params = {} },
        ["getheight"] = "getHeight",
        ["getPixelsPerUnit"] = { vt = 1, params = {} },
        ["getpixelsperunit"] = "getPixelsPerUnit",
        ["getScreen"] = { vt = "String", params = {} },
        ["getscreen"] = "getScreen",
        ["setScreen"] = { vt = false, params = {{ name = "name", vt = "String"}} },
        ["setscreen"] = "setScreen",
        ["clearScreen"] = { vt = false, params = {} },
        ["clearscreen"] = "clearScreen",
        ["clearGroup"] = { vt = false, params = {{ name = "group", vt = "String"}} },
        ["cleargroup"] = "clearGroup",
        ["setBackColor"] = { vt = false, params = {{ name = "color", vt = "String"}} },
        ["setbackcolor"] = "setBackColor",
        ["setBackColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}} },
        ["setbackcolorrgb"] = "setBackColorRGB",
        ["setBackImage"] = { vt = false, params = {{ name = "filename", vt = "String"}} },
        ["setbackimage"] = "setBackImage",
        ["circle"] = { vt = "GameObj", min = 3, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "diameter", vt = 1},{ name = "color", vt = "String"}} },
        ["rect"] = { vt = "GameObj", min = 4, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}} },
        ["line"] = { vt = "GameObj", min = 4, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1},{ name = "color", vt = "String"}} },
        ["text"] = { vt = "GameObj", min = 4, params = {{ name = "s", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}} },
        ["image"] = { vt = "GameObj", params = {{ name = "filename", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1}} },
        ["clicked"] = { vt = true, params = {} },
        ["clickX"] = { vt = 1, params = {} },
        ["clickx"] = "clickX",
        ["clickY"] = { vt = 1, params = {} },
        ["clicky"] = "clickY",
        ["keyPressed"] = { vt = true, params = {{ name = "keyName", vt = "String"}} },
        ["keypressed"] = "keyPressed",
        ["charTyped"] = { vt = true, params = {{ name = "ch", vt = "String"}} },
        ["chartyped"] = "charTyped",
        ["loadSound"] = { vt = true, params = {{ name = "filename", vt = "String"}} },
        ["loadsound"] = "loadSound",
        ["sound"] = { vt = false, params = {{ name = "filename", vt = "String"}} },
        ["setSoundVolume"] = { vt = false, params = {{ name = "volume", vt = 1}} },
        ["setsoundvolume"] = "setSoundVolume",
        ["random"] = { vt = 0, params = {{ name = "min", vt = 0},{ name = "max", vt = 0}} },
        ["round"] = { vt = 0, params = {{ name = "d", vt = 1}} },
        ["roundDecimal"] = { vt = 1, params = {{ name = "d", vt = 1},{ name = "numPlaces", vt = 0}} },
        ["rounddecimal"] = "roundDecimal",
        ["intDiv"] = { vt = 0, params = {{ name = "n", vt = 0},{ name = "d", vt = 0}} },
        ["intdiv"] = "intDiv",
        ["isError"] = { vt = true, params = {{ name = "d", vt = 1}} },
        ["iserror"] = "isError",
        ["distance"] = { vt = 1, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1}} },
        ["getTimer"] = { vt = 0, params = {} },
        ["gettimer"] = "getTimer",
        ["getVersion"] = { vt = 1, params = {} },
        ["getversion"] = "getVersion",
        ["toInt"] = { vt = 0, params = {{ name = "d", vt = 1}} },
        ["toint"] = "toInt",
        ["parseInt"] = { vt = 0, params = {{ name = "s", vt = "String"}} },
        ["parseint"] = "parseInt",
        ["canParseInt"] = { vt = true, params = {{ name = "s", vt = "String"}} },
        ["canparseint"] = "canParseInt",
        ["parseNumber"] = { vt = 1, params = {{ name = "s", vt = "String"}} },
        ["parsenumber"] = "parseNumber",
        ["canParseNumber"] = { vt = true, params = {{ name = "s", vt = "String"}} },
        ["canparsenumber"] = "canParseNumber",
        ["formatDecimal"] = { vt = "String", min = 1, params = {{ name = "d", vt = 1},{ name = "numPlaces", vt = 0}} },
        ["formatdecimal"] = "formatDecimal",
        ["formatInt"] = { vt = "String", min = 1, params = {{ name = "i", vt = 0},{ name = "numDigits", vt = 0}} },
        ["formatint"] = "formatInt",
    }
},

["gameobj"] = "GameObj",

["GameObj"] = {
    name = "GameObj",
    fields = {
        ["x"] = { vt = 1 },
        ["y"] = { vt = 1 },
        ["width"] = { vt = 1 },
        ["height"] = { vt = 1 },
        ["xSpeed"] = { vt = 1 },
        ["xspeed"] = "xSpeed",
        ["ySpeed"] = { vt = 1 },
        ["yspeed"] = "ySpeed",
        ["lineWidth"] = { vt = 0 },
        ["linewidth"] = "lineWidth",
        ["visible"] = { vt = true },
        ["clickable"] = { vt = true },
        ["autoDelete"] = { vt = true },
        ["autodelete"] = "autoDelete",
        ["group"] = { vt = "String" },
    },
    methods = {
        ["getType"] = { vt = "String", params = {} },
        ["gettype"] = "getType",
        ["getText"] = { vt = "String", params = {} },
        ["gettext"] = "getText",
        ["setText"] = { vt = false, params = {{ name = "text", vt = "String"}} },
        ["settext"] = "setText",
        ["toString"] = { vt = "String", params = {} },
        ["tostring"] = "toString",
        ["setSize"] = { vt = false, params = {{ name = "width", vt = 1},{ name = "height", vt = 1}} },
        ["setsize"] = "setSize",
        ["align"] = { vt = false, min = 1, params = {{ name = "alignment", vt = "String"},{ name = "adjustY", vt = true}} },
        ["setFillColor"] = { vt = false, params = {{ name = "color", vt = "String"}} },
        ["setfillcolor"] = "setFillColor",
        ["setFillColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}} },
        ["setfillcolorrgb"] = "setFillColorRGB",
        ["setLineColor"] = { vt = false, params = {{ name = "color", vt = "String"}} },
        ["setlinecolor"] = "setLineColor",
        ["setLineColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}} },
        ["setlinecolorrgb"] = "setLineColorRGB",
        ["getLayer"] = { vt = 0, params = {} },
        ["getlayer"] = "getLayer",
        ["setLayer"] = { vt = false, params = {{ name = "layer", vt = 0}} },
        ["setlayer"] = "setLayer",
        ["delete"] = { vt = false, params = {} },
        ["clicked"] = { vt = true, params = {} },
        ["containsPoint"] = { vt = true, params = {{ name = "x", vt = 1},{ name = "y", vt = 1}} },
        ["containspoint"] = "containsPoint",
        ["hit"] = { vt = true, params = {{ name = "obj", vt = "GameObj"}} },
    }
},

["math"] = "Math",

["Math"] = {
    name = "Math",
    fields = {
        ["E"] = { vt = 1 },
        ["e"] = "E",
        ["PI"] = { vt = 1 },
        ["pi"] = "PI",
    },
    methods = {
        ["abs"] = { vt = 1, overloaded = true, params = {{ name = "a", vt = 1}} },
        ["acos"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["asin"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["atan"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["atan2"] = { vt = 1, params = {{ name = "y", vt = 1},{ name = "x", vt = 1}} },
        ["ceil"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["cos"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["cosh"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["exp"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["floor"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["log"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["log10"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["max"] = { vt = 1, overloaded = true, params = {{ name = "a", vt = 1},{ name = "b", vt = 1}} },
        ["min"] = { vt = 1, overloaded = true, params = {{ name = "a", vt = 1},{ name = "b", vt = 1}} },
        ["pow"] = { vt = 1, params = {{ name = "a", vt = 1},{ name = "b", vt = 1}} },
        ["sin"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["sinh"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["sqrt"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["tan"] = { vt = 1, params = {{ name = "a", vt = 1}} },
        ["tanh"] = { vt = 1, params = {{ name = "a", vt = 1}} },
    }
},

["string"] = "String",

["String"] = {
    name = "String",
    fields = {
    },
    methods = {
        ["compareTo"] = { vt = 0, params = {{ name = "str2", vt = "String"}} },
        ["compareto"] = "compareTo",
        ["equals"] = { vt = true, params = {{ name = "str2", vt = "String"}} },
        ["indexOf"] = { vt = 0, params = {{ name = "strFind", vt = "String"}} },
        ["indexof"] = "indexOf",
        ["length"] = { vt = 0, params = {} },
        ["substring"] = { vt = "String", min = 1, params = {{ name = "beginIndex", vt = 0},{ name = "endIndex", vt = 0}} },
        ["toLowerCase"] = { vt = "String", params = {} },
        ["tolowercase"] = "toLowerCase",
        ["toUpperCase"] = { vt = "String", params = {} },
        ["touppercase"] = "toUpperCase",
        ["trim"] = { vt = "String", params = {} },
    }
},

["code12program"] = "Code12Program",

["Code12Program"] = {
    name = "Code12Program",
    fields = {
    },
    methods = {
        ["start"] = { vt = false, params = {} },
        ["update"] = { vt = false, params = {} },
        ["onMousePress"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}} },
        ["onmousepress"] = "onMousePress",
        ["onMouseDrag"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}} },
        ["onmousedrag"] = "onMouseDrag",
        ["onMouseRelease"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}} },
        ["onmouserelease"] = "onMouseRelease",
        ["onKeyPress"] = { vt = false, params = {{ name = "key", vt = "String"}} },
        ["onkeypress"] = "onKeyPress",
        ["onKeyRelease"] = { vt = false, params = {{ name = "key", vt = "String"}} },
        ["onkeyrelease"] = "onKeyRelease",
        ["onCharTyped"] = { vt = false, params = {{ name = "ch", vt = "String"}} },
        ["onchartyped"] = "onCharTyped",
        ["onResize"] = { vt = false, params = {} },
        ["onresize"] = "onResize",
    }
},

}
