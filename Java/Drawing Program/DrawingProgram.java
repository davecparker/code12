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
   GameObj newObj;         // new shape currently being drawn
   GameObj selectedObj;    // last drawn object clicked on
      
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
      circle.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make ellipse icon
      ellipse = ct.rect( circle.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      ellipse.clickable = true;
      iconImage = ct.circle( ellipse.x, ellipse.y, boxSize * 0.75 );
      iconImage.height *= 0.7;
      ellipse.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make rectangle icon
      rectangle = ct.rect( ellipse.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      rectangle.clickable = true;
      iconImage = ct.rect( rectangle.x, rectangle.y, boxSize * 0.7, boxSize * 0.7 );
      rectangle.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make line icon
      line = ct.rect( rectangle.x + boxSize, yBoxs, boxSize, boxSize, "white" );
      line.clickable = true;
      iconImage = ct.line( line.x - boxSize * 0.35, line.y + boxSize * 0.35, line.x + boxSize * 0.35, line.y - boxSize * 0.35 );
      line.setLayer( 2 );
      iconImage.setLayer( 2 );
      
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
            newObj = ct.circle( x, y, 0 );
         else if ( selectedShape == rectangle )
            newObj = ct.rect( x, y, 0, 0 );
         else if ( selectedShape == line )
            newObj = ct.line( x, y, x, y );
            
         newObj.clickable = true;
      }
      else if ( obj != circle && obj != ellipse && obj != rectangle && obj != line )
      {
         selectedObj = obj;
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( obj == null )
      {
         if ( selectedShape == circle )
         {
            double newDiameter = 2 * ct.distance( newObj.x, newObj.y, x, y );
            newObj.width = newDiameter;
            newObj.height = newDiameter;
         }
         else if ( selectedShape == ellipse || selectedShape == rectangle )
         {
            double newWidth = 2 * ct.distance( newObj.x, 0, x, 0 );
            double newHeight = 2 * ct.distance( 0, newObj.y, 0, y );
            newObj.width = newWidth;
            newObj.height = newHeight;
         }
         else
         {
            newObj.width = x - newObj.x;
            newObj.height = y - newObj.y;
         }
      }
      else if ( obj != circle && obj != ellipse && obj != rectangle && obj != line )
      {
         obj.x = x;
         obj.y = y;
      }
   }
   
   public void onKeyPress( String keyName )
   {
      if (keyName.equals( "backspace" ) && selectedObj != null )
         selectedObj.delete();
      else
         newObj.delete();
   }
}
