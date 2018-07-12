import Code12.*;
public class TestProgram extends Code12Program
{
	public static void main(String[] args)
	{
		Code12.run(new TestProgram());
	}
	
	int frameCount = 0;
	
	public void start()
	{
		ct.setHeight( 150 );
		String backgroundFile = "background.png";
		ct.setBackImage(backgroundFile);
		frameCount = 0;
	}

	public void update()
	{
		frameCount++;
		if (frameCount == 60)
			ct.setBackImage("background.png");

	}
}
