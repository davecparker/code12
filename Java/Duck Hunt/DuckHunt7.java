// Syntax Level 7: Object Method Calls
// Draws the duckhunt background with a duck and the NES light gun.
// Animates the duck moving accross the screen, the bomb falling, and the bullet moving up.
class DuckHunt7
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
		double diameter = 1;
		x = gun.x + gun.getWidth() * 0.35;
		y = gun.y - gun.getHeight() / 2 - diameter / 2;
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
		x = duck.x - duck.getWidth() / 2;
		double height = 1.5;
		y = duck.y + duck.getHeight() / 2;
		width = 0.5;
		color = "white";
		bomb = ct.rect( x, y, width, height, color );
		double speed = 0.5;
		// Start the duck moving to the right
		duck.setXSpeed( speed );
		// Start the bomb moving down
		bomb.setYSpeed( speed );
		// Start the bullet moving up
		bullet.setYSpeed( -speed );
	}

	public void update()
	{
	}
}
