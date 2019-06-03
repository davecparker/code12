import Code12.*;

class BasicTest extends Code12Program
{
   String author = "Dave";
   String title;
   GameObj circle, fish, wall;
   GameObj [] fishes = new GameObj[3];  

   public static void main(String[] args)
   { 
      Code12.run(new BasicTest()); 
   }
   
   public void start()
   {  
      ct.setTitle("Fish and Shapes Test");          
      ct.setHeight(178);      
      
      ct.println("Code 12 Version " + ct.getVersion());
      ct.logm("Screen size:", ct.getWidth(), ct.getHeight());
      ct.logm("Scale factor:", ct.getPixelsPerUnit());
      ct.print("Testing the ");
      ct.print("API");
      ct.println();
      ct.log(ct.intDiv(9,2));
      ct.log(ct.canParseInt("-3"), ct.canParseInt(" -3"), ct.canParseInt("-3 e2"));
      ct.log(ct.parseInt("-3"), ct.parseInt(" -3"), ct.parseInt("-3 e2"));
      ct.log(ct.canParseNumber("-3.14"), ct.canParseNumber(" -3.14"), ct.canParseNumber("-3e2g"));
      ct.log(ct.parseNumber("-3"), ct.parseNumber(" -3.14"), ct.parseNumber("-3e2"));

      // Game Over screen
      ct.setScreen("end");
      ct.setBackColor("light yellow");
      GameObj m = ct.text("Game Over!", 50, ct.getHeight() / 2, 10);
      m.align("center");

      // Main screen
      ct.setScreen("main");
      ct.setBackImage("underwater.jpg");
                               
      GameObj t = ct.text("Hello!", 50, 50, 10, "purple");
      t.align("left");
      t.setLayer(2);
      t.setClickable(false);
      ct.log(t);
      ct.log(t.getText());

      GameObj r = ct.rect(50, 50, 50, 50, "pink");
      
      circle = ct.circle(50, 20, 10, "orange");
      circle.setFillColorRGB(400, 127, -50);
      circle.group = "dots";

      GameObj cc = ct.circle(50, 50, 10);
      cc.group = "dots";
            
      wall = ct.rect(50, ct.getHeight(), 10, 50);
      wall.align("bottom");
      wall.setLayer(0);
      ct.log(wall);
      
      GameObj line = ct.line(0, 0, ct.getWidth(), ct.getHeight());
      line.setLineColorRGB(0, 100, 200);
      line.setLineWidth(5);
      line.align("left");
            
      double x = 150; // ct.inputNumber("Enter x coordinate:");
      if (!ct.isError(x))
      {
         fish = ct.image("goldfish.png", x, 85, 20);
         // fish.setText("Bob");
         ct.log(fish);
         fish.setXSpeed(-1);
         fishes[1] = fish;
      }
            
      ct.setSoundVolume(0.7);
   }
   
   public void update()
   {
      String screen = ct.getScreen();
      if (screen.equals("end"))
         return;

      if (fish.x < -30)
         fish.x = 130;
      else if (fish.x > 130)
         fish.x = -30;
         
      if (fish.hit(wall))
      {
         fish.setXSpeed(0);
         ct.println("Hit");
         // wall.visible = false;
      }
      
      if (circle.clicked())
      {
         ct.logm("Clicked", circle);
         ct.clearGroup("dots");
      }
      else if (fish.clicked())
      {
         ct.log("Clicked " + fish.toString());
         // ct.clearScreen();
         ct.setScreen("end");
      }
      else if (ct.objectClicked() != null)
         ct.logm("Object clicked", ct.objectClicked());
      else if (ct.clicked())
      {
         ct.logm("Click at", ct.clickX(), ct.clickY());
         ct.sound("bubble.wav");
      }
      
      if (ct.keyPressed("up"))
         fish.y--;
      else if (ct.keyPressed("down"))
         fish.y++;
         
      double scale = 1.2;
      if (ct.charTyped("+"))
         fish.setSize(fish.getWidth() * scale, fish.getHeight() * scale);
      else if (ct.charTyped("-"))
         fish.setSize(fish.getWidth() / scale, fish.getHeight() / scale);
      else if (ct.charTyped("f"))
         fish.setXSpeed(-1);
      else if (ct.charTyped("r"))
         fish.setXSpeed(1);         
      else if (ct.charTyped("u"))
         fish.setYSpeed(fish.getYSpeed() - 0.2);
      else if (ct.charTyped("d"))
         fish.setYSpeed(fish.getYSpeed() + 0.2);         
      else if (ct.charTyped("s"))
      {
         fish.setXSpeed(0);         
         fish.setYSpeed(0);         
      }
   }

/*      
   public void onResize()
   {
      ct.log("Resize");
   }

   public void onMousePress(GameObj obj, double x, double y)
   {
      if (obj != null)
         ct.log("Press " + obj);
      else
         ct.log("Press at " + x + ", " + y);
   }

   public void onMouseDrag(GameObj obj, double x, double y)
   {
      if (obj != null)
         ct.log("Drag " + obj);
      else
         ct.log("Drag at " + x, y);
   }

   public void onMouseRelease(GameObj obj, double x, double y)
   {
      if (obj != null)
         ct.log("Release " + obj);
      else
         ct.log("Release at " + x, y);
   }
*/
}
