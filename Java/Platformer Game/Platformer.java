import Code12.*;
import java.util.ArrayList;
import java.util.Iterator;
import javafx.animation.AnimationTimer;

class Platformer extends Code12Program
{
   public static void main(String[] args )
   {
      Code12.run(new Platformer()); 
   }
   
   public final String[] LEVEL1 =  
    {
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000111000000000000000000000000",
        "000000001110000000000000000000",
        "000002000000011100002000000000",
        "000001110000000000011100011000",
        "111111110011110001111100111111", // Level One
        "000000000000000000000000000000", // Start level two
        "000011110000000000000000000000",
        "000000001111000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000111000000000000000000",
        "000000000000011100000000000000",
        "000010000000000000000000000111",
        "000000001111100000111000000000",
        "000001110000000000000000000000",
        "111111111111111111111111111111"
    };
    

     ArrayList<GameObj> platforms = new ArrayList<GameObj>();
     ArrayList<GameObj> coins = new ArrayList<GameObj>();
     ArrayList<GameObj> enemies = new ArrayList<GameObj>();

     GameObj player;
     GameObj[] health;
     GameObj platform;
     GameObj coin;
     GameObj scoreText;
     GameObj gameOverText;
     GameObj timerText;
     
     int score;

     double gravity = 0.5;
     boolean onGround = true;
     double levelWidth;
     double mult;


    public void start()
    {
        // Background and static game features 
        ct.setBackColor("black");
        score = 0;
        scoreText = ct.text("Score: ", 8, ct.getHeight() - 10, 5, "white");
        timerText = ct.text("Time: " + 0, ct.getWidth() - 15, ct.getHeight() - 10, 5, "white");
       
        // Multiplier is used for scaling the platforms
        mult = ct.getWidth() / 30;
        levelWidth = LEVEL1[0].length() * mult;      

        for (int i = 0; i < 12; i++)   // This is so I can use the charAt method
        {
            String line = LEVEL1[i];
            for (int j = 0; j < line.length(); j++)
            {
                switch (line.charAt(j))
                {
                    case '0':
                        break;
                    case '1':
                         platform = ct.rect(j*mult, i*mult, mult, mult );
                        
                        platform.setFillColor("orange");
                        platforms.add(platform);
                        break;
                    case '2':
                        coin = ct.circle(j*mult, i*mult, mult/2);
                        coin.setFillColor("yellow");
                        coins.add(coin);
                        break;
                     // Maybe add case 3 for enemy ?
                }
            }
        }
     
        player = ct.image("player_forwards.png", 5, 34, 4);
        for ( int i = 0; i < 3; i++ )
        {
            health[i] = ct.image("8bitheart.png", ct.getWidth() - 10 - i, 10, 5 );
        }
        
    }

    public void update()
    {
      if (player.x > 5 )
      {
         double time = ct.getTimer()/120;
         timerText.delete();
         timerText = ct.text("Time: " + time, ct.getWidth() - 15, ct.getHeight() - 10, 5, "white");
      }
      player.ySpeed += gravity;
      player.y += player.ySpeed;
      
     
      for (GameObj platform: platforms )
      {
         if ( player.hit(platform) )
         {
            // check to see if player hit the platform from above or below
            player.ySpeed = 0.0;
            player.y = platform.y - (platform.height/2 +2); //slightly above
            onGround = true;
         }
      }

      Iterator<GameObj> it = coins.iterator();
      while ( it.hasNext() )
      {
         GameObj coin = it.next();
         if (coin.hit(player) )
         {
            coin.delete();          // Delete from screen
     // Delete from ArrayList coins
            score++;  
         }
      }
      
      for ( GameObj coin: coins )
      {
         if ( coin.hit(player) )
         {
            for ( int i = 0; i < coins.size() - 1; i++ )
            {
                  coins.remove(coins.get(i));
            }
            coin.delete();
            score++;
         }
      
      }
      
      
      scoreText.delete();
      scoreText = ct.text( "Score: " + Integer.toString(score), 12, ct.getHeight() - 10, 5, "white");
      
      if ( player.y > ct.getHeight() )
      {
         for ( int i = 0; i < 3; i++ )
         {
            health[i].delete();
            if ( health[i] == null )
            {
               ct.print("Game over!");
            }
         }
      }

      if ( player.x >= ct.getWidth() || player.y >= ct.getHeight() )
      {
         ct.clearScreen();
         // new level
         mult = ct.getWidth() / 30;
         levelWidth = LEVEL1[12].length() * mult;      
        
        for (int i = 12; i < LEVEL1.length; i++)   // This is so I can use the charAt method
        {
            String line = LEVEL1[i];
            for (int j = 0; j < line.length(); j++)
            {
                switch (line.charAt(j))
                {
                    case '0':
                        break;
                    case '1':
                         platform = ct.rect(j*mult, i*mult, mult, mult );
                        
                        platform.setFillColor("orange");
                        platforms.add(platform);
                        break;
                    case '2':
                        coin = ct.circle(j*mult, i*mult, mult/2);
                        coin.setFillColor("yellow");
                        coins.add(coin);
                        break;
                     // Maybe add case 3 for enemy ?
                }
            }
        }

         
      }
      
    }

  
    public void startJump()
    {
      if ( onGround )
      {
            player.ySpeed = -6.0;
          
            player.xSpeed = 0.5;
            onGround = false;
      }
    }
    
    public void endJump()
    {
      if (player.ySpeed < -3.0)
         player.ySpeed = -3.0;
         player.xSpeed = 0;
    }
    
   
    public void onKeyPress( String key )
    {
      switch (key)
      {
         case("space"):
             startJump();
             ct.sound("retro_jump.wav");
             endJump();
            break;
         case("right"):
            player.x++;
            player.delete();
            player = ct.image("player_forwards.png", player.x, player.y, 4);
            break;
         case("left"):
            player.x--;
            player.delete();
            player = ct.image("player_backwards.png", player.x, player.y, 4);
            break;
         case("m"):  // Toggle music
            ct.sound("cartoon_game_song.wav");
      }

    }


}


 
  