/*
	This version (not using a user-defined function) 
	has the code that draws an eye copied 3 times (bad).
*/
class EyesBefore
{

	public void start()
	{
		// Make the left eye
		double x = 35;
		double y = 30;
		GameObj ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		GameObj iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );

		// Make the right eye
		x = 65;
		y = 30;
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
		// Make a new eye at each click location
		if (ct.clicked())
		{
			double x = ct.round( ct.clickX() );
			double y = ct.round( ct.clickY() );
			GameObj ball = ct.circle( x, y, 20, "white" );
			ball.setLineWidth( 4 );
			GameObj iris = ct.circle( x, y, 10 );
			iris.setFillColorRGB( 50, 70, 255 );
			ct.circle( x, y, 5, "black" );
			ct.println( "Eye at (" + x + ", " + y + ")" );
		}
	}
}
