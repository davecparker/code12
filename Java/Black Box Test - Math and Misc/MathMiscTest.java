import Code12.*;

class MathMiscTest extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MathMiscTest()); 
   }
   
   public void start()
   {  
      for ( int i = 0; i > -101; i--   )
         ct.println( ct.formatInt(i, 5) );
   }
   
   public void update()
   {        
   }
}
