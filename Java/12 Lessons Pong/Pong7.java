/*
	Pong7

	This is the start of a Pong game, using variables, expressions,
	function return values, and object data fields and methods.

	For now the program:
	   * Draws the initial game elements 
	   * Calculates a random angle for the left player to serve the ball
	   * Positions the right paddle in the correct place to hit the serve
	   * Scores a point for the left player
	   * Tracks the hit status of the ball
*/
class Pong7
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
	final double BALL_SPEED = 1.0;    // ball speed
	final int MAX_ANGLE = 20;         // maximum serve angle in degrees

	// Game objects
	GameObj leftScoreText, rightScoreText;   // score display text objects
	GameObj leftPaddle, rightPaddle;         // paddles for player 1 and 2
	GameObj ball;                            // the ball

	// Game variables
	int leftScore = 0;             // left player's score
	int rightScore = 0;            // right player's score

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 7" );
		ct.setHeight( HEIGHT );
		ct.setBackColor( "black" );
		ct.line( WIDTH / 2, 0, WIDTH / 2, HEIGHT, COLOR );

		// Make the score displays
		double yScore = SCORE_SIZE / 2;
		leftScoreText = ct.text( "0", WIDTH * 0.25, yScore, SCORE_SIZE, COLOR );
		rightScoreText = ct.text( "0", WIDTH * 0.75, yScore, SCORE_SIZE, COLOR );

		// Start both paddles in the center
		double paddleWidth = BALL_RADIUS * 2;
		leftPaddle = ct.rect( MARGIN, HEIGHT / 2, paddleWidth, 
							PADDLE_SIZE, COLOR );
		rightPaddle = ct.rect( WIDTH - MARGIN, HEIGHT / 2, paddleWidth, 
							PADDLE_SIZE, COLOR );

		// Put the ball just in front of the left paddle
		double xBall = MARGIN + paddleWidth / 2 + BALL_RADIUS + 0.5;
		ball = ct.circle( xBall, leftPaddle.y, BALL_RADIUS * 2, COLOR );

		// Choose a random serve angle
		int serveAngle = ct.random( -MAX_ANGLE, MAX_ANGLE );
		ct.println( "Serve angle = " + serveAngle + " degrees" );

		// Move the right paddle to the correct position
		// to intercept the serve angle calculated above.
		double radians = serveAngle * Math.PI / 180;
		rightPaddle.y -= Math.tan( radians ) * (rightPaddle.x - ball.x);

		// Set the ball speed to move at the serve angle
		ball.setXSpeed( BALL_SPEED * Math.cos( radians ) );
		ball.setYSpeed( -BALL_SPEED * Math.sin( radians ) );

		// Simulate scoring a point for player 1
		leftScore++;
		leftScoreText.setText( ct.formatInt( leftScore ) );

	}

	public void update()
	{
		// At each animation frame, print the distance from the ball to the
		// right paddle and whether a hit was made.
		double distance = ct.distance( ball.x, ball.y, rightPaddle.x, rightPaddle.y );
		ct.print( "distance = " + ct.formatDecimal( distance, 1 ) );
		ct.println( ", hit = " + rightPaddle.hit( ball ) );
	}
}
