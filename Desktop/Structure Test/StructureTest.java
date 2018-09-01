import Code12.*;

class StructureTest extends Code12Program
{
	// instance variables
	GameObj fish, ball, bigBall;
	// GameObj[] moreBalls = new GameObj[10];
	int count, total;
	boolean gameOver = false;

	// More instance variables
	final int LIMIT = 120 + 4;
	double speed = 0.3;
	int frameCount = 0;
	int newCount = frameCount + 2 * -frameCount;
	String str = "Testing";

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
		ball.setFillColor( "blue" );
		frameCount = foo( LIMIT, speed * 2 );
		System.out.println("Program started");
	}

	int foo(int i, double d)
	{
		// Scanner scanner = new Scanner(System.in);
		i = 8;
		return 0;
	}

	int test(int i, double d)
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
		else if (d < i)
			d = -i;
		else
			i = 0;

		do
			i++;
		while (i < 0);

		d = 13;

		while (i > 10)
		{
			i--;
			i++;
		}

		d = 24;
		d = d * (1.0 - (int)Math.pow(d / d, i));

		for (int j = i; j < 10; j++)
		{
			d += i;
			i--;
		}

		i = (int) Math.PI * foo(1, 3.1);

		return 0;
	}

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
		for (GameObj c: circles)
			c.setFillColor( "black" );
		int[] scores = { 10, 20, 30 };
		return circles;
	}
}

