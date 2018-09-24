Code 12 API Documentation
=========================
The design of the Code 12 API is (c)Copyright 2018 by David C. Parker.

##### Global (ct) APIs
* [Text Output](#text-output)
* [Alerts and Input Dialogs](#alerts-and-input-dialogs)
* [Screen Management](#screen-management)
* [GameObj Creation](#gameobj-creation)
* [Mouse and Keyboard Input](#mouse-and-keyboard-input)
* [Audio](#audio)
* [Math and Misc.](#math-and-misc)
* [Type Conversion](#type-conversion)

##### GameObj Fields and Methods
* [GameObj Public Data Fields](#gameobj-public-data-fields)
* [GameObj Methods](#gameobj-methods)

##### Java Class Methods and Fields Supported
* [Math Class](#java-math-class-methods-and-fields-supported)
* [String Class](#java-string-class-methods-supported)

##### Events (Client Functions)
* [Events](#events)

##### Appendix: Pre-Defined Names
* [Color Names](#color-names)
* [Key Names](#key-names)

_____________________________________________________________________
Text Output
-----------

### ct.print()
```
ct.print( Object value )
```
Print the text representation of a value to the console.
The `value` can be a variable or expression of any type.
No newline or extra characters are added.

> This is equivalent to Java's `System.out.print`.

### ct.println()
```
ct.println( Object value )
ct.println( )
```
Print the text representation of a value to the console,
and add a newline afterwards.
The `value` can be a variable or expression of any type.
If `value` is not included, just a newline is printed.

> This is equivalent to Java's `System.out.println`.

### ct.log()
```
ct.log( Object... values )
```
Print any number of values to the console.
There can be any number of variables or expressions passed, of any types.
If multiple values are given, they are printed on one line separated by commas.
Strings are enclosed in ``"double quotes"``,
and `GameObj` objects are described in `[square brackets]`.

### ct.logm()
```
ct.logm( String message, Object... values )
```
Print the `message` followed by a space, then print the values
(any number of variables or expressions) to the console.
The values are output in the same way as `ct.logm()` (see above).

### ct.setOutputFile()
```
ct.setOutputFile( String filename )
```
If you call `ct.setOutputFile()`, then any subsequent text output
from `ct.print()`, `ct.println()`, `ct.log()`, and `ct.logm()` will be 
written to a text file named `filename` in addition to being displayed
in the console window. Call `ct.setOutputFile( null )` to restore output
to appearing in the console only.

The `filename` should be a simple filename such as `"output.txt"`,
which will be written to the same folder as the source code file, or a
relative path starting from the source code folder, such as
`"output/nameList.txt"`.

> If there is an existing file named `filename` then it will be deleted
> and written over. Note that each time you run your program and call 
> `ct.setOutputFile()` to a certain filename, it will overwrite the
> previous file. 

_____________________________________________________________________
Alerts and Input Dialogs
------------------------

### ct.showAlert()
```
ct.showAlert( String message )
```
Display `message` in a popup alert dialog. 
Execution of the program will pause and wait for the user to press
the OK button on the dialog or press the Enter key on the keyboard.

> The `message` can contain line breaks by embedding 
> newline (`\n`) characters in the string.

### ct.inputInt()
```
int ct.inputInt( String message )
```
Display `message` in a popup dialog box that allows the user to
enter a number.
Execution of the program will pause and wait until the user
enters a valid integer. The resulting integer value is returned.

### ct.inputNumber()
```
double ct.inputNumber( String message )
```
Display `message` in a popup dialog box that allows the user to
enter a number.
Execution of the program will pause and wait until the user
enters a valid number. The resulting numeric value is returned.

### ct.inputYesNo()
```
boolean ct.inputYesNo( String message )
```
Display `message` in a popup dialog box that has two buttons
labelled Yes and No.
Execution of the program will pause and wait until the user
presses one of the buttons. The function returns `true` if the
user presses Yes and `false` if they press No.

### ct.inputString()
```
String ct.inputString( String message )
```
Display `message` in a popup dialog box that allows the user to
enter a text string.
Execution of the program will pause and wait until the user
presses the Enter key to end the text input. 
The resulting String value is returned.

> If the user presses the Enter key without entering any other
> characters, then an empty string (`""`) will be returned.

_____________________________________________________________________
Screen Management
-----------------

### ct.setTitle()
```
ct.setTitle( String title )
```
Set the title of the application window to `title`.
If and where the title displays depends on the platform that
the application is running on.
The title will not display on mobile devices.

### ct.setHeight()
```
ct.setHeight( double height )
```
Set the height of the application window in coordinate units.
The width of the application window in display units is always 100.0
by definition, so this function sets the height relative to its width 
as a percent. The default height is 100.0, resulting in a square window.

> Coordinate units are not pixels, because the Code12 graphics window 
> scales your game up and down automatically when the window size changes.
> You can think of coordinate units as a percent of the window width,
> so an x-coordiante of 50 is always horizontally centered in the window.

> **Note**: On some platforms, you may have limited or no control over the
> window size or aspect ratio. On mobile devices, the application will always 
> fill the entire device screen. In this case, `ct.setHeight()` will determine 
> whether the application runs in portrait or landscape orientation.
> If `height` is less than 100 then the application will run in landscape mode,
> otherwise portrait mode.

> After calling `ct.setHeight()`, you can call `ct.getHeight()` to determine the
> actual height of the window.

##### Examples
```
ct.setHeight( 100 );               // default square window
ct.setHeight( 200 );               // window is twice as tall as wide
ct.setHeight( 100.0 * 9 / 16 );    // 16:9 aspect landscape
double height = ct.getHeight();    // get actual height used
```

### ct.getWidth()
```
double ct.getWidth( )
```
This function always returns 100.0, which is the width of the
application window in coordinate units by definition.

### ct.getHeight()
```
double ct.getHeight( )
```
Return the height of the the application window in coordinate units.
This is 100.0 by default, unless it is changed by `ct.setHeight()`.

### ct.getPixelsPerUnit()
```
double ct.getPixelsPerUnit( )
```
Return the current scale factor from display coordinate units
to device pixels. The contents of your application scale automatically
relative to the window size, and the width of the window is
always defined as 100 in coordinate units. If you want to
determine the physical size of the application window in pixels,
you can calculate this as:
```
int pixelWidth = ct.round( ct.getWidth() * ct.getPixelsPerUnit() );
int pixelHeight = ct.round( ct.getHeight() * ct.getPixelsPerUnit() );
```
> Note that the definition of a "pixel" is platform-dependent,
> and some devices with very high resolution (e.g. 4K or Retina)
> may use more than 1 physical pixel per reported "pixel".

### ct.getScreen()
```
String ct.getScreen( )
```
Return the name of the current screen.
Your application can define multiple named screens
and switch between them (see `ct.setScreen()`).
The default screen name is "" (empty string) if it has
not been changed.

### ct.setScreen()
```
ct.setScreen( String name )
```
Set the current application screen to the screen named `name`.
Your application can define multiple named screens
and switch between them. Each screen has its own background
and its own `GameObj` objects.

If a screen named `name` is not already known,
then create a new empty screen with this name and set it as the
current screen.

`GameObj` objects that are created are always created on
the current screen, so to create two screens in your `start`
function:
1. Call `ct.setScreen()` to name the first screen
2. Create `GameObj` objects for the first screen
3. Call `ct.setScreen()` to name the second screen
4. Create `GameObj` objects for the second screen
5. At the end of `start`, call `ct.setScreen()` to set the
desired starting screen for your application.

### ct.setScreenOrigin()
```
ct.setScreenOrigin( double x, double y )
```
Offset the entire screen horizontally and/or vertically so that
the coordinate at the upper-left of the screen is (`x`, `y`).
Normally the coordinate of the upper-left corner of the screen
is (0, 0). Using `ct.setScreenOrigin()` allows you to think of
the screen as a window viewing part of a larger world, and you
can pan ("scroll") the window where you want, in order to bring 
objects that would normally be outside the window into view.

> Using `ct.setScreenOrigin()` does not modify the (x, y) position
> of any objects. Rather it determines which objects are visible
> within the game window.

> Note that it is always OK to create or position objects outside 
> of the normal screen bounds. The x-coordinate of the right edge
> of the screen is normally 100. If you draw a small object at say
> (150, 50), it will normally not be visible. If you then call
> `ct.setScreenOrigin( 150, 0 )`, the game will "scroll" horizontally
> and the object will become visible in the center of the game window.
> Conversely, another object at (50, 0) will scroll off the screen
> to the left and no longer be visible.

> The screen's background image (see [ct.setBackImage](#ctsetbackimage)),
> if any, is not affected by the screen origin. If you want a background image
> that scrolls, you can use [ct.image](#ctimage) to create and display one 
> that is larger than the normal screen window.

### ct.clearScreen()
```
ct.clearScreen( )
```
Remove and delete all `GameObj` objects on the current screen.
The background color or image is kept.

### ct.clearGroup()
```
ct.clearGroup( String group )
```
Remove and delete all `GameObj` objects on the current screen
whose group name (see the `group` field of a `GameObj`)
matches the `group` passed.

The default group name for objects not assigned a group
name is "" (empty string).


### ct.setBackColor()
```
ct.setBackColor( String color )
```
Set the background color of the current screen to the
pre-defined color named `color`. See [Color Names](#color-names).

### ct.setBackColorRGB()
```
ct.setBackColorRGB( int red, int green, int blue )
```
Set the background color of the current screen to the
custom RGB color with components `red`, `green`, and `blue`
in the range 0-255.

### ct.setBackImage()
```
ct.setBackImage( String filename )
```
Set the background image of the current screen to the image `filename`.
The image file must be in PNG or JPG format. The background image is
centered and cropped automatically to show as much of the image as
possible given the aspect ratio of the window,
while preserving the aspect ratio of the image.

If `filename` is a simple filename (no path),
then the main project folder is checked first, followed by
the `Code12/images` folder if not found in the project folder.


_____________________________________________________________________
GameObj Creation
----------------

### ct.circle()
```
GameObj ct.circle( double x, double y, double diameter )
GameObj ct.circle( double x, double y, double diameter, String color )
```
Create and add a circle object to the current screen
with the given (`x`, `y`) location and `diameter`.
Return the `GameObj` reference to the circle object.

Circle objects default to a fill color of "red",
a line color of "black", and a line width of 1.
If `color` is included then set the circle's fill color
to the given named color. See [Color Names](#color-names).

### ct.rect()
```
GameObj ct.rect( double x, double y, double width, double height )
GameObj ct.rect( double x, double y, double width, double height, String color )
```
Create and add a rectangle object to the current screen
with the given (`x`, `y`) location and size given by `width` and `height`.
Return the `GameObj` reference to the rectangle object.

Rectangle objects default to a fill color of "yellow",
a line color of "black", and a line width of 1.
If `color` is included then set the rectangle's fill color
to the given named color. See [Color Names](#color-names).

### ct.line()
```
GameObj ct.line( double x1, double y1, double x2, double y2 )
GameObj ct.line( double x1, double y1, double x2, double y2, String color )
```
Create and add a line object to the current screen
from point (`x1`, `y1`) to point (`x2`, `y2`).
Return the `GameObj` reference to the line object.

Line objects default to a line color of "black", and a line width of 1.
(Lines have no fill color).
If `color` is included then set the line's color
to the given named color See [Color Names](#color-names).

### ct.text()
```
GameObj ct.text( String s, double x, double y, double height )
GameObj ct.text( String s, double x, double y, double height, String color )
```
Create and add a text object to the current screen
with text string `s`, at location (`x`, `y`),
and height given by `height`. The font size is determined
automatically to fit within the `height`.
The object width is determined automatically
to be wide enough to contain the string `s` on one line.
Return the `GameObj` reference to the text object.

Text objects default to a text (fill) color of "black"
and have no line color.
If `color` is included then set the text's color
to the given named color. See [Color Names](#color-names).

### ct.image()
```
GameObj ct.image( String filename, double x, double y, double width )
```
Create and add an image object to the current screen
with the image `filename`, at location (`x`, `y`),
and width given by `width`. The height is determined
automatically to preserve the original image's aspect ratio.
Return the `GameObj` reference to the image object.

The image file must be in PNG or JPG format.

_____________________________________________________________________
Mouse and Keyboard Input
------------------------
### ct.clicked()
```
boolean ct.clicked( )
```
Return `true` if a mouse click or touch occured in the application
window during the last update cycle. Calling this function
every time in your `update` function will detect all mouse clicks.

If this function returns true then you can retrive the click location
using `ct.clickX()` and `ct.clickY()`.

### ct.clickX()
```
double ct.clickX( )
```
Return the x-coordinate of the last known click, touch, or drag location
in the application.

### ct.clickY()
```
double ct.clickY( )
```
Return the y-coordinate of the last known click, touch, or drag location
in the application.

### ct.objectClicked()
```
GameObj ct.objectClicked( )
```
If a clickable `GameObj` object was clicked during the last update cycle, 
then `ct.objectClicked()` returns a reference to that object, 
otherwise it returns `null` .
Calling this function every time in your `update` function will find 
the topmost clickable object that was clicked, whenever the user clicks
on one.

> Any objects with the `clickable` field set to `false` will not be considered
> when determining which object was clicked. See [clickable](#clickable). 

> Note that `ct.objectClicked()` will return `null` if no object was
> clicked, which is the case for most update cycles in a game 
> (they occur 60 times per second). So you must check the return value
> for `null` before using the `GameObj` returned. Attempting to access a field
> of a `GameObj` (such as `obj.x`) or call a method (such as `obj.delete()`)
> will generate a runtime error (a "crash") if the `GameObj` is `null`.


### ct.keyPressed()
```
boolean ct.keyPressed( String keyName )
```
Return `true` if the key named `keyName` is currently pressed
(the key is down). See [Key Names](#key-names).
Note that multiple keys can be down at the same time.

### ct.charTyped()
```
boolean ct.charTyped( String charString )
```
Return `true` if the printable character `charString` was typed
during the last update cycle.

Calling this function every time in your `update` function
will detect any time that the given character is typed.

> Unlike the key names used by `ct.keyPressed()`, the `charString` here
> is a printable character including the appropriate shift status
> (e.g. "A" if a shifted "a" is typed, "$" or "4", "+" vs. "=", etc.).
> Only printable characters are detected, so key sequences such as Ctrl+C
> do not result in characters.

> Note that some platforms may have keys that auto-repeat when held down,
> so if you check `ct.charTyped()` every time in your `update` function,
> and the user holds down a key, you may get the first character,
> then perhaps a 1 second delay, then repeats at around 8 characters
> per second. Contrast this with using `ct.keyPressed()` instead, where you
> will get a `true` result continuously (60 times per second),
> and no delay after the first one.

_____________________________________________________________________
Audio
-----
### ct.loadSound()
```
boolean ct.loadSound( String filename )
```
You can call `ct.loadSound` to pre-load the sound effect in the sound file 
`filename`, so that it will play quickly when `ct.sound( filename )` is 
called. Loading sounds before playing them is optional, but it reduces the
slight delay that occurs the first time a certain sound is played. 

This function returns `true` if the sound was successfully loaded,
or `false` if the filename could not be found or is not a supported 
sound format.

> You will typically want to call `ct.loadSound` in your `start` function
> once for each sound that you want pre-loaded.

### ct.sound()
```
ct.sound( String filename )
```
Play the sound effect in the sound file `filename`.

> Only standard formats of WAV sounds are reliable on all platforms,
> although most platforms will support MP3 also.

> You can use `ct.loadSound` to reduce the short delay that might occur
> the first time a certain sound is played.

### ct.setSoundVolume()
```
ct.setSoundVolume( double volume )
```
Set the relative volume to use for sounds played by `ct.sound()`
to `volume`, which should be between 0.0 and 1.0.
The default sound volume is 1.0. If the volume is decreased
then sounds are attenuated relative to the volume they were recorded at.

_____________________________________________________________________
Math and Misc.
--------------
### ct.random()
```
int ct.random( int min, int max )
```
Return a random integer from `min` to `max` (inclusive).

### ct.round()
```
int ct.round( double number )
```
Return the `number` rounded to the nearest integer.

### ct.roundDecimal()
```
double ct.roundDecimal( double number, int numPlaces )
```
Return the `number` rounded to `numPlaces` decimal places.

### ct.intDiv()
```
int ct.intDiv( int numerator, int denominator )
```
Return the result of an integer divide of `numerator / denominator`. 
If `numerator / denominator` is not an integer, the result is rounded 
down to the next smaller integer.
If `denominator` is 0 then the result is a large positive integer 
if `numerator` > 0, a large negative integer if `numerator` < 0, 
and 0 if `numerator` is 0. 

### ct.isError()
```
boolean ct.isError( double number )
```
Return `true` if the value of `number` is an error value 
(NaN = "Not a Number").

### ct.distance()
```
double ct.distance( double x1, double y1, double x2, double y2 )
```
Return the distance between the points (`x1`, `y1`) and (`x2`, `y2`).

### ct.getTimer()
```
int ct.getTimer( )
```
Return the number of milliseconds since the application started.
Time starts at the begining of the `start` function.

### ct.getVersion()
```
double getVersion( )
```
Return the version number of the Code12 runtime system.

_____________________________________________________________________
Type Conversion
---------------
### ct.toInt()
```
int ct.toInt( double number )
```
Return the `number` truncated to an integer.

> All decimal places are lost.
> This is equivalent to a type cast from double to int.
> If you wish to round, use `ct.round()` instead.

### ct.parseInt()
```
int ct.parseInt( String str )
```
If `str` can be converted to (parsed as) an integer,
then return the integer value, otherwise return 0.

> Since 0 is a valid integer, it is a good idea to
> test the string with `ct.canParseInt()` first.

### ct.canParseInt()
```
boolean ct.canParseInt( String str )
```
If `str` can be converted to (parsed as) an integer,
then return `true`, otherwise return `false`.

### ct.parseNumber()
```
double ct.parseNumber( String str )
```
If `str` can be converted to (parsed as) a number,
then return the value as a `double`,
otherwise return the NaN (Not a Number) error value.

> To test for NaN, use `ct.isError()`

### ct.canParseNumber()
```
boolean ct.canParseNumber( String str )
```
If `str` can be converted to (parsed as) a number,
then return `true`, otherwise return `false`.

### ct.formatDecimal()
```
String ct.formatDecimal( double number )
String ct.formatDecimal( double number, int numPlaces )
```
Return the value of `number` converted to a string.
If `numPlaces` is included, then format the output
to exactly this many places past the decimal point,
rounding or adding extra zeros as necessary.

### ct.formatInt()
```
String ct.formatInt( int number )
String ct.formatInt( int number, int numDigits )
```
Return the value of `number` converted to a string.
If numDigits is included, then format to this many digits,
adding leading zeros as necessary.

_____________________________________________________________________
GameObj Public Data Fields
--------------------------
`GameObj` objects are graphics objects visible on the screen.
See [GameObj Creation](#gameobj-creation) to create a `GameObj`.
All `GameObj` objects have the following public data fields,
which can be accessed or assigned to at any time.
If assigned to, the new value takes effect at the next
update cycle.

### x, y
```
double x, y
```
The `x` and `y` fields specify the position of the object
in the application window, in graphics coordinates.
By default, graphics coordinates range from 0 to 100 in both x and y
if the window is square. If the window is not square (see `ct.setHeight()`),
then x coordinates still range from 0 (left edge) to 100 (right edge),
but y coordiantes will range from 0 (top edge) to the value returned
by `ct.getHeight()` (bottom edge).

> By default, objects are positioned by their center, so (`x`, `y`)
> will be the center of the object. However, this can be modified
> by the `GameObj` method `obj.align()`.

> It is not an error to position an object outside the application window,
> it will simply not be visible or will clip at the window boundary.

### width, height
```
double width, height
```
The `width` and `height` fields specify the size of the object
in graphics coordinates. The different types of `GameObj` objects
react somewhat differently to changes in size, as follows:

##### circle
Although circles are always created round, you can create an ellipse
by setting different `width` and `height` values.

##### rect
Rectangles can be any size and adjust to any `width` and `height`.

##### line
Line objects are created between two points. After creation,
the `x` and `y` fields are the location of the first point,
and the `width` and `height` fields specify signed offsets
(can be negative) from the first point to the second point.
Thus, the location of the second point is
(`x` + `width`, `y` + `height`). You can change any of the
`x`, `y`, `width`, or `height` fields, and the line will adjust.

> Note that unlike any of the other `GameObj` object types,
> a line may have negative values for the `width` and `height`
> fields. The physical width and height of the line's bounding
> box can be reliably determined with  
> `Math.abs(line.width)` and `Math.abs(line.height)`.
> This does not include the thickness of the drawn line itself
> (see `lineWidth` below).

##### text
Text objects use a font size that is automatically determined by
the object's `height`, and the object's `width` is calculated
automatically. So, changing `height` will change the font size,
and changes to the `width` field are undefined.

> **Note:** When you change a text object's `height`, the `width`
> will be recalculated automatically. However, the new value for
> `width` is not available immediately. It will be recalculated
> the next time the object draws (during the next update cycle).

##### image
Images are initially created with `height` calculated automatically
to preserve the image's aspect ratio given the specified `width`.
However, once created, you can set any values for `width` and `height`,
and the image will scale and/or stretch as necessary to fill the space.

### xSpeed, ySpeed
```
double xSpeed, ySpeed
```
The `xSpeed` and `ySpeed` fields can be used to make an object move
automatically at the specified speed and direction.
The `xSpeed` and `ySpeed` values are added to the object's
`x` and `y` fields at the beginning of each update cycle.
Update cycles happen 60 times per second, so setting `xSpeed` to 1
will make the object move 60 units per second to the right.
The values for `xSpeed` and `ySpeed` can be positive or negative,
and they both default to 0.

> You can change `xSpeed` and/or `ySpeed` at any time to change
> the speed or direction of an object.

### lineWidth
```
int lineWidth
```
If an object has a line color (see the `GameObj` methods `obj.setLineColor()`
and `obj.setLineColorRGB()`), then the object will be outlined in this color
with a stroke of approximately `lineWidth` pixels. The default is 1.

> Unlike normal coordinate values, `lineWidth` values are measured in
> approximate device "pixels", so apparent line thickness does not scale
> up as the window size is increased. The definition of "pixels" depends
> on the platform and may vary, but the overall intent is that on a
> screen of "normal" resolution (e.g. HD resolution, not 4K or Retina),
> a `lineWidth` of 1 will result in an appoximate 1 pixel border.
> High resolution screens may use multiple pixels, and some platforms
> may use partial pixels for a smoother appearance (anti-aliasing).

### visible
```
boolean visible
```
The `visible` field defaults to `true`, but you can set it to `false`
to hide the object. Hidden objects are effectively disabled, and will
not draw or respond to mouse/touch input.

### clickable
```
boolean clickable
```
The `clickable` field defaults to `true`, so by default all `GameObj` objects 
can be used to respond to click/touch input
(see [ct.objectClicked](#ctobjectclicked), [obj.clicked](#objclicked), and
[onMousePress](#onmousepress)).
However, if you set an object's `clickable` field to false, then it will ignore
clicks and pass them through to the object below, if any. 
 
> If you stack two objects and want to use the bottom object to test for hits
> (for example a rectangle with a text label on top of it), then you can
> set the `clickable` field of the top object to `false`, which will cause
> the click to "pass through" to the object below it.

### autoDelete
```
boolean autoDelete     // auto delete if it goes from on to off-screen
```
If you set the `autoDelete` field of an object to `true` (default `false`),
then the object will be automatically deleted if it moves off-screen
(outside of the application window).

> If an object is created initially off-screen, it will not be automatically
> deleted until it has moved on-screen, then off-screen again.

### group
```
String group
```
The `group` field is an optional name that you can assign to an object
that will cause the function `ct.clearGroup()` to delete all objects with
the matching group name. The default group name of an object is ""
(empty string)

_____________________________________________________________________
GameObj Methods
---------------
The following method functions must be called on an existing `GameObj`
object (see [GameObj Creation](#gameobj-creation)). In the syntax shown,
the `obj` can be any variable of type `GameObj`.

### obj.getType()
```
String obj.getType( )
```
Return the type name of the `GameObj` object, which is one of:
`"circle"`, `"rect"`, `"line"`, `"text"`, or `"image"`.

### obj.getText()
```
String obj.getText( )
```
Return the text of the object.
For a `"text"` object, this is the visible text.
For other objects, this is just a string kept inside the object,
which can be used to identity or describe the object.
For an `"image"` object,  the text defaults to the image filename,
but you can change it to something else (see `obj.setText` below).

> The `obj.toString()` method (see below) includes the object text
> in the description of an object.

### obj.setText()
```
obj.setText( String text )
```
Set the text of an object to `text`. If the object is a text object,
setting the text will cause the visible text to change.
For other object types, the text is simply stored in the object
(See `obj.getText( )` above).

### obj.toString()
```
String obj.toString( )
```
Return a string description of the object suitable for printing
for diagnostic purposes (via `ct.println()`, `ct.log()`, etc.)
The string will include the type name of the object,
the (`x`, `y`) coordinates rounded to the nearest integer,
and the text of the object, if any. The entire string
is enclosed in square brackets.

##### Examples:
```
[circle at (70, 25)]
[text at (50, 10) "Score 3200"]
[image at (21, 83) "goldfish.png"]
[image at (21, 83) "hero"]
[rect at (50, 100) "bottom wall"]
```

### obj.setSize()
```
obj.setSize( double width, double height )
```
Set the size of the object using `width` and `height`.
This is just a convenience method that is equivalent to
setting both the `width` and `height` fields.
Note that different types of objects react differently to changes
in width or height. (see [width, height](#width-height) above).

### obj.align()
```
obj.align( String alignment )
obj.align( String alignment, boolean adjustY )
```
Set the alignment of the object to `alignment`.
The alignment is a description of where where the object is
positioned on screen relative to its `x` and `y` coordinates.
By default, objects are positioned by their center point,
so that (`x`, `y`) is at the horizontal and vertical center
of the object.

The following alignments are supported, which describe the
location of (`x`, `y`) on the object:

```
"top left"
"top"             or "top center"
"top right"
"left"            (vertically centered)
"center"          (vertically centered)
"right"           (vertically centered)
"bottom left"
"bottom"          or "bottom center"
"bottom right"
```

If `adjustY` is included and `true`, then the object will be automatically
repositioned to maintain its relative vertical position in the
application window if the window is resized and changes aspect ratio.
This can be used to easily make objects stick to the bottom of the window,
or stay in the vertical center of the window, etc.

Note that all objects always automatically adjust their
horizontal position when the window is resized (because display
coordinates are relative to a width of 100), and that vertical positions
are also relative to the window's overall size, and thus also adjust
when the window resizes. The effect of `adjustY` is only relevant to
help adjust for changes in the aspect ratio of the window.

### obj.setFillColor()
```
obj.setFillColor( String color )
```
Set the fill color of the object (text color for text objects) to the
pre-defined color named `color`. See [Color Names](#color-names).
If `color` is `null` then the fill is removed from the object.

### obj.setFillColorRGB()
```
obj.setFillColorRGB( int red, int green, int blue )
```
Set the fill color of the object (text color for text objects) to 
the custom RGB color with components `red`, `green`, and `blue` 
in the range 0-255.

### obj.setLineColor()
```
obj.setLineColor( String color )
```
Set the line color of the object (the outline stroke color for objects
other than line objects) to the pre-defined color named `color`.
See [Color Names](#color-names).
If `color` is `null` then the stroke is removed from the object.

### obj.setLineColorRGB()
```
obj.setLineColorRGB( int red, int green, int blue )
```
Set the line color of the object (the outline stroke color for objects
other than line objects) to the custom RGB color with components
`red`, `green`, and `blue` in the range 0-255.

### obj.getLayer()
```
int obj.getLayer( )
```
Return the layer number for the object. See `obj.setLayer()` below.

### obj.setLayer()
```
obj.setLayer( int layer )
```
Set the layer number for the object. The layer number can be used to
easily control the stacking order of groups of objects. The default
layer is 1, and you can set any integer value. After the background
color or image, object layers are drawn from the lowest value first
(in the back) to the highest values (in the front).

Within a layer, objects are drawn in the order that they were created
or set to that layer number. Calling `obj.setLayer()` always re-inserts
an object at the top of that layer.

### obj.delete()
```
obj.delete( )
```
Remove and delete the object from the screen.

> Attempting to access the fields or methods of an object after it has
> been deleted may result in unpredictable behavior.

### obj.clicked()
```
boolean obj.clicked( )
```
Return `true` if the object was clicked or touched during
the last update cycle. Only objects with both the `visible` and `clickable`
fields set to `true` will receive mouse/touch input.

Calling this method for an object every time during your `update` function
will detect any clicks on the object.

> If more than one visible and clickable object intersects with the
> location of a click or touch, the topmost one will receive the click.
> Objects that are not both visible and clickable are ignored when
> determining the object that was clicked.

### obj.containsPoint()
```
boolean obj.containsPoint( double x, double y )
```
Return `true` if the point (`x`, `y`) lies within the interior
of the object, or on the border.

> Text and image objects use the rectangular bounds of the object
> for the test. Circles (or ellipses) use the curved shape.
> Lines have no interior and always return `false`.

### obj.hit()
```
boolean obj.hit( GameObj objTest )
```
Return `true` if the object currently intersects with another 
object `objTest`. If you call this method every time in your `update` 
function, it can be used to test if/when two objects "hit" each other.

### obj.objectHitInGroup( String group )
```
GameObj obj.objectHitInGroup( String group )
```
If the object currently intersects with another `GameObj` object
on the current screen that has its [group](#group) field equal to `group`,
then return a reference to the other object, otherwise return `null`.
If the specified `group` is `null` then all objects on the current screen
will be considered.

> Note that `obj.objectHitInGroup()` will return `null` if no 
> matching object intersects `obj`, so you must check the return value
> for `null` before using the `GameObj` returned.

_____________________________________________________________________
Java Math Class Methods and Fields Supported
--------------------------------------------
The following fields and functions from the Java `Math` class are supported.
```
double  Math.E
double  Math.PI
double  Math.abs( double number )
int     Math.abs( int number )
double  Math.acos( double number )
double  Math.asin( double number )
double  Math.atan( double number )
double  Math.atan2( double y, double x)
double  Math.ceil( double number )
double  Math.cos( double angle )
double  Math.cosh( double angle )
double  Math.exp( double number )
double  Math.floor( double number )
double  Math.log( double number )
double  Math.log10( double number )
double  Math.max( double number1, double number2 )
int     Math.max( int number1, int number2 )
double  Math.min( double number1, double number2 )
int     Math.min( int number1, int number2 )
double  Math.pow( double number, double exponent )
double  Math.sin( double angle )
double  Math.sinh( double angle )
double  Math.sqrt( double number )
double  Math.tan( double angle )
double  Math.tanh( double angle )
```
_____________________________________________________________________
Java String Class Methods Supported
-----------------------------------
The following methods from the Java `String` class are supported.
```
int      str.compareTo( String str2 )
boolean  str.equals( String str2 )
int      str.indexOf( String strFind )
int      str.length()
String   str.substring( int beginIndex )
String   str.substring( int beginIndex, int endIndex )
String   str.toLowerCase()
String   str.toUpperCase()
String   str.trim()
```
_____________________________________________________________________
Events
------
The following functions, if defined in your program, will be called when
indicated. Note that unlike all of the other functions and methods above,
These functions are *implemented* in your program (you write the body of the
function) and are *called* by the runtime system with appropriate.
They are called in response to "events" happening in your application.

Implementing any of these functions is optional and "for your information".
They are not necessary to use other functions and features of the system.
For example, if you don't implement any of the mouse event functions,
you can still call functions such as `ct.clicked()` to test for mouse clicks.

> **Tip:** If your program has complex mouse or keyboard handling
> (for example, many objects to check for clicks and many keys to test),
> then doing your work in the event functions will be more efficient
> than making many tests in your `update` function.

### start()
```
void start( )
```
The `start` function is called once at the beginning of your program.
This is good place to create most of the objects for your program
(except for any objects that get created as a result of an action that
occurs while the application is running).

### update()
```
void update( )
```
The `update` function is called at the beginning of each update cycle.
Update cycles start after the `start` function has completed and then
repeat continuously at 60 times per second.

One use of update cycles is to achieve object motion and animation.
For example, if you move an object 1 display unit to the right in
your `update` function, then the object will move continuously
at 60 units per second.

Another use of update cycles is to poll (check repeatedly) for user input,
using functions such as `ct.clicked()`, `ct.keyPressed()`,
and `ct.keyTyped()`, and the `GameObj` method `obj.clicked()`.

You can also use update cycles to test repeatedly for object interactions
that can occur during any update cycle when objects are moving. You can
examine object fields such as `x` and `y` directly, call the `GameObj` methods
`obj.containsPoint()` and `obj.hit()`, call the function `ct.distance()` or
write any code you want that tests what you need to detect.

Finally, note that you can call `ct.getTimer()` to detect the passage
of certain amounts of time if you want.

> A common mistake is to create `GameObj` objects in the `update` function
> in a way that causes many copies of the object to be created over
> and over. Note that you should *not* call functions like `ct.circle()` to
> "draw" a circle for each frame in an animation. Instead, you typically
> want to call `ct.circle()` to create the object once in your `start` function,
> then modify the existing circle in your `update` function.

### onMousePress()
```
void onMousePress( GameObj obj, double x, double y )
```
This event is called each time a mouse click or touch is detected.
The point (`x`, `y`) is the location of the click in display coordinates
(relative to the top-left of the application window).

If `obj` is not `null`, then it indicates that the click occured on
that object. Note that `GameObj` objects must have both their
`visible` and `clickable` fields `true` to receive clicks.
If `obj` is null, then the click occured outside of any clickable object.

### onMouseDrag()
```
void onMouseDrag( GameObj obj, double x, double y )
```
After a click or touch has happened, if the user's mouse or finger is still
"down" and drags across the screen, then `onMouseDrag` will be called
each time the position changes (you may get many calls in succession).
The point (`x`, `y`) is the new location of the mouse/finger.

If `obj` is not `null`, then it indicates that the original click occured
on that clickable object (see `onMousePress` above).

> Note: Once a click occurs on a clickable `GameObj`, all drag events
> will be sent indicating this `obj`, even if the (`x`, `y`) location
> is no longer on the object (`GameObj` objects automatically take the
> mouse/touch "focus" when clicked).


### onMouseRelease()
```
void onMouseRelease( GameObj obj, double x, double y )
```
This event is called when a mouse click or touch ends, and the mouse button
or finger is "released". The point (`x`, `y`) is the location of the
mouse/finger at the time of the release.

If `obj` is not `null`, then it indicates that the original click occured
on that clickable object (see `onMousePress` above).

> Note: When a click occurs on a clickable `GameObj`, the release event
> will always be sent indicating this `obj`, even if the (`x`, `y`)
> location of the release is no longer on the object.

### onKeyPress()
```
void onKeyPress( String keyName )     // key code name e.g. "a", "up"
```
This event is called when a keyboard key has been pressed down.
The event is only called once for each separate press/release,
when the key is first pressed down, reagardless of how long the key
is held down.

The `keyName` is the name of the key. See [Key Names](#key-names).

### onKeyRelease()
```
void onKeyRelease( String keyName )   // key code name e.g. "a", "up"
```
This event is called when the keyboard key named `keyName`
has been released (after being pressed). See [Key Names](#key-names).

### onCharTyped()
```
void onCharTyped( String charString )     // "a", "A", "$", etc.
```
This event is called when keyboard action results in a printable
character being generated.

> Unlike the key names used by `onkeyPressed` above, the `charString`
> here is a printable character including the appropriate shift status
> (e.g. "A" if a shifted "a" is typed, "$" or "4", "+" vs. "=", etc.).
> Only printable characters are detected, so key sequences such as Ctrl+C
> do not result in characters.

> Note that some platforms may have keys that auto-repeat,
> so you may get multiple `onCharTyped` events if a key is held down.

### onResize()
```
void onResize()
```
This event is called if the application window is resized by the user,
to allow you to change any object positions or otherwise react as desired.
The contents of your application scale automatically relative to the window
size, so you don't need to do anything in the normal case. However, if your
object layout depends on the window aspect ratio or the physical pixel size,
then you can determine these as follows:
```
double aspectRatio = ct.getWidth() / ct.getHeight();
int pixelWidth = ct.round( ct.getWidth() * ct.getPixelsPerUnit() );
int pixelHeight = ct.round( ct.getHeight() * ct.getPixelsPerUnit() );
```

> Some systems resize windows continuously in response to the user re-sizing
> the window frame, so you may receive many `onResize` events in succession.

_____________________________________________________________________
Appendix: Pre-Defined Names
---------------------------

### Color Names
The following named colors are supported.
If a string used as a color is not recognized then "gray" is used.
```
Color Name       (red, green, blue)
----------       ------------------
"black"          (0, 0, 0)
"white"          (255, 255, 255)
"red"            (255, 0, 0)
"green"          (0, 255, 0)
"blue"           (0, 0, 255)
"cyan"           (0, 255, 255)
"magenta"        (255, 0, 255)
"yellow"         (255, 255, 0)

"gray"           (127, 127, 127)
"orange"         (255, 127, 0)
"pink"           (255, 192, 203)
"purple"         (64, 0, 127)

"light gray"     (191, 191, 191)
"light red"      (255, 127, 127)
"light green"    (127, 255, 127)
"light blue"     (127, 127, 255)
"light cyan"     (127, 255, 255)
"light magenta"  (255, 127, 255)
"light yellow"   (255, 255, 127)

"dark gray"      (64, 64, 64)
"dark red"       (127, 0, 0)
"dark green"     (0, 127, 0)
"dark blue"      (0, 0, 127)
"dark cyan"      (0, 127, 127)
"dark magenta"   (127, 0, 127)
"dark yellow"    (127, 127, 0)

```

### Key Names
The following key names are supported.
Note that key names refer to a hardware key, not a typed character,
so typing 'A' uses the "a" key, and typing '$' uses the "4" key.
```
"a" to "z"                     (alphabet keys)
"0" to "9"                     (top row number keys)
"numPad0" to "numPad9"         (number pad digit keys)
"up", "down", "left", "right"  (arrow keys)
"space"                        (space bar)
"enter"                        (enter or return key)
"tab"                          (tab key)
"backspace"                    (backspace or delete left key)
"escape"                       (esc key)
```
