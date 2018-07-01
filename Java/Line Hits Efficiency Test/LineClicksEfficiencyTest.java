import Code12.*;
public class LineClicksEfficiencyTest extends Code12Program
{

   public static void main(String[] args)
   {
      Code12.run(new LineClicksEfficiencyTest());
   }

   public void start()
   {
      int n = 100000;
      double unitsPerPx = 1 / ct.getPixelsPerUnit();
      double x = 50;
      double y = 50;
      double width = 20;
      double height = 10;
      GameObj rect = ct.rect(x, y, width, height);
      GameObj horizLine = ct.line(x, y, x - width, y);
      GameObj vertLine = ct.line(x, y, x, y - height);
      GameObj slantLine = ct.line(x, y, x - width, y - height);
      
      int outsideTime, insideTime;
      ct.println( "obj:       ms outside, ms inside ");
      
      outsideTime = containsPointTime(horizLine, x - width / 2, y + height, n);
      insideTime = containsPointTime(horizLine, x - width / 2, y - unitsPerPx, n);
      ct.println("horizLine: " + outsideTime + ", " + insideTime);
      
      outsideTime = containsPointTime(vertLine, x, y + height, n);
      insideTime = containsPointTime(vertLine, x - unitsPerPx, y - height / 2, n);
      ct.println("vertLine:  " + outsideTime + ", " + insideTime);
      
      outsideTime = containsPointTime(slantLine, x - width / 2, y - height / 4, n);
      insideTime = containsPointTime(slantLine, x - width / 2 - unitsPerPx, y - height / 2, n);
      ct.println("slantLine: " + outsideTime + ", " + insideTime);
      
      outsideTime = containsPointTime(rect, x, y + height, n);
      insideTime = containsPointTime(rect, x, y, n);
      ct.println("rect:      " + outsideTime + ", " + insideTime);
   }
   
   // Returns the number of milliseconds for n calls of obj.containsPoint(x, y)
   public int containsPointTime(GameObj obj, double x, double y, int n )
   {
      int startTime = ct.getTimer();
      for (int i = 0; i < n; i++)
         obj.containsPoint(x, y);
      return ct.getTimer() - startTime;
   }
}