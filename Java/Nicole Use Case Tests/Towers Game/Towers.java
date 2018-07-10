/* You can only move one disk at a time
*  You may not stack a small disk on top of a larger disk
*/



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
         pole2box = ct.rect(pole2.x, pole2.y, pole2.width, ct.getHeight() );
         pole3 = ct.rect( base.x + 34, base.y - 7.5, 3, 20, "gray");
         pole3.lineWidth = 3;
         pole3box = ct.rect(pole3.x, pole3.y, pole3.width, ct.getHeight() );

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

   // Helper function to determine if disk is on top of the others
   public boolean isOnTopOfAll(GameObj obj, GameObj obj2, GameObj obj3 )
   {
      if ( obj.y < obj2.y && obj.y < obj3.y )
         return true;
      else
         return false;

   }

   // Helper function to 

   //Helper function to determine is disk is beneath the others
   // The first object passed in parameter is the one being checked
   public boolean isUnderneath(GameObj obj, GameObj obj2, GameObj obj3 )
   {
      if ( obj.y > obj2.y && obj.y > obj3.y )
         return true;
      else
         return false;
   }

   // Helper function to determine if object is smaller or bigger than others
   // If ( bigger ) can't put on top of smaller
   // If ( smaller ) can put on top of bigger

   // Helper function to let moved disks fall to the base of a given pole 
   // Once they reach the base of the pole, they stop falling ( ySpeed = 0 )
   public void moveDiskToPole(GameObj obj)
   {

         if ( small.hit(pole1box) || small.hit(pole2box) || small.hit(pole3box) )
         {
            small.ySpeed = 1;
            if ( small.y > pole1.y )
               small.ySpeed = 0;
         }

         if ( medium.hit(pole1box) || medium.hit(pole2box) || medium.hit(pole3box) )
         {
            medium.ySpeed = 1;
            if ( medium.y > pole1.y)
               medium.ySpeed = 0;

         }

         if ( large.hit(pole1box) || large.hit(pole2box) || large.hit(pole3box) )
         {
            large.ySpeed = 1;
            if ( large.y > pole1.y )
               large.ySpeed = 0;

         }



   }

   public void onMousePress(GameObj obj, double x, double y)
   {
      // TODO: save the previous x and y of the disks so that if the user makes an invalid move,
      // the disks go back to their old position

   }

   public void onMouseDrag(GameObj obj, double x, double y)
   {
         if ( obj == small )
         {
            if ( isOnTopOfAll(small,medium,large) )
            // Can only click on object when it is on top of the stack
            small.x = x;
            small.y = y;
            //moveDiskToPole(small);
         }

         if ( obj == medium )
         {
            medium.x = x;
            medium.y = y;
         }

         if ( obj == large )
         {
            large.x = x;
            large.y = y;
         }

   }

}