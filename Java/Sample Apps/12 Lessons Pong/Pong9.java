/*
	Pong9

	A two player Pong game with keyboard input.
	The w and s keys control the left paddle,
	the up and down arrow keys control the right paddle,
	and the space bar serves the ball.
*/
class Pong9
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
	int leftScore = 0;             // left player's score
	int rightScore = 0;            // right player's score
	boolean ballInPlay = false;    // true if the ball is served and in play
	boolean rightServe = false;    // true if right player serves next
	double dxServe;                // space between paddle and ball at serve

	public void start()
	{
		// Make the background and dividing line
		ct.setTitle( "Pong 9" );
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
		dxServe = paddleWidth / 2 + BALL_RADIUS + 0.5;

		// Make the ball (will be positioned in update)
		ball = ct.circle( 0, 0, BALL_RADIUS * 2, COLOR );

		// Make the serve message text
		serveMessage = ct.text( "Press space to serve", 
							WIDTH * 0.25, SCORE_SIZE + 2, 4, "yellow" );
	}

	public void update()
	{
		// Allow keys to move the paddles
		movePaddles();

		// Has the ball been served yet?
		if (ballInPlay)
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
			scoreLeftPoint();
		if (ball.x < 0)
			scoreRightPoint();
	}

	// Update the game while waiting for a serve
	void waitForServe()
	{
		// Keep the serving paddle in bounds
		if (rightServe)
			constrainRightServer();
		else
			constrainLeftServer();

		// Space bar serves ball
		if (ct.keyPressed( "space" ))
			serve();
	}

	// Check for keys that moves the paddles and move them as appropriate.
	void movePaddles()
	{
		// Up and down arrow keys control the right paddle
		if (ct.keyPressed( "up" ) )
			rightPaddle.y -= PADDLE_SPEED;
		if (ct.keyPressed( "down" ))
			rightPaddle.y += PADDLE_SPEED;
		
		// w and s keys control the left paddle
		if (ct.keyPressed( "w" ))
			leftPaddle.y -= PADDLE_SPEED;
		if (ct.keyPressed( "s" ))
			leftPaddle.y += PADDLE_SPEED;		
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

	// Score a point for the left player and prepare for a left serve
	void scoreLeftPoint()
	{
		leftScore++;
		leftScoreText.setText( ct.formatInt( leftScore ) );
		ballInPlay = false;
		rightServe = false;
		serveMessage.visible = true;
		serveMessage.x = WIDTH * 0.25;
	}

	// Score a point for the right player and prepare for a right serve
	void scoreRightPoint()
	{
		rightScore++;
		rightScoreText.setText( ct.formatInt( rightScore ) );
		ballInPlay = false;
		rightServe = true;
		serveMessage.visible = true;
		serveMessage.x = WIDTH * 0.75;
	}

	// Keep the right paddle and the ball in serving position
	void constrainRightServer()
	{
		// Don't let the paddle go off screen
		if (rightPaddle.y < MARGIN)
			rightPaddle.y = MARGIN;
		else if (rightPaddle.y > HEIGHT - MARGIN)
			rightPaddle.y = HEIGHT - MARGIN;

		// Position the ball right in front of the paddle
		ball.x = rightPaddle.x - dxServe; 
		ball.y = rightPaddle.y;
	}

	// Keep the left paddle and the ball in serving position
	void constrainLeftServer()
	{
		// Don't let the paddle go off screen
		if (leftPaddle.y < MARGIN)
			leftPaddle.y = MARGIN;
		else if (leftPaddle.y > HEIGHT - MARGIN)
			leftPaddle.y = HEIGHT - MARGIN;

		// Position the ball right in front of the paddle
		ball.x = leftPaddle.x + dxServe;
		ball.y = leftPaddle.y;
	}

	// Serve the ball
	void serve()
	{
		// Choose a random angle and set the ball speed
		int serveAngle = ct.random( -MAX_ANGLE, MAX_ANGLE );
		double radians = serveAngle * Math.PI / 180; 
		ball.setXSpeed( BALL_SPEED * Math.cos( radians ) );
		ball.setYSpeed( -BALL_SPEED * Math.sin( radians ) );
		if (rightServe)    // reverse the serve direction
			ball.setXSpeed( -ball.getXSpeed() );

		// Hide the serve message and mark the ball in play
		serveMessage.visible = false;
		ballInPlay = true;
	}

}
