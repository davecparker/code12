/** Black Box Test of Events:
*   onMousePress(), onMouseDrag(), onMouseRelease(),
*   onKeyPress(), onKeyRelease(), on charTyped(), onResize()

*   There are six objects to interact with utilizing these methods:
    -- a pixel sprite, which can be dragged and released with differing velocities
    -- four "obstacles" (GameObj circle), which can be controlled with WASD and arrow keys
    -- a help menu
    
    Instructions are available via pressing the capital h key ("H")
    Resizing the game window results in different background colors 
      depending on the aspect ratio.

*/

import Code12.*;

class EventsTest extends Code12Program
{
   GameObj helpMenu;
   GameObj text;
   GameObj text1;
   GameObj text2;
   GameObj sprite;
   GameObj dialogue;
   GameObj[] obstacles = new GameObj[4];
   int seconds;

   public static void main(String[] args)
   { 
      Code12.run(new EventsTest()); 
   }
   
   public void start()
   {
      sprite = ct.image("sprite.png", 50, 50, 10 );
      obstacles[0] = ct.circle(10,ct.getHeight()-10,10);
      obstacles[1] = ct.circle(ct.getWidth() - 10, 10, 10, "green");
      obstacles[2] = ct.circle(10,10,20,"purple");
      obstacles[3] = ct.circle(ct.getWidth()-10,ct.getHeight()-10,15,"blue");
      
   }
   
   public void update()
   {  
         sprite.clickable = true;
         
         // reverseDirection method keeps objects on screen
         for ( int i = 0; i < obstacles.length; i++ )
         {
            reverseDirection(obstacles[i]);
            
            // if the sprite hits an obstacle, deflect
            if ( sprite.hit(obstacles[i]) )
            {
               sprite.xSpeed *= -1;
               sprite.ySpeed *= -1;
            }
         }
         
         // Bounce sprite off of walls
         reverseDirection(sprite);

     
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      int rand = ct.random(1,3);
      if ( obj != null )
      {
         if ( obj == sprite )
         {
            if ( rand == 1 )
               dialogue = ct.text("Ow!", sprite.x, sprite.y + 5, 3 );
            else if ( rand == 2 )
               dialogue = ct.text("Let go!", sprite.x, sprite.y + 5, 3 );
            else
               dialogue = ct.text("Release me!", sprite.x, sprite.y + 5, 3 );     
            sprite.ySpeed = 0;
            sprite.xSpeed = 0;
         }
         
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( obj != null )
      {
         if ( obj == sprite )
         {
            sprite.x = x;
            sprite.y = y;
            
         }
      }
   }
   
   public void onMouseRelease( GameObj obj, double x, double y )
   {
      if ( obj != null )
      {
         if ( obj == sprite )
         {
            seconds++;
            dialogue.delete();
            
            for ( double v = 0; v < 0.050; v += 0.0025 )
            {
               if ( sprite.x > ct.getWidth()/2 && sprite.y < ct.getHeight()/2 )
               {
                  sprite.ySpeed -= v;
                  sprite.xSpeed += v;
               }
               else if ( sprite.x > ct.getWidth()/2 && sprite.y > ct.getHeight()/2 )
               {
                  sprite.ySpeed += v;
                  sprite.xSpeed += v;
               }
               else if ( sprite.x < ct.getWidth()/2 && sprite.y < ct.getHeight()/2 )
               {
                  sprite.ySpeed -= v;
                  sprite.xSpeed -= v;
               }
               else if ( sprite.x < ct.getWidth()/2 && sprite.y > ct.getHeight()/2 )
               {
                  sprite.ySpeed += v;
                  sprite.xSpeed -= v;
               }
               
               // The longer the sprite is held down whilst being moved around, the faster its velocity
               if ( seconds > 2 ) 
               {
                  sprite.ySpeed -= 2*v;
                  sprite.xSpeed += 2*v;
               }
               
               if ( seconds > 3 )
               {
                  sprite.ySpeed -= 3*v;
                  sprite.xSpeed += 3*v;
               }

            }
         }
      }
      
   }
   
   // Move around obstacles
   public void onKeyPress( String keyName ) 
   {
      if ( keyName.equals("right") )
         obstacles[0].xSpeed = 0.5;
      else if ( keyName.equals("left") )
         obstacles[0].xSpeed = -0.5;
      else if ( keyName.equals("up") )
         obstacles[1].ySpeed = -2;
      else if ( keyName.equals("down") )
         obstacles[1].ySpeed = 2;
      else if ( keyName.equals("w") )
         obstacles[2].ySpeed  = -1;
      else if ( keyName.equals("s") )
         obstacles[2].ySpeed = 1; 
      else if ( keyName.equals("d") )
         obstacles[3].xSpeed = 0.25;
      else if ( keyName.equals("a") )
         obstacles[3].xSpeed = -0.25; 
      
   }
   
   public void reverseDirection( GameObj obj )
   {
      if ( obj != null )
      {
         if ( obj.x <= 0 || obj.x >= ct.getWidth() )
            obj.xSpeed *= -1;
         if ( obj.y <= 0 || obj.y >= ct.getHeight() )
            obj.ySpeed *= -1;
      }
   }
   
   public void onKeyRelease(String keyName )
   {
      if ( keyName.equals("right") )
         obstacles[0].xSpeed = 0;
      else if ( keyName.equals("left") )
         obstacles[0].xSpeed = 0;
      else if ( keyName.equals("up") )
         obstacles[1].ySpeed = 0;
      else if ( keyName.equals("down") )
         obstacles[1].ySpeed = 0;
      else if ( keyName.equals("w") )
         obstacles[2].ySpeed  = 0;
      else if ( keyName.equals("s") )
         obstacles[2].ySpeed = 0; 
      else if ( keyName.equals("d") )
         obstacles[3].xSpeed = 0;
      else if ( keyName.equals("a") )
         obstacles[3].xSpeed = 0;
   }
   
   public void onCharTyped( String ch )
   {
      // Instructions/Help Menu
      if ( ch.equals("H") )
      {
         helpMenu = ct.rect(50,50,30,30,"gray");
         helpMenu.lineWidth = 2;
         helpMenu.setLayer(2);
         
         text = ct.text("Functional keys: " ,helpMenu.x, helpMenu.y - 5, 3 );
         text1 = ct.text("WASD and arrow keys", helpMenu.x, helpMenu.y, 3);
         text2 = ct.text("[ Press escape to exit ]", helpMenu.x, helpMenu.y + 10, 2 );
         
         text.setLayer(3);
         text1.setLayer(3);
         text2.setLayer(3);
         
      }
      
      if ( ct.keyPressed("escape") )
      {
         helpMenu.delete();
         text.delete();
         text1.delete();
         text2.delete();
      }
      
   }
   
   public void onResize()
   {
      double aspectRatio = ct.getWidth() / ct.getHeight();
      ct.print(aspectRatio);
      if ( aspectRatio < 0.50)
         ct.setBackColor("light cyan");
      else if ( aspectRatio < 1 )
         ct.setBackColor("light red");
      else
         ct.setBackColor("light yellow");

   }
}