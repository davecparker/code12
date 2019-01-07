// Syntax Level 12: Arrays
// Draws the duckhunt background with the NES light gun.
// Multiple ducks are randomly generated off the left of the screen. 
// The ducks drop bombs. If a bomb hits the gun the game is over. 
// The gun can fire bullets which can hit the ducks.
// ---------
// Controls:
// Press Enter to restart after game over text appears.
// Left/right arrows move the gun.
// Space bar fires the gun.

class DuckHunt10
{
	final double ASPECT_RATIO = (double) 16 / 9;
	final double GAME_HEIGHT = 100 / ASPECT_RATIO;
	final double GUN_SPEED = 1;
	final double BULLET_SPEED = 2;
	final double BOMB_SPEED = 0.5;
	final String DUCK_HIT_SOUND = "quack.wav";
	final String GUN_FIRED_SOUND = "shotgun.wav";
	final String IMAGE_DIR = "images/";
	final int NUM_DUCKS = 10;
	boolean gameOver = false;
	int ducksHitCount = 0;
	GameObj ducksHitDisplay, gameOverDisplay, gun;
	GameObj[] ducks = new GameObj[NUM_DUCKS];

	public void start()
	{
		// Set the game height
		ct.setHeight( GAME_HEIGHT );
		// Set the background image
		ct.setBackImage( IMAGE_DIR + "background.png" );
		// Make ducks hit display
		ducksHitDisplay = ct.text( "", 0, GAME_HEIGHT, 4, "yellow" );
		ducksHitDisplay.align( "bottom left" );
		updateDucksHitDisplay();
		// Make the gun
		gun = ct.image( IMAGE_DIR + "gun.png", 50, ducksHitDisplay.y - ducksHitDisplay.getHeight(), 6 );
		gun.align( "bottom" );
		// Make the ducks
		// for ( GameObj duck : ducks )
		for ( int i = 0; i < NUM_DUCKS; i++ )
			ducks[i] = newDuck();
		// Load sounds
		ct.loadSound( DUCK_HIT_SOUND );
		ct.loadSound( GUN_FIRED_SOUND );
		// Make game over display
		gameOverDisplay = ct.text( "GAME OVER", 50, GAME_HEIGHT / 2, 10, "red" );
		gameOverDisplay.visible = false;
	}

	public void update()
	{
		if ( gameOver )
		{
			if ( ct.keyPressed( "enter" ) )
				resetGame();
		}
		else
		{
			// Left/right arrow keys control the gun
			if ( ct.keyPressed( "left" ) )
				gun.setXSpeed( -GUN_SPEED );
			else if ( ct.keyPressed( "right" ) )
				gun.setXSpeed( GUN_SPEED );
			else
				gun.setXSpeed( 0 );

			// Space bar fires the gun
			if ( ct.charTyped( " " ) )
				fireGun();

			// Check for ducks going off screen
			for ( GameObj duck : ducks )
				if ( duck.x > 100 + duck.getWidth() || duck.y > GAME_HEIGHT + duck.getWidth() )
					resetDuck( duck );

			// Check for ducks getting hit by a bullet
			for ( GameObj duck : ducks )
			{
				if ( duck.group.equals( "alive" ) )
				{
					GameObj bullet = duck.objectHitInGroup( "bullets" );
					if ( bullet != null )
					{
						// duck got hit by bullet
						killDuck( duck );
						bullet.delete();
						// Record the hit
						ducksHitCount++;
						updateDucksHitDisplay();
					}
					else if ( ct.random( 1, 100 ) == 1 )
					{
						duckDropBomb( duck );
					}
				}
			}

			// Check for gun getting hit by a bomb
			GameObj bomb = gun.objectHitInGroup( "bombs" );
			if ( bomb != null )
			{
				bomb.delete();
				endGame();
			}
		}
	}

	void resetGame()
	{
		gameOver = false;
		gameOverDisplay.visible = false;
		ducksHitCount = 0;
		updateDucksHitDisplay();
		for ( GameObj duck : ducks )
			resetDuck( duck );
	}

	void updateDucksHitDisplay()
	{
		ducksHitDisplay.setText( "Ducks Hit: " + ducksHitCount );
	}

	// Fire a bullet from the gun
	void fireGun()
	{
		GameObj bullet = newBullet();
		bullet.setYSpeed( -BULLET_SPEED );
		ct.sound( GUN_FIRED_SOUND );
	}

	// Make and return a new duck
	GameObj newDuck()
	{
		GameObj duck = ct.image( IMAGE_DIR + "duck.png", 0, 0, 10 );
		duck.group = "ducks";
		resetDuck( duck );
		return duck;
	}

	// Make and return a new bullet at the end of the barrel of the gun
	GameObj newBullet()
	{
		double diameter = 1;
		double x = gun.x + gun.getWidth() * 0.35;
		double y = gun.y - gun.getHeight() - diameter / 2;
		String color = "black";
		GameObj b = ct.circle( x, y, diameter, color );
		b.group = "bullets";
		return b;
	}

	// Reset the given duck for a new run
	void resetDuck( GameObj duck )
	{
		// Reset the duck's image
		duck.setImage( IMAGE_DIR + "duck.png" );
		// Put the duck at a random spot to the left of the screen
		duck.x = -ct.random( 20, 50 );
		double duckHeight = duck.getHeight();
		duck.y = ct.random( (int) duckHeight, (int)(gun.y - gun.getHeight() - duckHeight) );
		// Set the duck moving to the right
		duck.setXSpeed( ct.random(5, 10) / 10.0 );
		duck.setYSpeed( 0 );
		// Bring the duck back to life
		duck.group = "alive";
	}

	// Make the given duck a dead duck that falls down screen
	void killDuck( GameObj duck )
	{
		duck.setImage( IMAGE_DIR + "falling_duck.png" );
		duck.setYSpeed( 1 );
		duck.setXSpeed( 0.1 );
		ct.sound( DUCK_HIT_SOUND );
		duck.group = "dead";
	} 

	// Make the given duck drop a bomb
	void duckDropBomb( GameObj duck )
	{
		double x = duck.x - duck.getWidth() / 2;
		double height = 1.5;
		double y = duck.y + duck.getHeight() / 2;
		double width = 0.5;
		String color = "white";
		GameObj b = ct.rect( x, y, width, height, color );
		b.group = "bombs";
		b.setYSpeed( BOMB_SPEED );
	}

	// End the game
	void endGame()
	{
		gameOver = true;
		gameOverDisplay.visible = true;
		for ( GameObj duck : ducks )
		{
			duck.setXSpeed( 0 );
			duck.setYSpeed( 0 );
		}
		gun.setXSpeed( 0 );
	}
}
