import Code12.*;

class ErrorTest extends Code12Program
{
	public static void main(String[] args)
	{ 
		Code12.run(new ErrorTest()); 
	}

	// ERROR "Return type of start function should be void"
	public int start()
	{
		int i = 3;
		int foo = i + 4;
		ct.setBackColor("light blue"); 
		ct.circle(50, 50, 20);
	}

	void expectedErrors()
	{
		// ERROR "Not enough parameters"
		ct.circle("Oops");
		// ERROR "Value of type double cannot be assigned to an int"
		int i = 3.4;
		// ERROR "Undefined variable"
		x = x + 1;
		// ERROR "cannot be assigned to an int"
		int j = 5 + 3.14;
		// ERROR "already defined"
		int j = 3;
		// ERROR "Undefined function"
		foo();
	}
}

