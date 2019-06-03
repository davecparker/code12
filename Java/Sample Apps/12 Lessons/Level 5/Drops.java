class Drops
{
	int maxSize;

	public void start()
	{
		maxSize = ct.inputInt( "Enter the maximum drop size" );
	}

	public void update()
	{
		// Add a new drop at each animation frame (60 times per second)
		int x = ct.random( 0, 100 );
		int y = ct.random( 0, 100 );
		ct.circle( x, y, ct.random( 1, maxSize ), "blue" );
	}
}
