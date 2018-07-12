import Code12.*;

class BubblePop extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new BubblePop()); 
   }
   
   public void start()
   {
      // Make the background 
      ct.setHeight(150);
      ct.setBackImage("underwater.jpg"); 
   }
   
   public void update()
   {
      // Make bubbles at random times, positions, and sizes
      if (ct.random(1, 20) == 1)
      {
         double x = ct.random(0, 100);
         double y = ct.getHeight() + 25;
         double size = ct.random(5, 20);
         GameObj bubble = ct.image("bubble.png", 
                              x, y, 
                              size);
         bubble.ySpeed = -1; 
         bubble.clickable = true;
         GameObj bubbleCopy = bubble; // initialization of GameObj from another GameObj
         int z; // declaration without initialization - primitive type
         int x, y, z; // declaring multiple variables
         z = -1 + 2; // assigning value with int and unary minus
         z = 0.707; // assigning value with double
         z = .707; // no leading zero
         z = -.707; // negative with no leading zero
         bigNum = 1.23456E10; // exponential notation E
         bigNum = 1.23456e10; // exponential notation e
         bigNum = 1.23456e+123; // exponential notation e+
         bigNum = -1.23456E103; // exponential notation -E
         bigNum = -1.23456E+103; // exponential notation -E+
         littleNum = 1.23456E-9; // exponential notation E-
         littleNum = -1.23456E-98; // exponential notation -E-
         littleNum = 1.23456e-987; // exponential notation e-
         littleNum = -1.23456e-9876; // exponential notation -e-
         x = .5e7; // exponential notation without leading digit before dot
         x = 3.e8; // exponential notation without digit after dot
         double xyz = ( 2 * x + y - 3.14 ) / z + 1.414; // initialization with expression
         double mean = (a + b + c) / 3;
         double y = m * x + b;
         z = p * r % q + w / x - y;
         y = a * x * x + b * x + c;
         y = (a * x * x) + (b * x) + c;
         double z2 = z * 2.0; // initialization from another variable 
         x = (a + b) / 2 + (c - d) / 2; // multiple parentheses
         x = ( ( a + b ) / c ) / 2; // nested parentheses
         x = y % 12; // mod operator
         
         // relational operators and if/else
         if (count == 0)
         if (x != 10)
         if (temp > 98.6)
         if ( temp <= 100 )
         else if (x >= 42)
         else
         boolean differenceIsSmall = Math.abs(x - a) < eps;
         
         // Strings
         String greeting; //  declaration without initialization - String type
         greeting = "hello"; // assigning value to a string
         String greeting2 = "hello there"; // declaration with initialization - String type
         String greeting3 = greeting1; // declaration with initialization from another variable's value
         String greeting4 = greeting1 + " " + "world"; // declaration with concatenation
         String greeting5 = greeting2.substring(0, 6); // declaration with String method
         s = "boolean variable b = " + true; // String concatenation with boolean
         s = "line1\nline2"; // String with newline
         s = "\"Hello,\" he said."; // String with escaped quotes
         ct.println("He said 'Hello'"); // String with single quotes
         docsDir = "C:\\Users\\Ben\\Documents\\"; // String with escaped backslash
         ct.println( "I\tneed\tmy\tspace" ); // String with escaped tab
         input = input.toUpperCase(); // method call
         i_dont_like_camel_case = "butItTakesLessKeystrokes"; // variable identifier with underscores

         // loops
         for (int i = 0; i < 10; i++)
         for (i = 0; i < 10; i = i + 2)
         for (int i = 0; i < 100 && 2 * i < 50; i = i * 2)
         for (int i = 100; i > 0; i--)
         for (int i = 10; i > 0; i = i - 2)
         for (int i = 0; i < len; i++)
         for (int i = 0; i < arr.length; i++)
         while (j < 100)
         do
         while (j < 100);
         while (j < foo && i != bar);
         while (j >= 100);
         while (j <= foo && i != bar);
         while (i < max && notFound)
         
         // arrays
         int[] a;
         int[] a = new int[100];
         int[] a = new int[foo];
         int[] a = new int[b.length * 2];
         int[] a = {1, 2, 3};
         int[] a = { 1,
                     2,
                     3};
         int[] a = b;
         double[] data = new double[1000];
         String[] greetings = {"hello", "hola", "bonjour"};
         GameObj[] targets;
         GameObj[] targets = new GameObj[100];
         GameObj[] targets = new GameObj[numTargets];
         foo = bar[i];
         foo = bar[0];

         // function definitions
         void foo()
         void fooBar(int aParameter)
         int foo(double x)
         String bar(String[] a, int length)
         String[] split(String s, String delim)
         public double add(double x, double y, double z)
         
         // function calls
         ct.println("Hello world");
         ct.println("Hello " + name);
         ct.println("Hello\nWorld");
         x = add(3, 4);
         m = mean(1.2, 3.4, 5.67);
         foo(x,
             y,
             z);

         // multiline comments
         /* this is a multiline comment
          * this is the second line
          * this is the third line
          */

         // Code12 api
         ct.print("Hello world");
         ct.print("Hello world\n");
         ct.print("Hello "+name);
         ct.print(myObj);
         ct.println("Hello world");
         ct.println("Hello world\n");
         ct.println("Hello "+name);
         ct.println(myObj);
         ct.log(obj);
         ct.log("obj1 = ", obj1, "obj2 = ", obj2, "obj3=", obj3, 3.14, Math.PI, 42);
         ct.logm("message");
         ct.logm("message", obj1, obj2);
         ct.showAlert("alert message");
         ct.showAlert(alertMessage);
         int n = ct.inputInt("enter a number: ");
         n = ct.inputInt("enter a number: ");
         double x = ct.inputNumber("enter a number: ");
         x = ct.inputNumber("enter a number: ");
         boolean quit = ct.inputString("Quit?");
         quit = ct.inputString("Quit?");
         ct.setTitle("Title");
         ct.setHeight(100.0 * 9 / 16);
         double height = ct.getHeight();
         height = ct.getHeight();
         double width = ct.getWidth();
         width = ct.getWidth();
         double pxPerUnit = ct.getPixelsPerUnit();
         pxPerUnit = ct.getPixelsPerUnit();
         int pixelWidth = ct.round( ct.getWidth() * ct.getPixelsPerUnit() );
         int pixelHeight = ct.round( ct.getHeight() * ct.getPixelsPerUnit() );
         String currentScreen = ct.getScreen( );
         currentScreen = ct.getScreen( );
         ct.clearScreen();
         ct.clearGroup("targets");
         ct.setBackColor("orange");
         ct.setBackColor(backColor);
         ct.setBackColor(colors[i]);
         ct.setBackColor(255, 0, 0);
         ct.setBackImage("background.png");
         ct.setBackImage("C:\\Users\\ben\\Pictures\\landscape.jpg");
         ct.setBackImage(filename);
         GameObj circle = ct.circle(x, y, diameter);
         GameObj circle = ct.circle(x, y, diameter, color);
         circle = ct.circle(50, 20, 10.5);
         circle = ct.circle(50, 20, 10.5, "blue");
         GameObj rect = ct.rect(x, y, width, height);
         GameObj rect = ct.rect(x, y, width, height, color);
         rect = ct.rect(50, 33.3, 11.2, 23.890);
         rect = ct.rect(50, 33.3, 11.2, 23.890, "green");
         GameObj line = ct.line( x1, y1, x2, y2 );
         GameObj line = ct.line( x1, y1, x2, y2, color );
         line = ct.line( 0, 0, 100, 95 );
         line = ct.line( 0, 0, 100, 95, "red" );
         GameObj text = ct.text( s, x, y, height );
         GameObj text = ct.text( s, x, y, height, color );
         text = ct.text( "Score: " + score, 20, 90, 10 );
         text = ct.text( "Score: " + score, 20, 90, 10, "purple" );
         GameObj car = ct.image( filename, x, y, width );
         car = ct.image( "car.png", 42, 25, 38.7 );
         car = ct.image( "C:\\Users\\john\\Pictures\\car.jpg", 42, 25, 38.7 );
         if (ct.clicked())
         boolean mouseClicked = ct.clicked();
         mouseClicked = ct.clicked();
         if ( ct.clickX() > 50 )
         double x = ct.clickX();
         x = ct.clickX();
         if ( ct.clickY() <= bottomMargin )
         double y = ct.clickY();
         y = ct.clickY();
         if (ct.keyPressed(keyName))
         if (ct.keyPressed("up"))
         boolean upKeyPressed = ct.keyPressed("up");
         keyPressed = ct.keyPressed(keyName);
         if ( ct.charTyped("+") )
         if ( ct.charTyped(keyName) )
         boolean plusCharTyped = ct.charTyped("+");
         plusCharTyped = ct.charTyped(plusKeyName);

         rect.width = 10;
      }
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Pop bubbles that get clicked
      if (obj != null)
      {
         obj.delete();
         ct.sound("pop.wav");
      }
   }
}

