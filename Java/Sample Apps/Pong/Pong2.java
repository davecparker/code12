// Pong2.java
// Comments
// Draws the start of a game of pong.

class Pong2
{
	public void start()
	{
		// Set background color to black
		ct.setBackColor( "black" );
		// Make center dividing line
		ct.line( 50, 0, 50, 100, "white" );
		// Make left score display
		ct.text( "0", 25, 5, 10, "white" );
		// Make right score display
		ct.text( "0", 75, 5, 10, "white" );
		// Make left paddle
		ct.rect( 10, 50, 2, 10, "white" );
		// Make right paddle
		ct.rect( 90, 50, 2, 10, "white" );
		// Make ball
		ct.circle( 15, 50, 2, "white" );
	}
}
