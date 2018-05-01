package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;


// A rectangle object that can be created in a Game
public class GameRect extends GameObj
{
   // Construct a rectangle at the given location and diameter
   GameRect(Game game, double x, double y, double width, double height)
   {
      // Create the GameObj at the right position and size
      super(game, x, y, width, height);
      type = "rect";
   }

   // Draw the rectangle into the given graphics surface
   protected void draw(Graphics2D g)
   {
      // Calculate drawing location considering alignment, and round to nearest pixel.
      double scale = game.scaleLToP;
      int leftP = (int) (((x - (width * xAlignFactor)) * scale) + 0.5);
      int topP = (int) (((y - (height * yAlignFactor)) * scale) + 0.5);
      int widthP = (int) ((width * scale) + 0.5);
      int heightP = (int) ((height * scale) + 0.5);
               
      // Fill the circle if fillColor is not null
      if (fillColor != null)
      {
         g.setColor(fillColor);
         g.fillRect(leftP, topP, widthP, heightP);
      }
      
      // Outline the circle if lineColor is not null
      if (lineColor != null)
      {
         g.setStroke(new BasicStroke(lineWidth));
         g.setColor(lineColor);
         g.drawRect(leftP, topP, widthP, heightP);
      }
   }
}
