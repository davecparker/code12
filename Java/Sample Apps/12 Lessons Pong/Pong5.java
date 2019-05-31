/*
	Pong5

	This is the start of a Pong game, using variables, expressions,
	and function return values.

	For now it draws the initial game elements, 
	calculates a random angle for the initial serve, 
	positions the right paddle in the correct place to hit it, 
	and plots the ball's trajectory with a line.
*/
class Pong5
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
	final int MAX_ANGLE = 20;         // maximum serve angle in degrees

	// Game variables
	double yLeft, yRight;       // paddle positions for left and right players
	double xBall, yBall;        // ball position

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 5" );
		ct.setHeight( HEIGHT );
		ct.setBackColor( "black" );
		ct.line( WIDTH / 2, 0, WIDTH / 2, HEIGHT, COLOR );

		// Make the score displays
		double yScore = SCORE_SIZE / 2;
		ct.text( "0", WIDTH * 0.25, yScore, SCORE_SIZE, COLOR );   // left
		ct.text( "0", WIDTH * 0.75, yScore, SCORE_SIZE, COLOR );   // right

		// Start the left paddle in the center on its side
		yLeft = HEIGHT / 2;
		double paddleWidth = BALL_RADIUS * 2;
		ct.rect( MARGIN, yLeft, paddleWidth, PADDLE_SIZE, COLOR );   // left

		// Put the ball just in front of the left paddle
		xBall = MARGIN + paddleWidth / 2 + BALL_RADIUS + 0.5;
		yBall = yLeft;
		ct.circle( xBall, yBall, BALL_RADIUS * 2, COLOR );

		// Choose a random serve angle
		int serveAngle = ct.random( -MAX_ANGLE, MAX_ANGLE );
		ct.println( "Serve angle = " + serveAngle + " degrees" );

		// Calculate starting position for the right paddle 
		// to intercept the serve angle calculated above.
		double xRight = WIDTH - MARGIN;
		double radians = serveAngle * 3.1416 / 180;   // degrees to radians
		yRight = yLeft - Math.tan( radians ) * (xRight - xBall);
		ct.rect( xRight, yRight, paddleWidth, PADDLE_SIZE, COLOR );   // right

		// Draw the serve trajectory with a line, so we can see
		// if the paddle was positioned correctly.
		ct.line( xBall, yBall, 
				xBall + WIDTH * Math.cos( radians ),
				yBall - WIDTH * Math.sin( radians ), COLOR );
	}
}
