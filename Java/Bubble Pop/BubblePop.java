class BubblePop
{
	// Variables to keep track of hits and misses
	int hits = 0;
	int misses = 0;

	public void start()
	{
		// Make the background
		ct.setTitle("Bubble Pop"); 
		ct.setBackImage("underwater.jpg"); 

		// Pre-load the pop sound
		ct.loadSound("pop.wav");
	}

	public void update()
	{
		// Make new bubbles at random times, positions, and sizes
		if (ct.random(1, 20) == 1)
		{
			double x = ct.random(0, 100);
			double y = ct.getHeight() + 25;
			double size = ct.random(5, 20);
			GameObj bubble = ct.image("bubble.png", x, y, size);
			bubble.setSpeed(0, -1);
		}

		// Check if any bubble got clicked
		GameObj obj = ct.objectClicked();
		if (obj != null)
		{
			obj.delete();
			ct.sound("pop.wav");
			hits++;
			ct.println("Hit!");
		}
		else if (ct.clicked())
		{
			misses++;
			ct.println("(miss)");         
		}    
	}
}
