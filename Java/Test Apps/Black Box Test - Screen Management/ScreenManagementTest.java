// Black box test of screen management APIs

// Screen Management
// -----------------
// ct.setTitle( String title )
// ct.setHeight( double height )   // on mobile just determines landscape vs. portrait
// double ct.getWidth( )           // always 100.0
// double ct.getHeight( )          // default 100.0
// double ct.getPixelsPerUnit()    // scale factor to convert coordinate units to pixels
// String ct.getScreen( )
// ct.setScreen( String name )
// ct.clearScreen( )
// ct.clearGroup( String group )
// ct.setBackColor( String color )
// ct.setBackColorRGB( int r, int g, int b )
// ct.setBackImage( String filename )

import Code12.*;

class ScreenManagementTest extends Code12Program
{ 
   boolean paused; // if true a call to update() does nothing
   GameObj displayText; // ct.text() obj for displaying variable values and function 
                        // return values
   int displayTextPixels; // height of the displayText in pixels
   GameObj cornerBox; // ct.rect() for testing ct.getHeight() and ct.getWidth(), should
                      // stay in bottom right corner as window resizes
   int cornerBoxPixels; // height and width of the corner box in pixels
   int updateCount; // count of how many times update() has been called while not paused
   int colorsCount; // count of how many named colors have been used in ct.setBackColor()
   int pngBackgroundCount; // how many png background images have been tested
   int jpgBackgroundCount; // how many jpg background images have been tested
   int pngBackgroundTotal; // how many png backgrounds there are in the program folder
   int jpgBackgroundTotal; // how many jpg backgrounds there are in the program folder
   String[] colorNames = { "black", 
                           "white", 
                           "red", 
                           "green", 
                           "blue", 
                           "cyan", 
                           "magenta", 
                           "yellow", 
                           "gray", 
                           "orange", 
                           "pink", 
                           "purple", 
                           "light gray", 
                           "light red", 
                           "light green", 
                           "light blue", 
                           "light cyan", 
                           "light magenta",
                           "light yellow",
                           "dark gray",
                           "dark red",
                           "dark green",
                           "dark blue",
                           "dark cyan",
                           "dark magenta",
                           "dark yellow" };

   public void start()
   {  
      paused = false;
      updateCount = 0;
      colorsCount = 0;
      pngBackgroundCount = 1;
      pngBackgroundTotal = 5;
      jpgBackgroundCount = 1;
      jpgBackgroundTotal = 5;
      
      // Screen2 for testing clearScreen() and clearGroup()
      ct.setScreen( "2" );
      ct.setTitle( "clearGroup() and clearScreen() Test" );
      ct.setBackImage( "background1.jpg" );
                  
      // Screen1 for testing other screen management APIs
      ct.setScreen( "1" );      
      displayText = ct.text( "", 0, 0, 6 );
      displayText.align( "bottom left" ); 
      displayText.setLayer( 2 );
      
      cornerBox = ct.rect( 100, 0, 10, 10 );
      cornerBox.align( "bottom right" );
      
      double pixelsPerUnit = ct.getPixelsPerUnit();
      displayTextPixels = ct.round( displayText.getHeight() * pixelsPerUnit );
      cornerBoxPixels = ct.round( cornerBox.getHeight() * pixelsPerUnit );
   }
   
