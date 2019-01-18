// Syntax Level 5: Function Return Values
// Draws the duckhunt background and the NES light gun.
// Draws a new duck dropping a bomb at a randome position each new frame.
class DuckHunt5
{
	final double ASPECT_RATIO = (double) 16 / 9; // width / height
	final double GAME_HEIGHT = 100 / ASPECT_RATIO;
	String imageDir = "images/";
	GameObj gun, bullet, duck, bomb;

	public void start()
	{
		// Set the game height
		ct.setHeight( GAME_HEIGHT );
		// Set the background image
		String filename = imageDir + "background.png";
		ct.setBackImage( filename );
		// Draw the gun
		filename = imageDir + "gun.png";
		double x = 50;
		double y = 50;
		double width = 6;
		gun = ct.image( filename, x, y, width );
		// Draw a bullet above the gun
		x += 2;
		y -= 10;
		double diameter = 1;
		String color = "black";
		bullet = ct.circle( x, y, diameter, color );
	}

	public void update()
	{
		// Draw a duck
		String filename = imageDir + "duck.png";
		double x = ct.random( 0, 100 );
		double y = ct.random( 0, ct.round(GAME_HEIGHT) );
		double width = 10;
		duck = ct.image( filename, x, y, width );
		// Draw a duck bomb below the duck
		x = x - 5;
		y = y + 5;
		width = 0.5;
		double height = 1.5;
		String color = "white";
		bomb = ct.rect( x, y, width, height, color );
	}
}
