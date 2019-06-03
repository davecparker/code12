// Pong8.java
// If-else
// A playable two-player Pong-like game.
// w and s keys control the left paddle, up and down keys control the right paddle.

class Pong8
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	final double SPEED = 1;               // Speed of the paddles
	final double MAX_SCORE = 15;          // Score needed to win the game
	int leftScore;              // Left player's score
	int rightScore;             // Right player's score
	GameObj leftScoreDisplay;   // Left player's score display
	GameObj rightScoreDisplay;  // Right player's score dispaly
	GameObj leftPaddle;  // Left player paddle
	GameObj rightPaddle; // Right player paddle
	GameObj ball;        // Game ball
	boolean ballInPlay;  // True when the ball is in play
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
		// Make center dividing line
		double x1 = WIDTH / 2;
		double y1 = 0;
		double x2 = x1;
		double y2 = HEIGHT;
		String color = "white";
		ct.line( x1, y1, x2, y2, color );
		// Make left score display
		String text = "0";
		double scoreHeight = 10;
		double scoreOffset = 25;
		double x = WIDTH / 2 - scoreOffset;
		double y = scoreHeight / 2;		
		leftScoreDisplay = ct.text( text, x, y, scoreHeight, color );
		// Make right score display
		x = WIDTH / 2 + scoreOffset;
		rightScoreDisplay = ct.text( text, x, y, scoreHeight, color );
		// Make left paddle
		double paddleMargin = 10;
		x = paddleMargin;
		y = HEIGHT / 2;
		double paddleWidth = 2;
		double paddleHeight = scoreHeight;
		leftPaddle = ct.rect( x, y, paddleWidth, paddleHeight, color );
		// Make right paddle
		x = WIDTH - paddleMargin;
		rightPaddle = ct.rect( x, y, paddleWidth, paddleHeight, color );
		// Make ball
		x = 0;
		y = 0;
		double diameter = 2;
		ball = ct.circle( x, y, diameter, color );
		ball.visible = false; 
		// Make instructions display
		text = "Press space to serve the ball";
		x = WIDTH / 2; 
		y = HEIGHT / 2;
		double h = 5;
		color = "yellow";
		instructions = ct.text( text, x, y, h, color );
		// Make end of game display
		y = instructions.y - instructions.getHeight() * 2 ;
		endGameMsg = ct.text( "", x, y, h, color );
		// Initialize game state variables
		leftScore = 0;
		rightScore = 0;
		ballInPlay = false;
		firstServe = true;
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
					leftScore++;
					leftScoreDisplay.setText( "" + leftScore );

				}
				else
				{
					rightScore++;
					rightScoreDisplay.setText( "" + rightScore );
				}
				// Check for a win on either side
				if ( leftScore == MAX_SCORE || rightScore == MAX_SCORE )
				{
					firstServe = true;
					endGameMsg.visible = true;
					if ( leftScore == MAX_SCORE )
						endGameMsg.setText( "Left Player Wins!" );
					else
						endGameMsg.setText( "Right Player Wins!" );
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
			// Hide instructions
			instructions.visible = false;
			// Set ball speed and direction
			double ballSpeed = 1;
			if ( firstServe )
			{
				// Initialize game state variables
				leftScore = 0;
				rightScore = 0;
				ballInPlay = false;
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
			// Set the ball's x- and y-speeds
			ball.setXSpeed( ballSpeed * Math.cos( directionAngle * Math.PI / 180 ) );
			ball.setYSpeed( ballSpeed * Math.sin( directionAngle * Math.PI / 180 ) );
			// Set the ball at the center of the screen
			ball.x = WIDTH / 2;
			ball.y = HEIGHT / 2;
			// Set ball in play
			ballInPlay = true;
		}
	}
}
