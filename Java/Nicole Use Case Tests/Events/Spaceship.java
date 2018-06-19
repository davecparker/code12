// Use Case Tests for:
//    onKeyPress()
//    onKeyRelease()
//    onMousePress()
//    onMouseRelease()

// Game level: 8. If-else

import Code12.*;

public class Spaceship extends Code12Program
{
   GameObj bg;
   GameObj topBg;
   GameObj asteroid;
   GameObj spaceship;
   GameObj spaceshipWreck;
   GameObj rayGun;
   GameObj flame;
   GameObj blackHole; 
   GameObj beginText;
   GameObj traveledText;
   double lightYears;
   double hit;
   double collision;
  
   public static void main(String[] args)
   { 
      Code12.run(new Spaceship()); 
   }
   
   public void start()
   { 
      double width = ct.getWidth();
      double height = ct.getHeight();
      
      ct.setTitle("Space Adventure 9000");
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

      asteroid = ct.image("asteroid.png", ct.random(10,100),ct.random(10,100), 10 );

      spaceship = ct.image("spacecraft.png", width/2, height - 10, 5 );
      spaceship.setLayer(2);
      spaceship.clickable = true;
      spaceship.visible = true;
      
      rayGun = ct.circle( spaceship.x, spaceship.y - 2, 1, "red");

   }
   
   public void update()
   {
      ct.setTitle( ct.toInt( 60 - (ct.getTimer() / 1000.0 ) ) + " seconds until the black hole" );
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
      
      // If ray gun goes off screen, put it back in its original position
      if ( rayGun.y < 0 )
      {
         rayGun = ct.circle( spaceship.x, spaceship.y - 2, 1, "red");
      }
      ;

      // If the spaceship is moving upwards and the current time is less than one minute (basically, while game is active)
      if ( spaceship.ySpeed != 0 && ct.getTimer() / 1000.0 < 60 )
      {
         // If spaceship is higher than or equal to than asteroid, relative to the top of the game window, re-draw it
         if ( spaceship.y <= asteroid.y )
         {
            asteroid.delete();
            asteroid = ct.image("asteroid.png", ct.random(10,100),ct.random(ct.toInt(spaceship.y) - 10,100), ct.random(10,30) );
         }

          
         // Increase amount of light years traveled
         traveledText.delete();
         lightYears += 0.5;
         traveledText = ct.text("Light years traveled: " + lightYears, 15, 5, 3,"white" );
         
         // Move the ray gun along with the spaceship
         rayGun.y = spaceship.y;
         
         // If the spaceship goes off screen, set it back to starting position
         if ( spaceship.y < 0 )
            spaceship.y = ct.getHeight() - 10;

      }
       // Check to see if the ray gun hit an asteroid
      hit = ct.distance(rayGun.x, rayGun.y, asteroid.x, asteroid.y );
      if ( hit < 5 )
      {
         asteroid.delete();
         asteroid = ct.image("asteroid.png", ct.random(10,100),ct.random(ct.toInt(spaceship.y),100), ct.random(10,30) );
      }
      
     
      // Check for collisions with spaceship and asteroid)        
      collision = ct.distance(spaceship.x, spaceship.y, asteroid.x, asteroid.y );
         
       if ( collision < 5 )
       {
            ct.sound("explosion.wav");
            blackHole = ct.image("seamless_tileable_nebula.jpg", ct.getWidth()/2, ct.getHeight()/2, ct.getWidth() );
            blackHole.height = ct.getHeight();
            spaceshipWreck = ct.image("spacecraft-wreck.png", spaceship.x, spaceship.y, spaceship.width + 10 );
            spaceship.ySpeed = 0;
            asteroid.delete();         
            traveledText.delete();
            ct.text("Game over! You traveled: " + lightYears + " light years.", ct.getWidth() /2, ct.getHeight() - 10, 5,"white" );
        }
      
      //Enter the black hole after 1 minute
         if ( ct.getTimer() / 1000.0 > 60 )
         {
               blackHole = ct.image("a0620-00.jpg", ct.getWidth()/2, ct.getHeight()/2, ct.getWidth() );
               blackHole.height = ct.getHeight();
               
               // A circle GameObj serves as the origin which all game objs "gravitate" towards
               GameObj origin = ct.circle(ct.getWidth()/2 + 10, ct.getHeight()/2, 10,"black");
               spaceship.xSpeed = (origin.x - spaceship.x) / 15.0;
               spaceship.ySpeed = (origin.y - spaceship.y) / 15.0;
               asteroid.xSpeed = (origin.x - asteroid.x) / 15.0;
               asteroid.ySpeed = (origin.y - asteroid.y) / 15.0;
               traveledText.delete();
               ct.setTitle("Game over");
               ct.text("Game over! You traveled: " + lightYears + " light years.", ct.getWidth() /2, ct.getHeight() - 20, 5,"white" );
               
         }

   }
   
   public void onKeyPress( String keyName )
   { 
      if ( keyName == "right" && spaceship.x < ct.getWidth() )
      {
         spaceship.x += 5;
         rayGun.x += 5;
         if ( spaceship.ySpeed != 0 )
            flame.x += 5;
      }
      else if ( keyName == "left" && spaceship.x > 0 )
      {
         spaceship.x -= 5;
         rayGun.x -= 5;
         if ( spaceship.ySpeed != 0 )
            flame.x -= 5;
      }

   }
  
   public void onKeyRelease(String keyName) 
   {
      // Shoot from spaceship
      if ( keyName == "up" )
      {
         rayGun.ySpeed = - 2;
         ct.sound("raygun.wav");
      }    
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      // If spaceship is clicked on, flame is "active" and both move upward
      if ( obj == spaceship )
      {
         spaceship.ySpeed -= 0.075;
         flame = ct.image("transparent-flame.png", spaceship.x, spaceship.y + spaceship.height/2, 5 );
         flame.ySpeed = spaceship.ySpeed;
         ct.sound("spaceship-engine-short.wav");
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