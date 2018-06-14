// Events Use Case of:
// onMousePress()
// onMouseDrag()
// Level 8. If-else   


import Code12.*;

public class Paint extends Code12Program
{
   String currentColor = "blue";    // Default color
   GameObj brush;
   
   // Rectangles to contain the colors
   GameObj palette;
   GameObj redRect;
   GameObj orangeRect;
   GameObj yellowRect;
   GameObj greenRect;
   GameObj blueRect;
   GameObj indigoRect;
   GameObj purpleRect;
   GameObj majentaRect;;
   GameObj eraseRect;
   
   // Objects to be used to change brush size
   GameObj small;
   GameObj medium;
   GameObj large;
   int size = 6;     // Default size is small
   
   public static void main(String[] args)
   { 
      Code12.run(new Paint()); 
   }
   
   public void start()
   {
      double width = ct.getWidth();
      double height = ct.getHeight();
      ct.setTitle("Cheesy MS Paint");
      
      double offset = 3;       // For a pro-looking bezel
      double spacing = height / 10;
      
      final double WIDTH = 17; // 20 minus offset
      
      palette = ct.rect(10,height/2,20,height,"black");
      ct.rect(10,height/2,WIDTH,height-offset,"gray");
         
      redRect = ct.rect(spacing, spacing - offset, WIDTH, spacing, "red");
      orangeRect = ct.rect(spacing,spacing*2 - offset, WIDTH, spacing, "orange");
      yellowRect = ct.rect(spacing,spacing*3 - offset, WIDTH, spacing, "yellow");
      greenRect = ct.rect(spacing,spacing*4 - offset, WIDTH, spacing, "green");
      blueRect = ct.rect(spacing,spacing*5 - offset, WIDTH, spacing, "blue");
      indigoRect = ct.rect(spacing,spacing*6 - offset, WIDTH, spacing, "dark blue");
      purpleRect = ct.rect(spacing,spacing*7 - offset, WIDTH, spacing, "purple");
      majentaRect = ct.rect(spacing,spacing*8 - offset, WIDTH, spacing, "dark majenta");
         
      // This will be pressed to activate the eraser
      eraseRect = ct.rect(spacing,spacing*9 - offset, WIDTH, spacing, "pink"); 
      ct.text("Eraser", spacing, spacing*9 - offset,5);
      
      // Squares to select brush size
      small = ct.rect(4.5, height - 5, WIDTH/3, spacing- offset - 1,"white");
      ct.text("s", small.x, small.y, 4);
      medium = ct.rect(spacing, height - 5, WIDTH/3, spacing - offset - 1,"white");
      ct.text("m", medium.x, medium.y, 4);
      large = ct.rect(15.7, height - 5, WIDTH/3, spacing - offset - 1,"white");
      ct.text("l", large.x, large.y, 4 );
      
   }
   
   public void update()
   {
      redRect.clickable = true;
      orangeRect.clickable = true;
      yellowRect.clickable = true;
      greenRect.clickable = true;
      blueRect.clickable = true;
      indigoRect.visible = true;
      indigoRect.clickable = true;
      purpleRect.clickable = true;
      majentaRect.clickable = true;
      eraseRect.clickable = true;

      small.clickable = true;
      medium.clickable = true;
      large.clickable = true;
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
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
            else if ( obj == majentaRect )
               currentColor = "dark majenta";
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
   // TODO draw line segments
       
      // Player can only draw on canvas, not on other game objects
      if ( ct.clickX() > palette.width + 1 )
      {
          brush = ct.line(ct.clickX(),ct.clickY(),x,y);
          brush.setLineColor(currentColor);
          brush.setFillColor(currentColor);
          brush.lineWidth = size;
      }

   }
}