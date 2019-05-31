import Code12.*;
public class LineCollisionsEfficiencyTest2 extends Code12Program
{

   public static void main(String[] args)
   {
      Code12.run(new LineCollisionsEfficiencyTest2());
   }

   public void start()
   {
      int numObjs = 1000;
      GameObj[] rects = new GameObj[numObjs];
      GameObj[] lines = new GameObj[numObjs];
      // Make random rects and lines
      for (int i = 0; i < numObjs; i++)
      {
         double x = ct.random(0, 100);
         double y = ct.random(0, 100);
         double width = ct.random(1,20);
         double height = ct.random(1,20);
         rects[i] = ct.rect(x, y, width, height);
         double x1 = ct.random(0, 100);
         double y1 = ct.random(0, 100);
         double x2 = ct.random(0, 100);
         double y2 = ct.random(0, 100);
         lines[i] = ct.line(x1, y1, x2, y2);
      }
      // Print times
      ct.println("hitTime(rects, lines): " + hitTime(rects, lines));
      ct.println("hitTime(lines, rects): " + hitTime(lines, rects));
      ct.println("hitTime(rects, rects): " + hitTime(rects, rects));
      ct.println("hitTime(lines, lines): " + hitTime(lines, lines));

   }
   
   // Returns the number of milliseconds for all calls of objs1[i].hit(objs2[j]), 
   public int hitTime(GameObj[] objs1, GameObj[] objs2)
   {
      int len1 = objs1.length;
      int len2 = objs2.length;
      int startTime = ct.getTimer();
      for (int i = 0; i < len1; i++)
         for (int j = 0; j < len2; j++)
            objs1[i].hit(objs2[i]);
      return ct.getTimer() - startTime;
   }
}