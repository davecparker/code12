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
// double ct.toDouble( int i )
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
import java.util.Arrays;
import org.apache.commons.math3.special.Gamma;

class MathMiscTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MathMiscTest()); 
   }
   
   PrintWriter writer;
   boolean allTestsPassed = true;
   int frameCount;
   int avgFrameCount;
   int start;
   double epsilon; // used when comparing doubles
   
   GameObj displayText;
   
   boolean runTest_getTimer;
   
   public void start()
   {  
      epsilon = 0.0000001; 
      int randomMaxCount = 1000;
      
      runTest_getTimer = false;
      
      boolean runTest_random = false;
      boolean runTest_randomIsUniform = false;
      boolean runTest_round = false;
      boolean runTest_isError = false;
      boolean runTest_distance = true;
      boolean runTest_getVersion = false;
      boolean runTest_toDouble = false;
      boolean runTest_toInt = false;
      boolean runTest_parseInt = true;
      boolean runTest_canParseInt = true;
      
      // double ct.parseNumber( String s )       // NaN if failure
      // boolean ct.canParseNumber( String s )
      // String ct.formatDecimal( double d )
      // String ct.formatDecimal( double d, int numPlaces )
      // String ct.formatInt( int i )
      // String ct.formatInt( int i, int numDigits )    // uses leading 0's

      frameCount = 0;
      displayText = ct.text( "", 0, 40, 5 );
      displayText.align( "left" );
            
      try
      {
         writer = new PrintWriter( "output.txt" );
         ct.println( "Tests started" );
         
         // ----------------------------------------------------------------------------------
         // Math and Misc. Tests
         // ----------------------------------------------------------------------------------

         // int ct.random( int min, int max )
         // ---------------------------------
         int chiSqrTestsFailed = 0;
         int chiSqrTestsDone = 0;
         if ( runTest_random )
         {
            double alpha = 0.05;
            
            for ( int range = 1; range <= 1000; range++ )
            {
               for ( int min = -100; min <= 100; min++ )
               {
                  int max = min + range;
               
                  int[] observedFreq = new int[1];

                  if ( runTest_randomIsUniform )
                  {
                     observedFreq = new int[range + 1];
                  }
                  
                  for ( int count = 1; count <= randomMaxCount; count++ )
                  {
                     int rand = ct.random( min, max );
                     
                     if ( runTest_randomIsUniform )
                     {
                        observedFreq[ rand - min ]++;
                     }

                     // test if return value is between min and max
                     if ( rand < min || rand > max )
                     {
                        allTestsPassed = false;
                        String error = "ct.random(" + min + "," + max + ") = " + rand;
                        writer.println( error );
                        ct.println( error );
                     }
                  }
                  
                  // test if return value is uniformly distributed (Chi Square test)
                  if ( runTest_randomIsUniform )
                  {
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
                     {
                         chiSqrTestsFailed++;
                     }
                  }

               }
               double fractionOfChiSqrTestsFailed = (double)(chiSqrTestsFailed) / chiSqrTestsDone;
               if ( fractionOfChiSqrTestsFailed > alpha )
               {
                  allTestsPassed = false;
                  String error = "Fraction of Chi Square Tests Failed = " + fractionOfChiSqrTestsFailed + " (alpha = " + alpha + ")";
                  writer.println( error );
                  ct.println( error );
               }
            }
            
            ct.println( "ct.random test done" );
            writer.println( "ct.random test done" );
         }
         
         // int ct.round( double d )
         // double ct.round( double d, int numPlaces )
         // ------------------------------------------
         if ( runTest_round )
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
            
            ct.println( "ct.round test done" );
            writer.println( "ct.round test done" );
         }
         
         // boolean ct.isError( double d )
         // ------------------------------
         if ( runTest_isError )
         {
            // test ct.isError( Infinity )
            // ----
            // testIsError( 1.0 / 0.0, "1.0 / 0.0" );
            // testIsError( 10.0 / 0, "10.0 / 0" );
            // testIsError( 10.0 / (1/2), "10.0 / (1/2)" );
            // testIsError( Math.tan(Math.PI/2), "Math.tan(Math.PI/2)" );
            
            // test ct.isError( NaN )
            // ----
            testIsError( Math.sqrt(-1), "Math.sqrt(-1)" );
            testIsError( Math.asin(2), "Math.asin(2)" );
            testIsError( Math.acos(2), "Math.asin(2)" );
            testIsError( Math.log(-1), "Math.log(-1)" );
            testIsError( Math.pow(-1, 0.5), "Math.pow(-1, 0.5)" );
            testIsError( Math.pow(-4, 0.25), "Math.pow(-4, 0.25)" );
            
            ct.println( "ct.isError test done" );
            writer.println( "ct.isError test done" );
         }
         
         // double ct.distance( double x1, double y1, double x2, double y2 )
         // ----------------------------------------------------------------
         if ( runTest_distance )
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
            
            ct.println( "ct.distance test done" );
            writer.println( "ct.distance test done" );
         }
         
         // int ct.getTimer( )
         // ------------------
         // tested in update()
         
         // double ct.getVersion( )
         // --------------------
         if ( runTest_getVersion )
         {
            double version = ct.getVersion();
            if ( version != 0.5 )
            {
               allTestsPassed = false;
               String error = "ct.getVersion() = " + version;
               ct.println( error );
               writer.println( error );
            }
            ct.println( "ct.getVersion test done" );
            writer.println( "ct.getVersion test done" );
         }
         
         // -------------------------------------------------------------------------------
         // Type Conversion Tests
         // -------------------------------------------------------------------------------
         
         // double ct.toDouble( int i )
         // ---------------------------
         if ( runTest_toDouble )
         {
            for (int i = -1000; i <= 1000; i++)
            {
               testToDouble( i, (double) i );
            }
                        
            ct.println( "ct.toDouble test done" );
            writer.println( "ct.toDouble test done" );
         }
         
         // int ct.toInt( double d )                // truncates
         // ------------------------
         if ( runTest_toInt )
         {
            for (int i = -100000; i <= 100000; i++)
            {
               testToInt( i / 1000.0, i / 1000 );
            }
            
            ct.println( "ct.toInt test done" );
            writer.println( "ct.toInt test done" );
         }
         
         // int ct.parseInt( String s )             // 0 if failure
         // ---------------------------
         if ( runTest_parseInt )
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
                        
            String line = "ct.parseInt test done";
            ct.println( line );
            writer.println( line );
         }
         
         // boolean ct.canParseInt( String s )
         // ----------------------------------
         if ( runTest_canParseInt )
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

            String line = "ct.canParseInt test done";
            ct.println( line );
            writer.println( line );
         }
         
         // double ct.parseNumber( String s )       // NaN if failure
         // ---------------------------------
         
         
         
         // boolean ct.canParseNumber( String s )
         // String ct.formatDecimal( double d )
         // String ct.formatDecimal( double d, int numPlaces )
         // String ct.formatInt( int i )
         // String ct.formatInt( int i, int numDigits )    // uses leading 0's
                  
         // End of tests
         writer.close();
         
         ct.println( "Tests finished" );
         if ( allTestsPassed )
         {
            String line = "All tests passed";
            ct.println( line );
            writer.println( line );
         }
      }
      catch(Exception e)
      {
         ct.println( "Error writing to output.txt" );
      }
      start = ct.getTimer();
   }
   
   public void update()
   {  
      if ( runTest_getTimer )
      { 
         int newStart = ct.getTimer();
         frameCount++;
         double secondsPerFrame = (newStart - start) / 1000.0;
         start = newStart;
         double framesPerSecond = ct.round(1 / secondsPerFrame, 2);
         // ct.println( "Frames Per Second: " + framesPerSecond );

         double secondsPerFrameSinceStart = newStart / 1000.0;
         double avgFramesPerSecond = ct.round(frameCount / secondsPerFrameSinceStart, 2);          
         displayText.setText( "Avg Frames Per Second: " + avgFramesPerSecond );       
      }
   }
   
   public void testRound( double d, int expected )
   {
      int output = ct.round(d);
      if ( output != expected )
      {
         allTestsPassed = false;
         String error = "ct.round(" + d + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testRound( double d, int numPlaces, double expected )
   {
      double output = ct.round(d, numPlaces);
      double eps = Math.pow(0.1, numPlaces + 1);
      if ( Math.abs(output - expected) > eps )
      {
         allTestsPassed = false;
         String error = "ct.round(" + d + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testIsError( double d, String expression )
   {
      if ( !ct.isError(d) )
      {
         allTestsPassed = false;
         String error = "ct.isError(" + expression + ") = ct.isError(" + d + ") = false";
         writer.println( error );
         ct.println( error );
      }  
   }
   
   public void testDistance( double x1, double y1, double x2, double y2, double expected )
   {
      double output = ct.distance( x1, y1, x2, y2 );
      if ( Math.abs(output - expected) > epsilon )
      {
         allTestsPassed = false;
         String error = "ct.distance(" + x1 + "," + y1 + "," + x2 + "," + y2 + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testToDouble( int i, double expected )
   {
      double output = ct.toDouble(i);
      if ( Math.abs(output - expected) > epsilon )
      {
         allTestsPassed = false;
         String error = "ct.toDouble(" + i + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testToInt( double d, int expected )
   {
      double output = ct.toInt(d);
      if ( output != expected )
      {
         allTestsPassed = false;
         String error = "ct.toInt(" + d + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
      
   public void testParseInt( String s, int expected )
   {
      int output = ct.parseInt(s);
      if ( output != expected )
      {
         allTestsPassed = false;
         String error = "ct.parseInt(" + s + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testCanParseInt( String s, boolean expected )
   {
      boolean output = ct.canParseInt(s);
      if ( output != expected )
      {
         allTestsPassed = false;
         String error = "ct.canParseInt(" + s + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
   
   public void testParseNumber( String s, double expected )
   {
      double output = ct.parseNumber(s);
      if ( Math.abs(output - expected) > epsilon )
      {
         allTestsPassed = false;
         String error = "ct.testParseNumber(" + s + ") = " + output;
         writer.println( error );
         ct.println( error );
      }
   }
}
