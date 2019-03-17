-- Code12 API tables
-- *** DO NOT EDIT *** This file is generated by the Make API tool.

return {

["ct"] = {
    name = "ct",
    fields = {
    },
    methods = {
        ["circle"] = { vt = "GameObj", min = 3, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "diameter", vt = 1},{ name = "color", vt = "String"}}, docLink = "API.html#ct.circle" },
        ["rect"] = { vt = "GameObj", min = 4, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}}, docLink = "API.html#ct.rect" },
        ["line"] = { vt = "GameObj", min = 4, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1},{ name = "color", vt = "String"}}, docLink = "API.html#ct.line" },
        ["text"] = { vt = "GameObj", min = 4, params = {{ name = "s", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}}, docLink = "API.html#ct.text" },
        ["image"] = { vt = "GameObj", params = {{ name = "filename", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1}}, docLink = "API.html#ct.image" },
        ["print"] = { vt = false, params = {{ name = "value", vt = nil}}, docLink = "API.html#ct.print" },
        ["println"] = { vt = false, min = 0, params = {{ name = "value", vt = nil}}, docLink = "API.html#ct.println" },
        ["log"] = { vt = false, variadic = true, params = {{ name = "values", vt = nil}}, docLink = "API.html#ct.log" },
        ["logm"] = { vt = false, variadic = true, params = {{ name = "message", vt = "String"},{ name = "values", vt = nil}}, docLink = "API.html#ct.logm" },
        ["setOutputFile"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "API.html#ct.setoutputfile" },
        ["setoutputfile"] = "setOutputFile",
        ["showAlert"] = { vt = false, params = {{ name = "message", vt = "String"}}, docLink = "API.html#ct.showalert" },
        ["showalert"] = "showAlert",
        ["inputInt"] = { vt = 0, params = {{ name = "message", vt = "String"}}, docLink = "API.html#ct.inputint" },
        ["inputint"] = "inputInt",
        ["inputNumber"] = { vt = 1, params = {{ name = "message", vt = "String"}}, docLink = "API.html#ct.inputnumber" },
        ["inputnumber"] = "inputNumber",
        ["inputYesNo"] = { vt = true, params = {{ name = "message", vt = "String"}}, docLink = "API.html#ct.inputyesno" },
        ["inputyesno"] = "inputYesNo",
        ["inputString"] = { vt = "String", params = {{ name = "message", vt = "String"}}, docLink = "API.html#ct.inputstring" },
        ["inputstring"] = "inputString",
        ["setTitle"] = { vt = false, params = {{ name = "title", vt = "String"}}, docLink = "API.html#ct.settitle" },
        ["settitle"] = "setTitle",
        ["setHeight"] = { vt = false, params = {{ name = "height", vt = 1}}, docLink = "API.html#ct.setheight" },
        ["setheight"] = "setHeight",
        ["getWidth"] = { vt = 1, params = {}, docLink = "API.html#ct.getwidth" },
        ["getwidth"] = "getWidth",
        ["getHeight"] = { vt = 1, params = {}, docLink = "API.html#ct.getheight" },
        ["getheight"] = "getHeight",
        ["getPixelsPerUnit"] = { vt = 1, params = {}, docLink = "API.html#ct.getpixelsperunit" },
        ["getpixelsperunit"] = "getPixelsPerUnit",
        ["setScreen"] = { vt = false, params = {{ name = "name", vt = "String"}}, docLink = "API.html#ct.setscreen" },
        ["setscreen"] = "setScreen",
        ["getScreen"] = { vt = "String", params = {}, docLink = "API.html#ct.getscreen" },
        ["getscreen"] = "getScreen",
        ["setScreenOrigin"] = { vt = false, params = {{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "API.html#ct.setscreenorigin" },
        ["setscreenorigin"] = "setScreenOrigin",
        ["clearScreen"] = { vt = false, params = {}, docLink = "API.html#ct.clearscreen" },
        ["clearscreen"] = "clearScreen",
        ["clearGroup"] = { vt = false, params = {{ name = "group", vt = "String"}}, docLink = "API.html#ct.cleargroup" },
        ["cleargroup"] = "clearGroup",
        ["setBackColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "API.html#ct.setbackcolor" },
        ["setbackcolor"] = "setBackColor",
        ["setBackColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "API.html#ct.setbackcolorrgb" },
        ["setbackcolorrgb"] = "setBackColorRGB",
        ["setBackImage"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "API.html#ct.setbackimage" },
        ["setbackimage"] = "setBackImage",
        ["clicked"] = { vt = true, params = {}, docLink = "API.html#ct.clicked" },
        ["clickX"] = { vt = 1, params = {}, docLink = "API.html#ct.clickx" },
        ["clickx"] = "clickX",
        ["clickY"] = { vt = 1, params = {}, docLink = "API.html#ct.clicky" },
        ["clicky"] = "clickY",
        ["objectClicked"] = { vt = "GameObj", params = {}, docLink = "API.html#ct.objectclicked" },
        ["objectclicked"] = "objectClicked",
        ["keyPressed"] = { vt = true, params = {{ name = "keyName", vt = "String"}}, docLink = "API.html#ct.keypressed" },
        ["keypressed"] = "keyPressed",
        ["charTyped"] = { vt = true, params = {{ name = "charString", vt = "String"}}, docLink = "API.html#ct.chartyped" },
        ["chartyped"] = "charTyped",
        ["loadSound"] = { vt = true, params = {{ name = "filename", vt = "String"}}, docLink = "API.html#ct.loadsound" },
        ["loadsound"] = "loadSound",
        ["sound"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "API.html#ct.sound" },
        ["setSoundVolume"] = { vt = false, params = {{ name = "volume", vt = 1}}, docLink = "API.html#ct.setsoundvolume" },
        ["setsoundvolume"] = "setSoundVolume",
        ["random"] = { vt = 0, params = {{ name = "min", vt = 0},{ name = "max", vt = 0}}, docLink = "API.html#ct.random" },
        ["round"] = { vt = 0, params = {{ name = "number", vt = 1}}, docLink = "API.html#ct.round" },
        ["roundDecimal"] = { vt = 1, params = {{ name = "number", vt = 1},{ name = "numPlaces", vt = 0}}, docLink = "API.html#ct.rounddecimal" },
        ["rounddecimal"] = "roundDecimal",
        ["distance"] = { vt = 1, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1}}, docLink = "API.html#ct.distance" },
        ["intDiv"] = { vt = 0, params = {{ name = "numerator", vt = 0},{ name = "denominator", vt = 0}}, docLink = "API.html#ct.intdiv" },
        ["intdiv"] = "intDiv",
        ["isError"] = { vt = true, params = {{ name = "number", vt = 1}}, docLink = "API.html#ct.iserror" },
        ["iserror"] = "isError",
        ["parseInt"] = { vt = 0, params = {{ name = "str", vt = "String"}}, docLink = "API.html#ct.parseint" },
        ["parseint"] = "parseInt",
        ["parseNumber"] = { vt = 1, params = {{ name = "str", vt = "String"}}, docLink = "API.html#ct.parsenumber" },
        ["parsenumber"] = "parseNumber",
        ["canParseInt"] = { vt = true, params = {{ name = "str", vt = "String"}}, docLink = "API.html#ct.canparseint" },
        ["canparseint"] = "canParseInt",
        ["canParseNumber"] = { vt = true, params = {{ name = "str", vt = "String"}}, docLink = "API.html#ct.canparsenumber" },
        ["canparsenumber"] = "canParseNumber",
        ["formatInt"] = { vt = "String", min = 1, params = {{ name = "number", vt = 0},{ name = "numDigits", vt = 0}}, docLink = "API.html#ct.formatint" },
        ["formatint"] = "formatInt",
        ["formatDecimal"] = { vt = "String", min = 1, params = {{ name = "number", vt = 1},{ name = "numPlaces", vt = 0}}, docLink = "API.html#ct.formatdecimal" },
        ["formatdecimal"] = "formatDecimal",
        ["getTimer"] = { vt = 0, params = {}, docLink = "API.html#ct.gettimer" },
        ["gettimer"] = "getTimer",
        ["getVersion"] = { vt = 1, params = {}, docLink = "API.html#ct.getversion" },
        ["getversion"] = "getVersion",
        ["pause"] = { vt = false, params = {}, docLink = "API.html#ct.pause" },
        ["stop"] = { vt = false, params = {}, docLink = "API.html#ct.stop" },
        ["restart"] = { vt = false, params = {}, docLink = "API.html#ct.restart" },
    }
},

