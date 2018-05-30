import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {       
      ct.rect( 40, 85, 10, 10, "blue" ); 
      ct.rect( 60, 85, 10, 10, "blue" );
      ct.rect( 37.5, 92.5, 15, 5, "black" );
      ct.rect( 62.5, 92.5, 15, 5, "black" );
      
      ct.circle( 50, 25, 50, "yellow" );
      ct.circle( 50, 60, 50, "blue" );
      ct.rect( 50, 42.5, 50, 45, "yellow" );
      ct.rect( 50, 55, 35, 20, "blue" );
      ct.rect( 50, 55, 20, 10, "blue" );
      ct.rect( 27.5, 47.5, 10, 5, "blue" );
      ct.rect( 72.5, 47.5, 10, 5, "blue" );
      
      ct.rect( 22.5, 65, 5, 30, "yellow" );
      ct.rect( 77.5, 65, 5, 30, "yellow" );
      ct.rect( 22.5, 80, 7, 10, "black" );
      ct.circle( 22.5, 85, 7, "black" );
      ct.circle( 19, 82, 7, "black" );
      ct.circle( 26, 82, 7, "black" );
      ct.rect( 77.5, 80, 7, 10, "black" );
      ct.circle( 77.5, 85, 7, "black" );
      ct.circle( 74, 82, 7, "black" );
      ct.circle( 81, 82, 7, "black" );
      
      ct.circle( 37.5, 20, 25, "gray" );
      ct.circle( 62.5, 20, 25, "gray" );
      ct.rect( 76.25, 20, 2.5, 10, "gray" );
      ct.rect( 23.75, 20, 2.5, 10, "gray" );
      
     /* ct.circle( 37.5, 20, 20, "white" );
      ct.circle( 62.5, 20, 20, "white" );
      /* ct.circle( 40, 20, 8, "green" );
      ct.circle( 60, 20, 8, "green" ); */
      ct.circle( 40, 20, 4, "black" );
      ct.circle( 60, 20, 4, "black" ); */
      
      ct.image( "mouth.png", 50, 36, 20 );
   }
   
}
