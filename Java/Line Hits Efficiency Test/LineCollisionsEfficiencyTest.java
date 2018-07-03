import Code12.*;
public class LineCollisionsEfficiencyTest extends Code12Program
{

   public static void main(String[] args)
   {
      Code12.run(new LineCollisionsEfficiencyTest());
   }

   public void start()
   {
      int n = 100000;
      double unitsPerPx = 1 / ct.getPixelsPerUnit();
      double x = 50;
      double y = 50;
      double width = 20;
      double height = 10;
      int numObjs = 6;
      GameObj[] objs = new GameObj[numObjs];
      String[] labels = new String[numObjs];

      objs[0] = ct.rect(x, y, width, height, "red");
      objs[1] = ct.rect(x, y, width / 2, height / 2, "orange");
      objs[2] = ct.line(x + width / 4, y + height / 4, x - width / 4, y - height / 4, "yellow");
      objs[3] = ct.line(x + 6, y + 10, x - 6, y - 10, "green");
      objs[4] = ct.line(x + width / 5, y, x - width / 5, y);
      objs[5] = ct.line(x, y + height / 5, x, y - height / 5);

      labels[0] = "rRect";
      labels[1] = "oRect";
      labels[2] = "yLine";
      labels[3] = "gLine";
      labels[4] = "hLine";
      labels[5] = "vLine";
      
      String[] times = new String[numObjs * numObjs];
      for (int i = 0; i < numObjs; i++)
         for (int j = 0; j < numObjs; j++)
            times[i * numObjs + j] = ct.formatInt( hitTime(objs[i], objs[j], n), 5 );

      ct.print("------");
      for (int i = 0; i < numObjs; i++)
         ct.print(labels[i] + " ");
      ct.println("-");
      for (int i = 0; i < numObjs; i++)
      {
         ct.print(labels[i] + " ");
         for (int j = 0; j < numObjs; j++)           
            ct.print(times[i * numObjs + j] + " ");
         ct.println("-");
      }
   }
   
   // Returns the number of milliseconds for n calls of obj1.hit(obj2)
   public int hitTime(GameObj obj1, GameObj obj2, int n )
   {
      int startTime = ct.getTimer();
      for (int i = 0; i < n; i++)
         obj1.hit(obj2);
      return ct.getTimer() - startTime;
   }
}