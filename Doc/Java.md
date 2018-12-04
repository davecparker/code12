% Java Language Help

##### [Java Language Constructs](#java-syntax-examples)
* [Procedure Calls]
* [Comments]
* [Variables]
* [Expressions]
* [Function Calls]
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

1. [Procedure Calls]
2. [Comments]
3. [Variables]
4. [Expressions]
5. [Function Calls]
6. [Object Data Fields]
7. [Object Method Calls]
8. [If-else]
9. [Function Definitions]
10. [Parameters]
11. [Loops]
12. [Arrays]

###### [Java Language Help](#top) > [Java Syntax Examples]


### Procedure Calls
A procedure call is a named command for your program to execute, followed by 
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
ct.setBackColor( "light blue" );
```
```
ct.text( "Game Over", 50, 50, 10 );
```

#### Notes
A procedure call is the most common programming construct. 
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

##### Java Terminology
Most programmers refer to procedure calls as "function calls",
and Java programmers will often refer to them as "method calls".
Here will we usually refer to them as "function calls".

The input values to a function call are called "parameters" or
"arguments". Here we will usually refer to them as "parameters".

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

The Java programming language is often used with a large library
called the "Java Class Library", but Code12 only supports a
handful of functions from this library when programs are run
within the Code12 application.

###### [Java Language Help](#top) > [Procedure Calls]


### Comments

###### [Java Language Help](#top) > [Comments]


### Variables

###### [Java Language Help](#top) > [Variables]


### Expressions

###### [Java Language Help](#top) > [Expressions]


### Function Calls

###### [Java Language Help](#top) > [Function Calls]


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
A `GameObj` (Game Object) is a reference to a graphical object (circle, rectangle, 
line, text, or image) that you can create for display on the screen. To create a `GameObj`,
see [Graphics Object Creation]. If you store a `GameObj` in a variable then you can 
also access and change the object later using the [GameObj Data Fields] and [GameObj Methods].

###### [Java Language Help](#top) > [Java Data Types]


<footer>
	Code12 Version 1.0

	(c)Copyright 2018 Code12 and David C. Parker. All Rights Reserved. 
</footer> 

