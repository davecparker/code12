// Duck Hunt
// A simple game of shooting rubber ducks.
// Click the mouse anywhere in the app window to make the gun move horizontally to the click
// location and fire straight upwards towards the ducks.

import Code12.*;

public class DuckHuntLineHits extends Code12Program
{
	GameObj gun; // Gun at bottom of window that fires bullets
	GameObj ducksHitDisplay; // Text display for percent of ducks hit
	GameObj accuracyDisplay; // Text display for percent of shots on target
	GameObj frameRateDisplay;// Text display for animation frame rate
	double yMax; // Maximum y-coordinate of the game window
	int maxSizeBullets; // Maximum bullets array size
	int maxSizeDucks; // Maximum ducks array size
	GameObj[] bulletsArr; // Array for accessing bullets on screen
	GameObj[] ducksArr; // Array for accessing ducks on screen
	double[] duckYStartsArr; // Array for tracking center of ducks vertical movement
	int bulletsCount; // Count of how many bullets are on the screen
	int bulletsMissed; // Count of how many bullets have gone off screen without hitting a duck
	int ducksCount; // Count of how many ducks are currently on screen
	int ducksHit; // Count of how many ducks have been hit by a bullet
	int ducksMissed; // Count of how many ducks have gone off screen without being hit by a bullet
	double amplitude; // Amplitude of the ducks up and down motion
	double period; // Period of the ducs up and down motion
	GameObj leftWall, topWall; // Lines to test line hits
	boolean paused; // For starting/stopping new duck creation
	boolean turboMode; // For a crazy number of ducks;
	int frameCount;
	int startTime;

	public void start()
	{
		// Set title
		ct.setTitle( "Duck Hunt" );

		// Set background
		ct.setHeight( ct.intDiv( 100 * 9, 16 ) );
		yMax = ct.getHeight();
		ct.setBackImage( "stage.png" );

		// Initialize count variables
		bulletsCount = 0;
		bulletsMissed = 0;
		ducksCount = 0;
		ducksHit = 0;
		ducksMissed = 0;

		// Make ducksHitDisplay
		double scoreHeight = 5;
		String scoreColor = "dark magenta";
		ducksHitDisplay = ct.text( "Ducks hit: ", 0, yMax, scoreHeight, scoreColor );
		ducksHitDisplay.align( "bottom left" );

		// Make accuracyDisplay
		accuracyDisplay = ct.text( "Shot Accuracy: ", 100, yMax, scoreHeight, scoreColor );
		accuracyDisplay.align( "bottom right" );

		// Make frameRateDisplay
		frameRateDisplay = ct.text( "FrameRate: ", 0, 0, scoreHeight, scoreColor );
		frameRateDisplay.align( "top left" );

		// Make gun
		gun = ct.image( "gun.png", 50, yMax - scoreHeight, 8 );
		gun.align( "bottom" );

		// Initialize arrays
		maxSizeDucks = 20;
		maxSizeBullets = 5;
		bulletsArr = new GameObj[maxSizeBullets];
		ducksArr = new GameObj[maxSizeDucks];
		duckYStartsArr = new double[maxSizeDucks];

		// Initialize amplitude and period for ducks' path
		amplitude = 5;
		period = 100;

		// Make walls
		leftWall = ct.line(0, 0, 0, ct.getHeight(), "red");
		topWall = ct.line(0, 0, 100, 0, "red");

		// Start the game unpaused and with turbo mode off
		paused = false;
		turboMode = false;

		// Initialize the frame count and timer for frameRateDisplay
		frameCount = 1;
		startTime = ct.getTimer();

	}

