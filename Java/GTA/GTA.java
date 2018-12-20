class GTA
{
	GameObj map;
	GameObj car;
	double maxSpeed = 1;
	double screenOriginX = 0;
	double screenOriginY = 0;

	public void start()
	{
		// Make map
		double mapWidth = 1024;
		double mapCenter = mapWidth / 2;
		map = ct.image( "GTA1_Liberty_City_map.png", mapCenter, mapCenter, mapWidth );
		// Make car
		car = ct.image( "Porsche.png", 50, 50, 20 );
	}

	public void update()
	{
		// Make arrow keys move the car and screen origin
		if ( ct.keyPressed( "right" ) )
		{
			car.x += maxSpeed;
			screenOriginX += maxSpeed;
			ct.setScreenOrigin( screenOriginX, screenOriginY );
		}
		else if ( ct.keyPressed( "left" ) )
		{
			car.x -= maxSpeed;
			screenOriginX -= maxSpeed;
			ct.setScreenOrigin( screenOriginX, screenOriginY );
		}
		else if ( ct.keyPressed( "down" ) )
		{
			car.y += maxSpeed;
			screenOriginY += maxSpeed;
			ct.setScreenOrigin( screenOriginX, screenOriginY );
		}
		else if ( ct.keyPressed( "up" ) )
		{
			car.y -= maxSpeed;
			screenOriginY -= maxSpeed;
			ct.setScreenOrigin( screenOriginX, screenOriginY );
		}
	}
}
