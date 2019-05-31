/*
	A simplified "Breakout" game where there is only one row of bricks.
*/
class BreakRow
{
	final double PADDLE_SIZE = 10;
	final double BALL_RADIUS = 1.5;

	GameObj paddle, ball;
	int numBricks = 0;

	public void start()
	{
		// Make the paddle and ball
		paddle = ct.rect( 50, 95, PADDLE_SIZE, 3, "blue" );
		ball = ct.circle( paddle.x, 90, BALL_RADIUS * 2, "red" );

		// Ask for the brick size
		double brickSize = ct.inputNumber( "Enter the brick size" );

		// Make the bricks
		double xLeft = 0;      // left edge of first brick
		while (xLeft < 100)    // as long as still partially on screen...
		{
			// Make a brick at this position
			GameObj brick = ct.rect( xLeft + brickSize / 2, 10, brickSize, 5, "orange" );
			brick.setLineWidth( 2 );
			brick.group = "bricks";
			xLeft += brickSize;          // center x for next brick
			numBricks++;
		}

		// Set the ball in motion at a random angle
		ball.setXSpeed( ct.random( 2, 8 ) / 10.0 );    // 0.2 to 0.8
		ball.setYSpeed( -1 );
	}

	public void update()
	{
		// Arrow keys move the paddle
		if (ct.keyPressed( "left" ))
			paddle.x--;
		if (ct.keyPressed( "right" ))
			paddle.x++;

		// Bounce ball off walls and paddle
		if (ball.x < BALL_RADIUS || ball.x > 100 - BALL_RADIUS)
			bounce( ball, false );
		if (ball.y < BALL_RADIUS || ball.hit( paddle ))
			bounce( ball, true );

		// Game Over if ball hits bottom wall
		if (ball.y >= ct.getHeight())
		{
			ct.showAlert( "Game Over!\n\nPress Enter to restart." );
			ct.restart();
		}

		// Ball hitting a brick bounces off and deletes the brick
		GameObj brick = ball.objectHitInGroup( "bricks" );
		if (brick != null)
		{
			bounce( ball, true);
			brick.delete();
			numBricks--;
			if (numBricks == 0)
			{
				ct.showAlert( "You win!\n\nPress Enter to play again." );
				ct.restart();
			}
		}
	}

	// If vertical then make obj bounce its y speed, otherwise its x speed
	void bounce( GameObj obj, boolean vertical )
	{
		// Undo the motion that obj travelled during the last frame
		obj.x -= obj.getXSpeed();
		obj.y -= obj.getYSpeed();

		// Bounce in the direction specified
		if (vertical)
			obj.setYSpeed( -obj.getYSpeed() );
		else
			obj.setXSpeed( -obj.getXSpeed() );
	}

}
