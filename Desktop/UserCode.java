import Code12.*;

class UserCode extends Code12Program
{
	// instance variables
	GameObj ball, bigBall;
	int count, total;
	boolean gameOver;
	final int LIMIT = 120;
	// int count = 5;
	double speed = 0.3;

	public void start()
	{
		double x = (10 + 50 * 5 + (45 / 3 * 2)) / 5.0;
		int xInt = ct.toInt( x );
		String name = "Dave" + " " + "Parker";
		boolean done;

		// Draw some circles
		ball = ct.circle(x + 6, 15, 5);
		ct.circle(ct.intDiv(xInt, 2) + 10, 40, 5);
		bigBall = ct.circle(x, 80, 40);
		bigBall.setFillColor( "blue" );
		bigBall.clickable = true;

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
}
