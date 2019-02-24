/*
	Pong8A

	A simplified two player Pong game with keyboard input.
	The w and s keys control the left paddle,
	the up and down arrow keys control the right paddle.

	In this simplified version, the ball is always in play,
	and there is no serving.
*/
class Pong8A
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
	final int MAX_ANGLE = 15;          // maximum serve angle in degrees

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
		ct.setTitle( "Pong 8" );
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

		// Make the ball, starting in the center of the field 
		ball = ct.circle( 50, 50, BALL_RADIUS * 2, COLOR );

		// Start the ball at a random speed and angle
		int angle = ct.random( -MAX_ANGLE, MAX_ANGLE );
		double radians = angle * Math.PI / 180; 
		ball.setXSpeed( BALL_SPEED * Math.cos( radians ) );
		ball.setYSpeed( -BALL_SPEED * Math.sin( radians ) );
	}

	public void update()
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

		// Make the ball bounce off the top and bottom walls
		if (ball.y < BALL_RADIUS || ball.y > HEIGHT - BALL_RADIUS)
			ball.setYSpeed( -ball.getYSpeed() );

		// Make the ball bounce off the paddles
		if (ball.hit( leftPaddle ) || ball.hit( rightPaddle ))
			ball.setXSpeed( -ball.getXSpeed() );

		// The left player scores if the ball reaches the right edge
		if (ball.x > WIDTH)
		{
			leftScore++;
			leftScoreText.setText( ct.formatInt( leftScore ) );
			ball.setXSpeed( -ball.getXSpeed() );   // bounce back for now
		}

		// The right player scores if the ball reaches the left edge
		if (ball.x < 0)
		{
			rightScore++;
			rightScoreText.setText( ct.formatInt( rightScore ) );
			ball.setXSpeed( -ball.getXSpeed() );   // bounce back for now
		}
	}
}
