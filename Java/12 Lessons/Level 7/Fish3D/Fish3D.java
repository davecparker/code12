class Fish3D
{
	public void start()
	{
		// Set a background image, and make (0, 0) the apparent 
		// vanishing point of the image to simplify the calculations.
		ct.setBackImage( "water.jpg" );
		ct.setScreenOrigin( -50, -40 );
	}

	public void update()
	{
		// Make a fish at a random location on screen
		double x = ct.random( -50, 50 );
		double y = ct.random( -30, 50 );
		GameObj fish = ct.image( "goldfish.png", x, y, 20 );

		// Choose a random distance for the fish from the viewer
		double z = ct.random( 1, 20 );

		// Scale the fish's position and size based on its distance
		fish.x /= z;
		fish.y /= z;
		fish.setSize( fish.getWidth() / z, fish.getHeight() / z );

		// Set a scaled swimming speed based on distance
		fish.setXSpeed( 1 / z );

		// Make sure all fish start off-screen to the left
		fish.x -= 120;
	}
}
