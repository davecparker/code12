/** Black Box Test of Events:
*   onMousePress(), onMouseDrag(), onMouseRelease(),
*   onKeyPress(), onKeyRelease(), on charTyped(), onResize()
*/

import Code12.*;

class EventsTest extends Code12Program
{
   GameObj helpMenu;
   GameObj sprite;
   GameObj dialogue;
   int seconds;
   boolean paused = false;
   
   public static void main(String[] args)
   { 
      Code12.run(new EventsTest()); 
   }
   
   public void start()
   {
      sprite = ct.image("sprite.png", 50, 50, 10 );
      
   }
   
   public void update()
   {
      if ( !paused)
      {
         sprite.clickable = true;
         ct.log(sprite);
         
         if ( sprite.y <= 0 || sprite.x >= ct.getWidth() || sprite.y >= ct.getHeight() || sprite.x <= 0 )
         {
            sprite.ySpeed = -sprite.ySpeed;
            sprite.xSpeed = -sprite.xSpeed;
         }
      }
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
         // 
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
               
               // The longer the sprite is held down, the faster its velocity
               if ( seconds > 2 ) //replace wi variable
               {
                  sprite.ySpeed -= 2*v;
                  sprite.xSpeed += 2*v;
               }

            }
         }
      }
      
   }
   
   public void onKeyPress( String keyName ) 
   {
   }
   
   public void onKeyRelease(String keyName )
   {
   }
   
   public void onCharTyped( String ch )
   {
      if ( ch.equals("H") )
      {
         paused = false;
         helpMenu = ct.rect(50,50,10,10,"gray");
      }
   }
   
   public void onResize()
   {
   }
}