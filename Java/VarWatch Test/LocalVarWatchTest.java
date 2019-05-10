class LocalVarWatchTest
{
	// Declare class-level variables here
	int globalInt = 1;
	double globalDouble = Math.E;
	String globalStrNull = null;
	String globalStrUninitialized;
	GameObj globalGameObjUninitialized;
	int[] globalIntArrUninitialized;
	int[] globalIntArr = { 1, 2, 3 };
	double[] globalDoubleArr = { .1, .2 };
	GameObj globalGameObj = null;
	GameObj[] globalGameObjArr = { null, null };

	public void start()
	{
		// Your program starts here
		func1();
		globalGameObj = ct.circle(50, 50, 10);
		globalGameObj.setXSpeed(1);
	}

	public void update()
	{
		// Code here runs before each animation frame
		globalInt++;
		for ( int i = 0; i < globalIntArr.length; i++ )
			globalIntArr[i]++;
		if ( globalGameObj.x > 100 )
			globalGameObj.x = 0;
	}

	void func1()
	{
		int localInt = 1;
		double localDouble = 3.14;
		boolean localBoolean = false;
		String localString = "foobar";
		String localStringUnitialized;
		String localStringNull = null;
		GameObj localGameObj = ct.circle(1, 2, 10, "blue");
		GameObj localGameObjUninitialized;
		GameObj localGameObjNull = null;
		int[] localIntArr = { 1, 2, 3 };
		double[] localDoubleArr = new double[10];
		GameObj[] localObjArr = { globalGameObj, localGameObj };
		GameObj[] localObjArrUn;
		GameObj[] localObjArrNull = null; 
		ct.pause();
		localGameObj.delete();
	}

	public void onKeyPress( String keyName )
	{
		ct.pause();
	}
}