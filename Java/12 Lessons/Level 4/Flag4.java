// This program draws a modified American flag
// using variables and expressions.

class Flag4
{
	// The overall location of the flag
	double xFlag = 50;
	double yFlag = 44;
	double flagWidth = 80;

	// Primary flag colors
	String baseColor = "white";
	String stripeColor = "red";
	String fieldColor = "dark blue";

	// Computed measurements
	double flagHeight = flagWidth * 0.65;
	double top = yFlag - flagHeight / 2;
	double stripeHeight = flagHeight / 13;
	double left = xFlag - flagWidth / 2;
	double fieldWidth = flagWidth * 0.5;
	double fieldHeight = stripeHeight * 7;
	double xField = left + fieldWidth / 2;
	double yField = top + fieldHeight / 2;
	double textSize = fieldHeight * 0.11;

	public void start()
	{
		// Base white rectangle for the whole flag
		ct.rect( xFlag, yFlag, flagWidth, flagHeight, baseColor );

		// Stripes
		double y = top + stripeHeight * 0.5;    // y coordinate of top stripe
		ct.rect( xFlag, y, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 2, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 4, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 6, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 8, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 10, flagWidth, stripeHeight, stripeColor );
		ct.rect( xFlag, y + stripeHeight * 12, flagWidth, stripeHeight, stripeColor );

		// Blue field with eagle logo and text
		ct.rect( xField, yField, fieldWidth, fieldHeight, fieldColor );
		ct.circle( xField, yField, fieldHeight * 0.7, "light blue" );
		ct.image( "eagle.png", xField, yField, fieldHeight * 0.55 );
		ct.text( "United States of America", xField, top + textSize * 0.6, 
				textSize, baseColor );
		ct.text( "In Code We Trust", xField, top + fieldHeight - textSize * 0.7, 
				textSize, baseColor );
	}
}
