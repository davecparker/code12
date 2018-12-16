class FlyGame
{
	GameObj bird, fly, drone, scoreText;
	final double FLY_SPEED = 1.0;
	final double droneSpeed = 0.5;
	int score = 0;
	double birdSpeed = 0;

	public void start()
	{
		// Make the sky and grass
		ct.setBackColor( "light blue" );
		ct.rect( 50, 95, 100, 10, "dark green" );

		// Make the flying objects
		bird = ct.image( "bird.png", 20, 30, 20 );
		fly = ct.image( "fly.png", 80, 20, 5 );
		drone = ct.image( "drone.png", 200, 50, 30 );

		// Make the score display
		scoreText = ct.text( "0", 90, 10, 10, "brown" );

		// Pre-load the sounds that are needed right away
		ct.loadSound( "flap.wav" );
		ct.loadSound( "crunch.wav" );
	}

	public void update()
	{
		// When the user clicks the bird flys up, otherwise it glides down
		if (ct.clicked())
		{
			birdSpeed -= 0.6;
			ct.sound( "flap.wav" );
		}
		else
		{
			birdSpeed += 0.03;
		}
		bird.y += birdSpeed;

		// If the bird sinks to the ground then it stops there
		if (bird.y > 83)
		{
			bird.y = 83;
			birdSpeed = 0;
		}

		// Move the fly to the left, then if it goes off-screen to the
		// left then restart it on the right at a random altitude.
		fly.x -= FLY_SPEED;
		if (fly.x < -10)
		{
			fly.x = ct.random( 110, 150 );
			fly.y = ct.random( 10, 80 );
		}

		// Move the drone to the left, then if it goes off-screen to the
		// left then restart it on the right at a random altitude.
		drone.x -= droneSpeed;
		if (drone.x < -20)
		{
			drone.x = ct.random( 200, 300 );
			drone.y = ct.random( 10, 80 );
		}

		// Check if the bird hit the fly
		if (bird.hit( fly ))
		{
			// Count a hit
			score++;
			ct.sound( "crunch.wav" );
			scoreText.setText( ct.formatInt( score ) );

			// The drone speeds up when the score gets greater than 10
			if (score > 10)
				droneSpeed = 1.5;

			// Restart the fly
			fly.x = ct.random( 110, 150 );
			fly.y = ct.random( 10, 80 );
		}

		// Check if the bird hit the drone
		if (bird.hit( drone ))
		{
			// Delete the bird
			bird.delete();
			ct.sound( "buzz.wav" );

			// Game Over
			ct.text( "Game Over", 50, 15, 12 );
			if (ct.inputYesNo( "Would you like to play again?" ) )
				ct.restart();
			else
				ct.stop();
		}
	}
}
