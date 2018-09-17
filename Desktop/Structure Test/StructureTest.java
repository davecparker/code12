import Code12.*;

class StructureTest extends Code12Program
{
	// instance variables
	private GameObj fish, ball, bigBall;
	// GameObj[] moreBalls = new GameObj[10];
	int count, total;
	public boolean gameOver = false;

	// More instance variables

	final int LIMIT = 120 + 4;
	double speed = 0.3;
	int frameCount = 0;
	int newCount = frameCount + 2 * -frameCount;
	String str = "Testing" + 3;

	public static void main(String[] args)
	{ 
		Code12.run(new StructureTest());
	}

	public void start()
	{
		final int X = 50;
		int y;
		y = X;
		ct.rect( X, 10, 50, 10 );
		ball = ct.circle( X, y, 30 );
		ball.setFillColor( "blue" );
		frameCount = foo( LIMIT, speed * 2 );
		System.out.println("Program started");
	}

	private int foo(int i, double d)
	{
		// Scanner scanner = new Scanner(System.in);
		i = 8;
		return 0;
	}

	int test(int i, double d)
	{
		int whILEe = 3;
		double z, y, w;

		i = foo( 3, 4 );
		if (i < 0)
			return i + 1;
		else
		{
			i += 3;
			d *= 2;
		}

		if (d < i)
		{
			i = 0;
			d = 1;
		}
		else
			i = 1;

		if (d == i)
			d = i;
		else if (d < i)
			d = -i;
		else
			return 0;

		do
			i++;
		while (i < 0);

		d = 13;

		while (i > 10)
		{
			i--;
			if (i > 10)
				break;
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
		return;
	}

	public void onMousePress( GameObj /* target */ obj, double x, double y )
	{
		ct.logm("Press", obj, x, y);
		// if (obj != null)
		// {
		// 	obj.xSpeed = .1;
		// 	ct.println( obj.toString() + " was clicked" );
		// }
		// else
		// 	ct.println( "Mouse was pressed at (" + x + ", " + y + ")" );
	}

	public void onMouseRelease( GameObj obj, double x, double y )
	{
		ct.logm("Release", obj, x, y);
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
		String in;
		return (int) ball.x;
	}

	GameObj[] makeCircles()
	{
		GameObj[] circles = new GameObj[10];
		// GameObj goo = new GameObj(10, 20, 30);
		for (GameObj c: circles)
			c.setFillColor( "black" );
		int[] scores = { 10, 20, 30 };
		double[] ratios = { 0, 1, 2 };
		GameObj[] coins = { null, circles[1], null, circles[2] };
		return circles;
	}

}

