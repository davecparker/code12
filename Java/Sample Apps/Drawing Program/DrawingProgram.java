// Drawing Program
// Code12 Programming Concepts 8: If-else

// A simple program for drawing circles, ovals, rectangles, and lines.
// Clicking the toolbar buttons at the top of the window sets the shape and color drawn.
// Clicking and draging the mouse draws a new shape centered at the click and scaled to 
// extend to the end of the drag.
// Clicking and dragging a drawn shape moves it around the window.
// The backspace key deletes a drawn shape after it is clicked on.
// The "C" key clears all drawn shapes from the window.

// Case use test for the following subset of the Code12 API:

// Math and Misc.
// --------------
// double ct.distance( double x1, double y1, double x2, double y2 )

import Code12.*;

class DrawingProgram extends Code12Program
{  
   double boxSize;         // size of toolbox items
   
   GameObj circle;         // clickable square for drawing circles
   GameObj ellipse;        // clickable square for drawing ellipses
   GameObj rectangle;      // clickable square for drawing rectangles
   GameObj line;           // clickable square for drawing lines
   GameObj selectBox;      // clickable square for selecting drawn shapes
   GameObj selectedShapeBox;  // box which is currently selected
   GameObj newObj;         // new shape currently being drawn
   GameObj selectedObj;    // last drawn object clicked on

   // clickable squares for selecting fill/line color
   GameObj black; 
   GameObj white; 
   GameObj red;
   GameObj green;
   GameObj blue;
   GameObj cyan;
   GameObj magenta;
   GameObj yellow;
   GameObj gray;
   GameObj orange;
   GameObj pink;
   GameObj purple;
   GameObj selectedColorSwatch; // which color square has been selected
   String selectedColor;        // which color has been selected
   
   double xMinColors;
   boolean selectBoxOn;
   double dxClick, dyClick; // initial displacement between obj.x, obj.y and click.x, click.y 
      
