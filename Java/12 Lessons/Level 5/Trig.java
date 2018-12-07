class Trig
{
	public void start()
	{
		// Draw axes and the circle
		double radius = 40;
		double x0 = 50;
		double y0 = 50;
		ct.circle( x0, y0, radius * 2, "white" );
		ct.line( x0, 0, x0, 100 );
		ct.line( 0, y0, 100, y0 );

		// Ask the user for an angle
		double degrees = ct.inputNumber( "Enter an angle in degrees" );
		double radians = degrees * 3.1416 / 180;

		// Do the trig to find the point on the circle
		double x = x0 + radius * Math.cos( radians );
		double y = y0 - radius * Math.sin( radians );

		// Draw the dot, triangle, and text label
		ct.circle( x, y, 4 );
		ct.line( x, y, x0, y0, "red" );
		ct.line( x, y, x, y0, "red" );
		ct.line( x0, y0, x, y0, "red" );
		String xText = ct.formatDecimal( Math.cos( radians ), 2 );
		String yText = ct.formatDecimal( Math.sin( radians ), 2 );
		String label = "(" + xText + ", " + yText + ")";
		ct.text( label, x, y - 6, 4 );

		// Compute hypotenuse length and compare to radius
		double h = Math.sqrt( Math.pow(x - x0, 2) + Math.pow(y - y0, 2) );
		ct.println( "hypotenuse = " + h );
		ct.println( "radius = " + radius );
	}
}
