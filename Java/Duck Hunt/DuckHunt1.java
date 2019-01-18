// Syntax Level 1: Function Calls
// Draws the duckhunt background with a duck and the NES light gun.
class DuckHunt1
{
	public void start()
	{
		ct.setHeight( 56.25 );
		ct.setBackImage( "images/background.png" );
		ct.image( "images/duck.png", 50, 15, 10 );
		ct.rect( 45, 20, 0.5, 1.5, "white" );
		ct.image( "images/gun.png", 50, 50, 6 );
		ct.circle( 52, 40, 1, "black" );
	}
}
