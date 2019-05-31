/*
	A game somewhat inspired by the mobile app "Flappy Bird".
	You try to make the bird eat the flys, but it must avoid the drone.
	The game behaviors are as follows:

		1. Pressing and holding space bar makes bird fly up
		2. If not pressing space, bird falls down
		3. Bird can't go lower than the ground
		4. The fly moves continuously to the left
		5. If fly goes off screen to the left, reset it for another pass
		6. Drone moves continuously to the left
		7. If drone goes off screen to the left, reset it for another pass
		8. If bird hits the fly, add a point and reset the fly for another pass
		9. If bird hits the drone, display Game Over alert then restart
		10. Fly makes each pass at a different altitude
		11. Drone makes each pass at a different altitude
		12. Subtract a point for each fly missed

	Possible additions:
		13. At 10 points, the drone speeds up to make it harder
		(What else?)
*/
class FlyGame
{
	// Constants 
	final double BIRD_SPEED = 1.0;
	final double FLY_SPEED = 1.0;
	final double DRONE_SPEED = 0.8;

	GameObj bird, fly, drone, scoreText;
	int score = 0;

	public void start()
	{
		// Make the sky and grass
		ct.setBackColor( "light blue" );
		ct.rect( 50, 95, 100, 10, "dark green" );

		// Make the flying objects
		bird = ct.image( "bird.png", 20, 30, 20 );
		drone = ct.image( "drone.png", 80, 50, 30 );
		fly = ct.image( "fly.png", 80, 20, 5 );

		// Make the score display
		scoreText = ct.text( "0", 90, 10, 10, "brown" );

		// #4 and #6: Fly and drone move continuously to the left
		fly.setXSpeed( -FLY_SPEED );
		drone.setXSpeed( -DRONE_SPEED );
	}

	public void update()
	{ 
		// #1 and #2: Space bar makes bird fly up, releasing goes down
		if (ct.keyPressed("space"))
			bird.setYSpeed( -BIRD_SPEED );
		else
			bird.setYSpeed( BIRD_SPEED );

		// #3: Bird can't go lower than the ground
		if (bird.y > 90)
			bird.y = 90;
 
		// #5: If fly goes off screen to the left, reset for another pass
		if (fly.x < 0)
		{
			fly.x = 150;
			fly.y = ct.random( 10, 80 );   // #10: choose different altitude

			// #12: Subtract a point for each fly missed
			if (score > 0)   // don't let score go negative
			{
				score--;
				scoreText.setText( ct.formatInt( score ) );
			}
		}

		// #7: If drone goes off screen to the left, reset for another pass
		if (drone.x < -drone.getWidth())
		{
			drone.x = 150;
			drone.y = ct.random( 10, 80 );  // #11: choose different altitude
		}

		// #8: If bird hits the fly, add a point and reset the fly for another pass
		if (bird.hit( fly ))
		{
			ct.sound( "crunch.wav" );
			fly.x = 150;
			fly.y = ct.random( 10, 80 );   // #10: different altitude
			score++;
			scoreText.setText( ct.formatInt( score ) );
		}

		// #9: If bird hits the drone, display Game Over alert then restart
		if (bird.hit( drone ))
		{
			ct.sound( "buzz.wav" );
			ct.showAlert( "Game Over!" );
			ct.restart();
		}
	}
}