   public void start()
   {
      ct.setTitle( "Drawing Program" );
      boxSize = 5;
      double yBoxes = boxSize / 2;
      GameObj iconImage;
     
      // Make circle icon
      circle = ct.rect( boxSize / 2, yBoxes, boxSize, boxSize, "white" );
      iconImage = ct.circle( circle.x, circle.y, boxSize * 0.75, "white" );
      iconImage.setClickable( false );
      circle.setLayer( 2 );
      iconImage.setLayer( 3 );
      
      // Make ellipse icon
      ellipse = ct.rect( circle.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      iconImage = ct.circle( ellipse.x, ellipse.y, boxSize * 0.75, "white" );
      iconImage.setClickable( false );
      iconImage.setSize( iconImage.getWidth(), iconImage.getHeight() * 0.7 );
      ellipse.setLayer( 2 );
      iconImage.setLayer( 3 );
      
      // Make rectangle icon
      rectangle = ct.rect( ellipse.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      iconImage = ct.rect( rectangle.x, rectangle.y, boxSize * 0.7, boxSize * 0.7, "white" );
      iconImage.setClickable( false );
      rectangle.setLayer( 2 );
      iconImage.setLayer( 3 );
      
      // Make line icon
      line = ct.rect( rectangle.x + boxSize, yBoxes, boxSize, boxSize, "white" );
      iconImage = ct.line( line.x - boxSize * 0.35, line.y + boxSize * 0.35, line.x + boxSize * 0.35, line.y - boxSize * 0.35 );
      iconImage.setClickable( false );
      line.setLayer( 2 );
      iconImage.setLayer( 3 );
      
      // Make arrow icon for selecting objects
      selectBox = ct.rect( line.x + boxSize * 2, yBoxes, boxSize, boxSize, "white" );
      iconImage = ct.image( "arrow.png", selectBox.x, selectBox.y, boxSize );
      selectBox.setLayer( 2 );
      iconImage.setLayer( 3 );
      iconImage.setClickable( false );
      
      // Make color boxes
      purple = ct.rect( 100 - boxSize / 2, yBoxes, boxSize, boxSize, "purple" );
      pink = ct.rect( purple.x - boxSize, yBoxes, boxSize, boxSize, "pink" );
      orange = ct.rect( pink.x - boxSize, yBoxes, boxSize, boxSize, "orange" );
      gray = ct.rect( orange.x - boxSize, yBoxes, boxSize, boxSize, "gray" );
      yellow = ct.rect( gray.x - boxSize, yBoxes, boxSize, boxSize, "yellow" );
      magenta = ct.rect( yellow.x - boxSize, yBoxes, boxSize, boxSize, "magenta" );
      cyan = ct.rect( magenta.x - boxSize, yBoxes, boxSize, boxSize, "cyan" );
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
      magenta.setLayer( 2 );
      yellow.setLayer( 2 );
      gray.setLayer( 2 );
      orange.setLayer( 2 );
      pink.setLayer( 2 );
      purple.setLayer( 2 );
           
      black.setText( "black" );
      white.setText( "white" );
      red.setText( "red" );
      green.setText( "green" );
      blue.setText( "blue" );
      cyan.setText( "cyan" );
      magenta.setText( "magenta" );
      yellow.setText( "yellow" );
      gray.setText( "gray" );
      orange.setText( "orange" );
      pink.setText( "pink" );
      purple.setText( "purple" );
      
      // Set xMinColors 
      xMinColors = black.x - boxSize / 2;
      
      // Set selected shape
      selectedShapeBox = circle;
      selectedShapeBox.setLineWidth( 3 );
      selectBoxOn = false;
      
      // Set selected color
      selectedColor = "black";
      selectedColorSwatch = black;
      selectedColorSwatch.setLineWidth( 3 );

      ct.println( "Backspace: delete selected object" );
      ct.println( "c: clear the canvas" );
   }

   public void update()
   {
      
   }
      
   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( y > boxSize + 1 ) 
      {
         // click is in the drawing area below the toolbox row
         if ( !selectBoxOn )
         {       
            // draw a new shape
            if ( selectedShapeBox == circle || selectedShapeBox == ellipse )
               newObj = ct.circle( x, y, 0, selectedColor );
            else if ( selectedShapeBox == rectangle )
               newObj = ct.rect( x, y, 0, 0, selectedColor );
            else if ( selectedShapeBox == line )
            {
               newObj = ct.line( x, y, x, y, selectedColor );
            }
            newObj.group = "drawing";
            // Make newObj the selectedObj
            selectedObj = newObj;
         }
         else if ( obj != null )
         {
            // Set selected object and bring to front
            selectedObj = obj;
            dxClick = x - obj.x;
            dyClick = y - obj.y;
            obj.setLayer( 1 );
         }
      }
      else if ( obj != null )
      {
         if ( x >= xMinColors )
         {
            // obj is a color swatch
            selectedColorSwatch.setLineWidth( 1 );
            selectedColorSwatch = obj;
            selectedColorSwatch.setLineWidth( 3 );
            selectedColorSwatch.setLayer( 2 );
            selectedColor = selectedColorSwatch.getText();
            if ( selectedObj != null )
            {
               // if ( selectedObj.getType().equals( "line" ) )
               String selectedObjType = selectedObj.getType();
               if ( selectedObjType.equals( "line" ) )
                  selectedObj.setLineColor( selectedColor );
               else
                  selectedObj.setFillColor( selectedColor );
            }
         }
         else
         {
            // obj is a shape selector or the select box
            selectedShapeBox.setLineWidth( 1 );
            selectedShapeBox = obj;
            selectedShapeBox.setLineWidth( 3 );
            selectedShapeBox.setLayer( 2 );
            if ( obj == selectBox )
               selectBoxOn = true;
            else
               selectBoxOn = false;
         }
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( newObj != null )
      {
         // Move object being drawn
         if ( selectedShapeBox == circle )
         {
            double newDiameter = 2 * ct.distance( newObj.x, newObj.y, x, y );
            newObj.setSize( newDiameter, newDiameter );
         }
         else if ( selectedShapeBox == ellipse || selectedShapeBox == rectangle )
         {
            double newWidth = 2 * ct.distance( newObj.x, 0, x, 0 );
            double newHeight = 2 * ct.distance( 0, newObj.y, 0, y );
            newObj.setSize( newWidth, newHeight );
         }
         else if ( selectedShapeBox == line )
         {
            newObj.setSize( x - newObj.x, y - newObj.y );
         }
      }
      else if ( obj != null && obj.group.equals( "drawing" ) )
      {
         // Move drawing object with drag
         obj.x = x - dxClick;
         obj.y = y - dyClick;
      }
   }
   
   public void onMouseRelease( GameObj obj, double x, double y )
   {
      if ( newObj != null )
      {
         selectedObj = newObj;
         newObj = null;
      }
   }

   public void onKeyPress( String keyName )
   {
      if ( keyName.equals( "backspace" ) )
      {
         // Delete selected drawing object
         if ( selectedObj != null )
            selectedObj.delete();
      }
      else if ( keyName.equals( "c" ) )
      {
         // Clear the canvas
         ct.clearGroup( "drawing" );
      }
   }
   
   public static void main( String[] args )
   { 
      Code12.run( new DrawingProgram() ); 
   }
}
