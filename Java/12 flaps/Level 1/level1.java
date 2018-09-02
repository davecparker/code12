import Code12.*;

class level1 extends Code12Program
{

   
   public static void main(String[] args)
   { 
      Code12.run( new level1() ); 
   }
   
   public void start()
   {  
      //draws the background
      ct.setBackImage( "background-day.png" );

      //sets the height of the sceen to match the height of the background
      ct.setHeight(128);

      //draws the bird
      ct.image( "yellowbird-downflap.png", 50, 44, 10 );

      //draws the count
      ct.image( "0.png", 50, 16, 5 );

      //draws the ground
      ct.image( "base.png", 20, 122, 40 );
      ct.image( "base.png", 60, 122, 40 );
      ct.image( "base.png", 100, 122, 40 );
   }
}
