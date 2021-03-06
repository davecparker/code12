% Java Language Help

<div class="rightLink">
[Code12 Function Reference](API.html)
</div>

<div class="summary">
<div class="summaryColumn">

##### Java Syntax Examples
1. [Function Calls]
2. [Comments]
3. [Variables]
4. [Expressions]
5. [Function Return Values]
6. [If-else]
7. [Object Data Fields]
8. [Object Method Calls]
9. [Function Definitions]
10. [Function Parameters]
11. [Loops]
12. [Arrays]

</div>
<div class="summaryColumn">

##### Java Language Elements
* [Java Data Types]
* [Java Operators]

##### Differences between Code12 and Java
* [Main Program Structure]
* [Unsupported Java Language Features]
* [Indentation and Brace Placement]

</div>
</div>

###### Code12 Version 2.0


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

##### Constant (final) Variables
If the keyword `final` is used before a variable declaration,
then the variable becomes a "constant", meaning the value cannot
change. The variable must be initialized at the point of declaration 
and cannot be reassigned later. 

A common convention for constant variable names is to use all
capital letters with underscores between words. For example:
```
class MyProgram
{
	final double DOT_SIZE = 20;

	public void start()
	{		
		ct.circle( 30, 50, DOT_SIZE );
		ct.circle( 70, 50, DOT_SIZE );
	}
}
```
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


