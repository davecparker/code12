class BubblePop
{
   // Variables to keep track of hits and misses
   int hits = 0;
   int misses = 0;

   public void start()
   {
      // Make the background 
      ct.setBackImage("underwater.jpg"); 

      // Pre-load the pop sound
      ct.loadSound("pop.wav");
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
         bubble.autoDelete = true;
      }
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Pop bubbles that get clicked, and count hits and misses
      if (obj == null)
         misses++;
      else
      {
         obj.delete();
         ct.sound("pop.wav");
         hits++;
      }
      ct.println(hits + " hits, " + misses + " misses");
   }
}
