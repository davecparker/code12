
import Code12.*;

import java.util.ArrayList;
import java.util.Iterator;

public class Platformer extends Code12Program
{
    public static final String[] LEVEL1 = new String[] 
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
        "111111110011110001111100111111"
    };
    
   //array of platforms, maybe switch to tileset
   ArrayList<GameObj> platforms = new ArrayList<GameObj>();
   
   GameObj player;
   GameObj background;
  
   int levelWidth;
   
   static final int PLAYER_HEIGHT = 10;
   static final int PLAYER_WIDTH = 10;
   float vDelta;     // Vertical delta (changes over time)
   float rebound; 
   float reboundDeg; // Measured in degrees, how much rebound degrades over time
   double yPos;      // The vertical position
   float gravity; 
        
   boolean bounce = false;

   
   public static void main(String[] args)
   { 
      Code12.run(new Platformer()); 
   }
   
   public void start()
   {
      ct.setHeight(100.0 * 9 / 16);
      double width = ct.getWidth();
      double height = ct.getHeight();
      
      background = ct.rect( width / 2, height / 2, width, height ); 
      background.setFillColor("black");
      
      player = ct.image("blob.png", 0, height -3, 10 );
      player.setSize(PLAYER_HEIGHT, PLAYER_WIDTH);
    
   }
   
   public void update()
   {
      //initialize
      levelWidth = LEVEL1[0].length() * 20;  // Multiplier is for scaling(how big each part of the platform will be)
      
      for ( int i = 0; i < LEVEL1.length; i++ )
      {
         String line = LEVEL1[i];
         
         for ( int j = 0; j < line.length(); j++ )
         {
            switch ( line.charAt(j) )
            {
               case '0':
                  break;
               case '1':
                  GameObj platform = ct.rect(j*20,i*20,20,20);
                  platform.setFillColor("white");
                  platforms.add(platform);
                  break;
                  
                   
            }
         }
         
         
      }
      
      //scrolling, will be called whenever the player's x position has changed..need to work on this
      /*double x = player.x;
      
      x.addListener((obs, old, newValue) -> {          
            double offset = newValue.intValue();

            if (offset > 640 && offset < levelWidth - 640) {
                gameRoot.setLayoutX(-(offset - 640));
            }
        });

         appRoot.getChildren().addAll(background, gameRoot, uiRoot);   */
         
        

   }
   
   public void onKeyPress( String key )
   {
      yPos = ct.getHeight() - PLAYER_HEIGHT;
            vDelta = 0;
            gravity = 0.25f;        // Can be adjusted
            reboundDeg = 2.5f;      // Decreased each time player hits floor
            
      double height = ct.getHeight();
      
      switch ( key )
      {
         case("right"):
            if ( player.x > ct.getWidth() )
               player.x = 0;
            player.x += 5;
            break;
         case("left"):
            player.x -= 5;
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
                              
                            
                      