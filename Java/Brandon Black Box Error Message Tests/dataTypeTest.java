import Code12.*;

public class dataTypeTest extends Code12Program
{
	public static void main(String[] args)
	{ 
		Code12.run( new dataTypeTest() ); 
	}

	public void start()
	{
		int i = 2147483647; //this is the maximum value of a Java int
		int negI = -2147483648; //this is the minimum value of a Java int

		int x = 2147483648; //this is the allowed in Code12 and not in Java
		int negX = -2147483649; //this is the allowed in Code12 and not in Java

		i = i + 1; //the maximum int value plus 1
		negI = negI - 1; //the minimum int value minus 1
      
		int doubleI = i * 2;

		ct.println( "Maximum int :" + i ); //this overflows and prints the minimum int value in JGrasp and prints 2147483648 in Code12
		ct.println( "Minimum int :" + negI ); //this overflows and prints the maximum int value in JGrasp and prints -2147483649 in Code12
		ct.println("Double max int:" + doubleI);

		double y = 1.7976931348623157 * Math.pow(10, 308);
		ct.println("Largest Double: " + y);

		double yplus1 = y + 1;
		ct.println("Largest Double Plus 1: " + yplus1);

		ct.print("Difference between them: " + (yplus1 - y) );

		boolean t;
		boolean f = false;
		
	}

	public void test()
	{

	}
}