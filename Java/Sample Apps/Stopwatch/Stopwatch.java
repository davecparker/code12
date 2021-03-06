// Stopwatch
// Code12 Programming Concepts 8: If-else

// A stopwatch app with lap functionality.

// Case use test for the following subset of the Code12 API:
// Screen Management
// -----------------
// ct.setTitle( String title )
// ct.setHeight( double height )
// double ct.getHeight( ) 
// ct.clearGroup( String group )
// ct.setBackColor( String color )
// 
// Math and Misc.
// --------------
// int ct.getTimer( )
// 
// Type Conversion
// ---------------
// int (int)( double d )                // truncates
// int ct.parseInt( String s )             // 0 if failure
// boolean ct.canParseInt( String s )
// double ct.parseNumber( String s )       // NaN if failure
// boolean ct.canParseNumber( String s )
// String ct.formatDecimal( double d, int numPlaces )
// String ct.formatInt( int i, int numDigits )    // uses leading 0's

import Code12.*;

class Stopwatch extends Code12Program
{
   // public static void main(String[] args)
   // { 
   //    Code12.run(new Stopwatch()); 
   // }
   
   GameObj timeDisplay; // Display for time elapsed
   GameObj startButton; // Button for starting the stopwatch
   GameObj stopButton; // Button for stopping the stopwatch
   GameObj lapButton; // Button for starting a new lap;
   GameObj resetButton; // Button for resetting the stopwatch
   int startTime; // Start time of start buttom being pressed in milliseconds since the app was started;
   int lapStartTime; // Start time of a lap in milliseconds since the app was started;
   int pauseTime; // Start time of a pause in milliseconds since the app was started;
   int pauseLength; // How long the stopwatch has been paused in milliseconds;
   boolean stopwatchRunning; // true when the stopwatch is running
   int lapCount; // Count of how many laps have been created
   
   public void start()
   {  
      // Make the title and background
      ct.setTitle( "Stopwatch" );
      ct.setBackColor( "light blue" );
   
      // Make time display
      double timeHeight = 15;
      timeDisplay = ct.text( "00:00:00.00", 0, timeHeight, timeHeight );
      timeDisplay.x = 50 - timeDisplay.getWidth() / 2;
      timeDisplay.align( "bottom left" );
      
      // Make start button
      double buttonHeight = 10;
      double buttonOffset = 15;
      startButton = ct.text( "Start", 50 - buttonOffset, timeDisplay.y + buttonHeight, buttonHeight );
      startButton.align( "bottom" );

      
      // Make stop button
      stopButton = ct.text( "Stop", startButton.x, startButton.y, buttonHeight );
      stopButton.align( "bottom" );

      stopButton.visible = false;
      
      // Make reset button
      resetButton = ct.text( "Reset", 50 + buttonOffset, startButton.y, buttonHeight );
      resetButton.align( "bottom" );

      resetButton.visible = false;
      
      // Make lap button
      lapButton = ct.text( "Lap", resetButton.x, resetButton.y, buttonHeight );
      lapButton.align( "bottom" );

      lapButton.visible = false;
      
      // Initialize state and count variables
      stopwatchRunning = false;
      startTime = 0;
      lapCount = 0;
      lapStartTime = 0;
      pauseTime = 0;
      pauseLength = 0;
   }
   
   public void update()
   {
      if ( stopwatchRunning )
      {
         // Update timeDisplay
         double seconds = ( ct.getTimer() - startTime ) / 1000.0;          
         int elapsedTime = (int)( seconds );
         int hours = ct.intDiv( elapsedTime, 3600 );
         elapsedTime = elapsedTime % 3600;
         int minutes = ct.intDiv(elapsedTime, 60);
         seconds = seconds - hours * 3600 - minutes * 60;
         String hrs = ct.formatInt( hours, 2 );
         String min = ct.formatInt( minutes, 2 );
         String sec = ct.formatDecimal( seconds, 2 );
         if (seconds < 10)
            sec = "0" + sec;
         timeDisplay.setText( hrs + ":" + min + ":" + sec );         
      }       
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( obj == startButton )
      {
         stopwatchRunning = true;
         startButton.visible = false;
         stopButton.visible = true;
         lapButton.visible = true;
         resetButton.visible = false;
         
         startTime = ct.getTimer();
         if ( pauseTime != 0 )
         {
            pauseLength += startTime - pauseTime;
         }
         if ( lapStartTime == 0 )
         {
            lapStartTime = startTime;
         }
         startTime -= pauseLength;
      }
      else if ( obj == stopButton )
      {
         pauseTime = ct.getTimer();
         stopwatchRunning = false;
         startButton.visible = true;
         stopButton.visible = false;
         lapButton.visible = false;
         resetButton.visible = true;
      }
      else if ( obj == resetButton )
      {
         timeDisplay.setText( "00:00:00.00" );
         resetButton.visible = false;
         lapCount = 0;
         lapStartTime = 0;
         pauseTime = 0;
         ct.clearGroup( "laps" );
         ct.setHeight( 100 );
      }
      else if ( obj == lapButton )
      {
         lapCount++;
         int time = ct.getTimer();
         int lapLength = time - lapStartTime - pauseLength; 
         lapStartTime = time;
         pauseLength = 0;
         String timeText = timeDisplay.getText();
         String lapLengthText;
         if ( lapCount == 1 )
         {
            lapLengthText = timeText;
         }
         else
         {
            // Convert lapLength to lapLengthText
            double seconds =  lapLength / 1000.0;          
            int elapsedTime = (int)( seconds );
            int hours = ct.intDiv( elapsedTime, 3600 );
            elapsedTime = elapsedTime % 3600;
            int minutes = ct.intDiv( elapsedTime, 60 );
            seconds = seconds - hours * 3600 - minutes * 60;
            String hrs = ct.formatInt( hours, 2 );
            String min = ct.formatInt( minutes, 2 );
            String sec = ct.formatDecimal( seconds, 2 );
            if (seconds < 10)
               sec = "0" + sec;
            lapLengthText = hrs + ":" + min + ":" + sec; 
         }
         String lapText = lapCount + "  " + timeText + " (+" + lapLengthText + ")";
         double lapHeight = 7; // Height of lap display texts
         double xLap = 90;
         double yLap = startButton.y + lapHeight * lapCount;
         GameObj lapDisplay = ct.text( lapText, xLap, yLap, lapHeight );
         lapDisplay.group = "laps";
         lapDisplay.align( "bottom right" );
         if ( yLap > ct.getHeight() )
            ct.setHeight( yLap );
      }
   }   
}
