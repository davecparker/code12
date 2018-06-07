// Use Case Tests for:
//    onKeyPress()
//    onKeyRelease()
//    onMousePress()
//    onMouseRelease()

import Code12.*;

public class Spaceship extends Code12Program
{
   GameObj bg;
   GameObj topBg;
   GameObj asteroid;
   GameObj spaceship;
   GameObj rayGunParticle;
   GameObj flame;
   GameObj blackHole; 
   GameObj beginText;
   GameObj traveledText;
   double lightYears;
  
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
      ct.setTitle("3300 light years until the nearest black hole");
      // Background one fills screen initally
      bg = ct.image("seamless_tileable_nebula.jpg",width/2,height/2,width);
      bg.height = height;
      
      // Second background is off of screen upwards
      topBg = ct.image("seamless_tileable_nebula.jpg", width/2, height/2 - height, width );
      topBg.height = height;
      beginText = ct.text("Click on the spaceship to begin!" , width/2, height - 40, 4,"white");
      traveledText = ct.text("Light years traveled: " + 0, 15, 5, 3,"white" );
      
      asteroid = ct.image("asteroid.png", ct.random(10,100),ct.random(10,100), 5 );
      
      spaceship = ct.image("spacecraft.png", width/2, height - 10, 5 );
      spaceship.clickable = true;
      spaceship.visible = true;
      
   }
   
   public void update()
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
      
     
      
 
      if ( spaceship.ySpeed != 0 )
      {
         
         
           
           // If the spaceship goes off screen, set it back to starting position
         if ( spaceship.y < 0 )
            spaceship.y = ct.getHeight() - 10;
 
         traveledText.delete();
        
         lightYears = ct.getTimer() / 1000.0;
      
         traveledText = ct.text("Light years traveled: " + lightYears, 15, 5, 3,"white" );  
          
         //Enter the black hole
         if ( lightYears > 3300 )
         {
               ct.clearScreen();
               blackHole = ct.image("a0620-00.jpg", ct.getWidth()/2, ct.getHeight()/2, ct.getWidth() );
               blackHole.height = ct.getHeight();
               spaceship = ct.image("spacecraft.png", ct.getWidth() - 10, 10, 5 );
               spaceship.setLayer(2);
               // A circle GamObj serves as the origin
               GameObj c = ct.circle(ct.getWidth()/2, ct.getHeight()/2, 1,"white");
               
               // Origin = (circle.x, circle.y)
               // Orbiter is the spaceship
               // Angle is current angle of spaceship, in radians
               // Speed for spaceship
               // Radius is spaceship's distance from origin
               double angle = Math.toRadians(45);
               double radius = ct.distance( spaceship.x, c.x, spaceship.y, c.y );
               spaceship.xSpeed = spaceship.x + Math.cos(angle)*radius;
               spaceship.ySpeed = spaceship.y + Math.sin(angle)*radius;
         }
          
      }
        
      
   }
   
   public void onKeyPress( String keyName )
   { 
      if ( keyName == "right" && spaceship.x < ct.getWidth() )
      {
         spaceship.x += 5;
         flame.x += 5;
      }
      else if ( keyName == "left" && spaceship.x > 0 )
      {
         spaceship.x -= 5;
         flame.x -= 5;
      }
   
   }
  
   public void onKeyRelease(String keyName) 
   {
      // Shoot from spaceship
      if ( keyName == "up" )
      {
         rayGunParticle = ct.circle( spaceship.x, spaceship.y - 4, 1, "red");
         rayGunParticle.ySpeed = - 2;
         
          if ( rayGunParticle.hit(asteroid) )
          {
             asteroid.delete();
             asteroid = ct.image("asteroid.png", ct.random(10,100),ct.random(10,100), 5 );
          }
         
         
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