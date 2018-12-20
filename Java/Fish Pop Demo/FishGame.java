// A simple game where you control a fish to pop bubbles

class FishGame
{
	final double SPEED = 0.5;     // fish swimming speed
	int numBubbles = 0;           // number of bubbles spawned
	int numHits = 0;              // number of bubbles popped
	GameObj fish, score;          // game objects

	public void start()
	{
		// Set the game background
		ct.setTitle( "Fish Pop" );
		ct.setHeight( 120 );
		ct.setBackImage( "underwater.jpg" );

		// Make the fish
		fish = ct.image( "goldfish.png", 30, 50, 20 );
		fish.setXSpeed( SPEED );

		// Make the score display
		score = ct.text( "0%", 100, 0, 8, "yellow" );
		score.align( "top right" );
	}

	public void update()
	{
		// Up/down arrow keys control the swimming
		if (ct.keyPressed( "up" ))
			fish.setYSpeed( -SPEED );
		else if (ct.keyPressed( "down" ))
			fish.setYSpeed( SPEED );
		else
			fish.setYSpeed( 0 );

		// Make the fish recycle continuously left to right
		if (fish.x > 110)
		{
			fish.x = -10;   // off-screen to the left
			ct.println( "Recycled after " + numBubbles + " bubbles" );
		}

		// Keep the fish on the screen vertically
		if (fish.y > 105)
			fish.y = 105;
		else if (fish.y < 10)
			fish.y = 10;

		// Spawn random bubbles
		if (ct.random( 1, 60 ) == 1)   // about 1 per second
		{
			double x = ct.random( 0, 100 );
			GameObj bubble = ct.image( "bubble.png", x, 120, 10 );
			bubble.group = "bubbles";
			bubble.setYSpeed( -SPEED * 0.7 );
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
