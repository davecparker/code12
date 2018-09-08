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
		double x = 5.; // number with decimal point but no digits after
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
		for (GameObj bullet : bullets )

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
	}
	// -------------------------------------------------------------
	// Parsing white box tests
	// -------------------------------------------------------------
	// "blank"

	// "comment"
	// single comment line
	while ( x < 100 ) // comment at end of line of code
	/* block comment line 1
	* block comment line 2
	*/
	/* block comment with // slash slash comment */
	int x = 0; /* block comment after code on same line */
	/* block comment before code on same line */ double pi = 3.14;
	// block comments inside line of code
	double foo(int i /*fee*/, double db /*fi*/, boolean boo /*fo*/)

	// "stmt",       stmt, ";"
	// -- stmt "call"      fnValue, "(", exprList, ")"
	// -- -- exprList "empty"
	foo();
	foo.bar();
	foo[i].bar();
	// -- -- exprList "list"
	foo(123); // "NUM"
	foo(12.345); 
	foo(1.234e56);
	foo(1.234e+56);
	foo(1.234e-56);
	foo(.234e56);
	foo(.234e+56);
	foo(.234e-56);
	foo(true); // "BOOL"
	foo(false);
	foo(null); // "NULL"
	foo("string literal"); // "STR"
	foo(bar()); // "call"
	foo(bar(123));
	foo(x); // "lValue"
	foo(obj.x);
	foo(objs[i]);
	foo(objs[i].x);
	foo(123); // "exprParens"
	foo(-123); // "neg"
	foo(-.234e+56);
	foo(-obj.x);
	foo(!true);   // "!"
	foo(!false);
	foo(!paused);
	foo(new int [100]); // "newArray"
	foo(new GameObj [numBullets]);
	foo(new GameObj [numBullets * 2]);
	// -- -- exprList "list" (1 non-primary expr)
	foo(123 + obj.x);
	foo(-123 + obj.x - obj2.x);
	foo(100 - obj.x * -3.14);
	foo((1 + a[iTop]) - 1);
	foo((1 + a[iTop]) / 1);
	foo((a[i] + b[j]) / 3);
	// -- -- exprList "list" (multiple exprs)
	foo(x, why, zee);
	foo(x,
		y,
		z);
	foo( x + y, a || b && c, bar[i].m(z * (u + v)) );
	// -- stmt "varAssign"      "ID", "=", expr
	// -- -- valid "ID"s
	x = 0;
	xValue = 0;
	x123 = 0;
	x123four = 0;
	some_variable = 0;
	x1_ = 0;
	// x = primaryExpr
	var = 12.345; 			// "NUM"
	x = 1.234e56;
	x = 1.234e+56;
	x = 1.234e-56;
	x = .234e56;
	x = .234e+56;
	x = .234e-56;
	x = true; 				// "BOOL"
	x = false;
	x = null;				// "NULL"
	x = "string literal"; 	// "STR"
	x = foo(); 				// "call"
	x = foo.bar(123);
	x = y; 					// "lValue"
	x = obj.x;
	x = objs[i];
	x = objs[i].x;
	x = (123); 				// "exprParens"
	x = -123; 				// "neg"
	x = -.234e+56;
	x = -obj.x;
	x = !true;   			// "!"
	x = !false;
	x = !paused;
	x = new GameObj [numBullets]; // "newArray"
	x = (int) 3.14;         // "cast"
	x = x * y;
	x = x / y;
	x = x % y;
	x = x + y;
	x = x - y;
	x = x << y;
	x = x >> y;
	x = x >>> y;
	b = x < y;
	b = x <= y;
	b = x > y;
	b = x >= y;
	b = x == y;
	b = x != y;
	x = x & y;
	x = x ^ y;
	x = x | y;
	b = x && y;
	b = x || y;
	x = x + y + z;
	x = x - y - z;
	x = x * y * z;
	x = x / y / z;
	x = x % y % z;
	x = x + y - z;
	x = x - y + z;
	x = x + y * z;
	x = x * y + z;
	x = x + y / z;
	x = x / y + z;
	x = x + y % z;
	x = x % y + z;
	x = x - y * z;
	x = x * y - z;
	x = x - y / z;
	x = x / y - z;
	x = x - y % z;
	x = x % y - z;
	x = x * y / z;
	x = x / y * z;
	x = x * y % z;
	x = x % y * z;
	x = x / y % z;
	x = x % y / z;
	x = (x + y) + z;
	x = x - (y - z);
	x = (x * y) * z;
	x = x / (y / z);
	x = (x + y) - z;
	x = x - (y + z);
	x = (x + y) * z;
	x = x * (y + z);
	x = (x + y) / z;
	x = x / (y + z);
	x = (x - y) * z;
	x = x * (y - z);
	x = (x - y) / z;
	x = x / (y - z);
	x = (x * y) / z;
	x = x / (y * z);
	x = 123 + obj.x;
	x = -123 + obj.x - obj2.x;
	x = 100 - obj.x * -3.14;
	x = (1 + a[iTop]) - 1;
	x = (1 + a[iTop]) / 1;
	x = 1 + (a[i] + b[j]) / 3;
	x = x1 * y1 + x2 * y2 + x3 * y3;
	x = x[0] * y[0] + x[1] * y[1] + x[2] * y[2];
	x = (x1 + x2 + x3) / 3;
	x = (x[0] + x[1] + x[2] + x[3]) / 4;
	x = sum / n;
	x = Math.sqrt(a * a + b * b);
	x = Math.sqrt(Math.pow(a,2) + Math.pow(b,2));
	x = Math.sqrt( (a.x - b.x) * (a.x - b.x) + (a.y - b.y)*(a.y - b.y) );
	x = Math.sqrt( Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2) );
	x = Math.sqrt((obj.x + obj.y) / 2 - (a[i] + b[j]) / 3);
	x = true;
	x = !true;
	x = false;
	x = !false;
	x = !boolVar1 && boolVar2;
	x = boolVar1 && !boolVar2;
	x = !boolVar1 && !boolVar2;
	x = !(boolVar1 && boolVar2);
	x = !boolVar1 || boolVar2;
	x = boolVar1 || !boolVar2;
	x = !boolVar1 || !boolVar2;
	x = !(boolVar1 || boolVar2);
	x = boolVar1 && boolVar2 && boolVar3;
	x = boolVar1 || boolVar2 || boolVar3;
	x = boolVar1 && boolVar2 || boolVar3;
	x = !boolVar1 && boolVar2 || boolVar3;
	x = boolVar1 && !boolVar2 || boolVar3;
	x = boolVar1 && boolVar2 || !boolVar3;
	x = !boolVar1 && !boolVar2 || boolVar3;
	x = boolVar1 || boolVar2 && boolVar3;
	x = (boolVar1 && boolVar2) || boolVar3;
	x = boolVar1 && (boolVar2 || boolVar3);
	x = (boolVar1 && boolVar2) || (boolVar3 && boolVar4);
	x = (boolVar1 && (boolVar2 || boolVar3)) && boolVar4;
	x = x && ( (y || z) && !w );
	x = x < 0;
	x = x <= 1.2;
	x = x > .1;
	x = x >= .1e-23;
	x = x < eps && x > -eps;
	x = xValue > eps[i] && xValue < eps[i + j];
	x = x1 < foo() || y2 >= foo[i].bar(arr[i]);
	x = x >= y.bar() && ( z_val <= 1 + 2.3 || 5 > 7 );
	// -- stmt "assign"      lValue, "=", expr
	obj.x = -0.5;
	obj.height = obj2.height;
	xCoord[i] = obj.x;
	objs[i].x = foo(i);
	a[0] = startValue;
	a[i] = max;
	a[i] = a[i - 1];
	a[i] = b[i];
	dist[i] = Math.sqrt( (a[i].x - b[i].x) * (a[i].x - b[i].x) + (a[i].y - b[i].y)*(a[i].y - b[i].y) );
	dist[i] = Math.sqrt( Math.pow(a[i].x - b[i].x, 2) + Math.pow(a[i].y - b[i].y, 2) );
	// -- stmt "opAssign"
	i += 1;
	obj.x += -0.5;
	obj.height -= obj2.height;
	xCoord[i] *= obj.x;
	objs[i].x /= foo(i);
	a[0] += startValue;
	a[i] -= max;
	a[i] *= a[i - 1];
	a[i] /= b[i];
	dist[i] += Math.sqrt( (a[i].x - b[i].x) * (a[i].x - b[i].x) + (a[i].y - b[i].y)*(a[i].y - b[i].y) );
	dist[i] -= Math.sqrt( Math.pow(a[i].x - b[i].x, 2) + Math.pow(a[i].y - b[i].y, 2) );
	// -- stmt "preInc"
	++x;
	++x.y;
	++a[i];
	++a[i].x;
	// -- stmt "preDec"
	--x;
	--x.y;
	--a[i];
	--a[i].x;
	// -- stmt "postInc"
	x++;
	x.y++;
	a[i]++;
	a[i].x++;
	// -- stmt "postDec"
	x--;
	x.y--;
	a[i]--;
	a[i].x--;
	// -- break
	break;

	// "varInit",       "ID", "ID", "=", expr, ";"
	// -- expr is a primaryExpr
	int i = 0;
	double c = 2.99792458e+8;
	boolean b = true;
	String greeting = "hello";
	int x = foo();
	double y = bar("foo");
	boolean b = x;
	String s = x.y;
	GameObj g = arr[index];
	double x = arr[i].x;
	int i = (j);
	double d = -123.e-56;
	boolean b = !b;
	// -- expr is not a primaryExpr
	int m = (s + e) / 2;
	int mid = start + (end - start) / 2;
	double dotProduct = x1 * y1 + x2 * y2 + x3 * y3;
	double avg = (x[0] + x[1] + x[2] + x[3]) / 4.0;
	double avg = sum(arr) / arr.length;
	GameObj b = bullets[i];
	double dist = Math.sqrt( Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2) );
	boolean b = ( x || y ) && ( x || z );
	boolean b = ( x && ( (y || z) && !w ) );

	// "varDecl",       "ID", idList, ";"
	int x;
	double x1, x2;
	double x_1, x_2, x_3;
	boolean paused, turboModeOn, cheatModeOn;
	String city, state, zip;

	// "constInit",      "final", "ID", "ID", "=", expr, ";"
	final int MAX_VALUE = 100;
	final double MAX_VAL_DOUBLE = 1.0 * MAX_VALUE;
	final int MAX = max(arr, len);
	final String NAME = "Max";
	final GameObj foo = bar;
	final boolean FOO = !bar || (p && !q);
	final int N = 1 - a * ( b + c ) / 2;
	final double WIDTH = ct.getWidth();
	final int X0 = x[0];
	final boolean FOO = bar[i].x + Math.sqrt(z);

	// "func", 		access, retType, "ID", "(", paramList, ")"
	public void foo()
	public int foo()
	public boolean foo2(double x)
	public double foo(int[] arr)
	public String foo_bar(double x1, boolean b_2, GameObj gameObj)
	public GameObj fooBar(GameObj[] objs, boolean [] bs, double []ds, int []  is)
	public int[] foo()
	public double[] foo()
	void foo()
	int foo123()
	boolean foo2(double x)
	double foo(int[] arr)
	String foo_bar(double[] x1s, boolean b_2, GameObj gameObj)
	GameObj fooBar(GameObj obj, boolean [] bs, double []ds, int []  is)
	GameObj[] myMethod(GameObj[] objs)

	// "begin",			"{"
	{
	
	// "end",			"}"
	}

	// "if",			"if", "(", expr, ")"
	if (true)

	// "elseif",		"else", "if", "(", expr, ")"
	else if ( true )

	// "else"
	else

	// "return",			"return", expr, ";"
	return 0;

	// "do"
	do

	// "while",				"while", "(", expr, whileEnd
	while (true)
	while (true);

	// "for",				"for", "(", forControl, ")"
	// -- forControl "three"
	for ( i = 0 ; i < n ; i++ )
	for ( int i = 0 ; i < n ; i++ )
	for ( i = 0 ; ; )
	for ( int i = 0 ; ; )
	for ( ; i < n ; )
	for ( ; ; i++ )
	for ( ; ; )
	// -- forControl "array"
	for ( GameObj g : gameObjs )
	
	// "arrayInit",		"ID", "[", "]", "ID", "=", arrayInit, ";"
	int[] a = {};
	double[] a = { 1 };
	boolean[] a = { 1, 2, 3 };
	GameObj[] a = new GameObj[100];
	
	// "arrayDecl",		"ID", "[", "]", idList, ";"
	String[] a;
	int[] a, b, c;
	
	// "importCode12",	"import", "ID", ".", "*", ";"
	import Code12.*;
	
	// "class",			"class", "ID",
	class Foo
	
	// "classUser",		"class", "ID", "extends", "ID"
	class TestProgram extends Code12Program
	
	// "classUserPub",	"public", "class", "ID", "extends", "ID"
	public class TestProgram extends Code12Program
	
	// "main",			"public", "static", "void", "ID", "(", "ID", "[", "]", "ID", ")"
	public static void main(String[] args)
	
	// "Code12Run",		"ID", ".", "ID", "(", "new", "ID", "(", ")", ")", ";"
	Code12.run(new TestProgram());
	
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
*/              // close comment without open
int i; /* /* */ // nested block comments
@               // invalid character
foo('a');       // char literals not supported
foo(" );        // unclosed string literal 
foo("\);        // unclosed string literal ending in backslash
s = "\          // unclosed string literal ending in backslash
s = "\";        // unclosed string literal from escaped double quote
s = "\ ";       // illegal escape character
s = "\r";       // unsupported escape sequence
interface foo   // unsupported reserved word
double 1stNumber; // variable name starting with a number
x = obj.1stNumber; // field name starting with a number
// Using reserved words as identifiers
int abstract;
int break;
int case;
int catch;
double class;
boolean const;
boolean continue;
boolean default;
String do;
GameObj else;
GameObj enum;
int[] extends;
double final;
double finally();
boolean foo(int for);
for(int do = 0; do < 10; do++)
String goto;
String if;
GameObj implements;
int import;
int instanceof;
int interface;
int native;
int new;
int package;	
int private;	
int protected;
int public;	
int return()
int static;	
int strictfp;	
int super;
int switch;	
int synchronized;	
int this;	
int throw;	
int throws;	
int transient;
int try;	
int volatile;	
int while;
boolean true;
boolean false;
int null;

void foo.x()    // function definition with . as part of identifier
x = 10          // missing ; in stmt
int x = 10		// missing ; in varInit
int x 			// missing ; in varDecl
final int x = 10 // missing ; in constInit
foo(x, );       // missing expr in exprList
f00()++;		// ++ applied to non-lvalue
--x.foo();		// -- applied to non-lvalue
x = / b;		// missing expr before binary op
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
x = 3.141592ee0;// Invalid exponential notation
x = 3.141592EE0;// Invalid exponential notation
x = 3e; 		// Invalid exponential notation
x = .3E; 		// Invalid exponential notation
foo(x,          // (incomplete line continued below)
y)              // missing ;
x = (a + b + c / 3; 	// missing closing parenthesis
x = foo(y, bar(z, w); 	// missing closing parenthesis w/ nested parentheses
x = a + b + c ) / 3; 	// missing openning parenthesis
if ( i == 1 	// missing closing parenthesis with if
if ( i == 1 ); 	// if statment ended by ;
for ( i=0; i<n; i++); 	// for() followed directly by ;
x + 1 = x; 		// confusing left hand side an right hand side of assignment
1000 = count; 	// confusing left hand side an right hand side of assignment
if ( x => 3 ) 	// => instead of <=
if ( x =< 5 ) 	// =< instead of >=.
elseif( x > 2 ) // elseif instead of else if
for(int i=0, i<n, i++) 	// commas in place of semicolons
for(int i=0; i<n, i++) 	// comma in place of semicolon
for(int i=0: i<n: i++) 	// colons in place of semicolons
for{int i=0; i<n; i++} 	// {} in place of ()
for (int i==0; i<n; i++)// == instead of =
for( x : arr ) 			// forgetting variable type
for( int x; arr ) 		// using ; instead of : 
for( int[] x : arr )
for( int x : arr[] )
for( arr : int x )
double foo(x, y, z) 	// missing variable types for arguments in function definition
double foo[i]()			// index on function identifier
ct.println; 			// missing parenteses for function call without arguments
foo(int x, double y, GameObj z) 	// missing return type in function definition
foo(int x, double y, GameObj z); 	// supplying variable types in function call
boolean foo(int x, double y, GameObj z); // semicolon after function declaration
String s = 'Hello'; 	// '' in place of "" for strings
String s = "A long string
            on more than one line";
ct.println("He said "Hello""); 	// not escaping double quotes in a string literal
newObj() = oldObj; 				// assigning to a function value
f = void foo()					// mixing assignment and function declaration
def func(x):					// Python syntax 
GameObj circle = new ct.circle(0,0,10); // new keyword not needed
intArr = {1, 2, 3}; // trying to assign value to array using initialization syntax
int intArr = {1, 2, 3}; // missing []

// Unsupported Java syntax
// --------------------------------------------------------------------------------
int x = 1, y = 2, z = 3;      // declaring and initializing multiple variables
import java.io.PrintWriter;   // import other than Code12.*
protected int secretVar;        // protected access
time %= 3600;                 // %= operator
int numberOfDucks = (turboMode ? 100 : 1); // ?: operator
char ch = 'a'; 	// char type
while(foo) { 	// opening { in control structure not on it's own line
i++; } 			// closing } not on it's own line
String s = "A long string" +
           "on more than one line using concatenation";
x = a; y = b; 	// more than one statement on a single line
if (x == 0) ct.println("x is zero"); // control structures must be on their own lines
double getVariable() { return variable; } // {} must start and end on their own lines
switch (choice)
continue;
a[i++] = b[i++]; 	// increment/decrement only supported as statements 
foo.obj.group.equals("targets"); 		// more than 2 chained fields
input.toLowerCase().equals("quit"); // indexing after function call
newBullet().ySpeed = 0;
final int N; 	// constant declaration without initialization
for (int i = 0, int j = 0; ; ) // Comma in forInit, forNext
for ( ; ; i++, j++ ) 	// Comma in forInit, forNext
int _var; // variable indentifiers starting with underscore
int $var; // $
double pay$;
int x[];	// arrays must be declared with [] between type and identifier
int _func() // function names starting with underscore
public abstract class Account 
assert x != null : "x variable is null";
case 0 :
catch(Exception e)
continue;
default :
enum WeekDays
goto
finally
public class C implements I
if (x instanceof y)
public interface I
native void foo()
package P;
public static int x;
protected int x;
static int x = 10;
strictfp void foo()
super.foo();
switch (x)
synchronized(sync_object)
this.x = x;
throw e;
void foo() throws Exception
transient int x;
try
volatile int x = 10;
