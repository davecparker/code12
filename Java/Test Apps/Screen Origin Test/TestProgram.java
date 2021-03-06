import Code12.*;

class TestProgram extends Code12Program
{
   double xOrigin = 50;
   double yOrigin = 0;
   GameObj dot, r;

   public static void main(String[] args)
   { 
      Code12.run(new TestProgram()); 
   }
   
   // Start function
   public void start()
   {
      // Make the background
      ct.setBackImage("underwater.jpg");
      dot = ct.circle(50, 50, 10);
      r = ct.rect(25, 75, 10, 50);
      r.group = "targets";   // things we can delete
      r = ct.rect(75, 75, 10, 50);
      r.group = "targets";
      GameObj t = ct.text("Hello", 50, 25, 10);
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

      // Move the dot with the arrow keys
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
