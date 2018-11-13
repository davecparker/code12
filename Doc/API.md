% Code12 API Documentation

The Code12 API functions are built in to the Code12 application.

##### Code12 (ct) API Functions
* [Graphic Object Creation](#graphic-object-creation)
* [Text Output](#text-output)
* [Alerts and Input Dialogs](#alerts-and-input-dialogs)
* [Screen Management](#screen-management)
* [Mouse and Keyboard Input](#mouse-and-keyboard-input)
* [Audio](#audio)
* [Math and Misc.](#math-and-misc-)
* [Type Conversion](#type-conversion)

##### GameObj Fields and Methods
* [GameObj Data Fields](#gameobj-data-fields)
* [GameObj Methods](#gameobj-methods)

##### Math and String Operations
* [Java Math Methods and Fields Supported](#java-math-methods-and-fields-supported)
* [Java String Methods Supported](#java-string-methods-supported)

##### Input Events and Program Control Functions
* [Program Control Functions](#program-control-functions)
* [Input Event Functions](#input-event-functions)

##### Additional Reference Information
* [Graphics Coordinates](#graphics-coordinates)
* [Java Data Types](#java-data-types)
* [Color Names](#color-names)
* [Key Names](#key-names)


Graphic Object Creation
-----------------------
These functions allow you to create new graphics objects for display on the screen.

* [ct.circle()](#ct.circle)
* [ct.rect()](#ct.rect)
* [ct.line()](#ct.line)
* [ct.text()](#ct.text)
* [ct.image()](#ct.image)


### ct.circle()
Creates a new circle graphics object (GameObj).

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
(see [GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods)).

#### Examples
```
ct.circle( 50, 30, 20 );
```
```
ct.circle( 50, 70, 40, "blue" );
```
```
GameObj ball = ct.circle( 0, 50, 10, "yellow" );
ball.xSpeed = 1;
```


### ct.rect()

Creates a new rectangle graphics object (GameObj).

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
(see [GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods)).

#### Examples
```
ct.rect( 50, 30, 40, 20 );
```
```
ct.rect( 50, 70, 80, 40, "blue" );
```
```
GameObj platform = ct.rect( 0, 50, 30, 8, "orange" );
platform.xSpeed = 1;
```


### ct.line()

Creates a new line graphics object (GameObj) drawn from a point (`x1`, `y2`) 
to a second point (`x2`, `y2`).

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
(see [GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods)).

#### Examples
```
ct.line( 10, 30, 90, 40 );
```
```
ct.line( 10, 50, 90, 50, "blue" );
```
```
GameObj border = ct.line( 0, 75, 100, 75, "red" );
border.lineWidth = 3;
```


### ct.text()

Creates a new text graphics object (GameObj), which can be used to display text
on the graphics screen.

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
(see [GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods)).

#### Examples
```
ct.text( "Zombie Attack!", 50, 40, 20 );
```
```
ct.text( "Click anywhere to play", 50, 60, 5, "blue" );
```
```
GameObj scoreText = ct.text( "Score: 0", 100, 20, 10, "green" );
scoreText.align( "right" );
```


### ct.image()

Creates a new graphics image object (GameObj) from an image file (.PNG or .JPG).

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
(see [GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods)).

#### Examples
```
ct.image( "dragon.png", 30, 50, 10 );
```
```
// Stretch the sky image to fill the entire screen
GameObj sky = ct.image( "sky.jpg", 50, 50, 100 );
sky.setSize( 100, 100 );
```


Text Output
-----------
These functions allow you to output text to the console area, 
which is below the graphics area in the Code12 application.
Text in this area displays as a continuous scrolling stream of lines.
You can also output to a text file on your computer.

> To display text on the graphics screen, use [ct.text()](#ct.text).

* [ct.print()](#ct.print)
* [ct.println()](#ct.println)
* [ct.log()](#ct.log)
* [ct.logm()](#ct.logm)
* [ct.setOutputFile()](#ct.setoutputfile)


### ct.print()

Output text, or the text representation of any value, to the console.
A newline is *not* added, so any subsequent text output will appear on
the same line. 

> This is equivalent to Java's `System.out.print()`.

#### Syntax
```
ct.print( value );
```
##### value
(Any type). The text or value to output.

#### Examples
```
// These will output on the same line
ct.print( "Hello" );
ct.print( " there!" );
```
```
String userName = "Jennifer";
int score = 500;

ct.print( "User " );
ct.print( userName )
ct.print( " has a score of " );
ct.print( score );
```


### ct.println()

Output text, or the text representation of any value, to the console.
A newline is automatically added to end the line after the value. 

> This is equivalent to Java's `System.out.println()`.

#### Syntax
```
ct.println( value );
ct.println();
```
##### value
(Any type, optional). The text or value to output. If no value is given
then only a newline is output.

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
int totalScore = 250;
int numTrys = 3;

ct.println( "Your average score is " + (totalScore / numTrys) );
```


### ct.log()

Output any number of values to the console, on one line separated by commas. 
[String](#java-data-types) values are output enclosed in `"double quotes"`, 
and [GameObj](#java-data-types) objects are described in `[square brackets]`.

#### Syntax
```
ct.log( value, value2, ... );
```
##### value, value2, ...
(Any number of values, of any types). The values to output. You can pass any number
of values of any type(s). The values will be output to the console on the same line, 
separated by commas.

> Unlike [ct.println()](#ct.println), String values will be automatically output 
> enclosed in double quotes. 

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


### ct.logm()

Output a text message followed by any number values to the console, 
all on one line separated by commas. 
[String](#java-data-types) values are output enclosed in `"double quotes"`, 
and [GameObj](#java-data-types) objects are described in `[square brackets]`.

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

> Unlike [ct.println()](#ct.println), String values will be automatically enclosed 
> in double quotes. 

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


### ct.setOutputFile()

If you call `ct.setOutputFile( filename )`, then any subsequent text output
from [ct.print()](#ct.print), [ct.println()](#ct.println), 
[ct.log()](#ct.log), and [ct.logm()](#ct.logm) will be
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

ct.setOutputFilename( "Math Test Results.txt" );
ct.println( "Test of simple math operations" );
ct.log( a, b );
ct.println( "Sum = " + (a + b) );
ct.println( "Difference = " + (a - b) );
ct.println( "Product = " + (a * b) );
ct.println( "Quotient = " + (a / b) );
ct.setOutputFilename( null );
```


Alerts and Input Dialogs
------------------------
These functions allow you to display a message box for the user
and to prompt for input from the user.

* [ct.showAlert()](#ct.showalert)
* [ct.inputInt()](#ct.inputint)
* [ct.inputNumber()](#ct.inputnumber)
* [ct.inputYesNo()](#ct.inputyesno)
* [ct.inputString()](#ct.inputstring)


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


### ct.inputInt()

Displays a message in a pop-up dialog box that asks the user to
enter a number.
Execution of the program will pause and wait until the user
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
```


### ct.inputNumber()

Displays a message in a pop-up dialog box that asks the user to
enter a number.
Execution of the program will pause and wait until the user
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
```


### ct.inputYesNo()

Displays a message in a pop-up dialog box that has two buttons
labelled Yes and No.
Execution of the program will pause and wait until the user
presses one of the buttons.

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
```


### ct.inputString()

Displays a message in a popup dialog box that allows the user to
enter a text string.
Execution of the program will pause and wait until the user
presses the Enter key to end the text input. 
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
```


Screen Management
-----------------
These functions allow you to control the size and appearance of the 
background of your application, and to manage multiple screens and 
groups of objects.

* [ct.setTitle()](#ct.settitle)
* [ct.setHeight()](#ct.setheight)
* [ct.getWidth()](#ct.getwidth)
* [ct.getHeight()](#ct.getheight)
* [ct.getPixelsPerUnit()](#ct.getpixelsperunit)
* [ct.getScreen()](#ct.getscreen)
* [ct.setScreen()](#ct.setscreen)
* [ct.setScreenOrigin()](#ct.setscreenorigin)
* [ct.clearScreen()](#ct.clearscreen)
* [ct.clearGroup()](#ct.cleargroup)
* [ct.setBackColor()](#ct.setbackcolor)
* [ct.setBackColorRGB()](#ct.setbackcolorrgb)
* [ct.setBackImage()](#ct.setbackimage)

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

### ct.getWidth()

This function always returns 100.0, which is the width of the application
window in [coordinate units](#graphics-coordinates) by definition.

#### Syntax
```
ct.getWidth();
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

### ct.getHeight()

Returns the height of the the application window in 
[coordinate units](#graphics-coordinates).
This is 100.0 by default, unless it is changed by [ct.setHeight()](#ct.setheight).

#### Syntax
```
ct.getHeight();
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


### ct.getPixelsPerUnit()

Returns the current graphics scale factor from 
[coordinate units](#graphics-coordinates) to device pixels. 

#### Syntax
```
ct.getPixelsPerUnit();
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
```
```
// Create a circle that is 10 pixels in diameter at the current scale
double diameter = 10 / ct.getPixelsPerUnit();
ct.circle( 50, 50, diameter );
```


### ct.getScreen()

Returns the name of the current screen, which is the most recent
screen set using [ct.setScreen()](#ct.setscreen).

#### Syntax
```
ct.getScreen();
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


### ct.setScreen()

Sets the current screen to the screen with the specified name.

#### Syntax
```
ct.setScreen( name );
```
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
	ct.text( "Game Over", 50, 50, 20 );
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
	ct.backImage( "city.jpg" );
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

> A screen's background image created with [ct.setBackImage()](#ct.setbackimage)
> is not affected by the screen origin. If you want a background image
> that scrolls, you can instead use [ct.image()](#ct.image) to create and display 
> one that is larger than the normal screen window.

#### Example
```
ct.image( "mountains.png", 50, 50, 300 );   // wider than screen
ct.image( "bear", 50, 70, 10 );
ct.setScreenOrigin( 30, 0 );       // entire scene scrolls to the left
```


### ct.clearScreen()

Removes and deletes all graphics (`GameObj`) objects on the current screen.
The background color or image is kept, if any.

#### Syntax
```
ct.clearScreen( )
```
#### Example
```
ct.setBackColor( "red" )
ct.circle( 50, 50, 20 );
ct.rect( 50, 70, 40, 10 );
ct.clearScreen();     // screen is now just solid red
```


### ct.clearGroup()

Removes and deletes all graphics (`GameObj`) objects on the current screen
whose [group name](#obj.group) matches the name passed.

#### Syntax
```
ct.clearGroup( name )
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
ct.setBackColorRGB( 0, 60, 255 );    // greenish blue
```


### ct.setBackImage()

Sets the background of the current screen to an image.
The background image always displays behind all graphics (`GameObj`) objects
on the screen.

#### Syntax
```
ct.setBackImage( filename )
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



Mouse and Keyboard Input
------------------------
These functions allow you to easily process mouse/touch and keyboard input
in your `update()` function.

* [ct.clicked()](#ct.clicked)
* [ct.clickX()](#ct.clickx)
* [ct.clickY()](#ct.clicky)
* [ct.objectClicked()](#ct.objectclicked)
* [ct.keyPressed()](#ct.keypressed)
* [ct.charTyped()](#ct.chartyped)

Calling these functions in your `update()` function causes them to be called
repeatedly, once for each animation frame (60 times per second), 
which is fast enough to provide fast response to input.

> Another more flexible way to handle mouse/touch and keyboard input,
> which requires writing your own functions with parameters (syntax level 10),
> is to write your own [Input Event Functions](#input-event-functions) 


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

Calling this function every time in your `update()` function will 
detect all mouse clicks in your application window.

If this function returns `true` then you can retrive the click location
using `ct.clickX()` and `ct.clickY()`.

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

You should call [ct.clicked()](#ct.clicked) and test for a return value 
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

You should call [ct.clicked()](#ct.clicked) and test for a return value 
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


### ct.objectClicked()

If a clickable graphics (`GameObj`) object was clicked during the 
last animation frame, then `ct.objectClicked()` returns a reference 
to that object, otherwise it returns `null` .

#### Syntax
```
ct.objectClicked()
```
##### *Return Value*
([GameObj](#java-data-types)). The object that was clicked.

#### Notes

Calling this function every time in your `update()` function will find 
the topmost clickable object that was clicked, whenever the user clicks
on one.

> Any objects with the [clickable](#obj.clickable) field set to `false` 
> will not be considered when determining which object was clicked. 

> **Note:** `ct.objectClicked()` will return `null` if no object was
> clicked, which is the case for most animation frames in a game 
> (they occur 60 times per second). So you must check the return value
> for `null` before using the `GameObj` returned. Attempting to access 
> a field of a `GameObj` (such as [obj.x](#obj.x)) or call a method 
> (such as [obj.delete()](#obj.delete))
> will generate a runtime error (a "crash") if the `GameObj` is `null`.

#### Example
```
public void update()
{
	// Delete objects that get clicked
	GameObj obj = ct.objectClicked();
	if (obj != null)
		obj.delete();
}
```

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

If you call this function every time in your `update()` function,
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
		ball.x += 0.25 
}
```

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

Calling this function every time in your `update()` function
will detect each time that the given character is typed.
Unlike the behavior of [ct.keyPressed()](#ct.keypressed), 
you will only get one `true` result for each typed character.
However, most platforms have a keyboard "auto-repeat" feature,
so if you check `ct.charTyped()` every time in your `update()` function,
and the user holds down a key, you may get the first character,
then perhaps a 1 second delay, then repeats at maybe 8 characters
per second.

#### Example
```
public void update()
{
	if (ct.charTyped( "w" ))
		ct.println( "w was typed" );
	
	if (ct.charTyped( " " ))
		ct.println( "Space bar" );
}
```


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

### ct.pause()
```
ct.pause( )
```
Execution of the program is paused at this statement.
You can then resume or stop execution using the toolbar buttons
in the Code12 application. 

> You can use `ct.pause` to help you examine or debug your program
> while running your program in the Code12 application.
> The `ct.pause` function is not supported (ignored) when programs 
> are running standalone outside of the Code12 application.

### ct.stop()
```
ct.stop( )
```
Execution of the program is immediately stopped and ended at this statement.
You can restart execution over from the beginning of the program using 
the **Restart** toolbar button in the Code12 application. 

> You can use `ct.stop` to help you examine or debug your program
> while running your program in the Code12 application.
> The `ct.stop` function is not supported (ignored) when programs 
> are running standalone outside of the Code12 application.

### ct.restart()
```
ct.restart( )
```
Execution of the program is immediately stopped and restarted from 
the beginning of the program. Variables are re-initialized with their
default/starting values, and execution starts over with your `start`
function.

> The `ct.restart` function is not supported (ignored) when programs 
> are running standalone under the Java runtime outside of the 
> Code12 environment.


Type Conversion
---------------
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


GameObj Data Fields
-------------------
`GameObj` objects are graphics objects visible on the screen.
See [GameObj Creation](#gameobj-creation) to create a `GameObj`.
All `GameObj` objects have the following public data fields,
which can be accessed or assigned to at any time.
If assigned to, the new value takes effect at the next
animation frame.

### x, y
```
double x, y
```
The `x` and `y` fields specify the position of the object
in the application window, in graphics coordinates.
By default, graphics coordinates range from 0 to 100 in both x and y
if the window is square. If the window is not square (see `ct.setHeight()`),
then x coordinates still range from 0 (left edge) to 100 (right edge),
but y coordinates will range from 0 (top edge) to the value returned
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
> the next time the object draws (at the next animation frame).

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
`x` and `y` fields before each new animation frame.
Animation frames happen 60 times per second, so setting `xSpeed` to 1
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
the last animation frame. Only objects with both the `visible` and `clickable`
fields set to `true` will receive mouse/touch input.

Calling this method for an object every time during your `update()` function
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
object `objTest`. If you call this method every time in your `update()` 
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


Java Math Methods and Fields Supported
--------------------------------------
Code12 supports the following fields and method functions from the Java `Math` class.
```
Field       Type
-------     ------
Math.E      double
Math.PI     double

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
```
For more information, see the [Java Math Class](https://docs.oracle.com/javase/8/docs/api/java/lang/Math.html).


Java String Methods Supported
-----------------------------
Code12 supports the following method functions from the Java `String` class.
String methods must operate on a variable of type [String](#java-data-types),
shown below as `str`.
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
For more information, see the [Java String Class](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html).


Program Control Functions
-------------------------

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
The `update` function is called at the beginning of each animation frame.
Animation frames start after the `start()` function has completed and then
repeat continuously 60 times per second.

One use of animation frames is to achieve object motion and animation.
For example, if you move an object 1 display unit to the right in
your `update()` function, then the object will move continuously
at 60 units per second.

Another use of animation frames is to test repeatedly for user input,
using functions such as `ct.clicked()`, `ct.keyPressed()`,
and `ct.keyTyped()`, and the `GameObj` method `obj.clicked()`.

You can also use animation frames to test repeatedly for object interactions
that can occur when objects are moving. You can
examine object fields such as `x` and `y` directly, call the `GameObj` methods
`obj.containsPoint()` and `obj.hit()`, call the function `ct.distance()` or
write any code you want that tests what you need to detect.

Finally, note that you can call `ct.getTimer()` to detect the passage
of certain amounts of time if you want.

> A common mistake is to create `GameObj` objects in the `update()` function
> in a way that causes many copies of the object to be created over
> and over. Note that you should *not* call functions like `ct.circle()` to
> "draw" a circle for each frame in an animation. Instead, you typically
> want to call `ct.circle()` to create the object once in your `start` function,
> then modify the existing circle in your `update()` function.

Input Event Functions
---------------------
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
> than making many tests in your `update()` function.

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


Additional Reference Information
--------------------------------

### Graphics Coordinates

Graphics objects in Code12 are positioned on the screen by (x, y) coordinates.
The coordinate values are not pixels, but instead are in unit values relative 
to the size of the graphics area, which we will call the "screen". 
Size values (e.g. width and height) use the same units.

##### X Coordinates, Width, and Objext Scaling
The screen area is always 100 units wide, by definition, so an x-coordinate of 50 
is always horizontally centered in the screen. So you can think of an x-coordinate
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
However, you can use the [ct.setScreenOrigin](#ct.setscreenorigin) function to
change the position of the origin, which will effectively "scroll" the screen.
You can use this to more easily create games and other applications in which the 
screen acts like a window into a larger world that you can move through.   


### Java Data Types
Code12 supports the standard Java data types `int`, `double`, `boolean`, and `String`,
plus the `GameObj` type defined by Code12.

#### int
A number with an integer value. 
Examples: `3`, `125`, `0`, `-1`, `43500`, `-1200`.

#### double
A number which can include optional decimal places. 
Examples: `3.14`, `5`, `-67.456`, `0`, `154.003`, `-0.0001`

#### boolean
A logical (truth) value that can only be `true` or `false`.

#### String
A sequence of text characters. When the value of a string is given directly,
it must be enclosed in double quotes. 
Examples: `"hello"`, `"What is your name?"`, `"3"`, `"food4u*$-!)"`

#### GameObj
A `GameObj` (Game Object) is a reference to a graphical object (circle, rectangle, line, 
text, or image) that you can create for display on the screen. To create a `GameObj`
see [Graphic Object Creation](#graphic-object-creation). If you store a `GameObj` in
a variable then you can also access and change the object later using 
[GameObj Data Fields](#gameobj-data-fields) and [GameObj Methods](#gameobj-methods).


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
