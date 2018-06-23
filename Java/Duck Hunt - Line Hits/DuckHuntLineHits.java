// Duck Hunt
// A simple game of shooting rubber ducks.
// Click the mouse anywhere in the app window to make the gun move horizontally to the click
// location and fire straight upwards towards the ducks.

import Code12.*;

public class DuckHuntLineHits extends Code12Program
{
   public static void main( String[] args )
   {
      Code12.run( new DuckHuntLineHits() );
   }

   GameObj gun; // Gun at bottom of window that fires bullets
   GameObj ducksHitDisplay; // Text display for percent of ducks hit
   GameObj accuracyDisplay; // Text display for percent of shots on target
   double yMax; // Maximum y-coordinate of the game window
   int maxSize; // Maximum array size
   GameObj[] bulletsArr; // Array for accessing bullets on screen
   GameObj[] ducksArr; // Array for accessing ducks on screen
   double[] duckYStartsArr; // Array for tracking center of ducks vertical movement
   int bulletsCount; // Count of how many bullets are on the screen
   int bulletsMissed; // Count of how many bullets have gone off screen without hitting a duck
   int ducksCount; // Count of how many ducks are currently on screen
   int ducksHit; // Count of how many ducks have been hit by a bullet
   int ducksMissed; // Count of how many ducks have gone off screen without being hit by a bullet
   double amplitude; // Amplitude of the ducks up and down motion
   double period; // Period of the ducs up and down motion
   GameObj leftWall, topWall; // Lines to test line hits
   boolean paused; // For starting/stopping new duck creation
   boolean turboMode; // For a crazy number of ducks;

   public void start()
   {
      // Set title
      ct.setTitle( "Duck Hunt" );

      // Set background
      ct.setHeight( ct.intDiv( 100 * 9, 16 ) );
      yMax = ct.getHeight();
      ct.setBackImage( "stage.png" );

      // Initialize count variables
      bulletsCount = 0;
      bulletsMissed = 0;
      ducksCount = 0;
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

      // Initialize arrays
      maxSize = 500;
      bulletsArr = new GameObj[10];
      ducksArr = new GameObj[maxSize];
      duckYStartsArr = new double[maxSize];

      // Initialize amplitude and period for ducks' path
      amplitude = 5;
      period = 100;

      // Make walls
      leftWall = ct.line(0, 0, 0, ct.getHeight(), "red");
      topWall = ct.line(0, 0, 100, 0, "red");

      // Start the game unpaused and in normal mode
      paused = false;
      turboMode = false;
   }

   public void update()
   {
//       if ( ct.keyPressed("space") )
//       {
//          paused = !paused;
//          ct.println( "paused = " + paused );
//       }
//       if ( ct.keyPressed("t") )
//       {
//          turboMode = !turboMode;
//          ct.println( "turboMode = " + turboMode );
//       }
      
      // Make ducks at random times and positions
      if (!paused && ct.random(1, 50) == 1)
      {
         int numberOfDucks = (turboMode ? 10 : 1);
         for (int i = 1; i <= numberOfDucks; i++)
         {
            double x = 110;
            double y = ct.random( 10, ct.toInt(yMax / 2) );
            GameObj duck = createDuck( x, y, -1 );
         }
      }

      // If a duck goes off screen, delete it
      // Else make it move up/down on sinusoidal path
      for ( int j = ducksCount - 1; j >= 0; j-- )
      {
         GameObj duck = ducksArr[j];
         double duckYStart = duckYStartsArr[j];
         if ( leftWall.hit(duck) )
         {
            deleteDuck(j);
            ducksMissed++;
            ct.println("duck #" + ducksMissed + " hit left wall");
         }
         else
         {
            //duck.ySpeed = ct.random( -1, 1 ) / 4.0;
            duck.y = duckYStartsArr[j] + amplitude * Math.sin( 2 * Math.PI / period * duck.x );
         }
      }

      // Check for duck-bullet hits and going off screen
      for ( int i = bulletsCount - 1; i >= 0; i-- )
      {
         GameObj bullet = bulletsArr[i];
         // Delete bullet if it has gone off screen
         if ( topWall.hit(bullet) )
         {
            deleteBullet(i);
            bulletsMissed++;
            ct.println("bullet #" + bulletsMissed + " hit top wall");

            // Don't check this bullet hitting ducks
            break;
         }
         // Check for bullet hitting any ducks
         for ( int j = ducksCount - 1; j >= 0; j-- )
         {
            GameObj duck = ducksArr[j];
            if ( bullet.hit(duck) )
            {
               ct.sound("quack.wav");
               makeDeadDuck( duck );

               // Delete bullet and duck
               deleteBullet(i);
               deleteDuck(j);
               ducksHit++;
               // Don't let this bullet affect any more ducks
               break;
            }
         }
      }

      // Update ducksHitDisplay
      int percent = ct.round( 100.0 * ducksHit / (ducksHit + ducksMissed) );
      ducksHitDisplay.setText( "Ducks hit: " + percent + "%" );

      // Update accuracyDisplay
      percent = ct.round( 100.0 * ducksHit / (ducksHit + bulletsMissed) );
      accuracyDisplay.setText( "Shot Accuracy: " + percent + "%" );
   }

