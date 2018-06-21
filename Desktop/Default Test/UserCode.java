import Code12.*;

class UserCode extends Code12Program
{
	// instance variables
	GameObj ball, bigBall;
	// GameObj tooSoon = ct.circle(50, 50, 50);
	int count, total;
	boolean gameOver = false;
	final int LIMIT = 120;
	// int count = 5;
	double speed = 0.3;

	public void start()
	{
		// int oops = count;
		// double nope = ball.x;
		double x = (10 + 50 * 5 + (45 / 3 * 2)) / 5.0;
		int xInt = ct.toInt( x );
		String name = "Dave" + " " + "Parker";
		boolean done;

		// Draw some circles
		ball = ct.circle(x + 6, 15, 5);
		ct.circle(ct.intDiv(xInt, 2) + 10, 40, 5);
		bigBall = ct.circle(x, 80, 40);
		bigBall.setFillColorRGB(400, 127, -50);
		bigBall.clickable = true;

		// Add a fish
		ct.image("goldfish.png", 50, 50, 15);

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

		// Move ball
		int xNew = moveBall( true );
		moveBall( false );

		// Move bigBall
		factor = factor + 0;
		bigBall.x += speed;
		if (bigBall.x > LIMIT)
		{
			double localX = 1.1 + 5;
			bigBall.x--;
			bigBall.width /= factor;
			bigBall.height *= /* WTF? */ (1 / factor);
			speed = -speed;
		}
		else if (bigBall.x < 0)
			speed = -this.speed;
		else
		{
			int localX = 3;
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
		ball.x += 0.5;
		if (wrap && ball.x >= LIMIT)
			ball.x = 0;

		--ball.x;
		++ball.x;
		return ball.x;
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		if (obj != null)
			ct.println( obj.toString() + " was clicked" );
		else
			ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
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

		int[] counts = { 2, 4, 5 + 6, 3 };
		int c = counts[0];

		int sum = 0;
		for (int cnt : counts )
			sum += cnt;

		for (double score : scores )
		{
			sum += ct.toInt( score );
		}

		for (;;)
		{
			sum += counts[c];
		}

		for (int i = 0; i < counts.length; i++)
			sum += counts[i];

		int [] aTest;
		aTest = new int[10];
	}

	public void onKeyPress( String key )
	{
		if (key.equals("b"))
			ct.println( "b was pressed" );
		else if (key.length() > 1)
			ct.println( "Long key" );

		String s = "  Dave ";
		ct.println(s.compareTo("Parker"));
		ct.log(s, s.trim(), s.toUpperCase(), s.substring(2), s.substring(2, 6), s.indexOf("D"));

		// Some common errors:
		// if (speed = 0)
		// 	ct.println("Still");

		// if (key == "n")
		// 	ct.print("n key");		
	}
}
