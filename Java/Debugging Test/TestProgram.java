import Code12.*;

class TestProgram extends Code12Program
{
   double xOrigin = 0;
   GameObj dot;

   public static void main(String[] args)
   { 
      Code12.run(new TestProgram()); 
   }
   
   public void start()
   {
      dot = ct.circle(50, 50, 10);
      GameObj r = ct.rect(25, 75, 10, 50);
      r.group = "walls";
      r = ct.rect(75, 75, 10, 50);
      r.group = "walls";
   }
   
   public void update()
   {
      if (ct.keyPressed("right"))
      {
         xOrigin += 10;
         ct.setScreenOrigin(xOrigin, 0);
      }
      else if (ct.keyPressed("left"))
      {
         xOrigin -= 10;
         ct.setScreenOrigin(xOrigin, 0);
      }

      if (ct.charTyped("a"))
         dot.x--;
      else if (ct.charTyped("d"))
         dot.x++;
      else if (ct.charTyped("w"))
         dot.y--;
      else if (ct.charTyped("s"))
         dot.y++;
      
      GameObj hit = dot.objectHitInGroup("walls");
      if (hit != null)
         hit.delete();

      GameObj clicked = ct.objectClicked();
      if (clicked != null)
         clicked.delete();

   }
   
}