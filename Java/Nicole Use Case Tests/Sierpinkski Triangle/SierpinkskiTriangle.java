import Code12.*;

class SierpinkskiTriangle extends Code12Program
{
   GameObj c1;
   GameObj c2;
   GameObj c3;

   GameObj slider;


   // TODO: do this without using circles, just the limiting circle and points
   public static void main(String[] args)
   { 
      Code12.run(new SierpinkskiTriangle()); 
   }
   
   public void start()
   {
      slider = ct.rect(0,50, 10,10,"black");
      slider.visible = false;

      c1 = ct.circle( 50, 10, 1,"blue");      // top circle
      c2 = ct.circle( 10 , 90 , 1,"green");  // left circle
      c3 = ct.circle( 90, 90, 1,"red");      // right circle

      drawTriangle( c1, c2, c3, 1);

      // set up everything in advance
      // way to do this more efficiently?
      GameObj c4 = ct.circle( 150, 10, 1,"blue"); 
      GameObj c5 = ct.circle( 110 , 90 , 1,"green");
      GameObj c6 = ct.circle( 190, 90, 1,"red"); 
      drawTriangle( c4, c5, c6, 2);


      GameObj c7 = ct.circle( 250, 10, 1,"blue"); 
      GameObj c8 = ct.circle( 210 , 90 , 1,"green");
      GameObj c9 = ct.circle( 290, 90, 1,"red"); 

      drawTriangle( c7, c8, c9, 3);


      GameObj c10 = ct.circle( 350, 10, 1,"blue"); 
      GameObj c11 = ct.circle( 310 , 90 , 1,"green");
      GameObj c12 = ct.circle( 390, 90, 1,"red"); 

      drawTriangle( c10, c11, c12, 4);

      GameObj c13 = ct.circle( 450, 10, 1,"blue"); 
      GameObj c14 = ct.circle( 410 , 90 , 1,"green");
      GameObj c15 = ct.circle( 490, 90, 1,"red"); 

      drawTriangle( c13, c14, c15, 5);

      GameObj c16 = ct.circle( 550, 10, 1,"blue"); 
      GameObj c17 = ct.circle( 510 , 90 , 1,"green");
      GameObj c18 = ct.circle( 590, 90, 1,"red"); 

      drawTriangle( c16, c17, c18, 6);

      GameObj c19 = ct.circle( 650, 10, 1,"blue"); 
      GameObj c20 = ct.circle( 610 , 90 , 1,"green");
      GameObj c21 = ct.circle( 690, 90, 1,"red"); 

      drawTriangle( c19, c20, c21, 7);

      GameObj c22 = ct.circle( 750, 10, 1,"blue"); 
      GameObj c23 = ct.circle( 710 , 90 , 1,"green");
      GameObj c24 = ct.circle( 790, 90, 1,"red"); 

      drawTriangle( c22, c23, c24, 8);

      GameObj c25 = ct.circle( 850, 10, 1,"blue"); 
      GameObj c26 = ct.circle(810 , 90 , 1,"green");
      GameObj c27 = ct.circle( 890, 90, 1,"red"); 

      drawTriangle( c25, c26, c27, 9);

      
   }

   // return a pair of points (x,y) between circles
   public double[] midpoint( GameObj circleOne, GameObj circleTwo )
   {
      double[] m = new double[2];
      m[0] = ( circleOne.x + circleTwo.x ) / 2;
      m[1] = ( circleOne.y + circleTwo.y ) / 2;
      return m;
   }

   public void drawTriangle( GameObj circle1, GameObj circle2, GameObj circle3, double size )
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
   public void update()
   {
      slider.xSpeed = 15;

      // TODO: improve this lol
      if ( slider.x > 100 )
      {
         ct.setScreenOrigin(100,0);
      }

      if ( slider.x > 200 )
      {
         ct.setScreenOrigin(200,0);
      }

      if ( slider.x > 300 )
      {
         ct.setScreenOrigin(300,0);
      }

      if ( slider.x > 400 )
      {
         ct.setScreenOrigin(400,0);
      }

      if ( slider.x > 500 )
      {
         ct.setScreenOrigin(500,0);
      }

      if ( slider.x > 600 )
      {
         ct.setScreenOrigin(600,0);
      }

      if ( slider.x > 700 )
      {
         ct.setScreenOrigin(700,0);
      }

      if ( slider.x > 800 )
      {
         ct.setScreenOrigin(800,0);
      }

   }
   
}