   // Makes a bullet at position xStart, yStart that will then
   // move up the window and delete itself once outside the window
   GameObj fireBullet( double xStart, double yStart )
   {
      GameObj bullet = null;
      if ( bulletsCount < maxSize )
      {
         //GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
         bullet = ct.line( xStart, yStart, xStart, yStart + 2, "blue" );
         bullet.lineWidth = 5;
         bullet.ySpeed = -3;
         bulletsArr[bulletsCount] = bullet;
         bulletsCount++;
      }
      else
      {
         ct.println( "Too many bullets on screen." );
      }
      return bullet;
   }

   // Deletes a bullet
   void deleteBullet( int index )
   {
      GameObj bullet = bulletsArr[index];
      bullet.delete();
      for( int i = index; i < bulletsCount - 1; i++ )
      {
         bulletsArr[i] = bulletsArr[i + 1];
      }
      bulletsCount--;
   }

   // Makes a duck to the right of the window at y-coordinate yStart
   // that will then accross the window horizontally with speed xSpeed
   GameObj createDuck( double xStart, double yStart, double xSpeed )
   {
      GameObj duck = null;
      if ( ducksCount < maxSize )
      {
         duck = ct.image( "rubber-duck.png", xStart, yStart, 5 );
         duck.xSpeed = xSpeed;
         ducksArr[ducksCount] = duck;
         duckYStartsArr[ducksCount] = yStart;
         ducksCount++;
      }
      else
      {
         ct.println( "Too many ducks on screen." );
      }

      return duck;
   }

   // Deletes a duck
   void deleteDuck( int index )
   {
      GameObj duck = ducksArr[index];
      duck.delete();
      for( int i = index; i <  ducksCount - 1; i++ )
      {
         ducksArr[i] = ducksArr[i + 1];
         duckYStartsArr[i] = duckYStartsArr[i + 1];

      }
      ducksCount--;
   }

   // Makes a dead duck at duck's position
   GameObj makeDeadDuck( GameObj duck )
   {
      GameObj deadDuck = ct.image( "dead-duck.png", duck.x, duck.y, duck.height );
      deadDuck.autoDelete = true;
      deadDuck.ySpeed = 1;
      return deadDuck;
   }

   // Moves the gun horizontally and fires a bullet when the mouse
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
   
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals("space") )
      {
         paused = !paused;
         ct.println( "paused = " + paused );
      }
      if ( keyName.equals("t") )
      {
         turboMode = !turboMode;
         ct.println( "turboMode = " + turboMode );
      }
   }
}