import Code12.*;

class BubblePop extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new BubblePop()); 
   }
   
   public void start()
   {
      // Make the background 
      ct.setHeight(150);
      ct.setBackImage("underwater.jpg"); 
   }
   
   public void update()
   {
      // Make bubbles at random times, positions, and sizes
      if (ct.random(1, 20) == 1)
      {
         double x = ct.random(0, 100);
         double y = ct.getHeight() + 25;
         double size = ct.random(5, 20);
         GameObj bubble = ct.image("bubble.png", x, y, size);
         bubble.ySpeed = -1;
         bubble.clickable = true;
      }
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Pop bubbles that get clicked
      if (obj != null)
      {
         obj.delete();
         ct.sound("pop.wav");
      }
   }
}
