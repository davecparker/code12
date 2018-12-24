import Code12.*;

class RPG extends Code12Program
{	
	GameObj playerChar;
	int playerCharFrame = 1;

	public void start()
	{
		playerChar = ct.image("walkDown1.png",5,5,5);
	}

	public void update()
	{
		playerCharFrame = playerCharFrame + 1;
		String newImage = 
		playerChar.setImage	
	
	}

	public void onMousePress( GameObj obj, double x, double y )
	{

	}
}