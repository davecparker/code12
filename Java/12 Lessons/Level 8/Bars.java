class Bars
{
	GameObj bar1, bar2, bar3, bar4, bar5;

	public void start()
	{
		// Make 5 bars starting at the same location
		bar1 = ct.rect( 35, 50, 10, 10 );
		bar2 = ct.rect( 35, 50, 10, 10 );
		bar3 = ct.rect( 35, 50, 10, 10 );
		bar4 = ct.rect( 35, 50, 10, 10 );
		bar5 = ct.rect( 35, 50, 10, 10 );

		// Put each bar 10 to the right of the one before it
		bar2.x = bar1.x + 10;
		bar3.x = bar2.x + 10;
		bar4.x = bar3.x + 10;
		bar5.x = bar4.x + 10;

		// Make the bars different colors
		bar1.setFillColor( "red" );
		bar2.setFillColor( "orange" );
		bar4.setFillColor( "green" );
		bar5.setFillColor( "blue" );

		// Make each bar 10 higher than the one before it
		bar2.setSize( 10, bar1.getHeight() + 10 );
		bar3.setSize( 10, bar2.getHeight() + 10 );
		bar4.setSize( 10, bar3.getHeight() + 10 );
		bar5.setSize( 10, bar4.getHeight() + 10 );
	}
}
