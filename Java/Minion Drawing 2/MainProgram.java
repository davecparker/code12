import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {  
      // Head
      ct.circle( 50, 25, 50, "yellow" );
      ct.rect( 50, 37.5, 50, 25, "yellow" );
   
      // Eyes
      ct.circle( 37.5, 25, 25, "gray" );
      ct.circle( 62.5, 25, 25, "gray" );
      ct.circle( 37.5, 25, 20, "white" );
      ct.circle( 62.5, 25, 20, "white" );
      
      // Irises
      ct.circle( 40, 25, 8, "green" );
      ct.circle( 60, 25, 8, "green" ); 
      
      // Pupils
      ct.circle( 40, 25, 4, "black" );
      ct.circle( 60, 25, 4, "black" ); 
   }
   
   public void update()
   {        
   }
}
