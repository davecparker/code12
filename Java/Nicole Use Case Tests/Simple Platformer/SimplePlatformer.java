import Code12.*;

public class SimplePlatformer extends Code12Program
{
   GameObj playerLeft;
   GameObj playerRight;
   GameObj platform;
   GameObj ground;

   double gravity = -0.5;

   boolean onGround = true;
  

   public static void main(String[] args)
   {
      Code12.run(new SimplePlatformer());
   }

   public void start()
   {
      double width = ct.getWidth();
      double height = ct.getHeight();

      ground = ct.line(0, height - 10, width, height -10);
      platform = ct.rect(30, height - 20, 20, 20,"light blue" );
      playerLeft = ct.image("stickmanleft.png", 10, height - 15,10);
      playerLeft.visible = false;
      playerRight = ct.image("stickmanright.png", 10, height - 15, 10);

      // only one player visible at a time
      // one facing left one right

   }

   public void update()
   {
      double height = ct.getHeight();
      /*playerRight.ySpeed += gravity;
      //playerRight.y += playerRight.ySpeed;
      playerLeft.ySpeed += gravity;
      //playerLeft.y += playerLeft.ySpeed;
*/
      if ( playerRight.y > ( height-20) || playerLeft.y > (height-20) )
      {
         onGround = true;
      }

      if ( playerRight.hit(platform) || playerLeft.hit(platform ))
      {
         onGround = true;
      }

      bounce(playerRight);
      bounce(playerLeft);

   }

   public void onKeyRelease( String keyName )
   {

   }

   public void bounce(GameObj obj)
   {
      if ( obj.x > ct.getWidth() )
         obj.x = 0;
      if ( obj.x < 0 )
         obj.x = ct.getWidth();
      if ( obj.y > ct.getHeight() )
         obj.y--;
      if ( obj.y < 0 )
         obj.y++;
   }



   public void onKeyPress( String keyName )
   {

      if ( keyName.equals("space"))
      {
         for ( double s = 5; s > 0; s--)
         {
            playerRight.ySpeed = -s;
            if ( playerRight.y < 30 )
            {
               ct.println("is this executing");
               playerRight.ySpeed = -playerRight.ySpeed;
            }
         }
         
      }

      if ( keyName.equals("left") )
      {
         playerRight.visible = false;
         playerLeft.visible = true;
         playerRight.xSpeed -= 1;
         playerLeft.xSpeed -= 1;
      }

      if ( keyName.equals("right") )
      {
         playerRight.visible = true;
         playerLeft.visible = false;
         playerRight.xSpeed += 1;
         playerLeft.xSpeed += 1;
      }


      // a distance from top of players y value minus 
      // double distance = ct.distance( player.x, player.y, player.x, player.y - 10)
      // set jump player y speed to negative
      // if ( player.y > player.y + d)



   }
}


