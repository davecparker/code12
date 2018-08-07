// Events Use Case of:
// onMousePress()
// onMouseDrag()
// Level 10: User-defined Functions

import Code12.*;

public class Paint extends Code12Program
{
   String currentColor = "blue";    // Default color
   String highlite = "yellow";
   GameObj brush;
   // circle to bound lines
   GameObj c;
   double lastX, lastY;
   // Rectangles to contain the colors
   GameObj palette;
   GameObj redRect;
   GameObj orangeRect;
   GameObj yellowRect;
   GameObj greenRect;
   GameObj blueRect;
   GameObj indigoRect;
   GameObj purpleRect;
   GameObj magentaRect;
   GameObj eraseRect;
   
   // Objects to be used to change brush size
   GameObj small;
   GameObj medium;
   GameObj large;
   double size = 6;     // Default size is small
   
   public static void main(String[] args)
   { 
      Code12.run(new Paint()); 
   }
   
   public void start()
   {
      double gameWidth = ct.getWidth();
      double gameHeight = ct.getHeight();
      ct.setTitle("Cheesy MS Paint");
      
      double offset = 3;      
      double spacing = gameHeight / 10;
      
      final double BOX_WIDTH = 17; // 20 minus offset
      
      palette = ct.rect(10,gameHeight/2,20,gameHeight,"black");
      ct.rect(10,gameHeight/2,BOX_WIDTH,gameHeight-offset,"gray");
      
      redRect = ct.rect(spacing, spacing - offset, BOX_WIDTH, spacing, "red");
      orangeRect = ct.rect(spacing,spacing*2 - offset, BOX_WIDTH, spacing, "orange");
      yellowRect = ct.rect(spacing,spacing*3 - offset, BOX_WIDTH, spacing, "yellow");
      greenRect = ct.rect(spacing,spacing*4 - offset, BOX_WIDTH, spacing, "green");
      blueRect = ct.rect(spacing,spacing*5 - offset, BOX_WIDTH, spacing, "blue");
      indigoRect = ct.rect(spacing,spacing*6 - offset, BOX_WIDTH, spacing, "dark blue");
      purpleRect = ct.rect(spacing,spacing*7 - offset, BOX_WIDTH, spacing, "purple");
      magentaRect = ct.rect(spacing,spacing*8 - offset, BOX_WIDTH, spacing, "dark magenta");
         
      // This will be pressed to activate the eraser
      eraseRect = ct.rect(spacing,spacing*9 - offset, BOX_WIDTH, spacing, "pink"); 
      ct.text("Eraser", spacing, spacing*9 - offset,5);
      
      // Squares to select brush size
      small = ct.rect(4.5, gameHeight - 5, BOX_WIDTH/3, spacing- offset - 1,"white");
      ct.text("s", small.x, small.y, 4);
      medium = ct.rect(spacing, gameHeight - 5,BOX_WIDTH/3, spacing - offset - 1,"white");
      ct.text("m", medium.x, medium.y, 4);
      large = ct.rect(15.7, gameHeight - 5, BOX_WIDTH/3, spacing - offset - 1,"white");
      ct.text("l", large.x, large.y, 4 );
      
   }
   
   public void update()
   {
      redRect.clickable = true;
      orangeRect.clickable = true;
      yellowRect.clickable = true;
      greenRect.clickable = true;
      blueRect.clickable = true;
      indigoRect.clickable = true;
      purpleRect.clickable = true;
      magentaRect.clickable = true;
      eraseRect.clickable = true;

      small.clickable = true;
      medium.clickable = true;
      large.clickable = true;
   }
   
  
    // have all except selected (null) for obj.setLineColor
    // selected obj.setLineColor("yellow"
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      lastX = x;
      lastY = y;
      
      if ( obj != null )
      {
            if ( obj == redRect )
               currentColor = "red";
            else if ( obj == orangeRect )
               currentColor = "orange";
            else if ( obj == yellowRect )
               currentColor = "yellow";
            else if ( obj == greenRect )
               currentColor = "green";
            else if ( obj == blueRect )
               currentColor = "blue";
            else if ( obj == indigoRect )
               currentColor = "dark blue";
            else if ( obj == purpleRect )
               currentColor = "purple";
            else if ( obj == magentaRect )
               currentColor = "dark magenta";
            else if ( obj == eraseRect )
               currentColor =  "white";
            
            // Whichever brush size selected gets highlighted
            if ( obj == small )
            {
               size = 6;
               small.setFillColor("light yellow");
               medium.setFillColor("white");
               large.setFillColor("white");
            }
            else if ( obj == medium )
            {
               size = 8;
               medium.setFillColor("light yellow");
               small.setFillColor("white");
               large.setFillColor("white");
            }
            else if ( obj == large )
            {
               size = 16;
               large.setFillColor("light yellow");
               small.setFillColor("white");
               medium.setFillColor("white");
            }

      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
      
      // saves the last known click position coordinates (lastX, lastY from onMousePress() )
      // then draw a line between those coordinates and the current 

      // user can only draw on canvas(null space), not on other game objects
      if ( ct.clickX() > palette.width + 2 )
      {
         brush = ct.line( lastX, lastY, x, y ,currentColor);
         brush.lineWidth = ct.toInt(size);
         // draw a bounding circle between lines (endpoints)
         if ( size == 6 || size == 8 )
            c = ct.circle(x, y, size / 10, currentColor);
         else if ( size == 16 )
            c = ct.circle(x, y, size / 5, currentColor); 
            
         c.setLineColor( currentColor );
         // update previous position
         lastX = x;
         lastY = y;
      }

   }
}