// Syntax Level 4: Expressions
// Draws the duckhunt background with a duck and the NES light gun.
class DuckHunt4
{
	final double ASPECT_RATIO = (double) 16 / 9; // width / height
	final double GAME_HEIGHT = 100 / ASPECT_RATIO;

	public void start()
	{
		// Variable declerations
		String imageDir = "images/";
		String filename;
		double x, y, width, height;
		// Set the game height
		ct.setHeight( GAME_HEIGHT );
		// Set the background image
		filename = imageDir + "background.png";
		ct.setBackImage( filename );
		// Draw a duck
		filename = imageDir + "duck.png";
		x = 50;
		y = 15;
		width = 10;
		ct.image( filename, x, y, width );
		// Draw a duck bomb below the duck
		x = x - 5;
		y = y + 5;
		width = 0.5;
		height = 1.5;
		String color = "white";
		ct.rect( x, y, width, height, color );
		// Draw the gun
		filename = imageDir + "gun.png";
		x = 50;
		y = 50;
		width = 6;
		ct.image( filename, x, y, width );
		// Draw a bullet above the gun
		x += 2;
		y -= 10;
		double diameter = 1;
		color = "black";
		ct.circle( x, y, diameter, color );
	}
}
