
/* TODO: task 1
 * 		collisions
 */

class Golf
{
	String[] traceColors = { "light green", "light yellow", "light red" };
	boolean aiming = false;
	boolean hitTerrain = true;
	GameObj ball;
	double dist;
	double phi = 0;
	double g = 0.02;
	int len = 15;
	double xi, yi;

	public void start()
	{
		ct.setBackColor( "dark gray" );
		ct.loadSound( "clack.wav" );
		ct.line( 0, 7 * ct.getHeight() / 8, 100, 7 * ct.getHeight() / 8, "white" );
		ball = ct.circle( 50, 50, 3, "white" );
		ball.setLineWidth( 0 );

		GameObj ground = ct.line( 60, 100, 100, 50, "white" );
		ground.group = "terrain";
	}

	public void update()
	{
		double xSpeed = ball.getXSpeed();
		double ySpeed = ball.getYSpeed();

		// left boundary
		if ( ball.x - ball.getWidth() / 2 < 0 )
		{
			ball.x = ball.getWidth() / 2;
			ball.setXSpeed( -xSpeed / 2 );
			ct.sound( "clack.wav" );
		}
		// right boundary
		else if ( ball.x + ball.getWidth() / 2 > ct.getWidth() )
		{
			ball.x = 100 - ball.getWidth() / 2;
			ball.setXSpeed( -xSpeed / 2 );
			ct.sound( "clack.wav" );
		}

		// terrain
		if ( ball.objectHitInGroup( "terrain" ) == null )
		{
			hitTerrain = true;
			xi = ball.x;
			yi = ball.y;
		}
		else if ( ball.objectHitInGroup( "terrain" ) != null && hitTerrain )
		{
			hitTerrain = false;
			xSpeed = ball.getXSpeed();
			ySpeed = ball.getYSpeed();
			ball.x = xi;
			ball.y = yi;
			double speed = Math.sqrt( xSpeed * xSpeed + ySpeed * ySpeed ) / 2;
			double theta = Math.atan2( -ySpeed, xSpeed ) + Math.atan2( 50, 40 );
			ball.setXSpeed( speed * -Math.cos( theta ) );
			ball.setYSpeed( speed * -Math.sin( theta ) );
			// if ( Math.abs( speed ) > 0.05 )
			ct.sound( "clack.wav" );
			// ct.pause();
		}

		// bottom boundary
		if ( ball.y + ball.getHeight() / 2 >= 7 * ct.getHeight() / 8 )
		{
			ball.y = 7 * ct.getHeight() / 8 - ball.getHeight() / 2;
			ball.setYSpeed( -ySpeed / 2 );
			if ( Math.abs( ySpeed ) > 0.05 )
				ct.sound( "clack.wav" );
			else
				ball.setYSpeed( 0 );
			// friction
			xSpeed = ball.getXSpeed();
			if ( Math.abs( xSpeed ) <= 0.01 )
				ball.setXSpeed( 0 );
			else if ( xSpeed != 0 )
				ball.setXSpeed( xSpeed - sign( xSpeed ) * g );
		}
		// gravity
		else
			ball.setYSpeed( ySpeed + g );
	}

	public void onMouseDrag( GameObj obj, double x, double y )
	{
		if ( obj == ball )
		{
			aiming = true;
			ct.clearGroup( "traces" );
			dist = ct.distance( obj.x, obj.y, x, y );
			phi = Math.atan2( y - obj.y, x - obj.x );
			for ( int i = 0; i < traceColors.length; i++ )
			{
				double r = ( i + 1 ) * len;
				if ( dist < r )
					r = dist;
				double xf = r * Math.cos( phi ) + obj.x;
				double yf = r * Math.sin( phi ) + obj.y;
				GameObj trace = ct.line( obj.x, obj.y, xf, yf, traceColors[ i ] );
				trace.setLineWidth( 4 );
				trace.setLayer( -i - 1 );
				trace.group = "traces";
			}
		}
	}

	public void onMouseRelease( GameObj obj, double x, double y )
	{
		if ( aiming )
		{
			aiming = false;
			ct.clearGroup( "traces" );
			// give speed
			double r = Math.min( dist, traceColors.length * len );
			ball.setXSpeed( r * Math.cos( phi + Math.PI ) / len );
			ball.setYSpeed( r * Math.sin( phi + Math.PI ) / len );
		}
	}

	public void onKeyRelease( String key )
	{
		if ( key.equals( "escape" ) )
		{
			aiming = false;
			ct.clearGroup( "traces" );
		}
	}

	int sign( double a )
	{
		if ( a > 0 )
			return 1;
		if ( a < 0 )
			return -1;
		return 0;
	}
}