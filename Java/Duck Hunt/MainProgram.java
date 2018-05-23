import Code12.*;
import java.util.*;

public class MainProgram extends Code12Program
{
   public static void main( String[] args )
   { 
      Code12.run( new MainProgram() ); 
   }
   
   GameObj gun; // Gun at bottom of window that fires bullets
   double yMax; // Maximum y-coordinate of the game window
   LinkedList<GameObj> bulletsList; // List for accessing bullets on screen
   LinkedList<GameObj> ducksList; // List for accessing ducks on screen
   int bulletsFired;
   int shotsMissed;
   int ducksMade;
   int ducksHit;
   int ducksMissed;
      
   public void start()
   {
      // Set title
      ct.setTitle( "Duck Hunt" );
      
      // Set background
      ct.setHeight( 100 * 9 / 16 );
      yMax = ct.getHeight();
      ct.setBackImage( "stage.png" );
      
      // Make gun
      gun = ct.image( "gun.png", 50, 0, 8 );
      setGunSizeAndPosition();
      
      // Initialize count variables
      bulletsFired = 0;
      shotsMissed = 0;
      ducksHit = 0;
      ducksMissed = 0;
      
      // Initialize GameObj lists
      bulletsList = new LinkedList<GameObj>();
      ducksList = new LinkedList<GameObj>();
   }
   
   public void update()
   {
      // Make ducks at random times and positions
      if (ct.random(1, 50) == 1)
      {
         double x = 110;
         double y = ct.random( 10, (int)(yMax / 2) );
         GameObj duck = createDuck( x, y, -0.5 );
         ducksMade++;
      }
      
      // Check for duck-bullet hits and going off screen
      for (int i = bulletsList.size() - 1; i >= 0; i--)
      {
         GameObj bullet = bulletsList.get(i);
         // Delete bullet if it has gone off screen
         if ( bullet.y < 0 )
         {
            bulletsList.remove(i);
            bullet.delete();
            shotsMissed++;
            ct.println("shotsMissed = " + shotsMissed );
            // Don't let this bullet affect any ducks
            break;
         }
         for (int j = ducksList.size() - 1; j >= 0; j--)
         {
            
            GameObj duck = ducksList.get(j);
            
            // If bullet hits duck, delete both
            if ( bullet.hit( duck ) )
            {
               bulletsList.remove(i);
               bullet.delete();
               ducksList.remove(j);
               duck.delete();
               ducksHit++;
               ct.println("ducksHit = " + ducksHit );
               // Don't let this bullet affect any more ducks
               break;
            }
            // If duck goes off screen, delete it
            else if ( duck.x < 0 )
            {
               ducksList.remove(j);
               duck.delete();
               ducksMissed++;
               ct.println("ducksMissed = " + ducksMissed );
            }
         }
      }
   }
   
   // Makes a bullet at position xStart, yStart that will then
   // move up the window and delete itself once outside the window
   public GameObj createBullet( double xStart, double yStart )
   {
      GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
      bullet.ySpeed = -2;
      bulletsList.add( bullet );
      return bullet;
   }
   
   // Makes a duck to the right of the window at y-coordinate yStart
   // that will then accross the window horizontally with speed xSpeed
   public GameObj createDuck( double xStart, double yStart, double xSpeed )
   {
      GameObj duck = ct.image( "rubber-duck.png", xStart, yStart, 5 );
      duck.xSpeed = xSpeed;
      ducksList.add( duck );
      return duck;
   }
   
   // Moves the gun horizontally and first a bullet when the mouse
   // is clicked
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Move the gun horizontally to match the click location
      gun.x = x;
      
      // Fire a new bullet
      double xStart = gun.x;
      double yStart = gun.y - gun.height / 2 * 0.9;
      createBullet( xStart, yStart );
      bulletsFired++;
      ct.println("bulletsFired = " + bulletsFired);
   }
   
   // Sets an objects height to height and changes its width to preserve
   // its original aspect ratio
   public void setHeight( GameObj obj, double height )
   {
      double aspectRatio = obj.width / obj.height;
      obj.height = height;
      obj.width = height * aspectRatio;
   }
   
   // Scales the gun so that it's height is 25% of the window height
   // and sets it's position to the bottom of the window
   public void setGunSizeAndPosition()
   {
      setHeight( gun, yMax * 0.25 );
      gun.y = yMax - gun.height / 2;
   }
   
   // Updates yMax and image positions when the window is resized.
   public void onResize()
   {
      yMax = ct.getHeight();
      setGunSizeAndPosition();
   }
}