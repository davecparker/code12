import Code12.*;

class IndentCheckTests extends Code12Program
{
/*<--
// ERROR "Class member variable declarations and function definitions should be indented"
int unindentedFirstMemberVar;
//-->*/

/*<--
// ERROR "Class member variable declarations and function definitions should be indented"
public void unindentedFirstMemberFunc()
{
}
//-->*/
	public static void main(String[] args)
	{
		Code12.run(new IndentCheckTests());
	}
/*<--	
		// ERROR "Class member variable declarations and function definitions should all have the same indentation"
		int overIndentedMemberVar;
//-->*/
/*<--
// ERROR "Class member variable declarations and function definitions should all have the same indentation"
int underIndentedMemberVar;
//-->*/
/*<--
		// ERROR "Class member variable declarations and function definitions should all have the same indentation"
		void overIndentedMemberFunc()
		{
		}
//-->*/
/*<--
// ERROR "Class member variable declarations and function definitions should all have the same indentation"
void underIndentedMemberFunc()
{
}
//-->*/
/*<--
	void funcWithUnindentedBody()
	{
	// ERROR "A block should be indented more than its beginning {
	ct.println();
	}
//-->*/
	public void start()
	{
		int x = 1;
		int y = 2;
/*<--
			// ERROR "Unexpected change in indentation"
			if (x == 1)
			{
				ct.println("x == 1");
			}
//-->*/
		// if statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (x == 1)
			// ERROR "This line should be indented more than its controlling 'if'"
		ct.println("x == 1");
//-->*/
/*<--
		if (x == 1)
		{
			// ERROR "A block should be indented from its beginning {"
		ct.println("x == 1");
		x = 2;
		}
//-->*/
/*<--
		if (x == 1)
			ct.println("x == 1");
			// ERROR "Unexpected change in indentation"
			x++;
//-->*/
/*<--
		if (x == 1)
		{
			ct.println("x == 1");
		// ERROR "Unexpected change in indentation"
		x++;
		}
//-->*/
/*<--
		if (x == 1)
			// ERROR "The { after an if statement should have the same indentation as the "if""
			{
				ct.println("x == 1");
			}
//-->*/
/*<--
		if (x == 1)
		{
			ct.println("x == 1");
			// ERROR "A block's ending } should have the same indentation as its beginning {"
			}
//-->*/
		// if-else statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (x == 1)
			ct.println("x == 1");
		else
		// ERROR ""This line should be indented more than its controlling "else""
		ct.println("x != 1");
//-->*/
/*<--
		if (x > 1)
		{
			ct.println("x > 1");
			x--;
		}
		else
		{
			// ERROR "A block should be indented more than its beginning {"
		ct.println("x < 1");
		x++;
		}
//-->*/
/*<--
		if (x == 1)
			ct.println("x == 1");
	// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
	else
			ct.println("x != 1");
//-->*/
/*<--		
		if (x == 1)
			ct.println("x == 1");
			// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
			else
			ct.println("x != 1");
//-->*/
/*<--
		if (x == 1)
			ct.println("x == 1");
		else
			ct.println("x != 1");
			// ERROR "Unexpected change in indentation"
			x++;
//-->*/
/*<--
		if (x == 1)
			ct.println("x == 1");
		else
				// ERROR "The { after an \"else\" should have the same indentation as the \"else\""
				{
			ct.println("x != 1");
		}
//-->*/
		// if-else if statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (x == 1)
			ct.println("x == 1");
		else if (x == 2)
		// ERROR "This line should be indented more than its controlling \"elseif\""
		ct.println("x == 2");
//-->*/
/*<--
		if (x == 1)
		{
			ct.println("x == 1");
		}
		else if (x == 2)
		{
		// ERROR "A block should be indented more than its beginning {"
		ct.println("x == 2");
		}
//-->*/
/*<--
		if (x == 1)
			ct.println("x == 1");
		else if (x != 1)
				// ERROR "The { after an else if statement should have the same indentation as the \"else if\""
				{
			ct.println("x != 1");
		}
//-->*/
		// if-else if-else statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (x > 0)
			ct.println("x > 0");
			// ERROR "This else if should have the same indentation as the highlighted \"if\" above it"
			else if (x < 0)
				ct.println("x < 0");
		else
			ct.println("x == 0");
//-->*/
/*<--
		if (x > 0)
			ct.println("x > 0");
		else if (x < 0)
			ct.println("x < 0");
			// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
			else
				ct.println("x == 0");
//-->*/
		// if-else if-else if-else statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (true)
			ct.println();
		else if (false)
			ct.println();
			// ERROR "This \"else if\" should have the same indentation as the highlighted \"if\" above it"
			else if (false)
				ct.println();
			else
				ct.println();
//-->*/
/*<--
		if (true)
			ct.println();
		else if (false)
			ct.println();
		else if (false)
				ct.println();
			// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
			else
				ct.println();
//-->*/
		// if-if-else statements
		// -------------------------------------------------------------------------------------------
/*<--		if (x > 0)
			if (x == 1)
				ct.println("x == 1");
		// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
		else
			ct.println("x < 0");
//-->*/
/*<--		
		if (x > 0)
		{
			if (x == 1)
			{
				ct.println("x == 1");
			}
			else
			{
				ct.println("x != 1");
			}
			// ERROR "A  block's ending } should have the same indentation as its beginning {"
			}
//-->*/
		// if-if-else if statements
		// -------------------------------------------------------------------------------------------
/*<--
		if (x > 0)
			if (x == 1)
				ct.println("x == 1");
		// ERROR "This \"else if\" should have the same indentation as the highlighted \"if\" above it"
		else if (x < 10)
			ct.println("x < 10");
//-->*/
		// for loops
		// -------------------------------------------------------------------------------------------
/*<--
		for (int i = 0; i < 100; i++)
		x += i;

		for (int i = 0; i < 100; i++)
		{
		x += i;
		}
//-->*/
/*<--
		for (int i = 0; i < 100; i++)
		{
			x += i;
			}
//-->*/
/*<--
		for (int i = 0; i < 100; i++)
			{
			x += i;
			}
//-->*/
		// while loops
		// -------------------------------------------------------------------------------------------
/*<--
		while (x < 10)
		x++;
//-->*/
/*<--
		while (x < 10)
		{
		x++;
		ct.println(x);
		}
//-->*/
/*<--
		while (x < 10)
			{
			x++;
			}
//-->*/
/*<--
		while (x < 10)
		{
			x++;
			}
//-->*/
/*<--
		while (x < 10)
			x++;
			y++;
//-->*/
		// do-while loops
		// -------------------------------------------------------------------------------------------
/*<--
		do
		x++;
		while (x < 10);
//-->*/
/*<--
		do
		{
		x++;
		}
		while (x < 10);
//-->*/
/*<--
		do
			{
			x++;
			}
		while (x < 10);
//-->*/
/*<--
		do
		{
			x++;
			}
		while (x < 10);
//-->*/
/*<--		
		do
			x++;
			while (x < 10);
//-->*/
/*<--
		do
			x++;
	while (x < 10);
//-->*/	
		// multi-line variable declarations
		// -------------------------------------------------------------------------------------------
/*<--
		int x1,
		x2,
		x3;
//-->*/
/*<--
		int y1,
			y2, y3,
				y4, y5,
					y6;
//-->*/
		// multi-line variable initializations
		// -------------------------------------------------------------------------------------------
/*<--
		GameObj circle = ct.circle( 0,
		0,
		10);
//-->*/
/*<--
		GameObj rectangle = ct.rect( 0, 0,
			20, 
				10);
//-->*/
		// multi-line function calls
		// -------------------------------------------------------------------------------------------
/*<--
		ct.log( 1,
		2,
		3);
//-->*/
/*<--
		ct.log( 1,
			2,
				3);
//-->*/
/*<--		
		ct.log( 1, ct.circle( 0,
		0,
		10) );
//-->*/
/*<--
		ct.log( 1, ct.circle( 0,
		0,
		10) );
//-->*/
/*<--
		if ( areEqual(1, 
		// ERROR
		2) )
			ct.println("1 == 2");
		else
			ct.println("1 != 2");
//-->*/		
		// multi-line array initializations
		// -------------------------------------------------------------------------------------------
/*<--
		int[] multiLineArrInit = { 1,
		2,
		3 };
//-->*/
/*<--
		int[] multiLineArrInit2 = { 1,
			2,
				3 };
//-->*/
		ct.println("end of start function");
	}
/*<--
	void multiLineFuncDef1( int i,
	int j,
	int k )
	{
	}
//-->*/
/*<--
	void multiLineFuncDef2( double d,
		int i, int j, int k,
			int a, int b, int c )
	{
	}
//-->*/
	// Okay indentation
	// ----------------------------------------------------------------
	int a, b;
	int c, d,
		e, f,
		g;
	GameObj[] coins, 
			  walls;
	final int LIMIT = 100;
	int[] arr = { 1, 2, 3 };
	int[] arr2 = new int[10];
	int[] arr3 = { 1,
				   2, 
				   3 };

	boolean areEqual(int i, int j)
	{
		return i == j;
	}

	public void onMousePress( GameObj obj, 
			double x, double y )
	{
		// if ( obj != null )
		// 	ct.log( obj, ct.random( 1,
		// 							100 ),
		// 			x, y );

		ct.println("Mouse pressed");
	}

	public void onMouseRelease( GameObj obj, 
			double x, 
			double y )
	{
		// int[] arr1 = { 1,
		// 	   2, 
		// 	   ct.random(1,
		// 	   		2) };

		// int[] arr2 = { 1,
		// 			   2, 
		// 			   ct.random( 1,
		// 			              100 ),
		// 			   4 };

		ct.println("Mouse released");

	}

}