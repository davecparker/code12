import Code12.*;

class ErrorTest extends Code12Program
{
	public static void main(String[] args)
	{ 
		Code12.run(new ErrorTest()); 
	}

	// user defined functions
	void errorFunc()
	{
		ct.println("Hello world");
	}
	// ERROR "Code12 API functions cannot be called before start()"
	errorFunc();
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

	
	// ERROR "Return type of start function should be void"
	public int start()
	{
		// These line are all OK

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
		d = -.123e-456;
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
		d = (i * (i) - d * d);
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
		boolean quit = ct.inputYesNo("Quit?"); // Crashes Error Test/main.lua
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
		if (ct.clicked())
			boolean mouseClicked = ct.clicked();
		mouseClicked = ct.clicked();
		if ( ct.clickX() > 50 )
			double clickX = ct.clickX();
		x = ct.clickX();
		if ( ct.clickY() <= x )
			double clickY = ct.clickY();
		y = ct.clickY();
		String keyName = "space";
		if (ct.keyPressed(keyName))
			if (ct.keyPressed("up"))
				boolean upKeyPressed = ct.keyPressed("up");
		boolean keyPressed = ct.keyPressed(keyName);
		if ( ct.charTyped("+") )
			String ch = "A";
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
		if (ct.distance(circle.x, circle.y, rect.x, rect.y) < (circle.width + rect.width) / 2)
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
		// Code12 API -- GameObj Public Data Fieldss
		rect.x = circle.y - 10;
		circle.width = circle.height * 1.5;
		rect.height = img.height * 1.1;
		line.x = line.x + line.width;
		img.width = img.width * .9;
		img.xSpeed = 0;
		img.ySpeed = .5;
		line.lineWidth = 3;
		img.lineWidth = line.lineWidth * 2;
		rect.visible = false;
		circle.clickable = circle.visible;
		if (img.visible)
			img.clickable = true;
		if (img.clickable != false)
			img.autoDelete = img.visible;
		line.group = s;
		line.autoDelete = s.equals("hello") || s.equals("world") && s.indexOf(line.group) == 1;
		// Code12 API -- GameObj Methods
		s = rect.getType();
		ct.println(text.getText() + "more text");
		img.setText("racecar.png");
		text.setText("Score: " + d);
		text.setText("Score: " + i);
		ct.log(line.toString());
		img.setSize(img.width * 1.1, img.height * 1.1);
		text.align(s);
		text.align(s, true);
		text.align(s, false);
		circle.setFillColor("light" + s);
		circle.setFillColor(text.getText());
		circle.setFillColorRGB(i,j,k);
		rect.setLineColor(colors[i]);
		rect.setLineColorRGB(i, 255 - i, 0);
		i = rect.getLayer();
		if (rect.getLayer() >= circle.getLayer())
			b =	colors[rect.getLayer()].equals("green");
		img.setLayer(-42);
		img.delete();
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
		s = s.substring(i);
		s = s.toLowerCase();
		s = s.toUpperCase();
		s = s.trim();
	}

	// ERROR "Code12 API functions cannot be called before start()"
	GameObj button = ct.text("START", 0, 0, 10);
	// ERROR "Code12 API functions cannot be called before start()"
	double WIDTH = ct.getWidth();
	// ERROR "is reserved for use by the system"
	void ct()
	{
		ct.println("Hello world");
	}
	// ERROR "Names cannot start with an underscore in Code12"
	int _fn()
	{
		return 0;
	}
	// ERROR "int is a type name, expected a function name here"
	double int()
	{
		return 0;
	}
	// ERROR "boolean is a type name, expected a variable name here"
	double foo(int i, GameObj boolean)
	{
		return 0;
	}
	// ERROR "Code12 does not allow names that differ only by upper/lower case from known names ("GameObj" is a type name)"
	boolean bar(String s, GameObj gameObj)
	{
		// ERROR "Incorrect case for constant, should be "true""
		return TRUE;
	}
	// ERROR "Code12 does not allow names that differ only by upper/lower case from known names ("double" is a type name)"
	int Double(int x)
	{
		return 2 * x;
	}

	// ERROR "Function voidFunc is already defined"
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
	void AnotherFunc()
	{
	}	
	// ERROR "differs only by upper/lower case from existing function"
	// void anotherfunc() // crash
	// {
	// }

