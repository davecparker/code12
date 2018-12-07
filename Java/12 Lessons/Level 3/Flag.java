// This program draws a modified American flag

class Flag
{
	// The overall location of the flag
	int xFlag = 55;
	double xField = 37.5;
	int width = 70;
	int fieldWidth = 35;
	int stripeHeight = 4;

	// Primary flag colors
	String stripeColor = "red";
	String fieldColor = "dark blue";
	String textColor = "white";

	public void start()
	{
		// 7 top stripes
		ct.rect( xFlag, 20, width, stripeHeight, stripeColor );
		ct.rect( xFlag, 24, width, stripeHeight, "white" );
		ct.rect( xFlag, 28, width, stripeHeight, stripeColor );
		ct.rect( xFlag, 32, width, stripeHeight, "white" );
		ct.rect( xFlag, 36, width, stripeHeight, stripeColor );
		ct.rect( xFlag, 40, width, stripeHeight, "white" );
		ct.rect( xFlag, 44, width, stripeHeight, stripeColor );

		// Blue field
		ct.rect(xField, 32, fieldWidth, 28, fieldColor );

		// 6 bottom stripes
		ct.rect( xFlag, 48, width, stripeHeight, "white" );
		ct.rect( xFlag, 52, width, stripeHeight, stripeColor );
		ct.rect( xFlag, 56, width, stripeHeight, "white" );
		ct.rect( xFlag, 60, width, stripeHeight, stripeColor );
		ct.rect( xFlag, 64, width, stripeHeight, "white" );	
		ct.rect( xFlag, 68, width, stripeHeight, stripeColor );

		// Eagle logo
		int yLogo = 32;
		ct.circle( xField, yLogo, 20, "light blue" );
		ct.image( "eagle.png", xField, yLogo, 15 );

		// Text
		int textSize = 3;
		ct.text( "United States of America", xField, 20, textSize, textColor );
		ct.text( "In Code We Trust", xField, 44, textSize, textColor );

		// Flag pole
		int xPole = 15;
		ct.rect( xPole, 60, 6, 84, "light gray" );
		ct.circle( xPole, 15, 10, "yellow" );
	}
}
