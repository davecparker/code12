import Code12.*;

public class GravityTest extends Code12Program
{
     static final int OBJ_HEIGHT = 10;
     static final int OBJ_WIDTH = 10;

     double rebound;     // Rebound factor
     double reboundDeg;  // The amount the rebound degrades over time
     double yPos;        // The vertical position
     double gravity;     // Gravity
     boolean bounce = false;
        
     GameObj rect;
      
   public static void main(String[] args)
   { 
      Code12.run(new GravityTest()); 
   }
   
   public void start()
   {
      yPos = ct.getHeight() - OBJ_HEIGHT;
      double xPos = (ct.getWidth() - OBJ_WIDTH) / 2;
      rect = ct.rect(xPos, yPos, OBJ_WIDTH, OBJ_HEIGHT);
   }
   
   public void update()
   {             
   }
   
   public void onKeyPress( String key )
   {
      gravity = 0.25f;
      reboundDeg = 2.5f; 
      double height = ct.getHeight();
      
      if ( key == "space" )
      {
         if (yPos + OBJ_HEIGHT == height )   // Can only bounce when on the ground (bottom of game window)
         {
            rect.ySpeed = -8;
            rebound = rect.ySpeed;           // Rebound initially is equivalent to speed
            bounce = true;
                    
            if (height > 0)
            {
               // Is the obj bouncing?
               if (bounce)
               {
               // Add the current speed (can be negative or positive) to the yPos
                  yPos += rect.ySpeed;
                  // Add the gravity to the speed, this will slow down
                  // the upward movement and speed up the downward movement
                  // Maybe add max speed?
                  rect.ySpeed += gravity;
                  // If the obj is not on the ground
                  if (yPos + OBJ_HEIGHT >= height)
                  {
                     // Put the obj on the ground
                     yPos = height - OBJ_HEIGHT;
                     // If the rebound is 0 or more then bouncing has stopped
                     if (rebound >= 0)
                     {
                        // Stop bouncing
                        bounce = false;
                     } 
                     else
                     {
                        // Add the re-bound degregation to the rebound
                        rebound += reboundDeg;
                        // Set the new speed
                        rect.ySpeed = rebound;
                     }
                  }
               }
            }
         }
      }
   }
}


           