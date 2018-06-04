import Code12.*;

class UserCode extends Code12Program
{
	// instance variables
	GameObj ball, bigBall;
	int count, total;
	boolean gameOver;
	final int LIMIT = 600;
	// int count = 5;
	int speed = 3;

	// Move the ball
	int moveBall(boolean wrap)
	{
		// int wrap = 5;
		boolean hack;
		// String hack;

		// hack = 6;
		ball.x++;
		ball.x--;
		ball.x += 1;
		if (ball.x >= LIMIT)  // if (wrap == true && ball != null && !(ball.x >= LIMIT))
			ball.x = 0;

		--ball.x;
		++ball.x;
		return ball.x;
	}

	public void start()
	{
		int x = 10 + 50 * 10 + (45 / 3 * 2);
		String name = "Dave" + " " + "Parker";
		boolean done;

		// Draw some circles
		ball = ct.circle(x + 30, 70, 50);
		ct.circle(ct.intDiv(x, 2) + 10, 200, 150);
		bigBall = ct.circle(x, 400, 200);
		bigBall.setFillColor( "black" );

		double z = ball.x + 1;
		if (ball == bigBall || bigBall != null)
			z = 2;

		double ok = 9.0 / 5;
		double ok2 = 10 / 5;
		//double notOk = 9 / 5;
		//double notOK2 = x / 3;
	}

	public void update()
	{
		double factor = 2;
		String name;
		boolean tooFast, tooSlow;

		// Move ball
		int xNew = moveBall( true );

		// Move bigBall
		bigBall.x += speed;
		if (bigBall.x > LIMIT)
		{
			bigBall.x--;
			bigBall.width /= factor;
			bigBall.height *= /* WTF? */ (1 / factor);
			speed = -speed;
		}
		else if (bigBall.x < 0)
			speed = -this.speed;
		else
		{
			// Nothing
		}
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		if (true)  // obj != null)
			ct.println( obj.toString() + " was clicked" );
		else
			ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
	}
}
