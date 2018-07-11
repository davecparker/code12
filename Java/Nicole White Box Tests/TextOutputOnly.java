import Code12.*;

class TextOutputOnly extends Code12Program 
{
   String[] letters;
   int[] integers;
   String s = null;
   public static void main(String[] args)
   { 
      Code12.run(new TextOutputOnly()); 
   }
   
   public void start()  
   {
      letters = new String[10];
      letters[0] = "test";
      letters[1] = "testing";
      letters[2] = "tested";
      
      integers = new int[10];
      integers[0] = 30;
      integers[1] = 3435;
      integers[2] = 91;
      
        for (int i = 0; i <= 100; i++)
        {
            ct.println("Progress: " + i + " %");
        }
        
        ct.println("Task completed.");
        
        for ( int i = 0; i < letters.length; i++ )
        {
            ct.println( letters[i] );
        }
        
        for ( int i = 0; i < integers.length; i++ )
         ct.println( integers[i] );
   }
   
   public void update()
   {
      
      
      
   }
   
}