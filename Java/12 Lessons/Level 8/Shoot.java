/*
	Clicking creates a target and fires a bullet at it.
	There can be only one target and bullet on screen at a time,
	so clicking too quickly is ignored.
	The target is deleted when it is hit.
*/ 
class Shoot
{
	// Since there is only 1 bullet and 1 target, we can use a single 
	// class-level variable for each, which is null when it doesn't exist.
	GameObj bullet = null;
	GameObj target = null;

	public void start()
	{
		ct.println( "Click to shoot" );
	}

	public void update()
	{
		// Does the bullet exist?
		if (bullet == null)
		{
			// No bullet yet: Clicking makes the target and fires the bullet at it.
			if (ct.clicked())
			{
				target = ct.circle( ct.clickX(), ct.clickY(), 5 );
				bullet = ct.rect( ct.clickX(), 100, 1, 5 );
				bullet.setYSpeed( -3 );
			}
		}
		else  // the bullet is in flight
		{
			// If the bullet hits the target, delete the target
			if (bullet.hit( target ))
			{
				target.delete();
				target = null;
			}

			// Delete the bullet when it reaches the top of the screen
			if (bullet.y < 0)
			{
				bullet.delete();
				bullet = null;
			}
		}
	}
}
