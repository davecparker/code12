import Code12.*;

class ErrorTest extends Code12Program
{
	public static void main(String[] args)
	{ 
		Code12.run(new ErrorTest()); 
	}

	// user defined functions
	int intFunc()
	{
		return 0;
	}
	int intFuncInt(int i)
	{
		return i * 2 + 1;
	}
	double dblFuncIntDbl(int i, double d)
	{
		return i + d;
	}
	
	// ERROR "Return type of start function should be void"
	public int start()
	{
		// These line are all OK
		// int, double, boolean, and String variable declarations and assignments;
		int i = 3;
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
		int exponentialNumberNoDot = 12e10;
		int exponentialNumberWithDot = 3.42e2;
		double expontialNumberWithDecimalPlaces = 6.62e-34;
		double d = 3.14;
		d = d / 2;
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
		b = b2 && b3;
		b2 = b2;
		String s = "A string variable";
		s = null;
		// arrays
		String[] colors = { "black", "white", "red", "green", "blue" };
		String[] strArr = new String[i];
		int[] intArr = {1, 2, 3};
		intArr = new int[100];
		double[] dblArr = {1.1, 2.2, 3.3};
		double[] dblArr2 = new double[100];
		dblArr = dblArr2;
		// if statements
		if (i == 0)
			ct.setBackColor(colors[i]);
		else if (i <= 10)
			i++;
		else
			i *= 5;

		if (i > 0)
		{
			j = 0;
			k = 0;
		}
		else if (i <= 10)
		{
			d = 7;
			ct.setSoundVolume(1);
		}
		else
		{
			String tempStr = "I'll be ";
			tempStr = tempStr + "out of scope soon";
		}
		if ( ct.isError(Math.tan(d)) && ct.distance(x1, y1, x2, y2) <= eps)
			ct.println("oops");
		
		// for loops

		// Code12 API -- Text Output
		ct.print("Hello world");
		ct.print("Hello" + " " + "world");
		ct.print("Hello world\n");
		ct.print(i);
		ct.print(d);
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
		d = Math.pow(Math.E, Math.PI * i) + 1;
		if (Math.abs(rect.x - img.x) < eps)
			i = Math.abs(i);
		d = Math.acos(-0.5) + Math.asin(Math.sqrt(3)/2) + Math.atan(1/Math.sqrt(2));
		d = Math.atan2(ct.clickX() - img.x, ct.clickY() - img.y);
		d = Math.ceil(d) + Math.cos(Math.PI / 2) + Math.sin(Math.PI * 2) + Math.tan(2 * Math.PI + 1);
		d = Math.cosh(0) + Math.sinh(d) - Math.tanh(3*i);
	}

	
	void expectedErrors()
	{
		// ERROR "Not enough parameters"
		ct.circle("Oops");
		// ERROR "Value of type double cannot be assigned to an int"
		int i = 3.4;
		// ERROR "Value of type double cannot be assigned to an int"
		i = 1.2;
		// ERROR "Undefined variable"
		x = x + 1;
		// ERROR "cannot be assigned to an int"
		int j = 5 + 3.14;
		// ERROR "cannot be assigned to an int"
		int plancksConst = 6.62e-34;
		// ERROR "already defined"
		int j = 3;
		// ERROR "Undefined function"
		foo();
		// ERROR "Function intFuncInt requires 1 parameter"
		if (intFuncInt() > 0)
		// ERROR "Parameter 1 of intFuncInt expects type int, but double was passed"
		int y = intFuncInt(2.3);
		// ERROR "Value of type int cannot be assigned to type boolean"
		boolean a = intFuncInt(2);
		// ERROR "Too many parameters passed to setBackColor"
		ct.setBackColor(255, 0, 0);
		// ERROR "Names are case-sensitive"
		string ch = "A";
		// ERROR "Names are case-sensitive"
		gameObj c = ct.circle(0,0,10);
		// ERROR "Names are case-sensitive"
		GameObj c = ct.Circle(0,0,10);
		// ERROR "Unknown API function"
		GameObj r = ct.rectangle(0,0,10,10);
		// ERROR "Use == to compare for equality"
		if (i = 0)
		// ERROR "Array element type does not match the array type"
		int[] intArr = {1, 2, 3.14};
		// ERROR "Array count must be an integer"
		intArr = new int[1.5];
		String str = "";
		// ERROR "+= can only be applied to numbers"
		str += "+= not supported for strings";
		// ERROR "Names are case-sensitive"
		double d = math.atan2(ct.clickX() - r.x, ct.clickY() - r.y);
		
	}
}

