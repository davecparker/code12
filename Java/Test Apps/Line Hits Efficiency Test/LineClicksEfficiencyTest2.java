import Code12.*;
public class LineClicksEfficiencyTest2 extends Code12Program
{

   public static void main(String[] args)
   {
      Code12.run(new LineClicksEfficiencyTest2());
   }

   public void start()
   {
      double x = 50;
      double y = 50;
      double width = 20;
      double height = 10;
      GameObj rect = ct.rect(x, y, width, height);
      GameObj horizLine = ct.line(x + width / 2, y, x - width / 2, y);
      GameObj vertLine = ct.line(x, y + height / 2, x, y - height / 2);
      GameObj slantLine1 = ct.line(x + width / 2, y + height / 2, x - width / 2, y - height / 2);
      GameObj slantLine2 = ct.line(x - width / 2, y + height / 2, x + width / 2, y - height / 2);
      
      ct.println( "horizLine:  " + containsPointTime(horizLine) );
      ct.println( "vertLine:   " + containsPointTime(vertLine) );
      ct.println( "slantLine1: " + containsPointTime(slantLine1) );
      ct.println( "slantLine2: " + containsPointTime(slantLine1) );
      ct.println( "rect:       " + containsPointTime(rect) );
   }
   
   // Returns the number of milliseconds for n calls of obj.containsPoint(x, y)
   public int containsPointTime(GameObj obj )
   {
      double dx = 0.1;
      double dy = 0.1;
      int startTime = ct.getTimer();
      for (double x = 0; x <= 100; x += dx)
      {
         for (double y = 0; y <= 40; y += dy)
         {
            obj.containsPoint(x, y);
         }
      }
      return ct.getTimer() - startTime;
   }
}