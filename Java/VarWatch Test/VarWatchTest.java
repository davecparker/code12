import Code12.*;

class VarWatchTest extends Code12Program
{
	double[] doubleArr;
	GameObj gObj;
	int[] intArr;
	int[] intArr1 = { 1, 2, 3, 4, 5 };
	int[] intArr2 = { 5, 10, 15 };

	public void start()
	{
		gObj = null;
	}
	
	public void update()
	{
		int len = intArr1.length;
		for (int i = 0; i < len; i++)
			intArr1[i]++;
		len = intArr2.length;
		for (int i = 0; i < len; i++)
			intArr2[i]++;
	}

	public void onKeyPress( String keyName )
	{
		if ( keyName.equals("1") )
			intArr = intArr1;
		else if ( keyName.equals("2") )
			intArr = intArr2;
		else if ( keyName.equals("3") )
			doubleArr = new double[10];
		else if ( keyName.equals("g") )
		{
			if ( gObj == null )
			{
				gObj = ct.rect(5, 10, 10, 10);
				gObj.xSpeed = 0.1;
			}
			else
			{
				gObj.delete();
				gObj = null;
			}
		}
	}

	public static void main(String[] args)
	{
		Code12.run(new VarWatchTest()); 
	}
}