	void expectedErrors()
	{
		int intVar = 1;
		double dblVar = 1.0;
		boolean boolVar = false;
		String strVar = "a";
		GameObj objVar = ct.circle(0,0,10);
		int[] intArr = {1, 2, 3};
		GameObj[] objArr = { objVar };

		// ERROR "Value of type void cannot be assigned to type int"
		intVar = objVar.setText("circle");
		// ERROR "Value of type void cannot be assigned to type double"
		double screen = ct.setScreen("menu");
		// ERROR "Value of type void cannot be assigned to type boolean"
		boolVar = ct.setHeight(150);
		// ERROR "Value of type void cannot be assigned to type String"
		strVar = voidFunc();
		// ERROR "Value of type void cannot be assigned to type GameObj"
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
		objVar.autoDelete = dblVar;
		// ERROR "Value of type double cannot be assigned to a String"
		strVar = 3.14;
		// ERROR "Value of type double cannot be assigned to type GameObj"
		objVar = dblVar;

		// ERROR "Value of type boolean cannot be assigned to type int"
		intVar = ct.clicked();
		// ERROR "Value of type boolean cannot be assigned to type double"
		objVar.x = boolVar;
		// ERROR "Value of type boolean cannot be assigned to type double"
		objVar.xSpeed = false;
		// ERROR "Value of type boolean cannot be assigned to type String"
		objVar.group = boolVar;
		// ERROR "Value of type boolean cannot be assigned to type GameObj"
		objVar = boolVar;

		// ERROR "A String cannot be assigned to an int"
		intVar = objVar.group;
		// ERROR "A String cannot be assigned to a double"
		objVar.ySpeed = "fast";
		// ERROR "Value of type String cannot be assigned to type boolean"
		boolVar = strVar;
		// ERROR "Value of type String cannot be assigned to type GameObj"
		GameObj score = "100 pts"; 		

		// ERROR "Value of type GameObj cannot be assigned to type int"
		intVar = objVar;
		// ERROR "Value of type GameObj cannot be assigned to type double"
		objVar.width = objVar;
		// ERROR "Value of type GameObj cannot be assigned to type boolean"
		boolVar = objVar;
		// ERROR "A GameObj cannot be assigned to a String"
		String circle = ct.circle(0,0,10);
		
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

		// ERROR "expects type boolean, but int was passed"
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
		// ERROR "requires 2 parameters"
		dblFuncIntDbl();
		// ERROR "requires 3 parameters"
		ct.circle();
		// ERROR "Not enough parameters"
		ct.rect(0, 0, 10);
		// ERROR "Not enough parameters"
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
		int k = i / 2;
		// ERROR "Integer divide"
		ct.random( intVar / intVar, intVar );
		// ERROR "Undefined variable"
		x = x + 1;
		// ERROR "Undefined variable"
		for (x = 0; x < 1; x++) 
		// ERROR "Undefined function"
		foo();
		// ERROR "already defined"
		int j = 3;

		int uninitializedVar;
		// ERROR "must be assigned before it is used"
		if (uninitializedVar < 0)
		GameObj g;
		// ERROR "must be assigned before it is used"
		g.xSpeed = 1;

		// ERROR "Unknown variable type"
		integer n = 100;
		// ERROR "Unknown variable type"
		bool gameOver = false;
		// ERROR "Unknown API function"
		GameObj r = ct.rectangle(0,0,10,10);
		// ERROR "Unknown field"
		objVar.isVisible = false;
		// ERROR "Unknown method"
		objVar.foo();

		// ERROR "Names are case-sensitive"
		string ch = "A";
		// ERROR "Names are case-sensitive"
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
		// ERROR "Incorrect case for constant"
		boolVar = TRUE;
		// ERROR "Incorrect case for constant"
		if (False)
		// ERROR "Incorrect case for constant"
		objVar.clickable = FALSE;

		// ERROR "Use == to compare for equality"
		if (i = 0)
		// ERROR "Array element type does not match the array type"
		int[] intArr2 = {1, 2, 3.14};
		// ERROR "Array element type does not match the array type"
		double[] dblArr = {1, "two", 3.14};
		// ERROR "Cannot initialize array of String with type array of GameObj"
		String[] strArr = new GameObj[100];
		// ERROR "Cannot initialize array of boolean with type array of int"
		boolean[] boolArr = intArrFuncInt(10);
		// ERROR "Array count must be an integer"
		intArr = new int[1.5];

		// ERROR "Can only apply "++" to numeric types"
		boolVar++;
		// ERROR "Can only apply "++" to numeric types"
		strVar++;
		// ERROR "Can only apply "++" to numeric types"
		objVar++;
		// ERROR "Can only apply "--" to numeric types"
		boolVar--;
		// ERROR "Can only apply "--" to numeric types"
		strVar--;
		// ERROR "Can only apply "--" to numeric types"
		objVar--;

		// ERROR "The source variable in a for-each loop must be an array"
		for (int x : intVar)
		// ERROR "The source variable in a for-each loop must be an array"
		for (double x : dblVar)
		// ERROR "The source variable in a for-each loop must be an array"
		for (boolean x : boolVar)
		// ERROR "The source variable in a for-each loop must be an array"
		for (String x : strVar)
		// ERROR "The source variable in a for-each loop must be an array"
		for (GameObj x : objVar)
		// ERROR "The source variable in a for-each loop must be an array"
		for (GameObj x : strVar)
		
		// ERROR "Array "intArr" contains elements of type int"
		for (double x : intArr)
		// ERROR "Array "objArr" contains elements of type GameObj"
		for (String x : objArr)
		
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; intVar ; )
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; dblVar ; )
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; strVar ; )
		// ERROR "Loop test must evaluate to a boolean"
		for ( ; objVar ; )

		do
			voidFunc();
		// ERROR "Loop test must be boolean"
		while(intVar);
		// ERROR "Loop test must be boolean"
		while(dblVar)
		// ERROR "Loop test must be boolean"
		while(strVar)
		// ERROR "Loop test must be boolean"
		while(objVar)

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

		// ERROR "The Integer type is not supported by Code12. Use int instead."
		Integer n = 100;
		// ERROR "The Double type is not supported by Code12. Use double instead."
		Double d = 100.0;
		// ERROR "The Boolean type is not supported by Code12. Use boolean instead."
		Boolean b = false;
		// ERROR "+= can only be applied to numbers"
		strVar += "hello";
		// ERROR "Use str1.equals( str2 ) to compare two String values"
		if (strVar == "s")
		// ERROR "Unsupported operator"
		i = i ^ i;
		// ERROR "Unsupported operator"
		i = i & i;
		// ERROR "Unsupported operator"
		i = i | i;
		// ERROR "Unsupported operator"
		i = i >> 2;
		// ERROR "Unsupported operator"
		i = i << 2;
		// ERROR "Unsupported operator"
		i = i >>> 2;

		// ERROR "is reserved for use by the system"
		String ct;
		// ERROR "Names cannot start with an underscore in Code12"
		GameObj _fn;
		// ERROR " is a type name, expected a variable name here"
		int String;
		// ERROR " is a type name, expected a variable name here"
		double GameObj;

		int lowercasefirst = 1;
		// ERROR "Names are case-sensitive, known name is"
		int lowerCaseFirst = 10;
		GameObj upperCaseFirst = objVar;
		// ERROR "Names are case-sensitive, known name is"
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
		// ERROR "Inequality operator (>) can only apply to numbers"
		boolVar = objVar > dblVar;
		// ERROR "Inequality operator (<=) can only apply to numbers"
		while( boolVar <= intVar )
		// ERROR "Inequality operator (>=) can only apply to numbers"
		dblVar = dblVar >= intArr;

		// ERROR "Integer divide has remainder. Use double or ct.intDiv()"
		intVar = 1 / 2;
		// ERROR "Integer divide has remainder. Use double or ct.intDiv()"
		dblVar = 3 / 8;

		// ERROR "Variable intVar was already defined"
		int intVar = 13;
		// ERROR "Variable objArr was already defined"
		GameObj[] objArr = new GameObj[10];

		// ERROR "Method call on invalid type"
		intArr.voidFunc();
	}

	// ERROR "Return type of update function should be void"
	GameObj update()
	{
	}
	// ERROR "Return type of onMousePress function should be void"
	String onMousePress( GameObj obj, double x, double y )
	{
	}
	// ERROR "Wrong number of parameters for function"
	void onMousePress( double x, double y )
	{
	}
	// ERROR Wrong number of parameters for function"
	void onKeyPress( GameObj obj, double x, double y )
	{
	}

	// ERROR "Wrong number of parameters for function"
	// void onKeyRelease( ) // crash
	// {
	// }

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

	int myVar = 1;
	// ERROR "Variable myVar was already defined"
	void myFunc(int myVar)
	{
	}

}
