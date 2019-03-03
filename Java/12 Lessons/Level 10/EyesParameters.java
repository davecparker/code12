/*
	In this version, with a user-defined function that
	takes parameters, the code that draws an eye is written 
	only once, and the position of the eye is specified
	using parameters instead of class-level variables (best).
*/
class EyesParameters
{
	public void start()
	{
		makeEye( 35, 30 );    // left eye
		makeEye( 65, 30 );    // right eye

		// Instructions
		ct.println( "Click to make more eyes" );
	}

	public void update()
	{
		// Make a new eye at each click location
		if (ct.clicked())
			makeEye( ct.round( ct.clickX() ), ct.round( ct.clickY() ) );
	}

	// Make an eye at (x, y)
	public void makeEye( double x, double y )
	{
		GameObj ball = ct.circle( x, y, 20, "white" );
		ball.setLineWidth( 4 );
		GameObj iris = ct.circle( x, y, 10 );
		iris.setFillColorRGB( 50, 70, 255 );
		ct.circle( x, y, 5, "black" );
		ct.println( "Eye at (" + x + ", " + y + ")" );
	}
}
