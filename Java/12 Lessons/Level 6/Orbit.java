class Orbit
{
	// The bodies and their masses
	GameObj sun, planet;
	final double massSun = 40;
	final double massPlanet = 1;
	final double G = 0.4;    // adjustable gravitational constant

	// Initial speeds of the bodies
	double xSpeedSun = 0.0175;
	double ySpeedSun = 0;
	double xSpeedPlanet = -0.7;
	double ySpeedPlanet = 0;

	public void start()
	{
		// Create the bodies
		sun = ct.circle( 30, 50, 10, "orange" );
		planet = ct.circle( 50, 25, 3, "blue" );
	}

	public void update()
	{
		// Calculate the gravitational force
		double dx = sun.x - planet.x;
		double dy = sun.y - planet.y;
		double distance = Math.sqrt( dx * dx + dy * dy );
		double gravity = G * massSun * massPlanet / (distance * distance);
		double xGravity = gravity * dx / distance;
		double yGravity = gravity * dy / distance;

		// Apply gravity to the body speeds
		xSpeedPlanet += xGravity / massPlanet;
		ySpeedPlanet += yGravity / massPlanet;
		xSpeedSun -= xGravity / massSun;
		ySpeedSun -= yGravity / massSun;

		// Move the bodies by their current speeds
		sun.x += xSpeedSun;
		sun.y += ySpeedSun;
		planet.x += xSpeedPlanet;
		planet.y += ySpeedPlanet;
	}
}
