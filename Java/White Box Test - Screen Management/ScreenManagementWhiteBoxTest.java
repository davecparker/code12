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

class ScreenManagementTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new ScreenManagementTest()); 
   }
   
   boolean allTestsPassed = true;

   String[] colorNames = { "black", 
                           "white", 
                           "red", 
                           "green", 
                           "blue", 
                           "cyan", 
                           "majenta", 
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
                           "light majenta",
                           "light yellow",
                           "dark gray",
                           "dark red",
                           "dark green",
                           "dark blue",
                           "dark cyan",
                           "dark majenta",
                           "dark yellow" };

	public void start()
	{
		runTests_setTitle( true );
		runTests_setHeight( true );
	}

   public void update()
   {  

   }
   
   public void onKeyPress( String keyName )
   {

   }
   
   public void onResize()
   {

   }

   public void runTests_setTitle( boolean run )
   {
		if ( run )
		{
	   	// Test null title
			ct.setTitle( null );

			// Test ASCII table
			for ( int i = 0; i <= 127; i++ )
			{
				ct.setTitle( ""+(char)i );
			}

			// Test title with newlines
			ct.setTitle( "Title with newline \n Second line of Title \n Third line of title" );

			// Test title longer than window width
			String tooLongString = "";
			for ( int i = 0; i < 100; i++ )
			{
				tooLongString += "A";
			}
			ct.setTitle( tooLongString );
		}

   }
}
