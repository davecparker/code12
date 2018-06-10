// Black Box test of Math, Misc, and Type Conversion APIs

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
import org.apache.commons.math3.special.Gamma;

class MathMiscTypeConversionTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MathMiscTypeConversionTest()); 
   }

   final double EPSILON = 0.0000001; // doubles differing by this or less will test equal
   
   boolean allTestsPassed = true;

   PrintWriter writer;
   int frameCount;
   int avgFrameCount;
   int start;
   GameObj framesPerSecondText;
   GameObj timeDisplay;
   GameObj startButton;
   int timerStartTime;
   boolean timerStarted;
         
   public void start()
   {  
      // ct.random( 100, 0 ); // Throws Exception in thread "AWT-EventQueue-0" java.lang.IllegalArgumentException: bound must be positive   
                              //    	at java.util.Random.nextInt(Random.java:388)
	                           //       at Code12.Game.random(Game.java:276)
      try
      {
         writer = new PrintWriter( "output.txt" );
         ct.println( "Tests started" );
         
         runTests_random( true );
         runTests_round( true );
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
      }
      
      initTests_getTimer( true );
   }
   
   public void update()
   {  
      runTests_getTimer( true );
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( obj == startButton )
      {
         timerStartTime = ct.getTimer();
         timerStarted = true;
         // startButton.visible = false;
      }
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
   
   public void testRound( double d, int expected )
   {
      int output = ct.round(d);
      if ( output != expected )
         printError( "ct.round(" + d + ") = " + output + "; " + expected + " expected" + "; " + expected + " expected" );
   }
   
   public void testRound( double d, int numPlaces, double expected )
   {
      double output = ct.round(d, numPlaces);
      double eps = Math.pow(0.1, numPlaces + 1);
      if ( Math.abs(output - expected) > eps )
         printError( "ct.round(" + d + ", " + numPlaces + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testIsError( double d, String expression )
   {
      if ( !ct.isError(d) )
         printError( "ct.isError(" + expression + ") = ct.isError(" + d + ") = false" );
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
         int chiSqrTestsFailed = 0;
         int chiSqrTestsDone = 0;
         double alpha = 0.05; // Level of significance for Chi-Squared Tests
         
         for ( int range = 1; range <= 200; range++ )
         {
            for ( int min = -100; min <= 100; min++ )
            {
               int max = min + range;
               int[] observedFreq = new int[range + 1];
               
               int randomMaxCount = 500;  // sample size for testing chi square tests
               
               for ( int count = 1; count <= randomMaxCount; count++ )
               {                
                  int rand = ct.random( min, max );
                  observedFreq[ rand - min ]++;
   
                  // test if return value is between min and max
                  if ( rand < min || rand > max )
                     printError( "ct.random(" + min + "," + max + ") = " + rand );
               }
               
               // test if return value is uniformly distributed (Chi Square test)
               double expectedFreq = (double)(randomMaxCount) / (range + 1);
               double chiSqr = 0;
               for ( int i = 0; i < range + 1; i++ )
               {
                  double dev = observedFreq[i] - expectedFreq;
                  chiSqr +=  dev * dev / expectedFreq;
               }
               double dof = randomMaxCount - 1;
               double pValue = Gamma.regularizedGammaQ(dof / 2, chiSqr / 2);
               chiSqrTestsDone++;
               
               if ( pValue < alpha )
                   chiSqrTestsFailed++;
            }
         }
         
         double fractionOfChiSqrTestsFailed = (double)(chiSqrTestsFailed) / chiSqrTestsDone;
         if ( fractionOfChiSqrTestsFailed > alpha )
            printError( "Fraction of Chi Square Tests Failed = " + fractionOfChiSqrTestsFailed + " (alpha = " + alpha + ")" );
               
         print( "ct.random tests done" );
      }
   }
      
   public void runTests_round( boolean run )
   {
      if ( run )
      {
         testRound( 3.14159265, 3 );
         testRound( 3.14159265, 1, 3.1 );
         testRound( 3.14159265, 2, 3.14 );
         testRound( 3.14159265, 3, 3.142 );
         testRound( 3.14159265, 4, 3.1416 );
         testRound( 3.14159265, 5, 3.14159 );
         testRound( 3.14159265, 6, 3.141593 );
         testRound( 3.14159265, 7, 3.1415927 );
         testRound( 3.14159265, 8, 3.14159265 );
         
         testRound( -3.14159265, -3 );
         testRound( -3.14159265, 1, -3.1 );
         testRound( -3.14159265, 2, -3.14 );
         testRound( -3.14159265, 3, -3.142 );
         testRound( -3.14159265, 4, -3.1416 );
         testRound( -3.14159265, 5, -3.14159 );
         testRound( -3.14159265, 6, -3.141593 );
         testRound( -3.14159265, 7, -3.1415927 );
         testRound( -3.14159265, 8, -3.14159265 );
                    
         testRound( 31.622776601683793319988935444327, 32);
         testRound( 31.622776601683793319988935444327, 1, 31.6);
         testRound( 31.622776601683793319988935444327, 2, 31.62);
         testRound( 31.622776601683793319988935444327, 3, 31.623);
         testRound( 31.622776601683793319988935444327, 29, 31.62277660168379331998893544433);

         testRound( -31.622776601683793319988935444327, -32);
         testRound( -31.622776601683793319988935444327, 1, -31.6);
         testRound( -31.622776601683793319988935444327, 2, -31.62);
         testRound( -31.622776601683793319988935444327, 3, -31.623);
         testRound( -31.622776601683793319988935444327, 29, -31.62277660168379331998893544433);

         testRound( 123.049, 1, 123.0 );
         testRound( -123.049, 1, -123.0 );
         
         testRound( 2.99792458, 3 );
         testRound( 29.9792458, 30 );
         testRound( 299.792458, 300 );
         testRound( 2997.92458, 2998 );
         testRound( 29979.2458, 29979 );
         testRound( 299792.458, 299792 );
         testRound( 2997924.58, 2997925 );
         testRound( 29979245.8, 29979246 );
         testRound( 299792458.0, 299792458 );
         
         testRound( -2.99792458, -3 );
         testRound( -29.9792458, -30 );
         testRound( -299.792458, -300 );
         testRound( -2997.92458, -2998 );
         testRound( -29979.2458, -29979 );
         testRound( -299792.458, -299792 );
         testRound( -2997924.58, -2997925 );
         testRound( -29979245.8, -29979246 );
         testRound( -299792458.0, -299792458 );
         
         print( "ct.round tests done" );
      }
   }
   
   public void runTests_isError( boolean run )
   {
      if ( run )
      {         
         testIsError( Math.sqrt(-1), "Math.sqrt(-1)" );
         testIsError( Math.asin(2), "Math.asin(2)" );
         testIsError( Math.acos(2), "Math.asin(2)" );
         testIsError( Math.log(-1), "Math.log(-1)" );
         testIsError( Math.pow(-1, 0.5), "Math.pow(-1, 0.5)" );
         testIsError( Math.pow(-4, 0.25), "Math.pow(-4, 0.25)" );
         
         print( "ct.isError tests done" );
      }
   }
      
   public void runTests_distance( boolean run )
   {
      if ( run )
      {
         testDistance( 0, 0, 3, 4, 5 );
         testDistance( 10, 20, 13, 24, 5 );
         testDistance( 0, 0, -5, -12, 13 );
         testDistance( -8, 15, 0, 0, 17 );
         testDistance( -75, -34, -37, 85, 124.9199744 );
         testDistance( -5.16, 64.79, 86.54, -29.152, 131.2782898  );
         testDistance( 1, 2, 1.01, 2.02, 0.02236068 );
         testDistance( 5, 10, 5.1, 1010, 1000.000005 );
         testDistance( 7, 8, 7.0001, 8.0001, 0.000141421 );
         
         print( "ct.distance tests done" );
      }
   }
   
   public void initTests_getTimer( boolean run )
   {
      if ( run )
      { 
         frameCount = 0;
         framesPerSecondText = ct.text( "", 5, 5, 5 );
         framesPerSecondText.align( "left" ); 
         
         timeDisplay = ct.text( "00:00:00.00", 5, 10, 5 );
         timeDisplay.align( "left" );
         
         startButton = ct.text( "Start Timer", 5, 15, 5 );
         startButton.align( "left" );
         startButton.clickable = true;
         
         start = ct.getTimer();
      }
   }
   
   public void runTests_getTimer( boolean run )
   {
      if ( run )
      {
         int newStart = ct.getTimer();
         frameCount++;
         double secondsPerFrame = (newStart - start) / 1000.0;
         start = newStart;
         double framesPerSecond = ct.round(1 / secondsPerFrame, 2);
         // ct.println( "Frames Per Second: " + framesPerSecond );
         
         double secondsPerFrameSinceStart = newStart / 1000.0;
         double avgFramesPerSecond = ct.round(frameCount / secondsPerFrameSinceStart, 2);          
         framesPerSecondText.setText( "Avg Frames Per Second: " + avgFramesPerSecond ); 
          
         if ( timerStarted )
         {
            double sec = ( ct.getTimer() - timerStartTime ) / 1000.0;          
            int time = (int)( sec );
            int hrs = time / 3600;
            time %= 3600;
            int min = time / 60;
            sec = sec - hrs * 3600 - min * 60;
            timeDisplay.setText( hrs + ":" + min + ":" + sec );
         }  
      }
   }
   
   public void runTests_getVersion( boolean run )
   {
      if ( run )
      {
         double version = ct.getVersion();
         if ( version != 0.5 )
         {
            allTestsPassed = false;
            String error = "ct.getVersion() = " + version;
            ct.println( error );
            writer.println( error );
         }
         print( "ct.getVersion tests done" );
      }
   }
      
   public void runTests_toInt( boolean run )
   {
      if ( run )
      {
         for (int i = -100000; i <= 100000; i++)
         {
            testToInt( i, i );
            testToInt( i / 1000.0, i / 1000 );
         }
         print( "ct.toInt tests done" );
      }
   }
      
   public void runTests_parseInt( boolean run )
   {
      if ( run )
      {
         // test valid input
         testParseInt( "0", 0 );
         testParseInt( " 0", 0 );
         testParseInt( "-0", 0 );
         testParseInt( "+0", 0 );
         testParseInt( "1", 1 );
         testParseInt( " 123", 123 );
         testParseInt( "  +4567", 4567 );            
         testParseInt( "  -987654321  ", -987654321 );   
         
         // test invalid input
         testParseInt( "", 0 );
         testParseInt( "3.14", 0 );
         testParseInt( "seven", 0 );
         testParseInt( "8/2", 0 );
         testParseInt( "  + 4567 ", 0 );
                     
         print( "ct.parseInt tests done" );
      }
   }
      
   public void runTests_canParseInt( boolean run )
   {
      if ( run )
      {
         // test valid input
         testCanParseInt( "0", true );
         testCanParseInt( " 0", true );
         testCanParseInt( "-0", true );
         testCanParseInt( "+0", true );
         testCanParseInt( "1", true );
         testCanParseInt( " 123", true );
         testCanParseInt( "  +4567", true );            
         testCanParseInt( "  -987654321  ", true );   
         
         // test invalid input
         testCanParseInt( "", false );
         testCanParseInt( "3.14", false );
         testCanParseInt( "seven", false );
         testCanParseInt( "8/2", false );
         testCanParseInt( "  + 4567 ", false );
         testCanParseInt( "1 + sqrt(2)", false );
         testCanParseInt( "Math.PI", false );

         print( "ct.canParseInt tests done" );
      }
   }
   
   public void runTests_parseNumber( boolean run )
   {
      if ( run )
      {
         // test valid input
         testParseNumber( "0", 0.0 );
         testParseNumber( " 0", 0.0 );
         testParseNumber( "-0", 0.0 );
         testParseNumber( "+0", 0.0 );
         testParseNumber( "1", 1.0 );
         testParseNumber( " 123", 123.0 );
         testParseNumber( "  +4567", 4567.0 );            
         testParseNumber( "  -987654321  ", -987654321.0 ); 
         testParseNumber( "3.14159", 3.14159 );
         testParseNumber( " 3.14159", 3.14159 );
         testParseNumber( "3.14159 ", 3.14159 );
         testParseNumber( "+1.618033989", 1.618033989 );
         testParseNumber( "-0.618033989", -0.618033989 );
         testParseNumber( ".123456", .123456 );
         testParseNumber( "+.123456", .123456 );
         testParseNumber( "-.123456", -.123456 );
         testParseNumber( "  987654.321   ", 987654.321 );
         
         // test invalid input
         testParseNumberError( "3.14.159" );
         testParseNumberError( "Math.PI" );
         testParseNumberError( "Hello World" );
         testParseNumberError( "1+2" );
         testParseNumberError( "3^2" );
         testParseNumberError( "foo" );
         testParseNumberError( "1 + sqrt(2)" );
         testParseNumberError( "0xFFFF00" );
         testParseNumberError( "" );
         
         print( "ct.parseNumber tests done" );
      }
   }
   
   public void runTests_canParseNumber( boolean run )
   {
      if ( run )
      {
         testCanParseNumber( "0", true );
         testCanParseNumber( " 0", true );
         testCanParseNumber( "-0", true );
         testCanParseNumber( "+0", true );
         testCanParseNumber( "1", true );
         testCanParseNumber( " 123", true );
         testCanParseNumber( "  +4567", true );
         testCanParseNumber( "  -987654321  ", true );
         testCanParseNumber( "3.14159", true );
         testCanParseNumber( " 3.14159", true );
         testCanParseNumber( "3.14159 ", true );
         testCanParseNumber( "+1.618033989", true );
         testCanParseNumber( "-0.618033989", true );
         testCanParseNumber( ".123456", true );
         testCanParseNumber( "+.123456", true );
         testCanParseNumber( "-.123456", true );
         testCanParseNumber( "  987654.321   ", true );

         testCanParseNumber( "3.14.159" , false );
         testCanParseNumber( "Math.PI" , false );
         testCanParseNumber( "Hello World" , false );
         testCanParseNumber( "1+2" , false );
         testCanParseNumber( "3^2" , false );
         testCanParseNumber( "foo" , false );
         testCanParseNumber( "1 + sqrt(2)" , false );
         testCanParseNumber( "0xFFFF00" , false );
         testCanParseNumber( "" , false );

         print( "ct.canParseNumber tests done" );
      }
   }
   
   public void runTests_formatDecimal( boolean run )
   {
      if ( run )
      {
         testFormatDecimal( 0.0, "0.0" );
         testFormatDecimal( 1, "1.0" );
         testFormatDecimal( 4567.0, "4567.0" );            
         testFormatDecimal( 3.14159, "3.14159" );
         testFormatDecimal( 3.14159, 7, "3.1415900" );
         testFormatDecimal( 3.14159, 5, "3.14159" );
         testFormatDecimal( 3.14159, 3, "3.142" );
         testFormatDecimal( 987654.321, 10, "987654.3210000000" );
         testFormatDecimal( 1.23456E2, 2, "123.46" );
         
         testFormatDecimal( Math.E, "" + Math.E );
         testFormatDecimal( Math.PI, "" + Math.PI );
         testFormatDecimal( Math.sqrt(-1), "NaN" );
         testFormatDecimal( 1/0.0, "Infinity" );

         // Very large and small doubles formated in exponential notation
         testFormatDecimal( 1234567.0 , "1234567.0" );
         testFormatDecimal( 12345678.0 , "1.2345678E7" ); 
         testFormatDecimal( 123456789.0 , "1.23456789E8" ); 
         
         testFormatDecimal( Double.MAX_VALUE, "1.7976931348623157E308" );
         testFormatDecimal( -Double.MAX_VALUE, "-1.7976931348623157E308" );
         testFormatDecimal( Double.MIN_VALUE, "4.9E-324" );
         testFormatDecimal( -Double.MIN_VALUE, "-4.9E-324" );

         // What should output be if numPlaces < 1 ?
         testFormatDecimal( 3.14159, 0, "3.0" );
         testFormatDecimal( -0.618033989, -1, "-1.0" );
         testFormatDecimal( 123.123, -2, "123.0" );
         testFormatDecimal( 12345.12345, -3, "12345.0" );
         
         print( "ct.formatDecimal tests done" );
      }
   }
   
   public void runTests_formatInt( boolean run )
   {
      if ( run )
      {
         testFormatInt( 0, "0" );
         testFormatInt( 123, "123" );
         testFormatInt( -123, "-123" );
         testFormatInt( 123456, "123456" );
         testFormatInt( -123456, "-123456" );
         testFormatInt( 123456789, "123456789" );
         testFormatInt( 2147483647, "2147483647" ); // Max int value
         testFormatInt( -2147483648, "-2147483648" ); // Min int value
         
         testFormatInt( 0, 3, "000" );
         testFormatInt( 123, 5, "00123" );
         testFormatInt( 654, 10, "0000000654" );

         testFormatInt( -123, 5, "-0123" );
         testFormatInt( 123456, 2, "123456" );
         testFormatInt( 123456, 6, "123456" );
         testFormatInt( 123456, 10, "0000123456" );
         testFormatInt( -123456, 2, "-123456" );
         testFormatInt( -123456, 6, "-123456" );
         testFormatInt( -123456, 10, "-000123456" );         
         testFormatInt( 123456789, 12, "000123456789" );
         testFormatInt( 2147483647, 10, "2147483647" ); // Max int value
         testFormatInt( 2147483647, 15, "000002147483647" ); 
         testFormatInt( -2147483648, 10, "-2147483648" ); // Min int value
         testFormatInt( -2147483648, 20, "-0000000002147483648" );

         print( "ct.formatInt tests done" );
      }
   }
}
