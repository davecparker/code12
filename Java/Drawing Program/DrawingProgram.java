import Code12.*;

class DrawingProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new DrawingProgram()); 
   }
   
   GameObj circle;         // clickable square for drawing circles
   GameObj ellipse;        // clickable square for drawing ellipses
   GameObj rectangle;      // clickable square for drawing rectangles
   GameObj line;           // clickable square for drawing lines
   GameObj selectedShape;  // box which is currently selected
   GameObj newShape;       // new shape currently being drawn
      
   public void start()
   {  
      ct.setTitle( "Drawing Program" );
      double boxSize = 5;
      double xBoxsStart = boxSize / 2;
      double yBoxs = boxSize / 2;
      GameObj iconImage;
      
      // Make circle icon
      circle = ct.rect( xBoxsStart, yBoxs, boxSize, boxSize, "white" );
      circle.clickable = true;
      iconImage = ct.circle( circle.x, circle.y, boxSize * 0.75 );
      
      // Make ellipse icon
      ellipse = ct.rect( circle.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      ellipse.clickable = true;
      iconImage = ct.circle( ellipse.x, ellipse.y, boxSize * 0.75 );
      iconImage.height *= 0.7;
      
      // Make rectangle icon
      rectangle = ct.rect( ellipse.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      rectangle.clickable = true;
      iconImage = ct.rect( rectangle.x, rectangle.y, boxSize * 0.75, boxSize * 0.75 );
      
      // Make line icon
      line = ct.rect( rectangle.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      line.clickable = true;
      iconImage = ct.line( line.x - boxSize * 0.35, line.y + boxSize * 0.35, line.x + boxSize * 0.35, line.y - boxSize * 0.35 );
      
      selectedShape = circle;
      selectedShape.setFillColor( "green" );
   }
   
   public void update()
   {
      if ( circle.clicked() || ellipse.clicked() || rectangle.clicked() || line.clicked() )
      {
         selectedShape.setFillColor( "white" );
         if ( circle.clicked() )
            selectedShape = circle;
         else if ( ellipse.clicked() )
            selectedShape = ellipse;
         else if ( rectangle.clicked() )
            selectedShape = rectangle;
         else if ( line.clicked() )
            selectedShape = line;
         selectedShape.setFillColor( "green" );
      }      
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( obj == null )
      {
         if ( selectedShape == circle || selectedShape == ellipse )
            newShape = ct.circle( x, y, 0 );
         else if ( selectedShape == rectangle )
            newShape = ct.rect( x, y, 0, 0 );
         else if ( selectedShape == line )
            newShape = ct.line( x, y, x, y );
            
         newShape.clickable = true;
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( obj == null )
      {
         if ( selectedShape == circle )
         {
            double newDiameter = 2 * ct.distance( newShape.x, newShape.y, x, y );
            newShape.width = newDiameter;
            newShape.height = newDiameter;
         }
         if ( selectedShape == ellipse || selectedShape == rectangle )
         {
            double newWidth = 2 * ct.distance( newShape.x, 0, x, 0 );
            double newHeight = 2 * ct.distance( 0, newShape.y, 0, y );
            newShape.width = newWidth;
            newShape.height = newHeight;
         }
         else
         {
            newShape.width = x - newShape.x;
            newShape.height = y - newShape.y;
         }
      }
   }
}
