// OK

import Code12.*;
//import java.util.Scanner;
import Code12.*;
// int foo = 5;
// OK
class TestProgram extends Code12Program
// int foo = 6;
{
   double xOrigin = 50;
   double yOrigin = 0;
   GameObj dot;

   public static void main(String[] args)
   { 
      Code12.run(new TestProgram()); 
   }
   
   public void start()
   {
      ct.setBackImage("underwater.jpg");
      dot = ct.circle(50, 50, 10);
      GameObj t = ct.rect(25, 75, 10, 50);
      t.group = "targets";
      t = ct.rect(75, 75, 10, 50);
      t.group = "targets";
      t = ct.text("Hello", 50, 25, 10);
      t.group = "targets";
      ct.setScreenOrigin(xOrigin, 0);
   }

   public void update()
   {
      if ( ct.keyPressed("tab") )
      {
         ct.println("ct.keyPressed(\"tab\")");
      }
      else if (ct.keyPressed("a"))
      {
         xOrigin--;
         ct.setScreenOrigin(xOrigin, yOrigin);
      }
      else if (ct.keyPressed("d"))
      {
         xOrigin++;
         ct.setScreenOrigin(xOrigin, yOrigin);
      }
      else if (ct.keyPressed("w"))
      {
         yOrigin--;
         ct.setScreenOrigin(xOrigin, yOrigin);
      }
      else if (ct.keyPressed("s"))
      {
         yOrigin++;
         ct.setScreenOrigin(xOrigin, yOrigin);
      }

      final double SPEED = 0.2;
      if (ct.keyPressed("left"))
         dot.x -= SPEED;
      else if (ct.keyPressed("right"))
         dot.x += SPEED;
      else if (ct.keyPressed("up"))
         dot.y -= SPEED;
      else if (ct.keyPressed("down"))
         dot.y += SPEED;
      
      GameObj hit = dot.objectHitInGroup("targets");
      if (hit != null)
         hit.delete();

      GameObj clicked = ct.objectClicked();
      if (clicked != null)
         clicked.delete();

      if (ct.clicked())
         ct.log(ct.clickX(), ct.clickY());
   }
   
}