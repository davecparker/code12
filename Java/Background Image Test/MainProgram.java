import Code12.*;

class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   int start;
   
   public void start()
   {  
      ct.setBackImage( "background.png" );
      start = ct.getTimer();
      
   }
   
   public void update()
   {  
      int millisec = ct.getTimer() - start;
      if ( millisec >= 60000 )  
      {
         ct.setBackImage( "background.png" );
         start = millisec;
         ct.println( "background set" );
      }
   }
}
