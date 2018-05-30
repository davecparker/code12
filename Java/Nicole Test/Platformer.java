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
        "111111110011110001111100111111" // level one
    };
    

     ArrayList<GameObj> platforms = new ArrayList<GameObj>();
     ArrayList<GameObj> coins = new ArrayList<GameObj>();
     ArrayList<GameObj> enemies = new ArrayList<GameObj>();

     GameObj player;
     GameObj platform;
     GameObj coin;
     GameObj scoreText;
     GameObj gameOverText;
     GameObj timerText;
     
     int score;

     double gravity = 0.5;
     boolean onGround = false;
     double levelWidth;


    public void start()
    {
        // Background and static game features 
        ct.setBackColor("black");
        score = 0;
        scoreText = ct.text("Score: ", 8, ct.getHeight() - 10, 5, "white");
        timerText = ct.text("Time: " + 0, ct.getWidth() - 15, ct.getHeight() - 10, 5, "white");
       
        // Multiplier is used for scaling the platforms
        double mult = ct.getWidth() / 30;
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
     
        player = ct.rect(5, 34, 2, 2);
        player.setFillColor("blue");
        
    }

    public void update()
    {
      double time = ct.getTimer();
      timerText.delete();
      timerText = ct.text("Time: " + time, ct.getWidth() - 15, ct.getHeight() - 10, 5, "white");
      
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

      /*Iterator<GameObj> it = coins.iterator();
      while ( it.hasNext() )
      {
         GameObj coin = it.next();
         if (coin.hit(player) )
         {
            coin.delete();          // Delete from screen
     // Delete from ArrayList coins
            score++;  
         }
      }*/
      
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
      

      if ( player.x >= ct.getWidth() || player.y >= ct.getHeight() )
      {
         ct.clearScreen();
         gameOverText = ct.text("Game Over!", ct.getWidth() / 2, ct.getHeight() / 2, 10, "white");
         gameOverText.ySpeed = gravity;
         
      }
      
    }

  
    public void startJump()
    {
      if ( onGround )
      {
            player.ySpeed = -6.0;
            onGround = false;
      }
    }
    
    public void endJump()
    {
      if (player.ySpeed < -3.0)
         player.ySpeed = -3.0;
    }
    
   
    public void onKeyPress( String key )
    {
      switch (key)
      {
         case("w"):
             startJump();
             endJump();
            break;
         case("d"):
            player.x++;
            break;
         case("space"):
            if (yPos + PLAYER_HEIGHT == height )
            {                                      // Can only bounce from floor (bottom of game window)
               vDelta = -8;
               rebound = vDelta;
               bounce = true;
               
               if (height > 0) 
               {
                  if (bounce)
                        {
                            // Add the vDelta (can be neg or pos) to the yPos
                            yPos += vDelta;
                            // Add the gravity to the vDelta, slows down the
                            // the upward movement and speeds up the downward movement
                            // Maybe set max speed?
                            vDelta += gravity;
                            // If the player is not on the ground...
                            if (yPos + PLAYER_HEIGHT >= height)
                            {
                                // Put the player on the ground
                                yPos = height - PLAYER_HEIGHT;
                                // If the re-bound is 0 or more then bouncing has stopped
                                if (rebound >= 0)
                                {
                                    // Stop bouncing
                                    bounce = false;
                                } else {
                                    // Add the re-bound degregation to the re-bound
                                    rebound += reboundDeg;
                                    // Set the vDelta
                                    vDelta = rebound;
                                }
                           }
                        }
                    }

            }
      }

    }


}


 
  