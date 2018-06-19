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
// int ct.toInt( double d )                // truncates
// int ct.parseInt( String s )             // 0 if failure
// boolean ct.canParseInt( String s )
// double ct.parseNumber( String s )       // NaN if failure
// boolean ct.canParseNumber( String s )
// String ct.formatDecimal( double d, int numPlaces )
// String ct.formatInt( int i, int numDigits )    // uses leading 0's

import Code12.*;

class Stopwatch extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new Stopwatch()); 
   }
   
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
      timeDisplay = ct.text( "00:00:00.00", 50, timeHeight, timeHeight );
      timeDisplay.align( "bottom" );
      
      // Make start button
      double buttonHeight = 10;
      double buttonOffset = 15;
      startButton = ct.text( "Start", timeDisplay.x - buttonOffset, timeDisplay.y + buttonHeight, buttonHeight );
      startButton.align( "bottom" );
      startButton.clickable = true;
      
      // Make stop button
      stopButton = ct.text( "Stop", startButton.x, startButton.y, buttonHeight );
      stopButton.align( "bottom" );
      stopButton.clickable = true;
      stopButton.visible = false;
      
      // Make reset button
      resetButton = ct.text( "Reset", timeDisplay.x + buttonOffset, startButton.y, buttonHeight );
      resetButton.align( "bottom" );
      resetButton.clickable = true;
      resetButton.visible = false;
      
      // Make lap button
      lapButton = ct.text( "Lap", resetButton.x, resetButton.y, buttonHeight );
      lapButton.align( "bottom" );
      lapButton.clickable = true;
      lapButton.visible = false;
      
      // Initialize state and count variables
      stopwatchRunning = false;
      lapCount = 0;
      lapStartTime = 0;
      pauseTime = 0;
   }
   
   public void update()
   {
      if ( stopwatchRunning )
      {
         // Update timeDisplay
         double seconds = ( ct.getTimer() - startTime ) / 1000.0;          
         int elapsedTime = ct.toInt( seconds );
         int hours = elapsedTime / 3600;
         elapsedTime %= 3600;
         int minutes = elapsedTime / 60;
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
         
         // Factor in the current time on the stopwatch
         String displayedTime = timeDisplay.getText();
         if ( !displayedTime.equals("00:00:00.00") )
         {
            String hrs = displayedTime.substring(0, 2);
            String min = displayedTime.substring(3, 5);
            String sec = displayedTime.substring(6, 11);
            if ( !ct.canParseInt(hrs) )
               ct.println( "Can't parse hrs" );
            int hours = ct.parseInt( hrs );
            
            if ( !ct.canParseInt(min) )
               ct.println( "Can't parse min" );
            int minutes = ct.parseInt( min );
            
            if ( !ct.canParseNumber(sec) )
               ct.println( "Can't parse sec" );
            double seconds = ct.parseNumber( sec );

            startTime -= ct.toInt( (hours * 3600 + minutes * 60 + seconds) * 1000 );
         }
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
            int elapsedTime = ct.toInt( seconds );
            int hours = elapsedTime / 3600;
            elapsedTime %= 3600;
            int minutes = elapsedTime / 60;
            seconds = seconds - hours * 3600 - minutes * 60;
            String hrs = ct.formatInt( hours, 2 );
            String min = ct.formatInt( minutes, 2 );
            String sec = ct.formatDecimal( seconds, 2 );
            if (seconds < 10)
               sec = "0" + sec;
            lapLengthText = hrs + ":" + min + ":" + sec; 
         }
         String lapText = lapCount + "  " + timeText + " (+" + lapLengthText + ")";
         double lapHeight = 8;
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