   public void update()
   {  
      String screen = ct.getScreen();
      
      if ( screen.equals("1") )
      {
         if ( !paused )
         {
            updateCount++;
            ct.setTitle( "updateCount=" + updateCount );
               
            if ( updateCount < 151 )
            {
               ct.setHeight( updateCount );
               displayText.setText( "ct.getHeight() = " + ct.getHeight() + ", ct.getWidth() = " + ct.getWidth() );
               displayText.y = ct.getHeight();
               cornerBox.y = ct.getHeight();
            }
            else if ( updateCount < 151 + 256 )
            {
               if ( updateCount == 151 )
               {
                  displayText.align( "top left" );
                  displayText.y = 0;
                  displayText.setFillColor( "white" );
               }
               int r = updateCount - 151;
               ct.setBackColorRGB( r, 0, 0 );
               displayText.setText( "ct.setBackColorRGB( " + r + ", 0, 0 )" ); 
            }
            else if ( updateCount < 407 + 256 )
            {
               int g = updateCount - 407;
               ct.setBackColorRGB( 0, g, 0 );
               displayText.setText( "ct.setBackColorRGB( 0, " + g + ", 0 )" );          
            }
            else if ( updateCount < 663 + 256 )
            {
               int b = updateCount - 663;
               ct.setBackColorRGB( 0, 0, b );
               displayText.setText( "ct.setBackColorRGB( 0, 0, " + b + " )" ); 
            }
            else if ( updateCount < 919 + 256 )
            {
               if ( updateCount == 919 )
               {
                  displayText.setFillColor( "red" );
               }
               int x = updateCount - 919;
               ct.setBackColorRGB( x, x, x );
               displayText.setText( "ct.setBackColorRGB( " + x + ", " + x + ", " + x + " )" ); 
            }
            else if ( (updateCount - 1775) % 60 == 0 && colorsCount < colorNames.length )
            {
               String colorName = colorNames[colorsCount];
               ct.setBackColor( colorName );
               displayText.setText( "ct.setBackColor( " + colorName + " )" );
               if ( colorName.equals("red") )
               {
                  displayText.setFillColor( "black" );
               }
               colorsCount++;
            }
            else if ( (updateCount - 2735) % 60 == 0 && pngBackgroundCount <= pngBackgroundTotal )
            {
               String backgroundFile = "background" + pngBackgroundCount + ".png";
               ct.setBackImage( backgroundFile );
               displayText.setText( "ct.setBackImage( " + backgroundFile + " )" );
               pngBackgroundCount++;
            }
            else if ( (updateCount - 3035) % 60 == 0 && jpgBackgroundCount <= jpgBackgroundTotal )
            {
               String backgroundFile = "background" + jpgBackgroundCount + ".jpg";
               ct.setBackImage( backgroundFile );
               displayText.setText( "ct.setBackImage( " + backgroundFile + " )" );
               jpgBackgroundCount++;
            }
         }
      }
      else if ( screen.equals("2") )
      {  
         if ( !paused && ct.random(1, 20) == 1 )
         {
            // Make a shape or image on the screen in a random spot
            int shapeNum = ct.random( 1, 4 );
            double x = ct.random( 0, (int)(ct.getWidth()) );
            double y = ct.random( 0, (int)(ct.getHeight()) );
            GameObj shape;
            if ( shapeNum == 1 )
            {
               shape = ct.rect( x, y, 10, 10 );
               shape.group = "squares";
            }
            else if ( shapeNum == 2 )
            {
               shape = ct.circle( x, y, 10 );
               shape.group = "circles";
            }
            else if ( shapeNum == 3 )
            {
               shape = ct.line( x, y, x + 10, y + 10 );
               shape.setLineWidth( 3 );
               shape.group = "lines";
            }
            else
            {
               shape = ct.image( "hampster.png", x, y, 10 );
               shape.group = "images";
            }
         }
      }
   }
   
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals("space") || keyName.equals("p") )
      {
         paused = !paused;
      }
      else if ( keyName.equals("1") )
      {
         ct.setScreen( "1" );
      }
      else if ( keyName.equals("2") )
      {
         ct.setScreen( "2" );
      }
      else if ( keyName.equals("s") )
      {
         ct.clearGroup( "squares" );
      }
      else if ( keyName.equals("c") )
      {
         ct.clearGroup( "circles" );
      }
      else if ( keyName.equals("l") )
      {
         ct.clearGroup( "lines" );
      }
      else if ( keyName.equals("i") )
      {
         ct.clearGroup( "images" );
      }
      else if ( keyName.equals("a") )
      {
         ct.clearScreen();
      }
   }
   
   public void onResize()
   {
      double pixelsPerUnit = ct.getPixelsPerUnit();
      double size = cornerBoxPixels / pixelsPerUnit;
      if ( cornerBox != null )
      {
         cornerBox.setSize( size, size );
         cornerBox.x = ct.getWidth();
         cornerBox.y = ct.getHeight();
      }
      if ( displayText != null )
         displayText.setSize( displayText.getWidth(), displayTextPixels / pixelsPerUnit );
   }

   public static void main(String[] args)
   {
      Code12.run(new ScreenManagementTest()); 
   }
}
