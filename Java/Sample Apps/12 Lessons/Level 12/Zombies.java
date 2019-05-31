/*
	Try to get to your friend, but avoid the zombies.
*/
class Zombies
{
	// Constants
	final int NUM_ZOMBIES = 25;
	final double SIZE = 5;
	final double ZOMBIE_SPEED = 0.1;   // as a fraction of their distance
	final double FRIEND_SPEED = 0.25;
	final double HERO_SPEED = 0.25;
	final double MIN_DISTANCE = 20;

	// The game objects
	GameObj hero, friend;
	GameObj[] zombies = new GameObj[NUM_ZOMBIES];


	public void start()
	{
		// Create the hero and the friend
		hero = ct.rect( 50, 70, SIZE, SIZE, "blue" );
		friend = ct.rect( 30, 15, SIZE, SIZE, "green" );

		// Create the zombies and put them in the zombies array
		for (int i = 0; i < NUM_ZOMBIES; i++)
		{
			// Place this zombie in a random spot
			zombies[i] = ct.circle( randomCoord(), randomCoord(), SIZE );

			// If the zombie is too close to the hero, or touching another zombie,
			// then keep trying until we find a better spot.
			while (objHitZombie( zombies[i] ) || ct.distance( zombies[i].x, zombies[i].y, 
					hero.x, hero.y ) < MIN_DISTANCE)
			{
				zombies[i].x = randomCoord();
				zombies[i].y = randomCoord();
			}
		}

		// Instructions
		ct.showAlert( "Use the arrow keys to get to your friend\nbefore the zombies get you!" );

		// The friend starts wandering to the right
		friend.setXSpeed( FRIEND_SPEED );

	}

	public void update()
	{
		// Arrow keys control the hero
		if (ct.keyPressed( "left" ))
			hero.x -= HERO_SPEED;
		if (ct.keyPressed( "right" ))
			hero.x += HERO_SPEED;
		if (ct.keyPressed( "up" ))
			hero.y -= HERO_SPEED;
		if (ct.keyPressed( "down" ))
			hero.y += HERO_SPEED;
		keepOnScreen( hero );

		// The friend wanders back and forth
		if (friend.x > 80 || friend.x < 20)
			friend.setXSpeed( -friend.getXSpeed() );
		friend.setYSpeed( ct.random( -10, 10 ) / 30.0 );
		keepOnScreen( friend );

		// Move the zombies
		moveZombies();

		// Did the hero get to the friend?
		if (hero.hit( friend ))
		{
			ct.showAlert( "You saved your friend!\n\nPress OK to play again" );
			ct.restart();
		}
	}

	// Return a random coordinate in the playing area
	double randomCoord()
	{
		return ct.random( 10, 90 );
	}

	// Move obj if necessary to keep it on the screen
	void keepOnScreen( GameObj obj )
	{
		double w2 = obj.getWidth() / 2;
		obj.x = pinValue( obj.x, w2, ct.getWidth() - w2 );
		double h2 = obj.getHeight() / 2;
		obj.y = pinValue( obj.y, h2, ct.getWidth() - h2 );
	}

	// Return the value v pinned to the range min to max
	double pinValue( double v, double min, double max )
	{
		if (v < min)
			return min;
		if (v > max)
			return max;
		return v;
	}

	// Move all of the zombies for the next frame
	void moveZombies()
	{
		// The zombies all move slowly towards the hero
		for (int i = 0; i < NUM_ZOMBIES; i++)
		{
			// Get a pointer to this zombie
			GameObj zombie = zombies[i];

			// Remember where the zombie was
			double xPrev = zombie.x;
			double yPrev = zombie.y;

			// Move the zombie toward the hero
			double dx = hero.x - zombie.x;
			double dy = hero.y - zombie.y;
			double distance = Math.sqrt( dx * dx + dy * dy );
			zombie.x += ZOMBIE_SPEED * dx / distance;
			zombie.y += ZOMBIE_SPEED * dy / distance;

			// If the zombie ran into another zombie,
			// then put it back where it was.
			if (objHitZombie( zombie ))
			{
				zombie.x = xPrev;
				zombie.y = yPrev;
			}

			// Did this zombie get the hero?
			if (zombie.hit( hero ))
			{
				ct.showAlert( "You died!\n\nPress OK to try again" );
				ct.restart();
			}
		}
	}

	// Return true if obj hit a zombie.
	boolean objHitZombie( GameObj obj )
	{
		// Check each zombie
		for (int i = 0; i < NUM_ZOMBIES; i++)
		{
			// We might be building the array, so it might have empty slots
			if (zombies[i] != null)
			{
				// An object can't hit itself
				if (obj != zombies[i])
				{
					// Did obj hit this zombie? 
					if (obj.hit( zombies[i]) )
						return true;    // hit
				}
			}
		}
		return false;  // the loop didn't find a hit
	}
}
