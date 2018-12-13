// This program draws a modified American flag

class Flag
{
	// The overall location and size of the flag
	double flagLeft = 20;
	double flagTop = 20;
	double flagWidth = 70;

	// Computed sizes
	double flagHeight = flagWidth * 0.6;
	double textSize = flagWidth * (2.5 / 70);

	// Primary flag colors
	String stripeColor = "red";
	String fieldColor = "dark blue";
	String textColor = "white";

	public void start()
	{
		// 7 top stripes
		double x = flagLeft + flagWidth / 2;
		double stripeHeight = flagHeight / 13;
		double y = flagTop + stripeHeight / 2;
		ct.rect( x, y, flagWidth, stripeHeight, stripeColor );
		ct.rect( x, y + stripeHeight, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 2, flagWidth, stripeHeight, stripeColor );
		ct.rect( x, y + stripeHeight * 3, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 4, flagWidth, stripeHeight, stripeColor );
		ct.rect( x, y + stripeHeight * 5, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 6, flagWidth, stripeHeight, stripeColor );

		// Blue field
		double fieldWidth = flagWidth * 0.4;
		double fieldHeight = stripeHeight * 7;
		double xField = flagLeft + fieldWidth / 2;
		double yField = flagTop + fieldHeight / 2;
		ct.rect( xField, yField, fieldWidth, fieldHeight, fieldColor );

		// 6 bottom stripes
		ct.rect( x, y + stripeHeight * 7, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 8, flagWidth, stripeHeight, stripeColor );
		ct.rect( x, y + stripeHeight * 9, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 10, flagWidth, stripeHeight, stripeColor );
		ct.rect( x, y + stripeHeight * 11, flagWidth, stripeHeight, "white" );
		ct.rect( x, y + stripeHeight * 12, flagWidth, stripeHeight, stripeColor );

		// Eagle logo
		ct.circle( xField, yField, fieldHeight * 0.7, "light blue" );
		ct.image( "eagle.png", xField, yField, fieldHeight * 0.60 );

		// Text
		ct.text( "United States of America", xField, flagTop + textSize * 0.7, 
				textSize, textColor );
		ct.text( "In Code We Trust", xField, flagTop + fieldHeight - textSize * 0.7,
				textSize, textColor );

		// Flag pole
		double poleWidth = flagWidth / 15;
		double xPole = flagLeft - poleWidth * 0.8;
		double poleTop = flagTop - stripeHeight;
		double poleBottom = 100;
		double poleHeight = poleBottom - poleTop;
		ct.rect( xPole, poleTop + poleHeight / 2, poleWidth, poleHeight, "light gray" );
		ct.circle( xPole, poleTop, poleWidth * 1.5, "yellow" );
	}
}
