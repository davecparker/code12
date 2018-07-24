import Code12.*;

public class SimplePlatformer extends Code12Program
{
   GameObj background;
   GameObj playerLeft;
   GameObj playerRight;
   GameObj[] platforms;
   GameObj[] items;
   double gravity = 0.5; 
   boolean onGround = true;
  

   public static void main(String[] args)
   {
      Code12.run(new SimplePlatformer());
   }

   public void start()
   {

      double width = ct.getWidth();
      double height = ct.getHeight();

      platforms = new GameObj[15];

      //background = ct.image("seamlessbg.jpg", width/2, height/2, width);
      //background.height = height;

      // platforms[0] is the ground
      platforms[0]= ct.rect(width/2, height, width * 5, 10,"dark blue");
      platforms[1] = ct.rect(30, height - 10, 20, 10, "dark blue");
      platforms[2] = ct.rect(60, height - 20, 25, 20, "dark blue");
      platforms[3] = ct.rect(90, height - 20, 15, 10);
      platforms[4] = ct.rect(110, height - 10, 10, 10);
      platforms[5] = ct.rect(130, height - 15, 20, 10, "light gray");
      platforms[6] = ct.rect(155, height - 20, 10, 10, "gray");
      platforms[7] = ct.rect(175, height - 25, 20, 20, "gray");
      platforms[8] = ct.rect(190, height - 45, 15, 15, "light gray");
      platforms[9] = ct.rect(175, 35, 10, 2, "gray");

      for ( int i = 0; i < 5; i++ )
      {
         platforms[i].setFillColor(null);
      }

      playerLeft = ct.image("stickmanleft.png", 10, 10,10);
      playerLeft.visible = false;
      playerRight = ct.image("stickmanright.png", 10, 10, 10);

      // only one player visible at a time
      // one facing left one right

   }

   public void update()
   {
      double width = ct.getWidth();
      double height = ct.getHeight();

      if ( playerRight.x > 100 || playerLeft.x > 100 )
      {
         ct.setScreenOrigin(100,0);

      }

      if ( playerRight.x > 200 || playerLeft.x > 200 )
      {
         ct.setScreenOrigin(200,0);
      }

      if ( playerRight.y >= height )
      {
         ct.clearScreen();
         ct.println("You died!");
      }

      playerRight.ySpeed += gravity;
      playerLeft.ySpeed += gravity;

      playerRight.y += playerRight.ySpeed;
      playerLeft.y += playerLeft.ySpeed;


      for(GameObj platform : platforms)
      {
         // Check to see if player hit a platform
         if ( playerRight.hit(platform) || playerLeft.hit(platform) )
         {
            // so we've established that the player collided with a platform, but..

            // if hit from top of platform, this occurs
            if ( playerRight.y < (platform.y - platform.height/2) || playerLeft.y < (platform.y - platform.height/2) )
            {
               ct.println("Player hit a platform");
               playerRight.ySpeed = 0.0;
               playerLeft.ySpeed = 0.0;

               playerRight.y = platform.y - (platform.height/2 + playerRight.height/2);
               playerLeft.y = platform.y - (platform.height/2 + playerLeft.height/2);
               onGround = true;
            }

            // else, fall back to ground
         }
      }


   }

   // need to define a hit from above vs. a hit from the side
   boolean hitFromTop(GameObj player)
   {


   }

   boolean hitFromSide()
   {

   }



   public void startJump()
   {
      if ( onGround )
      {
         ct.println("start the jump");
         playerRight.ySpeed = -6.0;
         playerLeft.ySpeed = -6.0;

         playerRight.xSpeed = 0.5;
         playerLeft.xSpeed = 0.5;

         onGround = false;
      }
   }

   public void endJump()
   {
      if ( playerRight.ySpeed < -3.0 || playerLeft.ySpeed < -3.0 )
      {
         ct.println("end the jump");
         playerRight.ySpeed = -3.0;
         playerLeft.ySpeed = -3.0;
         playerRight.xSpeed = 0;
         playerLeft.xSpeed = 0;
      }  
   }
  

   public void onKeyRelease( String keyName )
   {
       if ( keyName.equals("left") )
      {
         playerRight.xSpeed = 0;
         playerLeft.xSpeed = 0;
      }

      if ( keyName.equals("right") )
      {
         playerRight.xSpeed = 0;
         playerLeft.xSpeed  = 0;
      }

      /*if ( keyName.equals("space"))
      {
         if ( playerRight.ySpeed < -6 )
            playerRight.ySpeed = -6;
      }*/

   }


   public void onKeyPress( String keyName )
   {

      if ( keyName.equals("space"))
      {
         startJump();
         ct.println("spacebar was pressed");
         ct.sound("retro_jump.wav");
         endJump();
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


     


   }
}


