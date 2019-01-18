// Syntax Level 6: Object Data Fields
// Draws the duckhunt background with a duck and the NES light gun.
// Animates the duck moving accross the screen, the bomb falling, and the bullet moving up.
class DuckHunt6
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
		// Draw a duck
		filename = imageDir + "duck.png";
		x = 10;
		width = 10;
		int yMinDuck = (int) width;
		int yMaxDuck = (int) ( GAME_HEIGHT - width );
		y = ct.random( yMinDuck, yMaxDuck );
		duck = ct.image( filename, x, y, width );
		// Draw a duck bomb below the duck
		x = x - 5;
		y = y + 5;
		width = 0.5;
		double height = 1.5;
		color = "white";
		bomb = ct.rect( x, y, width, height, color );
	}

	public void update()
	{
		double speed = 0.5;
		// Move the duck to the right, wrapping around at edge of screen
		duck.x = ( duck.x + speed ) % 100;
		// Move the bomb down
		bomb.y += speed;
		// Move the bullet up
		bullet.y -= speed;
	}
}
