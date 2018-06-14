import java.util.ArrayList;

import Code12.*;

public class LogMethods extends Code12Program
{
   ArrayList circles = new ArrayList();
   GameObj stationaryCircle;
   GameObj varCircle;
   GameObj expCircle;
   GameObj movingCircle;
   GameObj r;
   GameObj[][] rects;
   GameObj line;
   GameObj textArray[][];
   GameObj t;
   GameObj image;
   String s;
   public static void main(String[] args)
   {
      Code12.run(new LogMethods());
   }

   public void start()
   {
      s = "test";
      stationaryCircle = ct.circle(50,50,5);
      r = ct.rect( 75, 75, 10, 10 );
      line = ct.line(0, ct.getHeight()/2, ct.getWidth(), ct.getHeight()/2 );

      // Objs with variables as params
      double x = 10;
      double y = 25;
      double diam = 15;
      varCircle = ct.circle(x,y,diam);

      // Objs with expressions as params
      expCircle = ct.circle( x + 10, y * 2, diam / 3, "blue");
      
      // Moving objs
      movingCircle = ct.circle( 50, 50, 10, "purple" );
   }

   public void update()
   {
      stationaryCircle.delete(); // A GameObj is still logged even if it has been deleted ( since .delete()
                                 // only clears the screen of the object.
      movingCircle.xSpeed = 1;
      logCircles();
      genText();
      
      logMultiple();
      //logText();

   }

   public void logCircles()
   {
      ct.println("Circle one: ");
      ct.log(stationaryCircle);
      ct.println("Circle two: ");
      ct.log(varCircle);
      ct.println("Circle three: ");
      ct.log(expCircle);
      // Logging with a message
      
      ct.logm("There is a moving " + movingCircle );
      
      // test with public data fields in log()
      ct.logm("The moving circle's yPos is " + movingCircle.y );
      ct.logm("The moving circle's xPos is " + movingCircle.x );
      ct.logm("The moving circle's height is " + movingCircle.height );
      ct.logm("The moving circle's width is " + movingCircle.width );
      ct.logm("The circle is moving " + movingCircle.xSpeed + " pixels to the right." );
      
      
      if ( movingCircle.x > ct.getWidth() )
      {
         ct.logError("The circle is off-screen",s);
      }
   }

   public void logRects()
   {
      ct.log(r);
   }

   public void logLines()
   {
      ct.log(line);
   }

   public void logMultiple()
   {
      ct.log( stationaryCircle, r, line );
   }

   public void genText()
   {
      for ( int row = 0; row < ct.getWidth(); row += 30 )
      {
         for ( int column = 0; column < ct.getHeight(); column += 20 )
         {
            t = ct.text(" Lorem ipsem ", row, column, 5 );
         }
      }
   }
   public void logText()
   {
      ct.log(t);
   }

   public void logImage()
   {
   }

}
