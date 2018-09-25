-- Code12 API tables
-- *** DO NOT EDIT *** This file is generated by the Make API tool.

return {

["ct"] = {
    name = "ct",
    fields = {
    },
    methods = {
        ["print"] = { vt = false, params = {{ name = "value", vt = nil}}, docLink = "#ct-print-" },
        ["println"] = { vt = false, min = 0, params = {{ name = "value", vt = nil}}, docLink = "#ct-println-" },
        ["log"] = { vt = false, variadic = true, params = {{ name = "values", vt = nil}}, docLink = "#ct-log-" },
        ["logm"] = { vt = false, variadic = true, params = {{ name = "message", vt = "String"},{ name = "values", vt = nil}}, docLink = "#ct-logm-" },
        ["setOutputFile"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "#ct-setoutputfile-" },
        ["setoutputfile"] = "setOutputFile",
        ["showAlert"] = { vt = false, params = {{ name = "message", vt = "String"}}, docLink = "#ct-showalert-" },
        ["showalert"] = "showAlert",
        ["inputInt"] = { vt = 0, params = {{ name = "message", vt = "String"}}, docLink = "#ct-inputint-" },
        ["inputint"] = "inputInt",
        ["inputNumber"] = { vt = 1, params = {{ name = "message", vt = "String"}}, docLink = "#ct-inputnumber-" },
        ["inputnumber"] = "inputNumber",
        ["inputYesNo"] = { vt = true, params = {{ name = "message", vt = "String"}}, docLink = "#ct-inputyesno-" },
        ["inputyesno"] = "inputYesNo",
        ["inputString"] = { vt = "String", params = {{ name = "message", vt = "String"}}, docLink = "#ct-inputstring-" },
        ["inputstring"] = "inputString",
        ["setTitle"] = { vt = false, params = {{ name = "title", vt = "String"}}, docLink = "#ct-settitle-" },
        ["settitle"] = "setTitle",
        ["setHeight"] = { vt = false, params = {{ name = "height", vt = 1}}, docLink = "#ct-setheight-" },
        ["setheight"] = "setHeight",
        ["getWidth"] = { vt = 1, params = {}, docLink = "#ct-getwidth-" },
        ["getwidth"] = "getWidth",
        ["getHeight"] = { vt = 1, params = {}, docLink = "#ct-getheight-" },
        ["getheight"] = "getHeight",
        ["getPixelsPerUnit"] = { vt = 1, params = {}, docLink = "#ct-getpixelsperunit-" },
        ["getpixelsperunit"] = "getPixelsPerUnit",
        ["getScreen"] = { vt = "String", params = {}, docLink = "#ct-getscreen-" },
        ["getscreen"] = "getScreen",
        ["setScreen"] = { vt = false, params = {{ name = "name", vt = "String"}}, docLink = "#ct-setscreen-" },
        ["setscreen"] = "setScreen",
        ["setScreenOrigin"] = { vt = false, params = {{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "#ct-setscreenorigin-" },
        ["setscreenorigin"] = "setScreenOrigin",
        ["clearScreen"] = { vt = false, params = {}, docLink = "#ct-clearscreen-" },
        ["clearscreen"] = "clearScreen",
        ["clearGroup"] = { vt = false, params = {{ name = "group", vt = "String"}}, docLink = "#ct-cleargroup-" },
        ["cleargroup"] = "clearGroup",
        ["setBackColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "#ct-setbackcolor-" },
        ["setbackcolor"] = "setBackColor",
        ["setBackColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "#ct-setbackcolorrgb-" },
        ["setbackcolorrgb"] = "setBackColorRGB",
        ["setBackImage"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "#ct-setbackimage-" },
        ["setbackimage"] = "setBackImage",
        ["circle"] = { vt = "GameObj", min = 3, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "diameter", vt = 1},{ name = "color", vt = "String"}}, docLink = "#ct-circle-" },
        ["rect"] = { vt = "GameObj", min = 4, params = {{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}}, docLink = "#ct-rect-" },
        ["line"] = { vt = "GameObj", min = 4, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1},{ name = "color", vt = "String"}}, docLink = "#ct-line-" },
        ["text"] = { vt = "GameObj", min = 4, params = {{ name = "s", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "height", vt = 1},{ name = "color", vt = "String"}}, docLink = "#ct-text-" },
        ["image"] = { vt = "GameObj", params = {{ name = "filename", vt = "String"},{ name = "x", vt = 1},{ name = "y", vt = 1},{ name = "width", vt = 1}}, docLink = "#ct-image-" },
        ["clicked"] = { vt = true, params = {}, docLink = "#ct-clicked-" },
        ["clickX"] = { vt = 1, params = {}, docLink = "#ct-clickx-" },
        ["clickx"] = "clickX",
        ["clickY"] = { vt = 1, params = {}, docLink = "#ct-clicky-" },
        ["clicky"] = "clickY",
        ["objectClicked"] = { vt = "GameObj", params = {}, docLink = "#ct-objectclicked-" },
        ["objectclicked"] = "objectClicked",
        ["keyPressed"] = { vt = true, params = {{ name = "keyName", vt = "String"}}, docLink = "#ct-keypressed-" },
        ["keypressed"] = "keyPressed",
        ["charTyped"] = { vt = true, params = {{ name = "charString", vt = "String"}}, docLink = "#ct-chartyped-" },
        ["chartyped"] = "charTyped",
        ["loadSound"] = { vt = true, params = {{ name = "filename", vt = "String"}}, docLink = "#ct-loadsound-" },
        ["loadsound"] = "loadSound",
        ["sound"] = { vt = false, params = {{ name = "filename", vt = "String"}}, docLink = "#ct-sound-" },
        ["setSoundVolume"] = { vt = false, params = {{ name = "volume", vt = 1}}, docLink = "#ct-setsoundvolume-" },
        ["setsoundvolume"] = "setSoundVolume",
        ["random"] = { vt = 0, params = {{ name = "min", vt = 0},{ name = "max", vt = 0}}, docLink = "#ct-random-" },
        ["round"] = { vt = 0, params = {{ name = "number", vt = 1}}, docLink = "#ct-round-" },
        ["roundDecimal"] = { vt = 1, params = {{ name = "number", vt = 1},{ name = "numPlaces", vt = 0}}, docLink = "#ct-rounddecimal-" },
        ["rounddecimal"] = "roundDecimal",
        ["intDiv"] = { vt = 0, params = {{ name = "numerator", vt = 0},{ name = "denominator", vt = 0}}, docLink = "#ct-intdiv-" },
        ["intdiv"] = "intDiv",
        ["isError"] = { vt = true, params = {{ name = "number", vt = 1}}, docLink = "#ct-iserror-" },
        ["iserror"] = "isError",
        ["distance"] = { vt = 1, params = {{ name = "x1", vt = 1},{ name = "y1", vt = 1},{ name = "x2", vt = 1},{ name = "y2", vt = 1}}, docLink = "#ct-distance-" },
        ["getTimer"] = { vt = 0, params = {}, docLink = "#ct-gettimer-" },
        ["gettimer"] = "getTimer",
        ["getVersion"] = { vt = 1, params = {}, docLink = "#ct-getversion-" },
        ["getversion"] = "getVersion",
        ["toInt"] = { vt = 0, params = {{ name = "number", vt = 1}}, docLink = "#ct-toint-" },
        ["toint"] = "toInt",
        ["parseInt"] = { vt = 0, params = {{ name = "str", vt = "String"}}, docLink = "#ct-parseint-" },
        ["parseint"] = "parseInt",
        ["canParseInt"] = { vt = true, params = {{ name = "str", vt = "String"}}, docLink = "#ct-canparseint-" },
        ["canparseint"] = "canParseInt",
        ["parseNumber"] = { vt = 1, params = {{ name = "str", vt = "String"}}, docLink = "#ct-parsenumber-" },
        ["parsenumber"] = "parseNumber",
        ["canParseNumber"] = { vt = true, params = {{ name = "str", vt = "String"}}, docLink = "#ct-canparsenumber-" },
        ["canparsenumber"] = "canParseNumber",
        ["formatDecimal"] = { vt = "String", min = 1, params = {{ name = "number", vt = 1},{ name = "numPlaces", vt = 0}}, docLink = "#ct-formatdecimal-" },
        ["formatdecimal"] = "formatDecimal",
        ["formatInt"] = { vt = "String", min = 1, params = {{ name = "number", vt = 0},{ name = "numDigits", vt = 0}}, docLink = "#ct-formatint-" },
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
        ["getType"] = { vt = "String", params = {}, docLink = "#obj-gettype-" },
        ["gettype"] = "getType",
        ["getText"] = { vt = "String", params = {}, docLink = "#obj-gettext-" },
        ["gettext"] = "getText",
        ["setText"] = { vt = false, params = {{ name = "text", vt = "String"}}, docLink = "#obj-settext-" },
        ["settext"] = "setText",
        ["toString"] = { vt = "String", params = {}, docLink = "#obj-tostring-" },
        ["tostring"] = "toString",
        ["setSize"] = { vt = false, params = {{ name = "width", vt = 1},{ name = "height", vt = 1}}, docLink = "#obj-setsize-" },
        ["setsize"] = "setSize",
        ["align"] = { vt = false, min = 1, params = {{ name = "alignment", vt = "String"},{ name = "adjustY", vt = true}}, docLink = "#obj-align-" },
        ["setFillColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "#obj-setfillcolor-" },
        ["setfillcolor"] = "setFillColor",
        ["setFillColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "#obj-setfillcolorrgb-" },
        ["setfillcolorrgb"] = "setFillColorRGB",
        ["setLineColor"] = { vt = false, params = {{ name = "color", vt = "String"}}, docLink = "#obj-setlinecolor-" },
        ["setlinecolor"] = "setLineColor",
        ["setLineColorRGB"] = { vt = false, params = {{ name = "red", vt = 0},{ name = "green", vt = 0},{ name = "blue", vt = 0}}, docLink = "#obj-setlinecolorrgb-" },
        ["setlinecolorrgb"] = "setLineColorRGB",
        ["getLayer"] = { vt = 0, params = {}, docLink = "#obj-getlayer-" },
        ["getlayer"] = "getLayer",
        ["setLayer"] = { vt = false, params = {{ name = "layer", vt = 0}}, docLink = "#obj-setlayer-" },
        ["setlayer"] = "setLayer",
        ["delete"] = { vt = false, params = {}, docLink = "#obj-delete-" },
        ["clicked"] = { vt = true, params = {}, docLink = "#obj-clicked-" },
        ["containsPoint"] = { vt = true, params = {{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "#obj-containspoint-" },
        ["containspoint"] = "containsPoint",
        ["hit"] = { vt = true, params = {{ name = "objTest", vt = "GameObj"}}, docLink = "#obj-hit-" },
        ["objectHitInGroup"] = { vt = "GameObj", params = {{ name = "group", vt = "String"}}, docLink = "#obj-objecthitingroup-" },
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
        ["abs"] = { vt = 1, overloaded = true, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["acos"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["asin"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["atan"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["atan2"] = { vt = 1, params = {{ name = "y", vt = 1},{ name = "x", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["ceil"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["cos"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["cosh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["exp"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["floor"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["log"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["log10"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["max"] = { vt = 1, overloaded = true, params = {{ name = "number1", vt = 1},{ name = "number2", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["min"] = { vt = 1, overloaded = true, params = {{ name = "number1", vt = 1},{ name = "number2", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["pow"] = { vt = 1, params = {{ name = "number", vt = 1},{ name = "exponent", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["sin"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["sinh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["sqrt"] = { vt = 1, params = {{ name = "number", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["tan"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
        ["tanh"] = { vt = 1, params = {{ name = "angle", vt = 1}}, docLink = "#java-math-class-methods-and-fields-supported" },
    }
},

["string"] = "String",

["String"] = {
    name = "String",
    fields = {
    },
    methods = {
        ["compareTo"] = { vt = 0, params = {{ name = "str2", vt = "String"}}, docLink = "#java-string-class-methods-supported" },
        ["compareto"] = "compareTo",
        ["equals"] = { vt = true, params = {{ name = "str2", vt = "String"}}, docLink = "#java-string-class-methods-supported" },
        ["indexOf"] = { vt = 0, params = {{ name = "strFind", vt = "String"}}, docLink = "#java-string-class-methods-supported" },
        ["indexof"] = "indexOf",
        ["length"] = { vt = 0, params = {}, docLink = "#java-string-class-methods-supported" },
        ["substring"] = { vt = "String", min = 1, params = {{ name = "beginIndex", vt = 0},{ name = "endIndex", vt = 0}}, docLink = "#java-string-class-methods-supported" },
        ["toLowerCase"] = { vt = "String", params = {}, docLink = "#java-string-class-methods-supported" },
        ["tolowercase"] = "toLowerCase",
        ["toUpperCase"] = { vt = "String", params = {}, docLink = "#java-string-class-methods-supported" },
        ["touppercase"] = "toUpperCase",
        ["trim"] = { vt = "String", params = {}, docLink = "#java-string-class-methods-supported" },
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
        ["start"] = { vt = false, params = {}, docLink = "#start" },
        ["update"] = { vt = false, params = {}, docLink = "#update" },
        ["onMousePress"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "#onmousepress" },
        ["onmousepress"] = "onMousePress",
        ["onMouseDrag"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "#onmousedrag" },
        ["onmousedrag"] = "onMouseDrag",
        ["onMouseRelease"] = { vt = false, params = {{ name = "obj", vt = "GameObj"},{ name = "x", vt = 1},{ name = "y", vt = 1}}, docLink = "#onmouserelease" },
        ["onmouserelease"] = "onMouseRelease",
        ["onKeyPress"] = { vt = false, params = {{ name = "keyName", vt = "String"}}, docLink = "#onkeypress" },
        ["onkeypress"] = "onKeyPress",
        ["onKeyRelease"] = { vt = false, params = {{ name = "keyName", vt = "String"}}, docLink = "#onkeyrelease" },
        ["onkeyrelease"] = "onKeyRelease",
        ["onCharTyped"] = { vt = false, params = {{ name = "charString", vt = "String"}}, docLink = "#onchartyped" },
        ["onchartyped"] = "onCharTyped",
        ["onResize"] = { vt = false, params = {}, docLink = "#onresize" },
        ["onresize"] = "onResize",
        ["main"] = { vt = false, params = {{ name = "args", vt = { vt = "String" }}}, docLink = "#main" },
    }
},

}
