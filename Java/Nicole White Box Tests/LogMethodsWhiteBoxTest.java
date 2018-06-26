import Code12.*;

public class LogMethodsWhiteBoxTest extends Code12Program
{
   GameObj stationaryCircle;
   GameObj varCircle;
   GameObj expCircle;
   GameObj movingCircle;
   GameObj stationaryRect;
   GameObj[] rectangles;
   GameObj line;
   GameObj t;
   GameObj image;
   GameObj movingImage;
   String s;
   
   GameObj circleOne;
   GameObj circleTwo;
   
   GameObj tempObj;
   int count = 0;
   
   public static void main(String[] args)
   {
      Code12.run(new LogMethodsWhiteBoxTest());
   }

   public void start()
   {
      ct.setTitle("LogMethods, not to be confused with logarithms");
      
      s = "test";
      stationaryCircle = ct.circle(50,50,5);
      stationaryRect = ct.rect( 75, 75, 10, 10 );
      line = ct.line(0, ct.getHeight()/2, ct.getWidth(), ct.getHeight()/2 );
      image = ct.image("sprite.png", 90, 10, 10 );
      movingImage = ct.image("pikachu.png", 90, 90, 10 );
      
      rectangles = new GameObj[10];
      // Some rectangles stored in an array
      for ( int i = 0; i < rectangles.length; i++ )
      {
         rectangles[i] = ct.rect( ct.random(10,100), ct.random(10,100), 10, 10, "pink");
      }
      
      // Objs with variables as params
      double x = 10;
      double y = 25;
      double diam = 15;
      varCircle = ct.circle(x,y,diam);

      // Objs with expressions as params
      expCircle = ct.circle( x + 10, y * 2, diam / 3, "blue");
      
      // Moving objs
      movingCircle = ct.circle( 50, 50, 10, "purple" );
      
      // temporary logged objects
      tempObj = ct.rect(10,10,10,10);
      
      // Two circles in the same position/same size
      circleOne = ct.circle(40,40,10);
      circleTwo = ct.circle(40,40,10);
      
      // Testing logging until a certain event happens
      // count-controlled:
      do
      {
         ct.logm("This object will be logged 5 times ", tempObj);
         // java : this will compile + run concatenating
         // ct.logm("message " + obj )
         count++;
      }
      while ( count <= 5 );
   }

   public void update()
   {
      //stationaryCircle.delete(); // A GameObj is still logged even if it has been deleted ( since .delete()
                                 // only clears the screen of the object.
      movingCircle.xSpeed = 1;
      movingImage.ySpeed = -2;
      
      if ( movingCircle.x > ct.getWidth() )
         movingCircle.x = 0;
      if ( movingImage.y < 0 )
         movingImage.y = ct.getHeight();
         
      
      // Testing logging until logical events occur
      // ex: start logging circles once movingCircle reaches max height
      if ( movingCircle.y <= 0 )
         logCircles();
         
      logCircleAlongLine();
      logRects();
      logRectArray();  
      logLines();
      logMultiple();
      logOverlapping();
      genText();
      logText();
      logImage();

   }

   void logCircles()
   {
      ct.println("Circle one: ");
      ct.log(stationaryCircle);
      ct.println("Circle two: ");
      ct.log(varCircle);
      ct.println("Circle three: ");
      ct.log(expCircle);
      
      // Printing with a message using the .toString() method
      ct.println("There is a moving " + movingCircle.toString() );
      
      // Test with public data fields in ct.println()
      ct.println("The moving circle's yPos is " + movingCircle.y );
      ct.println("The moving circle's xPos is " + movingCircle.x );
      ct.println("The moving circle's height is " + movingCircle.height );
      ct.println("The moving circle's width is " + movingCircle.width );
      ct.println("The circle is moving " + movingCircle.xSpeed + " pixels to the right." );
      
   }
   
   void logCircleAlongLine()
   {
      for ( int xValue = 0; xValue < ct.getWidth(); xValue++ )
      {
         // Makeshift collsion detection for line
         if ( movingCircle.containsPoint(xValue,ct.getHeight()/2) )
            ct.println("There is a " + movingCircle.toString() + " moving along a " + line.toString() );
      }
   }

   void logRects()
   {
      ct.log(stationaryRect);
   }
   
   void logRectArray()
   {
      for ( int i = 0; i < rectangles.length;i++)
      {
         ct.log( rectangles[i] );
      }
   }

   void logLines()
   {
      ct.log(line);
   }

   void logMultiple()
   {
      int one = 1;
      int two = 2;
      int three = 3;
      
      ct.log( stationaryCircle, stationaryRect, line );
      // ct.logm(" one " + stationaryCircle, "two " + stationaryRect, " three " + line );
//       // The first one is logged as a message (which it should be)
//       // With the following arguments - 
//       //    when adding other strings alongside the String representation of a gameObj
//       //    both those and the gameObj are printed as String literals
// 
//       ct.logm( "one", "two", "three");
      // Again, when using ct.logm to print, only the first argument is converted internally
      // rest are represented as String literals
      
      // Example of a potential use that would be caught as an error (incompatible data types)
      // ct.logm( one + stationaryCircle, two + stationaryRect, three + line );
   }
   
   void logOverlapping()
   {
      // Test with two overlapping circles ( both conditions are true )
      if ( circleOne.containsPoint(circleTwo.x, circleTwo.y) )
         ct.println("Logging the first circle " + circleOne.toString() );
      if ( circleOne.hit(circleTwo) )
         ct.println("Logging the second circle " + circleTwo.toString() );
   }

   void genText()
   {
      for ( int row = 0; row < ct.getWidth(); row += 30 )
      {
         for ( int column = 0; column < ct.getHeight(); column += 20 )
         {
            t = ct.text(" Lorem ipsem ", row, column, 5 );
         }
      }
   }
   
   // Logging text objects created in the function above
   void logText()
   {
      ct.log(t);
      // Logs the most recently generated text, since there is no reference to the others
   }

   void logImage()
   {
      ct.log(image);
      ct.logm("There is a moving ", movingImage);
   }

}
