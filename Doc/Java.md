% Java Language Help

##### [Java Language Constructs](#java-syntax-examples)
* [Function Calls]
* [Comments]
* [Variables]
* [Expressions]
* [Function Return Values]
* [Object Data Fields]
* [Object Method Calls]
* [If-else]
* [Function Definitions]
* [Parameters]
* [Loops]
* [Arrays]

##### Java Language Elements
* [Java Data Types]


###### Code12 Version 1.0


Java Syntax Examples
--------------------

These sections contain examples of Java language syntax for 
the 12 core programming constructs supported by Code12.

1. [Function Calls]
2. [Comments]
3. [Variables]
4. [Expressions]
5. [Function Return Values]
6. [Object Data Fields]
7. [Object Method Calls]
8. [If-else]
9. [Function Definitions]
10. [Parameters]
11. [Loops]
12. [Arrays]

###### [Java Language Help](#top) > [Java Syntax Examples]


### Function Calls
A function call is a named command for your program to execute, followed by 
a list of input values for the command to use.

#### Examples
```
ct.println( "Hello World!" );
```
```
ct.circle( 50, 30, 20 );
```
```
ct.circle( 50, 70, 20, "green" );
```
```
ct.setBackColor( "dark gray" );
```
```
ct.text( "Game Over", 50, 50, 10 );
```
```
ct.rect( 45, 45, 20, 20, "pink" );
ct.circle( 55, 55, 20, "light blue" );
```
#### Notes
A function call is the most common programming construct. 
It is essentially a command for the program to do something.
The command has a name (for example `ct.circle`) 
followed by a list of input values in parentheses, and at the
very end is a semicolon.
The input values provide additional details that the command
needs to do its work. For example, in the call:
```
ct.circle( 50, 30, 20 );
```
you need to give a list of 3 numbers to the command.
For `ct.circle`, these are the x-coordinate, y-coordinate,
and diameter of the circle.

If you make a sequence of function calls, they are executed
one at a time in the order they are listed in your program. 

> ##### Java Terminology
> Java programmers will often refer to function calls as 
> "method calls".

> The input values to a function call are called "parameters" or
> "arguments".

##### Parameters
Each command (function) requires different input values (parameters). 
To determine what parameters a function needs, you
can look it up in the reference documentation. For the Code12
system, this is the [Code12 Function Reference](API.html).
You must list the parameters in the order they are expected
by the function.

Parameters can have different types (e.g. number vs. text),
and each parameter you supply must be the correct type or 
you will get an error. See [Java Data Types] for examples.

