import Code12.*;

class BasicTest extends Code12Program
{
   GameObj circle, fish, wall;  

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
      ct.log(t);
      ct.log(t.getText());

      GameObj r = ct.rect(50, 50, 50, 50, "pink");
      r.clickable = true;
      
      circle = ct.circle(50, 20, 10, "orange");
      circle.setFillColorRGB(400, 127, -50);
      circle.clickable = true;
      circle.group = "dots";

      GameObj cc = ct.circle(50, 50, 10);
      cc.group = "dots";
            
      wall = ct.rect(50, ct.getHeight(), 10, 50);
      wall.align("bottom");
      wall.setLayer(0);
      ct.log(wall);
      
      GameObj line = ct.line(0, 0, ct.getWidth(), ct.getHeight());
      line.setLineColorRGB(0, 100, 200);
      line.lineWidth = 5;
      line.align("left");
            
      double x = 150; // ct.inputNumber("Enter x coordinate:");
      if (!ct.isError(x))
      {
         fish = ct.image("goldfish.png", x, 85, 20);
         // fish.setText("Bob");
         fish.clickable = true;
         ct.log(fish);
         fish.xSpeed = -1;
         // fish.autoDelete = true;
      }
            
      ct.setSoundVolume(0.7);
   }
   
   public void update()
   {      
      if (fish.x < -30)
         fish.x = 130;
      else if (fish.x > 130)
         fish.x = -30;
         
      if (fish.hit(wall))
         fish.xSpeed = -fish.xSpeed;
      
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
         fish.setSize(fish.width * scale, fish.height * scale);
      else if (ct.charTyped("-"))
         fish.setSize(fish.width / scale, fish.height / scale);
         
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
