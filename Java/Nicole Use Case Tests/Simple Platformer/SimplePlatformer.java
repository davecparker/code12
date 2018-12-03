import Code12.*;

public class SimplePlatformer extends Code12Program
{
   GameObj background;
   GameObj playerLeft;
   GameObj playerRight;
   GameObj[] platforms;
   GameObj[] items;
   GameObj[] clouds;
   GameObj ladder;
   double gravity = 0.5; 
   boolean onGround = true;


   boolean isJumping = false; //Is the player in a jump?
   boolean wasJumping = false; //Did the player just exit a jump?
   double jumpTime = 0; //Time the player has been in a jump (Useful for adding a power curve or to max out on jump height)

   double maxJumpTime = .8; //If you want to max out a jump, otherwise remove the relevant parts of the code
   double jumpLaunchVelocity = -3000.0; //How
 
   public static void main(String[] args)
   {
      Code12.run(new SimplePlatformer());
   }

   public void start()
   {

      double width = ct.getWidth();
      double height = ct.getHeight();

      platforms = new GameObj[15];

      ct.setBackColorRGB(0,100,100);

      // Background objects in the game
      GameObj tree = ct.image("tree.png", 15, height - 14,15);
      tree.setLayer(0);

      GameObj sun = ct.image("sun.png", width - 10, 10, 10 );
      clouds = new GameObj[5];
      clouds[0] = ct.image("cloud3.png", -35, 10, 20);
      clouds[1] = ct.image("cloud2.png", -15, 20, 25);
      clouds[2] = ct.image("cloud1.png", 20, 10, 20);
      clouds[3] = ct.image("cloud2.png", 50, 30, 25);
      clouds[4] = ct.image("cloud3.png", 30, 20, 20);

      // Platforms, platforms[0] is the ground
      platforms[0]= ct.rect(width/4, height, 40, 10,"dark green");
      platforms[1] = ct.rect(30, height - 10, 20, 10, "dark green");
      platforms[2] = ct.rect(60, height - 20, 25, 20, "dark green");
      platforms[3] = ct.rect(90, height - 20, 15, 10,"orange");
      platforms[4] = ct.rect(110, height - 10, 10, 10,"orange");
      platforms[5] = ct.rect(130, height - 15, 20, 10, "orange");
      platforms[6] = ct.rect(155, height - 20, 10, 10, "orange");
      platforms[7] = ct.rect(175, height - 25, 20, 20, "orange");
      platforms[8] = ct.rect(190, height - 45, 15, 15, "orange");
      platforms[9] = ct.rect(175, 35, 10, 2, "yellow");
      platforms[10] = ct.rect(155, 25, 10, 15, "yellow");
      platforms[11] = ct.rect(135, 15, 15, 20, "yellow");
      
      ladder = ct.image("ladder.png", 135, 0, 10);

      // TODO: solid platforms
      // use variables to store your old location and sends you back there if there is a wall collision.
      // or where the player rectangle OVERLAPS with platform rect
      // while ( player != colliding with platform) ? 


      // Two "twin" players (one facing left, one facing right)
      // Only one is visible at a time
      playerLeft = ct.image("stickmanleft.png", 10, 10, 8);
      playerLeft.visible = false;
      playerRight = ct.image("stickmanright.png", 10, 10, 8);

      /*playerLeft = ct.image("stickmanleft.png", 10, height - 8 , 8);
      playerLeft.visible = false;
      playerRight = ct.image("stickmanright.png", 10, height - 8, 8);*/



   }

