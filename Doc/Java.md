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

The most common parameter values are numbers and text (although
there are other types as well). Text values are called "strings" 
and are enclosed in `"double quotes"` when you are specifying 
the text directly.

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
String dotColor = "yellow";

ct.circle( xPosition, yPosition, size, dotColor );

xPosition = 70;

ct.rect( xPosition, yPosition, size, size, dotColor );
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
is added, so the result is 13, not 30.

If you want to override the normal order of operations,
you can use parentheses in your expression, such as:
```
int newResult = (3 + 2) * 5;    // result gets 30
```
> It is easy to make a mistake with assumptions about
> the order of operations. Good programmers are 
> generous with their use of parentheses to reduce
> mistakes and to make their code easier to understand. 

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
in conjunction with [if-else] statements (syntax level 8)
so they are explained in that section.

###### [Java Language Help](#top) > [Expressions]


### Function Return Values

###### [Java Language Help](#top) > [Function Return Values]


### Object Data Fields

###### [Java Language Help](#top) > [Object Data Fields]


### Object Method Calls

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

