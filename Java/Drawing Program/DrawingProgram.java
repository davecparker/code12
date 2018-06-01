import Code12.*;

class DrawingProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new DrawingProgram()); 
   }
   
   double boxSize;         // size of toolbox items
   
   GameObj circle;         // clickable square for drawing circles
   GameObj ellipse;        // clickable square for drawing ellipses
   GameObj rectangle;      // clickable square for drawing rectangles
   GameObj line;           // clickable square for drawing lines
   GameObj selectedShape;  // box which is currently selected
   GameObj newObj;         // new shape currently being drawn
   GameObj selectedObj;    // last drawn object clicked on
   
   GameObj black;
   GameObj white;
   GameObj red;
   GameObj green;
   GameObj blue;
   GameObj cyan;
   GameObj majenta;
   GameObj yellow;
   GameObj gray;
   GameObj orange;
   GameObj pink;
   GameObj purple;
   GameObj selectedColorSwatch;
   String selectedColor;
   
   double xMinColors;
      
   public void start()
   {  
      ct.setTitle( "Drawing Program" );
      boxSize = 5;
      double yBoxes = boxSize / 2;
      GameObj iconImage;
      
      // Make circle icon
      circle = ct.rect( boxSize / 2, yBoxes, boxSize, boxSize, "white" );
      circle.clickable = true;
      iconImage = ct.circle( circle.x, circle.y, boxSize * 0.75, "white" );
      circle.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make ellipse icon
      ellipse = ct.rect( circle.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      ellipse.clickable = true;
      iconImage = ct.circle( ellipse.x, ellipse.y, boxSize * 0.75, "white" );
      iconImage.height *= 0.7;
      ellipse.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make rectangle icon
      rectangle = ct.rect( ellipse.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      rectangle.clickable = true;
      iconImage = ct.rect( rectangle.x, rectangle.y, boxSize * 0.7, boxSize * 0.7, "white" );
      rectangle.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make line icon
      line = ct.rect( rectangle.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      line.clickable = true;
      iconImage = ct.line( line.x - boxSize * 0.35, line.y + boxSize * 0.35, line.x + boxSize * 0.35, line.y - boxSize * 0.35 );
      line.setLayer( 2 );
      iconImage.setLayer( 2 );
      
      // Make color boxes
      purple = ct.rect( 100 - boxSize / 2, yBoxes, boxSize, boxSize, "purple" );
      pink = ct.rect( purple.x - boxSize, yBoxes, boxSize, boxSize, "pink" );
      orange = ct.rect( pink.x - boxSize, yBoxes, boxSize, boxSize, "orange" );
      gray = ct.rect( orange.x - boxSize, yBoxes, boxSize, boxSize, "gray" );
      yellow = ct.rect( gray.x - boxSize, yBoxes, boxSize, boxSize, "yellow" );
      majenta = ct.rect( yellow.x - boxSize, yBoxes, boxSize, boxSize, "majenta" );
      cyan = ct.rect( majenta.x - boxSize, yBoxes, boxSize, boxSize, "cyan" );
      blue = ct.rect( cyan.x - boxSize, yBoxes, boxSize, boxSize, "blue" );
      green = ct.rect( blue.x - boxSize, yBoxes, boxSize, boxSize, "green" );
      red = ct.rect( green.x - boxSize, yBoxes, boxSize, boxSize, "red" );
      white = ct.rect( red.x - boxSize, yBoxes, boxSize, boxSize, "white" );
      black = ct.rect( white.x - boxSize, yBoxes, boxSize, boxSize, "black" );
      
      black.setLayer( 2 );
      white.setLayer( 2 );
      red.setLayer( 2 );
      green.setLayer( 2 );
      blue.setLayer( 2 );
      cyan.setLayer( 2 );
      majenta.setLayer( 2 );
      yellow.setLayer( 2 );
      gray.setLayer( 2 );
      orange.setLayer( 2 );
      pink.setLayer( 2 );
      purple.setLayer( 2 );
      
      black.clickable = true;
      white.clickable = true;
      red.clickable = true;
      green.clickable = true;
      blue.clickable = true;
      cyan.clickable = true;
      majenta.clickable = true;
      yellow.clickable = true;
      gray.clickable = true;
      orange.clickable = true;
      pink.clickable = true;
      purple.clickable = true;
      
      // Set xMinColors 
      xMinColors = black.x - boxSize / 2;
      
      // Set selected shape
      selectedShape = circle;
      // selectedShape.setFillColor( "green" );
      selectedShape.lineWidth = 3;      
      
      // Set selected color
      selectedColor = "black";
      selectedColorSwatch = black;
      selectedColorSwatch.lineWidth = 3;
   }
      
   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( obj == null && y > boxSize )
      {
         if ( selectedShape == circle || selectedShape == ellipse )
            newObj = ct.circle( x, y, 0 );
         else if ( selectedShape == rectangle )
            newObj = ct.rect( x, y, 0, 0 );
         else if ( selectedShape == line )
         {
            newObj = ct.line( x, y, x, y );
            newObj.setLineColor( selectedColor );
         }
         
         if ( selectedShape != line )
         {
            newObj.clickable = true;
            newObj.setFillColor( selectedColor );
         }
      }
      else if ( y > boxSize )
      {
         selectedObj = obj;
      }
      else if ( x >= xMinColors )
      {
         selectedColorSwatch.lineWidth = 1;
         selectedColorSwatch = obj;
         selectedColorSwatch.lineWidth = 3;
         selectedColorSwatch.setLayer( 2 );
         int colorNumber = ct.round( (selectedColorSwatch.x - xMinColors + boxSize / 2) / boxSize );
         if ( colorNumber == 1 )
            selectedColor = "black";
         else if ( colorNumber == 2 )
            selectedColor = "white";
         else if ( colorNumber == 3 )
            selectedColor = "red";
         else if ( colorNumber == 4 )
            selectedColor = "green";
         else if ( colorNumber == 5 )
            selectedColor = "blue";
         else if ( colorNumber == 6 )
            selectedColor = "cyan";
         else if ( colorNumber == 7 )
            selectedColor = "pink";
         else if ( colorNumber == 8 )
            selectedColor = "yellow";
         else if ( colorNumber == 9 )
            selectedColor = "gray";
         else if ( colorNumber == 10 )
            selectedColor = "orange";
         else if ( colorNumber == 11 )
            selectedColor = "pink";
         else if ( colorNumber == 12 )
            selectedColor = "purple";
      }
      else
      {
         selectedShape.lineWidth = 1;
         selectedShape = obj;
         selectedShape.lineWidth = 3;
         selectedColorSwatch.setLayer( 2 );
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( y > boxSize )
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
            else if ( selectedShape == line )
            {
               newObj.width = x - newObj.x;
               newObj.height = y - newObj.y;
            }
            newObj.group = "drawing";
         }
         else if ( obj.y > boxSize )
         {
            obj.x = x;
            obj.y = y;
            obj.setLayer( 1 );
         }
      }
   }
   
   public void onKeyPress( String keyName )
   {
      if (keyName.equals( "backspace" ) )
         if ( selectedObj != null )
            selectedObj.delete();
         else
            newObj.delete();
      else if ( keyName.equals( "c" ) )
         ct.clearGroup( "drawing" );
   }
}