   public void update()
   {
      double width = ct.getWidth();
      double height = ct.getHeight();

      // Using ct.setScreenOrigin to adjust viewpoint of the "world"

<<<<<<< HEAD
      // Moving the origin to the left
       //if ( playerRight.x < 100 || playerLeft.x  < 100 )
         //ct.setScreenOrigin(-100,0);
=======
      if ( playerRight.x < 100 || playerLeft.x  < 100 )
         ct.setScreenOrigin(0,0);
>>>>>>> master

      // Moving the origin to the right
      if ( playerRight.x > 100 || playerLeft.x > 100 )
         ct.setScreenOrigin(100,0);
      if ( playerRight.x > 200 || playerLeft.x > 200 )
         ct.setScreenOrigin(200,0);

      // Move the origin upwards
      if ( playerRight.y <= 0 || playerLeft.y <= 0 )
         ct.setScreenOrigin(100,100);

      if ( playerRight.y >= height )
      {
         ct.clearScreen();
         ct.println("You died!");
      }

      // Simple gravity mechanics
      playerRight.ySpeed += gravity;
      playerLeft.ySpeed += gravity;

      playerRight.x += playerRight.xSpeed;
      playerLeft.x += playerLeft.xSpeed;

      playerRight.y += playerRight.ySpeed;
      playerLeft.y += playerLeft.ySpeed;

      for ( GameObj platform : platforms )
      {
         // Check to see if player hit a platform
         if ( playerRight.hit(platform) || playerLeft.hit(platform) )
         {
            playerRight.ySpeed = 0.0;
            playerLeft.ySpeed = 0.0;
            // so we've established that the player collided with a platform, but from which side?
            String from = hitFrom(playerLeft);

            // if hit from top of platform, this occurs
            if ( playerRight.y < (platform.y - platform.height/2) || playerLeft.y < (platform.y - platform.height/2) )
            {

               playerRight.y = platform.y - (platform.height/2 + playerRight.height/2);
               playerLeft.y = platform.y - (platform.height/2 + playerLeft.height/2);
               onGround = true;
            }
            else if (from.equals("bottom"))
            {
               endJump();

            }
            // reverse player's direction if collision with the side of a platform
            else if (from.equals("left"))
            {
               playerLeft.visible = false;
               playerRight.visible = true;

               playerLeft.x = platform.x + platform.width;
               playerRight.x = platform.x + platform.width;

            }
            else if (from.equals("right"))
            {
               playerRight.visible = false;
               playerLeft.visible = true;

               playerLeft.x = platform.x - platform.width;
               playerRight.x = platform.x - platform.width;
            }
         }
      }

      if ( playerRight.hit(ladder) || playerLeft.hit(ladder))
      {
         playerRight.ySpeed = -0.25;
         playerLeft.ySpeed = -0.25;
         
         if ( playerRight.y <= 0 )
         {
            playerRight.ySpeed = 0;
            playerLeft.ySpeed = 0;
         }

      }

   }
   // Collision detection to detect from which side the rectangle collision occurred
   // Minkowski sum of the two original rectangles (A and B), 
   // which is a new rectangle, and then checks where the center
   // of A lies relatively that new rectangle
   // (to know whether a collision is happening) 
   // and to its diagonals (to know where the collision is happening):

   String hitFrom(GameObj player)
   {
      for (GameObj platform: platforms)
      {
         // Detect whether the collision between player and platform occurred 
         // from the right, left, top, or bottom
         double w = 0.5 * (player.width + platform.width);
         double h = 0.5 * (player.height + platform.height);
         double dx = player.x - platform.x;
         double dy = player.y - platform.y;

         if ( Math.abs(dx) <= w && Math.abs(dy) <= h )
         {
            // collision has occurred
            double wy = w * dy;
            double hx = h * dx;
            if ( wy > hx )
            {
               if ( wy > -hx )
               {
                  //ct.println("collsion from bottom");
                  return "bottom";
               }
               else
               {
                  ct.println("collsion from right");
                  return "right";
               }
            }
            else
            {
               if ( wy > -hx )
               {
                  ct.println("collision from left");
                  return "left";
               }
               else
               {
                  //ct.println("collison from top");
                  return "top";
               }
            }
         }
      }
      return "";
   }

   public void startJump()
   {
      if ( onGround )
      {
         playerRight.ySpeed = -6.0;
         playerLeft.ySpeed = -6.0;

         playerRight.xSpeed = 1.5;
         playerLeft.xSpeed = 1.5;

         onGround = false;
      }
   }

   public void endJump()
   {
      if ( playerRight.ySpeed < -3.0 || playerLeft.ySpeed < -3.0 )
      {
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
   }


   public void onKeyPress( String keyName )
   {

      if ( keyName.equals("space"))
      {
         startJump();
         ct.sound("retro_jump.wav");
         endJump();
         //isJumping = true;
         //playerRight.ySpeed = doJump(playerRight.ySpeed, ct.getTimer() );

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
         for ( int i = 0; i < clouds.length; i++ )
         {
            clouds[i].xSpeed += 0.001;

         }
      }

   }
}