["gameobj"] = "GameObj",

["GameObj"] = {
    name = "GameObj",
    fields = {
        ["x"] = { vt = 1 },
        ["y"] = { vt = 1 },
        ["visible"] = { vt = true },
        ["id"] = { vt = 0 },
        ["group"] = { vt = "String" },
    },
    methods = {
        ["getType"] = { vt = "String", params = {}, docLink = "API.html#obj.gettype" },
        ["gettype"] = "getType",
        ["setSize"] = { vt = false, params = {{ name = "width", vt = 1},{ name = "height", vt = 1}}, docLink = "API.html#obj.setsize" },
        ["setsize"] = "setSize",
        ["getWidth"] = { vt = 1, params = {}, docLink = "API.html#obj.getwidth" },
        ["getwidth"] = "getWidth",
        ["getHeight"] = { vt = 1, params = {}, docLink = "API.html#obj.getheight" },
        ["getheight"] = "getHeight",
        ["setXSpeed"] = { vt = false, params = {{ name = "xSpeed", vt = 1}}, docLink = "API.html#obj.setxspeed" },
        ["setxspeed"] = "setXSpeed",
        ["setYSpeed"] = { vt = false, params = {{ name = "ySpeed", vt = 1}}, docLink = "API.html#obj.setyspeed" },
        ["setyspeed"] = "setYSpeed",
        ["getXSpeed"] = { vt = 1, params = {}, docLink = "API.html#obj.getxspeed" },
        ["getxspeed"] = "getXSpeed",
        ["getYSpeed"] = { vt = 1, params = {}, docLink = "API.html#obj.getyspeed" },
        ["getyspeed"] = "getYSpeed",
        ["align"] = { vt = false, params = {{ name = "alignment", vt = "String"}}, docLink = "API.html#obj.align" },
        ["setText"] = { vt = false, params = {{ name = "text", vt = "String"}}, docLink = "API.html#obj.settext" },
        ["settext"] = "setText",
        ["getText"] = { vt = "String", params = {}, docLink = "API.html#obj.gettext" },
        ["gettext"] = "getText",
        ["toString"] = { vt = "String", params = {}, docLink = "API.html#obj.tostring" },
        ["tostring"] = "toString",
        ["setFillColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "API.html#obj.setfillcolor" },
        ["setfillcolor"] = "setFillColor",
        ["setFillColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "API.html#obj.setfillcolorrgb" },
        ["setfillcolorrgb"] = "setFillColorRGB",
        ["setLineColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "API.html#obj.setlinecolor" },
        ["setlinecolor"] = "setLineColor",
        ["setLineColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "API.html#obj.setlinecolorrgb" },
        ["setlinecolorrgb"] = "setLineColorRGB",
        ["setLineWidth"] = { vt = false, params = {{ name = "lineWidth", vt = 0}}, docLink = "API.html#obj.setlinewidth" },
        ["setlinewidth"] = "setLineWidth",
        ["setImage"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "API.html#obj.setimage" },
        ["setimage"] = "setImage",
        ["setLayer"] = { vt = false, params = {{ name = "layer", vt = 0}}, docLink = "API.html#obj.setlayer" },
        ["setlayer"] = "setLayer",
        ["getLayer"] = { vt = 0, params = {}, docLink = "API.html#obj.getlayer" },
        ["getlayer"] = "getLayer",
        ["delete"] = { vt = false, params = {}, docLink = "API.html#obj.delete" },
        ["setClickable"] = { vt = false, params = {{ name = "clickable", vt = true}}, docLink = "API.html#obj.setclickable" },
        ["setclickable"] = "setClickable",
        ["clicked"] = { vt = true, params = {}, docLink = "API.html#obj.clicked" },
        ["containsPoint"] = { vt = true, params = {{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "API.html#obj.containspoint" },
        ["containspoint"] = "containsPoint",
        ["hit"] = { vt = true, params = {{ name = "objTest", vt = "GameObj"}}, docLink = "API.html#obj.hit" },
        ["objectHitInGroup"] = { vt = "GameObj", params = {{ name = "group", vt = "String"}}, docLink = "API.html#obj.objecthitingroup" },
        ["objecthitingroup"] = "objectHitInGroup",
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
        ["abs"] = { vt = 1, overloaded = true, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["acos"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["asin"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["atan"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["atan2"] = { vt = 1, params = {{ name = "y", vt = 1},{ name = "x", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["ceil"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["cos"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["cosh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["exp"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["floor"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["log"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["log10"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["max"] = { vt = 1, overloaded = true, params = {{ name = "number1", vt = 1},{ name = "number2", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["min"] = { vt = 1, overloaded = true, params = {{ name = "number1", vt = 1},{ name = "number2", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["pow"] = { vt = 1, params = {{ name = "number", vt = 1},{ name = "exponent", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["sin"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["sinh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["sqrt"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["tan"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
        ["tanh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "API.html#java-math-class-methods-and-fields-supported" },
    }
},

["string"] = "String",

["String"] = {
    name = "String",
    fields = {
    },
    methods = {
        ["compareTo"] = { vt = 0, params = {{ name = "str2", vt = "String"}}, docLink = "API.html#java-string-class-methods-supported" },
        ["compareto"] = "compareTo",
        ["equals"] = { vt = true, params = {{ name = "str2", vt = "String"}}, docLink = "API.html#java-string-class-methods-supported" },
        ["indexOf"] = { vt = 0, params = {{ name = "strFind", vt = "String"}}, docLink = "API.html#java-string-class-methods-supported" },
        ["indexof"] = "indexOf",
        ["length"] = { vt = 0, params = {}, docLink = "API.html#java-string-class-methods-supported" },
        ["substring"] = { vt = "String", min = 1, params = {{ name = "beginIndex", vt = 0},{ name = "endIndex", vt = 0}}, docLink = "API.html#java-string-class-methods-supported" },
        ["toLowerCase"] = { vt = "String", params = {}, docLink = "API.html#java-string-class-methods-supported" },
        ["tolowercase"] = "toLowerCase",
        ["toUpperCase"] = { vt = "String", params = {}, docLink = "API.html#java-string-class-methods-supported" },
        ["touppercase"] = "toUpperCase",
        ["trim"] = { vt = "String", params = {}, docLink = "API.html#java-string-class-methods-supported" },
    }
},

["printstream"] = "PrintStream",

["PrintStream"] = {
    name = "PrintStream",
    fields = {
    },
    methods = {
        ["print"] = { vt = false, params = {{ name = "value", vt = nil}} },
        ["println"] = { vt = false, params = {{ name = "value", vt = nil}} },
    }
},

["code12program"] = "Code12Program",

["Code12Program"] = {
    name = "Code12Program",
    fields = {
    },
    methods = {
        ["start"] = { vt = false, params = {}, docLink = "API.html#start" },
        ["update"] = { vt = false, params = {}, docLink = "API.html#update" },
        ["main"] = { vt = false, params = {{ name = "args", vt = { vt = "String" }}}, docLink = "API.html#main" },
        ["onMousePress"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "API.html#onmousepress" },
        ["onmousepress"] = "onMousePress",
        ["onMouseDrag"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "API.html#onmousedrag" },
        ["onmousedrag"] = "onMouseDrag",
        ["onMouseRelease"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "API.html#onmouserelease" },
        ["onmouserelease"] = "onMouseRelease",
        ["onKeyPress"] = { vt = false, params = {{ name = "keyName", vt = "String"}}, docLink = "API.html#onkeypress" },
        ["onkeypress"] = "onKeyPress",
        ["onKeyRelease"] = { vt = false, params = {{ name = "keyName", vt = "String"}}, docLink = "API.html#onkeyrelease" },
        ["onkeyrelease"] = "onKeyRelease",
        ["onCharTyped"] = { vt = false, params = {{ name = "charString", vt = "String"}}, docLink = "API.html#onchartyped" },
        ["onchartyped"] = "onCharTyped",
        ["onResize"] = { vt = false, params = {}, docLink = "API.html#onresize" },
        ["onresize"] = "onResize",
    }
},

}
