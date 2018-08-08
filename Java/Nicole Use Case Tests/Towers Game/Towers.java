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
   GameObj[] disks;
   GameObj[] boundingBoxes;

   double lastX;
   double lastY;

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
         pole1box = ct.rect(pole1.x, pole1.y, pole1.width + 10, ct.getHeight() );
         pole1box.setFillColor(null);
         pole1box.setLineColor(null);

         pole2 = ct.rect(base.x, base.y - 7.5, 3, 20, "gray");
         pole2.lineWidth = 3;
         pole2box = ct.rect(pole2.x, pole2.y, pole2.width + 10, ct.getHeight() );
         pole2box.setFillColor(null);
         pole2box.setLineColor(null);

         pole3 = ct.rect( base.x + 34, base.y - 7.5, 3, 20, "gray");
         pole3.lineWidth = 3;
         pole3box = ct.rect(pole3.x, pole3.y, pole3.width + 10, ct.getHeight() );
         pole3box.setFillColor(null);
         pole3box.setLineColor(null);

         boundingBoxes = new GameObj[3];
         boundingBoxes[0] = pole1box;
         boundingBoxes[1] = pole2box;
         boundingBoxes[2] = pole3box;

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
         poles[0] = pole1;
         poles[1] = pole2;
         poles[2] = pole3;

         disks = new GameObj[3];
         disks[0] = small;
         disks[1] = medium;
         disks[2] = large;


   }


   // count variable to keep track of amt on each pole
   ///array of gmae obj
   // find obj in pole, pole is an array
   //GameObj[] pole. object trying to find
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

   // Find the pole from which an object came from
   public int poleFrom( GameObj obj )
   {
      // iterate through the array to find out which "pole" the obj is on
      // e.g., arr[0] is pole number one
      for ( int i = 0; i < poles.length; i++ )
      {
         for ( int j = 0; j < disks.length; j++ )
         {
            // Is it the object searched for?
            // if so, return the pole number at which its located
            if ( disks[j] == obj && obj.hit(boundingBoxes[i]) )
               return i;
         }
      }

   }

   // or det top disk of each pole?

   // function to determine the amount of disks on each pole
   // parameter passed is a GameObj (the pole)
   public int getAmountOnPole( GameObj pole )
   {
      int amount = 0;

      for ( int i = 0; i < poles.length; i++ )
      {
         for ( int j = 0; j < disks.length; j++ )
         {
            if ( disks[j].hit(poles[i]) == true )
               amount++;

         }
      }

      return amount;

   }

   public boolean isValidMove(GameObj diskMoving) // bool is valid move? pass obj tring to move
   {
      for ( int i = 0; i < poles.length; i++ )
      {
         int amount = getAmountOnPole( poles[i] );
         if ( amount == 0 )
         {
            ct.println("does this execute");
            return true;
         }
         else // There must be disks on the pole
         {
            // So get the one on top to find its width
            // and compare its width with the diskMoving
            // if diskMoving.width < top.width, move is ok
            // else if diskMoving.width > top.width, send diskMoving back to pole it came from
            for ( int j = 0; j < disks.length; j++ )
            {
               // If there is a disk is on the pole
               // Check the top disk's width
               if ( diskMoving.hit(poles[j]) && diskMoving != disks[j])
               {
                  ct.println("Test to see if the disk moving hit the disk on the pole");
                  if ( diskMoving.width > disks[j].width )
                  {
                     ct.println("This will print if the moving disk has a larger diam than disk on pole");
                     return false;
                  }
                  else if ( diskMoving.width < disks[j].width )
                  {
                     ct.println("This will print if the moving disk has a smaller diam than disk on pole");
                     return true;
                  }

               }
            }

         }
      }
   }

   public double[] getWidths()
   {
      double[] widths = new double[disks.length];

      for ( int i = 0; i < disks.length; i++ )
      {
         widths[i] = disks[i].width;
      }

      return widths;
   }

   //public void isClosestToTOp
   // Once we find the pole (and the amount of disks on each pole), compare their width to determine if a move is possible
   // public boolean isValidMove( GameObj  obj, GameObj[] arr )
   // {
   //    // Iterate through the poles
   //    for ( int i = 0; i < poles.length; i++ )
   //    {
   //       // Go through the amount of disks on each pole
   //       //int amount = getAmountOnPole(i);
   //       for ( int j = 0; j < amount; j++ )
   //       {
   //          for ( int k = 0; k < poles.length; k++ )
   //          {
   //             GameObj min; //holding variable



   //          }
   //       }

   //    }
   // }


   // If ( bigger ) can't put on top of smaller
   // If ( smaller ) can put on top of bigger


   // Helper function to let moved disks fall to the base of a given pole 
   // Once they reach the base of the pole or another objject in poles array, they stop falling ( ySpeed = 0 )
   public void moveDiskToPole(GameObj disk)
   {
      // move to stack
      // falls to bottom unless other disks obj is hits
      for ( int i = 0; i < poles.length; i++ )
      {
         for ( int j = 0; j < disks.length; j++ )
         {
         /*
            if ( disk.hit(disks[j]))
            {
               disk.x = disks[j].x - ( disks[j].height/4);
               disk.y = disks[j].y - (disks[j].height / 2);
            }*/

            // else to go to base of pole
            else if ( isValidMove(disk) == true )
            {
               disk.x = poles[i].x;
               disk.y = poles[i].y;

            }


         }

      }



   }

   public void onMousePress(GameObj obj, double x, double y)
   {// pole from where it came frm
   		lastX = x;
   		lastY = y;

   }


   public void onMouseDrag(GameObj obj, double x, double y)
   {
      // keep track of obj movibg
      // and the pole it came from remember pole 
      //GameOBj diskMoving
      //    int poleFrom
      if ( obj == small )
      {
         small.x = x;
         small.y = y;
         int polenum = poleFrom(small);
         ct.println( polenum );
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

       // on mouse release
       // actually check and do stuff

   }

   public void onMouseRelease(GameObj obj, double x, double y )
   {
      if ( obj == small )
      {
         if ( isValidMove(small) == true )
         {
            ct.println("This should print if move for small is valid");
            moveDiskToPole(small);
         }
         else if ( isValidMove(small) == false )
         {
            ct.println("This should print if move for small is invalid");
            int poleFrom = poleFrom(small);
            small.x = poles[poleFrom].x;
            small.y = poles[poleFrom].y;
         }

      }

      if ( obj == medium )
      {
         if ( isValidMove(medium) == true )
            moveDiskToPole(medium);
         else if ( isValidMove(medium) == false )
         {
            ct.println("This should print if move for medium is invalid");
            int poleFrom = poleFrom(medium);
            medium.x = poles[poleFrom].x;
            medium.y = poles[poleFrom].y;
         }
      }

      if ( obj == large )
      {
         if ( isValidMove(large) == true )
            moveDiskToPole(large);
         else if ( isValidMove(large) == false)
         {
            ct.println("This should print if move for large is invalid");
            int poleFrom = poleFrom(large);
            large.x = poles[poleFrom].x;
            large.y = poles[poleFrom].y;
         }
      }

   }
}