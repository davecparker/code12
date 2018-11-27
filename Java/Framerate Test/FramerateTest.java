class FramerateTest
{
	// Declare your class-level variables here
	int numObjs = 1500;
	GameObj[] objs = new GameObj[numObjs];
	int startTime;
	int frameCount;
	GameObj frameRateText;

	public void start()
	{
		// Your code here runs once at the start of running the program
		for (int i = 0; i < numObjs; i++)
		{
			objs[i] = ct.rect(50, 50, 10, 10);
			// objs[i] = ct.circle(50, 50, 10);
			// objs[i] = ct.text("Hello World", 50, 50, 10);
			// objs[i] = ct.image("block.png", 50, 50, 10);
			// objs[i] = ct.image("koopa.png", 50, 50, 10);
		}
		frameCount = 1;
		frameRateText = ct.text( "", 0, 0, 5);
		frameRateText.align("top left");
	}

	public void update()
	{
		// Your code here runs once per new frame after start()
		if (frameCount == 1)
			startTime = ct.getTimer();
		else
		{
			double elapsedTime = ct.getTimer() - startTime;
			double avgTime = elapsedTime / frameCount;
			double frameRate = ct.round(1000 / avgTime);
			ct.log(frameRate, frameCount);
			frameRateText.setText(frameRate + " fps");
		}

		frameCount++;
	}
}
