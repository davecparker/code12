import Code12.*;

class level4 extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run( new level4() ); 
   }
   
   public void start()
   {  
      //draws the background
      ct.setBackImage( "background-day.png" );

      //sets the height of the sceen to match the height of the background
      double h = 128; //sets h to 128 (the height of the screen)
      ct.setHeight( h );
      double w = 100; //sets w to 100 (the width of the screen)   

      //draws the bird ct.image("filename", x, y, h)
      double x = w / 2.0; // sets x to 50 (the x position of the bird)
      double y = h / 2.0; // sets y to 64  (the y position of the bird)
      int hbird = 10; //height of the bird (the height of the bird)
      ct.image( "yellowbird-downflap.png", x, y, hbird ); //uses x and y to stand in for 50, 64

      //draws the count
      //the value of x does not change (the x position of the bird and number are equal)
      y = h / 8.0; //sets y to 16 (the y position of the number)
      int hnumb = 5; //sets h to 5 (the height of the number)
      ct.image( "0.png", x, y, hnumb ); //

      //draws the ground
      y = 122; //sets y to 122 (the y positoin of all the pieces of the base)
      h = 40; //sets h to 40 (the height of all the pieces of the base)
      x = 20;
      ct.image( "base.png", x, y, h );
      x = x + 40;
      ct.image( "base.png", x, y, h );
      x = x + 20;
      ct.image( "base.png", x, y, h );
   }

   public void update( )
   {
      String filename;
   }
}