### If-else
The if-else structure allows you to specify that another statement 
(such as a [function call](#function-calls) or [variable assignment](#variables)), 
or a group of statements, should only happen if some condition
is true. You can also specify what should happen if the condition 
is false.

#### Examples
```
int age = ct.inputInt( "Enter your age" );

if (age > 17)
	ct.println( "You are an adult." );
else
	ct.println( "You are a child." );	
```
The code above asks the user to input an age and then
prints one of two messages depending on the value of `age`.
Only one of the two messages will be printed.

You can also leave off the `else` part if you want. For example:
```
int age = ct.inputInt( "Enter your age" );

if (age < 0)
	ct.println( "That is not a valid age." );
```
Statements that are controlled by an if-else, in either the `if` 
section or the `else` section (if included), should be indented 
to indicate that they only happen if the controlling test above 
them passes.

If more than one statement is controlled in either the `if` or
`else` sections, then the controlled statements must be enclosed
in curly brackets `{` and `}` as follows:
```
int age = ct.inputInt( "Enter your age" );

if (age > 15)
{
	ct.println( "You can apply for a driver's license." );
	ct.println( "If you already have one, you can drive." );
}
else
{
	ct.println( "You are too young to drive by yourself." );
	ct.println( "Get a ride or take your bike." );
}
ct.println( "Be careful!" );    // this always prints
```
Note that the last `ct.println()` in the example above is past the
if-else structure, so it executes afterwards no matter what.

> Although Java is fairly flexible about how if-else structures
> can be formatted in your code, Code12 requires that they be
> formatted as above (split over multiple lines and indented
> as shown), which helps identify mistakes in your code.

#### Notes
The condition for an if-else statement is tested "on the spot" 
right when the `if` statment is encountered in your code.
An if-else is *not* a general rule that says "whenever this is
true, do this". Instead, it says "If this is true right now, then
do this right now". After the condition is tested and the 
controlled statement(s) are executed (if any), execution continues
with the next statement after the entire if-else structure.

##### Comparison Tests
Immediately after the keyword `if`, there should be a condition
in parentheses. There are several types of conditions you can
test for, including these examples which compare two numbers:
```
Condition  Meaning
---------  ---------------------------------
(a > b)    Greater than
(a < b)    Less than
(a >= b)   Greater than or equal to
(a <= b)   Less than or equal to
(a == b)   Equal to (note: two equal signs!)
(a != b)   Not equal to
```
Note that each condition results in a `true` or `false` result
(either the test is true or not (false)). 

##### Testing a boolean Variable
A variable of type [boolean](#java-data-types) gives a `true` or `false` 
result by itself (without comparing it to anything), so you can also 
use a single `boolean` variable in a condition. For example:
```
boolean makeCircle = ct.inputYesNo( "Would you like to make a circle?" );

if (makeCircle)
	ct.circle( 50, 50, 20 );
ct.println( "Done" );
```
> Note that Java requires the condition to be in parentheses, 
> even if it is just a single variable name.

##### Testing Compound Conditions 
The condition for an if-else can also test for two different things
that must both be true for the test to succeed. This is done using `&&`, 
which means "and" in Java. For example:
```
double inches = ct.inputNumber( "Enter your height in inches" );
double pounds = ct.inputNumber( "Enter your weight in pounds" );

if (inches > 72 && pounds < 170)
	ct.println( "You are tall and thin" );
```

You can also test for two different things where only one of them
needs to be true. This is done using `||`, which means "or" in Java.
For example:
```
int n = ct.inputInt( "Enter a number from 1 to 10" );

if (n < 1 || n > 10)
	ct.println( "That number is out of range" );
```
##### Boolean Expressions
In all of the examples above, the condition for the if-else has to
be something that results in a `true` or `false` condition.
In fact, the way Java handles this is that the condition can be any
*boolean expression*. A boolean expression is like an expression
involving numbers (see [Expressions]), except that the end result 
needs to be `true` or `false` instead of a number.

Symbols such as `<`, `>=`, `==`, `&&`, and `||` are considered 
*operands* in Java, because they appear between two values and 
combine them to produce a resulting value. In these cases, the
resulting value is of type [boolean](#java-data-types), unlike for
the operands used in numeric expressions such as `+`, `-`, `*`, 
and `/`, which produce numeric results.

Like the numeric operators, however, the boolean operators can
be built up into more complex expressions, and also grouped using
parentheses. For example:
```
double inches = ct.inputNumber( "Enter your height in inches" );
double pounds = ct.inputNumber( "Enter your weight in pounds" );

// If the user is tall and thin, or short and fat, then we won't
// have any cloths in stock that fit them.

if ((inches > 72 && pounds < 170) || (inches < 48 && pounds > 200))
	ct.println( "Sorry, we don't have any cloths that fit you." );
```
##### Boolean Functions
An if-else condition (or part of a boolean expression) can also include 
using any [function return value](#function-return-values) for a
[function call](#function-calls) or [object method call](#object-method-calls)
that has a [boolean](#java-data-types) return value. For example:
```
if (ct.inputYesNo( "Would you like to play again?" ))
	ct.restart();
``` 
##### Nested if-else Structures
You can put whatever code you want in the `if` and `else` branches
of an if-else structure, including other if-else structures. 
For example:
```
int age = ct.inputInt( "Enter your age" );

if (age < 18)
{
	ct.println( "You are a child." );

	if (ct.inputYesNo( "Is your parent with you?" ) )
		ct.println( "You two must sit together" );
	else
	{
		ct.println( "Sorry you can't go on this ride." );
		ct.println( "Try the train ride." );
	}
}
else
{
	ct.println( "You are an adult." );
	ct.println( "Enjoy the ride!" );
}
```
In this case, the question `"Is your parent with you?"` is only asked
if the first `if` succeeds, and then the result `"You two must sit together"`
only happens if both `if` tests succeed. 

Note that the indentation level of the code increases each time you enter 
another level of if-else, and if curly brackets are needed to group the 
controlled statements then they are also indented accordingly.

There is no limit to the number of levels you can "nest" if-else structures
or the complexity of the tests, other than your ability as a programmer to
keep all the cases straight!

> Humans are notoriously weak in their ability to decode multiple levels
> of logic conditions, and computers are brutally literal in their 
> execution of them (doing exactly what you said, perhaps not what you meant), 
> often resulting in bugs. Organizing logic in a way that is not overly
> complex to understand is a skill that programmers build over time.

##### Testing Multiple Conditions with "else if"
Sometimes you may have multiple variations on a condition that need to
be tested. For example, the following code identifies three different
age ranges (child, adult, or senior):
```
int age = ct.inputInt( "Enter your age" );

if (age < 18)
	ct.println( "child" );	
if (age >= 18 && age < 65)
	ct.println( "adult" );
if (age >= 65)
	ct.println( "senior" );
```
The above conditions could be made simpler and more efficient by using
`else` sections and also nested if-else structures as follows:
```
int age = ct.inputInt( "Enter your age" );

if (age < 18)
	ct.println( "child" );
else
{
	if (age < 65)
		ct.println( "adult" );
	else
		ct.println( "senior" );
}
```
Note how much simpler the `if` conditions are. Also, the first example
always tests all three `if` conditions regardless of the age, but the
second one often skips one or more of them. Patterns such as the above
are common and can be written more compactly using `else if`, as follows:
```
int age = ct.inputInt( "Enter your age" );

if (age < 18)
	ct.println( "child" );
else if (age < 65)
	ct.println( "adult" );
else
	ct.println( "senior" );
```
You can have as many `else if` sections as you want. When structured this
way, the various `if` tests are executed sequentially until one of them
tests `true`, then all the remaining ones are skipped. It is important to
write the various conditions and the order of the tests in a way that 
produces the result you want in all cases.

##### Comparing Strings

It is possible to use an `if` condition to test the value of a
[String](#java-data-types) value (for example, to see if two names 
are the same). However, you cannot just use the `==` or `!=`
comparison operators like you can for numbers. To compare `String`
values, you need to call method functions on the `String` object,
which requires the [Object Method Calls] syntax described in
a later section.  

###### [Java Language Help](#top) > [If-else]


### Object Data Fields
The [Graphics Object Creation](API.html#graphics-object-creation)
functions in Code12 [return a value](#function-return-values) 
of type [GameObj](#java-data-types), which allows you to manipulate 
the graphics object created. First you must capture the return 
value of the function in a variable of type `GameObj`, such as:
```
GameObj ball = ct.circle( 50, 30, 20 );
```
A variable of type [GameObj](#java-data-types) acts like a name for a
container that has several sub-variables inside of it, which all apply to 
that particular graphics object. These sub-variables are called *data fields*.
Some of these data fields can be accessed directly using a dot (.) 
after the `GameObj` variable name followed by the name of the sub-variable. 
For example, `ball.x` is the x-coordinate of a `GameObj` variable named `ball`.

#### Example
```
class MoveBall
{
	public void start()
	{
		GameObj ball = ct.circle( 20, 15, 10 );
		ct.log( ball.x, ball.y );

		double xNew = ct.inputNumber( "Enter new x-coordinate to move the ball to" );
		ball.x = xNew;
		ct.log( ball.x, ball.y );
	}
}
```
Note that the syntax `ball.x` acts like a variable. Its current value can
be retrieved, or it can also be assigned (set) to a different value, which will
move the ball on the screen.

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

##### GameObj Public Data Fields
Only some of the data fields inside a `GameObj` can be accessed
directly. Java refers to these as "public data fields". These are:
```
Field       Type        Use
-------     -------     -------------------------
x           double      The object's x-coordinate
y           double      The object's y-coordinate
visible     boolean     Set to false to hide the object
group       String      Optional group name
```
For more information, see [GameObj Data Fields](API.html#gameobj-data-fields).

##### Getting and Setting Data Fields
An object data field allows you to either "get" its current value,
as in:
```
GameObj ball = ct.circle( 50, 30, 20 );   // circle at (50, 30)
ct.log( ball.x );                         // 50
```
or you can also "set" (change) a field value, as is:
```
GameObj ball = ct.circle( 50, 50, 20 );   // start in the center
ball.x = 100;             // move to right edge of screen
```
In this statement:
```
ball.x = ball.x + 1;
```
As with regular variables, the code first "gets" the current value 
of the `x` field of `ball` then changes ("sets") it to be 1 greater. 

##### Animation Using update()
The optional [update()](API.html#main-program-functions) code block in your 
program executes repeatedly, before every animation frame (60 times per second). 
By putting code in `update()`, you can make objects move smoothly on the screen 
by changing their `x` and `y` data fields before each animation frame. 
For example:

```
class MovingBall
{
	// Need a ball variable that both start() and update() can access
	GameObj ball;

	public void start()
	{
		// Create the ball
		ball = ct.circle( 0, 50, 10 );	
	}

	public void update()
	{
		// Move the ball a little to the right each animation frame
		ball.x = ball.x + 1;

		// If the ball goes off the right edge of the screen, 
		// then restart it at the left edge
		if (ball.x > 100)
			ball.x = 0;
	}
}
```
```
class MoveDiagonal
{
	// Need a block variable that both start() and update() can access
	GameObj block;

	public void start()
	{
		// Create the block
		block = ct.rect( 0, 20, 10, 10 );	
	}

	public void update()
	{
		// Move the block slowly diagonally
		block.x += 0.5;
		block.y += 0.2;
	}
}
```

###### [Java Language Help](#top) > [Object Data Fields]


### Object Method Calls
In addition to being able to access some [Object Data Fields] of
graphics objects, Code12 has several special functions that are designed 
for use on graphics objects. When a Java function is designed to
operate on a specific object (instead of your application as a whole), 
it is often provided as an "*object method*", which uses a slightly
different syntax than a normal function call.

See [GameObj Methods](API.html#gameobj-methods) for a list 
of the various object method functions available for a `GameObj`. 

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
block.setXSpeed( 0.5 );
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

block.setYSpeed( 1 );
```
the circle is created and drawn on the screen, but the 
[return value](#function-return-values) of `ct.circle()`
is ignored and not assigned to a variable. This means
there is no way to call a method function on it. 
The rectangle, however, is assigned to the variable
`block`, which can then be used to call method functions.

##### Using Object Methods in Animation and Games
By using [GameObj Methods](API.html#gameobj-methods) in the
`start()` and `update()` blocks in your program
(see [Main Program Functions](API.html#main-program-functions)), 
you can achieve a variety of interesting things including 
making games. For example, this program challeges you to click 
on a moving dot:
```
class ClickTheDot
{
	GameObj dot;

	public void start()
	{
		// Make a small red dot and make it move to the right
		dot = ct.circle( 0, 50, 5 );
		dot.setXSpeed( 1 );
		ct.println( "Try to click the dot" );
	}

	public void update()
	{
		// Did they click on the dot?
		if (dot.clicked())
			ct.showAlert( "You got it!" );
	}
}
```
Note that although an [if-else] only tests its condition and executes
its controlled statement(s) when it is encountered in your program,
the way the `update()` code block works in a Code12 program makes it
easy to test conditions repeatedly. Code in your `update()` block is
executed before each new animation frame, and animation frames happen 
60 times per second, so this means that the entire sequence of statements 
in your `update()` block is repeated 60 times per second, which is very 
often compared to human perception. This means that the 
`if (dot.clicked())` above may appear to be tested "continuously". 
In fact, it is not tested continuously, just repeatedly and quickly.

#### String Methods
Variables of type [String](#java-data-types) are also considered 
"objects" in Java (not primitive types like `int`, `double`, and 
`boolean`), and there are various method functions designed to operate 
on strings. For example:
```
String name = ct.inputString( "Enter your name" );
int numChars = name.length();
ct.println( "Your name has " + numChars + " characters in it." );
```
Here the method function is called `length()`, which counts the 
number of characters in a string, so it must be called on a `String` 
variable. The string variable to measure appears before the method 
function, separated with a dot, as `name.length()` above, similar to 
the syntax used for `GameObj` method functions.  

See [Java String Methods](API.html#java-string-methods) 
for the String methods supported by Code12.
String methods must be called on a `String`, whereas GameObj methods 
must be called on a `GameObj`.

All of the Java String methods either return information about
the string or create and return a new String. It is not possible 
to modify a String in Java. For example:
```
String name = ct.inputString( "Enter your name" );
String nameLower = name.toLowerCase();    // makes a new string
ct.log( name, nameLower );     // original name is not modified
```
```
String name = ct.inputString( "Enter your name" );
String sub = name.substring( 0, name.length() - 2 ); 
ct.log( name, sub );
```
##### Comparing Strings
Since strings are considered objects in Java, you cannot test to 
see if two strings have the same text by using the `==` or `!=`
operators. Instead you must use the `str.equals()` method function. 
For example:
```
String firstName = ct.inputString( "Enter your first name" );

if (firstName.equals( "Dave" ))
	ct.showAlert( "Hey, my name is Dave too!" );

String lastName = ct.inputString( "Enter your last name" );

if (lastName.equals( firstName ))
	ct.showAlert( "That's weird, your first and last name are the same!" );
```

#### Object References
The [GameObj](#java-data-types) and [String](#java-data-types) types in 
Java are examples of *Object* types, as opposed to the *primitive* types 
`int`, `double`, and `boolean`. Whereas a primitive type only stores a 
single value (e.g. a single number), an Object can be made up of many 
values (accessible via [Object Data Fields] and [Object Method Calls]).

In Java, a variable of type [GameObj](#java-data-types) or [String](#java-data-types)
is technically a *reference* to the underlying object, not the object itself.
You can think of a reference as an arrow pointing to the object that it
is referring to. Just like you can draw more than one arrow pointing at 
the same object, you can create more than one reference to an object.

> Physically, a reference to an object is the *memory address* where
> the underlying object is stored in memory, which is just a number.
> Two memory addresses that are equal then refer to the same object.

This distinction between an actual object (for example, a circle on the
screen) and a reference to the object (for example, a GameObj variable) 
matters when you assign and compare object variables. 
When you assign an object variable to an existing object, such as:
```
GameObj dot = ct.circle( 50, 50, 20 );
GameObj ball = dot;
```
The assignment of `ball` to `dot` makes another reference to the same circle
object. It does not make a copy of the object or create another circle.
Now both variables refer to the same object, and either one can be used 
to access or modify it:
```
GameObj dot = ct.circle( 50, 50, 20 );   // dot starts at x = 50
GameObj ball = dot;                      // ball now also refers to dot

dot.x = 70;                 // moves the dot to x = 70
ct.println( ball.x );       // prints 70 because ball is the same as dot
```
In addition, a comparison such as `if (ball == dot)` can be used to see if
two variables refer to the same object: 
```
GameObj dot = ct.circle( 50, 50, 20 );
GameObj ball = dot;                      // ball now also refers to dot

ct.println( dot == ball );   // prints true because they are the same object
``` 
An example of how this is used in practice would be using the Code12 function
[ct.objectClicked()](API.html#ct.objectclicked). This function has a return
value of type `GameObj`, which means that it returns a reference to the 
object that got clicked. For example:
```
class Example
{
	GameObj ball1, ball2, ball3;

	public void start()
	{
		// Make 3 balls
		ball1 = ct.circle( 30, 50, 10 );    // left
		ball2 = ct.circle( 50, 50, 10 );    // middle
		ball3 = ct.circle( 70, 50, 10 );    // right
	}

	public void update()
	{
		// See if the middle ball was clicked
		GameObj target = ct.objectClicked();
		if ( target == ball2 )
			ct.println( "You clicked the middle ball" );
	}
}
```
Here the statement `GameObj target = ct.objectClicked();` sets `target`
to another reference to whichever ball got clicked (note that each circle 
already has a variable referencing it). It does not make a copy of that 
ball or a new ball. Then the test `if ( target == ball2 )` can be used 
to see if the clicked object (`target`) refers to the same object
as `ball2`, which is the middle ball. 

##### A null Object Reference
It is also possible that none of the three balls in the example above 
got clicked, in which case the `ct.objectClicked()` function returns the 
special value `null`, which means "no object". The value `null` is pre-defined
by Java for this purpose. You can compare an object reference to `null` to 
see if it references an actual object:
```
class Example
{
	GameObj ball1, ball2, ball3;

	public void start()
	{
		// Make 3 balls
		ball1 = ct.circle( 30, 50, 10 );    // left
		ball2 = ct.circle( 50, 50, 10 );    // middle
		ball3 = ct.circle( 70, 50, 10 );    // right
	}

	public void update()
	{
		// See if any object was clicked
		GameObj target = ct.objectClicked();
		if ( target != null )
			ct.println( "You clicked on an object" );
	}
}
```
You can also assign an object variable to `null` if you want
to indicate that the variable doesn't reference an object yet,
or no longer references an object. In this case, note that if you 
try to use a field or method of the null variable, then you will 
generate an error. For example:
```
class Example
{
	GameObj ball1, ball2, ball3;
	GameObj selectedBall = null;   // no selection initially

	public void start()
	{
		// Make 3 balls
		ball1 = ct.circle( 30, 50, 10 );    // left
		ball2 = ct.circle( 50, 50, 10 );    // middle
		ball3 = ct.circle( 70, 50, 10 );    // right

		// Select the first ball
		selectedBall = ball1;

		// Print the x-coordinate of the selected ball
		ct.println( selectedBall.x );    // prints 30

		// Delete the selected ball then clear the selection
		selectedBall.delete();
		selectedBall = null;

		// Now is there a ball selected?
		if (selectedBall == null)
			ct.println( "No ball is selected now" );

		// This would produce an error if we tried it now
		// ct.println( selectedBall.x );
	}
}
```

###### [Java Language Help](#top) > [Object Method Calls]


### Function Definitions
A function definition is a block of code with a name that you can reuse
without having to copy and paste the code each time. The main program
blocks `start()` and `update()` in your program are actually function 
definitions, and these functions are called (told to execute) at the 
appropriate time by the Code12 system. You can also define your own 
functions and execute them whenever you want using the 
[function call](#function-calls) syntax.

#### Example
```
class Example
{
	public void start()
	{
		// Make 4 targets at random locations
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
	}

	// Below is the function definition for makeRandomTarget(),
	// which creates one target at a random (x, y) location.

	void makeRandomTarget()
	{
		int x = ct.random( 0, 100 );
		int y = ct.random( 0, 100 );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );
	}
}
```
The code starting with `void makeRandomTarget()` is a 
*function definition* for a function named "makeRandomTarget".
The code for the function definition is enclosed in 
curly brackets `{` and `}` and can have as many lines of code
as you want.

The 4 lines in `start()` that say `makeRandomTarget();` are *calls*
to the function named "makeRandomTarget()". This is just like
the syntax for a [function call](#function-calls) that you already
know, except in this case the definition of the function
(the code that executes when the function is called) is written
in your code instead of being defined by the Code12 system.

#### Notes
Defining your own functions is a very powerful tool, and it is the 
basis for how complex software programs can be written in a reasonable 
amount of time, and how programmers can share work and build upon
each other's work.

In the example above, note that all the code to make a target
(here 5 lines of code), only appears once in the program, 
although it is used and executed 4 times.
Each call to a function causes the program to go execute the
lines of code in the function definition, then return 
back to where the call occured and continue with the next line 
after the call. 

Without using a function definition, the program could have been
written like this:
```
class Example
{
	public void start()
	{
		// Make a target at a random location
		int x = ct.random( 0, 100 );
		int y = ct.random( 0, 100 );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );

		// Make another target at a random location
		x = ct.random( 0, 100 );
		y = ct.random( 0, 100 );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );

		// Make yet another target at a random location
		x = ct.random( 0, 100 );
		y = ct.random( 0, 100 );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );

		// And another
		x = ct.random( 0, 100 );
		y = ct.random( 0, 100 );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );
	}
}
```
which works, but is longer and creates a maintenance program for the
programmer, because any future change or fix to the target drawing code 
(e.g. make a target have 5 rings instead of 3) would need to be done in 
4 different places. As programs become more complex, this problem
would become critical and the code would become unmaintainable in 
practice.

Instead, here is the program again using a function definition,
and the function has been updated to draw 5 rings instead of 3:
```
class Example
{
	public void start()
	{
		// Make 4 targets at random locations
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
	}

	// Below is the function definition for makeRandomTarget(),
	// which creates one target at a random (x, y) location.

	void makeRandomTarget()
	{
		int x = ct.random( 0, 100 );
		int y = ct.random( 0, 100 );
		ct.circle( x, y, 25, "red" );
		ct.circle( x, y, 20, "white" );
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );
	}
}
```
Note that the code in `start()` required no modification at all.
For large programs, involving many systems and sub-systems,
this technique is the only way programmers could survive the need
to make constant changes, fixes, and improvements to programs,
which is the nature of software and technology.

##### Semicolons and Indentation
A function definition has a header line, such as:
```
void makeRandomTarget()
```
and then a block of code enclosed in curly brackets, such as:
```
{
	int x = ct.random( 0, 100 );
	int y = ct.random( 0, 100 );
	ct.circle( x, y, 15, "red" );
	ct.circle( x, y, 10, "white" );
	ct.circle( x, y, 5, "red" );
}
```
Note that the header line does *not* have a semicolon after it
(but the calls to the function do).

The header line should be indented at the same level as the header
lines for `start()` and `update()` in your program, and also like 
`start()` and `update()`, the code inside the curly brackets should 
be indented as shown in the examples above.

##### Public or not?
The header lines for `start()` and `update()` start with the 
keyword `public`, but you don't need this keyword for your own
function definitions. The `public` keyword is required by Java 
when the function being defined will be called from code that 
is outside the `class` block containing the function. 

If a function definition and all calls to the function are enclosed
inside the same `class` block, then you don't need to use `public`.
In the full example above, the definition of `makeRandomTarget()`
and all 4 calls to it are all enclosed within `class Example`.

In the case of `start()` and `update()`, the function definitions 
are inside `class Example`, but the calls to these functions are 
technically inside the Code12 system (where you can't see them), 
in a separate class that you didn't write.

> The complete rules concerning `public` are more complicated than
> this, and Java also has other keywords such as `private` and
> `protected`, but these are not used by Code12.

##### Void and Functions that Return a Value
The keyword `void` in a function definition header is required for a
function that does *not* have a *return value*. You can define your
own functions that return values, however, similar to some of the 
Code12 functions that have [Function Return Values]\ (for example, 
[ct.inputNumber()](API.html#ct.inputnumber)).

Here is an example program that defines a function named `randomCoord()`
that computes a random coordinate value between 0 and 100 and then
returns this value from the function. The code in `start()` then
uses this function 4 times.
```
class Example
{
	public void start()
	{
		// Make 4 circles at random x locations
		ct.circle( randomCoord(), 50, 10 );
		ct.circle( randomCoord(), 50, 10 );
		ct.circle( randomCoord(), 50, 10 );
		ct.circle( randomCoord(), 50, 10 );
	}

	double randomCoord()
	{
		double r = ct.random( 0, 100 );
		return r;
	}
}
```
The job of `randomCoord()` here is to compute a value internally, and then
*return* this value from the function so that the calling code can use
it. This requires two new bits of syntax. First, instead of `void` in the 
function header, you put the *type* of the return value
(see [Java Data Types]), here `double`. Second, at the end of the function you
specify the *value* to return after the `return` keyword. In this case, whatever
value is in the variable `r` when the `return` is encountered will 
become the return value of the function that the calling code can use.

##### Functions Calling Other Functions
Note that in a function definition such as:
```
void makeRandomTarget()
{
	int x = ct.random( 0, 100 );
	int y = ct.random( 0, 100 );
	ct.circle( x, y, 15, "red" );
	ct.circle( x, y, 10, "white" );
	ct.circle( x, y, 5, "red" );
}
```
The code in the function body itself contains calls to other
functions (here `ct.random()` and `ct.circle()`). 
In addition to calling Code12 functions in a function body,
you also call other functions that you have defined yourself!

Consider this example that combines two of the earlier examples above:
```
class Example
{
	public void start()
	{
		// Make 4 targets at random locations
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
		makeRandomTarget();
	}

	void makeRandomTarget()
	{
		double x = randomCoord();
		double y = randomCoord();
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );
	}

	double randomCoord()
	{
		double r = ct.random( 0, 100 );
		return r;
	}
}
```
Can you follow the flow and order of the statements here?
How many times does the line of code:
```
double r = ct.random( 0, 100 );
``` 
in function `randomCoord()` end up being executed? *(Answer: 8)*.

Once you understand and start to master this technique,
you will come to understand how very complex programs 
can be written.

###### [Java Language Help](#top) > [Function Definitions]


### Function Parameters
Just like many [function calls] to [Code12 functions](API.html) 
require *parameters* to specify input values for the function,
you can [define your own functions](#function-definitions) 
that take parameters. This provides an easy way for the calling 
code to supply additional information needed by the function.

#### Examples
Here is a more useful version of the first example sample shown 
in [Function Definitions]:
```
class Example
{
	public void start()
	{
		// Make 4 targets at specified locations
		makeTarget( 30, 30 );
		makeTarget( 30, 70 );
		makeTarget( 70, 30 );
		makeTarget( 70, 70 );
	}

	// The function makeTarget() makes a target at the (x, y)
	// location specified by its parameters.

	void makeTarget(double x, double y)
	{
		ct.circle( x, y, 15, "red" );
		ct.circle( x, y, 10, "white" );
		ct.circle( x, y, 5, "red" );
	}
}
```
This is an example of defining a function that takes parameters
and also returns a value:
```
class Example
{
	public void start()
	{
		// Compute and print 4 averages
		ct.println( average( 10, 20 ) );
		ct.println( average( 3, 4 ) );
		ct.println( average( -5, 5 ) );
		ct.println( average( 1.432, 5.902 ) );
	}

	double average(double a, double b)
	{
		double ave = (a + b) / 2;
		return ave;
	}
}
```
#### Notes
When you define a function that requires one or more parameters, 
you need to *declare* (specify) the parameter(s) in the function 
definition header, such as:
```
void makeTarget(double x, double y)
```
Here the first parameter is declared as `double x`, which means that 
the value passed by the caller must be of type `double` (or `int`,
which can automatically convert to `double`), and that the code in 
the function body will refer to this value as the variable `x`.

The parameter variables that are declared in a function header
(`x` and `y` above) act like *local variables* (see [Variables]),
because they are only defined within the body of the function being
defined. A parameter variable comes into existance at the beginning 
of the function body, where it is initialized to the value passed 
in the function call, and ends at the end of the function body.
Because a parameter variable is local, it doesn't matter if it
shares the same name as a parameter in another function definition.
If two function definitions both have a parameter named `x`, these
are different variables and will not interfere with each other.

> To help avoid mistakes, Code12 will not allow you to declare a
> parameter with the same name as a class-level (non-local) variable,
> although Java normally allows this.

#### More Examples
When you define a function, it is up to you to design how you want it
to be called, including what parameters it will take and whether it has
a return value. Consider this example:
```
class Example
{
	public void start()
	{
		// Make 3 coins
		makeCoin( 20, 30, "orange" );
		makeCoin( 40, 30, "light gray" );
		makeCoin( 60, 30, "orange" );

		// Make one more coin and make it drop
		GameObj dime = makeCoin( 80, 30, "light gray" );
		dime.setYSpeed( 0.5 );
	}

	// Make and return a round coin at (x, y) with the given color.
	GameObj makeCoin( double x, double y, String color )
	{
		GameObj coin = ct.circle( x, y, 10, color );
		coin.setLineColor( "gray" );
		coin.setLineWidth( 2 );
		return coin;
	}
}
```
The program above defines a "helper function" to make creating coins
easier, because all coins need a certain line color and line width
(so these are set in the helper function `makeCoin()`), but the (x, y)
position and color varies, so these are passed as parameters.
In addition, function `makeCoin()` returns the `GameObj` for the coin
that was created so that the caller can capture this object and make
further changes to it if desired (to make the last coin drop).

The function header:
```
GameObj makeCoin( double x, double y, String color )
```
can be read as *"function `makeCoin()` takes 3 parameters: two values of type
`double` then a value of type `String`. The function returns a `GameObj`"*.
Furthermore, when reading the code that makes up the body of `makeCoin()`,
there are variables that store the 1st, 2nd, and 3rd parameter values passed 
named `x`, `y`, and `color`, respectively.

##### Functions Calling Other Functions
Remember that functions that you can define can also call other functions
that you define (or functions defined by Code12), which allows you
to create layers of capability. This powerful technique allows 
programmers to manage the complexity of large programs. For example,
consider this rewrite of the example above:
```
class Example
{
	public void start()
	{
		// Make 3 coins
		makePenny( 20, 30 );
		makeDime( 40, 30 );
		makePenny( 60, 30 );

		// Make one more dime and make it drop
		GameObj dime = makeDime( 80, 30 );
		dime.setYSpeed( 0.5 );
	}

	// Make a penny at the given location and return its GameObj
	GameObj makePenny( double x, double y )
	{
		return makeCoin( x, y, "orange" );
	}

	// Make a dime at the given location and return its GameObj
	GameObj makeDime( double x, double y )
	{
		return makeCoin( x, y, "light gray" );
	}

	// Make and return a round coin at (x, y) with the given color.
	GameObj makeCoin( double x, double y, String color )
	{
		GameObj coin = ct.circle( x, y, 10, color );
		coin.setLineColor( "gray" );
		coin.setLineWidth( 2 );
		return coin;
	}
}
```
The code in `start()` is now even simpler and easier to understand,
and it would be even easier to extend to create more coins as desired.

Here are some things to notice about the code above:

The order of statements starts out as follows:

1. `start()` calls `makePenny()`
2. `makePenny()` then calls `makeCoin()`
3. `makeCoin()` then calls `ct.circle()`
4. The `ct.circle()` function definition is inside
Code12 (where you can't see it). When it finishes,
execution continues inside `makeCoin()`.
5. When `makeCoin()` finishes, control returns to
`makePenny()`, returning the same `GameObj` that got created, 
which then returns to `start()` again returning the same `GameObj`.
6. This puts the program back in `start()`, now at the 
first call to `makeDime()`, which starts a similar sequence.

The `x` and `y` parameters declared in `makePenny()`, `makeDime()`,
and `makeCoin()` are all different variables and do not interfere 
with each other. 

A `return` statement can return a variable value, an expression value,
or the result of another function call directly, so when `makePenny()` 
does:
```
return makeCoin( x, y, "orange" );
```
this calls `makeCoin()` and then takes the return value 
of the call (here a `GameObj`) and passes it on as the return value 
from `makePenny()`.

###### [Java Language Help](#top) > [Function Parameters]


### Loops
A loop allows your program to repeat a section of code multiple times,
until some ending condition is met. For example, you could use a loop
to draw 20 circles on the screen without having to copy and paste the
call to `ct.circle()` and related code 20 times.

#### Examples
The Java language has three different kinds of loops to choose from: 
the `while` loop, the `do-while` loop, and the `for` loop. 
Here is an example of each, all doing the same task:
```
// Draw 20 circles across the screen using a while loop
double x = 2.5;
while (x < 100)
{
	ct.circle( x, 50, 4 );
	x += 5;
}
```
```
// Draw 20 circles across the screen using a do-while loop
double x = 2.5;
do
{
	ct.circle( x, 50, 4 );
	x += 5;
}
while (x < 100);
```
```
// Draw 20 circles across the screen using a for loop
for (double x = 2.5; x < 100; x += 5)
{
	ct.circle( x, 50, 4 );
}
```
#### The "while" Loop
The syntax of a `while` loop is very similar to the syntax of an `if` statement
(see [if-else]):
```
if (test)
{
	// Code to do if test is true
}
```
```
while (test)
{
	// Code to repeat as long as test is true
}
```
For example:
```
double x = 2.5;

// If x is on the screen, then draw a circle there and increase x by 5
if (x < 100)
{
	ct.circle( x, 50, 4 );
	x += 5;	
}
```
```
double x = 2.5;

// As long as x is still on the screen, draw a circle there, 
// increase x by 5, and repeat
while (x < 100)
{
	ct.circle( x, 50, 4 );
	x += 5;	
}
```
A `while` loop starts by evaluating the test condition in the parentheses. 
Just like [if-else], this condition can be any expression that results in a 
[boolean](#java-data-types) (true or false) value, such as:

* One of the [Java Operators] that results in a `boolean` result (such as `<`)
* A [boolean](#java-data-types) variable
* A function call that [returns a value](#function-return-values) of type `boolean`

If the test result is false then the body of the loop (the code in curly brackets) 
is skipped, and execution continues after the loop (the loop body does not execute 
at all). If the test result is true, the loop body executes then execution goes back
up to the line with the test and repeats the entire process. The test is evaluated 
again to see if it is still true (typically variable values or something will have 
changed since the first test so the result may be different). If the test is still
true, the body is executed again, and execution goes back to the test again. 
The entire loop process stops once the test result becomes false.

> **Note**: If the test remains true and never changes, then the loop will execute
> forever, resulting in an "infinite loop", which never finishes.

##### More "while" Loop Examples
```
// Count from 1 to 10
int i = 1;
while (i <= 10)
{
	ct.println( i );
	i++;
}
```
```
// A loop with user input
boolean keepGoing = true;
ct.println( "Lets get started" );
while (keepGoing)
{
	ct.println( "This is text output" );
	keepGoing = ct.inputYesNo( "Do you want to keep going?" );
}
ct.println( "We're done" );
```
```
// Print powers of 2 less than 1 million
int i = 1;
while (i < 1000000)
{
	ct.println( i );
	i *= 2;
}
```
#### The "do-while" Loop
A `do-while` loop works just like a `while` loop, except that the test is after 
the loop body instead of before it:
```
while (test)
{
	// Loop body code
} 
```
```
do
{
	// Loop body code
}
while (test);
```
> **Note**: The test line at the end of a `do-while` loop must end with a semicolon,
> whereas the test line at the beginning of a `while` loop must **not** have a semicolon.

Since the loop body of a `do-while` is first, it always executes at least once, 
then the test is evaluated to determine if (and how long) the loop repeats. 
Sometimes this can simplify the code required to get the behavior you want compared to 
using a `while` loop. For example, consider one of the `while` examples above
rewritten to use a `do-while`:
```
// A while loop with user input
boolean keepGoing = true;
ct.println( "Lets get started" );
while (keepGoing)
{
	ct.println( "This is text output" );
	keepGoing = ct.inputYesNo( "Do you want to keep going?" );
}
ct.println( "We're done" );
```
```
// A do-while loop with user input
ct.println( "Lets get started" );
do
{
	ct.println( "This is text output" );
}
while( ct.inputYesNo( "Do you want to keep going?" ) );
ct.println( "We're done" );
```
However, if the correct behavior you want means that sometimes the loop body
should be executed 0 times (be skipped completely), then you must use a 
`while` loop instead of a `do-while` loop.

#### The "for" loop
The `for` loop structure is a convenient shorthand for a common pattern that often
occurs in loops in practice. Compared to using a `while` loop, using a `for` loop 
results in fewer lines of code when writing loops that follow these patterns. 
For example:
```
// Count from 1 to 10
int i = 1;
while (i <= 10)
{
	ct.println( i );
	i++;
}
```
```
// Count from 1 to 10
for (int i = 1; i <= 10; i++)
{
	ct.println( i );
}
```
The pattern for the `while` loop here is:

1. Set the starting value
2. While the value is still valid:
	3. Use the value
	4. Get the next value

The header line of a `for` loop packs steps 1, 2, and 4 all into one line,
resulting in fewer lines of code. Otherwise, a `for` loop behaves the same as
the corresponding `while` loop. 

Written briefly with placeholders, the corresponding pattern for the `while` 
and `for` loops is: 
```
initialize;
while (test)
{
	process;
	advance;
}
```
```
for (initialize; test; advance)
{
	process;
}
```
> Note that although the "advance" statement occurs before the loop body in
> a `for` loop, it is not executed until after the loop body, in the same order
> as the corresponding `while` loop pattern.

The header of a `for` loop is complex and takes some practice to write correctly,
but once you get used to it, experienced programmers can find it easier to 
understand the behavior of the loop because it makes the pattern easier to see.
In the example above, you can think of the loop header as saying 

> "for values of i starting at 1, going up to and including 10, increasing 
> by 1 each time, do the following:"

##### More "for" Loop Examples
```
// Count to 100 by 10s
for (int i = 10; i <= 100; i += 10)
{
	ct.println( i );
}
```
```
// Count backwards from 99 by 3s
for (int i = 99; i > 0; i -= 3)
{
	ct.println( i );
}
```
```
// Draw 20 circles at random positions
for (int i = 1; i <= 20; i++)
{
	ct.circle( ct.random( 10, 90 ), ct.random( 10, 90 ), 10 );
}
```
#### The "break" Statement
Inside the body of a `while`, `do-while`, or `for` loop, you can end the loop
early with the `break` statement. For example:
```
// Draw up to 20 labelled circles at random positions, but stop if one 
// would have been near the bottom of the screen.
for (int i = 1; i <= 20; i++)
{
	int x = ct.random( 10, 90 );
	int y = ct.random( 10, 90 );
	if (y > 85)
		break;
	ct.circle( x, y, 10 );
	ct.text( ct.formatInt( i ), x, y, 8 );
}
```
As soon as a `break` statement is encountered (they are typically controlled by
an `if` as above), the loop body is exited (no more statements in the loop body
are executed), and the entire loop ends (regardless of the current test result).
A `break` statement can only occur inside of a loop.

#### More Loop Syntax
Like the [if-else] structure, if the body of a `while`, `do-while`, or `for` loop
is just a single statement, then you can omit the curly brackets if you want.
For example:
```
// Count to 100 by 10s
for (int i = 10; i <= 100; i += 10)
	ct.println( i );
```
The three parts of a `for` loop header (*initialize*, *test*, and *advance*) are all
optional and can be left out if desired (but the two semicolons must be left in place). 
Leaving out the *initalize* or *advance* statements just means that no statement happens
at that stage of the loop. Leaving out the *test* means that the test defaults to `true`,
and the loop must be ended internally with a `break` statement. Examples:
```
// Count backwards from user-entered starting value by 3s
int i = ct.inputInt( "Enter starting value" );
for (; i > 0; i -= 3)
{
	ct.println( i );
}
```
```
// Draw labelled circles at random positions until one 
// would have been near the bottom of the screen.
for (int i = 1; ; i++)
{
	int x = ct.random( 10, 90 );
	int y = ct.random( 10, 90 );
	if (y > 85)
		break;
	ct.circle( x, y, 10 );
	ct.text( ct.formatInt( i ), x, y, 8 );
}
```
```
// Draw circles as long as the user wants to keep going
for (;;)
{
	ct.circle( ct.random( 10, 90 ), ct.random( 10, 90 ), 10 );
	if (!ct.inputYesNo( "Do you want to keep making circles?" ))
		break;
}
```
Finally, note that the *initialize* and *advance* statements in a `for` loop can be any 
single valid Java statement (not necessarily a variable initialization and 
variable increment/assignment), including function calls.

#### Loops and Code12 Animation Frames
Because loops allow you to repeat behavior, you might think that you could use a loop to
create animation effects (by repeatedly moving an object by a little bit) or to control 
repeating behavior in a game. However, due to way the [start()](API.html#start), 
[update()](API.html#update), and [Input Event Functions](API.html#input-event-functions) 
in Code12 work, this strategy will not work. Although animation frames occur 60 times per 
second, each function body in your program will always *execute to completion* before the 
next animation frame is drawn (even if the 1/60th of a second interval is passed).
This means that any loop in your code will always execute to completion before the screen 
is redrawn. So if you include a loop in your code, only the final results at the end of 
the loop will be displayed. 

Animation and repeating behaviors in a game should be handled by considering the 
automatic repeating nature of the [update()](API.html#update) function. In effect,
there is a loop inside of the Code12 system that is repeatedly preparing and drawing
new animation frames. The contents of your `update()` function are essentially inside 
the body of this loop. So, your `update()` function should typically do what is necessary
for *one* animation frame of your game, letting itself get called repeatedly by
the Code12 system. 

###### [Java Language Help](#top) > [Loops]


### Arrays
An array is a way to store an entire list or sequence of values in a single variable.
You can then access one entry in the sequence by using an integer *index* in 
square brackets after the array name. The first entry is at index 0, the second is
at index 1, etc.

#### Example
```
// Declare and initialize an array of double values named sizes
double[] sizes = { 2, 5, 1, 3.5, 1 };

// Use the 4th size (index 3) to make a circle
ct.circle( 50, 50, sizes[3] );    // diameter will be 3.5
```
#### Notes
The syntax `double[]` is the type for the variable `sizes` above and can be read
as "double array", meaning an array of `double` values. 
You can make an array of any of the [Java Data Types]. Note that all entries
in the array must be the same type. For example:
```
int[] counts = { 2, 0, 1, 6 };
double[] sizes = { 2, 5, 1, 3.5, 1 };
boolean[] hits = { true, false, false, true };
String[] names = { "Doug", "Sue", "Pat" };
GameObj[] walls = { leftWall, topWall, bottomWall };
```
> In the `GameObj[] walls` example above, assume that the variables `leftWall`,
> `topWall`, and `bottomWall` are existing `GameObj` variables that were already
> created (using [ct.rect()](API.html#ct.rect), for example).

##### Getting and Setting Array Values
You can access the entries of an array (often called the *elements* of the array)
using an integer index. Like a regular variable, you can get the value at 
a particular index, and you can also set (change) the value at an index by using
an assignment statement. For example:
```
String[] names = { "Doug", "Sue", "Pat" };

ct.println( names[0] );      // Doug
ct.println( names[1] );      // Sue
ct.println( names[2] );      // Pat

// Change the second name (index 1) 
names[1] = "Abby";

ct.println( names[0] );      // Doug
ct.println( names[1] );      // Abby
ct.println( names[2] );      // Pat
```
##### Using an Index Expression
What really makes arrays a powerful tool is that you can use an `int` variable, 
or any [expression](#expressions) of type `int`, as an index to choose which element 
to access, not just a number directly. For example:
```
double[] sizes = { 2, 5, 1, 3.5, 1 };

int i = 1;
ct.println( sizes[i] );    // 5
```
```
String[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

int month = ct.inputInt( "Enter month number" );

// The correct months index is one less than the month number. 
// For example, "Jan" is month number 1 and index 0.

ct.println( months[month - 1] );
```
##### Invalid Array Indexes
In an array of 3 items, such as:
```
String[] names = { "Doug", "Sue", "Pat" };
```
the valid index values are 0, 1, and 2. Attempting to access an item at an 
invalid index (e.g. past the end of the array) will produce an error. 
For example:
```
String[] names = { "Doug", "Sue", "Pat" };

ct.println( names[3] );   // This causes an error
```
> Note that unlike most error messages that you get for problems with your code,
> an invalid array index causes an error at "runtime" (after your program 
> has already started running). 

##### Using Loops with Arrays
Arrays are especially powerful when used in conjunction with [Loops].
A loop can be used to repeat some code for every element in the array
by modifying an *index variable* and using it inside the loop body.
For example:
```
String[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

// Print all the months
for (int i = 0; i < 12; i++ )
{
	ct.println( months[i] );
}
```
If you want to read and process all the elements of an array in order
(such as in the example above), Java also offers a special shortcut
syntax for this called the "Enhanced For Loop":
```
String[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

// Print all the months
for (String month: months )
{
	ct.println( month );
}
```
In the Enhanced For Loop, instead of using an integer index, the loop
variable is the same type as the elements in the array, and it will be
assigned in turn to each element in the array, in order.

##### Creating an Empty Array
An array variable initialization such as:
```
String[] names = { "Doug", "Sue", "Pat" };
```
declares the array variable `names` and also initializes the array to contain
the values given in the curly brackets.

You can also declare and create an array that leaves the individual array elements
"blank" but has room for them to be assigned (set) later:
```
String[] names = new String[3];      // blank array with room for 3 Strings

names[0] = "Doug";
names[1] = "Sue";
names[2] = "Pat";
```
Carefully note the syntax `new String[3]`. After `new` goes the type for the
elements in the array (this must be declared up front), then the *size* of the
array in square brackets (here 3).

Creating an array in this way is useful when you need code to calculate or 
create the array elements. For example:
```
// Create a blank array of 10 int values to store sizes
int[] sizes = new int[10];

// Set all the sizes to random values
for (int i = 0; i < 10; i++)
{
	sizes[i] = ct.random( 0, 5 );
}

// Print all the sizes
for (int i = 0; i < 10; i++)
{
	ct.println( sizes[i] );
}
```
Note that when you create a "blank" array, the elements of the array are actually 
all initialized right away to an initial default value depending on their type
as follows:
```
Type      Default Value
----      -------------
int       0
double    0.0
boolean   false
String    null
GameObj   null
```
##### An Array of GameObj Objects
Especially useful in games is the ability to create an array of 
[GameObj](#java-data-types) objects. In conjunction with [Loops],
You can create many objects on the screen and keep track of and
manipulate all of them. For example:
```
class Example
{
	// An array that can hold 10 GameObj objects
	GameObj[] balls = new GameObj[10];

	public void start()
	{
		// Create the balls at random locations
		for (int i = 0; i < 10; i++)
		{
			balls[i] = ct.circle( ct.random( 10, 90 ), ct.random( 10, 90 ), 10 );
		}
	}

	public void update()
	{
		// Move all the balls and recycle them when they go off-screen
		for (int i = 0; i < 10; i++)
		{
			balls[i].x += 0.5;
			if (balls[i].x > 110)
				balls[i].x = -10;
		}
	}
}
```
##### Passing an Array as a Parameter and Getting the Array Length
You can write a function that takes an array as a parameter and then pass 
an array to it. For example:
```
class Example
{
	public void start()
	{
		// Two different arrays of int
		int[] counts = { 32, 12, 75, 42 };
		int[] scores = { 85, 100, 65, 72, 67, 98, 0, 12 };

		// Call function to get the total of each array and print it.
		ct.println( "Total of counts is " + arrayTotal( counts ) );
		ct.println( "Total of scores is " + arrayTotal( scores ) );
	}

	// Calculate and return the sum of all the elements in the array a.
	int arrayTotal( int[] a )
	{
		int total = 0;
		for (int i = 0; i < a.length; i++)
			total += a[i];
		return total;
	}
}
```
Note that the array parameter variable is declared above as `int[] a`,
so the array passed must be an array of `int`, however the number of 
elements in the array is not specified. You could pass an array of `int` 
with any number of elements in it.

A function may need to determine the number of elements in an array parameter
to do its work, as shown in the example above. You can get the number of elements 
in any array by using the syntax `a.length`, where `a` is the array variable. 
This will result in an integer value that is the number of elements in the array. 

When passing an array as a parameter, it is important to understand that only
a *reference* to the array is passed (essentially a pointer to the actual array
where it lives in memory). Passing an array does *not* make a copy of the array.
So, if the function modifies the elements of the array, the original array that 
was passed will be modified. 

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
see [Graphics Object Creation](API.html#graphics-object-creation). 
If you store a `GameObj` in a variable then you can also access and change the object later 
using the [GameObj Data Fields](API.html#gameobj-data-fields) and 
[GameObj Methods](API.html#gameobj-methods).

###### [Java Language Help](#top) > [Java Data Types]


### Java Operators
Code12 supports the following Java operators in [expressions]. 
These are listed in groups from highest precedence to lowest precedence
(see [Order of Operations and Parentheses]). Within each group,
operators execute from left to right.

##### Unary Operators (operate on only one value)
```
-a        // (Negate) a is numeric, result is numeric
!a        // (NOT) a is boolean, result is boolean
```
##### Multiplication and Division
```
a * b     // (Multiply) a and b are numeric, result is numeric
a / b     // (Divide) a and b are numeric, result is numeric
a % b     // (Mod) a and b are numeric, result is numeric
```
##### Addition and Subtraction
```
a + b     // (Add) a and b are numeric, result is numeric
a - b     // (Subtract) a and b are numeric, result is numeric
a + b     // (Concatenation) either a or b is String, result is String
```
##### Inequality Comparison
```
a < b     // (Less than) a and b are numeric, result is boolean
a <= b    // (Less than or equal to) a and b are numeric, result is boolean
a > b     // (Greater than) a and b are numeric, result is boolean
a >= b    // (Greater than or equal to) a and b are numeric, result is boolean
```
##### Equality Comparison
```
a == b    // (Equal to) a and b are compatible types, result is boolean
a != b    // (Not equal to) a and b are compatible types, result is boolean
```
##### Logical AND
```
a && b    // (AND) a and b are boolean, result is boolean
```
##### Logical OR
```
a || b    // (OR) a and b are boolean, result is boolean
```

###### [Java Language Help](#top) > [Java Operators]

### Main Program Structure
A Code12 Java program running in the Code12 Application consists of a single
user-defined class corresponding to the main program. Declaring or importing 
additional classes is not supported.

> Use the [Code12 Java Package](http://www.code12.org/download.html) 
> when you are ready to start using additional classes.

In addition, your program does not need the standard Java `main()` function. 
Instead, your program will define a `start()` function where the program
begins. For example:
```
class Example
{
	public void start()
	{
		// Your program starts here
		ct.circle( 50, 30, 20 );
	}
}
```
Your program can also contain an optional
[update()](API.html#main-program-functions) function and optional
[Input Event Functions](API.html#input-event-functions).

###### [Java Language Help](#top) > [Main Program Structure]


### Unsupported Java Language Features
The Code12 Application supports a subset of the full Java language,
in order to avoid the typical syntax ambiguities that make traditional
Java error messages frequently confusing to beginners, and to keep
the focus on the [12 fundamental programming concepts](#top).

> You can use the [Code12 Java Package](http://www.code12.org/download.html) 
> with the Java development environment of your choice if you want to 
> use the [Code12 API](API.html) with the full Java language.

##### No Class Definitions
The main restriction is that class definitions other than the main program
class are not supported, and importing classes is not allowed.
This means that other than the main program class, the only classes that 
a Code12 program will use are: 

1. The main `ct` class/instance defined by the Code12 API
2. The `GameObj` class defined by the Code12 API (a graphical object)
3. The standard Java `String` class (a subset of methods is supported)
4. The Java `Math` class (a subset of methods is supported)

##### Other Unsupported Java Features
In addition to restricting a program to a single user-defined class, 
the following Java features are not supported by the Code12 Application:

1. Importing classes and packages, including the Java Class Library
2. Class inheritance, interfaces, etc.
3. Using `new` to create object instances (except arrays)
4. The byte, char, float, long and short data types
5. Enumeration (enum) types
6. Exception handling (try, catch, throw, etc.)
7. The switch statement (switch, case, default)
8. The continue statement
9. Bit operators (<<, >>, >>>, &, |, ^)
10. The ternary operator (? :)
11. Multi-dimentional arrays or arrays of arrays

##### Restricted Java Features
To further help prevent common errors and sources of confusion,
Code12 also intentionally restricts the use of some language features:

1. The assignment and increment operators (=, +=, ++, etc.) do not
result in values. Assignments are statements, not expressions.
2. Integer division that may produce (and lose) a remainder is not 
allowed directly. A function ct.intDiv() is provided if desired.
3. Local variables and parameters cannot hide (be named the same as)
a class-level variable.
4. Variable names are not allowed to differ only by case from existing names.
5. Functions calls returning objects cannot be be used to access fields
or methods of the object directly. An object variable must be used.


#### Unsupported Java Keywords
The following Java keywords are not supported by the Code12 Application:
```
Data Types     Classes        Flow Control    Other
----------     -------        ------------    -----
byte           abstract       assert          native
char           extends        case            strictfp
enum           implements     catch           synchronized
float          import         continue        transient
long           instanceof     default         volatile
short          interface      finally
               package        switch
               protected      throw
               static         try
               super
               this
               throws
```
In addition, the following Java keywords have reduced or limited support:
```
class       (only for the main program class)
new         (only for arrays)
private     (ignored when allowed)
public      (ignored when allowed)
```
###### [Java Language Help](#top) > [Unsupported Java Language Features]

### Indentation and Brace Placement
The Java language is normally defined to treat line breaks the same as 
spaces, and to ignore indentation. However, to help you find common errors 
in your program, the Code12 Application detects and enforces consistent use
of indentation and a "style" of placing braces (curly brackets) as follows:
```
class Example
{
	// Class-level variables and function bodies are indented inside
	// the class, all starting at the same level.

	int size = 20;

	public void start()
	{
		// Code inside function bodies is indented more

		ct.circle( 50, 30, size );
		if (size < 10)
			size = 10;    // controlled statements are indented further
		else
		{
			// Braces to enclose a block are always on their own lines,
			// the enclosed statements are indented further, and 
			// the close brace lines up with the matching open brace.

			ct.circle( 50, 30, size );
			size -= 10;
			ct.circle( 50, 30, size );
		}
	}
}
```
For more information on the brace placement for specific structures, see:

* [Main Program Structure]
* [If-else]
* [Loops]
* [Function Definitions]

#### Line Breaks
In addition to the rules for indentation, the Code12 Application requires 
each statement to be on its own line and restricts how and where
statements can be broken with a line break:
```
class Example
{
	public void start()
	{
		// Each statement must be on its own line

		double a = 50;
		double b = 20;
		double y = 30;

		// Long statements can be broken after a comma,
		// and the continuation line(s) must be indented.

		ct.circle( (a + (b * 2) / 3) + ct.random( 0, 10 ),
				y + ct.random( 2, 8 ), 20 );

		// Any line can also be broken after the special comment ///
		if ((a < 10 && b > 30 && y < a + b)      ///
			|| (a > 50 && b < 10 && y > a - b))
		{
			a = 0;
			b += 10;
		}
	}
}
```
These restrictions help Code12 provide accurate placement and wording
of error messages that correspond to the actual mistakes made by
the programmer.

###### [Java Language Help](#top) > [Indentation and Brace Placement]


<footer>
	Code12 Version 2.0

	Copyright (c) 2019 Code12. All Rights Reserved. 
</footer> 
