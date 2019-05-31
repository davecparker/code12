// White box test of screen management APIs

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

class ScreenManagementWhiteBoxTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new ScreenManagementWhiteBoxTest()); 
   }
   // On/Off controls for tests ---------------------------------------
   boolean setTitleTestOn = false;
   boolean getHeightGetWidthTestOn = false;
   boolean setScreenTestOn = false;
   boolean clearGroupTestOn = false;
   boolean setBackColorTestOn = false;
   boolean setBackColorRGBTestOn = false;
   boolean setBackImageTestOn = true;

   String[] colorNames = { "foo",
                           "red", 
                           "green", 
                           "blue", 
                           "cyan", 
                           "magenta", 
                           "yellow",
                           "orange", 
                           "pink", 
                           "purple",
                           "black", 
                           "white",
                           "gray",  
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
   GameObj widthText, heightText, hampsterImg, screenText;
   int startTime, colorIndex;
   boolean paused = false;
   int setTitleTestNumber = 1;
   int currentScreenIndex = 0;
   String[] screenNames = { "", "oops\n", null };
   int[] invalidRGBs = { -1, 256, -1000, 1000 };

   // Start & Update---------------------------------------------------
	public void start()
	{  
      screenText = ct.text( "", 50, 0, 5 );
      screenText.align( "top" );

      initGetWidthGetHeightTest();

      if ( setScreenTestOn )
         initSetScreenTest();

      if ( clearGroupTestOn )
         initClearGroupTest();     
         
      if ( setBackColorTestOn )
         initSetBackColorTest();

      if ( setBackColorRGBTestOn )
         runSetBackColorRGBTest();      
      
      if ( setBackImageTestOn )
         runSetBackImageTest();   
   }
   
   public void update()
   {  
      if ( !paused )
      {
         if ( setTitleTestOn )
            runSetTitleTest();
            
         if ( setBackColorTestOn )
            runSetBackColorTest(); 
      }
   }
   
   // Event Listeners ---------------------------------------------------
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals("space") )
         paused = !paused;
      else if ( keyName.equals("h") )
         runSetHeightTest();
      else if ( setScreenTestOn && keyName.equals("s") )
         runSetScreenTest();

   }
   
   public void onResize()
   {
      if ( getHeightGetWidthTestOn )
         runGetWidthGetHeightTest();
   }

   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( clearGroupTestOn && obj != null )
      {
         String group = obj.group;
         ct.clearGroup( group );
         ct.println( "ct.clearGroup("+group+")" );
      }

   }

   // Tests --------------------------------------------------------------
   public void runSetTitleTest()
   {
      if ( setTitleTestNumber == 1 )
      {
         // Test null title
   		ct.setTitle( null );
         ct.println( "ct.setTitle( null )" );
         ct.println( "Press spacebar to continue" );
         setTitleTestNumber++;
         paused = true;
      }
      else if ( setTitleTestNumber == 2 )
      {
         // Test title with newlines
         ct.setTitle( "Title with newline\nSecond line of Title\nThird line of title" );
         ct.println( "ct.setTitle( \"Title with newline\\nSecond line of Title\\nThird line of title\" )" );
         ct.println( "Press spacebar to continue" );
         setTitleTestNumber++;
         paused = true;
      }
      else if ( setTitleTestNumber == 3 )
      {
   		// Test title longer than window width
   		String tooLongTitle = "Too long title";
   		for ( int i = 0; i < 100; i++ )
   		{
   			tooLongTitle += "e";
   		}
         ct.setTitle( tooLongTitle );
         ct.println( "ct.setTitle( "+tooLongTitle+" )" );
         ct.println( "End of ct.setTitle() test" );
         setTitleTestNumber++;
         paused = true;
      }
   }

   public void runSetHeightTest()
   {
         // ct.setHeight( 1.0/0 );
         // ct.setHeight( -1.0/0 );
         // ct.setHeight( 0.0/0 );
         // ct.setHeight( Double.MIN_VALUE );
         // ct.setHeight( Double.MAX_VALUE );
         // ct.setHeight( Math.PI );

         double height = ct.inputNumber( "Enter height: ");
         ct.setHeight( height );
         ct.println( "ct.setHeight("+height+") executed" );
         ct.println( "ct.getHeight() = "+ct.getHeight() );
   }

   public void initGetWidthGetHeightTest()
   {
      double x, y, textHeight;

      textHeight = 5;
      
      x = 100;
      y = 50;
      widthText = ct.text( "", x, y, textHeight );
      widthText.align( "right", true );

      x = 50;
      y = 100;
      heightText = ct.text( "", x, y, textHeight );
      heightText.align( "bottom", true );
   }

   public void runGetWidthGetHeightTest()
   {
      widthText.setText( "ct.getWidth() = "+ct.getWidth() );
      heightText.setText( "ct.getHeight() = "+ct.getHeight() );
   }


   public void initSetScreenTest()
   {
      ct.println("screenNames.length = " + screenNames.length);
      for ( int i = 0; i < screenNames.length; i++ )
      {
         String screenName = screenNames[i];
         ct.setScreen( screenName );
         ct.setBackColor(colorNames[i]);

         String textToDisplay = "screen name = ";
         if ( screenName == null )
         {
            textToDisplay += "null";
         }
         else if ( screenName.equals( "" ) )
         {
            textToDisplay += "empty string";
         }
         else if ( screenName.equals( "oops\n") )
         {
            textToDisplay += "oops\\n";
         }
         screenText.setText( textToDisplay );
      }
     
      ct.println( "intSetScreenTest() done" );
      currentScreenIndex = screenNames.length - 1;
   }

   public void runSetScreenTest()
   {
      currentScreenIndex = (currentScreenIndex + 1) % screenNames.length;
      ct.setScreen( screenNames[currentScreenIndex] );
   }

   public void initClearGroupTest()
   {
      for ( int i = 10; i < 100; i += 20 )
      {
         GameObj circle = ct.circle( i, 25, 20 );
         circle.group = "circle";
         circle.clickable = true;
      }

      for ( int i = 10; i < 100; i += 20 )
      {
         GameObj rect = ct.rect( i, 75, 20, 20 );
         rect.group = null;
         rect.clickable = true;
      }
   }

   public void initSetBackColorTest()
   {
      ct.setBackColor( null );
      screenText.setText( "ct.setBackColor( null )" );
      hampsterImg = ct.image( "hampster.png", 0, 50, 20 );
      hampsterImg.xSpeed = 1;

      // startTime = ct.getTimer(); // Gives system time when called in start?
      // ct.println( startTime + "" );
      startTime = 0;

      colorIndex = 0;
   }

   public void runSetBackColorTest()
   {
      if  (hampsterImg.x > 100 + hampsterImg.width / 2 )
      {
         hampsterImg.x = -hampsterImg.width / 2;
      }

      int newTime = ct.getTimer();
      if ( newTime - startTime > 1000 )
      {
         String color = colorNames[colorIndex];

         if ( color.equals("black") )
            screenText.setFillColor( "white" );
         else if ( color.equals("white") )
            screenText.setFillColor( "black" );

         int middleIndex = color.length() / 2;
         color = color.substring(0, middleIndex).toUpperCase() + color.substring(middleIndex);

         ct.setBackColor( color );
         screenText.setText( "ct.setBackColor( "+color+" )" );

         startTime = newTime;
         colorIndex = ( colorIndex + 1 ) % colorNames.length;
      }
   }

   public void runSetBackColorRGBTest()
   {
      screenText.setFillColor( "orange" );

      for( int i = 0; i < invalidRGBs.length; i++ )
      {
         String text = "ct.setBackColor("+i+","+i+","+i+")";
         try {
            ct.setBackColorRGB( i, i, i );
            screenText.setText( text );
         } catch (Exception e) {
            ct.println( text );
            e.printStackTrace();
         }
      }
   }

   public void testSetBackImage( String filename )
   {
      String text = "ct.setBackImg("+filename+")";
      try {
         ct.setBackImage( filename );
         screenText.setText( text );
      } catch (Exception e) {
         ct.println( text );
         e.printStackTrace();
      }
   }

   public void runSetBackImageTest()
   {
      testSetBackImage( null );
      testSetBackImage( "no file with this name" );
   }
}

