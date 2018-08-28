// ERROR "\"import Code12.*;\" shouldn't be indented"
	// import Code12.*;
import Code12.*;

// ERROR "The class header shouldn't be indented"
	// class CheckIndentationTest extends Code12Program
class CheckIndentationTest extends Code12Program
{
	// ERROR "Class member variable declarations and function definitions should be indented"
// int unindentedFirstMemberVar;

	// ERROR "Class member variable declarations and function definitions should be indented"
// public void unindentedFirstMemberFunc()
// {
// 	ct.println();
// }

	public static void main(String[] args)
	// ERROR "The { after a function header should have the same indentation as the function header"
		// { 
	{
		// ERROR "The body of a function should be indented more than its opening {"
	// Code12.run(new CheckIndentationTest());
		Code12.run(new CheckIndentationTest());
	}
	// ERROR "Class member variable declarations and function definitions should all have the same indentation"
		// int overIndentedMemberVar;

	// ERROR "Class member variable declarations and function definitions should all have the same indentation"
// int underIndentedMemberVar;

	// ERROR "Class member variable declarations and function definitions should all have the same indentation"
		// void overIndentedMemberFunc()
		// {
		// 	ct.println();
		// }

	// ERROR "Class member variable declarations and function definitions should all have the same indentation"
// void underIndentedMemberFunc()
// {
// 	ct.println();
// }

	// Okay indentation
	int x = 1;
	int a, b;
	final int LIMIT = 100;
	int[] arr = { 1, 2, 3 };
	int[] arr2 = new int[10];
	int[] arr3 = { 1,
				   2, 
				   3 };
	GameObj[] coins, walls;

