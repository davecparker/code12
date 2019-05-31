// Pong9.java
// Function definitions
// A playable two-player Pong-like game.
// w and s keys control the left paddle, up and down keys control the right paddle.

class Pong9
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	final double SPEED = 1;               // Speed of the paddles
	final double MAX_SCORE = 15;          // Score needed to win the game
	int leftScore;              // Left player's score
	int rightScore;             // Right player's score
	GameObj leftScoreDisplay;   // Left player's score display
	GameObj rightScoreDisplay;  // Right player's score dispaly
	GameObj leftPaddle = null;    // Left player paddle
	GameObj rightPaddle = null;   // Right player paddle
	GameObj ball = null;          // Game ball
	boolean ballInPlay = false;    // True when the ball is in play
	boolean firstServe;    // True the first time the ball is served
	int directionAngle;    // Angle from horizontal for the ball's path
	GameObj instructions;  // Text for showing gameplay instructions
	GameObj endGameMsg;    // Text for showing end of game message

	public void start()
	{
		// Set height of graphics output window
		ct.setHeight( HEIGHT );
		// Set background color to black
		ct.setBackColor( "black" );
		// Make display objects
		makeCenterLine();
		makeScoreDisplays();
		makePaddles();
		makeBall();
		makeTextDisplays();
		// Initialize game state variables
		initStateVariables();
	}

	public void update()
	{
		// Up/down arrow keys control the right paddle
		if (ct.keyPressed( "up" ))
			rightPaddle.setYSpeed( -SPEED );
		else if (ct.keyPressed( "down" ))
			rightPaddle.setYSpeed( SPEED );
		else
			rightPaddle.setYSpeed( 0 );
		
		// w/s letter keys control the left paddle
		if (ct.keyPressed( "w" ))
			leftPaddle.setYSpeed( -SPEED );
		else if (ct.keyPressed( "s" ))
			leftPaddle.setYSpeed( SPEED );
		else
			leftPaddle.setYSpeed( 0 );

		if ( ballInPlay )
		{
			// Make ball bounce off the the top and bottom of the game window and the paddles
			boolean ballHitTop = ball.y < ball.getWidth() / 2;
			boolean ballHitBottom = ball.y > HEIGHT - ball.getWidth() / 2;
			if ( ballHitTop || ballHitBottom )
				ball.setYSpeed( -ball.getYSpeed() );
			else if ( ball.hit( leftPaddle ) || ball.hit( rightPaddle ) )
				ball.setXSpeed( -ball.getXSpeed() );

			// Update the score if the ball goes off the right or left edge of the game window
			boolean ballOffRightEdge = ball.x > WIDTH + ball.getWidth() / 2;
			boolean ballOffLeftEdge = ball.x < -ball.getWidth() / 2;
			if ( ballOffRightEdge || ballOffLeftEdge )
			{
				if ( ballOffRightEdge )
					updateLeftScore();
				else
					updateRightScore();
				checkForWin();
				prepForNextServe();
			}
		}
		else if ( ct.keyPressed( "space" ) )
			serveBall();
	}

	public void makeCenterLine()
	{
		// Make center dividing line
		double x1 = WIDTH / 2;
		double y1 = 0;
		double x2 = x1;
		double y2 = HEIGHT;
		String color = "white";
		ct.line( x1, y1, x2, y2, color );
	}

	public void makeScoreDisplays()
	{
		// Make left score display
		String text = "0";
		double scoreHeight = 10;
		double scoreOffset = 25;
		double x = WIDTH / 2 - scoreOffset;
		double y = scoreHeight / 2;
		String color = "white";
		leftScoreDisplay = ct.text( text, x, y, scoreHeight, color );
		// Make right score display
		x = WIDTH / 2 + scoreOffset;
		rightScoreDisplay = ct.text( text, x, y, scoreHeight, color );
	}

	public void makePaddles()
	{
		double paddleMargin = 10;
		double paddleWidth = 2;
		double paddleHeight = 10;
		double y = HEIGHT / 2;
		String color = "white";
		// Make left paddle
		double x = paddleMargin;
		leftPaddle = ct.rect( x, y, paddleWidth, paddleHeight, color );
		// Make right paddle
		x = WIDTH - paddleMargin;
		rightPaddle = ct.rect( x, y, paddleWidth, paddleHeight, color );
	}

	public void makeBall()
	{
		double x = 0;
		double y = 0;
		double diameter = 2;
		String color = "white";
		ball = ct.circle( x, y, diameter, color );
		ball.visible = false;
	}

	public void makeTextDisplays()
	{
		// Make instructions display
		String text = "Press space to serve the ball";
		double x = WIDTH / 2;
		double y = HEIGHT / 2;
		double h = 5;
		String color = "yellow";
		instructions = ct.text( text, x, y, h, color );
		// Make end of game display
		y = instructions.y - instructions.getHeight() * 2;
		endGameMsg = ct.text( "", x, y, h, color );
	}

	public void initStateVariables()
	{
		leftScore = 0;
		rightScore = 0;
		ballInPlay = false;
		firstServe = true;
	}

	public void updateLeftScore()
	{
		leftScore++;
		leftScoreDisplay.setText( "" + leftScore );
	}

	public void updateRightScore()
	{
		rightScore++;
		rightScoreDisplay.setText( "" + rightScore );
	}

	public void prepForNextServe()
	{
		ballInPlay = false;
		directionAngle = ct.round( Math.atan2( ball.getYSpeed(), ball.getXSpeed() ) * 180 / Math.PI );
		// Stop the ball moving so that it doesn't get auto deleted
		ball.setXSpeed( 0 );
		ball.setYSpeed( 0 );
		// Show the instructions for the next serve
		instructions.visible = true;
	}

	public void checkForWin()
	{
		if ( leftScore == MAX_SCORE || rightScore == MAX_SCORE )
		{
			firstServe = true;
			endGameMsg.visible = true;
			if ( leftScore == MAX_SCORE )
				endGameMsg.setText( "Left Player Wins!" );
			else
				endGameMsg.setText( "Right Player Wins!" );
		}
	}

	// Serve the ball away from the side that last scored
	public void serveBall()
	{
		// Hide instructions
		instructions.visible = false;
		// Set ball speed and direction
		if ( firstServe )
		{
			initStateVariables();
			// Set score displays
			leftScoreDisplay.setText( "0" );
			rightScoreDisplay.setText( "0" );
			// Hide end of game text
			endGameMsg.visible = false;
			// Give the ball a random direction
			int spread = 15; // Max number of degrees up/down from horizontal the ball will be served
			int direction = ct.random( 1, 2 );
			if ( direction == 1 )
				// Serve the ball to the right
				directionAngle = ct.random( -spread, spread );
			else
				// Serve the ball to the left
				directionAngle = ct.random( 180 - spread, 180 + spread );
			firstServe = false;
			ball.visible = true;
		}
		// Set the ball's velocity
		double ballSpeed = 1.5;
		double radians = directionAngle * Math.PI / 180;
		ball.setXSpeed( ballSpeed * Math.cos( radians ) );
		ball.setYSpeed( ballSpeed * Math.sin( radians ) ); 
		// Set the ball at the center of the screen
		ball.x = WIDTH / 2;
		ball.y = HEIGHT / 2;
		// Set ball in play
		ballInPlay = true;
	}
}
