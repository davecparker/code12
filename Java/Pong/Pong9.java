// Pong9.java
// Function definitions

class Pong9
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	final double SPEED = 1;               // Speed of the paddles
	GameObj leftScore;     // Left score display
	GameObj rightScore;    // Right score dispaly
	GameObj leftPaddle;    // Left player paddle
	GameObj rightPaddle;   // Right player paddle
	GameObj ball;          // Game ball
	boolean ballInPlay;    // True when the ball is in play
	boolean firstServe;    // True the first time the ball is served
	int directionAngle;    // Angle from horizontal for the ball's path
	GameObj instructions;  // Text for showing gameplay instructions
	
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
		leftScore = ct.text( text, x, y, scoreHeight, color );
		// Make right score display
		x = WIDTH / 2 + scoreOffset;
		rightScore = ct.text( text, x, y, scoreHeight, color );
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
		// Make ball
		double x = 0;
		double y = 0;
		double diameter = 2;
		String color = "white";
		ball = ct.circle( x, y, diameter, color );
		ball.visible = false;
	}

	public void makeInstructions()
	{
		// Make instructions display
		String text = "Press space to serve the ball";
		double x = WIDTH / 2;
		double y = HEIGHT / 2;
		double h = 5;
		String color = "yellow";
		instructions = ct.text( text, x, y, h, color );
	}

	public void initStateVariables()
	{
		ballInPlay = false;
		firstServe = true;
	}

	// Serve the ball away from the side that last scored
	public void serveBall()
	{
		// Set ball speed and direction
		double ballSpeed = 0.7;
		if ( firstServe )
		{
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
		// Set the ball's x- and y-speeds
		ball.setXSpeed( ballSpeed * Math.cos( directionAngle * Math.PI / 180 ) );
		ball.setYSpeed( ballSpeed * Math.sin( directionAngle * Math.PI / 180 ) );
		// Set the ball at the center of the screen
		ball.x = WIDTH / 2;
		ball.y = HEIGHT / 2;
		// Set ball in play
		ballInPlay = true;
	}

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
		makeInstructions();
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
				// Update score
				if ( ballOffRightEdge )
				{
					int newScore = ct.parseInt( leftScore.getText() ) + 1;
					leftScore.setText( "" + newScore );
				}
				else
				{
					int newScore = ct.parseInt( rightScore.getText() ) + 1;
					rightScore.setText( "" + newScore );
				}
				// Prep for next serve
				ballInPlay = false;
				directionAngle = ct.round( Math.atan2( ball.getYSpeed(), ball.getXSpeed() ) * 180 / Math.PI );
				// Stop the ball moving so that it doesn't get auto deleted
				ball.setXSpeed( 0 );
				ball.setYSpeed( 0 );
				// Show the instructions for the next serve
				instructions.visible = true;
			}
		}
		else if ( ct.keyPressed( "space" ) )
		{
			serveBall();
			instructions.visible = false;
		}
	}
}
