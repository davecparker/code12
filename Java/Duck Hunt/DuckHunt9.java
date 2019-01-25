// Syntax Level 9: Function Definitions
// Draws the duckhunt background with the NES light gun.
// A duck is randomly generated off the left of the screen and flies from left to right. 
// The duck drops bombs. If a bomb hits the gun the game is over. 
// The gun can fire bullets which can hit the duck.
// ---------
// Controls:
// Press Enter to restart after game over text appears.
// Left/right arrows move the gun.
// Space bar fires the gun.

class DuckHunt9
{
	final double ASPECT_RATIO = (double) 16 / 9;
	final double GAME_HEIGHT = 100 / ASPECT_RATIO;
	final double GUN_SPEED = 1;
	final double BULLET_SPEED = 2;
	final double BOMB_SPEED = 0.5;
	final String DUCK_HIT_SOUND = "quack.wav";
	final String GUN_FIRED_SOUND = "shotgun.wav";
	final String IMAGE_DIR = "images/";
	boolean gameOver = false;
	boolean duckIsAlive = true;
	int ducksHitCount = 0;
	GameObj ducksHitDisplay, gameOverDisplay, gun, duck;

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
		// Make the duck of to the left of the scene
		duck = ct.image( IMAGE_DIR + "duck.png", -20, 25, 10 );
		duck.group = "ducks";
		// Start the duck moving to the right
		duck.setXSpeed( ct.random( 1, 3 ) / 3.0 );
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

			// Check for duck going off screen 
			if ( duck.x > 100 + duck.getWidth() || duck.y > GAME_HEIGHT + duck.getWidth() )
				resetDuck();
			// Check for duck getting hit by a bullet
			if ( duckIsAlive )
			{
				GameObj bullet = duck.objectHitInGroup( "bullets" );
				if ( bullet != null )
				{
					// duck got hit by bullet
					killDuck();
					bullet.delete();
					// Record the hit
					ducksHitCount++;
					updateDucksHitDisplay();
				}
				else if ( ct.random( 1, 50 ) == 1 )
				{
					duckDropBomb();
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
		resetDuck();
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

	// Reset the duck for a new run
	void resetDuck()
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
		duckIsAlive = true;
	}

	// Make the duck a dead duck that falls down screen
	void killDuck()
	{
		duck.setImage( IMAGE_DIR + "falling_duck.png" );
		duck.setYSpeed( 1 );
		duck.setXSpeed( 0.1 );
		ct.sound( DUCK_HIT_SOUND );
		duckIsAlive = false;
	} 

	// Make the duck drop a bomb
	void duckDropBomb()
	{
		GameObj bomb = newBomb();
		bomb.setYSpeed( BOMB_SPEED );
	}

	// Make and return an new bomb
	GameObj newBomb()
	{
		double x = duck.x - duck.getWidth() / 2;
		double height = 1.5;
		double y = duck.y + duck.getHeight() / 2;
		double width = 0.5;
		String color = "white";
		GameObj b = ct.rect( x, y, width, height, color );
		b.group = "bombs";
		return b;
	}

	// End the game
	void endGame()
	{
		gameOver = true;
		gameOverDisplay.visible = true;
		duck.setXSpeed( 0 );
		duck.setYSpeed( 0 );
		gun.setXSpeed( 0 );
	}
}
