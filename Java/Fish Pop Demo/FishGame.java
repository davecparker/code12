class FishGame
{
	GameObj fish;
	GameObj score;
	final double SPEED = 0.5;
	int numBubbles = 0;
	int numHits = 0;

	public void start()
	{
		// Make the background,fish, and score text
		ct.setBackImage( "underwater.jpg" );
		fish = ct.image( "goldfish.png", 30, 50, 20 );
		score = ct.text( "0%", 100, 0, 8, "yellow" );
		score.align( "top right" );
	}

	public void update()
	{
		// Up/down arrow keys control the swimming
		double ySpeed = 0;
		if (ct.keyPressed( "up" ))
			ySpeed = -SPEED;
		else if (ct.keyPressed( "down" ))
			ySpeed = SPEED;
		fish.setSpeed( SPEED, ySpeed );

		// Keep the fish on the screen (except top)
		if (fish.x > 110)
			fish.x = -10;
		if (fish.y > 90)
			fish.y = 90;

		// Spawn random bubbles
		if (ct.random( 1, 60 ) == 1)   // about 1 per second
		{
			double x = ct.random( 0, 100 );
			GameObj bubble = ct.image( "bubble.png", x, 120, 10 );
			bubble.group = "bubbles";
			bubble.setSpeed( 0, -SPEED * 0.7 );
			numBubbles++;
		}

		// Check for fish hitting a bubble
		GameObj bubbleHit = fish.objectHitInGroup( "bubbles" );
		if (bubbleHit != null)
		{
			ct.sound( "pop.wav" );
			bubbleHit.delete();
			numHits++;
		}

		// Update the score
		if (numBubbles > 0)
		{
			int percent = ct.round( 100.0 * numHits / numBubbles );
			score.setText( percent + "%" );
		}
	}
}
