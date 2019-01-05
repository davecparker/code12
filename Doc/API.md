% Code12 Function Reference

<div class="rightLink">
[Java Language Help](Java.html)
</div>

<div class="summary">
<div class="summaryColumn">


##### [Graphics Object Creation] {#toc-graphics-object-creation}
* [ct.circle()]
* [ct.rect()]
* [ct.line()]
* [ct.text()]
* [ct.image()]

##### [Text Output] {#toc-text-output}
* [ct.print()]
* [ct.println()]
* [ct.log()]
* [ct.logm()]
* [ct.setOutputFile()]

##### [Alerts and Input Dialogs] {#toc-alerts-and-input-dialogs}
* [ct.showAlert()]
* [ct.inputInt()]
* [ct.inputNumber()]
* [ct.inputYesNo()]
* [ct.inputString()]

##### [Screen Management] {#toc-screen-management}
* [ct.setTitle()]
* [ct.setHeight()]
* [ct.getWidth()]
* [ct.getHeight()]
* [ct.getPixelsPerUnit()]
* [ct.setScreen()]
* [ct.getScreen()]
* [ct.setScreenOrigin()]
* [ct.clearScreen()]
* [ct.clearGroup()]
* [ct.setBackColor()]
* [ct.setBackColorRGB()]
* [ct.setBackImage()]

</div>
<div class="summaryColumn">

##### [Mouse and Keyboard Input] {#toc-mouse-and-keyboard-input}
* [ct.clicked()]
* [ct.clickX()]
* [ct.clickY()]
* [ct.objectClicked()]
* [ct.keyPressed()]
* [ct.charTyped()]

##### [Audio] {#toc-audio}
* [ct.loadSound()]
* [ct.sound()]
* [ct.setSoundVolume()]

##### [Math Utilities] {#toc-math-utilities}
* [ct.random()]
* [ct.round()]
* [ct.roundDecimal()]
* [ct.distance()]
* [ct.intDiv()]
* [ct.isError()]

##### [Type Conversion] {#toc-type-conversion}
* [ct.parseInt()]
* [ct.parseNumber()]
* [ct.canParseInt()]
* [ct.canParseNumber()]
* [ct.formatInt()]
* [ct.formatDecimal()]

##### [Program Control] {#toc-program-control}
* [ct.getTimer()]
* [ct.getVersion()]
* [ct.pause()]
* [ct.stop()]
* [ct.restart()]


</div>
<div class="summaryColumn">

##### [GameObj Data Fields] {#toc-gameobj-data-fields}
* [obj.x]
* [obj.y]
* [obj.visible]
* [obj.group]

##### [GameObj Methods]	{#toc-gameobj-methods}
* [obj.getType()]
* [obj.setSize()]
* [obj.getWidth()]
* [obj.getHeight()]
* [obj.setXSpeed()]
* [obj.setYSpeed()]
* [obj.getXSpeed()]
* [obj.getYSpeed()]
* [obj.align()]
* [obj.setText()]
* [obj.getText()]
* [obj.toString()]
* [obj.setFillColor()]
* [obj.setFillColorRGB()]
* [obj.setLineColor()]
* [obj.setLineColorRGB()]
* [obj.setLineWidth()]
* [obj.setImage()]
* [obj.setLayer()]
* [obj.getLayer()]
* [obj.delete()]
* [obj.setClickable()]
* [obj.clicked()]
* [obj.containsPoint()]
* [obj.hit()]
* [obj.objectHitInGroup()]

##### Other Functions Supported {#toc-other-functions-supported}
* [Java Math Functions]
* [Java String Methods]
* [Main Program Functions]
* [Input Event Functions]

</div>
</div>

###### Code12 Version 1.0


