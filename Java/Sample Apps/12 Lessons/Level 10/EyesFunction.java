/*
	In this version, with a user-defined function, 
	the code that draws an eye is written only once (better).
	However, class-level variables (x, y) must be used
	to specify the location of the eye.

*/
class EyesFunction
{
	// The position of an eye being drawn
	double x, y;

	public void start()
	{
		// Make the left eye
		x = 35;
		y = 30;
		makeEye();

		// Make the right eye
		x = 65;
		y = 30;
		makeEye();

		// Instructions
		ct.println( "Click to make more eyes" );
	}

	public void update()
	{
		// Make a new eye at each click location
		if (ct.clicked())
		{
			x = ct.round( ct.clickX() );
			y = ct.round( ct.clickY() );
			makeEye();
		}
	}

	// Make an eye at (x, y)
	public void makeEye()
	{
		GameObj ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		GameObj iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );
	}
}
