// Random Walk
// Code12 Programming Concepts 9: Function Definitions

// An animation of a random walk.
// Resizing the window restarts the random walk with a larger lattice.

// Case use test for the following subset of the Code12 API:

// Screen Management
// -----------------
// ct.setTitle( String title )
// double ct.getWidth( )           // always 100.0
// double ct.getHeight( )          // default 100.0
// double ct.getPixelsPerUnit()    // scale factor to convert coordinate units to pixels
// ct.clearScreen( )
// ct.setBackColor( String color )

// Math and Misc.
// --------------
// int ct.random( int min, int max )
// int ct.round( double d )
// double ct.round( double d, int numPlaces )
// boolean ct.isError( double d )

// Type Conversion
// ---------------
// int ct.toInt( double d )                // truncates

import Code12.*;

class RandomWalk extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new RandomWalk()); 
   }
   // TODO: fields where initialized in restart(); causes Code12 runtime to see them as unitialized before use
   int pixelsPerSquare = 0; // Dimension of the lattice grid
   double xMax = 0.0; // Maximum x coordinate of the window
   double yMax = 0.0; // Maximum y coordinate of the window
   double pixelsPerUnit = 0.0; // Pixels per coordinate unit
   double unitsPerSquare = 0.0; // Coordinate units per lattice grid square
   GameObj marker = null; // Circle used to mark the random walk
   int rowCount = 0; // Number of horizontal lines in the lattice
   int columnCount = 0; // Number of vertical lines in the lattice
   
   public void start()
   {  
      restart();  
   }
   
   public void update()
   {
      // Choose a random direction
      String direction; // "up", "down", "left", "right"
      int column = ct.toInt( marker.x / unitsPerSquare + 0.5 );
      int row = ct.toInt( marker.y / unitsPerSquare + 0.5 );
      
      if ( row == 1 && column == 1)
      {
         // Marker is in top left corner, can move down or right
         int n = ct.random(1, 2);
         if ( n == 1 )
            direction = "down";
         else
            direction = "right";
      }
      else if ( row == 1 && column == columnCount )
      {
         // Marker is in top right corner, can move down or left
         int n = ct.random(1, 2);
         if ( n == 1 )
            direction = "down";
         else
            direction = "left";
      }
      else if ( row == rowCount && column == 1 )
      {
         // Marker is in bottom left corner, can move up or right
         int n = ct.random(1, 2);
         if ( n == 1 )
            direction = "up";
         else
            direction = "right";
      }
      else if ( row == rowCount && column == columnCount )
      {
         // Marker is in bottom right corner, can move up or left
         int n = ct.random(1, 2);
         if ( n == 1 )
            direction = "up";
         else
            direction = "left";
      }
      else if ( row == 1 )
      {
         // Marker is at top of screen (not in a corner), can move down, left, right
         int n = ct.random(1, 3);
         if ( n == 1 )
            direction = "down";
         else if ( n == 2 )
            direction = "left";
         else
            direction = "right";
      }
      else if ( row == rowCount )
      {
         // Marker is at bottom of screen (not in a corner), can move up, left, right
         int n = ct.random(1, 3);
         if ( n == 1 )
            direction = "up";
         else if ( n == 2 )
            direction = "left";
         else
            direction = "right";
      }
      else if ( column == 1 )
      {
         // Marker is at left side of screen (not in a corner), can move up, down, right
         int n = ct.random(1, 3);
         if ( n == 1 )
            direction = "up";
         else if ( n == 2 )
            direction = "down";
         else
            direction = "right";
      }
      else if ( column == columnCount )
      {
         // Marker is at right side of screen (not in a corner), can move up, down, left
         int n = ct.random(1, 3);
         if ( n == 1 )
            direction = "up";
         else if ( n == 2 )
            direction = "down";
         else
            direction = "left";
      }
      else
      {
         // Marker can move in any direction.
         int n = ct.random(1, 4);
         if ( n == 1 )
            direction = "up";
         else if ( n == 2 )
            direction = "down";
         else if ( n == 3 )
            direction = "left";
         else
            direction = "right";
      }
            
      // Make marker path line
      double newX, newY;
      if ( direction.equals( "up" ) )
      {
         newX = marker.x;
         newY = marker.y - unitsPerSquare;
      }
      else if ( direction.equals("down") )
      {
         newX = marker.x;
         newY = marker.y + unitsPerSquare;
      }
      else if ( direction.equals("left") )
      {
         newX = marker.x - unitsPerSquare;
         newY = marker.y;
      }
      else // direction.equals("right")
      {
         newX = marker.x + unitsPerSquare;
         newY = marker.y;
      }
      GameObj pathLine = ct.line( marker.x, marker.y, newX, newY, "red" );
      int lineWidth = ct.round( pixelsPerSquare / 3.0 );
      if ( lineWidth > 0 )
         pathLine.lineWidth = lineWidth;
      
      // Move marker
      marker.x = newX;
      marker.y = newY;
   }
   
   public void onResize()
   {
      // Clear the screen
      ct.clearScreen();
      
      // Restart the random walk
      restart();
   }

   public void restart()
   {
   	// Set the title
      ct.setTitle( "Random Walk" );
      
      // Initialize size variables
      pixelsPerSquare = 8;
      
      // Set background
      ct.setBackColor( "light yellow" );

      // Set the lattice variables
      xMax = ct.getWidth();
      yMax = ct.getHeight();
      pixelsPerUnit = ct.getPixelsPerUnit();
      unitsPerSquare = pixelsPerSquare / pixelsPerUnit;
      rowCount = ct.toInt( yMax / unitsPerSquare );
      columnCount = ct.toInt( xMax / unitsPerSquare );
      
      // Draw horizontal lines
      for ( int i = 0; i < rowCount; i++ )
      {
         double y = (i + 0.5) * unitsPerSquare;
         ct.line(0, y, xMax, y);
      } 
      // Draw vertical lines
      for ( int i = 0; i < columnCount; i++ )
      {
         double x = (i + 0.5) * unitsPerSquare;
         ct.line(x, 0, x, yMax);
      } 
      
      // Make the walk marker
      double x = ( ct.random(1, columnCount) - 0.5 ) * unitsPerSquare;
      double y = ( ct.random(1, rowCount) - 0.5 ) * unitsPerSquare;

      marker = ct.circle( x, y, unitsPerSquare );
      
      // Make the start marker
      GameObj startMarker = ct.circle( marker.x, marker.y, unitsPerSquare, "green" );
   }
}
