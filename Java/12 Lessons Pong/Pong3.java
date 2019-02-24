/*
	Pong3

	This is the start of a Pong game, using variables.
	For now it just draws the game elements in fixed positions.
*/
class Pong3
{
	// Constants
	final String COLOR = "white";     // the color used for all game elements
	final double SCORE_SIZE = 10;     // size for score text
	final double PADDLE_SIZE = 10;    // height of paddles

	// Game variables
	double yLeft, yRight;       // paddle positions for left and right players

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 3" );
		ct.setBackColor( "black" );
		ct.line( 50, 0, 50, 100, COLOR );

		// Make the score displays
		double yScore = 5;
		ct.text( "0", 25, yScore, SCORE_SIZE, COLOR );      // left
		ct.text( "0", 75, yScore, SCORE_SIZE, COLOR );      // right

		// Start both paddles in the center
		yLeft = 50;
		yRight = yLeft;

		// Make the paddles
		double paddleWidth = 2;
		ct.rect( 10, yLeft, paddleWidth, PADDLE_SIZE, COLOR );    // left
		ct.rect( 90, yRight, paddleWidth, PADDLE_SIZE, COLOR );   // right

		// Put the ball just in front of the left paddle
		ct.circle( 12.5, yLeft, 2, COLOR );
	}
}
