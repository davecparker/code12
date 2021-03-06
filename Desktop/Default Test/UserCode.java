import Code12.*;

class UserCode extends Code12Program
{
	// instance variables
	GameObj fish, ball, bigBall;
	GameObj[] moreBalls = new GameObj[10];
	// GameObj tooSoon = ct.circle(50, 50, 50);
	int count, total;
	boolean gameOver = false;
	final int LIMIT = 120;
	// int count = 5;
	double speed = 0.3;
	int frameCount = 0;
	String function = "Testing";

	public static void main(String[] args)
	{ 
		Code12.run(new UserCode()); 
	}
   
	public void start()
	{
		// int oops = count;
		// double nope = ball.x;
		// ct.circle(50, 50, LIMIT);
		double x = (10 + 50 * 5    ///
			+ (45 / 3 * 2))        ///  
			/ 5.0;
		int xInt = (int) x;
		String name = "Dave" + " " + "Parker";
		boolean done, end;
		// boolean _end = false;
		// int $java = 5;
		end = true;
      

		int[] nums = new int[10];
		// nums[10] = 4;
		// ct.println( nums[10] );

		// Try some console output
		ct.println(function + " " + 1.23e2);
		ct.println("This is the default \"Code12\" test app");
		ct.println("This is console output");
		ct.setOutputFile("output.txt");
		ct.println("This is file output also");
		ct.print("Beginning of line");
		ct.print(" - Middle - ");
		ct.println("End");
		ct.print("This\nis\nmultiple\nlines");
		ct.print(" of text");
		ct.println();
		ct.println("Here's a blank line:");
		ct.print("\n");
		ct.print("And another:");
		ct.println("\n");
		ct.print("Here's an unitialized GameObj: "); 
		ct.println(moreBalls[3]);
		ct.println("Done");
		ct.showAlert("Hey, this is an alert.\nThis is the second line.");
		String userName = ct.inputString("Enter your name");
		ct.println("Hello " + userName);
		boolean test = ct.inputYesNo("Would you like to print some lines?");
		if (test)
		{
			count = ct.inputInt("Enter number of lines to print");
			for (int i = 1; i <= count; i++)
			{
				ct.println("Line " + i);
			}
		}
      // ct.setOutputFile(null);

		// Draw some circles
		ball = ct.circle(x + 6, 15, 5);
		ball.setFillColor("blue");
		ct.circle(ct.intDiv(xInt, 2) + 10, 40, 5);
		bigBall = ct.circle(x, 80, 40);
		// bigBall.setFillColorRGB(400, 127, -50);
		bigBall.setFillColor(null);

		// Add a fish
		fish = ct.image("goldfish.png", 50, 50, 15);
		String filename = null;
		// ct.image(filename, 50, 20, 15);

		// Make a line
		GameObj line1 = ct.line(20, 80, 80, 80, "red");
		line1.setLineColor("MAGENTA");
		line1.setFillColor("red");

		double z = ball.x + 1;
		if (ball == bigBall || bigBall != null)
			z = 2;

		double ok = 9.0 / 5;
		double ok2 = 10 / 5;
		// double notOk =  1 / 2;
		//double notOK2 = x / 3;
	}

	public void update()
	{
		double factor = 2;
		String name;
		boolean tooFast, tooSlow;

		// frameCount++;
		// if (frameCount < 100)
		// 	ct.println(ct.getTimer());

		// Move ball
		int xNew = moveBall( true );
		xNew++;
		moveBall( false );

		// Move bigBall
		factor = factor + 0;
		bigBall.x += speed;
		if (bigBall.x > LIMIT)
		{
			double localX = 1.1 + 5;
			bigBall.x--;
			bigBall.setSize( bigBall.getWidth() / factor, bigBall.getHeight() / factor);
			speed = -speed;
		}
		else if (bigBall.x < 0)
			speed = -speed;
		else
		{
			int localX = 3;
		}

		// Check for keys
		if (ct.keyPressed("enter"))
			ct.println("Enter key pressed");
		else if (ct.keyPressed("backspace"))
			ct.println("Backspace key pressed");

		// Some keys trigger sounds
		if (ct.charTyped("L") && ct.loadSound("launch.wav"))
			ct.println("Launch sound loaded");
		if (ct.charTyped("l"))
			ct.sound("launch.wav");
		if (ct.charTyped("P") && ct.loadSound("pop.wav"))
			ct.println("Pop sound loaded");
		if (ct.charTyped("p"))
			ct.sound("pop.wav");

		// Check for fish click
		if (fish.clicked())
		{
			if (ct.inputYesNo("Continue?"))
				fish.setImage("goldfish right.png");
			else
				ct.restart();
		}
	}

	// Move the ball
	int moveBall(boolean wrap)
	{
		// int wrap = 5;
		boolean hack;
		// String hack;

		// hack = 6;
		ball.x++;
		ball.x--;
		ball.x += .5;
		if (wrap && ball.x >= LIMIT)
			ball.x = 0;

		--ball.x;
		++ball.x;
		return ct.round(ball.x);
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		if (obj != null)
		{
			obj.setXSpeed( .1 );
			ct.println( obj.toString() + " was clicked" );
		}
		else
			ct.logm( "onMousePress", x, y );
	}

	void loopAndArrayTest()
	{
		while (!gameOver)
		{
			speed += 3;
			if (speed > 10)
				break;
		}
		while (speed < 3)
			speed++;

		do
			speed--;
		while (speed > 4) ;

		do
		{
			speed += 3;
			speed--;
		}
		while (speed < 2) ;

		double[] scores = new double[10];
		boolean[] questions = new boolean[20];
		String[] strings = new String[5];

		int[] counts = { 2, 4, 5 + 6, 3 };
		int c = counts[0];

		int sum = 0;
		for (int cnt : counts )
			sum += cnt;

		for (double score : scores )
		{
			sum += (int) score;
		}

// 		for (;;)
// 		{
// 			sum += counts[c];
// 		}

		for (int i = 0; i < counts.length; i++)
			sum += counts[i];

		int [] aTest;
		aTest = new int[10];
		GameObj[] as, bs, cs;

		as = new GameObj[10];
		double myX = as[4].x;
		as[sum - 1].y = myX;
		as = makeCircles();

		// int [] ai = { 1, 2, 3.3 };
		double[] ad = { 1.1, 2.2, 0 };

		local();
	}

	void local()
	{
	}

	GameObj[] makeCircles()
	{
		GameObj[] circles = new GameObj[10];
		return circles;
	}

	public void onKeyPress( String key )
	{
		if (key.equals("b"))
			ct.println( "b was pressed" );
		else if (key.length() > 1)
			ct.println( "Long key" );

		String s = "  Dave ";
		// ct.println(s.compareTo("Parker"));
		// ct.log(s, s.trim(), s.toUpperCase(), s.substring(2), s.substring(2, 6), s.indexOf("D"));

		// Some common errors:
		// if (speed = 0)
		// 	ct.println("Still");

		// if (key == "n")
		// 	ct.print("n key");		
	}
}
