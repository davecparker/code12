/*
	This version uses a user-defined function so that the
	code that draws an eye is only written once (much better).
*/
class RandomEyesFunction
{

	public void start()
	{
		// Make two eyes at random locations
		makeRandomEye();
		makeRandomEye();

		// Instructions
		ct.println( "Click to make more eyes" );
	}

	public void update()
	{
		// Each click adds another eye at a random location
		if (ct.clicked())
			makeRandomEye();
	}

	// Make an eye at a random location
	void makeRandomEye()
	{
		final int MARGIN = 10;
		double x = ct.random( MARGIN, 100 - MARGIN );
		double y = ct.random( MARGIN, 100 - MARGIN );
		GameObj ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		GameObj iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );
	}
}
