/*
	Pong4

	This is the start of a Pong game, using variables and expressions.
	For now it just draws the game elements in fixed positions.
*/
class Pong4
{
	// The game size
	final double WIDTH = 100;
	final double HEIGHT = WIDTH * 3 / 4;    // original tube TV aspect

	// Constants
	final String COLOR = "white";     // the color used for all game elements
	final double SCORE_SIZE = 10;     // size for score text
	final double PADDLE_SIZE = 10;    // height of paddles
	final double MARGIN = 10;         // space between paddle and side edge
	final double BALL_RADIUS = 1;     // ball radius

	// Game variables
	double yLeft, yRight;       // paddle positions for left and right players

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 4" );
		ct.setHeight( HEIGHT );
		ct.setBackColor( "black" );
		ct.line( WIDTH / 2, 0, WIDTH / 2, HEIGHT, COLOR );

		// Make the score displays
		double yScore = SCORE_SIZE / 2;
		ct.text( "0", WIDTH * 0.25, yScore, SCORE_SIZE, COLOR );   // left
		ct.text( "0", WIDTH * 0.75, yScore, SCORE_SIZE, COLOR );   // right

		// Start both paddles in the center
		yLeft = HEIGHT / 2;
		yRight = yLeft;

		// Make the paddles
		double paddleWidth = BALL_RADIUS * 2;
		ct.rect( MARGIN, yLeft, paddleWidth, PADDLE_SIZE, COLOR );           // left
		ct.rect( WIDTH - MARGIN, yRight, paddleWidth, PADDLE_SIZE, COLOR );  // right

		// Put the ball just in front of the left paddle
		double xBall = MARGIN + paddleWidth / 2 + BALL_RADIUS + 0.5;
		double yBall = yLeft;
		ct.circle( xBall, yBall, BALL_RADIUS * 2, COLOR );
	}
}
