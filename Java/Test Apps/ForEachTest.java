class ForEachTest
{
	int[] nums = new int[4];
	double[] values = new double[4];
	String[] names = new String[4];
	boolean[] flags = new boolean[4];
	GameObj[] objs = new GameObj[4];
	int i = 0;

	public void start()
	{
		nums[0] = 1;
		for (int n: nums)
			ct.println( n );

		values[0] = 3.14;
		for (double x: values)
			ct.println( x );
		
		names[0] = "Test";
		for (String s: names)
			ct.println( s );

		flags[0] = true;
		for (boolean f: flags)
			ct.println( f );

		objs[0] = ct.circle( 50, 50, 20 );
		for (GameObj obj: objs)
			ct.println( obj );

		ct.println( "Infinite while loop..." );
		while (true)
			i++;

		// ct.println( "Infinite do-while loop..." );
		// do
		// 	i++;
		// while (true);

		// ct.println( "Infinite for loop..." );
		// for (;;)
		// 	i++;

	}

	public void update()
	{
		// // Incorrect for loop, is essentially infinite
		// for (int j = 1; j > 0 ; j++ )
		// {
		// 	ct.println( j );
		// 	i++;
		// }

		objs[0].x++;
		if (objs[0].x > 100)
			objs[0].x = 0;

	}


}
