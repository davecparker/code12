// Pong3.java
// Variables

class Pong3
{
	public void start()
	{
		// Set background color to black
		ct.setBackColor( "black" );
		// Make center dividing line
		double x1 = 50;
		double y1 = 0;
		double x2 = x1;
		double y2 = 100;
		String color = "white";
		ct.line( x1, y1, x2, y2, color );
		// Make left score display
		String text = "0";
		double x = 25;
		double y = 5;
		double scoreHeight = 10;
		ct.text( text, x, y, scoreHeight, color );
		// Make right score display
		x = 75;
		ct.text( text, x, y, scoreHeight, color );
		// Make left paddle
		x = 10;
		y = 50;
		double paddleWidth = 2;
		double paddleHeight = scoreHeight;
		ct.rect( x, y, paddleWidth, paddleHeight, color );
		// Make right paddle
		x = 90;
		ct.rect( x, y, paddleWidth, paddleHeight, color );
		// Make ball
		double diameter = paddleWidth;
		x = 15;
		ct.circle( x, y, diameter, color );
	}
}
