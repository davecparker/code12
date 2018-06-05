
import Code12.*;

public class Paint extends Code12Program
{
   String currentColor = "blue";    // Default color
   GameObj brush;
   
   GameObj redRect;
   GameObj orangeRect;
   GameObj yellowRect;
   GameObj greenRect;
   GameObj blueRect;
   GameObj indigoRect;
   GameObj purpleRect;
   GameObj majentaRect;;
   GameObj eraseRect;
   
   GameObj small;
   GameObj medium;
   GameObj large;
   
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
      
      ct.rect(10,height/2,20,height,"black");
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
      eraseRect = ct.rect(spacing,spacing*9, WIDTH, spacing + 6, "pink"); 
      ct.text("Eraser", spacing, spacing*9,5);
      
      // Circles to select brush size
      GameObj box = ct.rect(width-5,10,21,21);
      box.setFillColor("light gray");
      //box.setLayer(2);
      GameObj sizeText = ct.text("Brush size", width - 8, 1, 3);
      //sizeText.setLayer(3);
      small = ct.rect(width-5,5,2,2,"white");
      //small.setLayer(3);
      medium = ct.rect(width-5,10,4,4,"white");
      large = ct.rect(width-5,17,6,6,"white");

   }
   
   public void update()
   {
      redRect.visible = true;
      redRect.clickable = true;
      orangeRect.visible = true;
      orangeRect.clickable = true;
      yellowRect.visible = true;
      yellowRect.clickable = true;
      greenRect.visible = true;
      greenRect.clickable = true;
      blueRect.visible = true;
      blueRect.clickable = true;
      indigoRect.visible = true;
      indigoRect.clickable = true;
      purpleRect.visible = true;
      purpleRect.clickable = true;
      majentaRect.visible = true;
      majentaRect.clickable = true;
      eraseRect.visible = true;
      eraseRect.clickable = true;
      
      small.visible = true;
      small.clickable = true;
      medium.visible = true;
      medium.clickable = true;
      large.visible = true;
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
               
      //    // For setting different brush sizes
// 
//          
//             if ( obj == small )
//             {
//                brush = ct.line(ct.clickX(),ct.clickY(),x,y);
//                brush.setLineColor(currentColor);
//                brush.setFillColor(currentColor);
//                brush.lineWidth = 4;
//             }
//             else if ( obj == medium )
//                brush.lineWidth = 6;
//             else if ( obj == large )
//                brush.lineWidth = 10;
//             
         
      }
   }
   
   public void onMouseDrag( GameObj obj, double x, double y )
   {
       
      // Player can only draw on canvas
      if ( ct.clickX() > 20 )
      {
         // If the eraser is active, set "brush" size slightly larger
         if ( currentColor == "white" )
         {
            brush.lineWidth = 20;
         }
         brush = ct.line(ct.clickX(),ct.clickY(),x,y);
         brush.setLineColor(currentColor);
         brush.setFillColor(currentColor);
         //brush.setLineWidth(
      }
      
      
   }
  
   
   
}