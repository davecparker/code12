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
      // Reject test each side
      double minSize = 1; // 2 / game.getPixelsPerUnit();
      double halfW = lineWidthLU() / 2;
      boolean smallThickness = (halfW < minSize);
      boolean smallWidth = (smallThickness && width < minSize && width > -minSize);
      double left = boundingBoxLeft();
      if (smallWidth)
         left -= minSize;
      if (xPoint < left)
         return false;
      double right = boundingBoxRight();
      if (smallWidth)
         right += minSize;
      if (xPoint > right)
         return false;
      boolean smallHeight = (smallThickness && height < minSize && height > -minSize);
      double top =  boundingBoxTop();
      if (smallHeight)
         top -= minSize;
      if (yPoint < top)
         return false;
      double bottom = boundingBoxBottom();
      if (smallHeight)
         bottom += minSize;
      if (yPoint > bottom)
         return false;
      // Compare squared distance from point to line to squared halfwidth of line
      double d2 = squaredDistance(xPoint, yPoint);
     	if (halfW < minSize)
     		halfW = minSize;
      if (d2 > halfW * halfW)
      	return false;
      return true;
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
   	if ( width > 0)
   		return x;
   	if ( width < 0)
			return x + width;
		return x - lineWidthLU() / 2;
   }

   @Override
   protected double boundingBoxRight()
   {
   	if ( width > 0)
   		return x + width;
   	if ( width < 0)
			return x;
		return x + lineWidthLU() / 2;
   }

   @Override
   protected double boundingBoxTop()
   {
   	if ( height > 0)
   		return y;
   	if ( height < 0)
   		return y + height;
   	return y - lineWidthLU() / 2;
   }

   @Override
   protected double boundingBoxBottom()
   {
   	if ( height > 0)
			return y + height;
   	if ( height < 0)
			return y;
		return y + lineWidthLU() / 2;
   }

   //@Override
   protected boolean isLine()
   {
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
      // Line and obj's bounding rectangles are intersecting
      // Treat obj is line case different
  		if (obj.isLine())
  		{
  			// Check if both this line and obj are vertical or horizontal
			if (width == 0 || height == 0 )
      		if (obj.width == 0 || obj.height == 0)
      			return true;

      	// Calculate the intersection point
	   	double det = obj.height * width - obj.width * height;
	  		if (det == 0) // parallel lines and bounding boxes intersect
	  		{
	  			double minDist = (lineWidthLU() + obj.lineWidthLU()) / 2;
	  			return squaredDistance(obj.x, obj.y) <= minDist * minDist;
	  		}

			double t = ( obj.width * (y - obj.y) - obj.height * (x - obj.x) ) / det;
			if (t < 0 || t > 1)
				return false;

			double s = ( width * (y - obj.y) - height * (x - obj.x) ) / det;
			if (s < 0 || s > 1)
				return false;

			return true;
  		}
  		else // obj is not a line
  		{
  			// Check if this line is vertical or horizontal
			if (width == 0 || height == 0 )
				return true;
  			// Check for line hitting each side of obj
  			if (hitVertLine(left, right, objLeft, objTop, objBottom)) // left side
  				return true;
  			if (hitVertLine(left, right, objRight, objTop, objBottom)) // right side
  				return true;
  			if (hitHorizLine(top, bottom, objTop, objLeft, objRight)) // top side
  				return true;
  			if (hitHorizLine(top, bottom, objBottom, objLeft, objRight)) // bottom side
  				return true;
  			return false;
  		}
   }

   // Returns the squared distance from line to (xPoint, yPoint)
   protected double squaredDistance(double xPoint, double yPoint)
   {
      // Get squared distance from point to line (as squared length of normal vector from line to point)
      double ax = xPoint - x;
      double ay = yPoint - y;
      double bx = width;
      double by = height;
      double compAB = (ax * bx + ay * by)/(bx * bx + by * by);
      double nx = ax - bx * compAB;
      double ny = ay - by * compAB;
      return nx * nx + ny * ny;
   }

   // Determines if this line (from left to right) intersects a vertical line from (x2, top2) to (x1, bottom2)
   // Assumes top2 < bottom2 and this line is not vertical
   protected boolean hitVertLine(double left, double right, double x2, double top2, double bottom2)
   {
   	if (left > x2 || right < x2)
   		return false;
   	double yIntersect = height / width * (x2 - x) + y;
   	return top2 <= yIntersect && yIntersect <= bottom2;
   }

   // Determines if this line (from top to bottom) intersects a horizontal line from (left2, y2) to (right2, y2)
   // Assumes left2 < right2 and this line is not horizontal
   protected boolean hitHorizLine(double top, double bottom, double y2, double left2, double right2)
   {
   	if (top > y2 || bottom < y2)
   		return false;
   	double xIntersect = width / height * (y2 - y) + x;
   	return left2 <= xIntersect && xIntersect <= right2;
   }
}