////////////////////////////////////////////////////////////////////
ERRORS

// Lexical errors
@               // invalid character
foo('a');       // char literals not supported
foo(" );        // unclosed string literal 
foo("\);        // unclosed string literal ending in backslash
s = "\          // unclosed string literal ending in backslash
s = "\";        // unclosed string literal from escaped double quote
s = "\ ";       // illegal escape character
s = "\r"        // unsupported escape sequence
interface foo   // unsupported reserved word
double 1stNumber; // variable name starting with a number
x = obj.1stNumber; // field name starting with a number

// Syntax errors
x = 10          // missing ;
foo(x, );       // missing expr in exprList
x = a + ;       // missing expr after binary op
x = a ++ b;     // unexpected token after unary op
x = a ** b;     // missing expression between binary ops
x = a + b * ;   // missing expr after higher precedence binary op
x = a * b + ;   // missing expr after lower precedence binary op
x = ();         // missing expr in parentheses
x = 10 + ! ;    // missing expr after unary op
x = obj.3;      // expected ID after .
x = 3.obj;      // ID expected before .
if x == 3       // required next token in pattern doesn't match
while i < max   // required next token in pattern doesn't match
for i=0; i<num; i=i+1 // required next token in pattern doesn't match
x + 3;          // no matching pattern
x = 1,000;      // commas in numbers
x = 1.23.45;    // too many decimal points
x = 3.14e1.0;   // exponential notation with decimal point in exponent
x = 3.14e;      // Invalid exponential notation
x = 3.141e+;    // Invalid exponential notation
x = 3.1415e-;   // Invalid exponential notation
x = 3.14159e+exponent; // Invalid exponential notation
x = 3.141592ee0; // Invalid exponential notation
x = 3.141592EE0; // Invalid exponential notation
x = 3e; // Invalid exponential notation
x = .3E; // Invalid exponential notation
foo(x,          // (incomplete line continued below)
y)              // missing ;
x = (a + b + c / 3; // missing closing parenthesis
x = foo(y, bar(z, w); // missing closing parenthesis w/ nested parentheses
x = a + b + c ) / 3; // missing openning parenthesis
if ( i == 1 // missing closing parenthesis with if
if ( i == 1 ); // if followed directly by ;
for ( i=0; i<n; i++); // for() followed directly by ;
x + 1 = x; // confusing left hand side an right hand side of assignment
1000 = count; // confusing left hand side an right hand side of assignment
if ( x => 3 ) // => instead of <=
for(int i=0, i<n, i++) // commas in place of semicolons
for(int i=0: i<n: i++) // colons in place of semicolons
for{int i=0; i<n; i++} // {} in place of ()

double foo(x, y, z) // missing variable types for arguments in function definition
ct.println; // missing parenteses for function call without arguments
foo(int x, double y, GameObj z) // missing return type in function definition
foo(int x, double y, GameObj z); // supplying variable types in function call
String s = 'Hello'; // '' in place of "" for strings
String s = "A long string
            on more than one line";
ct.println("He said "Hello""); // not escaping double quotes in a string literal

// Unsupported Java syntax
int x = 1, y = 2, z = 3;      // declaring and initializing multiple variables
import java.io.PrintWriter;   // import other than Code12.*
int time = (int)( sec );      // type casting
time %= 3600;                 // %=
int numberOfDucks = (turboMode ? 100 : 1); // ?: operator
System.out.println("Hello world"); // classes other than GameObj and String
char ch = 'a'; // char type
while(foo) { // opening { in control structure not on it's own line
i++; } // closing } not on it's own line
String s = "A long string" +
           "on more than one line using concatenation";
x = a; y = b; // more than one statement on a single line not supported
if (x == 0) ct.println("x is zero"); // control structure must be on their own lines
double getVariable() { return variable; } // blocks must start and end on their own lines
switch (choice) // switch not supported
continue;   // continue not supported
max = a[i++]; // complex expressions not supported
x = ++i; // prefix increment not supported
x = --i; // prefix decrement not supported
obj.group.equals("targets"); // indexing more than one level at a time not supported
input.toLowerCase().equals("quit"); // indexing after function call not supported
