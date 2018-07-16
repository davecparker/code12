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
		// ERROR "Value of type double cannot be assigned to an int"
		int i = 3.4;
		ct.setBackColor("light blue"); 
		ct.circle(50, 50, 20);
		// ERROR "Confused"
		ct.circle("Oops");
	}

	public void update()
	{
		i = i + 1;
		int j = 5 + 3.14;
		int j = 3;
		foo();
	}
}

