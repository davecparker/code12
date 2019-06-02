// Syntax Level 2: Comments
// Draws the duckhunt background with a duck and the NES light gun.
class DuckHunt2
{
	public void start()
	{
		// Set the game height
		ct.setHeight( 56.25 ); // For a 16 x 9 aspect ratio
		// Set the background image
		ct.setBackImage( "images/background.png" );
		// Draw a duck
		ct.image( "images/duck.png", 50, 15, 10 );
		// Draw a duck bomb below the duck
		ct.rect( 45, 20, 0.5, 1.5, "white" );
		// Draw the gun
		ct.image( "images/gun.png", 50, 50, 6 );
		// Draw a bullet above the gun
		ct.circle( 52, 40, 1, "black" );
	}
}
