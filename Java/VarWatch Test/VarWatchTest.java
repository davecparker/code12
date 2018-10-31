import Code12.*;

class VarWatchTest extends Code12Program
{
	int intVarrrrrrrrrrrrrrrr;
	double dblVar;
	boolean boolVar;
	String strVar;
	double[] doubleArr = new double[0];
	GameObj gObj;
	int[] intArr;
	int[] intArr1 = { 1, 2, 3, 4, 5 };
	int[] intArr2 = { 5, 10, 15 };
	GameObj[] gObjArr = new GameObj[5];
	GameObj[] gObjArr1 = new GameObj[1];
	GameObj[] gObjArr2 = new GameObj[2];

	public void start()
	{
		gObj = null;
		for (int i=1; i<100; i++)
			ct.println(i);
		gObjArr2[0] = ct.rect(50, 20, 30, 5);
		gObjArr1[0] = ct.text("gObjArr1[0]", 50, 20, 5);
	}
	
	public void update()
	{
		int len = intArr1.length;
		for (int i = 0; i < len; i++)
			intArr1[i]++;
		len = intArr2.length;
		for (int i = 0; i < len; i++)
			intArr2[i] += 5;
		if ( gObj != null )
		{
			gObj.width += 0.01;
			gObj.height += 0.01;
		}
	}

	public void onKeyPress( String keyName )
	{
		if ( keyName.equals("1") )
		{
			intArr = intArr1;
			gObjArr = gObjArr1;
		}
		else if ( keyName.equals("2") )
		{
			intArr = intArr2;
			gObjArr = gObjArr2;
		}
		else if ( keyName.equals("3") )
			doubleArr = new double[10];
		else if ( keyName.equals("g") )
		{
			if ( gObj == null )
			{
				gObj = ct.rect(5, 10, 10, 10);
				gObj.group = "rectangles";
				gObj.xSpeed = 0.1;
				gObj.ySpeed = 0.1;
			}
			else
			{
				gObj.delete();
				gObj = null;
			}
		}
		else if ( keyName.equals("a") )
		{
			int len = gObjArr.length;
			if ( gObjArr[0] == null )
			{
				for ( int i = 0; i < len; i++ )
				{
					gObjArr[i] = ct.circle(0, 10*i, 10);
					gObjArr[i].group = "circles";
					gObjArr[i].xSpeed = ct.random(0,10) / 100.0;
					gObjArr[i].ySpeed = ct.random(0,10) / 100.0;
				}
			} 
			else
			{
				for ( int i = 0; i < len; i++ )
				{
					if ( gObjArr[i] != null )
					{
						gObjArr[i].delete();
						gObjArr[i] = null;
					}
				}
			}
			if ( gObj == null )
			{
				gObj = ct.rect(5, 10, 10, 10);
				gObj.group = "rectangles";
				// gObj.xSpeed = 0.1;
			}
			else
			{
				gObj.delete();
				gObj = null;
			}
		}
		else if ( keyName.equals("d") )
		{
			if (gObjArr1[0] != null)
			{
				gObjArr1[0].delete();
				gObjArr1[0] = null;
			}
			if (gObjArr2[0] != null)
			{
				gObjArr2[0].delete();
				gObjArr2[0] = null;
			}
		}
		else if ( keyName.equals("n") )
		{
			intArr = null;
		}
	}

	public static void main(String[] args)
	{
		Code12.run(new VarWatchTest()); 
	}
}