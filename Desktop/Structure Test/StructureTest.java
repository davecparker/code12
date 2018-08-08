import Code12.*;

class StructureTest extends Code12Program
{
	// instance variables
	GameObj fish, ball, bigBall;
	// GameObj[] moreBalls = new GameObj[10];
	int count, total;
	boolean gameOver = false;

	public static void main(String[] args)
	{ 
		Code12.run(new StructureTest()); 
	}
   
	public void start()
	{
		final int X = 50;
		int y;
		y = X;
		ball = ct.circle( X, y, 30 );
	}

	int foo(int i, double d)
	{
		if (i < 0)
			return i + 1;
		else
		{
			i += 3;
			d *= 2;
		}

		if (d == i)
			d = i;
		else
			i = 0;

		return 0;
	}

	// More instance variables
	final int LIMIT = 120 + 4;
	double speed = 0.3;
	int frameCount = foo( LIMIT, speed * 2 );
	int newCount = frameCount + 2 * -frameCount;
	String str = "Testing";

	public void update()
	{
		moveBall( false );
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		// if (obj != null)
		// {
		// 	obj.xSpeed = .1;
		// 	ct.println( obj.toString() + " was clicked" );
		// }
		// else
		// 	ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
	}

	// Move the ball
	int moveBall(boolean wrap)
	{
		ball.x++;
		if (wrap)
		{
			boolean checked = true;
			if (ball.x > 100)
				ball.x = 0;
		}
		return ball.x;
	}

	GameObj[] makeCircles()
	{
		GameObj[] circles = new GameObj[10];
		int[] scores = { 10, 20, 30 };
		return circles;
	}
}

