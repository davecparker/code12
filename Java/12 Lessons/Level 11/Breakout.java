/*
	A sample "Breakout" game using loops.
*/
class Breakout
{
	final double PADDLE_SIZE = 10;
	final double BALL_RADIUS = 1.5;
	final int NUM_ROWS = 5;
	final int BRICKS_PER_ROW = 15;
	final double BRICK_HEIGHT = 3;
	final double BRICK_WIDTH = 100.0 / BRICKS_PER_ROW;

	GameObj paddle, ball;
	int numBricks = 0;

	public void start()
	{
		// Make the paddle and ball
		paddle = ct.rect( 50, 95, PADDLE_SIZE, 3, "blue" );
		ball = ct.circle( paddle.x, 90, BALL_RADIUS * 2, "red" );

		// Make the rows of bricks
		for (int row = 0; row < NUM_ROWS; row++)
		{
			double y = 10 + row * BRICK_HEIGHT;         // y coord for this row
			int greenShade = ct.round( row * 255.0 / (NUM_ROWS - 1) );   // color of this row
			makeRow( y, greenShade );
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

		// Bounce ball off walls
		if (ball.x < BALL_RADIUS || ball.x > 100 - BALL_RADIUS)
			bounce( ball, false );
		if (ball.y < BALL_RADIUS)
			bounce( ball, true );

		// Bouncing off paddle: Contact point affects bounce direction 
		if (ball.hit( paddle ))
		{
			bounce( ball, true );
			double dx = paddle.x - ball.x;
			ball.setXSpeed( ball.getXSpeed() - dx / 10 );
		}

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

	// Make a row of bricks at the y coordinate using greenShade for the 
	// green component of the RGB color of the bricks.
	void makeRow( double y, int greenShade )
	{
		for (int i = 0; i < BRICKS_PER_ROW; i++)
		{
			// Make a brick at the right grid location
			double x = (i + 0.5) * BRICK_WIDTH;
			GameObj brick = ct.rect( x, y, BRICK_WIDTH, BRICK_HEIGHT);
			brick.setFillColorRGB( 255, greenShade, 0 );
			brick.setLineWidth( 2 );
			brick.group = "bricks";
			numBricks++;
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
