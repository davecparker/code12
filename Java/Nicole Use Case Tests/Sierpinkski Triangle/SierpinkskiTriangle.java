import Code12.*;

class SierpinkskiTriangle extends Code12Program
{

   public static void main(String[] args)
   { 
      Code12.run(new SierpinkskiTriangle()); 
   }
   
   public void start()
   {

      GameObj c1 = ct.circle( 50, 10, 1,"blue");      // top circle
      GameObj c2 = ct.circle( 10 , 90 , 1,"green");  // left circle
      GameObj c3 = ct.circle( 90, 90, 1,"red");      // right circle

      drawTriangle( c1, c2, c3, 9 );
   }

   // return a pair of points (x,y) between circles
   public double[] midpoint( GameObj circleOne, GameObj circleTwo )
   {
      double[] m = new double[2];
      m[0] = ( circleOne.x + circleTwo.x ) / 2;
      m[1] = ( circleOne.y + circleTwo.y ) / 2;
      return m;
   }

   public void drawTriangle( GameObj circle1, GameObj circle2, GameObj circle3, int size )
   {
      if ( Math.abs(size) < 2 )
         GameObj limit = ct.circle( circle1.x, circle1.y, 2 );
      else
      {
         double[] midOne = midpoint( circle1, circle2 );
         double[] midTwo = midpoint( circle2, circle3 );
         double[] midThree = midpoint( circle3, circle1 );

         // Circles to represent the midpoints
         GameObj midOneCircle = ct.circle( midOne[0], midOne[1], 1);
         GameObj midTwoCircle = ct.circle ( midTwo[0], midTwo[1], 1);
         GameObj midThreeCircle = ct.circle ( midThree[0], midThree[1], 1);

         drawTriangle(circle1, midOneCircle, midThreeCircle, size - 1 );

         drawTriangle(midOneCircle, circle2, midTwoCircle, size - 1 );

         drawTriangle (midThreeCircle, midTwoCircle, circle3, size - 1 );

      }

   }

   // experiment...on click, change origin, recurse again 
   //but closer up scale
   
   public void update()
   {
   }
   
}