Text values are called "strings" (type [String](#java-data-types)) 
and are enclosed in `"double quotes"` when you are specifying 
the text directly. 

There are two types of numbers: [int](#java-data-types) 
and [double](#java-data-types), depending on whether the number 
is allowed to have decimal places or not.
You are allowed to use an `int` where a `double` is required
and it will convert automatically, but you cannot use a
`double` where an `int` is required, because precision would
be lost. 

##### Optional Parameters
Some functions have parameters that are optional, meaning you can 
choose to specify them or not. For example, the `ct.circle` function 
has an optional 4th parameter, which is a color name for the circle, 
as in:
```
ct.circle( 50, 70, 20, "green" );
```
If you do not specify an optional parameter, the function will
use a default value. In the case of `ct.circle`, if you don't
specify the color, it defaults to the color `"red"`.

##### Functions Supported
What functions you have to choose from in your program depends on
what "libraries" your system provides or that you have installed.
Code12 has its own library of functions build-in, and most
of these functions start with the prefix `ct.` (for "Code Twelve").
For a complete list, see the [Code12 Function Reference](API.html).

The Java programming language is often used with a large library
called the "Java Class Library", but Code12 only supports a
handful of functions from this library when programs are run
within the Code12 application.

###### [Java Language Help](#top) > [Function Calls]


### Comments
Comments are a way for programmers to leave notes to themselves or
other programmers in the code. They are ignored when the program executes.

#### Examples
```
// This is a comment
```
```
// Draw a circle in the center of the screen
ct.circle( 50, 50, 20 );
```
```
// Draw 3 circles
ct.circle( 30, 50, 10 );    // left side
ct.circle( 50, 50, 10 );    // center
ct.circle( 70, 50, 10 );    // right side
```
```
// The statement below has been "commented out" (disabled)
// ct.circle( 50, 50, 10);
```
```
/*
   This is a block comment.
   It can go on for several lines.
   If the block comment contains any Java code,
   the code will all be ignored.

   ct.rect( 50, 50, 70, 70 );
   ct.circle( 50, 50, 20 );

   The above code is ignored.
*/
```
#### Notes
Comments help make your program more readable (to humans) by
explaining what is going on and giving other information that
might be useful to you or another programmer reading your code.
Comments are ignored by Java when your program is being executed.

Besides leaving helpful notes, another use of comments is to
temporarily disable some code without deleting it
(because you might want to add it back later, for example).

There are two different ways to make a comment in Java. 
The most common way is use to `//`, which causes all text
after it until the end of the line to be treated as a comment.

If you want to make a long comment that spans several lines,
you can also use a block comment, which begins with `/*` and 
ends with `*/` at any point in your code after the start 
of the comment.

###### [Java Language Help](#top) > [Comments]


### Variables
A variable is a name for a location in memory that can store a value
(such as a number). The value of the variable can be changed during a
program, but only the most recent value is remembered.
Using a variable name in a program causes the value to be substituted.

#### Examples
```
int x = 30;
ct.circle( x, 50, 20 );
```
```
int xPosition = 30;
double yPosition = 25.5;
int size = 10;
String color = "yellow";

ct.circle( xPosition, yPosition, size, color );

xPosition = 70;

ct.rect( xPosition, yPosition, size, size, color );
```
#### Notes
Variables can have different types, corresponding to the type 
of value that they can store. Code12 supports 5 different
types of variables: `int`, `double`, `boolean`, `String`,
and `GameObj` (see [Java Data Types]).

The first time a new variable is introduced in your program,
you must "declare" the variable by specifying its type.
The type is followed by the name of the variable, which you
can choose, then a equals sign ("=") and the starting value
for the variable. For example:
```
int xPosition = 30;
```
Finally, like most Java statements, the entire statement must 
be followed by a semicolon.

##### Variable names
You can choose the names for your variables, and unlike in
mathematics, they can be multiple characters (e.g. a word).
Variable names must start with a letter, and by convention
in Java, it should be a lowercase letter (a-z). After the
first letter, you can use any sequence of letters, digits (0-9),
and the underscore ("\_") character. Examples:
```
int x = 30;
int x2 = 70;
int count = 1;
double middle = 2.5;
boolean done = false;
String name = "Fred";
String gR8_name_dude = "Bill";
```
Variable names cannot contain spaces, but using a convention
called "camel case", you can create a readable multi-word name
without underscores by capitalizing the first letter of each word 
except the first, for example:
```
int enemyCount = 50;
double averageScore = 85.72;
boolean bonusMode = true;
String playerName = "Sue";
int youCanGetReallyLongButEventuallyItGetsAnnoyingToType = 100;
```
Some names are not allowed as variables because they mean
something special in the Java language, for example `double`,
`public`, `class`, `if`, `for`, and `do`. If you try to use an 
invalid variable name, you will get a syntax error.

##### Variable Declaration, Initialization, and Assignment
In the example:
```
int xPosition = 30;
```
the variable `xPosition` is being *declared* (introduced as a new
variable with the specified type) and also *initialized*
(being given its starting value).

If you want to change the value of a variable later, you can
use an *assignment* statement, for example:
```
xPosition = 70;
```
This changes the value of `xPosition` to 70 and the previous 
value of 30 is overwritten and lost. Note that you do not specify 
the type of the variable when it is being assigned, only when 
it is declared.

It is also possible to declare a variable without initializing
it, such as:
```
int xPosition;
```
However, you will need to assign a value to it before using it
for the first time anywhere else in your program, for example:
```
int xPosition;
xPosition = 30;
ct.circle( xPosition, 50, 20 );
```
If you are only declaring variables and not initializing them,
it is also possible to declare more than one at a time,
as long as they have the same type, for example:
```
int xPosition, yPosition;
String playerOneName, playerTwoName;
```
##### Class-Level Variables vs. Local Variables
Code in Java programs is grouped into blocks that are surrounded
by curly brackets `{` and `}`. A variable is only defined
inside the block that you declare it in, starting just after
the declaration and ending at the end of the block.
For example:
```
class MyProgram
{
	public void start()
	{
		int yPosition = 50;
		ct.circle( 30, yPosition, 20 );
		ct.circle( 70, yPosition, 20 );
	}

	public void update()
	{
		// yPosition cannot be used here
	}
}
```
Here the variable `yPosition` is declared in the `start`
block, so it can be used there in the two `ct.circle`
function calls after the declaration. However, it cannot
be used in the `update` block.

If you want to use a variable in any block in your program,
you can declare it in the `class` block but before the `start`
block. For example:
```
class MyProgram
{
	int size = 20;

	public void start()
	{		
		int yPosition = 50;
		ct.circle( 30, yPosition, size );
		ct.circle( 70, yPosition, size );
	}

	public void update()
	{
		// size can be used here, but not yPosition
	}
}
```
This works because variables are defined in the block they
are defined in as well as any nested blocks inside it.

A variable that is defined at the start of the `class` block
is called a *class-level variable* and can be used anywhere
in your program. A variable declared in any block other than
the class block (such as `yPosition` above) is called
a *local variable* because it can only be used locally in 
the block with the declaration.

Note that the memory storage location for a class-level variable 
in Code12 lasts for the entire run of your program and is therefore 
"permanent", whereas the memory for a local variable is disposed
of as soon as the block it is declared in ends. Local variables
are therefore also "temporary" variables in practice.

> Only class-level (permanent) variables are displayed in the 
> variable watch window in the Code12 application, because all
> local variables come and go very quickly in practice. 

###### [Java Language Help](#top) > [Variables]


### Expressions
An expression is a combination of numbers (or values of 
other types), variables, and *operators* such as `+`, `-`,
`*`, and `/`, which causes the computer to do the calculations
and get a resulting value.

#### Examples
```
int xCenter = 50;
int x = xCenter + 10;    // assigns resulting value 60 to x
ct.log( x );
```
```
double a = 3;
double b = 2;
double sum = a + b;           // sets sum to 5
double difference = a - b;    // sets diff to 1
double product = a * b;       // sets product to 6
double quotient = a / b;      // sets quotient to 1.5
ct.log( sum, difference, product, quotient );
```
```
int hits = 5;
int misses = 9;
int bonus = 200;
double score = (hits * 50 - misses) / ((hits + misses) * 0.1) + bonus;
ct.log( score );
```
#### Notes
In most places where a numeric value is expected in a Java program,
such as where the number 9 appears in these examples:
```
int variable = 9;
variable = 9;
ct.circle( 9, 9, 9 );
```
instead of using a simple number or variable, you can also use 
an *expression*, which is a combination of numbers and variables 
combined with basic math operations such as `+` and `-`. 
For example,
```
int xCenter = 50;
int yCenter = 50;
int yLevel = yCenter - 20;
ct.circle( xCenter + 10, yLevel, 15 );
```
Here the value used to initialize `yLevel` is the expression
`yCenter - 20`, which will be calculated as 30, and first parameter 
for the function call is the expression `xCenter + 10`, which results 
in the value 60. 

When you use expressions for parameters to a function call, 
the variables and expressions are all evaluated and calculated
"on the spot" before the function is called, using the current 
values of any variables. Then the resulting values are
sent to the function, so when the `ct.circle()` function 
above is called, the call above ends up being equivalent to:
```
ct.circle( 60, 30, 15 );
```
##### Numeric Operators
The numeric operators suppported are:
```
Expression      Calculation
----------      -----------
a + b           Addition
a - b           Subtraction
-a              Negate (change sign)
a * b           Multiplication
a / b           Division
a % b           Mod (remainder)
```
The expression `a % b` operator calculates the remainder of
(a / b) after the integer part of the quotient is subtracted.
For example, `7 % 3` is 1, because (7 / 3) is 2 remainder 1.

##### Order of Operations and Parentheses
In an expression with multiple operators, such as:
```
int result = 3 + 2 * 5;     // result gets 13
```
The calculations are done in the same order as the rules
of algebra, which is not always left-to-right. 
Here, `2 * 5` will be calculated first (because multiplication
has "higher precedence" over addition), then the 3
is added, so the result is 13, not 25.

If you want to override the normal order of operations,
you can use parentheses in your expression, such as:
```
int newResult = (3 + 2) * 5;    // result gets 25
```
> It is easy to make a mistake with assumptions about
> the order of operations. Good programmers are 
> generous with their use of parentheses to reduce
> mistakes and to make their code easier to understand.

##### Changing a Variable Value
In the following code:
```
int score = 500;
int bonus = 100;
int total = score + bonus;
```
The `total` is introduced as a new variable that will be
assigned the value 600. Instead of introducing a new 
variable, it is also possible to change the value of 
the existing `score` variable:
```
int score = 500;
int bonus = 100;
score = score + bonus;
```
Here `score` is initialized to 500, but then it is assigned 
a new value using the expression `score + bonus`, which 
is calculated as 600, so `score` then gets assigned the
new value of 600 (overwriting the previous value of 500).

If you try to look at the statement `score = score + bonus;`
like an equation in algebra, it doesn't make much sense (bonus 
must be 0? But we said it was 100...). However, this makes perfect
sense in Java (and other computer languages). It is important 
to understand that assignment statements are *not equations*. 
They are *instructions* to calculate and store a new value for a 
variable. Here `score = score + bonus;` increases the value 
of the score by the bonus. This kind of code is very common
in programming.

##### Assignment Shortcuts
Statements like `score = score + bonus;` above are common 
enough that Java has a shortcut for it:
```
score += bonus;       // score = score + bonus;
```
Further, increasing a variable by 1 is even more common
(when counting things, for example), so Java has an
even shorter shortcut for that:
```
score++;             // score = score + 1
```
Here are examples of the Java assignment shortcut statements
supported by Code12:
```
Shortcut      Equivalent
--------      ----------
a += b;       a = a + b;
a -= b;       a = a - b;
a *= b;       a = a * b;
a /= b;       a = a / b;
a++;          a = a + 1;
a--;          a = a - 1;
```

##### int vs. double and Integer Division
The numeric operators (`+`, `-`, `*`, `/`, and `%`) can 
be used on values of either type [int](#java-data-types) 
or [double](#java-data-types), and the result will be 
type `int` if both sides are `int`, or `double` if 
either side is a `double`. This produces the results 
you would probably expect, except in the case of using
`/` to divide two `int` values. What if the result is
not an integer?
```
int i = 3 / 2;       // What do you think this does?  
double d = 3 / 2;    // How about this?
```
You might think that since 3/2 = 1.5, storing the result 
in an integer (`i`) will force the computer to round 
the result to 2, whereas storing the result
in a double (`d`) will store 1.5. Unfortunately,
neither of these is what Java will do...

Java treats `/` operating on two `int` values as 
"integer division", which is defined as discarding any
fractional part of the result and "truncating"
the result to an integer (always rounding towards zero), 
so here `3 / 2` is 1. This happens even if the result 
is being stored in a `double`. So, the results for both 
`i` and `d` above would be 1. 

Normally Java would just produce the result of 1 for both
`i` and `d` above without warning. Because this situation 
is a common source of errors (especially for beginning 
programmers), Code12 considers the above statements to be
errors, and you must code them differently. There are three
choices to rewrite it:
```
// Make sure at least one side is a double
double d = 3.0 / 2;       // 1.5
```
```
// Use a "type cast" to convert one side to double
int left = 3;
int right = 2;
double d = (double) left / right;     // 1.5
```
```
// Use ct.intDiv() if you really want integer division
int i = ct.intDiv( 3, 2 );         // 1
```
##### Using + for String Concatenation 
In addition to using the `+` operator to add two numeric
values, you can also use it to combine two
[String](#java-data-types) (text) values. The result
is a new longer string with the second string appended to
the end of the first string. This is called "concatenation".
For example:
```
String firstName = "John";
String lastName = "Smith";
String fullName = firstName + " " + lastName;   // "John Smith"
ct.log( firstName, lastName, fullName );
```
Java also allows you to concatenate numbers with strings,
in which case the number is automatically converted to
text (a string) and then the text is concatenated.
For example:
```
String name = "Sue";
int score = 500;
String message = "Player " + name + " has score " + score;
ct.log( message );     // "Player Sue has score 500"
```
Note the use of spaces in the examples above. String concatenation
does not add them automatically, so `"John" + "Smith"` would be
`"JohnSmith"`.

##### Operands with boolean Results
There are several other operands that produce 
[boolean](#java-data-types) values. These are mostly used
in conjunction with [if-else] statements (syntax level 8),
so they are explained in that section.

###### [Java Language Help](#top) > [Expressions]


### Function Return Values
Functions that are defined to have a *Return Value* will produce
a "result" value, which can then be used by the calling code. 
The call to the function acts like a value that can be used anywhere
a value or an [expression](#expressions) is expected.

#### Examples
```
// Roll a 6-sided die 
int roll = ct.random( 1, 6 );
ct.log( roll );
```
```
// Ask the user to enter their name
String name = ct.inputString( "Enter your name" );
ct.log( name );
```
```
// Round a number to two decimal places
double amount = 24.947823;
double result = ct.roundDecimal( amount, 2 );
ct.log( amount, result );
```
```
// Make a circle at a random location
ct.circle( ct.random( 0, 100 ), ct.random( 0, 100 ), 10 );
```
```
// Compute sin(a) + cos(a)
double a = 1.2;
ct.log( Math.sin( a ) + Math.cos( a ) );
```
#### Notes
Some functions that you can call with a [function call](#function-calls)
are designed to calculate or produce a resulting value that they can give 
("return") to the calling code. Not all functions return a value.
You can look up the description of a function in the 
[Code12 Function Reference](API.html) to see if it has a *Return Value*.

For example, the function [ct.random()](API.html#ct.random) calculates
a random integer within the range of the two numbers given in its parameters. 
For example:
```
int roll = ct.random( 1, 6 );
```
This code calls the `ct.random()` function and then captures and stores 
the return value in the variable `roll`. The code `ct.random( 1, 6 )` then
acts like the resulting value to the rest of the code. Note that the
rest of the code takes the same form as:
```
int roll = 3;
```
so here the value being assigned to the variable (`3`) can be replaced with 
the function call `ct.random( 1, 6 )`, which calculates a value to use.

##### Function Calls in Expressions
You can also use function calls in an [expression](#expressions), anywhere
a value of the function's return value type can be used. For example:
```
// Roll two dice and get the total
int totalRoll = ct.random( 1, 6 ) + ct.random( 1, 6 );
```
Here the `ct.random()` function is called twice (calculating a potentially
different result each time), and the values are "returned" to the calling code,
which otherwise takes the same form as:
```
// Pretend to roll two dice and get the total
int totalRoll = 3 + 5;
```
Note carefully the placement of the semicolons in the above examples.
A function call itself does *not* have a semicolon after it, but
the entire statement it is used in (e.g. a variable initialization or
assignment) might need one at the very end.

##### Function Calls in Parameters
Since a function call can be used anywhere a value of the resulting
type can be used, you can also use them as parameters to other
function calls. For example:
```
// Draw a circle at a random location on the screen
ct.circle( ct.random( 0, 100 ), ct.random( 0, 100 ), 20 );
```
In this case, we have function calls "within" a function call, 
and the parentheses end up being nested. At first this may appear 
confusing, but just remember that you can think of a function call 
as being replaced by its return value, and also that logically the 
whole statement will be executed from the inside out (like a 
complex Math expression with parentheses would be). So the two
`ct.random()` function calls will happen first, then the outer
call to `ct.circle()` will happen, taking the same form as, for example:
```
ct.circle( 67, 32, 20 );
```
##### Java Math Functions 
In addition to the functions that Code12 provides (which start with
`ct.`), Java provides several functions to do standard Math calculations 
that start with `Math.` (note that the "M" is capitalized). See 
[Java Math Functions](API.html#java-math-functions). For example:
```
// Try the Pythagorean Theorem
double a = 3;
double b = 4;
double c = Math.sqrt( Math.pow( a, 2 ) + Math.pow( b, 2 ) );
ct.log( a, b, c );
```
###### [Java Language Help](#top) > [Function Return Values]


### Object Data Fields
The [Graphics Object Creation](API.html#graphics-object-creation)
functions in Code12 [return a value](#function-return-values) 
of type [GameObj](#java-data-types), which allows you to manipulate 
the graphics object created. First you must capture the return 
value of the function in a variable of type `GameObj`, such as:
```
GameObj dot = ct.circle( 50, 30, 20 );
```
A variable of type [GameObj](#java-data-types) acts like a container
that has several sub-variables inside of it, which all apply to that 
graphics object. These sub-variables are called *data fields*.
Some of these data fields can be accessed directly using a dot (.) 
after the `GameObj` variable name followed by the name of the sub-variable. 
For example, `hero.x` is the x-coordinate of a `GameObj` variable named `hero`.

#### Examples
```
GameObj dot = ct.circle( 50, 50, 20 );   // start in the center
dot.x = 100;             // move to right edge of screen
```
```
GameObj square = ct.rect( 7, 7, 10, 10 );
double y = ct.inputNumber( "Enter y-coordinate to move square to" );
square.y = y;
```
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
}
```
```
GameObj greenDot = ct.circle( 30, 50, 20, "green" );
GameObj redDot = ct.circle( 70, 50, 20, "red" );
redDot.visible = false;
```
```
GameObj penny = ct.circle( 30, 10, 6, "orange" );
penny.group = "coins";

GameObj dime = ct.circle( 50, 10, 6, "light gray" );
dime.group = "coins";

GameObj bill = ct.rect( 75, 10, 20, 10, "dark green" );
bill.group = "bills";

ct.showAlert( "Click OK to delete the coins" );
ct.clearGroup( "coins" );
```
#### Notes
The Java data types [int](#java-data-types), [double](#java-data-types),
and [boolean](#java-data-types) are called "primitive" data types,
because they only take a single number to store (the boolean 
values `true` and `false` are represented by the numbers 1 and 0
internally). The [GameObj](#java-data-types) type, however, is a 
complex data type that requires several numbers internally to store.
This is an example of an "Object" data type in Java.

Each `GameObj` variable contains several data fields inside it.
These fields store the object's current position, size, speed,
color, and more. Because you can have many `GameObj` objects in your 
program, each one has its own memory locations for each of these
fields, so, for example, `hero.x` may be 32 while `enemy.x` 
might be 75.

##### Getting and Setting Data Fields
An object data field allows you to either "get" its current value,
as in:
```
GameObj dot = ct.circle( 50, 30, 20 );   // circle at (50, 30)
double xPosition = dot.x;       // sets xPosition to 50
```
or you can also "set" (change) a field value, as is:
```
GameObj dot = ct.circle( 50, 50, 20 );   // start in the center
dot.x = 100;             // move to right edge of screen
```
In this statement:
```
dot.x = dot.x + 1;
```
The code first "gets" the current value of the `x` field of `dot`
then changes ("sets") it to be 1 greater. 

##### GameObj Public Data Fields
Only some of the data fields inside a `GameObj` can be accessed
directly. Java refers to these as "public data fields". These are:
```
Field       Type        Use
-------     -------     -------------------------
x           double      The object's x-coordinate
y           double      The object's y-coordinate
visible     boolean     false to hide the object
group       String      optional group name
```
For more information, see [GameObj Data Fields](API.html#gameobj-data-fields).

###### [Java Language Help](#top) > [Object Data Fields]


### Object Method Calls
Code12 has several special functions that are designed 
for use on graphics objects. When a Java function is designed to
operate on a specific object (instead of your application as a whole), 
it is often provided as an "*object method*", which uses a slightly
different syntax than a normal function call.

#### Example
```
GameObj ball = ct.circle( 50, 50, 20 );
ball.setFillColor( "blue" );
```
The call to `ball.setFillColor()` above is an object method call.
Unlike [function calls](#function-calls) that apply to your application 
as a whole (which start with `ct.` in Code12), object methods 
for graphics objects are called by specifying a variable of type
[GameObj](#java-data-types) (here `ball`) to the left of the dot (.) 
instead of `ct`. The `GameObj` variable refers to the particular 
graphics object in your program that you want to operate on.

The function [ct.circle()](API.html#ct.circle) creates a new circle
object and also [returns a value](#function-return-values) 
of type `GameObj` so that you can make a variable such as `ball`
that will refer to the object that was created and then call object
methods on it afterwards.

#### More Examples
```
GameObj top = ct.circle( 50, 35, 10 );
GameObj middle = ct.circle( 50, 50, 10 );
GameObj bottom = ct.circle( 50, 65, 10 );

top.setFillColor( "red" );
middle.setFillColor( "yellow" );
bottom.setFillColor( "green" );
```
```
GameObj block = ct.rect( 10, 10, 10, 10 );
block.setSize( 20, 5 );
block.setSpeed( 0.5, 0.25 );
block.setFillColorRGB( 200, 100, 50 );
block.setLineColor( "gray" );
block.setLineWidth( 3 );
```
```
GameObj text = ct.text( "This will be underlined", 50, 30, 8 );
double width = text.getWidth();
double height = text.getHeight();
double yBottom = text.y + height / 2;
GameObj underline = ct.line( text.x - width / 2, yBottom,
                             text.x + width / 2, yBottom );
underline.setLineWidth( 2 );
```
```
String str = "Code12";
int numChars = str.length();
String strLower = str.toLowerCase();
ct.println( strLower.substring( 0, numChars - 2 ) );
```
#### Notes
You can think of a [GameObj](#java-data-types) as a container
for several sub-variables ("data fields"), all of which apply
to a specific graphics object on the screen. You can also think
of a variable of type `GameObj` as a reference to (like a name for) 
the graphics object itself.

In addition to the [GameObj public data fields](API.html#gameobj-data-fields),
each `GameObj` also internally has data fields that are used to 
store the object's size, speed, colors, and more. These fields are
not accessible directly, but the 
[GameObj method functions](API.html#gameobj-methods) can
be used to access or change these properties of the object.
There are also some method functions that perform special actions
or tests on the object.

Calling a `GameObj` method function applies only to the particular 
`GameObj` that the method is called on, not any other `GameObj`
objects in your program. 

##### Getting and Setting Properties of an Object
Some method functions modify the object that they are called on,
for example:
```
GameObj ball = ct.circle( 50, 50, 20 );
ball.setFillColor( "blue" );
```
This is often called "setting a property" of an object.

Other method functions are designed to just return information 
about the object, for example:
```
GameObj message = ct.text( "Hello There", 50, 50, 10 );
double width = message.getWidth();
```
This is often called "getting a property" of an object.
Method functions that "get" properties will always have
a [return value](#function-return-values).

##### Methods vs. Functions
A call to an object method function has a variable name before 
the dot instead of `ct`. For example:
```
GameObj ball = ct.circle( 50, 50, 20 );

ct.setBackColor( "yellow" );    // normal function call
ball.setFillColor( "blue" );    // method function call
```
> Strictly speaking, all function calls in Java are actually 
> considered method calls in Object-Oriented terminology.
> The "ct" in a Code12 function call is actually a variable 
> that is provided to you by the system that refers to your 
> program as a whole. So a call such as `ct.setBackColor()`
> is really a call to the `setBackColor()` method on the 
> `ct` object.

So, calling a method function on a `GameObj` requires that you have
a variable of type `GameObj` in your program to refer to the object
with. In the following code:
```
ct.circle( 30, 50, 20 );
GameObj block = ct.rect( 70, 50, 20, 30 );

block.setSpeed( 0, 1 );
```
the circle is created and drawn on the screen, but the 
[return value](#function-return-values) of `ct.circle()`
is ignored and not assigned to a variable. This means
there is no way to call a method function on it. 
The rectangle, however, is assigned to the variable
`block`, which can then be used to call method functions.

##### GameObj and String Methods
A Code12 program can call method functions on two different 
types of data objects: [GameObj](#java-data-types) and 
[String](#java-data-types). See the 
[GameObj method functions](API.html#gameobj-methods) for
the method functions supported for `GameObj` objects.

Variables of type [String](#java-data-types) are technically 
also "objects" in Java, and there are various method functions 
designed to operate on strings.
See [Java String Methods](API.html#java-string-methods) 
for the methods supported by Code12.

> All of the Java String methods either return information about
> the string or create and return a new String. It is not possible 
> to modify a String in Java.

Note that `GameObj` methods can only be called on a variable
of type `GameObj`, and `String` methods must be called on a
variable of type `String`.

The Java data types [int](#java-data-types), [double](#java-data-types),
and [boolean](#java-data-types) are "primitive types" and do
not support method calls.

###### [Java Language Help](#top) > [Object Method Calls]


### If-else

###### [Java Language Help](#top) > [If-else]


### Function Definitions

###### [Java Language Help](#top) > [Function Definitions]


### Parameters

###### [Java Language Help](#top) > [Parameters]


### Loops

###### [Java Language Help](#top) > [Loops]


### Arrays

###### [Java Language Help](#top) > [Arrays]



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

###### [Java Language Help](#top) > [Java Data Types]


<footer>
	Code12 Version 1.0

	(c)Copyright 2018 Code12 and David C. Parker. All Rights Reserved. 
</footer> 

