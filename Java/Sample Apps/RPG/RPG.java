import Code12.*;

class RPG extends Code12Program
{	
	//Animation
	boolean freeze = false; //if freeze is true no animation happens
	int update = 0; //tracks the number of updates

	//Player Character
	GameObj playerChar; 
	String direction; //stores the direction that the character is facing
	String newImage;
	int playerCharFrame = 1;
	boolean moving = false; 

	public void start()
	{
		//Initializes the player character
		playerChar = ct.image( "down1.png", 5, 5, 5 );
		direction = "down";
	}

	public void update()
	{
		update += 1;

		if( !freeze ) //only animates if freeze is false
		{
			if( update % 8 == 0 ) //happens every 8 updates
			{
				if( moving )
				{
					//Handles the animation of the main character
					if(playerCharFrame < 4)
					{
						playerCharFrame = playerCharFrame + 1;
						newImage = direction + ct.formatInt( playerCharFrame ) + ".png";
						playerChar.setImage(newImage);
					}
					else
					{
						playerCharFrame = 1;
					}
				}
			}
		}
		
		

		//
		
		if( update > 99 ) //resets update at 100 to prevent overflow errors
		{
			update = 0;
		}
	}

	public void onKeyPress( String keyName )
	{

		//Player Movement
		if ( keyName.equals("down") || keyName.equals("s") )
		{
			moving = true;
			playerChar.setYSpeed(1);
		}
	}

	public void onMousePress( GameObj obj, double x, double y )
	{


	}
}