// Syntax Level 8: If-else
// Draws the duckhunt background with the NES light gun.
// A duck is randomly generated off the left of the screen and flies from left to right. 
// Left/right arrows move the gun and space bar fires bullets up from the gun.
// Bullets can hit the ducks.

class DuckHunt8
{
	final double ASPECT_RATIO = (double) 16 / 9; // width / height
	final double GAME_HEIGHT = 100 / ASPECT_RATIO;
	final double GUN_SPEED = 1;
	final double BULLET_SPEED = 2;
	final double BOMB_SPEED = 0.5;
	final String DUCK_HIT_SOUND = "quack.wav";
	final String GUN_FIRED_SOUND = "shotgun.wav";

	String imageDir = "images/";
	GameObj gun;
	GameObj bullet = null;
	GameObj ducksHitDisplay;
	int ducksHitCount = 0;

	public void start()
	{
		double x, y, width, height;
		String filename;
		// Set the game height
		ct.setHeight( GAME_HEIGHT );
		// Set the background image
		filename = imageDir + "background.png";
		ct.setBackImage( filename );
		// Make ducks hit display
		height = 4;
		x = 0;
		y = GAME_HEIGHT;
		ducksHitDisplay = ct.text( "Ducks Hit: 0", x, y, height, "yellow" );
		ducksHitDisplay.align( "bottom left" );
		// Draw the gun
		filename = imageDir + "gun.png";
		x = 50;
		y = ducksHitDisplay.y - ducksHitDisplay.getHeight();
		width = 6;
		gun = ct.image( filename, x, y, width );
		gun.align( "bottom" );
		// Load sounds
		ct.loadSound( DUCK_HIT_SOUND );
		ct.loadSound( GUN_FIRED_SOUND );
	}

	public void update()
	{
		if ( ct.random( 1, 80 ) == 1 )
		{
			// Make a new duck at a random height
			String filename = imageDir + "duck.png";
			double duckWidth = 10;
			double x = -duckWidth;
			int yMinDuck = (int) ( duckWidth );
			int yMaxDuck = (int) ( gun.y - gun.getHeight() - duckWidth );
			double y = ct.random( yMinDuck, yMaxDuck );
			GameObj duck = ct.image( filename, x, y, duckWidth );
			duck.group = "ducks";
			// Start the duck moving to the right with a random speed
			duck.setXSpeed( ct.random( 1, 3 ) / 3.0 );
		}

		// Left/right arrow keys control the gun
		if ( ct.keyPressed( "left" ) )
			gun.setXSpeed( -GUN_SPEED );
		else if ( ct.keyPressed( "right" ) )
			gun.setXSpeed( GUN_SPEED );
		else
			gun.setXSpeed( 0 );

		// Make sure gun doesn't go off edge of screen
		double gunHalfWidth = gun.getWidth() / 2;
		double xMinGun = gunHalfWidth;
		boolean gunOffLeftEdge = gun.x < xMinGun;
		if ( gunOffLeftEdge )
		{
			gun.x = xMinGun;
			gun.setXSpeed( 0 );
		}
		else
		{
			double xMaxGun = 100 - gunHalfWidth;
			boolean gunOffRightEdge = gun.x > xMaxGun;
			if ( gunOffRightEdge )
			{
				gun.x = xMaxGun;
				gun.setXSpeed( 0 );
			}
		}

		// File bullet or check for it hitting any ducks
		if ( bullet == null )
		{
			// Space bar fires a bullet from the gun
			if ( ct.keyPressed( "space" ) )
			{
				// Draw a bullet above the gun
				double diameter = 1;
				double x = gun.x + gun.getWidth() * 0.35;
				double y = gun.y - gun.getHeight() - diameter / 2;
				String color = "black";
				bullet = ct.circle( x, y, diameter, color );
				// Start the bullet moving up
				bullet.setYSpeed( -BULLET_SPEED );
				// Play gun fired sound
				ct.sound( GUN_FIRED_SOUND );
			}
		}
		else
		{
			// Check bullet hitting a duck
			GameObj duckHit = bullet.objectHitInGroup( "ducks" );
			if ( duckHit != null )
			{
				// Change the duck's image to a dead duck and make it fall
				duckHit.setImage( imageDir + "falling_duck.png" );
				duckHit.setYSpeed( BOMB_SPEED );
				duckHit.group = "dead ducks";
				// Delete the bullet
				bullet.delete();
				bullet = null;
				// Play duck hit sound
				ct.sound( DUCK_HIT_SOUND );
				// Record the hit
				ducksHitCount++;
				ducksHitDisplay.setText( "Ducks Hit: " + ducksHitCount );
			}
			else if ( bullet.y < -10 )
			{
				// Bullet when off top of screen, delete it
				bullet.delete();
				bullet = null;
			}
		}
	}
}
