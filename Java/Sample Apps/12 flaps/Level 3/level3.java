import Code12.*;

class Level3 extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run( new level3() ); 
   }
   
   public void start()
   {  
      //draws the background
      ct.setBackImage( "background-day.png" );

      //sets the height of the sceen to match the height of the background
      int h = 128; //sets h to 128 (the height of the screen)
      ct.setHeight( h );

      //draws the bird ct.image("filename", x, y, h)
      int x = 50; // sets x to 50 (the x position of the bird)
      int y = 64; // sets y to 64  (the y position of the bird)
      h = 10; //height of the bird (the height of the bird)
      ct.image( "yellowbird-downflap.png", x, y, h ); //uses x and y to stand in for 50, 64

      //draws the count
      //the value of x does not change (the x position of the bird and number are equal)
      y = 16; //sets y to 16 (the y position of the number)
      h = 5; //sets h to 5 (the height of the number)
      ct.image( "0.png", x, y, h ); //

      //draws the ground
      y = 122; //sets y to 122 (the y positoin of all the pieces of the base)
      h = 40; //sets h to 40 (the height of all the pieces of the base)
      //since the x position of each piece of the base is different it is not useful to use a variable
      ct.image( "base.png", 20, y, h );
      ct.image( "base.png", 60, y, h );
      ct.image( "base.png", 100, y, h );
   }
}