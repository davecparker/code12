import Code12.*;

public class MainProgram extends Code12Program
{
   // public static void main(String[] args)
   // { 
   //    Code12.run(new MainProgram()); 
   // }
   
   public void start()
   {
      foo("Hey");
   }

   void foo(String s)
   {
      ct.println(s);
   }
}
