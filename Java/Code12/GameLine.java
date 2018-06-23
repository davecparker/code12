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

   // Determines if this line intersects a vertical line from (x2, yTop) to (x1, yBottom)
   // Assumes yTop < yBottom and this line is not vertical
   protected boolean hitVertLine(double x2, double yTop, double yBottom)
   {
   	double yIntersect = height / width * (x2 - x) + y;
   	return yTop <= yIntersect && yIntersect <= yBottom;

   }

   // Determines if this line intersects a horizontal line from (xLeft, y2) to (xRight, y2)
   // Assumes xLeft < xRight and this line is not horizontal
   protected boolean hitHorizLine(double y2, double xLeft, double xRight)
   {
   	double xIntersect = width / height * (y2 - y) + x;
   	return xLeft <= xIntersect && xIntersect <= xRight;

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
      // Case this line is vertical or horizontal
      if (width == 0 || height == 0)
      {
      	if (obj.isLine())
      	{
      		if (obj.width == 0 || obj.height == 0)
      			return true;

      		if (width == 0)
      			return objLeft <= x && x <= objRight;
      		else // isHorizontalLine() == true
      			return objTop <= y && y <= objBottom;
      	}
      	else
      		return true;
      }

  		if (obj.isLine())
  		{
  			double x1 = x;
   		double y1 = y;
   		double x2 = x + width;
   		double y2 = y + height;

			// Calculate the intersection point
	   	double det = obj.height * width - obj.width * height;
	  		if (det == 0) // parallel lines and bounding boxes intersect
	  			return true;

			double t = ( obj.width * (y - obj.y) - obj.height * (x - obj.x) ) / det;
			if (t < 0 || t > 1)
				return false;

			double s = ( width * (y - obj.y) - height * (x - obj.x) ) / det;
			if (s < 0 || s > 1)
				return false;

			return true;
  		}
  		else
  		{
  			// If line hits left side of bounding rect return true
  			if (hitVertLine(objLeft, objTop, objBottom))
  				return true;
  			// If line hits right side of bounding rect return true
  			if (hitVertLine(objRight, objTop, objBottom))
  				return true;
  			// If line hits top of bounding rect return true
  			if (hitHorizLine(objTop, objLeft, objRight))
  				return true;
  			// If line hits bottom of bounding rect return true
  			if (hitHorizLine(objBottom, objLeft, objRight))
  				return true;

  			return false;
  		}
   }

}