	public void start()
	{
		// First statement to set indentaion level of the block
		ct.println();

			// // ERROR "Unexpected change in indentation"
			// if (x == 1)
			// {
			// 	ct.println("x == 1");
			// }

		// if statements
		// -------------------------------------------------------------------------------------------
		// if (x == 1)
		// 	// ERROR "This line should be indented more than its controlling 'if'"
		// ct.println("x == 1");

		// if (x == 1)
		// {
		// 	// ERROR "A block should be indented from its beginning {"
		// ct.println("x == 1");
		// x = 2;
		// }

		// if (x == 1)
		// 	ct.println("x == 1");
		// 	// ERROR "Unexpected change in indentation"
		// 	x++;

		// if (x == 1)
		// {
		// 	ct.println("x == 1");
		// 	// ERROR "Unexpected change in indentation"
		// x++;
		// }

		// if (x == 1)
		// 	// ERROR "The { after an if statement should have the same indentation as the "if""
		// 	{
		// 		ct.println("x == 1");
		// 	}

		// if (x == 1)
		// {
		// 	ct.println("x == 1");
		// 	// ERROR "A block's ending } should have the same indentation as its beginning {"
		// 	}
		



		// if-else statements
		// -------------------------------------------------------------------------------------------
		// if (x == 1)
		// 	ct.println("x == 1");
		// else
		// 	// ERROR ""This line should be indented more than its controlling "else""
		// ct.println("x != 1");

		// if (x > 1)
		// {
		// 	ct.println("x > 1");
		// 	x--;
		// }
		// else
		// {
		// 	// ERROR "A block should be indented more than its beginning {"
		// ct.println("x < 1");
		// x++;
		// }

	// 	if (x == 1)
	// 		ct.println("x == 1");
	// 		// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
	// else
	// 		ct.println("x != 1");
		
		// if (x == 1)
		// 	ct.println("x == 1");
		// 	// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
		// 	else
		// 	ct.println("x != 1");

		// if (x == 1)
		// 	ct.println("x == 1");
		// else
		// 	ct.println("x != 1");
		// 	// ERROR "Unexpected change in indentation"
		// 	x++;

		// if (x == 1)
		// 	ct.println("x == 1");
		// else
		// 	// ERROR "The { after an \"else\" should have the same indentation as the \"else\""
		// 		{
		// 	ct.println("x != 1");
		// }

		// if-else if statements
		// -------------------------------------------------------------------------------------------
		// if (x == 1)
		// 	ct.println("x == 1");
		// else if (x == 2)
		// 	// ERROR "This line should be indented more than its controlling \"elseif\""
		// ct.println("x == 2");

		// if (x == 1)
		// {
		// 	ct.println("x == 1");
		// }
		// else if (x == 2)
		// {
		// 	// ERROR "A block should be indented more than its beginning {"
		// ct.println("x == 2");
		// }

		// if (x == 1)
		// 	ct.println("x == 1");
		// else if (x != 1)
		// 	// ERROR "The { after an else if statement should have the same indentation as the \"else if\""
		// 		{
		// 	ct.println("x != 1");
		// }

		// if-else if-else statements
		// -------------------------------------------------------------------------------------------
		// if (x > 0)
		// 	ct.println("x > 0");
		// 	// ERROR "This else if should have the same indentation as the highlighted \"if\" above it"
		// 	else if (x < 0)
		// 		ct.println("x < 0");
		// else
		// 	ct.println("x == 0");

		// if ( areEqual(1,
		// 		2) )
		// 	ct.println("x > 0");
		// else if (x < 0)
		// 	ct.println("x < 0");
		// 	// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
		// 	else
		// 		ct.println("x == 0");

		// if-if-else statements
		// -------------------------------------------------------------------------------------------
		// if (x > 0)
		// 	if (x == 1)
		// 		ct.println("x == 1");
		// 	// ERROR "This \"else\" should have the same indentation as the highlighted \"if\" above it"
		// else
		// 	ct.println("x < 0");
		
		// if (x > 0)
		// {
		// 	if (x == 1)
		// 	{
		// 		ct.println("x == 1");
		// 	}
		// 	else
		// 	{
		// 		ct.println("x != 1");
		// 	}
		// 	// ERROR "A  block's ending } should have the same indentation as its beginning {"
		// 	}

		// if-if-else if statements
		// -------------------------------------------------------------------------------------------
		// if (x > 0)
		// 	if (x == 1)
		// 		ct.println("x == 1");
		// 	// ERROR "This \"else if\" should have the same indentation as the highlighted \"if\" above it"
		// else if (x < 10)
		// 	ct.println("x < 10");

		// for loops
		// -------------------------------------------------------------------------------------------
		// for (int i = 0; i < 100; i++)
		// x += i;

		// for (int i = 0; i < 100; i++)
		// {
		// x += i;
		// }

		// for (int i = 0; i < 100; i++)
		// 	{
		// 	x += i;
		// 	}

		// while loops
		// -------------------------------------------------------------------------------------------
		// while (x < 10)
		// x++;

		// while (x < 10)
		// {
		// x++;
		// ct.println(x);
		// }

		// while (x < 10)
		// 	{
		// 	x++;
		// 	}

		// while (x < 10)
		// 	x++;
		// 	y++;

		// do-while loops
		// -------------------------------------------------------------------------------------------
		// do
		// x++;
		// while (x < 10);

		// do
		// {
		// x++;
		// }
		// while (x < 10);

		// do
		// 	{
		// 	x++;
		// 	}
		// while (x < 10);

		// do
		// 	x++;
		// 	while (x < 10);


		// multi-line function calls
		// -------------------------------------------------------------------------------------------
		ct.log( 1,
		2,
		3);

		ct.log( 1,
		ct.circle( 0,
			0,
			10),
			3);

		// multi-line array initializations
		// -------------------------------------------------------------------------------------------
		int[] multiLineArrInit = { 1,
		2,
		3 };

	}

	boolean areEqual(int i, int j)
	{
		return i == j;
	}

	void multiLineFuncDef( int i,
	int j,
	int k )
	{
		ct.log(i, j, k);
	}

}
