// This program draws a modified American flag
// using variables.

class Flag3
{
	// The overall location of the flag
	double xFlag = 50;
	double flagWidth = 80;
	double fieldWidth = 40;
	double stripeHeight = 4;

	// Primary flag colors
	String baseColor = "white";
	String stripeColor = "red";
	String fieldColor = "dark blue";

	public void start()
	{
		// Base white rectangle for the whole flag
		ct.rect( xFlag, 44, flagWidth, 52, baseColor );

		// Stripes
		ct.rect( xFlag, 20, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 28, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 36, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 44, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 52, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 60, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, 68, flagWidth, stripeHeight, stripeColor );

		// Blue field with eagle logo and text
		double xField = 30;
		double yField = 32;
		ct.rect( xField, yField, fieldWidth, 28, fieldColor );
		ct.circle( xField, yField, 20, "light blue" );
		ct.image( "eagle.png", xField, yField, 15 );
		int textSize = 3;
		ct.text( "United States of America", xField, 20, textSize, baseColor );
		ct.text( "In Code We Trust", xField, 44, textSize, baseColor );
	}
}
