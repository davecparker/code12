// White Box test of Math, Misc, and Type Conversion APIs

// Math and Misc.
// --------------
// int ct.random( int min, int max )
// int ct.round( double d )
// double ct.roundDecimal( double d, int numPlaces )
// boolean ct.isError( double d )
// double ct.distance( double x1, double y1, double x2, double y2 )
// int ct.getTimer( )
// double getVersion( )

// Type Conversion
// ---------------
// int (int)( double d )                // truncates
// int ct.parseInt( String s )             // 0 if failure
// boolean ct.canParseInt( String s )
// double ct.parseNumber( String s )       // NaN if failure
// boolean ct.canParseNumber( String s )
// String ct.formatDecimal( double d )
// String ct.formatDecimal( double d, int numPlaces )
// String ct.formatInt( int i )
// String ct.formatInt( int i, int numDigits )    // uses leading 0's

import Code12.*;

class MathMiscTypeConversionWhiteBoxTest extends Code12Program
{
   final double EPSILON = 0.0000001; // doubles differing by this or less will test equal
   final double VERSION = 1; // Code12 Runtime Version

   boolean allTestsPassed = true;

   GameObj timerDisplay;
   int startTimeMs;
   GameObj countDownDisplay;
   int countDownSec;
   
   public void start()
   {  
   	ct.setOutputFile( "output.txt" );
   	ct.println( "Tests started" );

   	runTests_roundDecimal( true );
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
   	   ct.println( "All tests passed" );
   	}
   	ct.setOutputFile( null );
   	initTests_getTimer( true );
   }
   
   public void update()
   {  
   	runTests_getTimer( true );
   }
   
   
   // Utility functions 
   // -------------------------------------------------------------
   	
   public void printError( String error )
   {
   	allTestsPassed = false;
   	ct.println( error );
   }
   
   public void testRandom( int min, int max )
   {
   	// try
   	// {
   	   int output = ct.random( min, max );
   	   if ( output < min || output > max )
   	   {
   	   	printError( "ct.random(" + min + "," + max + ") = " + output );
   	   }
   	// }
   	// catch( Exception e )
   	// {
   	//    printError( "ct.random(" + min + "," + max + ") throws " + e.toString() );
    //     }
   }

   public void testRound( double d, int expected )
   {
   	int output = ct.round(d);
   	if ( output != expected )
   	   printError( "ct.round(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testRoundDecimal( double d, int numPlaces, double expected )
   {
   	double output = ct.roundDecimal(d, numPlaces);
   	if ( Math.abs(output - expected) > EPSILON )
   	   printError( "ct.roundDecimal(" + d + ", " + numPlaces + ") = " + output + "; " + expected + " expected" );
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
   	{
   	   if ( output )
   	   	printError( "ct.isError(" + d + ") = true; false expected" );
   	   else
   	   	printError( "ct.isError(" + d + ") = false; true expected" );
   	}

   }
   
   public void testDistance( double x1, double y1, double x2, double y2, double expected )
   {
   	double output = ct.distance( x1, y1, x2, y2 );
   	if ( Math.abs(output - expected) > EPSILON )
   	   printError( "ct.distance(" + x1 + "," + y1 + "," + x2 + "," + y2 + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testToInt( double d, int expected )
   {
   	double output = (int)(d);
   	if ( output != expected )
   	   printError( "(int)(" + d + ") = " + output + "; " + expected + " expected" );
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
   	{
   	   if ( output )
   	   	printError( "ct.canParseInt(" + s + ") = true; false expected" );
   	   else
   	   	printError( "ct.canParseInt(" + s + ") = false; true expected" );
   	}
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
   	{
   	   if ( output )
   	   	printError( "ct.canParseNumber(" + s + ") = true; false expected" );
   	   else
   	   	printError( "ct.canParseNumber(" + s + ") = false; true expected" );
   	}
   }   
   
   public void testFormatDecimal( double d, String expected )
   {
   	String output = ct.formatDecimal( d );
   	if ( !output.equals(expected) )
   	   printError( "ct.formatDecimal(" + d + ") = " + output + "; " + expected + " expected" );
   }
   
   public void testFormatDecimalNumplaces( double d, int numPlaces, String expected )
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
   
   public void testFormatIntNumplaces( int i, int numPlaces, String expected )
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
   	    // testRandom( 10, 1 );
//   	    testRandom( -2147483648, 2147483647 ); // throws exception
//   	    testRandom( 0, 2147483647 ); // throws exception
//   	    testRandom( -2147483648 / 2, 2147483647 / 2 ); // throws exception 
   	   
   	   // testRandom( 0, 2147483647 - 1 );
   	   // testRandom( ct.intDiv(-2147483648,1), -1 );
   	   // testRandom( ct.intDiv(-2147483648,2) + 1, ct.intDiv(2147483647,2) );
   	   // testRandom( ct.intDiv(-2147483648,2), ct.intDiv(2147483647,2) - 1 );

   	   ct.println( "ct.random tests done" );
   	}
   }
   	
   public void runTests_round( boolean run )
   {
   	if ( run )
   	{  
   	   // If the argument is NaN, the result is 0
   	   testRound( 0.0/0, 0 );
   	   testRound( Math.log(-1), 0 );
   	   
   	   // If the argument is negative infinity or any value less than or equal to the value of Long.MIN_VALUE, the result is equal to the value of (int)Long.MIN_VALUE.
   	   testRound( -1.0/0, 0 );
   	   // testRound( 4.9E-324, 0 );
    
   	   // If the argument is positive infinity or any value greater than or equal to the value of Long.MAX_VALUE, the result is equal to the value of (int)Long.MAX_VALUE.
   	   testRound( 1.0/0, -1 );
   	   // testRound( 1.7976931348623157E308, -1 );
   	   
   	   testRound( 2147483647, 2147483647 );
   	   testRound( 1.0 * 2147483647 + 1, -2147483648 );
   	   
   	   testRound( -2147483648, -2147483648 );
   	   testRound( -2147483648 - 1, 2147483647 );   	 
   	   
   	   ct.println( "ct.round tests done" );
   	}
   }

   public void runTests_roundDecimal( boolean run )
   {
   	if ( run )
   	{  
   	   // Ties round to the nearest even number if numPlaces is used
   	   testRoundDecimal( 1.45, 1, 1.4 ); 
   	   testRoundDecimal( 1.35, 1, 1.4 );
   	   	   
   	   // How should negative values for numPlaces work?
   	   testRoundDecimal( 123456.7, -1, 123460.0 );
   	   testRoundDecimal( 123456.7, -2, 123500.0 );
   	   testRoundDecimal( 123456.7, -3, 123000.0 );
   	   
   	   ct.println( "ct.roundDecimal tests done" );
   	}
   }
   
   public void runTests_intDiv( boolean run )
   {
   	if ( run )
   	{   	   
   	   testIntDiv( 0, 0, 0 );
   	   testIntDiv( 1, 0, 2147483647 );
   	   testIntDiv( -1, 0, -2147483648 );
   	   testIntDiv( 0, 1, 0 );
   	   testIntDiv( 0, -1, 0 );

   	   testIntDiv( -2147483648, -2147483648, 1 );
   	   testIntDiv( 2147483647, 2147483647, 1 );
   	   testIntDiv( 2147483647, -2147483648, -1 );
   	   testIntDiv( -2147483648, 2147483647, -2 );


   	   // There is one special case, if the dividend is the -2147483648 and the divisor is -1, 
   	   // then integer overflow occurs and the result is equal to the -2147483648.
   	   testIntDiv( -2147483648, -1, -2147483648);

   	   for ( int i = 0; i < 1000; i++ )
   	   {
   	   	boolean runTest = true;
   	   	int n, d;

   	   	n = ct.random( ct.intDiv(-2147483648, 2) + 1, ct.intDiv(2147483647, 2) );
   	   	d = ct.random( ct.intDiv(-2147483648, 2) + 1, ct.intDiv(2147483647, 2) );
   	   	if ( d != 0 )
   	   		testIntDiv( n, d, ct.intDiv(n, d) );
   	   }
   	   
   	   ct.println( "ct.intDiv tests done" );
   	}
   }
   
   public void runTests_isError( boolean run )
   {
   	if ( run )
   	{   	   
   	   testIsError( 0.0/0, true );
   	   testIsError( 1.0/0, false );
   	   testIsError( -1.0/0, false );
   	   for ( int i = 0; i < 1000; i++ )
   	   {
   	   	double d = ct.random( -2147483648 + 1, -1 ) + ct.random(0, 1000) / 1000.0;
   	   	testIsError( d, false );
   	   	
   	   	d = ct.random( 0, 2147483647 - 1 ) + ct.random(0, 1000) / 1000.0;
   	   	testIsError( d, false );

   	   }
   	   
   	   ct.println( "ct.isError tests done" );
   	}
   }
   	
   public void runTests_distance( boolean run )
   {
   	if ( run )
   	{
   	   // double pInf = Double.POSITIVE_INFINITY;
   	   // double nInf = Double.NEGATIVE_INFINITY;
   	   // double nAn = Double.NaN;

   	   // testDistance( 0, 0, 0, pInf, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, 0, pInf, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, pInf, 0, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( pInf, 0, 0, 0, Double.POSITIVE_INFINITY );

   	   // testDistance( 0, 0, 0, nInf, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, 0, nInf, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, nInf, 0, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( nInf, 0, 0, 0, Double.POSITIVE_INFINITY );

   	   // testDistance( pInf, pInf, pInf, pInf, Double.POSITIVE_INFINITY );
   	   // testDistance( nInf, nInf, nInf, nInf, Double.POSITIVE_INFINITY );
   	   // testDistance( pInf, pInf, nInf, nInf, Double.POSITIVE_INFINITY );
   	   // testDistance( nInf, nInf, pInf, pInf, Double.POSITIVE_INFINITY );

   	   // testDistance( 0, 0, 0, nAn, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, 0, nAn, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( 0, nAn, 0, 0, Double.POSITIVE_INFINITY );
   	   // testDistance( nAn, 0, 0, 0, Double.POSITIVE_INFINITY );

   	   // testDistance( nAn, pInf, nInf, nAn, Double.POSITIVE_INFINITY );
   	   // testDistance( nAn, 0, 0, 0, Double.NaN );

   	   // testDistance( 1.7976931348623157E308, 0, 0, 0, 1.7976931348623157E308 );
   	   // testDistance( 0, 1.7976931348623157E308, 0, 0, 1.7976931348623157E308 ); 

   	   testDistance( 4.9E-324, 0, 0, 0, 4.9E-324 );
   	   testDistance( 0, 4.9E-324, 0, 0, 4.9E-324 );

   	   ct.println( "ct.distance tests done" );
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
   	   startTimeMs = ct.getTimer() - extraTimeMs;
   	   
   	   ct.println( "ct.getTimer() = "+ct.getTimer()+" when called from start()" );
   	}
   }
   
   public void runTests_getTimer( boolean run )
   {
   	if ( run )
   	{
   	   int currentMs = ct.getTimer();
   	   timerDisplay.setText( "Timer millis: " + (currentMs - startTimeMs) );
   	   int secondsTillRollover = countDownSec - ct.intDiv(currentMs, 1000);
   	   countDownDisplay.setText( "Countdown to rollover: " + secondsTillRollover );
   	}
   }
   
   public void runTests_getVersion( boolean run )
   {
   	if ( run )
   	{
   	   double ver = ct.getVersion();
   	   if ( ver != VERSION )
   	   {
   	   	allTestsPassed = false;
   	   	printError( "ct.getVersion() = " + ver + "; " + VERSION + " expected" );
   	   }
   	   ct.println( "ct.getVersion tests done" );
   	}
   }
   	
   public void runTests_toInt( boolean run )
   {
   	if ( run )
   	{
   	   testToInt( 2147483647 * 1.0, 2147483647 );
   	   testToInt( -2147483648 * 1.0, -2147483648 );

   	   ct.println( "(int) tests done" );
   	}
   }
   	
   public void runTests_parseInt( boolean run )
   {
   	if ( run )
   	{
   	   testParseInt( "" + 2147483647, 2147483647 );
   	   testParseInt( "" + -2147483648, -2147483648 );
   	   testParseInt( "5.0", 5 );

   	   ct.println( "ct.parseInt tests done" );
   	}
   }
   	
   public void runTests_canParseInt( boolean run )
   {
   	if ( run )
   	{
   	   testCanParseInt( "" + 2147483647, true );
   	   testCanParseInt( "" + -2147483648, true );
   	   testCanParseInt( "5.0", true );

   	   ct.println( "ct.canParseInt tests done" );
   	}
   }
   
   public void runTests_parseNumber( boolean run )
   {
   	if ( run )
   	{
   	   // testParseNumber( "" + 1.7976931348623157E308, 1.7976931348623157E308 );
   	   testParseNumber( "" + 4.9E-324, 4.9E-324 );
   	   // testParseNumber( "" + 1.0/0, Double.POSITIVE_INFINITY );
   	   // testParseNumber( "" + (-1.0/0), Double.NEGATIVE_INFINITY );
   	   	   	
   	   ct.println( "ct.parseNumber tests done" );
   	}
   }
   
   public void runTests_canParseNumber( boolean run )
   {
   	if ( run )
   	{
   	   testCanParseNumber( "" + 1.7976931348623157E308, true );
   	   testCanParseNumber( "" + 4.9E-324, true );
   	   testCanParseNumber( "" + 1.0/0, true );
   	   testCanParseNumber( "" + (-1.0/0), true );

   	   ct.println( "ct.canParseNumber tests done" );
   	}
   }
   
   public void runTests_formatDecimal( boolean run )
   {
   	if ( run )
   	{
   	   // if ( numPlaces <= 0 ), Math.rInt() rounds ties to the nearest event number.
   	   testFormatDecimalNumplaces( 2.5, 0, "2.0" );
   	   testFormatDecimalNumplaces( 1.5, 0, "2.0" );
   	   testFormatDecimalNumplaces( -3.5, 0, "-4.0" );
   	   testFormatDecimalNumplaces( -4.5, 0, "-4.0" );
   	   
   	   testFormatDecimalNumplaces( 1.0/0, 0, "Infinity" );
   	   testFormatDecimalNumplaces( -1.0/0, 0, "-Infinity" );
   	   testFormatDecimalNumplaces( 0.0/0, 0, "NaN" );
   	   testFormatDecimalNumplaces( Math.sqrt(-1), 0, "NaN" );
   	   
   	   ct.println( "ct.formatDecimal tests done" );
   	}
   }
   
   public void runTests_formatInt( boolean run )
   {
   	if ( run )
   	{
   	   testFormatIntNumplaces( 123, 0, "" );
   	   testFormatIntNumplaces( 456, -1, "" );
   	   testFormatIntNumplaces( 456, 1, "456" );

   	   ct.println( "ct.formatInt tests done" );
   	}
   }

   public static void main(String[] args)
   { 
      Code12.run(new MathMiscTypeConversionWhiteBoxTest());
   }
}
