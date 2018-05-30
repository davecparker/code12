import Code12.*;

class UserCode extends Code12Program
{
	// instance variables
	GameObj ball, bigBall;
	int count, total;
	boolean gameOver;
	final int LIMIT = 600;
	int speed = 3;

	// Move the ball
	void moveBall(boolean wrap)
	{
		ball.x++;
		if (wrap && ball != null && !(ball.x <= LIMIT))
			ball.x = 0;

		--ball.x;
		++ball.x;
	}

	public void start()
	{
		int x = 10 + 50 * 2 + (45 * 2);
		// String name = "Dave" + " " + "Parker";
		boolean done;

		// Draw some circles
		ball = ct.circle(x + 30, 70, 50);
		ct.circle(x / 2 + 10, 200, 150);
		bigBall = ct.circle(x, 400, 200);
	}

	public void update()
	{
		double factor = 2;
		String name;
		boolean tooFast, tooSlow;

		// Move ball
		moveBall( true );

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
		if (obj != nil)
			ct.println( obj.toString() + " was clicked" );
		else
			ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
	}
}
