// White Box test of Math, Misc, and Type Conversion APIs

// Math and Misc.
// --------------
// int ct.random( int min, int max )
// int ct.round( double d )
// double ct.round( double d, int numPlaces )
// boolean ct.isError( double d )
// double ct.distance( double x1, double y1, double x2, double y2 )
// int ct.getTimer( )
// double getVersion( )

// Type Conversion
// ---------------
// int ct.toInt( double d )                // truncates
// int ct.parseInt( String s )             // 0 if failure
// boolean ct.canParseInt( String s )
// double ct.parseNumber( String s )       // NaN if failure
// boolean ct.canParseNumber( String s )
// String ct.formatDecimal( double d )
// String ct.formatDecimal( double d, int numPlaces )
// String ct.formatInt( int i )
// String ct.formatInt( int i, int numDigits )    // uses leading 0's

import Code12.*;
import java.io.PrintWriter;

class MathMiscTypeConversionWhiteBoxTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MathMiscTypeConversionWhiteBoxTest()); 
   }

   final double EPSILON = 0.0000001; // doubles differing by this or less will test equal
   final double VERSION = 0.5; // Code12 Runtime Version

   boolean allTestsPassed = true;

   PrintWriter writer;
   GameObj timerDisplay;
   long startTimeMs;
   GameObj countDownDisplay;
   int countDownSec;
   
   public void start()
   {  
      try
      {
         writer = new PrintWriter( "output.txt" );
         ct.println( "Tests started" );
         
         runTests_random( true );
         runTests_round( true );
         runTests_intDiv( true );
			runTests_isError( true );
         runTests_distance( true );
         runTests_getVersion( true );
         runTests_toInt( true );
         runTests_parseInt( true );
         runTests_canParseInt( true );
         runTests_parseNumber( true );
         runTests_canParseNumber( true );
         runTests_formatDecimal( true );
         runTests_formatInt( true );
                  
         ct.println( "Tests finished" );
         
         if ( allTestsPassed )
         {
            print( "All tests passed" );
         }
         writer.close(); 
      }
      catch(Exception e)
      {
         ct.println( "Error writing to output.txt" );
         e.printStackTrace();
      }
      
      initTests_getTimer( true );
   }
   
   public void update()
   {  
      runTests_getTimer( true );
   }
   
   
   // Utility functions 
   // -------------------------------------------------------------
   
   public void print( String line )
   {
      writer.println( line );
      ct.println( line );
   }
   
   public void printError( String error )
   {
      allTestsPassed = false;
      print( error );
   }
   
   public void testRandom( int min, int max )
   {
   	try
      {
      	int output = ct.random( min, max );
      	if ( output < min || output > max )
   		{
   			printError( "ct.random(" + min + "," + max + ") = " + output );
   		}
      }
      catch( Exception e )
      {
      	printError( "ct.random(" + min + "," + max + ") throws " + e.toString() );
     	}
   }

   public void testRound( double d, int expected )
   {
      int output = ct.round(d);
      if ( output != expected )
         printError( "ct.round(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testRound( double d, int numPlaces, double expected )
   {
      double output = ct.round(d, numPlaces);
      if ( Math.abs(output - expected) > EPSILON )
         printError( "ct.round(" + d + ", " + numPlaces + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testIntDiv( int n, int d, int expected )
   {
      int output = ct.intDiv( n, d );
      if ( output != expected )
         printError( "ct.round(" + n + "/" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testIsError( double d, boolean expected )
   {
   	boolean output = ct.isError( d );
      if ( output != expected )
         printError( "ct.isError(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testDistance( double x1, double y1, double x2, double y2, double expected )
   {
      double output = ct.distance( x1, y1, x2, y2 );
      if ( Math.abs(output - expected) > EPSILON )
         printError( "ct.distance(" + x1 + "," + y1 + "," + x2 + "," + y2 + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testToInt( double d, int expected )
   {
      double output = ct.toInt(d);
      if ( output != expected )
         printError( "ct.toInt(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testParseInt( String s, int expected )
   {
      int output = ct.parseInt(s);
      if ( output != expected )
         printError( "ct.parseInt(" + s + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testCanParseInt( String s, boolean expected )
   {
      boolean output = ct.canParseInt(s);
      if ( output != expected )
         printError( "ct.canParseInt(" + s + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testParseNumber( String s, double expected )
   {
      double output = ct.parseNumber(s);
      if ( Math.abs(output - expected) > EPSILON )
         printError( "ct.parseNumber(" + s + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testParseNumberError( String s )
   {
      double output = ct.parseNumber(s);
      if ( !ct.isError( output ) )
         printError( "ct.parseNumber(" + s + ") = " + output + "; NaN expected" );
   }
   
   public void testCanParseNumber( String s, boolean expected )
   {
      boolean output = ct.canParseNumber(s);
      if ( output != expected )
         printError( "ct.canParseNumber(" + s + ") = " + output + "; " + expected + " expected" );
   }   
   
   public void testFormatDecimal( double d, String expected )
   {
      String output = ct.formatDecimal( d );
      if ( !output.equals(expected) )
         printError( "ct.formatDecimal(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testFormatDecimal( double d, int numPlaces, String expected )
   {
      String output = ct.formatDecimal( d, numPlaces );
      if ( !output.equals(expected) )
         printError( "ct.formatDecimal(" + d + ", " + numPlaces + ") = " + output + "; " + expected + " expected" );
   }
     
   public void testFormatInt( int i, String expected )
   {
      String output = ct.formatInt( i );
      if ( !output.equals(expected) )
         printError( "ct.formatInt(" + i + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testFormatInt( int i, int numPlaces, String expected )
   {
      String output = ct.formatInt( i, numPlaces );
      if ( !output.equals(expected) )
         printError( "ct.formatInt(" + i + ", " + numPlaces + ") = " + output + "; " + expected + " expected" );
   }
   
   // Tests 
   // -------------------------------------------------------------
   
   public void runTests_random( boolean run )
   {
      if ( run )
      {
//          testRandom( 10, 1 );
//          testRandom( Integer.MIN_VALUE, Integer.MAX_VALUE ); // throws exception
//          testRandom( 0, Integer.MAX_VALUE ); // throws exception
//          testRandom( Integer.MIN_VALUE / 2, Integer.MAX_VALUE / 2 ); // throws exception 
         
         testRandom( 0, Integer.MAX_VALUE - 1 );
         testRandom( Integer.MIN_VALUE + 1, -1 );
         testRandom( Integer.MIN_VALUE / 2 + 1, Integer.MAX_VALUE / 2 );
         testRandom( Integer.MIN_VALUE / 2, Integer.MAX_VALUE / 2 - 1 );

         print( "ct.random tests done" );
      }
   }
      
   public void runTests_round( boolean run )
   {
      if ( run )
      {  
         // Ties round to the nearest even number if numPlaces is used
         testRound( 1.45, 1, 1.4 ); 
         testRound( 1.35, 1, 1.4 );
      
         // If the argument is NaN, the result is 0
         testRound( 0.0/0, 0 );
         testRound( Math.log(-1), 0 );
         
         // If the argument is negative infinity or any value less than or equal to the value of Long.MIN_VALUE, the result is equal to the value of (int)Long.MIN_VALUE.
         testRound( -1.0/0, 0 );
         testRound( Double.MIN_VALUE, 0 );
    
         // If the argument is positive infinity or any value greater than or equal to the value of Long.MAX_VALUE, the result is equal to the value of (int)Long.MAX_VALUE.
         testRound( 1.0/0, -1 );
         testRound( Double.MAX_VALUE, -1 );
         
         testRound( Integer.MAX_VALUE, 2147483647 );
         testRound( (double)Integer.MAX_VALUE + 1, -2147483648 );
         
         testRound( Integer.MIN_VALUE, -2147483648 );
         testRound( (double)Integer.MIN_VALUE - 1, 2147483647 );
         
         // How should negative values for numPlaces work?
         testRound( 123456.7, -1, 123460.0 );
         testRound( 123456.7, -2, 123500.0 );
         testRound( 123456.7, -3, 123000.0 );
         
         
         print( "ct.round tests done" );
      }
   }
   
   public void runTests_intDiv( boolean run )
   {
      if ( run )
      {         
         testIntDiv( 0, 0, 0 );
         testIntDiv( 1, 0, Integer.MAX_VALUE );
         testIntDiv( -1, 0, Integer.MIN_VALUE );
         testIntDiv( 0, 1, 0 );
         testIntDiv( 0, -1, 0 );

         testIntDiv( Integer.MIN_VALUE, Integer.MIN_VALUE, 1 );
         testIntDiv( Integer.MAX_VALUE, Integer.MAX_VALUE, 1 );
         testIntDiv( Integer.MAX_VALUE, Integer.MIN_VALUE, -1 );
         testIntDiv( Integer.MIN_VALUE, Integer.MAX_VALUE, -2 );


         // There is one special case, if the dividend is the Integer.MIN_VALUE and the divisor is -1, 
         // then integer overflow occurs and the result is equal to the Integer.MIN_VALUE.
         testIntDiv( Integer.MIN_VALUE, -1, Integer.MIN_VALUE);

         for ( int i = 0; i < 1000; i++ )
         {
         	int n, d;

      		n = ct.random( Integer.MIN_VALUE / 2 + 1, Integer.MAX_VALUE / 2 );
      		d = ct.random( Integer.MIN_VALUE / 2 + 1, Integer.MAX_VALUE / 2 );

         	int expected = 0;

         	if ( n > 0 && d > 0 || n < 0 && d < 0 )
         	{
	      		// n and d are the same sign
      			expected = n / d;
      		}
      		else if ( n > 0 && d < 0 || n < 0 && d > 0 )
   			{
					// n and d are opposite signs
      			expected = n / d - 1;
   			}
   			else if ( d == 0 )
   			{
					if ( n > 0 )
					{
						expected = Integer.MAX_VALUE;
					}
					else if ( n < 0 )
					{
						expected = Integer.MIN_VALUE;
					}
   			}

   			testIntDiv( n, d, expected );
         }
         
         print( "ct.intDiv tests done" );
      }
   }
   
   public void runTests_isError( boolean run )
   {
      if ( run )
      {         
         testIsError( Double.NaN, true );
         testIsError( 1.0/0, false );
         testIsError( -1.0/0, false );
         for ( int i = 0; i < 1000; i++ )
         {
         	double d = ct.random( Integer.MIN_VALUE + 1, -1 ) + Math.random();
            testIsError( d, false );
            
            d = ct.random( 0, Integer.MAX_VALUE - 1 ) + Math.random();
            testIsError( d, false );

         }
         
         print( "ct.isError tests done" );
      }
   }
      
   public void runTests_distance( boolean run )
   {
      if ( run )
      {
         double pInf = Double.POSITIVE_INFINITY;
         double nInf = Double.NEGATIVE_INFINITY;
         double nAn = Double.NaN;

         testDistance( 0, 0, 0, pInf, Double.POSITIVE_INFINITY );
         testDistance( 0, 0, pInf, 0, Double.POSITIVE_INFINITY );
         testDistance( 0, pInf, 0, 0, Double.POSITIVE_INFINITY );
         testDistance( pInf, 0, 0, 0, Double.POSITIVE_INFINITY );

     		testDistance( 0, 0, 0, nInf, Double.POSITIVE_INFINITY );
         testDistance( 0, 0, nInf, 0, Double.POSITIVE_INFINITY );
         testDistance( 0, nInf, 0, 0, Double.POSITIVE_INFINITY );
         testDistance( nInf, 0, 0, 0, Double.POSITIVE_INFINITY );

         testDistance( pInf, pInf, pInf, pInf, Double.POSITIVE_INFINITY );
         testDistance( nInf, nInf, nInf, nInf, Double.POSITIVE_INFINITY );
         testDistance( pInf, pInf, nInf, nInf, Double.POSITIVE_INFINITY );
         testDistance( nInf, nInf, pInf, pInf, Double.POSITIVE_INFINITY );

         testDistance( 0, 0, 0, nAn, Double.POSITIVE_INFINITY );
         testDistance( 0, 0, nAn, 0, Double.POSITIVE_INFINITY );
         testDistance( 0, nAn, 0, 0, Double.POSITIVE_INFINITY );
         testDistance( nAn, 0, 0, 0, Double.POSITIVE_INFINITY );

         testDistance( nAn, pInf, nInf, nAn, Double.POSITIVE_INFINITY );
         testDistance( nAn, 0, 0, 0, Double.NaN );

         testDistance( Double.MAX_VALUE, 0, 0, 0, Double.MAX_VALUE );
         testDistance( 0, Double.MAX_VALUE, 0, 0, Double.MAX_VALUE );

         testDistance( Double.MIN_VALUE, 0, 0, 0, Double.MIN_VALUE );
         testDistance( 0, Double.MIN_VALUE, 0, 0, Double.MIN_VALUE );

         print( "ct.distance tests done" );
      }
   }
   
   public void initTests_getTimer( boolean run )
   {
      if ( run )
      {  
         timerDisplay = ct.text( "", 5, 10, 5 );
         timerDisplay.align( "left" );
         countDownDisplay = ct.text( "", 5, 20, 5 );
         countDownDisplay.align( "left" );
         
         countDownSec = 10;
      	double days = 24.855134814814814814814814814815;
      	double hours = days * 24;
      	double minutes = hours * 60;
      	double seconds = minutes * 60 - countDownSec;
      	int extraTimeMs = (int)(seconds * 1000);
      	startTimeMs = System.currentTimeMillis() - extraTimeMs;
      }
   }
   
   public void runTests_getTimer( boolean run )
   {
      if ( run )
      {         
         timerDisplay.setText( "Timer millis: " + (int)(System.currentTimeMillis() - startTimeMs) );
         int secondsTillRollover = countDownSec - ct.getTimer() / 1000;
         countDownDisplay.setText( "Countdown to rollover: " + secondsTillRollover );
      }
   }
   
   public void runTests_getVersion( boolean run )
   {
      if ( run )
      {
         double version = ct.getVersion();
         if ( version != VERSION )
         {
            allTestsPassed = false;
            printError( "ct.getVersion() = " + version + "; " + VERSION + " expected" );
         }
         print( "ct.getVersion tests done" );
      }
   }
      
   public void runTests_toInt( boolean run )
   {
      if ( run )
      {
      	testToInt( Integer.MAX_VALUE * 1.0, Integer.MAX_VALUE );
      	testToInt( Integer.MIN_VALUE * 1.0, Integer.MIN_VALUE );

         print( "ct.toInt tests done" );
      }
   }
      
   public void runTests_parseInt( boolean run )
   {
      if ( run )
      {
      	testParseInt( "" + Integer.MAX_VALUE, Integer.MAX_VALUE );
      	testParseInt( "" + Integer.MIN_VALUE, Integer.MIN_VALUE );
        	testParseInt( "5.0", 0 );

         print( "ct.parseInt tests done" );
      }
   }
      
   public void runTests_canParseInt( boolean run )
   {
      if ( run )
      {
      	testCanParseInt( "" + Integer.MAX_VALUE, true );
      	testCanParseInt( "" + Integer.MIN_VALUE, true );
      	testCanParseInt( "5.0", false );

         print( "ct.canParseInt tests done" );
      }
   }
   
   public void runTests_parseNumber( boolean run )
   {
      if ( run )
      {
      	testParseNumber( "" + Double.MAX_VALUE, Double.MAX_VALUE );
      	testParseNumber( "" + Double.MIN_VALUE, Double.MIN_VALUE );
      	testParseNumber( "" + 1.0/0, Double.POSITIVE_INFINITY );
      	testParseNumber( "" + (-1.0/0), Double.NEGATIVE_INFINITY );
      	         
         print( "ct.parseNumber tests done" );
      }
   }
   
   public void runTests_canParseNumber( boolean run )
   {
      if ( run )
      {
      	testCanParseNumber( "" + Double.MAX_VALUE, true );
      	testCanParseNumber( "" + Double.MIN_VALUE, true );
      	testCanParseNumber( "" + 1.0/0, true );
      	testCanParseNumber( "" + (-1.0/0), true );

         print( "ct.canParseNumber tests done" );
      }
   }
   
   public void runTests_formatDecimal( boolean run )
   {
      if ( run )
      {
      	// if ( numPlaces <= 0 ), Math.rInt() rounds ties to the nearest event number.
      	testFormatDecimal( 2.5, 0, "2.0" );
         testFormatDecimal( 1.5, 0, "2.0" );
         testFormatDecimal( -3.5, 0, "-4.0" );
         testFormatDecimal( -4.5, 0, "-4.0" );
         
         testFormatDecimal( 1.0/0, 0, "Infinity" );
         testFormatDecimal( -1.0/0, 0, "-Infinity" );
         testFormatDecimal( 0.0/0, 0, "NaN" );
         testFormatDecimal( Math.sqrt(-1), 0, "NaN" );
         
         print( "ct.formatDecimal tests done" );
      }
   }
   
   public void runTests_formatInt( boolean run )
   {
      if ( run )
      {
         testFormatInt( 123, 0, "" );
			testFormatInt( 456, -1, "" );
			testFormatInt( 456, 1, "456" );

         print( "ct.formatInt tests done" );
      }
   }
}
