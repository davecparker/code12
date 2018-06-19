//  Use Case Tests for:
//  onKeyPress()
//  onKeyRelease()
//  onMousePress()
//  onMouseRelease()

import Code12.*;

public class Spaceship extends Code12Program
{
   GameObj bg;
   GameObj topBg;
   GameObj asteroid;
   GameObj spaceship;
   GameObj rayGunParticle;
   GameObj flame;
   GameObj beginText;
   GameObj traveledText;
   int lightYears;
  
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
      beginText = ct.text("Click on the spaceship to begin!" , width/2, height - 40, 4,"white");
      traveledText = ct.text("Light years traveled: " + 0, 15, 5, 3,"white" );
      
      spaceship = ct.image("spacecraft.png", width/2, height - 10, 5 );
      spaceship.clickable = true;
      spaceship.visible = true;
      
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
            
          // Display light years traveled
          traveledText.delete();
          lightYears++;
          traveledText = ct.text("Light years traveled: " + lightYears, 15, 5, 3,"white" );
      }
   
   }
   
   public void onKeyPress( String keyName )
   { 
     if ( keyName == "right" && spaceship.x < ct.getWidth() )
         spaceship.x += 5;
      else if ( keyName == "left" && spaceship.x > 0 )
         spaceship.x -= 5;

   }
  
   public void onKeyRelease(String keyName) 
   {
      // Shoot from spaceship
      if ( keyName == "up" )
      {
         rayGunParticle = ct.circle( spaceship.x, spaceship.y - 4, 1, "red");
         rayGunParticle.ySpeed = - 2;
      }
         
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      // If spaceship is clicked on, flame is "active" and both move upward
      if ( obj == spaceship )
      {
         spaceship.ySpeed = -0.05;
         flame = ct.image("transparent-flame.png", spaceship.x, spaceship.y + spaceship.height/2, 5 );
         flame.ySpeed = spaceship.ySpeed;
         ct.sound("spaceship-engine.wav");
         beginText.delete();
      }
   }
 
   public void onMouseRelease( GameObj obj, double x, double y )
   {
      // When nothing is being clicked,
      // there is no movement ( besides the background )
      if ( obj != null )
      {
         spaceship.ySpeed = 0;
         flame.delete();
      }
   }
 
}