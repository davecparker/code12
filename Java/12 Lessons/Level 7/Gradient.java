class Gradient
{
	public void start()
	{
	}

	public void update()
	{
		// Make a dot at a random location
		GameObj dot = ct.circle( ct.random( 0, 100 ), ct.random( 0, 100 ), 10 );

		// Set its color based on its postion
		dot.setFillColorRGB( (int) (dot.x * 2.55), (int) (dot.y * 2.55), 0 );
		dot.setLineWidth( 0 );   // remove the outline

		// Set its size based on its height
		double size = dot.y / 5;
		dot.setSize( size, size );
	}
}
