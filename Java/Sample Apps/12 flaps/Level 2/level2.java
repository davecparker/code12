import Code12.*;

class Level2 extends Code12Program
{
   
   public void start()
   {  
      //omg coments wow
      //draws the background
      ct.setBackImage( "background-day.png" );

      //sets the height of the sceen to match the height of the background
      ct.setHeight(128);

      //draws the bird
      ct.image( "yellowbird-downflap.png", 50, 44, 10 );

      //draws the count
      ct.image( "0.png", 50, 18, 5 );

      //draws the ground
      ct.image( "base.png", 20, 122, 40 );
      ct.image( "base.png", 60, 122, 40 );
      ct.image( "base.png", 100, 122, 40 );
   }
}