Graphics Object Creation
------------------------
These functions allow you to create a new graphics object 
([GameObj](#java-data-types)) for display on the screen.

* [ct.circle()]
* [ct.rect()]
* [ct.line()]
* [ct.text()]
* [ct.image()]

###### [Code12 Function Reference](#top) > [Graphics Object Creation]


### ct.circle()
Creates a new circle graphics object ([GameObj](#java-data-types)).

#### Syntax
```
ct.circle( x, y, diameter );
ct.circle( x, y, diameter, color );
```
##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the center of the circle.

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) 
of the center of the circle.

##### diameter
([double](#java-data-types)) The diameter ([width](#graphics-coordinates)
and [height](#graphics-coordinates)) of the circle.

##### color
([String](#java-data-types), optional). A [color name](#color-names)
(for example, `"blue"`) for the fill color of the circle. If the `color`
is not included, circle objects default to a fill color of `"red"`.

##### *Return Value*
([GameObj](#java-data-types)). A reference to the circle object is returned, 
which can be used to access and modify the circle later 
(see [GameObj Data Fields] and [GameObj Methods]).

#### Examples
```
ct.circle( 50, 30, 20 );
```
```
ct.circle( 50, 70, 40, "blue" );
```
```
GameObj ball = ct.circle( 0, 50, 10, "yellow" );
ball.setXSpeed( 1 );
```
###### [Code12 Function Reference](#top) > [Graphics Object Creation] > [ct.circle()]


### ct.rect()
Creates a new rectangle graphics object ([GameObj](#java-data-types)).

#### Syntax
```
ct.rect( x, y, width, height );
ct.rect( x, y, width, height, color );
```
##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the center of the rectangle.

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) 
of the center of the rectangle.

##### width
([double](#java-data-types)) The horizontal size ([width](#graphics-coordinates)) 
of the rectangle.

##### height
([double](#java-data-types)) The vertical size ([height](#graphics-coordinates))
of the rectangle.

##### color
([String](#java-data-types), optional). A [color name](#color-names) 
(for example, `"blue"`) for the fill color of the rectangle. If the `color` 
is not included, rectangle objects default to a fill color of `"yellow"`.

##### *Return Value*
([GameObj](#java-data-types)). A reference to the rectangle object is returned, 
which can be used to access and modify the rectangle later 
(see [GameObj Data Fields] and [GameObj Methods]).

#### Examples
```
ct.rect( 50, 30, 40, 20 );
```
```
ct.rect( 50, 70, 80, 40, "blue" );
```
```
GameObj platform = ct.rect( 0, 50, 30, 8, "orange" );
platform.setXSpeed( 1 );
```
###### [Code12 Function Reference](#top) > [Graphics Object Creation] > [ct.rect()]


### ct.line()
Creates a new line graphics object ([GameObj](#java-data-types))
drawn from a point (`x1`, `y2`) to a second point (`x2`, `y2`).

#### Syntax
```
ct.line( x1, y1, x2, y2 );
ct.line( x1, y1, x2, y2, color );
```
##### x1
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the first point.

##### y1
([double](#java-data-types)). The [y coordinate](#graphics-coordinates)
of the first point.

##### x2
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the second point.

##### y2
([double](#java-data-types)). The [y coordinate](#graphics-coordinates)
of the second point.

##### color
([String](#java-data-types), optional). A [color name](#color-names) 
(for example, `"blue"`) for the color of the line. If the `color` 
is not included, line objects default to a color of `"black"`.

##### *Return Value*
([GameObj](#java-data-types)). A reference to the line object is returned, 
which can be used to access and modify the line later 
(see [GameObj Data Fields] and [GameObj Methods]).

#### Examples
```
ct.line( 10, 30, 90, 40 );
```
```
ct.line( 10, 50, 90, 50, "blue" );
```
```
GameObj border = ct.line( 0, 75, 100, 75, "red" );
border.setLineWidth( 3 );
```
###### [Code12 Function Reference](#top) > [Graphics Object Creation] > [ct.line()]


### ct.text()
Creates a new text graphics object ([GameObj](#java-data-types)), 
which can be used to display text on the graphics screen.

#### Syntax
```
ct.text( text, x, y, height );
ct.text( text, x, y, height, color );
```
##### text
([String](#java-data-types)). The text to display.

##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the center of the text object.

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) 
of the center of the text object.

##### height
([double](#java-data-types)) The [height](#graphics-coordinates) of the text object. 
The font size of the text is determined automatically to fit within the `height`. 
The text object's width is then determined automatically to be wide enough to contain 
the `text` on one line.

##### color
([String](#java-data-types), optional). A [color name](#color-names) 
(for example, `"blue"`) for the color of the text. If the `color` 
is not included, text objects default to a text color of `"black"`.

##### *Return Value*
([GameObj](#java-data-types)). A reference to the text object is returned, 
which can be used to access and modify the text object later 
(see [GameObj Data Fields] and [GameObj Methods]).

#### Examples
```
ct.text( "Zombie Attack!", 50, 40, 12 );
```
```
ct.text( "Click anywhere to play", 50, 60, 5, "blue" );
```
```
GameObj scoreText = ct.text( "Score: 0", 100, 5, 7, "red" );
scoreText.align( "right" );
```
###### [Code12 Function Reference](#top) > [Graphics Object Creation] > [ct.text()]


### ct.image()
Creates a new image graphics object ([GameObj](#java-data-types)) 
from an image file (.PNG or .JPG).

#### Syntax
```
ct.image( filename, x, y, width );
```
##### filename
([String](#java-data-types)). The filename of the image to display. 
The image file must be in PNG or JPG format, for example 
`"dragon.png"`, or `"sky.jpg"`.

> For a simple filename such as `"dragon.png"`, the image file must be copied
> into the same folder as your Java program (.java) file. You can also put image
> files into subfolders using, for example, `"images/bullet.png"`.

##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
for the center of the image.

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) 
for the center of the image.

##### width
([double](#java-data-types)) The [width](#graphics-coordinates) for the image object. 
The image file itself can be any size, and it will be scaled to fit into the the 
given `width`. The height of the image object is determined automatically to preserve 
the original image's aspect ratio.

> If you wish to stretch or distort the image to be different from its original
> aspect ratio, you can do so using the [obj.setSize()](#obj.setsize) method.

##### *Return Value*
([GameObj](#java-data-types)). A reference to the image object is returned, 
which can be used to access and modify the image object later 
(see [GameObj Data Fields] and [GameObj Methods]).

#### Examples
```
ct.image( "dragon.png", 50, 30, 20 );
```
```
// Stretch the sky image to fill the entire screen
GameObj sky = ct.image( "sky.jpg", 50, 50, 100 );
sky.setSize( 100, 100 );
```
###### [Code12 Function Reference](#top) > [Graphics Object Creation] > [ct.image()]


Text Output
-----------
These functions allow you to output text to the console area, 
which is below the graphics area in the Code12 application.
Text in this area displays as a continuous scrolling stream of lines.
You can also output to a text file on your computer.

Note: To display text on the graphics screen, use [ct.text()].

* [ct.print()]
* [ct.println()]
* [ct.log()]
* [ct.logm()]
* [ct.setOutputFile()]

###### [Code12 Function Reference](#top) > [Text Output]


### ct.print()
Output text, or the text representation of any value, to the console.
A newline is *not* added, so any subsequent text output will appear on
the same line. 

> This function is equivalent to Java's `System.out.print()`.

#### Syntax
```
ct.print( value );
```
##### value
([Any type](#java-data-types)). The text or value to output.

#### Examples
```
// These will output on the same line
ct.print( "Hello" );
ct.print( " there!" );
```
```
String userName = "Jennifer";
int score = 2500;

ct.print( "User " );
ct.print( userName );
ct.print( " has a score of " );
ct.print( score );
```
###### [Code12 Function Reference](#top) > [Text Output] > [ct.print()]


### ct.println()
Output text, or the text representation of any value, to the console.
A newline is automatically added to end the line after the value. 

> This function is equivalent to Java's `System.out.println()`.

#### Syntax
```
ct.println( value );
ct.println();
```
##### value
([Any type](#java-data-types), optional). The text or value to output. 
If no value is given then only a newline is output.

#### Examples
```
ct.println( "Hello World!" );
```
```
ct.println( "This is line 1" );
ct.println( "This is line 2" );
ct.println();    // a blank line
ct.println( "This is the next paragraph." );
```
```
String userName = "Jennifer";
int score = 2500;

ct.println( userName );
ct.println( score );
ct.println();
ct.println( userName + " has score " + score );
```
###### [Code12 Function Reference](#top) > [Text Output] > [ct.println()]


### ct.log()
Output any number of values to the console, on one line separated by commas. 

#### Syntax
```
ct.log( value, value2, ... );
```
##### value, value2, ...
(Any number of values, of any types). The values to output. You can pass any number
of values of any type(s). The values will be output to the console on the same line, 
separated by commas.

#### Notes
Unlike [ct.print()] and [ct.println()], output from [ct.log()] and [ct.logm()] 
is colored blue in the console instead of black, and String values are automatically 
enclosed in double quotes. 

#### Examples
```
int count = 3;
ct.log( count );
```
```
String playerName = "Rick";
int hits = 7;
int misses = 4;
int total = hits + misses;

ct.log( playerName, hits, misses, total );
```
###### [Code12 Function Reference](#top) > [Text Output] > [ct.log()]


### ct.logm()
Output a text message followed by any number values to the console, 
all on one line separated by commas.

#### Syntax
```
ct.logm( message, value, value2, ... );
```
##### message
([String](#java-data-types)). A message to output at the beginning of the line.

> Unlike a String value passed as a `value`, the message is not output with 
> double quotes added.  

##### value, value2, ...
(Any number of values, of any types). The values to output. You can pass any number
of values of any type(s). The values will be output to the console on the same line 
after the `message` plus a space, separated by commas.

#### Notes
Unlike [ct.print()] and [ct.println()], output from [ct.log()] and [ct.logm()] 
is colored blue in the console instead of black, and String values are automatically 
enclosed in double quotes. 

#### Examples
```
int count = 3;
ct.logm( "count", count );
```
```
int runs = 3;
int hits = 7;
int errors = 1;

ct.logm( "Current stats:", runs, hits, errors );
```
###### [Code12 Function Reference](#top) > [Text Output] > [ct.logm()]


### ct.setOutputFile()
If you call `ct.setOutputFile( filename )`, then any subsequent text output
from [ct.print()], [ct.println()], [ct.log()], and [ct.logm()] will be
written to a text file with the given filename in addition to being output
to the console. 

#### Syntax
```
ct.setOutputFile( filename );
ct.setOutputFile( null );
```
##### filename
([String](#java-data-types)). The output filename. This should be a 
simple filename such as `"output.txt"`, which will be written to the 
same folder as the Java source code file, or a relative path starting 
from the source code folder, such as `"output/nameList.txt"`.

> If there is an existing file with the given name then it will be deleted
> and written over. Note that each time you run your program and call 
> `ct.setOutputFile` with a certain filename, it will overwrite the
> previous version of the file.

Call `ct.setOutputFile( null )` to end output to a file and restore 
output to the console only.

> It is a good idea to call `ct.setOutputFile( null )` after you are 
> finished writing to a file, to ensure that no buffered output is lost.

#### Example
```
double a = 7;
double b = 2;

ct.setOutputFile( "Math Test Results.txt" );
ct.println( "Test of simple math operations" );
ct.log( a, b );
ct.println( "Sum = " + (a + b) );
ct.println( "Difference = " + (a - b) );
ct.println( "Product = " + (a * b) );
ct.println( "Quotient = " + (a / b) );
ct.setOutputFile( null );
```
###### [Code12 Function Reference](#top) > [Text Output] > [ct.setOutputFile()]


Alerts and Input Dialogs
------------------------
These functions allow you to display a message box for the user
and to ask for input from the user.

* [ct.showAlert()]
* [ct.inputInt()]
* [ct.inputNumber()]
* [ct.inputYesNo()]
* [ct.inputString()]

###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs]


### ct.showAlert()
Displays a message in a pop-up dialog box over the graphics screen.
Execution of the program will pause and wait for the user to press
the OK button on the dialog or press the Enter key on the keyboard.

#### Syntax
```
ct.showAlert( message );
```
##### message
([String](#java-data-types)). The message to display. The string can
contain line breaks by embedding newline (`\n`) characters in it. 

#### Example
```
ct.showAlert( "Game Over!" );
```
###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs] > [ct.showAlert()]


### ct.inputInt()
Displays a message in a pop-up dialog box that asks the user to enter 
a number. Execution of the program will pause and wait until the user
enters a valid integer. The resulting integer value is returned.

#### Syntax
```
ct.inputInt( message );
```
##### message
([String](#java-data-types)). The message to display. 

##### *Return Value*
([int](#java-data-types)). The number entered by the user. 

#### Example
```
int numTargets = ct.inputInt( "How many targets would you like to have?" );
ct.println( numTargets );
```
###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs] > [ct.inputInt()]


### ct.inputNumber()
Displays a message in a pop-up dialog box that asks the user to enter
a number. Execution of the program will pause and wait until the user
enters a valid number. The resulting numeric value is returned.

#### Syntax
```
ct.inputNumber( message );
```
##### message
([String](#java-data-types)). The message to display. 

##### *Return Value*
([double](#java-data-types)). The number entered by the user. 

#### Example
```
double tempF = ct.inputNumber( "Enter the temperature in Farenheit" );
ct.println( tempF );
```
###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs] > [ct.inputNumber()]


### ct.inputYesNo()
Displays a message in a pop-up dialog box that has two buttons
labelled Yes and No. Execution of the program will pause and wait until 
the user presses one of the buttons.

#### Syntax
```
ct.inputYesNo( message );
```
##### message
([String](#java-data-types)). The message to display. 

##### *Return Value*
([boolean](#java-data-types)). `true` if the user presses Yes 
and `false` if they press No. 

#### Example
```
boolean playAgain = ct.inputYesNo( "Do you want to play again?" );
ct.println( playAgain );
```
###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs] > [ct.inputYesNo()]


### ct.inputString()
Displays a message in a popup dialog box that allows the user to
enter a text string. Execution of the program will pause and wait
until the user presses the Enter key to end the text input. 
The resulting String value is returned.

#### Syntax
```
ct.inputString( message );
```
##### message
([String](#java-data-types)). The message to display. 

##### *Return Value*
([String](#java-data-types)). The text entered by the user. 

> If the user presses the Enter key without entering any other
> characters, then an empty string (`""`) will be returned.

#### Example
```
String name = ct.inputString( "Enter your name" );
ct.println( name );
```
###### [Code12 Function Reference](#top) > [Alerts and Input Dialogs] > [ct.inputString()]


Screen Management
-----------------
These functions allow you to control the size and appearance of the 
background of your application, and to manage multiple screens and 
groups of objects.

* [ct.setTitle()]
* [ct.setHeight()]
* [ct.getWidth()]
* [ct.getHeight()]
* [ct.getPixelsPerUnit()]
* [ct.setScreen()]
* [ct.getScreen()]
* [ct.setScreenOrigin()]
* [ct.clearScreen()]
* [ct.clearGroup()]
* [ct.setBackColor()]
* [ct.setBackColorRGB()]
* [ct.setBackImage()]

###### [Code12 Function Reference](#top) > [Screen Management]


### ct.setTitle()
Allows you to set the title of the application window.

#### Syntax
```
ct.setTitle( title );
```
##### title
([String](#java-data-types)). The title to display at the top of the
application window. 

#### Example
```
ct.setTitle( "Zombie Attack" );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setTitle()]


### ct.setHeight()
Sets the height of the graphics output window in coordinate units,
which effectively sets the aspect ratio of your application.

#### Syntax
```
ct.setHeight( height );
```
##### height
([double](#java-data-types)). The height for your application in 
[coordinate units](#graphics-coordinates). The width of the application window 
in [coordinate units](#graphics-coordinates) is always 100.0 by definition, 
so this function effectively sets the application height relative to its width 
as a percent.

#### Examples
```
ct.setHeight( 100 );               // default square window
```
```
ct.setHeight( 200 );               // window is twice as tall as wide
```
```
ct.setHeight( 100.0 * 9 / 16 );    // 16:9 landscape aspect
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setHeight()]


### ct.getWidth()
This function always returns 100.0, which is the width of the application
window in [coordinate units](#graphics-coordinates) by definition.

#### Syntax
```
ct.getWidth()
```
##### *Return Value*
([double](#java-data-types)). Always returns 100.0. 

#### Example
```
// Get the screen size
final double WIDTH = ct.getWidth();
final double HEIGHT = ct.getHeight();

// Make a rectangle that fills the entire screen
ct.rect( WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.getWidth()]


### ct.getHeight()
Returns the height of the the application window in 
[coordinate units](#graphics-coordinates).
This is 100.0 by default, unless it is changed by [ct.setHeight()].

#### Syntax
```
ct.getHeight()
```
##### *Return Value*
([double](#java-data-types)). The height of the application window in
[coordinate units](#graphics-coordinates). 

#### Example
```
// Get the screen size
final double WIDTH = ct.getWidth();
final double HEIGHT = ct.getHeight();

// Make a rectangle that fills the entire screen
ct.rect( WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.getHeight()]


### ct.getPixelsPerUnit()
Returns the current graphics scale factor from 
[coordinate units](#graphics-coordinates) to device pixels. 

#### Syntax
```
ct.getPixelsPerUnit()
```
##### *Return Value*
([double](#java-data-types)). The current scale factor from 
[coordinate units](#graphics-coordinates) to device pixels
at the current window size.

> Note that the scale factor changes if the application window
> is resized or if the graphics window is resized using the 
> pane splits.

> Note that the definition of a "pixel" is platform-dependent,
> and some devices with very high resolution (e.g. 4K or Retina)
> may use more than 1 physical pixel per reported "pixel".

#### Examples
```
// Determine the physical size of the game window in pixels
int pixelWidth = ct.round( ct.getWidth() * ct.getPixelsPerUnit() );
int pixelHeight = ct.round( ct.getHeight() * ct.getPixelsPerUnit() );
ct.log( pixelWidth, pixelHeight );
```
```
// Create a circle that is 10 pixels in diameter at the current scale
double diameter = 10 / ct.getPixelsPerUnit();
ct.circle( 50, 50, diameter );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.getPixelsPerUnit()]


### ct.setScreen()
Sets the current screen to the screen with the specified name,
creating a new screen if the screen name does not exist yet.

#### Syntax
```
ct.setScreen( name );
```
##### name
([String](#java-data-types)). The name of the screen to create or switch to. 

#### Notes

Your application can define multiple named screens
and switch between them. Each screen has its own background
and its own graphics (`GameObj`) objects.

When you call `ct.setScreen( name )`, if a screen with the specified 
`name` has not already been created, then a new empty screen with this 
name is created and set as the current screen.

> The names of the screens have no special meaning or special
> behavior, and you can call them anything you want. 

#### Examples
```
// If there are no lives left then create and show a Game Over screen
if (numLives == 0)
{
	ct.setScreen( "end" );
	ct.setBackColor( "light blue" );
	ct.text( "Game Over", 50, 50, 15 );
}
```
```
// A game with two screens

public void start()
{
	// Make the intro screen
	ct.setScreen( "intro" );
	ct.text( "Zombie Attack", 50, 30, 10 );
	ct.text( "Click to begin", 50, 70, 5 );

	// Make the game screen
	ct.setScreen( "game" );
	ct.setBackImage( "city.jpg" );
	ct.image( "hero.png", 50, 50, 10 );
	// etc.

	// Start on the intro screen
	ct.setScreen( "intro" );
}

public void update()
{
	// If we are on the intro screen, then wait for a click 
	// to switch to the game screen.
	String screenName = ct.getScreen();
	if (screenName.equals( "intro" ))
	{
	    if (ct.clicked())
	    	ct.setScreen( "game" );
	}	
}

```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setScreen()]


### ct.getScreen()
Returns the name of the current screen, which is the most recent
screen set using [ct.setScreen()].

#### Syntax
```
ct.getScreen()
```
##### *Return Value*
([String](#java-data-types)). The name of the current screen.
The default screen name is `""` (empty string) if it has not been changed.

#### Example
```
// If we are on the intro screen, then wait for a click 
// to switch to the game screen.
String screenName = ct.getScreen();
if (screenName.equals( "intro" ))
{
    if (ct.clicked())
    	ct.setScreen( "game" );
}
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.getScreen()]


### ct.setScreenOrigin()
Offsets the entire screen horizontally and/or vertically so that
the coordinate at the upper-left of the screen is a specified (`x`, `y`).

#### Syntax
```
ct.setScreenOrigin( x, y );
```
##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
for the left edge of the screen.

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) 
for the top of the screen.

#### Notes
Normally the coordinate at the upper-left corner of the screen
is (0, 0). Using `ct.setScreenOrigin( x, y )` allows you to think of
the screen as a window viewing part of a larger world, and you
can pan ("scroll") the window where you want, in order to bring 
objects that would normally be outside the window into view.

Using `ct.setScreenOrigin()` does not modify the (x, y) position
of any objects. Rather it determines which objects are visible
within the game window and where they display.

Note that it is always OK to create or position objects outside 
of the normal screen bounds. The [x coordinate](#graphics-coordinates)
of the right edge of the screen is normally 100. 
If you draw a small object at say (150, 50), then it will normally 
not be visible. If you then call
`ct.setScreenOrigin( 150, 0 )`, the game will "scroll" horizontally
and the object will become visible in the center of the game window.
Conversely, another object at (50, 0) will scroll off the screen
to the left and no longer be visible.

> A screen's background image created with [ct.setBackImage()]
> is not affected by the screen origin. If you want a background image
> that scrolls, you can instead use [ct.image()] to create and display 
> one that is larger than the normal screen window.

#### Example
```
ct.image( "city.jpg", 50, 50, 250 );   // wider than screen
ct.image( "hero.png", 50, 70, 10 );
ct.setScreenOrigin( 25, 0 );       // entire scene scrolls to the left
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setScreenOrigin()]


### ct.clearScreen()
Removes and deletes all graphics (`GameObj`) objects on the current screen.
The background color or image is kept, if any.

#### Syntax
```
ct.clearScreen();
```
#### Example
```
ct.setBackColor( "gray" );
ct.circle( 50, 50, 20 );
ct.rect( 50, 70, 40, 10 );
ct.clearScreen();     // screen is now just solid red
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.clearScreen()]


### ct.clearGroup()
Removes and deletes all graphics (`GameObj`) objects on the current screen
whose [group name](#obj.group) matches the name passed.

#### Syntax
```
ct.clearGroup( name );
```
##### name
([String](#java-data-types)). The [group name](#obj.group) of objects to delete.

> The default group name for objects not assigned a group
> name is "" (empty string).

#### Example
```
GameObj hero = ct.image( "hero.png", 50, 80, 10 );

GameObj coin1 = ct.image( "coin.png", 30, 20, 10 );
coin1.group = "coins";

GameObj coin2 = ct.image( "coin.png", 60, 10, 10 );
coin2.group = "coins";

GameObj coin3 = ct.image( "coin.png", 90, 30, 10 );
coin3.group = "coins";

ct.clearGroup( "coins" );    // deletes all 3 coins
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.clearGroup()]


### ct.setBackColor()
Sets the background color of the current screen to a specified 
[color name](#color-names).

#### Syntax
```
ct.setBackColor( color );
```
##### color
([String](#java-data-types)). The [color name](#color-names) for the background.

#### Example
```
ct.setBackColor( "light blue" );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setBackColor()]


### ct.setBackColorRGB()
Sets the background color of the current screen to a
custom RGB color with specified `red`, `green`, and `blue` components.

#### Syntax
```
ct.setBackColorRGB( red, green, blue );
```
##### red
([int](#java-data-types)). The red component for the color, from 0 to 255.

##### green
([int](#java-data-types)). The green component for the color, from 0 to 255.

##### blue
([int](#java-data-types)). The blue component for the color, from 0 to 255.

#### Example
```
ct.setBackColorRGB( 210, 180, 140 );    // tan
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setBackColorRGB()]


### ct.setBackImage()
Sets the background of the current screen to an image.
The background image always displays behind all graphics (`GameObj`) objects
on the screen.

#### Syntax
```
ct.setBackImage( filename );
```
##### filename
([String](#java-data-types)). The name of a file containing the image. 
The image file must be in PNG or JPG format, for example `"sky.jpg"`.

> For a simple filename such as `"sky.jpg"`, the image file must be copied
> into the same folder as your Java program (.java) file. You can also put image
> files into subfolders using, for example, `"images/sky.jpg"`.

#### Notes

The image file does not need to match the aspect ratio of the screen.
The background image is centered and cropped automatically to show as much of 
the image as possible while preserving the aspect ratio of the image.

#### Example
```
ct.setBackImage( "sky.jpg" );
```
###### [Code12 Function Reference](#top) > [Screen Management] > [ct.setBackImage()]


Mouse and Keyboard Input
------------------------
These functions allow you to process mouse/touch input and keyboard input
in your [update()] function.

* [ct.clicked()]
* [ct.clickX()]
* [ct.clickY()]
* [ct.objectClicked()]
* [ct.keyPressed()]
* [ct.charTyped()]

Calling these functions in your [update()] function causes them to be 
called repeatedly, once for each animation frame (60 times per second), 
which is fast enough to provide fast response to input.

> Another more flexible way to handle mouse and keyboard input,
> which requires writing your own functions with parameters (syntax level 10),
> is to write your own [Input Event Functions]. 

###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input]


### ct.clicked()
Returns `true` if a click (mouse button press) or touch (on touch screens)
occured in the application window during the last animation frame. 

#### Syntax
```
ct.clicked()
```
##### *Return Value*
([boolean](#java-data-types)). `true` if a click occured, otherwise `false`.

#### Notes
Calling this function every time in your [update()] function will 
detect all mouse clicks in your application window.

If this function returns `true` then you can retrive the click location
using [ct.clickX()] and [ct.clickY()].

#### Example
```
public void update()
{
	if (ct.clicked())
	{
		double x = ct.clickX();
		double y = ct.clickY();
		ct.logm( "Click at", x, y );
	}
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.clicked()]


### ct.clickX()
Returns the [x coordinate](#graphics-coordinates) of the last known click
location in the application.

#### Syntax
```
ct.clickX()
```
##### *Return Value*
([double](#java-data-types)). The [x coordinate](#graphics-coordinates) of the click.

#### Notes
You should call [ct.clicked()] and test for a return value 
of `true` to make sure a click has occured before calling `ct.clickX()`.

#### Example
```
public void update()
{
	if (ct.clicked())
	{
		if (ct.clickX() < 50)
			ct.println( "Left side" );
		else
			ct.println( "Right side" );
	}
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.clickX()]


### ct.clickY()
Returns the [y coordinate](#graphics-coordinates) of the last known click
location in the application.

#### Syntax
```
ct.clickY()
```
##### *Return Value*
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) of the click.

#### Notes
You should call [ct.clicked()] and test for a return value 
of `true` to make sure a click has occured before calling `ct.clickY()`.

#### Example
```
public void update()
{
	if (ct.clicked())
	{
		if (ct.clickY() < 50)
			ct.println( "Top half" );
		else
			ct.println( "Bottom half" );
	}
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.clickY()]


### ct.objectClicked()
If a clickable graphics object (`GameObj`) was clicked during the 
last animation frame, then `ct.objectClicked()` returns a reference 
to that object, otherwise it returns `null` .

#### Syntax
```
ct.objectClicked()
```
##### *Return Value*
([GameObj](#java-data-types)). The object that was clicked, or `null` if none.

> `ct.objectClicked()` will return `null` if no object was
> clicked, which is the case for most animation frames in a game 
> (they occur 60 times per second). So you must check the return value
> for `null` before using the `GameObj` returned. Attempting to access 
> a field of a `GameObj` (such as [obj.x]) or call a method 
> (such as [obj.delete()])
> will generate a runtime error (a "crash") if the `GameObj` is `null`.

#### Notes
Calling this function every time in your [update()] function will 
find the topmost clickable object that was clicked, whenever the user clicks
on one. Any objects with the [obj.clickable] field set to `false` 
will not be considered when determining which object was clicked. 

#### Example
```
public void start()
{
	ct.circle( 50, 30, 10 );
	ct.rect( 30, 70, 30, 10 );
	ct.text( "Hey", 70, 50, 10 );
}

public void update()
{
	// Delete objects that get clicked
	GameObj obj = ct.objectClicked();
	if (obj != null)
		obj.delete();
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.objectClicked()]


### ct.keyPressed()
Returns `true` if the key with the specified [key name](#key-names)
is currently pressed (the key is down).

#### Syntax
```
ct.keyPressed( keyName )
```
##### keyName
([String](#java-data-types)). The [key name](#key-names)
of the key to test.

##### *Return Value*
([boolean](#java-data-types)). `true` if the key is pressed, otherwise `false`.

#### Notes
If you call this function every time in your [update()] function,
then it will return `true` for each animation frame where the key
is being held down. Animation frames happen 60 times per second,
so this function will typically trigger (return `true`) multiple 
times for each key "press". This is useful to produce things like 
continuous motion as long as a key is held down.

> To get only a single trigger for each key press, consider using
> [ct.charTyped()](#ct.keytyped) or the [onKeyPress event](#onkeypress).

Note that multiple keys can be down at the same time, so you can
also test for some key combinations such as `"up"` and `"left"`
being pressed at the same time.

#### Example
```
GameObj ball;

public void start()
{
	ball = ct.circle( 0, 50, 10 );
}

public void update()
{
	// Move ball to the right when right arrow is held down
	if (ct.keyPressed( "right" ))
		ball.x += 0.25; 
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.keyPressed()]


### ct.charTyped()
Return `true` if the specified character was typed on the keyboard
during the last animation frame.

#### Syntax
```
ct.charTyped( charString )
```
##### charString
([String](#java-data-types)). The character to test, for example `"a"`.

> Unlike the key names used by [ct.keyPressed()](#ct.keypressed), 
> the `charString` here is a printable character including the appropriate 
> shift status. For example, holding the shift key down while pressing
> the "a" key will cause `ct.charTyped( "a" )` to return `false` but
> `ct.charTyped( "A" )` to return `true`.
> Only printable characters can be detected, so special keys such as the
> arrow keys and key sequences such as Ctrl+C do not result in characters.

##### *Return Value*
([boolean](#java-data-types)). `true` if the character was typed, otherwise `false`.

#### Notes
Calling this function every time in your [update()] function
will detect each time that the given character is typed.
Unlike the behavior of [ct.keyPressed()](#ct.keypressed), 
you will only get one `true` result for each typed character.
However, most platforms have a keyboard "auto-repeat" feature,
so if you check `ct.charTyped()` every time in your [update()] 
function, and the user holds down a key, you may get the first character,
then perhaps a 1 second delay, then repeats at maybe 8 characters
per second.

#### Example
```
public void start()
{
	ct.println( "Looking for 4, $, and space" );
}

public void update()
{
	if (ct.charTyped( "4" ))
		ct.println( "4 was typed" );
	
	if (ct.charTyped( "$" ))
		ct.println( "$ was typed" );

	if (ct.charTyped( " " ))
		ct.println( "space was typed" );
}
```
###### [Code12 Function Reference](#top) > [Mouse and Keyboard Input] > [ct.charTyped()]


Audio
-----
These functions allow you to play sounds from audio files.

* [ct.loadSound()]
* [ct.sound()]
* [ct.setSoundVolume()]

###### [Code12 Function Reference](#top) > [Audio]


### ct.loadSound()
Pre-loads an audio file into memory so that the first use will have no delay.

#### Syntax
```
ct.loadSound( filename )
```
##### filename
([String](#java-data-types)). The name of the audio file to pre-load.

> Only standard formats of .WAV and .MP3 files are reliably supported
> on all operating systems.

##### *Return Value*
([boolean](#java-data-types)). `true` if the sound was successfully loaded, 
otherwise `false`.

#### Notes
You can call `ct.loadSound( filename )` to pre-load the sound effect in the 
`filename`, so that it will play quickly when played with [ct.sound()]. 
Pre-loading sounds before playing them is optional, but it reduces the
slight delay that occurs the first time a sound is played. 

For a simple filename such as `"ding.wav"`, the audio file must be copied
into the same folder as your Java program (.java) file. You can also put sound
files into subfolders using, for example, `"sounds/ding.wav"`.

You will typically want to call `ct.loadSound()` in your [start()] function
once for each sound that you want pre-loaded.

The `ct.loadSound()` function returns `true` if the sound was successfully 
loaded, or `false` if the `filename` could not be found or is not a supported 
sound format.

#### Example
```
public void start()
{
	ct.loadSound( "pop.wav" );
}

public void update()
{
	if (ct.clicked())
		ct.sound( "pop.wav" );
}
```
###### [Code12 Function Reference](#top) > [Audio] > [ct.loadSound()]


### ct.sound()
Play a sound effect from an audio file.

#### Syntax
```
ct.sound( filename )
```
##### filename
([String](#java-data-types)). The name of the audio file to play.

> Only standard formats of .WAV and .MP3 files are reliably supported
> on all operating systems.

#### Notes
For a simple filename such as `"ding.wav"`, the audio file must be copied
into the same folder as your Java program (.java) file. You can also put sound
files into subfolders using, for example, `"sounds/ding.wav"`.

The `ct.sound()` function starts the sound then returns immediately. 
The sound will then continue to play "in the background", while your program
continues. If you start a second sound before the first sound is finished,
the two sounds will mix if mixing is supported by the operating system. 

You can use [ct.loadSound()] to reduce the short delay that might occur
the first time a sound is played.

#### Examples
```
ct.sound( "pop.wav" );
```
```
public void start()
{
	ct.sound( "music.mp3" );
}

public void update()
{
	if (ct.clicked())
		ct.sound( "pop.wav" );
}
```
###### [Code12 Function Reference](#top) > [Audio] > [ct.sound()]


### ct.setSoundVolume()
Sets the relative volume to use for sounds played by [ct.sound()].

#### Syntax
```
ct.setSoundVolume( volume );
```
##### volume
([double](#java-data-types)). A volume number between 0.0 and 1.0.

#### Notes
The default sound volume is 1.0. If the volume is decreased
then sounds are attenuated relative to the volume they were recorded at.

#### Example
```
ct.setSoundVolume( 0.2 );
ct.sound( "music.mp3" );
```
###### [Code12 Function Reference](#top) > [Audio] > [ct.setSoundVolume()]


Math Utilities
--------------
These functions provide a convenient way to do common calculations.

* [ct.random()]
* [ct.round()]
* [ct.roundDecimal()]
* [ct.distance()]
* [ct.intDiv()]
* [ct.isError()]

For more math operations, see [Java Math Functions].

###### [Code12 Function Reference](#top) > [Math Utilities]


### ct.random()
Returns a random integer within the specified range.

#### Syntax
```
ct.random( min, max )
```
##### min
([int](#java-data-types)). The lower bound of the range.

##### max
([int](#java-data-types)). The upper bound of the range.

##### *Return Value*
([int](#java-data-types)). A random integer from `min` to `max` (inclusive).

#### Examples
```
int diceRoll = ct.random( 1, 6 );
ct.log( diceRoll );
```
```
// Flip a coin
if (ct.random( 0, 1 ) == 0)
	ct.println( "heads" );
else
	ct.println( "tails" );
```
```
// Create a ball at a random x position
ct.circle( ct.random( 0, 100 ), 50, 10 );
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.random()]


### ct.round()
Returns a specified number rounded to the nearest integer.

#### Syntax
```
ct.round( number )
```
##### number
([double](#java-data-types)). The number to round.

##### *Return Value*
([int](#java-data-types)). The `number` rounded to the nearest integer.

#### Example
```
double x = 10.75;
int n = ct.round( x );
ct.log( n );
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.round()]


### ct.roundDecimal()
Returns a number rounded to a specified number of decimal places.

#### Syntax
```
ct.roundDecimal( number, numPlaces )
```
##### number
([double](#java-data-types)). The number to round.

##### numPlaces
([int](#java-data-types)). The number of decimal places to round to.

##### *Return Value*
([int](#java-data-types)). The `number` rounded to `numPlaces` decimal places.

#### Example
```
double amount = 24.3467;
double price = ct.roundDecimal( amount, 2 );
ct.log( price );
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.roundDecimal()]


### ct.distance()
Returns the geometric distance between two (x, y) coordinates.

#### Syntax
```
ct.distance( x1, y1, x2, y2 )
```
##### x1
([double](#java-data-types)). The first x coordinate.

##### y1
([double](#java-data-types)). The first y coordinate.

##### x2
([double](#java-data-types)). The second x coordinate.

##### y2
([double](#java-data-types)). The second y coordinate.

##### *Return Value*
([double](#java-data-types)). The geometric distance from (`x1`, `y1`)
to (`x2`, `y2`).

This is equivalent to: 
```
Math.sqrt( (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) )
```

#### Example
```
GameObj ball1 = ct.circle( 30, 20, 10 );
GameObj ball2 = ct.circle( 50, 70, 10 );

double dist = ct.distance( ball1.x, ball1.y, ball2.x, ball2.y );
ct.println( "The balls are " + dist + " units apart" );
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.distance()]


### ct.intDiv()
Return the result of an integer division of two integers (discard any fractional part
and round the result down to the nearest integer).

#### Syntax
```
ct.intDiv( numerator, denominator )
```
##### numerator
([int](#java-data-types)). The numerator of the division.

##### denominator
([int](#java-data-types)). The denominator of the division.

##### *Return Value*
([int](#java-data-types)). The value of `numerator` / `denominator` rounded down
to the nearest integer.

> The `ct.intDiv()` function also supports dividing by 0, which is normally
> an error if done directly in Java. If `denominator` is 0 then the result is:

> * a large positive integer if `numerator` > 0
> * a large negative integer if `numerator` < 0 
> * 0 if `numerator` is 0 

#### Example
```
int n = ct.intDiv( 3, 2 );    // sets n to 1
ct.log( n );
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.intDiv()]


### ct.isError()
Returns `true` if the value of the specified number is an error value 
(NaN = "Not a Number").

#### Syntax
```
ct.isError( number )
```
##### numerator
([double](#java-data-types)). The number to test.

##### *Return Value*
([boolean](#java-data-types)). `true` if `number` is an error (NaN) value, or
`false` if `number` is a valid number.

An error (NaN or "Not a Number") value can result from certain calculations or
functions that return a [double](#java-data-types) but the calculation results
in an error or invalid number. See the examples below.

#### Example
```
// One of these is not considered a NaN error
ct.log( ct.isError( 0.0 / 0.0 ) );                  // undefined (NaN)
ct.log( ct.isError( Math.sqrt( -1 ) ) );            // imaginary (NaN)
ct.log( ct.isError( 2.0 / 0.0 ) );                  // infinity
ct.log( ct.isError( ct.parseNumber( "nope" ) ) );   // error (NaN)
```
###### [Code12 Function Reference](#top) > [Math Utilities] > [ct.isError()]


Type Conversion
---------------
These functions allow you to convert text strings to numbers and vice-versa.

* [ct.parseInt()]
* [ct.parseNumber()]
* [ct.canParseInt()]
* [ct.canParseNumber()]
* [ct.formatInt()]
* [ct.formatDecimal()]

###### [Code12 Function Reference](#top) > [Type Conversion]


### ct.parseInt()
Reads an [int](#java-data-types) value in a [String](#java-data-types).

#### Syntax
```
ct.parseInt( str )
```
##### str
([String](#java-data-types)). A string containing an integer, for example "34".

##### *Return Value*
([int](#java-data-types)). If `str` is a valid integer in text form (digit characters),
then the integer value is returned, otherwise 0 is returned.

> Since 0 is also a valid integer, it is a good idea to
> test the string with [ct.canParseInt()] first.

#### Example
```
int a = ct.parseInt( "546" );      // sets a to 546
int b = ct.parseInt( "  -3 " );    // sets b to -3
int c = ct.parseInt( "six");       // sets c to 0
int d = ct.parseInt( "4 more" );   // sets d to 0

ct.log( a, b, c, d);
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.parseInt()]


### ct.parseNumber()
Reads a [double](#java-data-types) value in a [String](#java-data-types).

#### Syntax
```
ct.parseNumber( str )
```
##### str
([String](#java-data-types)). A string containing an number, for example "-2.15".

##### *Return Value*
([double](#java-data-types)). If `str` is a valid number in text form, then
the numeric value is returned, otherwise the special error value NaN (Not a Number)
is returned.

> To test for NaN, use [ct.isError()]

#### Examples
```
double a = ct.parseNumber( "5" );           // sets a to 5.0
double b = ct.parseNumber( "  -3.02 " );    // sets b to -3.02
double c = ct.parseNumber( "$24.99" );      // sets c to NaN

ct.log( a, b, c );
if (ct.isError( c ))
	ct.println( "Got an invalid number" );
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.parseNumber()]


### ct.canParseInt()
Returns `true` if a specified [String](#java-data-types) is a valid integer 
in text form.

#### Syntax
```
ct.canParseInt( str )
```
##### str
([String](#java-data-types)). The string to test.

##### *Return Value*
([boolean](#java-data-types)). `true` if `str` is a valid integer in text form,
otherwise `false`.

#### Example
```
String entry = ct.inputString( "Enter something" );

if (ct.canParseInt( entry ))
{
	int n = ct.parseInt( entry );
	ct.println( "The number is " + n );
}
else
{
	ct.println( "Not a valid integer" );
}
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.canParseInt()]


### ct.canParseNumber()
Returns `true` if a specified [String](#java-data-types) is a valid number 
in text form.

#### Syntax
```
ct.canParseNumber( str )
```
##### str
([String](#java-data-types)). The string to test.

##### *Return Value*
([boolean](#java-data-types)). `true` if `str` is a valid number in text form,
otherwise `false`.

#### Example
```
String entry = ct.inputString( "Enter something" );

if (ct.canParseNumber( entry ))
{
	double num = ct.parseNumber( entry );
	ct.println( "The number is " + num );
}
else
{
	ct.println( "Not a valid number" );
}
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.canParseNumber()]


### ct.formatInt()
Returns a text ([String](#java-data-types)) representation of an integer 
([int](#java-data-types)).

#### Syntax
```
ct.formatInt( num );
ct.formatInt( num, numDigits );
```
##### num
([int](#java-data-types)). An integer value, for example 32.

##### numDigits
([int](#java-data-types), optional). If `numDigits` is included, then the text
returned will have at least this many characters, adding leading zeros as necessary.

##### *Return Value*
([String](#java-data-types)). The text representation of `num`, for example "32".

#### Examples
```
String text = ct.formatInt( 32 );    // sets text to "32"
ct.log( text );
```
```
int score = 520;
String text = ct.formatInt( score, 6 );   // sets text to "000520"
ct.text( text, 50, 5, 10 );               // displays score on the graphics screen
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.formatInt()]


### ct.formatDecimal()
Returns a text ([String](#java-data-types)) representation of a number 
([double](#java-data-types)).

#### Syntax
```
ct.formatDecimal( number );
ct.formatDecimal( number, numPlaces );
```
##### number
([double](#java-data-types)). Any numeric value.

##### numPlaces
([int](#java-data-types), optional). If `numPlaces` is included, then the text
is formatted to exactly this many places past the decimal point, rounding or 
adding extra zeros as necessary.

##### *Return Value*
([String](#java-data-types)). The text representation of `number`.

#### Examples
```
double x = 1.250;
String text = ct.formatDecimal( x );    // sets text to "1.25"
ct.log( text );
```
```
double a = 3.14159;
String text = ct.formatDecimal( a, 4 );    // sets text to "3.1416"
ct.log( text );
```
###### [Code12 Function Reference](#top) > [Type Conversion] > [ct.formatDecimal()]


Program Control
---------------
These functions allow you to get information about and control the 
execution of your program.

* [ct.getTimer()]
* [ct.getVersion()]
* [ct.pause()]
* [ct.stop()]
* [ct.restart()]

###### [Code12 Function Reference](#top) > [Program Control]


### ct.getTimer()
Return the number of milliseconds since your program started.

#### Syntax
```
ct.getTimer()
```
##### *Return Value*
([int](#java-data-types)). The number of milliseconds since your program started.

#### Examples
```
public void update()
{
	ct.println( ct.getTimer() );
}
```
```
boolean timerStarted = false;
int startTime;

public void start()
{
	ct.text( "Click to start timer", 50, 50, 5 );
}

public void update()
{
	// Start a timer when the user clicks
	if (ct.clicked())
	{
		ct.println( "Timer started" );
		timerStarted = true;
		startTime = ct.getTimer();
	}

	// Print a message 3 seconds after the timer started
	if (timerStarted && ct.getTimer() - startTime > 3000)
	{
		ct.println( "3 seconds have passed" );
		timerStarted = false;
	}
}
```
###### [Code12 Function Reference](#top) > [Program Control] > [ct.getTimer()]


### ct.getVersion()
Returns the version number of the Code12 runtime system.

#### Syntax
```
ct.getVersion()
```
##### *Return Value*
([double](#java-data-types)). The Code12 version number (for example 1.0).

#### Examples
```
if (ct.getVersion() > 1.0)
	ct.println( "We have the update" );
```
###### [Code12 Function Reference](#top) > [Program Control] > [ct.getVersion()]


### ct.pause()
Pauses execution of your program at this statement.
You can then resume or stop execution using the toolbar buttons
in the Code12 application. 

#### Syntax
```
ct.pause();
```
#### Notes
You can use `ct.pause()` to help you examine or debug your program
while it is running. Any motion on the screen will pause so you
can inspect it, and you can also check variable values in the 
variable watch window. 

#### Example
```
public void start()
{
	// Make a circle on the left
	ct.circle( 30, 50, 20 );

	// Wait for the Resume toolbar button to be pressed
	ct.pause();

	// Make a circle on the right
	ct.circle( 70, 50, 20 );
}
```
###### [Code12 Function Reference](#top) > [Program Control] > [ct.pause()]


### ct.stop()
Stops execution of your program immediately at this statement.
You can restart execution over from the beginning of the program using 
the Restart toolbar button in the Code12 application. 

#### Syntax
```
ct.stop();
```
#### Notes
You can use `ct.stop()` to terminate your program if something 
unexpected happens. No more code will execute, and the values of 
your variables will stay as they were when `ct.stop()` was called
so you can examine them in the variable watch window.

#### Example
```
if (hero.x < 0)
	ct.stop();    // Oops, how did he get off-screen?
```
###### [Code12 Function Reference](#top) > [Program Control] > [ct.stop()]


### ct.restart()
Immediately stops and and then restarts your program from the beginning.

#### Syntax
```
ct.restart();
```
#### Notes
After calling `ct.restart()`, your program immediately restarts from
the beginning. Variables are re-initialized with their default/starting 
values, and execution starts over with your [start()] function.

#### Example
```
if (ct.inputYesNo( "Would you like to play again?" ))
	ct.restart();
```
###### [Code12 Function Reference](#top) > [Program Control] > [ct.restart()]


GameObj Data Fields
-------------------
Each graphics object ([GameObj](#java-data-types)) that you create 
(see [Graphics Object Creation]) has several data variables that live inside it. 
These variables store information such as the position, size, and color of the object. 
Each [GameObj](#java-data-types) has its own copy of these variables. 
You can access or change some of these data variables directly.
Java refers to these object variables as *public data fields*.

Each [GameObj](#java-data-types) has public data fields named `x`, `y`, 
`visible`, and `group`. 
To access these fields, you need a variable of type [GameObj](#java-data-types),
which you put before the data field name followed by a dot (.) character,
for example `hero.x`.

In the general descriptions below, the [GameObj](#java-data-types) variable is 
shown as `obj`. In your program, you will replace `obj` with the name of the 
[GameObj](#java-data-types) variable that you wish to access.

* [obj.x]
* [obj.y]
* [obj.visible]
* [obj.group]

###### [Code12 Function Reference](#top) > [GameObj Data Fields]


### obj.x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates) of
a [GameObj](#java-data-types).

#### Syntax
```
obj.x
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

#### Notes
You can access ("get") or change ("set") the [x coordinate](#graphics-coordinates)
of a [GameObj](#java-data-types) at any time.

#### Example
```
GameObj dot;

public void start()
{
	dot = ct.circle( 0, 50, 10 );	
}

public void update()
{
	// Move dot a little to the right each animation frame
	dot.x = dot.x + 1;

	// If dot goes off-screen to the right, start over at the left
	if (dot.x > 100)
		dot.x = 0;
}
```
###### [Code12 Function Reference](#top) > [GameObj Data Fields] > [obj.x]


### obj.y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates) of
a [GameObj](#java-data-types).

#### Syntax
```
obj.y
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

#### Notes
You can access ("get") or change ("set") the [y coordinate](#graphics-coordinates)
of a [GameObj](#java-data-types) at any time.

#### Example
```
GameObj slab;

public void start()
{
	slab = ct.rect( 50, 0, 40, 10 );	
}

public void update()
{
	// Move slab down a little each animation frame
	slab.y = slab.y + 1;

	// If slab reaches the bottom, start over at the top
	if (slab.y > ct.getHeight())
		slab.y = 0;
}
```
###### [Code12 Function Reference](#top) > [GameObj Data Fields] > [obj.y]


### obj.visible
([boolean](#java-data-types)). `true` if a [GameObj](#java-data-types)
should be displayed as normal, or `false` to hide the object and not display it.

#### Syntax
```
obj.visible
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

#### Notes
Graphics objects default to visible when created. If you set the `visible` 
field to `false`, the object will be hidden and disappear from the display. 
Hidden objects still exist (they are not deleted), and they can be brought 
back by setting `visible` back to `true`.

> In addition to not being displayed, hidden objects do not respond to 
> mouse clicks (from [ct.objectClicked()], for example) and do not
> register as "hitting" other objects (see [obj.hit()], for example]).

#### Example
```
public void start()
{
	ct.circle( 50, 30, 10 );
	ct.rect( 30, 70, 30, 10 );
	ct.text( "Hey", 70, 50, 10 );
}

public void update()
{
	// Hide objects that get clicked
	GameObj obj = ct.objectClicked();
	if (obj != null)
		obj.visible = false;
}
```
###### [Code12 Function Reference](#top) > [GameObj Data Fields] > [obj.visible]


### obj.group
([String](#java-data-types)). An optional name that you can assign to a 
[GameObj](#java-data-types) to associate it with other 
similar objects.

#### Syntax
```
obj.group
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

#### Notes
The default group name for an object is `""` (empty string) when it is created.
If you assign a group name, you can access and check it when you have an
unknown object reference to see what kind it is.

The `group` field is also used by the functions [ct.clearGroup()] 
and [obj.objectHitInGroup()].

#### Examples
```
GameObj block;
GameObj coin1, coin2;

public void start()
{
	block = ct.rect( 50, 70, 20, 20 );

	coin1 = ct.circle( 30, 30, 10, "orange" );
	coin1.group = "coins";

	coin2 = ct.circle( 70, 30, 10, "orange" );
	coin2.group = "coins";
}

public void update()
{
	// Hide (only) coins that get clicked
	GameObj target = ct.objectClicked();
	if (target != null && target.group.equals("coins"))
		target.visible = false;	
}
```
###### [Code12 Function Reference](#top) > [GameObj Data Fields] > [obj.group]


GameObj Methods
---------------
The following method functions must be called on an existing graphics object
([GameObj](#java-data-types)). To create a [GameObj](#java-data-types), 
see [Graphics Object Creation]. In the syntax descriptions shown,
the `obj` can be any variable of type [GameObj](#java-data-types). 
The method function will access or modify the `obj` variable you specify.

* [obj.getType()]
* [obj.setSize()]
* [obj.getWidth()]
* [obj.getHeight()]
* [obj.setXSpeed()]
* [obj.setYSpeed()]
* [obj.getXSpeed()]
* [obj.getYSpeed()]
* [obj.align()]
* [obj.setText()]
* [obj.getText()]
* [obj.toString()]
* [obj.setFillColor()]
* [obj.setFillColorRGB()]
* [obj.setLineColor()]
* [obj.setLineColorRGB()]
* [obj.setLineWidth()]
* [obj.setImage()]
* [obj.setLayer()]
* [obj.getLayer()]
* [obj.delete()]
* [obj.setClickable()]
* [obj.clicked()]
* [obj.containsPoint()]
* [obj.hit()]
* [obj.objectHitInGroup()]

###### [Code12 Function Reference](#top) > [GameObj Methods]


### obj.getType()
Returns the type name of a [GameObj](#java-data-types), 
for example, `"circle"`.

#### Syntax
```
obj.getType()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([String](#java-data-types)). One of: `"circle"`, `"rect"`, `"line"`, `"text"`, or `"image"`.

#### Example
```
GameObj dot = ct.circle( 50, 50, 10 );
String type = dot.getType();
ct.log( type );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getType()]


### obj.setSize()
Sets the size ([width](#graphics-coordinates) and [height](#graphics-coordinates)) 
of a [GameObj](#java-data-types).

#### Syntax
```
obj.setSize( width, height );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### width
([double](#java-data-types)). The new [width](#graphics-coordinates) for the object. 

##### height
([double](#java-data-types)). The new [height](#graphics-coordinates) for the object. 

#### Notes
The different types of [GameObj](#java-data-types) objects
react somewhat differently to changes in size, as follows:

> ##### circle Objects
> Although circles are always created round (see [ct.circle()]), you can create 
> an ellipse by setting different `width` and `height` values.

> ##### rect Objects
> Rectangles (see [ct.rect()]) can be adjusted to any `width` and `height`.

> ##### line Objects
> For line objects (see [ct.line()]), the `width` and `height` specify 
> offsets (positive or negative) from the first point to the second point.
> The [obj.x] and [obj.y] data fields specify the location of the first point.
> Calling `obj.setSize( width, height )` can be used to change the 
> second point relative to the first point.

> ##### text Objects
> Text objects (see [ct.text()]) ignore the `width` passed. 
> The `height` is used to set the new height and determine the 
> new font size for the object, 
> and the object's width is recalculated automatically.

> ##### image Objects
> Images (see [ct.image()]) are initially created with `height` calculated 
> automatically to preserve the image's aspect ratio given the specified `width`.
> However, once created, you can set any values for `width` and `height`,
> and the image will scale and/or stretch as necessary to match the specified size.

#### Example
```
GameObj blob = ct.circle( 50, 50, 30 );
blob.setSize( 50, 30 );      // makes an ellipse
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setSize()]


### obj.getWidth()
Returns the [width](#graphics-coordinates) (horizontal size) of a 
[GameObj](#java-data-types).

#### Syntax
```
obj.getWidth()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([double](#java-data-types)). The [width](#graphics-coordinates) of the object.

#### Notes
For line objects (see [ct.line()]), the width returned is the x offset
(positive or negative) from the first point to the second point,
not the physical width of the line, and unrelated to the thickness
of the line as set by [obj.setLineWidth()].

#### Example
```
GameObj title = ct.text( "Zombie Attack", 50, 30, 10 );
double titleWidth = title.getWidth();
ct.log( titleWidth );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getWidth()]


### obj.getHeight()
Returns the [height](#graphics-coordinates) (vertical size) of a 
[GameObj](#java-data-types).

#### Syntax
```
obj.getHeight()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([double](#java-data-types)). The [height](#graphics-coordinates) of the object.

#### Notes
For line objects (see [ct.line()]), the height returned is the y offset
(positive or negative) from the first point to the second point,
not the physical height of the line.

#### Example
```
GameObj hero = ct.image( "hero.png", 50, 50, 10 );
double heroHeight = hero.getHeight();
ct.log( heroHeight );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getHeight()]


### obj.setXSpeed()
Sets the speed of a [GameObj](#java-data-types) in the x direction so that
it moves horizontally on its own.

#### Syntax
```
obj.setXSpeed( xSpeed );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### xSpeed
([double](#java-data-types)). The horizontal speed for the object in 
[x coordinate](#graphics-coordinates) units per animation frame. 

#### Notes
Before each new animation frame, the value of `xSpeed` is added to
the [obj.x] field of the object. 
Animation frames occur 60 times per second, so an `xSpeed` of `1.0` will 
cause the object to move to the right at 60 units per second.

The `xSpeed` can be negative, so for example, an `xSpeed` of
`-0.5` will cause the object to move to the left at 30 units per second.

#### Example
```
GameObj dot = ct.circle( 0, 50, 10 );
dot.setXSpeed( 0.3 );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setXSpeed()]


### obj.setYSpeed()
Sets the speed of a [GameObj](#java-data-types) in the y direction so that
it moves vertically on its own.

#### Syntax
```
obj.setYSpeed( ySpeed );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### ySpeed
([double](#java-data-types)). The vertical speed for the object in 
[y coordinate](#graphics-coordinates) units per animation frame. 

#### Notes
Before each new animation frame, the value of `ySpeed` is added to
the [obj.y] field of the object. 
Animation frames occur 60 times per second, so a `ySpeed` of `1.0` will 
cause the object to move downward at 60 units per second.

The `ySpeed` can be negative, so for example, an `ySpeed` of
`-0.5` will cause the object upwards at 30 units per second.

#### Example
```
GameObj dot = ct.circle( 50, 100, 10 );
dot.setYSpeed( -0.3 );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setYSpeed()]


### obj.getXSpeed()
Returns the horizontal speed of an object as set by [obj.setXSpeed()].

#### Syntax
```
obj.getXSpeed()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([double](#java-data-types)). The horizontal speed of the object in 
[coordinate units](#graphics-coordinates) per animation frame.

#### Example
```
GameObj dot = ct.circle( 50, 50, 10 );
dot.setXSpeed( ct.random( -2, 2 ) / 3.0 );
ct.println( "Speed = " + dot.getXSpeed() );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getXSpeed()]


### obj.getYSpeed()
Returns the vertical speed of an object as set by [obj.setYSpeed()].

#### Syntax
```
obj.getYSpeed()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([double](#java-data-types)). The vertical speed of the object in 
[coordinate units](#graphics-coordinates) per animation frame.

#### Example
```
GameObj dot = ct.circle( 50, 50, 10 );
dot.setYSpeed( ct.random( -2, 2 ) / 3.0 );
ct.println( "Speed = " + dot.getYSpeed() );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getYSpeed()]


### obj.align()
Sets the alignment of a [GameObj](#java-data-types),
which determines where it is located relative to its 
[(x, y) coordinates](#graphics-coordinates).

#### Syntax
```
obj.align( alignment );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### alignment
([String](#java-data-types)). One of the following strings
describing the placement of an object relative to its (x, y):

```
alignment         horizontal            vertical
--------------    -----------------     ------------------------
"top left"        to the right of x     below y
"top"             centered at x         below y
"top right"       to the left of x      below y
"left"            to the right of x     vertically centered at y
"center"          centered at x         vertically centered at y
"right"           to the left of x      vertically centered at y
"bottom left"     to the right of x     above y
"bottom"          centered at x         above y
"bottom right"    to the left of x      above y
```

#### Notes
The default alignment is `"center"`, so that objects are horizontally
and vertically centered around the (x, y) coordinates of the object.

Line objects (see [ct.line()]) ignore the alignment setting and are 
always drawn from the first point to the second point.

#### Example
```
// Make the score text right-aligned in the upper right of the screen
GameObj score = ct.text( "Score: 0", 100, 0, 8 );
score.align( "top right" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.align()]


### obj.setText()
Sets the text of a [GameObj](#java-data-types).

#### Syntax
```
obj.setText( text )
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### text
([String](#java-data-types)). The text to store in the object,
or `null` for none.
For a text object (see [ct.text()]), this becomes the visible text.
For other objects, this is just a string kept inside the object,
which can be used to identity or describe the object (see [obj.getText()]).

#### Notes
For an image object (see [ct.image()]), the text defaults to the 
image filename, but you can change it to something else.

For circle, rect, and line objects, the default text is `null` (none). 

The [obj.toString()] method includes the object text, if any,
in the description of an object.

#### Example
```
GameObj message;

public void start()
{
	message = ct.text( "Waiting for a click", 50, 50, 10 );
}

public void update()
{
	if (ct.clicked())
		message.setText( "You clicked" );
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setText()]


### obj.getText()
Returns the text of a [GameObj](#java-data-types).

#### Syntax
```
obj.getText()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([String](#java-data-types)). The text of the object.
For a text object (see [ct.text()]), this is the visible text.
For other objects, this is just a string kept inside the object,
which can be used to identity or describe the object (see [obj.setText()]).

#### Notes
For an image object (see [ct.image()]), the text defaults to the 
image filename, but you can change it to something else (see [obj.setText()]).

For circle, rect, and line objects, the default text is `null` (none). 

The [obj.toString()] method includes the object text, if any,
in the description of an object.

#### Example
```
public void start()
{
	GameObj circle1 = ct.circle( 30, 50, 10, "orange" );
	circle1.setText( "coin" );

	GameObj circle2 = ct.circle( 70, 50, 10, "black" );
	circle2.setText( "bomb" );
}

public void update()
{
	GameObj target = ct.objectClicked();
	if (target != null)
		ct.log( target.getText() );
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getText()]


### obj.toString()
Returns a text ([String](#java-data-types)) description of a graphics object 
([GameObj](#java-data-types)).

#### Syntax
```
obj.toString()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([String](#java-data-types)). A description of the object.
The string will include the type name of the object,
the (x, y) coordinates rounded to the nearest integer,
and the text of the object, if any (see [obj.setText()]). 
The entire string is enclosed in square brackets. Examples:
```
[circle at (70, 25)]
[text at (50, 10) "Score 3200"]
[image at (21, 83) "goldfish.png"]
[image at (21, 83) "hero"]
[rect at (50, 100) "bottom wall"]
```
#### Notes
The text output functions [ct.print()], [ct.println()], 
[ct.log()], and [ct.logm()] automatically call `obj.toString()`
internally if you print a [GameObj](#java-data-types) directly,
so there is no need to explicitly call `obj.toString()` to print
a [GameObj](#java-data-types) description with these functions.

#### Example
```
GameObj message;

public void start()
{
	message = ct.text( "", 50, 20, 10 );
	ct.circle( 30, 50, 10 );
	ct.rect( 70, 50, 10, 10 );
}

public void update()
{
	GameObj target = ct.objectClicked();
	if (target != null)
		message.setText( target.toString() );
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.toString()]


### obj.setFillColor()
Sets the fill color of a [GameObj](#java-data-types)
to one of the pre-defined [color names](#color-names).

#### Syntax
```
obj.setFillColor( color );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### color
([String](#java-data-types)). A [color name](#color-names), for example `"blue"`.
If `color` is `null` then the fill is removed from the object.

#### Notes
For a text object (see [ct.text()]), the color of the text is set.

> If you want a solid "background color" for a text object,
> use [ct.rect()] to create a rectangle behind the text object.

#### Example
```
GameObj dot = ct.circle( 50, 50, 20 );
dot.setFillColor( "blue" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setFillColor()]


### obj.setFillColorRGB()
Sets the fill color of a [GameObj](#java-data-types)
to a custom RGB color with red, green, and blue component values.

#### Syntax
```
obj.setFillColorRGB( red, green, blue );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### red
([int](#java-data-types)). The red component for the color, from 0 to 255.

##### green
([int](#java-data-types)). The green component for the color, from 0 to 255.

##### blue
([int](#java-data-types)). The blue component for the color, from 0 to 255.

#### Notes
For a text object (see [ct.text()]), the color of the text is set.

> If you want a solid "background color" for a text object,
> use [ct.rect()] to create a rectangle behind the text object.

#### Example
```
GameObj blob = ct.circle( 50, 50, 20 );
blob.setFillColorRGB( 210, 180, 140 );     // tan
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setFillColorRGB()]


### obj.setLineColor()
Sets the line color of a [GameObj](#java-data-types)
to one of the pre-defined [color names](#color-names).

#### Syntax
```
obj.setLineColor( color );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### color
([String](#java-data-types)). A [color name](#color-names), for example `"blue"`.
If `color` is `null` then the outline is removed from the object.

#### Notes
For line objects (see [ct.line()]), the color of the line is set.
For other object types, the color of the outlined border of the object is set.

#### Example
```
GameObj dot = ct.circle( 50, 50, 20 );
dot.setLineWidth( 5 );
dot.setLineColor( "green" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setLineColor()]


### obj.setLineColorRGB()
Sets the line color of a [GameObj](#java-data-types)
to a custom RGB color with red, green, and blue component values.

#### Syntax
```
obj.setLineColorRGB( red, green, blue );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### red
([int](#java-data-types)). The red component for the color, from 0 to 255.

##### green
([int](#java-data-types)). The green component for the color, from 0 to 255.

##### blue
([int](#java-data-types)). The blue component for the color, from 0 to 255.

#### Notes
For line objects (see [ct.line()]), the color of the line is set.
For other object types, the color of the outlined border of the object is set.

#### Example
```
GameObj blob = ct.circle( 50, 50, 20 );
blob.setLineWidth( 5 );
blob.setLineColorRGB( 210, 180, 140 );     // tan outline
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setLineColorRGB()]


### obj.setLineWidth()
Sets the line width (thickness) of a [GameObj](#java-data-types).

#### Syntax
```
obj.setLineWidth( lineWidth );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### lineWidth
([int](#java-data-types)). The line thickness in pixels.

#### Notes
If an object has a line color (see [obj.setLineColor()] 
and [obj.setLineColorRGB()]), then the object will be outlined
with a stroke (pen thickness) of approximately `lineWidth` pixels. 
The default is line width 1.

> Unlike normal [coordinate values](#graphics-coordinates), 
> line thickness values are measured in approximate device "pixels", 
> so apparent line thickness does not scale up as the window size is increased. 
> The definition of "pixels" depends on the platform and the display, 
> but the overall intent is that on a display of "normal" resolution 
> (e.g. HD resolution, not 4K or Retina),
> a `lineWidth` of 1 will result in an appoximate 1 pixel border.
> High resolution displays may use multiple pixels, and some displays
> may use partial pixels for a smoother appearance (anti-aliasing).

#### Example
```
GameObj frame = ct.rect( 50, 50, 60, 30 );
frame.setLineWidth( 5 );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setLineWidth()]


### obj.setImage()
Changes the image of an image graphics object ([GameObj](#java-data-types)).

#### Syntax
```
obj.setImage( filename );
```
##### obj
([GameObj](#java-data-types)). The graphics object, which must be an 
image object (see [ct.image()]).

##### filename
([String](#java-data-types)). The new image filename. See [ct.image()]
for the filename requirements. 

#### Notes
The object's image is changed while keeping the other properties of the 
object the same (e.g. position, size, speed). The text of the object 
is set to the new filename (see [obj.getText()]).

> Both the width and height of the object are maintained, so if the 
> new image has a different aspect ratio than the original, then 
> the new image may be distored to make it fit.

> If the filename is invalid or is not found, the results are undefined
> but will likely result in the object showing no image.  

#### Example
```
GameObj hero = ct.image( "hero.png", 50, 50, 10 );
GameObj bullet = ct.rect( 50, 70, 1, 10 );

if (hero.hit( bullet ))
	hero.setImage( "hero-hurt.png" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setImage()]


### obj.setLayer()
Sets the layer number for a [GameObj](#java-data-types),
which helps controls the stacking order of objects on the screen.

#### Syntax
```
obj.setLayer( layer )
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### layer
([int](#java-data-types)). The layer number to set for the object.

#### Notes
By default, [GameObj](#java-data-types) objects are all assigned 
a layer number of 1 when they are created. You can use `obj.setLayer()`
to change an object's layer number to any integer value. The layer
numbers themselves have no special meaning; they are just used to
order objects relative to other layer numbers.

After the screen background color or image is drawn (as set by [ct.setBackColor()],
[ct.setBackColorRGB()], or [ct.setBackImage()]), graphics object layers are 
drawn from the lowest layer number first (in the back) to the highest number 
(in the front).

Within a layer, objects are drawn in the order that they were created
or set to that layer number. Calling `obj.setLayer( layer )` always re-inserts
an object at the top of `layer`, on top of any other objects with that same
layer number.

You can use any layer number values to help organize your screen how you
want. As an example, you might assign various background object in a game
to layer 0, floating objects such as score readouts and messages to layer 2, 
and leave the normal game objects in the default layer 1. Thus if you create 
new game objects during the game, they will be properly placed above the 
background objects but below the floating objects.

#### Examples
```
public void start()
{
	// Make a rect in the back
	GameObj rect = ct.rect( 50, 50, 70, 20 );
	rect.setLayer( 0 );

	// Make the score readout on top
	GameObj score = ct.text( "Score: 0", 50, 50, 10 );
	score.setLayer( 2 );
}

public void update()
{
	// Make dots whereever the user clicks
	// at default layer 1
	if (ct.clicked())
		ct.circle( ct.clickX(), ct.clickY(), 10 );
}
```
```
// Move an object to the top of the layer it is currently in
target.setLayer( target.getLayer() );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setLayer()]


### obj.getLayer()
Returns the layer number for a [GameObj](#java-data-types). 
See [obj.setLayer()].

#### Syntax
```
obj.getLayer()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([int](#java-data-types)). The layer number as set by [obj.setLayer()], 
(or the default of 1), which helps determine the stacking order of objects.

#### Example
```
GameObj target = ct.objectClicked();
if (target != null && target.getLayer() == 0)
	ct.println( "You clicked on one of the background items" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.getLayer()]


### obj.delete()
Removes and deletes a [GameObj](#java-data-types) 
from the screen.

#### Syntax
```
obj.delete();
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

#### Notes
The object is removed from the screen and deleted.
Unlike hiding an object using the [obj.visible] field,
deleting an object is permanent, and it cannot be brought back.

> Once an object has been deleted, any variables referencing that
> object will still exist, but accessing the fields or methods of
> the object is undefined and may result in unpredictable behavior.

#### Example
```
public void start()
{
	ct.circle( 50, 30, 10 );
	ct.rect( 30, 70, 30, 10 );
	ct.text( "Hey", 70, 50, 10 );
}

public void update()
{
	// Delete objects that get clicked
	GameObj obj = ct.objectClicked();
	if (obj != null)
		obj.delete();
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.delete()]


### obj.setClickable()
Specifies whether or not a [GameObj](#java-data-types) 
should accept mouse/touch input.

#### Syntax
```
obj.setClickable( clickable );
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### clickable
([boolean](#java-data-types)). `true` to allow the object to accept 
mouse/touch input, or `false` to disable it.

#### Notes
By default, all [GameObj](#java-data-types) objects will detect and accept 
mouse/touch input (clicks), but you can disable click detection for an object 
by using `obj.setClickable( false )`.

The functions [ct.objectClicked()] and [obj.clicked()], and the input event 
functions [ct.onMousePress()], [ct.onMouseDrag()], and [ct.onMouseRelease()] 
can all be be used to identify if a [GameObj](#java-data-types) was clicked 
and which object it was. 

If more than one object intersects the click location, then normally
the topmost object will be considered to be the target of the click.
However if an object has had click input disabled with `obj.setClickable( false )`, 
then the click will "pass through" to the next lower object that intersects
the click location (if any), or to the background if none.

#### Example
```
GameObj button;

public void start()
{
	// Make a button with both text and a background rect, but let the rect
	// handle the click detection, so we don't have to test both.
	button = ct.rect( 50, 50, 60, 15 );
	GameObj text = ct.text( "Click me", 50, 50, 10 );
	text.setClickable( false );   // change to true to see the difference
}

public void update()
{
	if (button.clicked())
		ct.println( "Button was clicked");
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.setClickable()]


### obj.clicked()
Returns `true` if a [GameObj](#java-data-types) was clicked/touched 
during the last animation frame. 

#### Syntax
```
obj.clicked()
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### *Return Value*
([boolean](#java-data-types)). `true` if the object was clicked/touched during
the last animation frame, or `false` if not.

#### Notes
Calling this method for an object every time during your [update()] 
function will detect any clicks on the object.

> Calling `obj.clicked()` in your [start()] function will have no effect,
> because [start()] is only called once before animation frames have begun.

If an object is currently hidden because [obj.visible] was set to `false`,
or if the object has click input disabled (see [obj.setClickable()]),
then `obj.clicked()` will always return `false`.

If more than one visible and clickable object intersects with the
location of a click or touch, the topmost one will receive the click.

#### Example
```
GameObj dot;

public void start()
{
	dot = ct.circle( 50, 50, 10 );
}

public void update()
{
	if (dot.clicked())
		ct.println( "The dot was clicked");
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.clicked()]


### obj.containsPoint()
Returns `true` if a specified (x, y) location is within the interior
of a [GameObj](#java-data-types).

#### Syntax
```
obj.containsPoint( x, y )
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the point to test. 

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates)
of the point to test. 

##### *Return Value*
([boolean](#java-data-types)). `true` if (`x`, `y`) is inside the object, 
or `false` if not.

#### Notes
Text ([ct.text()]) and image ([ct.image()]) objects test the rectangular 
bounds of the object.

Except for line objects ([ct.line()]), the thickness of the border of the
object (see [obj.setLineWidth()]) is not included as part of the object area.

#### Example
```
GameObj hero = ct.image( "hero.png", 45, 45, 10 );

if (hero.containsPoint( 50, 50 ))
	ct.println( "Hero is over the center of the screen" );
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.containsPoint()]


### obj.hit()
Return `true` if a [GameObj](#java-data-types) currently intersects 
another specified [GameObj](#java-data-types).

#### Syntax
```
obj.hit( objTest )
```
##### obj
([GameObj](#java-data-types)). A graphics object. 

##### objTest
([GameObj](#java-data-types)). Another graphics object. 

##### *Return Value*
([boolean](#java-data-types)). `true` if `obj` and `objTest` are
currently overlapping (or partially overlapping) on the screen.

#### Notes
Calling this method every time in your [update()] function
can be used to test if/when two objects "hit" each other.

Text ([ct.text()]) and image ([ct.image()]) objects test the rectangular 
bounds of the object.

Except for line objects ([ct.line()]), the thickness of the border of the
object (see [obj.setLineWidth()]) is not included as part of the object area.

#### Example
```
GameObj block, dot;

public void start()
{
	block = ct.rect( 70, 50, 10, 10 );
	dot = ct.circle( 20, 50, 5 );
}

public void update()
{
	dot.x++;
	if (dot.hit( block ))
		ct.println( "The dot hit the block" );
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.hit()]


### obj.objectHitInGroup()
Determines if a [GameObj](#java-data-types) currently intersects 
another [GameObj](#java-data-types) in the specified group.

#### Syntax
```
obj.objectHitInGroup( group )
```
##### obj
([GameObj](#java-data-types)). The graphics object. 

##### group
([String](#java-data-types)). A group name for objects (see [obj.group]),
or `null` to consider all objects. 

##### *Return Value*
([GameObj](#java-data-types)). If `obj` currently intersects
(overlaps or partially overlaps) another [GameObj](#java-data-types)
that has [obj.group] equal to `group` (or any object if `group` is `null`), 
then the other [GameObj](#java-data-types) is returned, otherwise `null` 
is returned.

> Note that `null` is returned if no intersecting object is found, 
> so you must check the return value for `null` before using the 
> [GameObj](#java-data-types) returned. 

#### Notes
Calling this method every time in your [update()] function
can be used to test if/when an object "hits" any other objects
that you are interested in.

Text ([ct.text()]) and image ([ct.image()]) objects test the rectangular 
bounds of the object.

Except for line objects ([ct.line()]), the thickness of the border of the
object (see [obj.setLineWidth()]) is not included as part of the object area.

#### Example
```
GameObj bullet;

public void start()
{
	GameObj c = ct.circle( 30, 20, 10 );
	c.group = "targets";
	c = ct.circle( 70, 20, 10 );
	c.group = "targets";

	bullet = ct.rect( 70, 100, 1, 10 );
	bullet.setYSpeed( -1 );
}

public void update()
{
	GameObj target = bullet.objectHitInGroup( "targets" );
	if (target != null)
		target.delete();
}
```
###### [Code12 Function Reference](#top) > [GameObj Methods] > [obj.objectHitInGroup()]


Java Math Functions
-------------------
Code12 supports the following functions and fields from the Java `Math` class.

For more information, see the 
[Java Math Class](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html).

```
Function               Parameter Type(s)   Return Type
--------------------   -----------------   -----------
Math.abs( number )     double              double
Math.abs( number )     int                 int
Math.acos( number )    double              double
Math.asin( number )    double              double
Math.atan( number )    double              double
Math.atan2( y, x )     double, double      double
Math.ceil( number )    double              double
Math.cos( angle )      double              double
Math.cosh( angle )     double              double
Math.exp( number )     double              double
Math.floor( number )   double              double
Math.log( number )     double              double
Math.log10( number )   double              double
Math.max( a, b )       double, double      double
Math.max( a, b )       int, int            int
Math.min( a, b )       double, double      double
Math.min( a, b )       int, int            int
Math.pow( num, exp )   double, double      double
Math.sin( angle )      double              double
Math.sinh( angle )     double              double
Math.sqrt( number )    double              double
Math.tan( angle )      double              double
Math.tanh( angle )     double              double

Field       Type
-------     ------
Math.E      double
Math.PI     double

```

###### [Code12 Function Reference](#top) > [Java Math Functions]


Java String Methods
-------------------
Code12 supports the following method functions from the Java `String` class.
String methods must operate on a variable of type [String](#java-data-types),
shown below as `str`.

For more information, see the 
[Java String Class](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html).

```
Function                      Parameter Type(s)   Return Type
---------------------------   -----------------   -----------
str.compareTo( str2 )         String              int
str.equals( str2 )            String              boolean
str.indexOf( strFind )        String              int
str.length()                                      int
str.substring( begin )        int                 String
str.substring( begin, end )   int, int            String
str.toLowerCase()                                 String
str.toUpperCase()                                 String
str.trim()                                        String
```

###### [Code12 Function Reference](#top) > [Java String Methods]


Main Program Functions
----------------------
The functions [start()] and [update()] are two functions that your program
provides to contain the code for your program. Unlike other Code12 functions,
you do not call the [start()] or [update()] functions. Instead, you *write*
these functions by providing the function body in { brackets }, and *Code12
will call them* when appropriate.

Your [start()] function is called once at the beginning of each new run of
your program, and then [update()] is called before each new animation frame
is drawn (60 times per second).

The sequence of events for a Code12 program is:

1. Any class-level variables that you declare are initialized.
2. Code in your [start()] function is executed.
3. Code12 draws the graphics screen for the first time.
4. The following steps are now repeated until the program is stopped:
	a. The system waits until the next animation frame (about 1/60th of a second).
 	b. Code in your [update()] function is executed.
	c. The system redraws the graphics screen.

###### [Code12 Function Reference](#top) > [Main Program Functions]


### start()
Your `start()` function is executed once at the beginning of the program.

#### Syntax
```
public void start()
{
	// Code you write here runs once at the beginning of the program
}
```
#### Example
```
public void start()
{
	ct.rect( 50, 50, 80, 20 );
	ct.text( "Welcome to Code12!", 50, 50, 8 );
	ct.println( "This is the text output area" );
}
```
###### [Code12 Function Reference](#top) > [start()]


### update()
Your `update()` function is executed before each animation frame 
is drawn (60 times per second).

#### Syntax
```
public void update()
{
	// Code you write here runs before each animation frame is drawn
}
```
#### Notes
Animation frames start after the [start()] function has completed and then
repeat continuously 60 times per second.

One use of animation frames is to achieve object motion and animation.
For example, if you move an object 1 display unit to the right in
your [update()] function, then the object will move continuously
at 60 units per second.

> A common mistake is to create [GameObj](#java-data-types) objects 
> in the [update()] function in a way that causes many copies of an object 
> to be created over and over. Note that you should not call functions 
> like [ct.image()] to "draw" an image for each frame in an animation. 
> Instead, you typically want to call [ct.image()] to create the object 
> once in your [start()] function then modify the existing image
> (e.g. change its [obj.x] and [obj.y]) in your [update()] function.

Another use of animation frames is to test repeatedly for user input,
using functions such as [ct.clicked()], [ct.keyPressed()],
and [ct.keyTyped()], and [obj.clicked()].

You can also use animation frames to test repeatedly for object interactions
that can occur when objects are moving. You can call functions such as
[obj.containsPoint()] and [obj.hit()], or examine object locations
using [obj.x] and [obj.y] and write any code you want that tests what you 
need to detect.

Finally, note that you can call [ct.getTimer()] to detect the passage
of certain amounts of time if you want to do something less frequently 
than every animation frame.

#### Examples
```
int frameCount = 0;

public void start()
{
	ct.println( "Program started" );
}

public void update()
{
	frameCount++;
	ct.println( "Frame #" + frameCount );
}
```
```
GameObj dot;

public void start()
{
	dot = ct.circle( 0, 50, 10 );
}

public void update()
{
	dot.x++;
}
```
###### [Code12 Function Reference](#top) > [update()]


Input Event Functions
---------------------
Input event functions are optional functions that you can provide to 
handle mouse/touch and keyboard input and to respond to system events.
Like your [Main Program Functions], input event functions are *written*
by you and *called by the Code12 system*. 

> Using input event functions is optional and not required to handle
> mouse/touch or keyboard input. You can also use the 
> [Mouse and Keyboard Input] functions. Using input event functions
> is a more advanced technique that can be more flexible and more
> efficient.

If defined in your program, the following functions will be called 
by the system when the corresponding input event occurs:

* [onMousePress()]
* [onMouseDrag()]
* [onMouseRelease()]
* [onKeyPress()]
* [onKeyRelease()]
* [onCharTyped()]
* [onResize()]

###### [Code12 Function Reference](#top) > [Input Event Functions]


### onMousePress()
If defined in your program, this function is called whenever the user
clicks in the graphics screen (or touches it with a touch screen).

#### Syntax
```
public void onMousePress( GameObj obj, double x, double y )
{
	// Your code goes here
}
```
##### obj
([GameObj](#java-data-types)). The [GameObj](#java-data-types) that was
clicked, or `null` if none (if the background was clicked).

##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the click. 

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates)
of the click. 

#### Example
```
public void start()
{
	ct.circle( 30, 50, 10 );
	ct.rect( 70, 50, 10, 10 );
}

public void onMousePress( GameObj obj, double x, double y )
{
	if (obj != null)
		ct.logm( "Press", obj, x, y );
	else
		ct.logm( "Press", x, y );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onMousePress()]


### onMouseDrag()
If defined in your program, after a click or touch has happened, 
if the user's mouse or finger is still "down" and drags across the screen, 
then this function will be called each time the drag location changes.

#### Syntax
```
public void onMouseDrag( GameObj obj, double x, double y )
{
	// Your code goes here
}
```
##### obj
([GameObj](#java-data-types)). The [GameObj](#java-data-types) that the
click that started this drag was on, or `null` if none.

> Once a click occurs on a clickable object, all drag events
> will be sent indicating this `obj`, even if the (`x`, `y`) location
> is no longer on the object.

##### x
([double](#java-data-types)). The current [x coordinate](#graphics-coordinates)
of the drag. 

##### y
([double](#java-data-types)). The current [y coordinate](#graphics-coordinates)
of the drag. 

#### Notes
Because the system checks frequently for changes in the mouse/touch position,
you may get many `onMouseDrag()` events in rapid succession.

#### Example
```
public void start()
{
	ct.circle( 30, 50, 10 );
	ct.rect( 70, 50, 10, 10 );
}

public void onMouseDrag( GameObj obj, double x, double y )
{
	if (obj != null)
		ct.logm( "Drag", obj, x, y );
	else
		ct.logm( "Drag", x, y );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onMouseDrag()]


### onMouseRelease()
If defined in your program, after a click or touch has happened, 
this function will be called when the click or touch is released.

#### Syntax
```
public void onMouseRelease( GameObj obj, double x, double y )
{
	// Your code goes here
}
```
##### obj
([GameObj](#java-data-types)). The [GameObj](#java-data-types) that the
click was originally on, or `null` if none.

> Once a click occurs on a clickable object, the release event
> will be sent indicating this `obj`, even if the (`x`, `y`) location
> is no longer on the object.

##### x
([double](#java-data-types)). The [x coordinate](#graphics-coordinates)
of the mouse/touch at the time of the release. 

##### y
([double](#java-data-types)). The [y coordinate](#graphics-coordinates)
of the mouse/touch at the time of the release.

#### Example
```
public void start()
{
	ct.circle( 30, 50, 10 );
	ct.rect( 70, 50, 10, 10 );
}

public void onMouseRelease( GameObj obj, double x, double y )
{
	if (obj != null)
		ct.logm( "Release", obj, x, y );
	else
		ct.logm( "Release", x, y );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onMouseRelease()]


### onKeyPress()
If defined in your program, this function is called when 
a key on the keyboard has been pressed down. 

#### Syntax
```
public void onKeyPress( String keyName )
{
	// Your code goes here
}
```
##### keyName
([String](#java-data-types)). The name of the key.
Only certain keys are supported on all platforms, see [Key Names].

#### Notes
This function is only called once for each separate key press and release,
when the key is first pressed down, reagardless of how long the key
is held down.

#### Example
```
public void start()
{
	ct.println( "Press some keys" );
}

public void onKeyPress( String keyName )
{
	ct.logm( "Press", keyName );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onKeyPress()]


### onKeyRelease()
If defined in your program, this function is called when 
a key on the keyboard has been released after being pressed. 

#### Syntax
```
public void onKeyRelease( String keyName )
{
	// Your code goes here
}
```
##### keyName
([String](#java-data-types)). The name of the key.
Only certain keys are supported on all platforms, see [Key Names].

#### Example
```
public void start()
{
	ct.println( "Press some keys" );
}

public void onKeyRelease( String keyName )
{
	ct.logm( "Release", keyName );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onKeyRelease()]


### onCharTyped()
If defined in your program, this function is called when 
keyboard action results in a printable character being generated.

#### Syntax
```
public void onCharTyped( String charString )
{
	// Your code goes here
}
```
##### charString
([String](#java-data-types)). The printable character generated, 
for example `"a"`, `"A"`, `"$"`, `" "`, etc.

#### Notes
Unlike the key names used by [onKeyPress()], the `charString`
here is a printable character including the appropriate shift status
(e.g. "A" if a shifted "a" is typed, "$" or "4", "+" vs. "=", etc.).
Only printable characters are detected, so special keys such as 
arrow keys and key sequences such as Ctrl+C do not result in characters.

Most computers have a keyboard "auto-repeat" feature, so if the user
holds down a key, you may get the first character, then perhaps
a 1 second delay, then repeats at maybe 8 characters per second.
                 
#### Example
```
public void start()
{
	ct.println( "Press some keys" );
}

public void onCharTyped( String charString )
{
	ct.logm( "Character", charString );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onCharTyped()]


### onResize()
If defined in your program, this function is called if the application window
is resized by the user when running in a standalone window.

#### Syntax
```
public void onResize()
{
	// Your code goes here
}
```

#### Notes
Most systems resize windows continuously in response to the user dragging
the window frame, so you may receive many `onResize()` events in succession.

Note that the contents of your application scale automatically relative 
to the overall window size, so in most cases you don't need to do anything
in response to a resize. 
However, if your object layout depends on the window aspect ratio or the 
physical pixel size of the window, then you can determine these as follows:

```
double width = ct.getWidth();
double height = ct.getHeight();
double aspectRatio = width / height;
int pixelWidth = ct.round( width * ct.getPixelsPerUnit() );
int pixelHeight = ct.round( height * ct.getPixelsPerUnit() );
```

#### Example
```
public void start()
{
	ct.println( "Resize the window" );
}

public void onResize()
{
	double width = ct.getWidth();
	double height = ct.getHeight();
	int pixelWidth = ct.round( width * ct.getPixelsPerUnit() );
	int pixelHeight = ct.round( height * ct.getPixelsPerUnit() );

	ct.log( width, height, pixelWidth, pixelHeight );
}
```
###### [Code12 Function Reference](#top) > [Input Event Functions] > [onResize()]


Additional Reference Information
--------------------------------

### Graphics Coordinates

Graphics objects in Code12 are positioned on the screen by (x, y) coordinates.
The coordinate values are not pixels, but instead are in unit values relative 
to the width of the graphics area, or "screen". 
Size values (e.g. width and height) use the same units.

##### X Coordinates, Width, and Object Scaling
The screen area is always 100 units wide, by definition, so an x-coordinate of 50 
is always horizontally centered in the screen. You can think of an x-coordinate
value as a percent of the window width. An x value of 0 is at the left edge, 50 is 
in the center, and 100 is at the right edge. Similarly, a width of 50 is half as
wide as the screen.

> If you resize the Code12 application or use the pane splits to change the size
> of the graphics screen area, your graphics objects will automatically scale 
> along with the screen, and the coordinates of the objects do not change. 

##### Y Coordinates, Height, and Aspect Ratio
By default, the screen area is square, so the screen is also 100 units high.
A y value of 0 is at the top edge, 50 is centered vertically, and 100 is at 
the bottom edge. Similarly, a height of 50 would be half as high as the default
screen size.

> Note that unlike in Algegra, the origin (0, 0) is at the top-left of the screen,
> and y-coordinates increase downward, not upwards.

If you want the screen area for your program to be taller or wider than square
(e.g. a rectangle in "portrait" or "landscape" orientation), you can use the 
[ct.setHeight](#ct.setheight) function to change the height of the screen area.

##### Coordinate Precision
Coordinate values are of type [double](#java-data-types), so they may include 
non-integer precision (for example, you could have x = 8.25). Because coordinates
are relative values, not pixels, the actual pixel locations of objects are 
determined automatically and "on the fly" by the graphics system based on the size
of the screen area.

##### Positioning Objects Off-screen
By default, x and y coordinates in the screen area range from 0 to 100. 
However, it is not an error to position objects outside of the screen bounds.
For example, you could position a circle at (-10, 150), which would put it
slightly off-screen to the left and quite a bit off-screen beyond the bottom.
Objects outside the screen area still exist but are simply not visible, and
objects overlapping a screen edge are "clipped" at the edge.

##### Changing the Screen Origin to Scroll the Screen
By default the position (0, 0) is at the upper-left corner of the screen.
However, you can use the [ct.setScreenOrigin()] function to change the position 
of the origin, which will effectively "scroll" the screen.
You can use this to more easily create games and other applications in which the 
screen acts like a window into a larger world that you can move through.   

###### [Code12 Function Reference](#top) > [Additional Reference Information] > [Graphics Coordinates]


### Java Data Types
Code12 supports the standard Java data types `int`, `double`, `boolean`, and `String`,
plus the `GameObj` type defined by Code12.

#### int
A number with an integer value. 
Examples: `3`, `125`, `0`, `-1`, `43500`, `-1203`.

#### double
A number which can include optional decimal places. 
Examples: `3.14`, `5.0`, `-67.456`, `0.0`, `154.003`, `-0.0001`

#### boolean
A logical (truth) value that can only be `true` or `false`.

#### String
A sequence of text characters. When the value of a string is given directly,
it must be enclosed in double quotes. 
Examples: `"hello"`, `"What is your name?"`, `"3"`, `"food4u*$-!)"`

#### GameObj
A `GameObj` (Game Object) is a reference to a graphical object (circle, rectangle, 
line, text, or image) that you can create for display on the screen. To create a `GameObj`,
see [Graphics Object Creation]. If you store a `GameObj` in a variable then you can 
also access and change the object later using the [GameObj Data Fields] and [GameObj Methods].

###### [Code12 Function Reference](#top) > [Additional Reference Information] > [Java Data Types]


### Color Names
The following color names are supported.
If a String value used as a color is not recognized then "gray" is used.
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
"brown"          (130, 70, 30)

"light gray"     (191, 191, 191)
"light red"      (255, 127, 127)
"light green"    (127, 255, 127)
"light blue"     (170, 225, 255)
"light cyan"     (127, 255, 255)
"light magenta"  (255, 127, 255)
"light yellow"   (255, 255, 127)

"dark gray"      (64, 64, 64)
"dark red"       (127, 0, 0)
"dark green"     (0, 127, 0)
"dark blue"      (0, 0, 127)
"dark cyan"      (0, 127, 127)
"dark magenta"   (127, 0, 127)
"dark yellow"    (220, 190, 0)

```
###### [Code12 Function Reference](#top) > [Additional Reference Information] > [Color Names]


### Key Names
The following key names are supported on all platforms
(different operating systems and computers) that have these keys. 
Support for other keys is platform-dependent.

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

###### [Code12 Function Reference](#top) > [Additional Reference Information] > [Key Names]


<footer>
	Code12 Version 1.0

	Copyright (c) 2019 Code12. All Rights Reserved. 
</footer> 
