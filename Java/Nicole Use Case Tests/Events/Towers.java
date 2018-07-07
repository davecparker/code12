import Code12.*;

public class Towers extends Code12Program
{
   GameObj base;
   GameObj pole1;
   GameObj pole1box;
   GameObj pole2;
   GameObj pole2box;
   GameObj pole3;
   GameObj pole3box;

   GameObj small;
   GameObj medium;
   GameObj large;

   public static void main(String[] args)
   {
      Code12.run(new Towers());
   }

   public void start()
   {
         // Initial base 
         base = ct.rect(ct.getWidth()/2,ct.getHeight()/2 + 20, 70, 5, "gray");
         base.lineWidth = 5;
         pole1 = ct.rect( base.x / 3, base.y - 7.5, 3, 20,"gray");
         pole1.lineWidth = 3;
         pole1box = ct.rect(pole1.x, pole1.y, pole1.width, ct.getHeight() );
         pole2 = ct.rect(base.x, base.y - 7.5, 3, 20, "gray");
         pole2.lineWidth = 3;
         pole3 = ct.rect( base.x + 34, base.y - 7.5, 3, 20, "gray");
         pole3.lineWidth = 3;

         small = ct.circle(pole2.x,pole2.y - 9, 10, "blue");
         small.height = 3;
         small.lineWidth = 3;
         small.setLineColor("dark blue");

         medium = ct.circle(pole2.x, pole2.y -5, 15, "green");
         medium.height = 5;
         medium.lineWidth = 3;
         medium.setLineColor("dark green");
         
         large = ct.circle(pole2.x, pole2.y + 1, 18, "red");
         large.height = 7;
         large.lineWidth = 3;
         large.setLineColor("dark red");


   }

   public void update()
   {
      small.clickable = true;
      medium.clickable = true;
      large.clickable = true;


   }

   // Helper function to determine if object is under another
   public void moveDiskToPole(GameObj obj)
   {
         if ( small.hit(pole1box) )
         {
            small.ySpeed = 1;
            if ( small.y > pole1.y )
               small.ySpeed = 0;
         }



   }

   public void onMousePress(GameObj obj, double x, double y)
   {

   }

   public void onMouseDrag(GameObj obj, double x, double y)
   {
         if ( obj == small )
         {
            small.x = x;
            small.y = y;
            moveDiskToPole(small);
         }

   }

}