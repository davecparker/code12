package Code12;  // Copyright (c) 2018-2019 Code12 

import java.awt.*;


// A circle object that can be created in a Game
public class GameCircle extends GameObj
{
   // Construct a circle at the given location and diameter
   GameCircle(Game game, double x, double y, double diameter)
   {
      // Create the GameObj at the right position and size
      super(game, x, y, diameter, diameter);
      type = "circle";
   }

   // Determine if point is inside the object
   @Override
   public boolean containsPoint(double xPoint, double yPoint)
   {
      // Reject test rectangular bounds first
      if (!super.containsPoint(xPoint, yPoint))
         return false;
         
      // Find ellipse center point considering alignment 
      double xCenter = x + (width * (0.5 - xAlignFactor)); 
      double yCenter = y + (height * (0.5 - yAlignFactor));
      
      // Test for point inside ellipse
      double dx = xPoint - xCenter;
      double dy = yPoint - yCenter;
      return (dx * dx) / (width * width) 
           + (dy * dy) / (height * height) <= 0.25; 
   }

   // Draw the circle (or oval) into the given graphics surface
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
         g.fillOval(leftP, topP, widthP, heightP);
      }
      
      // Outline the circle if lineColor is not null
      if (lineColor != null)
      {
         g.setStroke(new BasicStroke(lineWidth));
         g.setColor(lineColor);
         g.drawOval(leftP, topP, widthP, heightP);
      }
   }
}
