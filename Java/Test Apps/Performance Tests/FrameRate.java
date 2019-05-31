class FrameRate
{
	final int NUM_OBJECTS = 2500;
	int numFrames = 0;
	int startTime;

	public void start()
	{
		for (int i = 0; i < NUM_OBJECTS; i++)
		{
			ct.rect(ct.random(0, 100), ct.random(0, 100), 5, 5);
		}
	}

	public void update()
	{
		numFrames++;
		if (numFrames == 1)
			startTime = 0;
		else
		{
			double totalTime = ct.getTimer() - startTime;
			double aveTime = totalTime / numFrames;
			ct.println(1000 / aveTime);
		}
	}
}
