package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;


// A line object that can be created in a Game
public class GameLine extends GameObj
{         
   // Construct a line that goes from (x, y) to (x2, y2)
   GameLine(Game game, double x, double y, double x2, double y2)
   {
      // Create the GameObj using signed size as offset for 2nd point
      super(game, x, y, x2 - x, y2 - y);
      type = "line";             
   }

   // Determine if point is inside the object
   @Override
   public boolean containsPoint(double xPoint, double yPoint)
   {
      return false;   // lines have no interior
   }
   
   // Update the object as necessary for a window resize from oldHeight to newHeight.
   @Override
   protected void updateForWindowResize(double oldHeight, double newHeight)
   {
      // Adjust y coordinate of both points if object has adjustY set
      if (adjustY)
      {
         double adjustFactor = (newHeight / oldHeight);
         y *= adjustFactor;
         height *= adjustFactor;
      }
   }

   // Draw the line into the given graphics surface
   protected void draw(Graphics2D g)
   {
      if (lineColor != null)
      {
         g.setStroke(new BasicStroke(lineWidth));
         g.setColor(lineColor);
         
         // Lines ignore alignment, and width and height 
         // are signed offsets to 2nd point.
         // Round to scaled pixel locations.
         double scale = game.scaleLToP;
         g.drawLine((int) ((x * scale) + 0.5), 
                    (int) ((y * scale) + 0.5), 
                    (int) (((x + width) * scale) + 0.5), 
                    (int) (((y + height) * scale) + 0.5));
      }
   }
}
