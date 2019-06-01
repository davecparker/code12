class ArrayVars
{
	// Class-level with new
	int[] nums = new int[4];
	double[] values = new double[4];
	String[] names = new String[4];
	boolean[] flags = new boolean[4];
	GameObj[] objs = new GameObj[4];

	// Class-level with init list
	int[] numsList = { 1, 2, 3, 4 };
	double[] valuesList = { 1.1, 2.2, 3.3, 4.4 };
	String[] namesList = { "A", "B", "C", "D" };
	boolean[] flagsList = { true, false, true, false };
	GameObj[] objsList = { null, null, null, null };

	public void start()
	{
		GameObj circle = ct.circle( 30, 50, 20 );
		GameObj rect = ct.rect( 70, 50, 20, 20 );
		boolean nope = false;

		// Local with new
		int[] localNums = new int[4];
		double[] localValues = new double[4];
		String[] localNames = new String[4];
		boolean[] localFflags = new boolean[4];
		GameObj[] localObjs = new GameObj[4];

		// Local with init list
		int[] localNumsList = { 1, 2, 3, 4 };
		double[] localValuesList = { 1.1, 2.2, 3.3, 4.4 };
		String[] localNamesList = { "A", "B", "C", "D" };
		boolean[] localFlagsList = { true, false, true, false };
		GameObj[] localObjsList = { circle, rect, circle, rect };

		ct.pause();

	}

}
