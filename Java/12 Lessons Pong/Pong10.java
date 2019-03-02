/*
	Pong10

	A two player Pong game with keyboard input.
	The w and s keys control the left paddle,
	the up and down arrow keys control the right paddle,
	and the space bar serves the ball.
*/
class Pong10
{
	// The game size
	final double WIDTH = 100;
	final double HEIGHT = WIDTH * 3 / 4;    // original tube TV aspect

	// Constants
	final String COLOR = "white";      // the color used for all game elements
	final double SCORE_SIZE = 10;      // size for score text
	final double PADDLE_SIZE = 10;     // height of paddles
	final double MARGIN = 10;          // space between paddle and side edge
	final double BALL_RADIUS = 1;      // ball radius
	final double BALL_SPEED = 1.0;     // ball speed
	final double PADDLE_SPEED = 1.0;   // paddle up/down speed
	final int MAX_ANGLE = 20;          // maximum serve angle in degrees

	// Game objects
	GameObj leftScoreText, rightScoreText;   // score display text objects
	GameObj leftPaddle, rightPaddle;         // paddles for player 1 and 2
	GameObj ball;                            // the ball
	GameObj serveMessage;                    // serve message text

	// Game variables
	int leftScore = 0;                 // left player's score
	int rightScore = 0;                // right player's score
	GameObj servingPaddle;             // the paddle that is serving or null if none

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 10" );
		ct.setHeight( HEIGHT );
		ct.setBackColor( "black" );
		ct.line( WIDTH / 2, 0, WIDTH / 2, HEIGHT, COLOR );

		// Make the score displays
		leftScoreText = makeScoreText( WIDTH * 0.25 );
		rightScoreText = makeScoreText( WIDTH * 0.75 );

		// Start both paddles in the center
		leftPaddle = makePaddle( MARGIN );
		rightPaddle = makePaddle( WIDTH - MARGIN );

		// Make the ball (will be positioned in update)
		ball = ct.circle( 0, 0, BALL_RADIUS * 2, COLOR );

		// Make the serve message text
		serveMessage = ct.text( "Press space to serve", 
							WIDTH * 0.25, SCORE_SIZE + 2, 4, "yellow" );

		// Start with the left paddle serving
		servingPaddle = leftPaddle;
	}

	// Make and return a score text object at the given x coordinate
	GameObj makeScoreText( double x )
	{
		return ct.text( "0", x, SCORE_SIZE / 2, SCORE_SIZE, COLOR );
	}

	// Make and return a paddle at the given x coordinate
	GameObj makePaddle( double x )
	{
		return ct.rect( x, HEIGHT / 2, BALL_RADIUS * 2, PADDLE_SIZE, COLOR );
	}

	public void update()
	{
		// Allow keys to move the paddles
		movePaddle( leftPaddle, "w", "s" );
		movePaddle( rightPaddle, "up", "down" );

		// Is the ball in play (already been served)?
		if (servingPaddle == null)
			updateBallInPlay();
		else
			waitForServe();
	}

	// Update the game for a ball in play
	void updateBallInPlay()
	{
		// Check for ball bounces and scores
		bounceBall();
		if (ball.x > WIDTH)
			leftScore = scorePoint( leftScore, leftScoreText, leftPaddle );
		if (ball.x < 0)
			rightScore = scorePoint( rightScore, rightScoreText, rightPaddle );
	}

	// Update the game while waiting for a serve
	void waitForServe()
	{
		constrainServer();
		if (ct.keyPressed( "space" ))
			serve();
	}

	// Check for the keys keyUp and keyDown to move the given paddle.
	void movePaddle( GameObj paddle, String keyUp, String keyDown )
	{
		if (ct.keyPressed( keyUp ) )
			paddle.y -= PADDLE_SPEED;
		if (ct.keyPressed( keyDown ))
			paddle.y += PADDLE_SPEED;
	}


	// Make the ball bounce off the walls and paddles 
	void bounceBall()
	{
		// Check the top and bottom walls
		if (ball.y < BALL_RADIUS || ball.y > HEIGHT - BALL_RADIUS)
			ball.setYSpeed( -ball.getYSpeed() );

		// Check the paddles
		if (ball.hit( leftPaddle ) || ball.hit( rightPaddle ))
			ball.setXSpeed( -ball.getXSpeed() );
	}

	// Add a point to the given score value for the given paddle, update the 
	// given scoreText with the new score, and return the new score value.
	int scorePoint( int score, GameObj scoreText, GameObj paddle )
	{
		score++;
		scoreText.setText( ct.formatInt( score ) );
		prepareForServe( paddle );
		return score;
	}

	// Prepare to wait for a serve by the given paddle.
	void prepareForServe( GameObj paddle )
	{
		servingPaddle = paddle;
		serveMessage.visible = true;
		if (servingPaddle == rightPaddle) 
			serveMessage.x = WIDTH * 0.75;
		else
			serveMessage.x = WIDTH * 0.25;
	}

	// Keep the serving paddle in a valid position and put the ball
	// in front of the paddle.
	void constrainServer()
	{
		// Don't let the paddle go off screen
		if (servingPaddle.y < MARGIN)
			servingPaddle.y = MARGIN;
		else if (servingPaddle.y > HEIGHT - MARGIN)
			servingPaddle.y = HEIGHT - MARGIN;

		// Position the ball right in front of the paddle
		double dxServe = servingPaddle.getWidth() / 2 + BALL_RADIUS + 0.5;
		if (servingPaddle == leftPaddle)
			ball.x = servingPaddle.x + dxServe;
		else 
			ball.x = servingPaddle.x - dxServe;
		ball.y = servingPaddle.y;
	}

	// Serve the ball
	void serve()
	{
		// Choose a random angle and set the ball speed
		int serveAngle = ct.random( -MAX_ANGLE, MAX_ANGLE );
		double radians = serveAngle * Math.PI / 180; 
		ball.setXSpeed( BALL_SPEED * Math.cos( radians ) );
		ball.setYSpeed( -BALL_SPEED * Math.sin( radians ) );
		if (servingPaddle == rightPaddle)    // reverse the serve direction
			ball.setXSpeed( -ball.getXSpeed() );

		// Hide the serve message and mark the ball in play
		serveMessage.visible = false;
		servingPaddle = null;
	}

}
