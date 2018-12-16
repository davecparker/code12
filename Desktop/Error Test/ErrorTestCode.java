// ERROR "Code12 does not support importing"
import java.util.Scanner;
// ERROR "The class header shouldn't be indented"
	class ErrorTest extends Code12Program
// ERROR "should not be indented"
		{
	int classLevelInt = 0;
	double classLevelDouble = 0;
	boolean classLevelBoolean = false;
	String classLevelString = "";
	boolean classLevelBoolean2 = classLevelString.equals("");
	int classLevelStringLength = classLevelString.length();
	GameObj classLevelGameObj;
	int[] classLevelIntArr = new int[10];
	int classLevelIntArrSub0 = classLevelIntArr[0];
	int classLevelIntArrLength = classLevelIntArr.length;
	GameObj classLevelUnassignedVar;
	// ERROR "API functions cannot be called before start()"
	GameObj varFromCtCallBeforeStart = ct.rect(0, 0, 10, 10);
	// ERROR "User-defined functions cannot be called before start()"
	GameObj intVarFromUserMethod = intMethod();
	int myVar = 1;
	// ERROR "Code12 API functions cannot be called before start()"
	GameObj button = ct.text("START", 0, 0, 10);
	// ERROR "cannot be called before start()"
	int intResult = intFunc();
	// ERROR "Class-level variable and function blocks should all have the same indentation"
		int overIndentedInstanceVar;
	// ERROR "Class-level variable and function blocks should all have the same indentation"
int underIndentedInstanceVar;
	// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
	int[] classLevelMultilineIntArray1 = { 1,
	2 };
	// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
	int[] classLevelMultilineIntArray2 = { 1,
		2,
	3 };
	// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
	int[] classLevelMultilineIntArray3 = new int[ Math.max(1,
	2) ];
	// ERROR "double cannot be assigned to an int"
	int classLevelVarTypeMismatchIntDouble = 0.1;
	// Error-free class-level variables
	final int MAX_ENEMIES = 100;
	int numEnemies = Math.min(1000, MAX_ENEMIES);
	double[] doubleArr = { 1.0,
		2.0,
		3.0 };
	GameObj leftWall, rightWall, topWall, bottomWall;
	GameObj[] enemies;
	public GameObj[] friends = new GameObj[MAX_ENEMIES];
	private int myPrivateVar;
	// ERROR "operator is not supported"
	int instanceIntVar1 = 2 | 1;
	// ERROR "operator is not supported"
	int instanceIntVar2 = 2 ^ 1;
	// ERROR "operator is not supported"
	int instanceIntVar3 = 2 & 1;
	// ERROR "operator is not supported"
	int instanceIntVar4 = 2 >>> 1;
	// ERROR "operator is not supported"
	int instanceIntVar5 = 2 >> 1;
	// ERROR "operator is not supported"
	int instanceIntVar6 = 2 << 1;
	// ERROR "Use == to compare for equality"
	boolean instanceBoolVar1 = (1 + 1 = 2);
	// ERROR "Cannot compare"
	boolean instanceBoolVar2 = false == 0;
	// ERROR "Cannot compare"
	boolean instanceBoolVar3 = 1 == button;
	// ERROR "can only apply to numbers"
	boolean instanceBoolVar4 = 1 > false;
	// ERROR "can only apply to boolean values"
	boolean instanceBoolVar4 = (1 + 1 == 2) || doubleArr[0];
	// ERROR "Integer divide"
	int instanceIntVar7 = -10 / 3;
	// ERROR "Numeric operator"
	double instanceDblVar = classLevelString - ".txt";
	// ERROR "Numeric operator"
	int instanceIntVar = button.group % button;
	// ERROR "Numeric operator"
	double instanceDblVar2 = button / 10;
	// ERROR "Numeric operator"
	double instanceDblVar3 = button * 2;
	// ERROR "Numeric operator"
	double instanceDblVar4 = 100 - button;
	// ERROR "can only apply to numbers or Strings"
	double classLevelDouble = 1 / (classLevelBoolean + classLevelInt + 1);
	// ERROR "can only apply to numbers or Strings"
	String classLevelString = classLevelBoolean + button;
	// ERROR "can only apply to numbers or Strings"
	int classLevelInt = classLevelBoolean + classLevelDouble / 2;
	// ERROR "can only apply to numbers or Strings"
	int classLevelInt = classLevelBoolean + classLevelInt - 1;
	// ERROR "can only apply to numbers or Strings"
	boolean classLevelBoolean = classLevelBoolean + classLevelBoolean;
	// ERROR "can only apply to numbers or Strings"
	double classLevelDouble = button + button;
	// ERROR "must be assigned before it is used"
	double classLevelDouble = 2 + classLevelGameObj;
	// ERROR "Undefined variable"
	double classLevelDouble = rect.x + false;
	// ERROR "The (+) operator can only apply to numbers or Strings"
	double[] arrFromPlusOperator = doubleArr + 1;
	// ERROR "The (+) operator cannot be applied to arrays"
	double[] arrFromPlusOperator2 = friends + classLevelString;
	// ERROR "Names are case-sensitive, known name is"
	String[] classLevelArrInit = { classLevelString, classlevelInt, classLevelDouble };
	// ERROR "Array initializers must all be the same type"
	String[] classLevelArrInit = { classLevelString, classLevelInt, classLevelDouble };
	// ERROR "Code12 does not support arrays of arrays"
	String[] arrInit9 = { new String[classLevelInt] };
	// ERROR "objects with new"
	String classLevelNewString = new String();
	// ERROR "count must be an integer"
	int[] intArrDoubleCount = new int[10.0];
	// ERROR "not operator"
	boolean	boolVarNotInt = !classLevelInt;
	// ERROR "negate operator"
	String negateString = -classLevelString;
	// ERROR "Undefined variable"
	double intCastOnInt1 = (int) (undefinedVar + 314);
	// ERROR "already of type int"
	double intCastOnInt2 = (int) (classLevelInt + 314);
	// ERROR "(int) type cast can only be applied to type double"
	GameObj[] classLevelGameObjArr = new GameObj[2 * (int) classLevelString];
	// ERROR "already of type double"
	double doubleCastOnDouble = (double) (10 * 2.3);
	// ERROR "must be assigned before it is used"
	String stringCast = (String) classLevelGameObj.group;
	// ERROR "Type casts can only be (int) or (double)"
	String stringCast2 = (String) classLevelDouble;
	// ERROR "Unknown data field of Math class"
	double unknownMathField = Math.P;
	// ERROR "Too many parameters passed"
	double classLevelMathInitErr = Math.min(1, 2, 3);
	// ERROR "requires 1 parameter"
	double classLevelMathInitErr2 = Math.sin();
	// ERROR "requires 2 parameters"
	double classLevelMathInitErr3 = Math.pow(2);
	// ERROR "Method call on invalid type"
	int intVarMethodCall = classLevelInt.delete();
	// ERROR "Unknown method"
	String stringSize = classLevelString.size();
	// ERROR "Unknown or unsupported Math method"
	double unknownMathMethod = Math.foo();
	// ERROR "does not return a value"
	String greeting = System.out.println("hello");
	// ERROR "must include a type"
	undeclaredClassLevelVar = 0;
	// ERROR "differs only by upper/lower case from existing variable"
	boolean classlevelBoolean = true;
	// ERROR "already defined"
	int classLevelInt;
	// ERROR "Names are case-sensitive, known name is"
	double caseSentiveClassLevelVar = classlevelint + 1;
	// ERROR "variable names should start with a lower-case letter"
	int Starts_with_capital_letter_var_class_level;
	// ERROR "variable names should start with a lower-case letter"
	double StartsWithCapitalLetterVarWithAssignmentClassLevel = 3.14;
	// ERROR "variable names should start with a lower-case letter"
	GameObj[] StartsWithCapitalGameObjArr = new GameObj[10];

	// TODO: Need more tests involving instance (class-level) variables

	public static void main(String[] args)
	{ 
		// Note: errors in main are ignored
		// Standard code here
		Code12.run(new ErrorTest());
	}

	// user defined functions
	void emptyFunc()
	{
	}
	void voidFunc()
	{
		int i = 0;
	}
	int intFunc()
	{
		int i = 1;
		return i;
	}
	double dblFunc()
	{
		double d = 0.0;
		return d;
	} 
	boolean boolFunc()
	{
		boolean b = true;
		return b;
	}
	String strFunc()
	{
		String s = "";
		return s;
	}
	GameObj gObjFunc()
	{
		return ct.circle(0.0, 0.0, 1.0);
	}
	int[] intArrFuncInt(int n)
	{
		return new int[n];
	}
	int intFuncInt(int i)
	{
		return i * 2 + 1;
	}
	double dblFuncIntDbl(int i, double d)
	{
		return i + d;
	}
	boolean boolFuncBoolStringGameObj(boolean b, String s, GameObj g)
	{
		return b && s.equals("") && g.visible;
	}
	int recursiveFunc(int i)
	{
		if (i <= 0)
			return 0;
		return 1 + recursiveFunc(i - 1);
	}
	void multiLineFuncDecl( int arg1,
							double arg2,
							boolean arg3 )
	{
		ct.log(arg1, arg2, arg3);
	}

	// ERROR "Return type of start function should be void"
	public int start()
	{
		// These line are all OK
		// constants
		final int LIMIT = 100;
		// int, double, boolean, and String variable declarations and assignments;
		int i = 3;
		i=-5;
		i++;
		i = i + 1;
		i += 1;
		i -= 2;
		i *= 3;
		i /= 4;
		i = intFunc();
		i = intFuncInt(i - (i + i) - 345 * i);
		int foo = i + 4;
		int score = 500;
		int j,k;
		double exponentialNumberNoDot = 12e10;
		double exponentialNumberWithDot = 3.42e2;
		double expontialNumberWithDecimalPlaces = 6.62e-34;
		double d = 3.14;
		d = 100;
		d = .5;
		d = 1.2345e6;
		d = 1.2345e+67;
		d = .12e0;
		d = -.123e-123;
		d=-.5;
		d = d / 2;
		d ++;
		d += 0.5;
		d -= 7;
		d *= 8;
		d /= 8.0;
		double d2 = 3;
		double d3 = d + 2 * (d2 + d);
		double x1, x2, y1, y2;
		x1 = 1;
		x2 = 2.0;
		y1 = .5e+1;
		y2 = -.5e-1;
		double eps = 1e-4;
		String name = "Einstein";
		boolean b = true;
		boolean b2 = false;
		boolean b3 = b || b2;
		String s = "A string variable";
		s = s;
		s = null;
		// arrays
		String[] colors = { "black", "white", "red", "green", "blue" };
		i = 100;
		String[] strArr = new String[i];
		strArr = colors;
		int[] intArr = {1, 2, 3};
		intArr = new int[100];
		int[] intArr2 = new int[s.length()];
		intArr = intArr2;
		double[] dblArr = {1.1, 2.2, 3.3};
		double[] dblArr2 = new double[100];
		dblArr = dblArr2;
		GameObj[] gObjArr = new GameObj[i * 2];
		// user defined functions
		voidFunc();
		i = intFunc();
		d = dblFunc();
		b = boolFunc();
		s = strFunc();
		GameObj gObj = gObjFunc();
		intArr = intArrFuncInt(i);
		i = intFuncInt(i);
		d = dblFuncIntDbl(i, d);
		b = boolFuncBoolStringGameObj(b, s, gObj);
		i = recursiveFunc(2);
		// expressions
		i = 5 / 1;
		i = 100 / 20;
		i = i + i;
		i = i - i;
		i = i * i;
		i = i % i;
		i = i * i + i - i;
		i = i * ((i + i) - i);
		d = i;
		d = d + i;
		d = d - i;
		d = d * i;
		d = d / i;
		d = d % i;
		d = i + d;
		d = i - d;
		d = i * d;
		d = i / d;
		d = i % d;
		d = d + d;
		d = d - d;
		d = d * d;
		d = d / d;
		d = d % d;
		d = i - i + i * i;
		d = d + i * i - i;
		d = i * i - d * d;
		d = (i * i - d * d);
		s = s + s;
		s = s + s + "s";
		s = s + i;
		s = s + d;
		s = s + b;
		s = s + gObj;
		s = i + s;
		s = d + s;
		s = b + s;
		s = gObj + s;
		b = b;
		b = !b;
		b = (b);
		b = i == i;
		b = i == d;
		b = d == i;
		b = d == d;
		b = b == b;
		b = gObj == gObj;
		b = i != i;
		b = i != d;
		b = d != i;
		b = d != d;
		b = b != b;
		b = gObj != gObj;
		b = i < i;
		b = i > i;
		b = i <= i;
		b = i >= i;
		b = i < d;
		b = i > d;
		b = i <= d;
		b = i >= d;
		b = d < i;
		b = d > i;
		b = d <= i;
		b = d >= i;
		b = d < d;
		b = d > d;
		b = d <= d;
		b = d >= d;
		b = b || b;
		b = b && b;
		b = 1 < 2;
		b = 1.1 <= 2;
		b = 1 > 2;
		b = 1 >= 2.2;
		b2 = b2 || b3 && b == b;
		b = i % 2 == 0;
		b = (b || b) && b;
		b = (1 + 1 == 2) && (Math.PI - 3.14159 < 0.0001);
		// if statements
		if (i == 0)
			ct.setBackColor(colors[i]);
		else if (i <= 10)
			i++;
		else
			i *= 5;

		if(i > 0)
		{
			j = 0;
			k = 0;
		}
		else if(i<=10)
		{
			d = 7;
			ct.setSoundVolume(1);
		}
		else if (b)
			i++;
		else
		{
			String tempStr = "I'll be ";
			tempStr = tempStr + "out of scope soon";
		}
		if ( ct.isError(Math.tan(d)) && ct.distance(x1, y1, x2, y2) <= eps)
			ct.println("oops");
		// for loops
		for(;false;)
			for(;;)
				for(i=0;;)
					for(;i<10;)
						for(;;i++)
							for(;b;)
								d = 0;
		for (int ii = 0; ii < 10; ii++)
		{
			for (int jj = 0; jj != 10; jj+=1)
				if ( ii == 0 || jj == 0 )
					break;
			break;
		}
		for (int ii = 0; ii < 10; ii++)
		{
			for (int jj = 0; jj != 10; jj+=1)
			{
				if ( ii == 0 && jj == 0 )
				{
					intArr[ii] = 0;
					break;
				}
				break;
			}
			break;
		}
		double xVar = 0;
		double yVar = 1;
		for (double dx = .1; xVar < 1; xVar += dx)
			for(double dy=-.5;yVar>0;yVar+=dy)
				d = xVar + dx - yVar / dy;
		intArr = new int[1];
		for (int a : intArr)
			a = 0;
		// while loops
		while(b)
			b = false;
		while ( b )
		{
			voidFunc();
			i++;
			b = false;
		}
		do
			b = false;
		while (b);
		do
		{
			b = false;
		}
		while (b);
		// Code12 API -- Text Output
		ct.print("Hello world");
		ct.print("Hello" + " " + "world");
		ct.print("Hello world\n");
		ct.print(i);
		ct.print(d);
		ct.print(b);
		ct.print("i = " + i);
		ct.print("d = " + d);
		ct.print(name);
		ct.print("Hello" + " " + name);
		GameObj circleObj = ct.circle(50, 50, 20);
		ct.print(circleObj);
		ct.println("Hello world");
		ct.println("Hello" + " " + "world");
		ct.println("Hello world\n");
		ct.println(i);
		ct.println(d);
		ct.println(b);
		ct.println("i = " + i);
		ct.println("d = " + d);
		ct.println(name);
		ct.println("Hello" + " " + name);
		ct.println(circleObj);
		ct.log(i);
		ct.log(d);
		ct.log(b);
		ct.log(circleObj);
		GameObj obj2 = circleObj;
		GameObj obj3 = obj2;
		ct.log("circleObj = ", circleObj, "obj2 = ", obj2, "obj3=", obj3, 3.14, Math.PI, 42);
		ct.logm("message", null );
		ct.logm("message", obj2, obj3);
		ct.setOutputFile("output.txt");
		ct.setOutputFile("output/nameList.txt");
		String outputFilename = "output.txt";
		ct.setOutputFile(outputFilename);
		// Code12 API -- Alerts and Input Dialogs
		ct.showAlert("alert meassage");
		String message = "alert!";
		ct.showAlert(message);
		int n = ct.inputInt("enter a number: ");
		n = ct.inputInt("enter a number: ");
		n = ct.inputInt(message);
		double x = ct.inputNumber("enter a number: ");
		x = ct.inputNumber("enter a number: ");
		x = ct.inputNumber(message);
		boolean quit = ct.inputYesNo("Quit?");
		quit = ct.inputYesNo(message);
		String inputStr = ct.inputString("Quit?");
		inputStr = ct.inputString("Quit?");
		inputStr = ct.inputString(message);
		// Code12 API -- Screen Management
		ct.setTitle("Title");
		String title = "Title";
		ct.setTitle(title);
		ct.setTitle(title + " " + i);
		ct.setTitle(title + d);
		ct.setHeight(100.0 * 9 / 16);
		ct.setHeight(i);
		ct.setHeight(d);
		ct.setHeight(i * d + 5 * 4);
		double height = ct.getHeight();
		height = ct.getHeight();
		double width = ct.getWidth() * 0.5 - 10;
		width = ct.getWidth();
		double pxPerUnit = ct.getPixelsPerUnit();
		pxPerUnit = ct.getPixelsPerUnit();
		int pixelWidth = ct.round( ct.getWidth() * ct.getPixelsPerUnit() );
		int pixelHeight = ct.round( ct.getHeight() * ct.getPixelsPerUnit() );
		String currentScreen = ct.getScreen( );
		currentScreen = ct.getScreen( );
		ct.clearScreen();
		ct.clearGroup("targets");
		ct.clearGroup("");
		ct.setBackColor("orange");
		ct.setBackColor("light blue");
		String backColor = "red"; 
		ct.setBackColor(backColor);
		ct.setBackColorRGB(255, 0, 0);
		ct.setBackColorRGB(i, i, i);
		ct.setBackImage("background.png");
		ct.setBackImage("C:\\Users\\ben\\Pictures\\landscape.jpg");
		String filename = "landscape.png";
		ct.setBackImage(filename);
		// Code12 API -- GameObj Creation
		x = 50;
		double y = 50;
		double diameter = 10;
		GameObj circle = ct.circle(50, 20, 10);
		circle = ct.circle(50.0, 20.0, 10.0);
		circle = ct.circle(50, 20, 10.5, "blue");
		circle = ct.circle(x, y, diameter);
		String color = "green";
		circle = ct.circle(x, y, diameter, color);
		GameObj rect = ct.rect(x, y, width, height);
		rect = ct.rect(x, y, width, height, color);
		rect = ct.rect(50.0, 33.3, 11.2, 23.890);
		rect = ct.rect(50, 33, 11, 23, "green");
		GameObj line = ct.line( i, d, width, height );
		line = ct.line( x1, y1, x2, y2, color );
		line = ct.line( 0.0, .0, 100.0, 95.0 );
		line = ct.line( 0, 0, 100, 95, "red" );
		GameObj text = ct.text( s, x, y, height );
		text = ct.text( s, x, y, height, color );
		text = ct.text( "Score: " + score, 20.0, 90.0, 10.0 );
		text = ct.text( "Score: " + score, 20, 90, 10, "purple" );
		GameObj img = ct.image( filename, x, y, width );
		img = ct.image( "car.png", 42, 25, 38.7 );
		img = ct.image( "C:\\Users\\john\\Pictures\\car.jpg", 42, 25, 38 );
		GameObj[] objs = { circle, rect, line, text, img };
		img = rect;
		// Code12 API -- Mouse and Keyboard Input
		boolean mouseClicked = ct.clicked();
		if (ct.clicked())
			mouseClicked = ct.clicked();
		if ( ct.clickX() > 50 )
			x = ct.clickX();
		x = ct.clickX();
		if ( ct.clickY() <= x )
			y = ct.clickY();
		y = ct.clickY();
		String keyName = "space";
		boolean keyPressed = ct.keyPressed(keyName);
		if (ct.keyPressed(keyName))
			if (ct.keyPressed("up"))
				keyPressed = ct.keyPressed("up");
		if ( ct.charTyped("+") )
			x++;
		String ch = "+";
		if ( ct.charTyped(ch) )
			b = ct.charTyped("+");
		b = ct.charTyped(ch);
		// Code12 API -- Audio
		b = ct.loadSound( filename );
		ct.loadSound("pow.wav");
		if (ct.loadSound("sounds/ding.mp3"))
			ct.sound("sounds/ding.mp3");
		ct.sound(filename);
		ct.setSoundVolume(d);
		ct.setSoundVolume(1);
		ct.setSoundVolume(0.5);
		// Code12 API -- Math and Misc.
		i = ct.random(i, i);
		i = ct.random(0, 100);
		i = ct.round(d);
		i = ct.round(i);
		i = ct.round(1.62);
		i = ct.round(d * i);
		d = ct.round(1 + d * i);
		d = ct.round(ct.distance(x1, y1, x2, y2));
		d = ct.roundDecimal(d, i);
		d = ct.roundDecimal(d * i + 1, i * 2);
		d = ct.roundDecimal(2.71828182846, 2);
		d = ct.roundDecimal(ct.distance(x1, y1, x2, y2), 1);
		i = ct.intDiv(i, i);
		i = ct.intDiv(5, 2);
		b = ct.isError(d);
		b = ct.isError(d / d);
		b = ct.isError(d / i);
		b = ct.isError(0.0 / 0);
		d = ct.distance(circle.x, circle.y, rect.x, rect.y);
		if (ct.distance(circle.x, circle.y, rect.x, rect.y) < (circle.getWidth()) / 2)
			i = ct.getTimer();
		i = ct.getTimer() - i;
		d = ct.getVersion();
		ct.round(ct.getVersion());
		// Code12 API -- Type Conversion
		i = ct.toInt(d);
		i = ct.toInt(d * i);
		i = ct.toInt(.707);
		i = ct.toInt(Math.PI);
		i = ct.toInt(6.0221409e+2);
		i = ct.parseInt(s);
		i = ct.parseInt("345");
		b = ct.canParseInt(s);
		b = ct.canParseInt("12345");
		while(ct.canParseInt(s))
			d = ct.parseNumber(s);
		d = ct.parseNumber("123.45") * 100;
		b = ct.canParseNumber("543.210");
		while(ct.canParseNumber(s))
			s = ct.formatDecimal(d);
		s = ct.formatDecimal(d, i);
		s = ct.formatDecimal(d, ct.intDiv(2*i,i));
		s = ct.formatDecimal(6.0221, 7) + ":00";
		s = ct.formatInt(i);
		s = ct.formatInt(i + 1, j + k);
		// Code12 API -- GameObj Public Data Fields
		img.x = 3;
		rect.x = circle.y - 10;
		rect.visible = false;
		circle.visible = rect.visible;
		line.group = s;
		circle.group = "dots";
		rect.group = circle.group;
		line.visible = s.equals("hello") || s.equals("world") && s.indexOf(line.group) == 1;
		// Code12 API -- GameObj Methods
		s = rect.getType();
		ct.println(text.getText() + "more text");
		img.setText("racecar.png");
		text.setText("Score: " + d);
		text.setText("Score: " + i);
		ct.log(line.toString());
		img.setSize(img.getWidth() * 1.1, img.getHeight() * 1.1);
		rect.setSize(10, 30);
		d = img.getHeight();
		circle.setSpeed(0, 3);
		rect.setSpeed(0.1, d / 2);
		text.align(s);
		text.align("left");
		text.align("right");
		circle.setFillColor("light" + s);
		circle.setFillColor(text.getText());
		circle.setFillColorRGB(i,j,k);
		rect.setLineColor(colors[i]);
		rect.setLineColorRGB(i, 255 - i, 0);
		line.setLineWidth(i);
		line.setLineWidth(3);
		i = rect.getLayer();
		if (rect.getLayer() >= circle.getLayer())
			b =	colors[rect.getLayer()].equals("green");
		img.setLayer(-42);
		img.delete();
		img.setClickable(true);
		circle.setClickable(false);
		rect.setClickable(rect.x > 0);
		b = img.clicked();
		b = img.containsPoint( ct.clickX(), ct.clickY() );
		if ( img.containsPoint( ct.clickX(), ct.clickY() ) )
			while (img.hit(rect))
				b = img.hit(rect) == true;
		// Java Math Class Methods and Fields Supported
		double e = Math.E;
		double pi = Math.PI;
		if (Math.abs(rect.x - img.x) < eps)
			i = Math.abs(i);
		d = Math.acos(-0.5);
		d = Math.asin(Math.sqrt(3)/2);
		d = Math.atan(1/Math.sqrt(2));
		d = Math.atan2(ct.clickX() - img.x, ct.clickY() - img.y);
		d = Math.ceil(d);
		d = Math.cos(Math.PI / 2);
		d = Math.cosh(Math.PI * 2);
		d = Math.exp(2 * Math.PI + 1);
		d = Math.floor(-1.67);
		d = Math.log(32);
		d = Math.log10(d);
		d = Math.max(d, d);
		i = Math.max(i, i);
		d = Math.min(d, d);
		i = Math.min(i, i);
		d = Math.pow(d, d);
		d = Math.sin(d);
		d = Math.sinh(d);
		d = Math.sqrt(d);
		d = Math.tan(d);
		d = Math.tanh(d);
		// Java String Class Methods Supported
		i = s.compareTo(s);
		b = s.equals(s);
		i = s.indexOf(s);
		i = s.length();
		s = s.substring(i);
		s = s.toLowerCase();
		s = s.toUpperCase();
		s = s.trim();
		// multi-line statements
		GameObj[] coins, 
				  walls;
		int[] multilineArrayInit = { 1,
									 2, 
									 3 };
		ct.log( 1,
				2,
				3 );
		if ( ct.random( 1, 2 ) ///
				== 1 )
			ct.println("heads");
		ct.log( 1, ct.random( 1,
							  100 ), ///
				3, 4 );
		return 0;
	}

	// ERROR "Class-level variables must be defined at the beginning of the class"
	double newWidth = ct.getWidth();

	// ERROR "cannot start with an underscore"
	void _fn()
	// ERROR "Unexpected or extra {"  (because the function header was bad)
	{
		ct.println("Hello world");
	}

	// ERROR "must be declared starting with"
	void update()
	{
		// ERROR "void functions cannot return a value"
		return 0;
	}
	// ERROR "("boolean" is a type name)"
	double fooBad(int i, GameObj boolean)
	{
		return 0;
	}
	// ERROR "("GameObj" is a type name)"
	boolean bar(String s, GameObj gameObj)
	{
		// ERROR "Incorrect case for constant"
		return TRUE;
	}
	// ERROR "("double" is a type name)"
	int Double(int x)
	{
		return 2 * x;
	}

	// ERROR "already defined"
	void voidFunc(int i)
	{
	}
	void func()
	{
	}
	// ERROR "differs only by upper/lower case from existing function"
	void FUNC()
	{
	}
	// ERROR "should start with a lower-case letter"
	void AnotherFunc()
	{
	}	
	// ERROR "differs only by upper/lower case from existing function"
	void anotherfunc()
	{
	}

	void expectedErrors()
	{
		int intVar = 1;
		double dblVar = 1.0;
		boolean boolVar = false;
		String strVar = "a";
		GameObj objVar = ct.circle(0,0,10);
		int[] intArr = {1, 2, 3};
		GameObj[] objArr = { objVar };

		// ERROR "does not return a value"
		intVar = objVar.setText("circle");
		// ERROR "does not return a value"
		double screen = ct.setScreen("menu");
		// ERROR "does not return a value"
		boolVar = ct.setHeight(150);
		// ERROR "does not return a value"
		strVar = voidFunc();
		// ERROR "does not return a value"
		GameObj title = ct.setTitle("title");

		// ERROR "Value of type int cannot be assigned to type boolean"
		boolVar = intVar;
		// ERROR "Value of type int cannot be assigned to type boolean"
		boolean b = intFuncInt(2);
		// ERROR "Value of type int cannot be assigned to type boolean"
		objVar.visible = 0;
		// ERROR "Integer value cannot be assigned to a String"
		String s = intVar;
		// ERROR "Value of type int cannot be assigned to type GameObj"
		objVar = intVar;
		
		// ERROR "Value of type double cannot be assigned to an int"
		int i = 3.4;
		// ERROR "Value of type double cannot be assigned to an int"
		i = 1.2;
		// ERROR "Value of type double cannot be assigned to an int"
		i = 10 * 3.4;
		// ERROR "Value of type double cannot be assigned to an int"
		int j = 5 + 3.14;
		// ERROR "Value of type double cannot be assigned to an int"
		int plancksConst = 6.62e-34;
		// ERROR "Value of type double cannot be assigned to an int"
		int exponentialNumberNoDot = 12e10;
		// ERROR "Value of type double cannot be assigned to an int"
		int exponentialNumberWithDot = 3.42e2;
		// ERROR "Value of type double cannot be assigned to type boolean"
		objVar.visible = dblVar;
		// ERROR "Value of type double cannot be assigned to a String"
		strVar = 3.14;
		// ERROR "Value of type double cannot be assigned to type GameObj"
		objVar = dblVar;

		// ERROR "Value of type boolean cannot be assigned to type int"
		intVar = ct.clicked();
		// ERROR "Value of type boolean cannot be assigned to type double"
		objVar.x = boolVar;
		// ERROR "Value of type boolean cannot be assigned to type double"
		objVar.x = false;
		// ERROR "Value of type boolean cannot be assigned to type String"
		objVar.group = boolVar;
		// ERROR "Value of type boolean cannot be assigned to type GameObj"
		objVar = boolVar;

		// ERROR "A String cannot be assigned to an int"
		intVar = objVar.group;
		// ERROR "A String cannot be assigned to a double"
		objVar.y = "fast";
		// ERROR "Value of type String cannot be assigned to type boolean"
		boolVar = strVar;
		// ERROR "Value of type String cannot be assigned to type GameObj"
		GameObj score = "100 pts"; 		

		// ERROR "Value of type GameObj cannot be assigned to type int"
		intVar = objVar;
		// ERROR "Value of type GameObj cannot be assigned to type double"
		objVar.x = objVar;
		// ERROR "Value of type GameObj cannot be assigned to type boolean"
		boolVar = objVar;
		// ERROR "A GameObj cannot be assigned to a String"
		String circleStr = ct.circle(0,0,10);
		
		// ERROR "expects type int, but double was passed"
		int y = intFuncInt(2.3);
		// ERROR "expects type int, but double was passed"
		intVar = ct.random( 0.0, 10 );
		// ERROR "expects type int, but boolean was passed"
		intVar = ct.random( 0, false );
		// ERROR "expects type int, but String was passed" 
		ct.setBackColorRGB( "red", 0, 0 );
		// ERROR "expects type int, but String was passed" 
		objVar.setLayer( "front" );
		// ERROR "expects type int, but GameObj was passed"
		ct.roundDecimal( 3.14159, objVar );
		// ERROR "expects type int, but GameObj was passed"
		strVar.substring( objVar );

		// ERROR "expects type double, but boolean was passed"
		Math.pow( boolVar, 3 );
		// ERROR "expects type double, but String was passed"
		dblFuncIntDbl( 0, "pi" );
		// ERROR "expects type double, but String was passed"
		objVar.containsPoint( strVar, dblVar );
		// ERROR "expects type double, but GameObj was passed"
		Math.exp( objVar );

		// ERROR "Too many parameters"
		objVar.align( "left", 0 );
		// ERROR "expects type boolean, but double was passed"
		boolFuncBoolStringGameObj( dblVar, strVar, objVar );
		// ERROR "expects type boolean, but String was passed"
		boolFuncBoolStringGameObj( strVar, objVar, boolVar );
		// ERROR "expects type boolean, but GameObj was passed"
		boolFuncBoolStringGameObj( objVar, strVar, boolVar );

		// ERROR "expects type String, but int was passed"
		objVar.align(intVar);
		// ERROR "expects type String, but int was passed"
		intVar = ct.parseInt( 123 );
		// ERROR "expects type String, but int was passed"
		ct.circle(0, 0, 1, 1);
		// ERROR "expects type String, but int was passed"
		objVar.setText(1);
		// ERROR "expects type String, but double was passed"
		boolVar = ct.canParseInt( 1.0 );
		// ERROR "expects type String, but boolean was passed"
		boolVar = ct.canParseInt( boolVar );
		// ERROR "expects type String, but boolean was passed"
		objVar.align(true);
		// ERROR "expects type String, but GameObj was passed"
		strVar.equals( objVar );

		// ERROR "expects type GameObj, but int was passed"
		boolFuncBoolStringGameObj( boolVar, strVar, 42 );
		// ERROR "expects type GameObj, but double was passed"
		objVar.hit( 0.0 );
		// ERROR "expects type GameObj, but boolean was passed"
		objVar.hit( false );
		// ERROR "expects type GameObj, but String was passed"
		objVar.hit( "the wall" );
		
		// ERROR "requires 1 parameter"
		if (intFuncInt() > 0)
			voidFunc();
		// ERROR "requires 2 parameters"
		dblFuncIntDbl();
		// ERROR "requires 3 parameters"
		ct.circle();
		// ERROR "requires 4 parameters"
		ct.rect(0, 0, 10);
		// ERROR "requires 3 parameters"
		ct.circle(0, 0);
		// ERROR "Too many parameters passed"
		voidFunc(1);
		// ERROR "Too many parameters passed"
		ct.setBackColor(255, 0, 0);
		// ERROR "Too many parameters passed"
		objVar.delete(true);
		// ERROR "Too many parameters passed"
		objVar.setText("circle", "green");

		// ERROR "Integer divide"
		int k = 3 / 2;
		// ERROR "Integer divide"
		ct.random( intVar / intVar, intVar );
		// ERROR "Undefined variable"
		x = x + 1;
		// ERROR "Undefined variable"
		for (x = 0; x < 1; x++) 
			voidFunc();
		// ERROR "Undefined function"
		foo();
		// ERROR "already defined"
		int j = 3;

		int uninitializedVar;
		// ERROR "must be assigned before it is used"
		if (uninitializedVar < 0)
			uninitializedVar = 0;
		GameObj g;
		// ERROR "must be assigned before it is used"
		g.xSpeed = 1;

		// ERROR "Unknown type name"
		integer n = 100;
		// ERROR "Unknown type name"
		bool gameOver = false;
		// ERROR "Unknown function"
		GameObj r = ct.rectangle(0,0,10,10);
		// ERROR "Unknown field"
		objVar.isVisible = false;
		// ERROR "Unknown method"
		objVar.foo();

		// ERROR "Incorrect case for type name"
		string ch = "A";
		// ERROR "Incorrect case for type name"
		gameObj obj;
		// ERROR "Names are case-sensitive"
		ct.Circle(0,0,10);
		// ERROR "Names are case-sensitive"
		math.atan2(ct.clickX() - r.x, ct.clickY() - r.y);
		// ERROR "Names are case-sensitive"
		voidfunC();
		// ERROR "Names are case-sensitive"
		intvar = 2;

		// ERROR "Incorrect case for constant"
		strVar = Null;
		// ERROR "Incorrect case for constant"
		objVar = NULL;
		// ERROR "Incorrect case for constant"
		while(True)
			voidFunc();
		// ERROR "Incorrect case for constant"
		boolVar = TRUE;
		// ERROR "Incorrect case for constant"
		if (False)
			voidFunc();
		// ERROR "Incorrect case for constant"
		objVar.clickable = FALSE;

		// ERROR "Use == to compare for equality"
		if (i = 0)
			i = 0;
		// ERROR "cannot be assigned"
		int[] intArr2 = {1, 2, 3.14};
		// ERROR "Array initializers must all be the same type"
		double[] dblArr = {1, "two", 3.14};
		// ERROR "cannot be assigned"
		String[] strArr = new GameObj[100];
		// ERROR "cannot be assigned"
		boolean[] boolArr = intArrFuncInt(10);
		// ERROR "Array count must be an integer"
		intArr = new int[1.5];

		// ERROR "can only be applied to numbers"
		boolVar++;
		// ERROR "can only be applied to numbers"
		strVar++;
		// ERROR "can only be applied to numbers"
		objVar++;
		// ERROR "can only be applied to numbers"
		boolVar--;
		// ERROR "can only be applied to numbers"
		strVar--;
		// ERROR "can only be applied to numbers"
		objVar--;

		// ERROR "A for-each loop must operate on an array"
		for (int x : intVar)
			voidFunc();
		// ERROR "A for-each loop must operate on an array"
		for (double x : dblVar)
			voidFunc();
		// ERROR "A for-each loop must operate on an array"
		for (boolean x : boolVar)
			voidFunc();
		// ERROR "A for-each loop must operate on an array"
		for (String x : strVar)
			voidFunc();
		// ERROR "A for-each loop must operate on an array"
		for (GameObj x : objVar)
			voidFunc();
		// ERROR "A for-each loop must operate on an array"
		for (GameObj x : strVar)
			voidFunc();
		
		// ERROR "The loop array contains elements of type int"
		for (double x : intArr)
			voidFunc();
		// ERROR "The loop array contains elements of type GameObj"
		for (String x : objArr)
			voidFunc();

		// ERROR "Loop test must evaluate to a boolean"
		for ( ; intVar ; )
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; dblVar ; )
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; strVar ; )
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; objVar ; )
			voidFunc();

		do
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		while(intVar);

		// ERROR "Loop test must evaluate to a boolean"
		while(dblVar)
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		while(strVar)
			voidFunc();
		// ERROR "Loop test must evaluate to a boolean"
		while(objVar)
			voidFunc();

		// ERROR "Conditional test must be boolean"
		if(intVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		else if(intVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		if(dblVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		else if(dblVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		if(strVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		else if(strVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		if(objVar)
			voidFunc();
		// ERROR "Conditional test must be boolean"
		else if(objVar)
			voidFunc();

		// ERROR "Integer is a Java class name"
		Integer n = 100;
		// ERROR "Incorrect case for type name"
		Double d = 100.0;
		// ERROR "Incorrect case for type name"
		Boolean b = false;

		// ERROR "+= can only be applied to numbers"
		strVar += "hello";
		// ERROR "-= can only be applied to numbers"
		boolVar -= 1;
		// ERROR "*= can only be applied to numbers"
		objVar *= objVar;
		// ERROR "/= can only be applied to numbers"
		objVar /= 3.14;
		// ERROR "Expression for += must be numeric"
		intVar += "hello";
		// ERROR "Expression for -= must be numeric"
		dblVar -= ct.rect(0,0,1,2);
		// ERROR "Expression for *= must be numeric"
		intVar *= false;
		// ERROR "Expression for /= must be numeric"
		dblVar /= true;
		// ERROR "double cannot be assigned to int"
		intVar += dblVar;
		// ERROR "double cannot be assigned to int"
		intVar -= dblVar;
		// ERROR "double cannot be assigned to int"
		intVar *= dblVar;
		// ERROR "double cannot be assigned to int"
		intVar /= dblVar;
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		if (strVar == "s")
			voidFunc();

		// ERROR "operator is not supported"
		i = i ^ i;
		// ERROR "operator is not supported"
		i = i & i;
		// ERROR "operator is not supported"
		i = i | i;
		// ERROR "operator is not supported"
		i = i >> 2;
		// ERROR "operator is not supported"
		i = i << 2;
		// ERROR "operator is not supported"
		i = i >>> 2;

		// ERROR "was unexpected here"
		String ct;
		// ERROR "("String" is a type name)"
		int String;
		// ERROR "("GameObj" is a type name)"
		double GameObj;

		int lowercasefirst = 1;
		// ERROR "differs only by upper/lower case from existing variable"
		int lowerCaseFirst = 10;
		GameObj upperCaseFirst = objVar;
		// ERROR "differs only by upper/lower case from existing variable"
		GameObj uppercasefirst = null;
		// ERROR "Names are case-sensitive, known name is"
		dblVar = dblvar + 1;

		
		// ERROR "Code12 does not allow names that differ only by upper/lower case from known names"
		int DouBle;
		// ERROR "Code12 does not allow names that differ only by upper/lower case from known names"
		double BooLean;
		// ERROR "Code12 does not allow names that differ only by upper/lower case from known names"
		boolean string;

		// ERROR "An index in [brackets] can only be applied to an array"
		intVar[0] = 1;

		// ERROR "Array index must be an integer value"
		intArr[dblVar] = 1;

		// ERROR "Arrays can only access their ".length" field
		int numObjs = objArr.Length;

		// ERROR "Type String has no data fields"
		int len = strVar.length;
		// ERROR "Type int has no data fields"
		int size = intVar.size;

		// ERROR "The negate operator (-) can only apply to numbers"
		objVar = -objVar;

		// ERROR "The not operator (!) can only apply to boolean values"
		objVar.visible = !intVar;

		// ERROR "The (+) operator cannot be applied to arrays"
		strVar = strVar + intArr;
		// ERROR "The (+) operator cannot be applied to arrays"
		strVar = intArr + strVar;

		// ERROR "The (+) operator can only apply to numbers or Strings"
		boolVar = boolVar + !boolVar;
		// ERROR "The (+) operator can only apply to numbers or Strings"
		objVar = objVar + objVar;
		// ERROR "The (+) operator can only apply to numbers or Strings"
		intArr = intArr + 1;
		// ERROR "The (+) operator can only apply to numbers or Strings"
		objArr = objArr + objVar;

		// ERROR "Numeric operator (-) can only apply to numbers"
		strVar = strVar - intVar;
		// ERROR "Numeric operator (*) can only apply to numbers"
		boolVar = boolVar * 0;
		// ERROR "Numeric operator (/) can only apply to numbers"
		objVar = objVar / 2;
		// ERROR "Numeric operator (%) can only apply to numbers"
		intArr = intArr % 2;

		// ERROR "Logical operator (&&) can only apply to boolean values"
		intVar = intVar && 1001;
		// ERROR "Logical operator (||) can only apply to boolean values"
		boolVar = boolVar || 1010;

		// ERROR "Inequality operator (<) can only apply to numbers"
		if (boolVar < boolVar)
			voidFunc();
		// ERROR "Inequality operator (>) can only apply to numbers"
		boolVar = objVar > dblVar;
		// ERROR "Inequality operator (<=) can only apply to numbers"
		while( boolVar <= intVar )
			voidFunc();

		// ERROR "Inequality operator (>=) can only apply to numbers"
		dblVar = dblVar >= intArr;

		// ERROR "Integer divide has remainder"
		intVar = 1 / 2;
		// ERROR "Integer divide may lose remainder"
		dblVar = intVar / 8;

		// ERROR "Variable intVar was already defined"
		int intVar = 13;
		// ERROR "Variable objArr was already defined"
		GameObj[] objArr = new GameObj[10];

		// ERROR "Calling main program or event functions"
		update();
		// ERROR "Calling main program or event functions"
		start();
		// ERROR "Calling main program or event functions"
		onMousePress(0,0);

		// ERROR "Code12 function name is"
		println("Hello world");
		// ERROR "Code12 function name is"
		setHeight(150);

		// ERROR "was unexpected here"
		intFunc[0]();
		// ERROR "was unexpected here"
		dblFuncIntDbl[intVar](0, 0.1);

		// ERROR "("GameObj" is a type name)"
		GameObj.foo();
		// ERROR "("String" is a type name)"
		String.foo();
		// ERROR "expected a variable name here"
		Code12Program.foo();
		// ERROR "expected a variable name here"
		Code12.foo();

		// ERROR "An index in [brackets] can only be applied to an array"
		boolVar[0].log(objVar);
		// ERROR "was unexpected here"
		dblVar = Math[intVar].tan(0);
		
		// ERROR "Method call on invalid type (array of int)"
		intArr.voidFunc();
		
		// ERROR "Method call on invalid type (int)"
		intArr[0].voidFunc();
		// ERROR "Method call on invalid type (boolean)"
		boolVar.foo();

		// ERROR "misspelled function"
		ct.prnitln();
		// ERROR "Unknown function"
		ct.circ(0,0,10);

		// ERROR "Unknown method"
		objArr[0].foo();
		// ERROR "Unknown or unsupported Math method"
		Math.foo();
		
		// ERROR "requires 1 parameter"
		intFuncInt();
		// ERROR "requires 2 parameters"
		dblFuncIntDbl();
		// ERROR "requires 1 parameter"
		ct.log();
		// ERROR "requires 2 parameters"
		Math.atan2();
		// ERROR "requires 3 parameters"
		boolFuncBoolStringGameObj(false, "");
		// ERROR "requires 4 parameters"
		ct.rect(0,0,10);
		// ERROR "Too many parameters passed"
		voidFunc(intVar);
		// ERROR "Too many parameters passed"
		ct.print("intVar =", intVar);
		// ERROR "Too many parameters passed"
		Math.atan(4,3);
		// ERROR "expects type String, but int was passed"
		ct.logm(intVar, objVar);

		String indent = "2 Tabs";
		// ERROR "Mix of tabs and spaces"
 		indent = "1 Space + 2 Tabs";
		// ERROR "Mix of tabs and spaces"
		indent = "2 Tabs";
		// ERROR "Mix of tabs and spaces"
        indent = "8 Spaces";
		// ERROR "Mix of tabs and spaces"
		indent = "2 Tabs";
		// ERROR "Mix of tabs and spaces"
    	indent = "4 Spaces + 1 Tab";
		// ERROR "Mix of tabs and spaces"
		indent = "2 Tabs";
		// ERROR "Unexpected change in indentation"
			if (false)
			{
				voidFunc();
			}
		if (false)
		// ERROR "line should be indented more than its controlling "if""
		voidFunc();
		if (false)
		{
		// ERROR "Lines within { } brackets should be indented"
		voidFunc();
		voidFunc();
		}
		if (false)
			voidFunc();
		// ERROR "This line is not controlled by the "if" above it"
			voidFunc();
		if (false)
		{
			voidFunc();
		// ERROR "Unexpected change in indentation"
		voidFunc();
		}
		if (false)
		// ERROR "should have the same indentation"
			{
				voidFunc();
			}
		if (false)
		{
			voidFunc();
			// ERROR "should have the same indentation"
			}
		if (false)
			voidFunc();
		else
		// ERROR "line should be indented more than its controlling "else""
		voidFunc();
		if (false)
			voidFunc();
		// ERROR "This line is not controlled"
			else
				voidFunc();
		if (false)
			voidFunc();
		else
			voidFunc();
		// ERROR "This line is not controlled by the "else" above it"
			voidFunc();
		if (false)
			voidFunc();
		else
			// ERROR "should have the same indentation"
				{
					voidFunc();
				}
		if (false)
			voidFunc();
		else if (false)
		// ERROR "This line should be indented more than its controlling "elseif""
		voidFunc();
		if (false)
			voidFunc();
		else if (false)
		// ERROR "should have the same indentation"
				{
					voidFunc();
				}
		if (false)
			voidFunc();
		// ERROR "This line is not controlled"
			else if (false)
				voidFunc();
		else
			voidFunc();
		if (false)
			voidFunc();
		else if (false)
			voidFunc();
		// ERROR "This line is not controlled"
			else
				voidFunc();
		if (false)
			voidFunc();
		else if (false)
			voidFunc();
		// ERROR "This line is not controlled"
			else if (false)
				voidFunc();
		// ERROR "An "else" should have the same indentation as its "if""
			else
				voidFunc();
		if (false)
			if (false)
					voidFunc();
		// ERROR "An "else" should have the same indentation as its "if""
		else
			voidFunc();
		if (false)
		{
			if (false)
			{
				voidFunc();
			}
			else
			{
				voidFunc();
			}
		// ERROR "A block's ending } should have the same indentation as its beginning {"
			}
		if (false)
			if (false)
				voidFunc();
		// ERROR "An "else if" should have the same indentation as the first "if""
		else if (false)
			voidFunc();
		for (int ii = 0; ii < 100; ii++)
		// ERROR "This line should be indented more than its controlling "for""
		voidFunc();
		for (int ii = 0; ii < 100; ii++)
		{
		// ERROR "Lines within { } brackets should be indented"
		voidFunc();
		}
		for (int ii = 0; ii < 100; ii++)
		// ERROR "should have the same indentation"
			{
				voidFunc();
			}
		while (false)
		// ERROR "This line should be indented more than its controlling "while""
		voidFunc();
		while (false)
		// ERROR "should have the same indentation"
			{
				voidFunc();
			}
		while (false)
			voidFunc();
		// ERROR "This line is not controlled by the "while" above it"
			voidFunc();
		do
		// ERROR "This line should be indented more than its controlling "do""
		voidFunc();
		while (false);
		do
		// ERROR "should have the same indentation"		
			{
				voidFunc();
			}
		while (false);
		do
			voidFunc();
		// ERROR "This while statement should have the same indentation as its "do""
			while (false);
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		int x1,
		x2,	x3;
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		GameObj circle = ct.circle( 0, 0,
		10);
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		ct.log( 1,
			2,
		3);
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		int[] multiLineArrInit = { 1,
		2 };
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		int[] multiLineArrDec = new int[ct.random(1,
		10)];
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		if ( ct.random(1, 2)  ///
		> 3 )
			voidFunc();
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		else if ( ct.random(1,
		2) > 3 )
			voidFunc();
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		while ( ct.random(1,
		2) > 3 )
			voidFunc();
		do
			voidFunc();
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		while( Math.max(1,
		0) < 0 );
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		for (;Math.max(1,
		0) < 0; )
			voidFunc();
		if (false)
			voidFunc();
		// ERROR This line is not controlled by the highlighted "if" above it"
			voidFunc();
		if (false)
			voidFunc();
		else
			voidFunc();
		// ERROR This line is not controlled by the highlighted "else" above it"
			voidFunc();
		if (false)
			voidFunc();
		else if (false)
			voidFunc();
		// ERROR This line is not controlled by the highlighted "elseif" above it"
			voidFunc();
		if (false)
			voidFunc();
		// ERROR This line is not controlled by the highlighted "if" above it"
			while (false)
				voidFunc();
		for (;false;)
			voidFunc();
		// ERROR This line is not controlled by the highlighted "for" above it"
			voidFunc();	
		while (false)
			voidFunc();
		// ERROR This line is not controlled by the highlighted "while" above it"
			voidFunc();
		do
			voidFunc();
		// ERROR This line is not controlled by the highlighted "do" above it"
			voidFunc();
		do
			voidFunc();
			// ERROR This line is not controlled by the highlighted "do" above it"
			while (false)
		// ERROR "Access specifiers are only allowed on class-level variables"
		private int privateInt = 0;
		// ERROR "Access specifiers are only allowed on class-level variables"
		public double publicDouble = 0;
		// ERROR "(double) type cast can only be applied to type int"
		double halfIntVar = (double) "3";
		if (false)
		// ERROR "Variable declarations are not allowed here"
			int bogusVarInit = 0;
		if (false)
			voidFunc();
		else if (false)
		// ERROR "Variable declarations are not allowed here"
			int bogusVarDecl;
		if (false)
			voidFunc();
		else
		// ERROR "Variable declarations are not allowed here"
			int[] bogusArrayInit = { 0 };	
		while (false)
		// ERROR "Variable declarations are not allowed here"
			int[] bogusArrayDecl;
		// ERROR "else without matching if (misplaced { } brackets?)"
		else
		do
			voidFunc();
		// ERROR "Expected while statement to end do-while loop"
		voidFunc();
		do
		{
			voidFunc();
		}
		// ERROR "Expected while statement to end do-while loop"
		voidFunc();
		do
			voidFunc();
		// ERROR "while statement at end of do-while loop must end with a semicolon"
		while (false)
		do
		{
			voidFunc();
		}
		// ERROR "while statement at end of do-while loop must end with a semicolon"
		while (false)
		// ERROR "while loop header should not end with a semicolon"
		while (false);
		// ERROR "Function definitions cannot occur inside a statement block"
		void misplacedFunc()
		// ERROR "Function definitions cannot occur inside a statement block"
		public static void main(String[] args)
		// ERROR "Function definitions cannot occur inside a statement block"
		public void update()
	}

	// ERROR "Variable myVar was already defined"
	void myFunc(int myVar)
	{
	}
	GameObj makeCoin()
	{
	// ERROR "missing a return"
	}
	// ERROR "Return type of onMousePress function should be void"
	int onMousePress( GameObj obj, double x, double y )
	{
		return 0;
	}
	// ERROR "Wrong number of parameters for function"
	void onMousePress( double x, double y )
	{
	}
	// ERROR "Wrong number of parameters for function"
	void onKeyPress( GameObj obj, double x, double y )
	{
	}
	// ERROR "Wrong number of parameters for function"
	void onKeyRelease( )
	{
	}
	// ERROR "Wrong type for parameter 1 of function onMousePress"
	void onMousePress( boolean obj, double x, double y )
	{
	}
	// ERROR "Wrong type for parameter 2 of function onMouseDrag"
	void onMouseDrag( GameObj obj, int x, double y )
	{
	}
	// ERROR "Wrong type for parameter 3 of function"
	void onMouseRelease( GameObj obj, double x, String y )
	{
	}
	// ERROR "Wrong type for parameter 1 of function"
	void onKeyPress( double keyName )
	{
	}
	// ERROR "Wrong type for parameter 1 of function"
	void onKeyRelease( int keyName )
	{
	}
	// ERROR "Wrong type for parameter 1 of function"
	void onCharTyped( GameObj keyName )
	{
	}
	// ERROR "Class-level variable and function blocks should all have the same indentation"
		void overIndentedFunc()
		{
		}
	// ERROR "Class-level variable and function blocks should all have the same indentation"
void underIndentedFunc()
{
}
	int funcWithUnindentedBody()
	{
	// ERROR "Lines within { } brackets should be indented"
	return 0;
	}
	// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
	void multiLineFuncDef( int arg1,
	int arg2 )
	{
	}
	int multilineReturnFunc()
	{
		// ERROR "The lines after the first line of a multi-line statement should be indented further than the first line"
		return Math.max(1,
		2);
	}
	void missingCurlyBracketFunc()
	// ERROR "Expected {"
	void syntaxLevelDependentTests()
	{
		String strVar = "";
		GameObj gameObjVar = ct.circle(0, 0, 1);
		// if syntaxLevel is 7-12: 
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		if ("" != strVar)
			voidMethod();
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		ct.println(gameObjVar.group == "circles");
	}

	int intMethod()
	{
		return 0;
	}
	void voidMethod()
	{
		int voidMethodVar;
		return;
	}
	void voidMethodWithParams(int p1, double p2, boolean p3, String p4, GameObj p5)
	{
	}

	GameObj noErrorsMethod()
	{
		System.out.println("Hello world");
		classLevelGameObj = ct.rect(0, 0, 10, 10);
		GameObj returnValue = null;
		boolean boolVar = false;
		int[] intArrayInitWithExpressions = { 1 + 2, 3 * 4 + 50, (67 - 890) + 3 };
		GameObj[] gObjArrayInitWithCTCalls = { ct.rect(50, 50, 10, 10), ct.text("text", 50, 50, 10) };
		double[] dblArrayInitWithExpressionsAndIntPromotion = { 1 + 2, 3.4 * 7 / 2 };

		for (;boolVar;)
		{
			ct.println();
			if (boolVar)
				ct.println();
			else
				break;
			ct.println();
		}
		while (boolVar)
		{
			if (boolVar)
				break;
			ct.println();
		}
		do
		{
			ct.println();
			if (boolVar)
				break;
		}
		while (boolVar);
		// Leave at end of method to test each path having a return with no return following
		for (;boolVar;)
		{
			if (boolVar)
				return returnValue;
		}
		if (classLevelBoolean)
		{
			return returnValue;
		}
		else if (boolVar)
		{
			return returnValue;
		}
		else
		{
			return returnValue;
		}
	}
	// void syntaxLevelDependentTests()
	// ERROR "parameter names should start with a lower-case letter"
	public void onMousePress( GameObj obj, double x, double Yvalue )
	{
	}
	// ERROR "parameter names should start with a lower-case letter"
	void parameterStartsWithCapitalMethod( double doubleParam, int IntParam, boolean boolParam )
	{
		int userFunc1Var = 1;
	}
	// ERROR "function names should start with a lower-case letter"
	void StartsWithCapitalLetterMethod()
	{
	}
	void testErrors3()
	{
		int intVar = 0;
		boolean boolVar = false;
		// ERROR "variable names should start with a lower-case letter"
		int Starts_with_capital_letter_var;
		// ERROR "variable names should start with a lower-case letter"
		double StartsWithCapitalLetterVarWithAssignment = 3.14;
		// ERROR "variable names should start with a lower-case letter"
		GameObj[] GameObjArrVar = new GameObj[10];
		// ERROR "Names are case-sensitive, known name is"
		double dblVar = intvar + 1;
		// ERROR "Names are case-sensitive, known name is"
		ct.println(boolvar);
		// ERROR "Names are case-sensitive, known name is"
		voidmethod();
		// ERROR "Names are case-sensitive, known name is"
		ct.PrintLn();
		// ERROR "already defined"
		int classLevelGameObj;
		// ERROR "already defined"
		int intVar;
		// ERROR "already defined"
		boolean boolVar;
		// ERROR "differs only by upper/lower case from existing variable"
		GameObj classlevelInt;
		// ERROR "differs only by upper/lower case from existing variable"
		boolean boolvar = true;
		if (boolVar)
		{
			int prevBlockVar;
		}
		// ERROR "Undefined variable (previous variable"
		prevBlockVar = 2e2;
		// ERROR "Undefined variable (previous variable"
		ct.println(voidMethodVar + 1);
		// ERROR "Undefined variable (previous similar variable"
		prevBlockvar = 1.1;
		// ERROR "must be declared with a type before being assigned"
		undeclaredVar = 0;
		// ERROR "Undefined variable"
		classLevelGameObj.setText(undeclaredVar);
		// ERROR "must be assigned before it is used"
		ct.print(classLevelUnassignedVar);
		int unassignedVar;
		// ERROR "must be assigned before it is used"
		ct.print(unassignedVar);
	}
	// ERROR "Return type" (for Code12 events)
	public boolean onMousePress( GameObj obj, double x, double y )
	{
		return classLevelBoolean;
	}
	// ERROR "Wrong number of parameters" (for Code12 events)
	public void onMouseDrag( GameObj obj, double x, double y, double z )
	{
	}
	// ERROR "Wrong type for parameter 3"
	public void onMouseRelease( GameObj obj, double x, int y )
	{
	}
	// ERROR "function must be declared starting with" public
	void onKeyPress( String keyName )
	{
	}
	// ERROR "function must be declared starting with" public
	private void onKeyRelease( String keyName )
	{
	}

	// ERROR "function should not be declared static"
	public static void onCharTyped( String charString )
	{
	}
	public void onResize()
	{
	}
	// ERROR "function was already defined"
	public void onResize()
	{
	}
	void existingUserFunction()
	{
	}
	// ERROR "already defined"
	void existingUserFunction()
	{
	}
	// ERROR "differs only by upper/lower case from existing function"
	void existingUserfunction()
	{
	}
	void testErrors2()
	{
		int intVar = 0;
		double dblVar = 0;
		boolean boolVar = false;
		String strVar = "";
		GameObj rect = ct.rect(50, 50, 10, 10);
		GameObj circle = ct.circle(50, 50, 10);
		GameObj text = ct.text("text", 50, 50, 10);
		GameObj image = ct.image("bogusFileName.png", 50, 50, 10);
		int[] intArr = new int[10];
		double[] dblArr = new double[10];
		boolean[] boolArr = new boolean[10];
		String[] strArr = new String[10];
		GameObj[] objArr = new GameObj[10];
		// ERROR "double cannot be assigned to an int"
		intVar = dblVar;
		// ERROR "double cannot be assigned to a String"
		strVar = dblVar;
		// ERROR "Integer value cannot be assigned to a String"
		strVar = intVar;
		// ERROR "String cannot be assigned to a double"
		dblVar = strVar;
		// ERROR "String cannot be assigned to an int"
		intVar = strVar;
		// ERROR "cannot be assigned to type"
		dblVar = rect;
		// ERROR "can only be applied to an array"
		rect[0].x = dblVar;
		// ERROR "can only be applied to an array"
		intVar[0]++;
		// ERROR "index must be an integer"
		strArr[intVar * 1.0] = strVar;
		// ERROR "index must be an integer"
		objArr[dblVar] = rect;
		// ERROR "Arrays can only access" .length field
		intArr = new int[intArr.foo * 2];
		// ERROR "no data fields"
		ct.print(intVar.x);
		// ERROR "function as a variable"
		rect.setText = strVar;
		// ERROR "Unknown field"
		dblVar = rect.foo;
		// ERROR "Unknown field"
		rect.foo = 0;
		// ERROR "Calling main program or event functions directly is not allowed"
		onMousePress( rect, rect.x, rect.y );
		// ERROR "Unknown function, the Code12 function name is"
		GameObj line = line(50, 50, 10, 10);
		// ERROR "Unknown function, the Code12 function name is"
		println();
		// ERROR "Undefined function"
		undefinedFunc();
		// ERROR "Unknown or misspelled function"
		rect = ct.rec(0, 0, 1, 1);
		// ERROR "Unknown or misspelled function"
		ct.printLine();
		// ERROR "Unknown function"
		ct.foo();
		// ERROR "supported System functions are"
		System.foo.bar();
		// ERROR "supported System functions are"
		System.err.println("File opening failed:");
		// ERROR "Unknown or unsupported Math method"
		double stdev = Math.foo(doubleVar);
		// ERROR "Unknown or misspelled method"
		rect.getWidht(dblVar);
		// ERROR "Unknown or misspelled method"
		strVar.equal(classLevelString);
		// ERROR "Unknown method"
		rect.foo();		
		// ERROR "Unknown method"
		rect.group.concat(text.getText());
		// ERROR "Unknown method"
		classLevelString.setSize(intVar, dblVar);
		// ERROR "Unknown method"
		strVar.size();
		// ERROR "Method call on invalid type"
		objArr.delete();
		// ERROR "Method call on invalid type"
		intVar.delete();
		// ERROR "requires 1 parameter"
		ct.print();
		// ERROR "requires 2 parameters"
		if ( Math.min(1) < 0 )
			voidMethod();
		// ERROR "requires 5 parameters"
		voidMethodWithParams();
		// ERROR "Too many parameters passed"
		if ( Math.min(1, 2, 3) < 0 )
			voidMethod();
		// ERROR "Too many parameters passed"
		double minOf3 = Math.min(1, 2, 3);
		// ERROR "Too many parameters passed"
		voidMethod(1);
		// ERROR "Too many parameters passed"
		ct.println("hello", "world");
		// ERROR "expects type"
		ct.println( ct.distance(ct.round(rect.x), rect.y, circle, circle.y) );
		// ERROR "expects type"
		dblVar = Math.max(intVar, strVar);
		voidMethodWithParams(intVar, intVar, boolVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(intVar, dblVar, boolVar, strVar, intVar);
		// ERROR "expects type"
		voidMethodWithParams(intVar, dblVar, strVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(intVar, boolVar, boolVar, strVar, rect);
		// ERROR "expects type"
		voidMethodWithParams(dblVar, dblVar, boolVar, strVar, rect);
		// ERROR "Loop test must evaluate to a boolean"
		for (;intVar;)
			ct.println();
		do
			ct.println();
		// ERROR "Loop test must evaluate to a boolean"
		while ( (1 + 1.0 == 2e0) + "");
		// ERROR "Loop test must evaluate to a boolean"
		while (boolVar + "")
			// ERROR "can only be applied to numbers"
			rect.group += 1;		
		// ERROR "can only be applied to numbers"
		boolVar += false;
		// ERROR "must be numeric"
		dblVar *= rect;
		// ERROR "must be numeric"
		dblVar += boolVar + "";
		// ERROR "must be numeric"
		intVar += boolVar;
		// ERROR "double cannot be assigned to int"
		intVar /= classLevelInt * rect.x;
		// ERROR "double cannot be assigned to int"
		intVar *= 1e0;
		// ERROR "double cannot be assigned to int"
		classLevelInt -= classLevelDouble;
		// ERROR "double cannot be assigned to int"
		intVar += 1.0;
		// ERROR "test must be boolean"
		if (dblVar)
			ct.println();
		// ERROR "test must be boolean"
		else if (intVar)
			ct.println();
		// ERROR "test must be boolean"
		if (0)
			ct.println();
		// ERROR "must operate on an array"
		for (int x : null)
			break;
		// ERROR "must operate on an array"
		for (int x : image)
			break;
		// ERROR "must operate on an array"
		for (int x : intVar)
			break;
		// ERROR "loop array contains elements of type"
		for (GameObj x : classLevelIntArr)
			break;
		// ERROR "loop array contains elements of type"
		for (boolean x : new String[10])
			break;
		// ERROR "loop array contains elements of type"
		for (int x : dblArr)
			break;
	}
	void voidFuncReturnsValue6()
	{
		GameObj r = ct.circle(0, 0, 1);
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "cannot return a value"
				return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue5()
	{
		GameObj r = null;
		for (;classLevelBoolean;)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue4()
	{
		String r = null;
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue3()
	{
		String r = "";
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue2()
	{
		boolean r = false;
		if (classLevelBoolean)
			// ERROR "cannot return a value"
			return r;
		// ERROR "cannot return a value"
		return r;
	}
	void voidFuncReturnsValue1()
	{
		double r = 0;
		// ERROR "cannot return a value"
		return r;
	}
	int funcWrongReturnValueType7()
	{
		// ERROR "Incorrect return value type"
		return classLevelInt * 1.0;
	}
	int funcWrongReturnValueType6()
	{
		GameObj r = ct.circle(0, 0, 1);
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "Incorrect return value type"
				return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	String funcWrongReturnValueType5()
	{
		GameObj r = null;
		for (;classLevelBoolean;)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	GameObj funcWrongReturnValueType4()
	{
		String r = null;
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	boolean funcWrongReturnValueType3()
	{
		String r = "";
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	double funcWrongReturnValueType2()
	{
		boolean r = false;
		if (classLevelBoolean)
			// ERROR "Incorrect return value type"
			return r;
		// ERROR "Incorrect return value type"
		return r;
	}
	int funcWrongReturnValueType1()
	{
		double r = 0;
		// ERROR "Incorrect return value type"
		return r;
	}
	int funcNoReturnValue6()
	{
		int r = 0;
		while (classLevelBoolean)
			if (classLevelBoolean)
				// ERROR "requires a return value"
				return;
		return r;
	}
	int funcNoReturnValue5()
	{
		int r = 0;
		for (;classLevelBoolean;)
			// ERROR "requires a return value"
			return;
		return r;
	}
	int funcNoReturnValue4()
	{
		int r = 0;
		if (classLevelBoolean)
			// ERROR "requires a return value"
			return;
		// ERROR "requires a return value"
		return;
	}
	int funcNoReturnValue3()
	{
		int r = 0;
		if (classLevelBoolean)
			// ERROR "requires a return value"
			return;
		return r;
	}
	int funcNoReturnValue2()
	{
		int r = 0;
		if (classLevelBoolean)
			return r;
		// ERROR "requires a return value"
		return;
	}
	int funcNoReturnValue1()
	{
		// ERROR "requires a return value"
		return;
	}
	void funcBreakStmtErrors()
	{
		if (classLevelBoolean)
		{
			// ERROR "only allowed inside loops"
			break;
		}
		else if (classLevelBoolean)
			// ERROR "only allowed inside loops"
			break;
		else
			// ERROR "only allowed inside loops"
			break;
		// ERROR "only allowed inside loops"
		break;
	}
	int funcUnreachableStmt8()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			if (classLevelBoolean)
			{
				ct.println();
			}
			else if (1 + 1 == 3)
			{
				return r;
				// ERROR "statement is unreachable"
				ct.println();
			}
		}
		return r;
	}
	int funcUnreachableStmt7()
	{
		int r = 0;
		while (classLevelBoolean)
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt6()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			ct.println();
		}
		else if (1 + 1 == 3)
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt5()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			ct.println();
		}
		else
		{
			return r;
			// ERROR "statement is unreachable"
			ct.println();
		}
		return r;
	}
	int funcUnreachableStmt4()
	{
		int r = 0;
		if (classLevelBoolean)
		{
			return r;
			// ERROR "statement is unreachable"
			if (1 + 1 == 2)
				ct.println();
		}
		return r;
	}
	int funcUnreachableStmt3()
	{
		int r = 0;
		return r;
		// ERROR "statement is unreachable"
		for (;classLevelBoolean;)
			break;
		ct.println();
		return r;
	}
	int funcUnreachableStmt2()
	{
		int r = 0;
		return r;
		// ERROR "statement is unreachable"
		if (classLevelBoolean)
			ct.println();
		ct.println();
		return r;
	}
	void funcUnreachableStmt1()
	{
		return;
		// ERROR "statement is unreachable"
		ct.println();
		ct.println();
	}
	int funcMissingReturn10()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				ct.println();
			else if (boolVar2)
				return r;
			else
				return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn9()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar2)
				return r;
			else
				ct.println();
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn8()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar2)
				return r;
			else
				return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn7()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = true;
		if (boolVar1)
			ct.println();
		else if (boolVar2)
			ct.println();
		else
			return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn6()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = true;
		if (boolVar1)
			ct.println();
		else if (boolVar2)
			return r;
		else
			ct.println();
		// ERROR "Function is missing a return statement"
	}

	int funcMissingReturn4()
	{
		boolean boolVar = false;
		if (boolVar)
			ct.println();
		else
			ct.println();
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn2()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			return r;
		// ERROR "Function is missing a return statement"
	}
	int funcMissingReturn1()
	{
		// ERROR "Function is missing a return statement"
	}
	int funcPathMissingReturn3Brackets()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
		else if (boolVar2)
		{
			return r;
		}
	}
	int funcPathMissingReturn2Brackets()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
		{
			return r;
		}
		else
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
	}
	int funcPathMissingReturn1Brackets()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
		{
			ct.println();
			// ERROR "path is missing a return statement"
		}
		else
		{
			return r;
		}
	}
	int funcPathMissingReturn10()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				return r;
			else if (boolVar2)
				return r;
			else
				// ERROR "path is missing a return statement"
				ct.println();
		else
			return r;
	}
	int funcPathMissingReturn9()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				return r;
			else if (boolVar2)
				// ERROR "path is missing a return statement"
				ct.println();
			else
				return r;
		else
			return r;
	}
	int funcPathMissingReturn8()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			if (boolVar1)
				// ERROR "path is missing a return statement"
				ct.println();
			else if (boolVar2)
				return r;
			else
				return r;
		else
			return r;
	}
	int funcPathMissingReturn7()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			// ERROR "path is missing a return statement"
			ct.println();
		else if (boolVar2)
			return r;
		else
			return r;
	}
	int funcPathMissingReturn6()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			return r;
		else if (boolVar2)
			// ERROR "path is missing a return statement"
			ct.println();
		else
			return r;
	}
	int funcPathMissingReturn5()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			return r;
		else if (boolVar2)
			return r;
		else
			// ERROR "path is missing a return statement"
			ct.println();
	}
	int funcPathMissingReturn3()
	{
		int r = 0;
		boolean boolVar1 = false;
		boolean boolVar2 = false;
		if (boolVar1)
			// ERROR "path is missing a return statement"
			ct.println();
		else if (boolVar2)
			return r;
	}
	int funcPathMissingReturn2()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			return r;
		else
			// ERROR "path is missing a return statement"
			ct.println();
	}
	int funcPathMissingReturn1()
	{
		int r = 0;
		boolean boolVar = false;
		if (boolVar)
			// ERROR "path is missing a return statement"
			ct.println();
		else
			return r;
	}

	void testErrors1()
	{
		int intVar = 1;
		double dblVar = 1.2;
		boolean boolVar = false;
		String strVar = "";
		GameObj rect = ct.rect(50, 50, 10, 10);
		GameObj circle = ct.circle(50, 50, 10);
		GameObj text = ct.text("text", 50, 50, 10);
		GameObj image = ct.image("bogusFileName.png", 50, 50, 10);
		int[] intArr = new int[10];
		double[] dblArr = new double[10];
		boolean[] boolArr = new boolean[10];
		String[] strArr = new String[10];
		GameObj[] objArr = new GameObj[10];

		// ERROR "already of type int"
		circle.x = (int) intVar + 314;
		// ERROR "already of type int"
		circle.x = (int) (intVar + 314);
		// ERROR "(int) type cast can only be applied to type double"
		objArr = new GameObj[2 * (int) objArr];
		// ERROR "already of type double"
		dblVar = (double) (10 * 2.3);
		// ERROR "Type casts can only be (int) or (double)"
		rect.group = (String) circle.group;
		// ERROR "Unknown data field of Math class"
		dblVar = Math.P;

		// "The negate operator (-) can only apply to numbers"
		// ERROR "negate operator"
		rect.x = -rect;
		// ERROR "negate operator"
		strVar = -strVar;

		// "The not operator (!) can only apply to boolean values"
		// ERROR "not operator"
		boolVar = !intVar;

		// "Array count must be an integer"
		// ERROR "count must be an integer"
		objArr = new GameObj["ten"];
		// ERROR "count must be an integer"
		strArr = new String[intVar + dblVar];
		// ERROR "count must be an integer"
		boolArr = new boolean[intVar + dblVar];
		// ERROR "count must be an integer"
		dblArr = new double[dblVar];
		// ERROR "count must be an integer"
		intArr = new int[10.0];
		// "Code12 does not support making objects with new"
		// ERROR "objects with new"
		circle.group = new String();
		// ERROR "objects with new"
		rect.setText( new String() );
		// ERROR "objects with new"
		String[] newStringArr2 = { strVar, new String() };
		// ERROR "objects with new"
		String[] newStringArr = { new String() };
		// ERROR "objects with new"
		String newString = new String();
		// ERROR "objects with new"
		intVar = new Integer(1);
		// ERROR "objects with new"
		rect = new GameObj();

		// "Code12 does not support arrays of arrays"
		// ERROR "arrays of arrays"
		String[] arrInit9 = { new String[intVar] };
		// ERROR "arrays of arrays"
		GameObj[] arrInit8 = { rect, intArr, text };
		// ERROR "arrays of arrays"
		GameObj[] arrInit7 = { rect, image, objArr };

		// "Array initializers must all be the same type"
		// ERROR "all be the same type"
		GameObj[] arrInit6 = { ct.rect(50, 50, 10, 10), text, 0 };
		// ERROR "all be the same type"
		GameObj[] arrInit5 = { "circle", circle };
		// ERROR "all be the same type"
		String[] arrInit4 = { strVar + 1, intVar, intVar + 2 };
		// ERROR "all be the same type"
		boolean[] arrInit3 = { false, boolVar, null };
		// ERROR "all be the same type"
		double[] arrInit2 = { circle, 0.5 };
		// ERROR "all be the same type"
		int[] arrInit1 = { 1, "1" };
		

		// "The (+) operator cannot be applied to arrays"
		// ERROR "cannot be applied to arrays"
		ct.println(objArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(strArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(boolArr + strVar);
		// ERROR "cannot be applied to arrays"
		ct.println(strVar + dblArr);
		// ERROR "cannot be applied to arrays"
		ct.println(strVar + intArr);

		// "The (+) operator can only apply to numbers or Strings"
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(boolVar + dblVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intArr + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(boolVar + intVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(dblVar + boolVar);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + intArr);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + rect);
		// ERROR "can only apply to numbers or Strings"
		ct.println(intVar + boolVar);
		// ERROR "can only apply to numbers or Strings"
		dblVar = 1 / (boolVar + intArr + 1);
		// ERROR "can only apply to numbers or Strings"
		strVar = boolVar + rect;
		// ERROR "can only apply to numbers or Strings"
		intVar = boolVar + dblVar / 2;
		// ERROR "can only apply to numbers or Strings"
		intVar = boolVar + intVar - 1;
		// ERROR "can only apply to numbers or Strings"
		boolVar = boolVar + boolVar;
		// ERROR "can only apply to numbers or Strings"
		rect.x = circle + text;
		// ERROR "can only apply to numbers or Strings"
		rect.width = 2 + rect;
		// ERROR "can only apply to numbers or Strings"
		ct.println(rect.x + false);

		// "Numeric operator (%strVar) can only apply to numbers"
		// ERROR "Numeric operator"
		dblVar = strVar - ".txt";
		// ERROR "Numeric operator"
		intVar = rect.group % text;
		// ERROR "Numeric operator"
		dblVar = circle / 10;
		// ERROR "Numeric operator"
		rect.width = rect * 2;
		// ERROR "Numeric operator"
		rect.x = 100 - rect;

		// "Integer divide may lose remainder. Use (double) or ct.intDiv()"
		// ERROR "Integer divide"
		int[] intArrayInitWithExpressions = { 1 + 2 / 1, (3 + 1) / 2 };
		// ERROR "Integer divide"
		boolVar = intVar / intVar == 1;
		// ERROR "Integer divide"
		dblVar = -10 / 3;
		// ERROR "Integer divide"
		dblVar = 10 / -3;
		// ERROR "Integer divide"
		intVar = 123 / 5;
		// ERROR "Integer divide"
		intVar = (1 + 2) / 3;
		// ERROR "Integer divide"
		intVar = 1 / (2 + 3);
		// ERROR "Integer divide"
		rect.x = intVar / 1;
		// ERROR "Integer divide"
		ct.println(1 + intVar / intVar);
		// ERROR "Integer divide"
		dblVar = 2 / intVar;
		// ERROR "Integer divide"
		intVar = intVar / 2;

		// "Logical operator (%strVar) can only apply to boolean values"
		// ERROR "Logical operator"
		circle = intVar || false;
		// ERROR "Logical operator"
		if (true && dblVar)
			voidMethod();
		// ERROR "Logical operator"
		else if (rect && true)
			voidMethod();
		// ERROR "Logical operator"
		while (intVar && boolVar)
			break;
		do
			break;
		// ERROR "Logical operator"
		while (dblVar || strVar);

		// "Inequality operator (%strVar) can only apply to numbers"
		// ERROR "Inequality operator"
		boolVar = circle < rect;
		// ERROR "Inequality operator"
		if (1 > false)
			voidMethod();
		// ERROR "Inequality operator"
		else if ("level" <= 10)
			voidMethod();
		// ERROR "Inequality operator"
		while ( 1 + 1 >= rect.visible )
			break;
		do
			break;
		// ERROR "Inequality operator"
		while (3.14 < text);

		// "Cannot compare %strVar to %strVar"
		// ERROR "Cannot compare"
		boolVar = boolVar == rect;
		// ERROR "Cannot compare"
		boolVar = rect != true;
		// ERROR "Cannot compare"
		boolVar = "3.14" == Math.PI;
		// ERROR "Cannot compare"
		for (;intVar != strVar;)
			voidMethod();
		// ERROR "Cannot compare"
		boolVar = strVar == true;
		// ERROR "Cannot compare"
		boolVar = "false" != false;
		do
			voidMethod();
		// ERROR "Cannot compare"
		while (1 == false);
		// ERROR "Cannot compare"
		while (boolVar != 0)
			voidMethod();
		// ERROR "Cannot compare"
		if (rect == 1)
			voidMethod();
		// ERROR "Cannot compare"
		else if (1 != circle)
			voidMethod();

		// "Use == to compare for equality (= is for assignment)"
		// ERROR "compare for equality"
		ct.println(circle = rect);
		// ERROR "compare for equality"
		while (boolVar = false)
			boolVar = true;
		// ERROR "compare for equality"
		if (rect.x = 100)
			rect.setSpeed(-1, 0);
		// ERROR "compare for equality"
		boolVar = (1 + 1 = 2);
		// ERROR "compare for equality"
		if (intVar = 1)
			ct.println("oops");

		// "%strVar does not return a value"
		// ERROR "does not return a value"
		ct.println(voidMethod());
		// ERROR "does not return a value"
		intVar = ct.println();

		// ERROR "operator is not supported"
		intVar = 2 | 1;
		// ERROR "operator is not supported"
		intVar = 2 ^ 1;
		// ERROR "operator is not supported"
		ct.println(2 & 1);
		// ERROR "operator is not supported"
		ct.println(2 >>> 1);
		// ERROR "operator is not supported"
		ct.println(2 >> 1);
		// ERROR "operator is not supported"
		ct.println(2 << 1);
	}
	// ERROR "The ending } of the program class should not be indented"
	}
