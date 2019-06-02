// Pong7.java
// Object Method Calls
// Draws the start of a game of pong.
// Animates the ball (using obj.set[XY]Speed) and right paddle.

class Pong7
{
	final double WIDTH = 100;             // Graphics output window width
	final double HEIGHT = WIDTH / 1.5;    // Graphics output window height
	GameObj leftScore;   // Left score display
	GameObj rightScore;  // Right score dispaly
	GameObj leftPaddle;  // Left player paddle
	GameObj rightPaddle; // Right player paddle
	GameObj ball;        // Game ball

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
	}

	public void update()
	{
		// Move right paddle to follow the ball
		rightPaddle.y = ball.y;
	}
}
