class ProjectileMotion
{
	double initialVelocity = 1;
	double gravity = 0.01;
	int numObjsMade = 0;
	double startTime;
	double secondsBetweenNewobjs = 0.1;
	double bounceLoss = 0.75;
	GameObj ground, sky;
	GameObj[] objs = new GameObj[2000];

	public void start()
	{
		ct.setHeight( 100.0 * 9 / 16 );
		ct.setScreenOrigin( -2, -50 );
		ground = ct.rect( 0, 0, 1000, 1000, "green" );
		addObj( ground );
		ground.align( "top" );
		sky = ct.rect( 0, 0, 1000, 1000, "blue" );
		addObj( sky );
		sky.align( "bottom" );
		makeBalls();
		startTime = ct.getTimer();

	}

	public void update()
	{
		for ( int i = 2; i < numObjsMade; i++ )
		{
			GameObj b = objs[i];
			if ( !b.hit( ground ) )
				b.setYSpeed( b.getYSpeed() + gravity );
			else
			{
				b.y = -b.getHeight() / 2 - 0.1;
				b.setYSpeed( -b.getYSpeed() * bounceLoss );
			}
		}

		if ( ct.getTimer() - startTime > secondsBetweenNewobjs * 1000 )
		{
			makeBalls();
			startTime = ct.getTimer();
		}

	}

	public void makeBalls()
	{
		for ( double degrees = 10; degrees > -90; degrees -= 10 )
		{
			if ( numObjsMade < objs.length )
			{
				double diameter = 3;
				GameObj ball = ct.circle( 0, -diameter / 2 - 1, diameter, "red" );
				double radians = degrees * Math.PI / 180;
				ball.setXSpeed( initialVelocity * Math.cos( radians ) );
				ball.setYSpeed( initialVelocity * Math.sin( radians ) );
				addObj( ball );
			}
		}
	}

	public void addObj( GameObj g )
	{
		objs[numObjsMade] = g;
		numObjsMade++;
	}
}
