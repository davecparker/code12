// Pong12.java
// Arrays
// A playable two-player Pong-like game.
// w and s keys control the left paddle, up and down keys control the right paddle.

class Pong12
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	final double PADDLE_SPEED = 1;               // Speed of the paddles
	final double MAX_SCORE = 15;          // Score needed to win the game
	final double SCORE_HEIGHT = 10;       // Height of the score displays
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
	String[] colors = { "red", "orange", "yellow", "green", "cyan", "blue", "magenta" };

	public void start()
	{
		// Set height of graphics output window
		ct.setHeight( HEIGHT );
		// Set background color to black
		ct.setBackColor( "black" );
		// Make display objects
		makeCenterLine();
		makeGoalBlocks();
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
			rightPaddle.setYSpeed( -PADDLE_SPEED );
		else if (ct.keyPressed( "down" ))
			rightPaddle.setYSpeed( PADDLE_SPEED );
		else
			rightPaddle.setYSpeed( 0 );
		
		// w/s letter keys control the left paddle
		if (ct.keyPressed( "w" ))
			leftPaddle.setYSpeed( -PADDLE_SPEED );
		else if (ct.keyPressed( "s" ))
			leftPaddle.setYSpeed( PADDLE_SPEED );
		else
			leftPaddle.setYSpeed( 0 );

		if ( ballInPlay )
		{
			// Make ball bounce off the the top and bottom of the game window and the paddles
			boolean ballHitTop = ball.y < ball.getWidth() / 2;
			boolean ballHitBottom = ball.y > HEIGHT - ball.getWidth() / 2;
			GameObj blockHit = ball.objectHitInGroup( "goalBlocks" );
			if ( blockHit != null )
			{
				blockHit.delete();
				ball.setXSpeed( -ball.getXSpeed() );
			}
			else if ( ballHitTop || ballHitBottom )
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

	public GameObj newGoalBlock( double x, double y, double h, String side, String color )
	{
		GameObj block = ct.rect( x, y, 2, h, color );
		block.group = "goalBlocks";
		block.align( "top " + side );
		return block;
	}


	public void scrambleArray( String[] arr )
	{
		int n = arr.length;
		for ( int i = 0; i < n; i++ )
		{
			int j = ct.random( 0, n - 1 );
			String temp = arr[i];
			arr[i] = arr[j];
			arr[j] = temp;
		}
	}

	public void makeGoalBlocks()
	{
		double blockWidth = 2;
		double blockHeight = 10;
		int numBlocks = (int) Math.ceil( HEIGHT / blockHeight );
		// Make left goal blocks with a for loop
		scrambleArray( colors );
		for ( int i = 0; i < numBlocks; i++ )
		{
			double y = i * blockHeight;
			newGoalBlock( 0, y, blockHeight, "left", colors[i % colors.length] );
		}
		// Make right goal blocks with a while loop
		scrambleArray( colors );
		int i = 0;
		double y = 0;
		while ( y < HEIGHT )
		{
			newGoalBlock( WIDTH, y, blockHeight, "right", colors[i % colors.length] );
			i++;
			y += blockHeight;
		}
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

	public GameObj newScoreDisplay( double x, double y )
	{
		return ct.text( "0", x, y, SCORE_HEIGHT, "white" );
	}

	public void makeScoreDisplays()
	{
		double y = SCORE_HEIGHT / 2;
		double scoreOffset = 25;
		leftScoreDisplay = newScoreDisplay( WIDTH / 2 - scoreOffset, y );
		rightScoreDisplay = newScoreDisplay( WIDTH / 2 + scoreOffset, y );
	}

	public GameObj newPaddle( double x, double y )
	{
		return ct.rect( x, y, 2, 10, "white" );
	}

	public void makePaddles()
	{
		double paddleMargin = 10;
		double y = HEIGHT / 2;
		leftPaddle = newPaddle( paddleMargin, y );
		rightPaddle = newPaddle( WIDTH - paddleMargin, y );
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

	public GameObj newTextDisplay( String text, double x, double y )
	{
		return ct.text( text, x, y, 5, "yellow" );
	}

	public void makeTextDisplays()
	{
		// Make instructions display
		double x = WIDTH / 2;
		double y = HEIGHT / 2;
		instructions = newTextDisplay( "Press space to serve the ball", x, y );
		// Make end of game display
		y = instructions.y - instructions.getHeight() * 2;
		endGameMsg = newTextDisplay( "", x, y );
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

	public void setVelocity( GameObj obj, double speed, double degrees )
	{
		double radians = degrees * Math.PI / 180;
		ball.setXSpeed( speed * Math.cos( radians ) );
		ball.setYSpeed( speed * Math.sin( radians ) );
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
		setVelocity( ball, ballSpeed, directionAngle );

		// Set the ball at the center of the screen
		ball.x = WIDTH / 2;
		ball.y = HEIGHT / 2;
		// Set ball in play
		ballInPlay = true;
	}
}