	public void update()
	{
		// Move screenOrigin
		double screenOriginX = frameCount / 10.0;
		ct.setScreenOrigin( screenOriginX, 0 );
		// Move displays and walls
		frameRateDisplay.x = screenOriginX;
		ducksHitDisplay.x = screenOriginX;
		accuracyDisplay.x = screenOriginX + 100;
		topWall.x = screenOriginX;
		leftWall.x = screenOriginX;
		// Update frameCount
		frameCount++;

		// Update frameRateDisplay
		int numFrames = 20;
		if ( frameCount % numFrames == 0 )
		{
			int endTime = ct.getTimer();
			int frameRate = ct.round( numFrames * 1000.0 / (endTime - startTime) );
			frameRateDisplay.setText( "FrameRate: " + frameRate);
			startTime = endTime;
		}

		// Make ducks at random times and positions
		int randMax = 50;
		if ( turboMode )
			randMax = 10;
		if (!paused && ct.random(1, randMax) == 1)
		{
			double duckSpeed = -0.5;
			if (turboMode)
			{
				duckSpeed = -0.75;
			}
			double x = 105 + screenOriginX;
			double y = ct.random( 10, (int) (yMax / 2) );
			GameObj duck = createDuck( x, y, duckSpeed);
		}

		// If a duck goes off screen, delete it
		// Else make it move up/down on sinusoidal path
		for ( int j = ducksCount - 1; j >= 0; j-- )
		{
			GameObj duck = ducksArr[j];
			double duckYStart = duckYStartsArr[j];
			if ( duck.hit(leftWall) )
			{
				deleteDuck(j);
				ducksMissed++;
				ct.println("duck #" + ducksMissed + " hit left wall");
			}
			else
				//duck.ySpeed = ct.random( -1, 1 ) / 4.0;
				duck.y = duckYStartsArr[j] + amplitude * Math.sin( 2 * Math.PI / period * duck.x );
		}

		// Check for duck-bullet hits and going off screen
		for ( int i = bulletsCount - 1; i >= 0; i-- )
		{
			GameObj bullet = bulletsArr[i];
			// Delete bullet if it has gone off screen
			if ( topWall.hit(bullet) )
			{
				deleteBullet(i);
				bulletsMissed++;
				ct.println("bullet #" + bulletsMissed + " hit top wall");

				// Don't check this bullet hitting ducks
				break;
			}
			// Check for bullet hitting any ducks
			for ( int j = ducksCount - 1; j >= 0; j-- )
			{
				GameObj duck = ducksArr[j];
				if ( duck.hit(bullet) )
				{
					ct.sound("quack.wav");
					makeDeadDuck( duck );

					// Delete bullet and duck
					deleteBullet(i);
					deleteDuck(j);
					ducksHit++;
					// Don't let this bullet affect any more ducks
					break;
				}
			}
		}

		// Update ducksHitDisplay
		if ( ducksHit + ducksMissed > 0 )
		{
			int percent = ct.round( 100.0 * ducksHit / (ducksHit + ducksMissed) );
			ducksHitDisplay.setText( "Ducks hit: " + percent + "%" );
		}

		// Update accuracyDisplay
		if ( ducksHit + bulletsMissed > 0 )
		{
			int percent = ct.round( 100.0 * ducksHit / (ducksHit + bulletsMissed) );
			accuracyDisplay.setText( "Shot Accuracy: " + percent + "%" );
		}
	}

	// Makes a bullet at position xStart, yStart that will then
	// move up the window and delete itself once outside the window
	GameObj fireBullet( double xStart, double yStart )
	{
		GameObj bullet = null;
		if ( bulletsCount < maxSizeBullets )
		{
			//GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
			bullet = ct.line( xStart, yStart, xStart, yStart + 2, "blue" );
			bullet.setLineWidth( 5 );
			bullet.setYSpeed( -3 );
			bulletsArr[bulletsCount] = bullet;
			bulletsCount++;
		}
		else
			ct.println( "Too many bullets on screen." );
		return bullet;
	}

	// Deletes a bullet
	void deleteBullet( int index )
	{
		bulletsArr[index].delete();
		for( int i = index; i < bulletsCount - 1; i++ )
			bulletsArr[i] = bulletsArr[i + 1];
		bulletsCount--;
		bulletsArr[bulletsCount] = null;
	}

	// Makes a duck to the right of the window at y-coordinate yStart
	// that will then accross the window horizontally with speed xSpeed
	GameObj createDuck( double xStart, double yStart, double xSpeed )
	{
		GameObj duck = null;
		if ( ducksCount < maxSizeDucks )
		{
			duck = ct.image( "rubber-duck.png", xStart, yStart, 5 );
			duck.setXSpeed( xSpeed );
			ducksArr[ducksCount] = duck;
			duckYStartsArr[ducksCount] = yStart;
			ducksCount++;
		}
		else
			ct.println( "Too many ducks on screen." );
		return duck;
	}

	// Deletes a duck
	void deleteDuck( int index )
	{
		ducksArr[index].delete();
		for( int i = index; i <  ducksCount - 1; i++ )
		{
			ducksArr[i] = ducksArr[i + 1];
			duckYStartsArr[i] = duckYStartsArr[i + 1];
		}
		ducksCount--;
		ducksArr[ducksCount] = null;
	}

	// Makes a dead duck at duck's position
	GameObj makeDeadDuck( GameObj duck )
	{
		GameObj deadDuck = ct.image( "dead-duck.png", duck.x, duck.y, duck.getHeight() );
		deadDuck.setYSpeed( 1 );
		return deadDuck;
	}

	// Moves the gun horizontally and fires a bullet when the mouse
	// is clicked
	public void onMousePress( GameObj obj, double x, double y )
	{
		// ct.log("mouse press", obj, x, y);
		// Play squirt sound
		ct.sound( "squirt.wav" );

		// Move the gun horizontally to match the click location
		gun.x = x;

		// Fire a new bullet
		double xStart = gun.x;
		double yStart = gun.y - gun.getHeight() * 0.9;
		fireBullet( xStart, yStart );
	}

	public void onKeyPress( String keyName )
	{
		if ( keyName.equals("space") )
		{
			paused = !paused;
			if (paused)
				ct.println( "paused" );
			else
				ct.println( "unpaused" );
		}
		if ( keyName.equals("t") )
		{
			turboMode = !turboMode;
			if (turboMode)
				ct.println( "turboMode on" );
			else
				ct.println( "turboMode off" );
		}
	}

	public static void main( String[] args )
	{
		Code12.run( new DuckHuntLineHits() );
	}
}