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

   GameObj[] poles;

   int totalDisks = 3;
   int count = 0;

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

         poles = new GameObj[3];
         poles[0] = small;
         poles[1] = medium;
         poles[2] = large;


   }


//three arrays for size
   // a sub 0 diam of bottom guy
   // count var ti keep track of amt on each pole
   // compare diameter
   // width
   ///array of gmae obj
   // find obj in pole, pole is an array
   //GameObj[] pole. obect trying to find
   // findObj(GameObj[]pole, a )
   // findObj( a)
   //while 0 to null
   // boolean movetopole( obj, pole)
   public void update()
   {
      small.clickable = true;
      medium.clickable = true;
      large.clickable = true;


   }

   public GameObj findObj( GameObj[] arr, GameObj obj)
   {

   }


   //public boolean moveToPole( GameObj obj, GameObj[] p)
   //{

   //}

   // dont keep track of their y coordinate positions
   // keep track if theyre on top or not?

   // Helper function to determine if disk is on top of the others
   // The first object passed in parameter is the one being checked
   public boolean isOnTopOfAll(GameObj obj, GameObj obj2, GameObj obj3 )
   {
      if ( obj.y <= obj2.y && obj.y <= obj3.y ) 
         return true;
      else
         return false;
   }

   public boolean isUnderneathAll(GameObj obj, GameObj obj2, GameObj obj3 )
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
            if ( small.y > (pole1.y - pole1.height/2) )
               small.ySpeed = 0;
         }

         if ( medium.hit(pole1box) || medium.hit(pole2box) || medium.hit(pole3box) )
         {
            medium.ySpeed = 1;
            if ( medium.y > (pole1.y - pole1.height/2) )
               medium.ySpeed = 0;

         }

         if ( large.hit(pole1box) || large.hit(pole2box) || large.hit(pole3box) )
         {
            large.ySpeed = 1;
            if ( large.y > ( pole1.y - pole1.height/2) )
               large.ySpeed = 0;

         }



   }

   public void onMousePress(GameObj obj, double x, double y)
   {
   		double lastX = x;
   		double lastY = y;


      // TODO: save the previous x and y of the disks so that if the user makes an invalid move,
      // the disks go back to their old position

   }

   //TODO: add function to check winning conditions
   // small > medium > large on a different pole than the starting

   public void onMouseDrag(GameObj obj, double x, double y)
   {
         if ( obj == small )
         {
            if ( isOnTopOfAll(small,medium,large) )
            {
	            // Can only click on object when it is on top of the stack
	            small.x = x;
	            small.y = y;
	            //moveDiskToPole(small);
        	   }
         }

         if ( obj == medium )
         {
         	if ( isOnTopOfAll(medium,small,large) )
         	{
         		medium.x = x;
            	medium.y = y;

         	}
            
         }

         if ( obj == large )
         {
         	if ( isOnTopOfAll(large, medium, small) )
            large.x = x;
            large.y = y;
         }

   }
}