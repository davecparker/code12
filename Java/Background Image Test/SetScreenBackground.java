import Code12.*;
public class SetScreenBackground extends Code12Program
{
	public static void main(String[] args)
	{
		Code12.run(new SetScreenBackground());
	}
		
	public void start()
	{
		ct.setScreen("screen2");
		ct.setBackImage("background2.jpg");
		ct.setScreen("screen1");
		ct.setBackImage("background1.jpg");		
	}

	public void update()
	{
	}

	public void onKeyPress( String keyName )
	{
		if ( keyName.equals("1") )
			ct.setScreen("screen1");
		else if ( keyName.equals("2") )
			ct.setScreen("screen2");
	}
	
}
