// Syntax Level 3: Variables
// Draws the duckhunt background with a duck and the NES light gun.
class DuckHunt3
{
	public void start()
	{
		// Variable declerations
		String filename;
		double x, y, width, height;
		// Set the game height
		height = 56.25; // For a 16 x 9 aspect ratio
		ct.setHeight( height );
		// Set the background image
		filename = "images/background.png";
		ct.setBackImage( filename );
		// Draw a duck
		filename = "images/duck.png";
		x = 50;
		y = 15;
		width = 10;
		ct.image( filename, x, y, width );
		// Draw a duck bomb below the duck
		x = 45;
		y = 20;
		width = 0.5;
		height = 1.5;
		String color = "white";
		ct.rect( x, y, width, height, color );
		// Draw the gun
		filename = "images/gun.png";
		x = 50;
		y = 50;
		width = 6;
		ct.image( filename, x, y, width );
		// Draw a bullet above the gun
		x = 52;
		y = 40;
		double diameter = 1;
		color = "black";
		ct.circle( x, y, diameter, color );
	}
}
