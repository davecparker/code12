// Use Case Tests for:
//  onKeyPress()
//  onKeyRelease()

import Code12.*;

public class Spaceship extends Code12Program
{
   GameObj bg;
   GameObj topBg;
   
   GameObj spaceship;
   GameObj rayGunParticle;
   
   GameObj beginText;
  
   public static void main(String[] args)
   { 
      Code12.run(new Spaceship()); 
   }
   
   public void start()
   { 
      double width = ct.getWidth();
      double height = ct.getHeight();
      
      // Color any space not covered by the background image
      ct.setBackColor("black");
      
      // Background one fills screen initally
      bg = ct.image("seamless_tileable_nebula.jpg",width/2,height/2,width);
      bg.height = height;
      
      // Second background is off of screen upwards
      topBg = ct.image("seamless_tileable_nebula.jpg", width/2, height/2 - height, width );
      topBg.height = height;
      
      beginText = ct.text("Press up arrow key to begin!", width/2, height - 40, 4,"white");
      // Spaceship to be controlled via arrow keys
      spaceship = ct.image("spacecraft.png", width/2, height - 10, 5 );
   }
   
   public void update()
   {
      if ( spaceship.ySpeed != 0 )
      {
            // Set the initial background down
            bg.ySpeed = 0.5;
            // Set the top background moving down
            topBg.ySpeed = 0.5;
           
           // Once the utmost point of the top background reaches the game window 
           if ( (topBg.y - topBg.height/2) >= 0 )
           {
            // Subtract one background height from both of the background's vertical positions 
               topBg.y -= ct.getHeight();
               bg.y -= ct.getHeight();
           }
           
           // If the spaceship goes off screen, set it back to starting position
           if ( spaceship.y < 0 )
            spaceship.y = ct.getHeight() - 10;
           
           // TODO: Add asteroids that explode when shot with ray gun 
        }
      
   }
   
   public void onKeyPress( String keyName )
   { 
      if ( keyName == "up" )
         spaceship.ySpeed = -0.0025;
      else if ( keyName == "right" && spaceship.x < ct.getWidth() )
            spaceship.x += 5;
      else if ( keyName == "left" && spaceship.x > 0 )
            spaceship.x -= 5;

   }
  
   public void onKeyRelease(String keyName) 
   {
      // Initialize movement
      if ( keyName == "up" )
      {
         beginText.delete();
      } 

      // Shoot from spaceship
      if ( keyName == "space" )
      {
         rayGunParticle = ct.circle( spaceship.x, spaceship.y - 4, 1, "red");
         rayGunParticle.ySpeed = - 2;
      }
         
   }
   
   
}