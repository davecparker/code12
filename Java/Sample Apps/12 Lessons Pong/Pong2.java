/*
	Pong2

	This is the start of a Pong game.
	For now it just draws the game elements in fixed positions.
*/
class Pong2
{
	public void start()
	{
		// The background and dividing line
		ct.setTitle( "Pong 2" );
		ct.setBackColor( "black" );
		ct.line( 50, 0, 50, 100, "white" );

		// The score displays
		ct.text( "0", 25, 5, 10, "white" );      // left
		ct.text( "0", 75, 5, 10, "white" );      // right

		// The paddles
		ct.rect( 10, 50, 2, 10, "white" );       // left
		ct.rect( 90, 50, 2, 10, "white" );       // right

		// The ball
		ct.circle( 12.5, 50, 2, "white" );
	}
}
