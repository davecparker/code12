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
		ball = ct.circle( 50, 50, 30 );
	}

	int foo(int i, double d)
	{
		return i + 1;
	}

	// More instance variables
	final int LIMIT = 120 + 4;
	double speed = 0.3;
	int frameCount = foo( LIMIT, speed * 2 );
	int newCount = frameCount + 2 * -frameCount;
	String str = "Testing";

	public void update()
	{
		moveBall( true );
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
		return ball.x;
	}

	GameObj[] makeCircles()
	{
		GameObj[] circles = new GameObj[10];
		return circles;
	}
}

