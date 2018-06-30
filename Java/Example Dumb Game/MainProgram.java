import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {
      GameObj r = ct.rect(50, 50, 75, 25);  
      ct.logm("I created", r);
   }
   
   public void update()
   {        
   }
}
