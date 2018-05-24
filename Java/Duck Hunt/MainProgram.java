import Code12.*;
import java.util.*;

public class MainProgram extends Code12Program
{
   public static void main( String[] args )
   { 
      Code12.run( new MainProgram() ); 
   }
   
   GameObj gun; // Gun at bottom of window that fires bullets
   GameObj ducksHitDisplay; // Text display for percent of ducks hit
   GameObj accuracyDisplay; // Text display for percent of shots on target   
   double yMax; // Maximum y-coordinate of the game window
   LinkedList<GameObj> bulletsList; // List for accessing bullets on screen
   LinkedList<GameObj> ducksList; // List for accessing ducks on screen
   LinkedList<Double> duckYStartsList; // List for tracking center of ducks vertical movement
   int shotsFired; // Count of how many bullets have been fired
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
                
      // Initialize count variables
      shotsFired = 0;
      shotsMissed = 0;
      ducksMade = 0;
      ducksHit = 0;
      ducksMissed = 0;
      
      // Make ducksHitDisplay
      double scoreHeight = 5;
      String scoreColor = "dark majenta";
      ducksHitDisplay = ct.text( "Ducks hit: ", 0, yMax, scoreHeight, scoreColor );
      ducksHitDisplay.align( "bottom left", true );
      
      // Make accuracyDisplay
      accuracyDisplay = ct.text( "Shot Accuracy: ", 100, yMax, scoreHeight, scoreColor );
      accuracyDisplay.align( "bottom right", true );
      
      // Make gun
      gun = ct.image( "gun.png", 50, yMax - scoreHeight, 8 );
      gun.align( "bottom", true );
            
      // Initialize lists
      bulletsList = new LinkedList<GameObj>();
      ducksList = new LinkedList<GameObj>();
      duckYStartsList = new LinkedList<Double>();
      
      // Initialize amplitude and period
      amplitude = 5;
      period = 100;
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
               // Don't let this bullet affect any more ducks
               break;
            }
         }
      }
      
      // update ducksHitDisplay
      int percent = ct.round( 100.0 * ducksHit / (ducksHit + ducksMissed) );
      ducksHitDisplay.setText( "Ducks hit: " + percent + "%" );
      
      // Make accuracyDisplay
      percent = ct.round( 100.0 * ducksHit / shotsFired );
      accuracyDisplay.setText( "Shot Accuracy: " + percent + "%" );
   }
   
   // Makes a bullet at position xStart, yStart that will then
   // move up the window and delete itself once outside the window
   public GameObj fireBullet( double xStart, double yStart )
   {
      //GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
      GameObj bullet = ct.rect( xStart, yStart, 0.5, 2, "blue" );
      bullet.ySpeed = -2;
      bulletsList.add(bullet);
      shotsFired++;
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
      // Play squirt sound
      ct.sound( "squirt.wav" );
      
      // Move the gun horizontally to match the click location
      gun.x = x;
      
      // Fire a new bullet
      double xStart = gun.x;
      double yStart = gun.y - gun.height * 0.9;
      fireBullet( xStart, yStart );
   }
   
   // Sets an objects height to height and changes its width to preserve
   // its original aspect ratio
   public void setHeight( GameObj obj, double height )
   {
      double aspectRatio = obj.width / obj.height;
      obj.height = height;
      obj.width = height * aspectRatio;
   }
}