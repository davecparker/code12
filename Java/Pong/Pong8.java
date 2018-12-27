// Pong8.java
// If-else

class Pong8
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	final double SPEED = 1;               // Speed of the paddles
	GameObj leftScore;   // Left score display
	GameObj rightScore;  // Right score dispaly
	GameObj leftPaddle;  // Left player paddle
	GameObj rightPaddle; // Right player paddle
	GameObj ball;        // Game ball
	boolean ballInPlay;  // True when the ball is in play

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
		leftScore = ct.text( text, x, y, scoreHeight, color );
		// Make right score display
		x = WIDTH / 2 + scoreOffset;
		rightScore = ct.text( text, x, y, scoreHeight, color );
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
		// Make ball next to left paddle
		double diameter = paddleWidth;
		x = leftPaddle.x + leftPaddle.getWidth() / 2 + diameter / 2;
		ball = ct.circle( x, y, diameter, color );
		// Set ball speed and direction
		double ballSpeed = 0.7;
		int directionAngle = ct.random( -15, 15 ); 
		double xSpeed = ballSpeed * Math.cos( directionAngle * Math.PI / 180 );
		double ySpeed = ballSpeed * Math.sin( directionAngle * Math.PI / 180 );
		// Start ball moving
		ball.setXSpeed( xSpeed );
		ball.setYSpeed( ySpeed );
		ballInPlay = true;
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
			if ( ball.x > WIDTH + ball.getWidth() / 2 )
			{
				// Ball went off right edge
				// Update leftScore
				int newScore = ct.parseInt( leftScore.getText() ) + 1;
				leftScore.setText( "" + newScore );
				ballInPlay = false;
			}
			else if ( ball.x < -ball.getWidth() / 2 )
			{
				// Ball went off left edge
				// Update rightScore
				int newScore = ct.parseInt( leftScore.getText() ) + 1;
				leftScore.setText( "" + newScore );
				ballInPlay = false;
			}
		}
	}
}
