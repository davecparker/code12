import Code12.*;

public class MainProgram extends Code12Program
{
   // GameObj c = ct.circle(0, 0, 0);

   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {
      int i = 4;
      double[] ratios = new double[10];
      int [] scores = { 2, 3 };
      GameObj[] rects = makeRects();
      rects = makeRects();  
      foo("hey");
      rects[1].setFillColor("red");
      ct.logm("I created", rects[1]);
   }

   GameObj[] makeRects()
   {
      GameObj[] a = { ct.rect(50, 50, 75, 25),
                     ct.rect(50, 25, 50, 20) };
      return a;
   }

   void foo(String s)
   {
      ct.println(Math.min(3.4, 2.1));
      if (s.equals("hey"))
         ct.println("Foo! " + s.length());
   }
}
