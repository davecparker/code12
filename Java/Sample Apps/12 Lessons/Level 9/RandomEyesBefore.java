/*
	This version (not using a user-defined function) has
	the code that draws an eye written/copied 3 times (bad).
*/
class RandomEyesBefore
{
	final int MARGIN = 10;

	public void start()
	{
		// Make the first eye at a random location
		double x = ct.random( MARGIN, 100 - MARGIN );
		double y = ct.random( MARGIN, 100 - MARGIN );
		GameObj ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		GameObj iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );

		// Make a second eye at a random location
		x = ct.random( MARGIN, 100 - MARGIN );
		y = ct.random( MARGIN, 100 - MARGIN );
		ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );

		// Instructions
		ct.println( "Click to make more eyes" );
	}

	public void update()
	{
		// Each click adds another eye at a random location
		if (ct.clicked())
		{
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
}
