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

   @Override
   protected double boundingBoxLeft()
   {
   	if ( width < 0)
			return x + width;
		return x;
   }

   @Override
   protected double boundingBoxRight()
   {
   	if ( width < 0)
			return x;
		return x + width;

   }

   @Override
   protected double boundingBoxTop()
   {
   	if ( height < 0)
   		return y + height;
   	return y;
   }

   @Override
   protected double boundingBoxBottom()
   {
   	if ( height < 0)
			return y;
		return y + height;
   }

   //@Override
   protected boolean isLine()
   {
   	return true;
   }

   // Tests if this line hits another line from (x3,y3) to (x4,y4)
	protected boolean hitLine(double x3, double y3, double x4, double y4)
   {
   	double x1 = x;
   	double y1 = y;
   	double x2 = x + width;
   	double y2 = y + height;

		// Calculate the distance to intersection point
   	double d = (y4-y3)*(x2-x1) - (x4-x3)*(y2-y1);

		double uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / d;
		if (uA < 0 || uA > 1)
			return false;

		double uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / d;
		if (uB < 0 || uB > 1)
			return false;

		return true;
   }

   // Determine if the line has hit another GameObj
   @Override
   public boolean hit(GameObj obj)
   {
   	// If the line and obj's bounding rectangles don't intersect then no hit has occured
     	double left = boundingBoxLeft();
      double objRight = obj.boundingBoxRight();
      if (objRight < left)
         return false;

   	double right = boundingBoxRight();
   	double objLeft = obj.boundingBoxLeft();
      if (objLeft > right)
         return false;

      double top = boundingBoxTop();
      double objBottom = obj.boundingBoxBottom();
      if (objBottom < top)
         return false;

      double bottom = boundingBoxBottom();
      double objTop = obj.boundingBoxTop();
      if (objTop > bottom)
         return false;

      // Line and obj's bounding rectangels are intersecting
      if (isVerticalLine() || isHorizontalLine())
      	if (!obj.isLine())
      		return true;

  		if (obj.isLine())
  			return hitLine(obj.x, obj.y, obj.x + obj.width, obj.y + obj.height);
  		else
  		{
  			// If line hits left side of bounding rect return true
  			if (hitLine(objLeft, objTop, objLeft, objBottom))
  				return true;
  			// If line hits right side of bounding rect return true
  			if (hitLine(objRight, objTop, objRight, objBottom))
  				return true;
  			// If line hits top of bounding rect return true
  			if (hitLine(objLeft, objTop, objRight, objTop))
  				return true;
  			// If line hits bottom of bounding rect return true
  			if (hitLine(objLeft, objBottom, objRight, objBottom))
  				return true;
  			return false;
  		}
   }

   @Override
   protected boolean isHorizontalLine()
   {
   	double epsilon = 0.001;
   	return -epsilon < width && width < epsilon;
   }

   @Override
   protected boolean isVerticalLine()
   {
   	double epsilon = 0.001;
   	return -epsilon < height && height < epsilon;
   }

}
