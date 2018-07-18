import Code12.*;
public class TestProgram extends Code12Program
{
	public static void main(String[] args)
	{
		Code12.run(new TestProgram());
	}
		
	public void start()
	{
	}

	public void onKeyPress( String keyName )
	{
		if ( keyName.equals("b") )
			ct.setBackImage("background.png");
	}
}
