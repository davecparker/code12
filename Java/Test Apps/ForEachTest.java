class ForEachTest
{
	int[] nums = new int[4];
	double[] values = new double[4];
	String[] names = new String[4];
	boolean[] flags = new boolean[4];
	GameObj[] objs = new GameObj[4];

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


	}


}
