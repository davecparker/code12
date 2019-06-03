class ObjectLeak
{
	int numObjects = 800;
	int lastTime = 0;
	int frameRate;

	public void start()
	{
		for (int i = 0; i < numObjects; i++)
		{
			ct.rect(ct.random(0, 100), ct.random(0, 100), 5, 5);
		}
	}

	public void update()
	{
		int time = ct.getTimer();
		frameRate = (int) (1000.0 / (time - lastTime));
		lastTime = time;

		GameObj r = ct.rect(ct.random(0, 100), ct.random(0, 100), 5, 5);
		r.setFillColor("red");
		numObjects++;
	}
}
