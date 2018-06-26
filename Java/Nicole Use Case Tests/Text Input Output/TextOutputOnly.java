import Code12.*;

class TextOutputOnly extends Code12Program 
{
   
   public static void main(String[] args)
   { 
      Code12.run(new TextOutputOnly()); 
   }
   
   public void start()  
   {
        for (int i = 0; i <= 100; i++)
        {
            ct.println("Progress: " + i + " %");
        }
        
        ct.println("Task completed.");
   }
   
   public void update()
   {
   }
   
}