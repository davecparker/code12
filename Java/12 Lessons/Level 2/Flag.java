// This program draws a modified American flag

class Flag
{
	public void start()
	{
		// 7 top stripes
		ct.rect( 50, 20, 80, 4, "red" );
		ct.rect( 50, 24, 80, 4, "white" );
		ct.rect( 50, 28, 80, 4, "red" );
		ct.rect( 50, 32, 80, 4, "white" );
		ct.rect( 50, 36, 80, 4, "red" );
		ct.rect( 50, 40, 80, 4, "white" );
		ct.rect( 50, 44, 80, 4, "red" );

		// Blue field
		ct.rect( 30, 32, 40, 28, "dark blue" );

		// 6 bottom stripes
		ct.rect( 50, 48, 80, 4, "white" );
		ct.rect( 50, 52, 80, 4, "red" );
		ct.rect( 50, 56, 80, 4, "white" );
		ct.rect( 50, 60, 80, 4, "red" );
		ct.rect( 50, 64, 80, 4, "white" );	
		ct.rect( 50, 68, 80, 4, "red" );

		// Eagle logo
		ct.circle( 30, 32, 20, "light blue" );
		ct.image( "eagle.png", 30, 32, 15 );

		// Text
		ct.text( "United States of America", 30, 20, 3, "white" );
		ct.text( "In Code We Trust", 30, 44, 3, "white" );
	}
}
