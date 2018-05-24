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
   LinkedList<Double> duckYStartsList; // List for tracking center of ducks vertical movement
   int bulletsFired; // Count of how many bullets have been fired
   int shotsMissed; // Count of how many shots have been missed
   int ducksMade; // Count of how many ducks have been made
   int ducksHit; // Count of how many ducks have been hit by a bullet
   int ducksMissed; // Count of how many ducks have gone off screen
   double amplitude; // Amplitude of the ducks up and down motion
   double period; // Period of the ducs up and down motion
   
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
            
      // Initialize lists
      bulletsList = new LinkedList<GameObj>();
      ducksList = new LinkedList<GameObj>();
      duckYStartsList = new LinkedList<Double>();
      
      // Initialize amplitude and period
      amplitude = 5;
      period = 50;
   }
   
   public void update()
   {
      // Make ducks at random times and positions
      if (ct.random(1, 50) == 1)
      {
         double x = ct.random( 110, 130 );
         double y = ct.random( 10, (int)(yMax / 2) );
         GameObj duck = createDuck( x, y, -0.5 );
      }
      
      // If a duck goes off screen, delete it
      // Else make it go up or down randomly
      for ( int j = ducksList.size() - 1; j >= 0; j-- )
      {
         GameObj duck = ducksList.get(j);
         double duckYStart = duckYStartsList.get(j);
         if ( duck.x < 0 )
         {
            deleteDuck(j);
            ducksMissed++;
            ct.println( "ducksMissed = " + ducksMissed );
         }
         else
         {
            //duck.ySpeed = ct.random( -1, 1 ) / 4.0;
            duck.y = duckYStartsList.get(j) + amplitude * Math.sin( 2 * Math.PI / period * duck.x );
         }
      }
      
      // Check for duck-bullet hits and going off screen
      for ( int i = bulletsList.size() - 1; i >= 0; i-- )
      {
         GameObj bullet = bulletsList.get(i);
         // Delete bullet if it has gone off screen
         if ( bullet.y < 0 )
         {
            deleteBullet(i);
            shotsMissed++;
            ct.println( "shotsMissed = " + shotsMissed );
            // Don't check this bullet hitting ducks
            break;
         }
         // Check for bullet hitting any ducks
         for ( int j = ducksList.size() - 1; j >= 0; j-- )
         {
            GameObj duck = ducksList.get(j);
            // If bullet hits duck, delete both
            if ( bullet.hit(duck) )
            {
               ct.sound("quack.wav");
               deleteBullet(i);
               deleteDuck(j);
               ducksHit++;
               ct.println( "ducksHit = " + ducksHit );
               // Don't let this bullet affect any more ducks
               break;
            }
         }
      }
   }
   
   // Makes a bullet at position xStart, yStart that will then
   // move up the window and delete itself once outside the window
   public GameObj fireBullet( double xStart, double yStart )
   {
      GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
      bullet.ySpeed = -2;
      bulletsList.add(bullet);
      bulletsFired++;
      return bullet;
   }
   
   // Deletes a bullet and its list data
   public void deleteBullet( int i )
   {
      bulletsList.get(i).delete();
      bulletsList.remove(i);
   }
   
   // Makes a duck to the right of the window at y-coordinate yStart
   // that will then accross the window horizontally with speed xSpeed
   public GameObj createDuck( double xStart, double yStart, double xSpeed )
   {
      GameObj duck = ct.image( "rubber-duck.png", xStart, yStart, 5 );
      duck.xSpeed = xSpeed;
      ducksList.add(duck);
      duckYStartsList.add(yStart);
      ducksMade++;
      return duck;
   }
   
   // Deletes a duck and its list data
   public void deleteDuck( int i )
   {
      ducksList.get(i).delete();
      ducksList.remove(i);
      duckYStartsList.remove(i);
   }
   
   // Moves the gun horizontally and first a bullet when the mouse
   // is clicked
   public void onMousePress( GameObj obj, double x, double y )
   {
      // Move the gun horizontally to match the click location
      gun.x = x;
      
      // Fire a new bullet
      double xStart = gun.x;
      double yStart = gun.y - gun.height / 2 * 0.9;
      fireBullet( xStart, yStart );
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