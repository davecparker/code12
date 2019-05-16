package Code12;  // Copyright (c) 2018-2019 Code12 

import java.awt.*;
import java.awt.geom.Rectangle2D;
import java.util.*;
import java.awt.font.FontRenderContext;
import java.awt.event.*;
import java.io.*;
import javax.swing.JOptionPane;


// A game where objects can be created and modified
public class Game implements GameInterface
{
   // The version number of the Code 12 Runtime
   private static final double VERSION = 2.0;
      
   //  Instance data
   Code12Program program;                // the main program callback interface
   GameWindow window;                    // The window that the game lives in
   int widthP, heightP;                  // The size of the game window in pixels
   final double WIDTH_L = 100.0;         // logical width is always 100 by definition
   double heightL;                       // logical height
   double scaleLToP;                     // scale factor for logical to pixel
   long startTimeMs;                     // system millisecond count at start of game
   Random randomGenerator;               // for random method
   PrintWriter printWriter;              // file to echo text output to or null if none
   GameInput input;                      // helper class to implement mouse and key input
   GameAudio audio;                      // helper class to implement audio
   HashMap<String, GameScreen> screens;  // set of named screens
   GameScreen screen;                    // the current screen
   FontRenderContext fontRenderContext;  // for measuring text
   double scalePToPoints;                // scale factor for pixels to points (font size)

 
   // Construct the game with the given initial window size in pixels
   Game(Code12Program program, GameWindow window, int widthP, int heightP)
   {
      this.program = program;
      this.window = window;
      setPixelSize(widthP, heightP);   // calculates heightL and scaleLToP
      startTimeMs = 0;                 // set for real when game timer starts
      printWriter = null;
      randomGenerator = new Random(System.currentTimeMillis());
      input = new GameInput(this);
      audio = new GameAudio(this);
      screens = new HashMap<String, GameScreen>();
      
      // Create initial screen with empty name ("")
      screen = new GameScreen("", WIDTH_L, heightL);
      screens.put(screen.name, screen);

      // Create a temp Graphics context and use it to get the fontRenderContext      
      Graphics2D g = (Graphics2D) window.getGraphics();
      fontRenderContext = g.getFontRenderContext();
      g.dispose();
      
      // Calculate scalePToPoints by measuring a known point size
      Font font100Point = new Font(Font.SANS_SERIF, Font.BOLD, 100);
      Rectangle2D boundsP = font100Point.getStringBounds("Test", fontRenderContext);
      scalePToPoints = 100.0 / boundsP.getHeight();
   }


   //================ Graphics Object Creation API ===================
   
   public GameObj circle(double x, double y, double diameter)
   {
      return circle(x, y, diameter, "red");
   }
       
   public GameObj circle(double x, double y, double diameter, String color)
   {
      GameObj obj = new GameCircle(this, x, y, diameter);
      obj.setFillColor(color);
      screen.addObj(obj);
      return obj;
   }

   public GameObj rect(double x, double y, double width, double height)
   {
      return rect(x, y, width, height, "yellow");
   }

   public GameObj rect(double x, double y, double width, double height, String color)
   {
      GameObj obj = new GameRect(this, x, y, width, height);
      obj.setFillColor(color);
      screen.addObj(obj);
      return obj;
   }

   public GameObj line(double x, double y, double x2, double y2)
   {
      return line(x, y, x2, y2, "black");
   }
                             
   public GameObj line(double x, double y, double x2, double y2, String color)
   {
      GameObj obj = new GameLine(this, x, y, x2, y2);
      obj.setLineColor(color);
      screen.addObj(obj);
      return obj;
   }

   public GameObj text(String text, double x, double y, double height)
   {
      return text(text, x, y, height, "black");
   }
   
   public GameObj text(String text, double x, double y, double height, String color)
   {
      if (text == null)
         text = "";
         
      GameObj obj = new GameText(this, text, x, y, height);
      obj.setFillColor(color);
      screen.addObj(obj);
      return obj;
   }

   public GameObj image(String filename, double x, double y, double width)
   {
      GameImage obj = new GameImage(this, filename, x, y);
      if (!obj.imageFound())
      {
         // Substitute text with red "X" for images that aren't found
         return text("[x]", x, y, width, "red");
      } 
      obj.setSize(width, width * obj.height / obj.width);
      screen.addObj(obj);
      return obj;
   }
   

   //================ Text Output API ===================

   public void print(Object obj)
   { 
      System.out.print(obj);
      if (printWriter != null)
         printWriter.print(obj);
   }
   
   public void println(Object obj)
   { 
      System.out.println(obj);
      if (printWriter != null)
         printWriter.println(obj);
   }
   
   public void println()
   {
      System.out.println();
      if (printWriter != null)
         printWriter.println();
   }

   public void log(Object... objs)     
   {
      // Print each object separated by commas
      if (objs != null && objs.length > 0)
      {
         int i = 0;
         while (i < objs.length - 1)   // not including last one
         {
            logValue(objs[i]);
            print(", ");
            i++;
         }
         logValue(objs[i]);   // last one without comma
      }  
      println();   // newline at the very end
   }
   
   public void logm(String message, Object... objs)     
   {
      print(message);
      print(" ");
      log(objs);
   }
   
   public void setOutputFile(String filename)
   {
      // Close existing file, if any
      if (printWriter != null)
      {
         printWriter.close();
         printWriter = null;
      }
      
      // Open the new file
      if (filename != null)
      {
         try
         {
            printWriter = new PrintWriter(filename);
         }
         catch (Exception ex)
         {
            logError("Cannot open output file", filename);
         }
      }
   }


   //================ Text Input API ===================

   public void showAlert(String message)
   {
      JOptionPane.showMessageDialog(window, message,
            window.getTitle(), JOptionPane.INFORMATION_MESSAGE);
   }
   
   public int inputInt(String message)
   {
      while (true)
      {
         String s = inputString(message);
         try
         {
            return Integer.parseInt(s.trim()); 
         }
         catch (Exception e)
         {
         }
      }
   }
   
   public double inputNumber(String message)
   {
      while (true)
      {
         String s = inputString(message);
         try
         {
            return Double.parseDouble(s.trim()); 
         }
         catch (Exception e)
         {
         }
      }
   }
   
   public boolean inputYesNo(String message)
   {
      int answer = JOptionPane.showConfirmDialog(window, message,
                        window.getTitle(), JOptionPane.YES_NO_OPTION);
      return answer == JOptionPane.YES_OPTION;
   }
   
   public String inputString(String message)
   {
      String answer = JOptionPane.showInputDialog(window, message, 
            window.getTitle(), JOptionPane.QUESTION_MESSAGE);
      if (answer == null)
         return "";    // user cancelled
      return answer;
   }


   //================ Screen Management API ===================
     
   public void setTitle(String title)       { window.setTitle(title); }
   public double getWidth()                 { return WIDTH_L; }
   public double getHeight()                { return heightL; }
   public double getPixelsPerUnit()         { return scaleLToP; }
   public String getScreen()                { return screen.name; }
   public void clearScreen()                { screen.clear(null); }
   public void clearGroup(String group)     { screen.clear(group); }


   public void setHeight(double height)
   {
      height = pinValue(height, 1, 10000);
      
      // New aspect requested, so adjust window accordingly
      heightP = (int) (height * scaleLToP);
      window.setPixelSize(widthP, heightP);
      setPixelSize(widthP, heightP); 
   }
 
   public void setScreen(String name)
   {
      if (name == null)
         name = "";
         
      // Does this screen name already exist?
      GameScreen newScreen = screens.get(name);
      if (newScreen != null)
      {
         screen = newScreen;    // change to existing screen
         screen.setSize(WIDTH_L, heightL);  // in case window was resized
      }
      else
      {
         // Create new screen and change to it
         screen = new GameScreen(name, WIDTH_L, heightL);
         screens.put(name, screen);
      }  
   }

   public void setScreenOrigin(double x, double y)
   {
      screen.xOrigin = x;
      screen.yOrigin = y;
   }
   
   public void setBackColor(String name)
   { 
      GameObj rc = new GameRect(this, WIDTH_L / 2, heightL / 2, WIDTH_L, heightL); 
      rc.setFillColor(name);
      screen.setBackObj(rc); 
   }
   
   public void setBackColorRGB(int r, int g, int b)
   {
      GameObj rc = new GameRect(this, WIDTH_L / 2, heightL / 2, WIDTH_L, heightL); 
      rc.setFillColorRGB(r, g, b);
      screen.setBackObj(rc);
   } 

   public void setBackImage(String filename)
   {
      if (filename == null)
         screen.setBackObj(null);
      else
      {
         GameObj img = new GameImage(this, filename, WIDTH_L / 2, heightL / 2);
         screen.setBackObj(img);
         screen.setSize(WIDTH_L, heightL);   // make image fill the screen
      }
   }


   //=============== Mouse and Keyboard Input API =====================
   
   public boolean clicked()         { return input.clicked; }  
   public double clickX()           { return input.clickX; }
   public double clickY()           { return input.clickY; }
   public GameObj objectClicked()   { return input.clickedObj; }

   
   public boolean keyPressed(String key)
   {
      if (key == null)
         return false;
      if (!input.keyNameToCode.containsKey(key))
         return false;
      return input.keysDown.get(input.keyNameToCode.get(key));
   }
   
   public boolean charTyped(String ch)
   {
      if (ch == null)
         return false;
      return (input.keyTyped != null) && (input.keyTyped.equals(ch));
   }      


   //========================= Audio API ===============================

   public void loadSound(String filename)      { audio.load(filename); }
   public void sound(String filename)          { audio.play(filename); }
   public void setSoundVolume(double d)        { audio.setVolume(d); }
 

   //====================== Math Utiliites API =========================
   
   public int random(int min, int max)
   {
      return randomGenerator.nextInt(max - min + 1) + min;
   }
      
   public int round(double d)
   {
      return (int) Math.round(d);
   }
   
   public double roundDecimal(double d, int numPlaces)
   {
      if (numPlaces <= 0)
         return Math.round(d);
      double f = Math.pow(10, numPlaces);
      return Math.rint(d * f) / f;
   }
   
   public double distance(double x1, double y1, double x2, double y2)
   {
      return Math.hypot(x1 - x2, y1 - y2);
   }
   
   public int intDiv(int n, int d)
   {
      if (d == 0)
      {
         if (n == 0)
            return 0;
         else if (n > 0)
            return Integer.MAX_VALUE;
         else
            return Integer.MIN_VALUE;
      }
      return Math.floorDiv(n, d);
   }

   public boolean isError(double d)
   {
      return Double.isNaN(d);
   }

  
   //===================== Type Conversion API ========================
   
   public int toInt(double d)
   {
      return (int) d;
   }
   
   public int parseInt(String s)
   {
      int result = 0;  // if failure
      try
      {
         result = Integer.parseInt(s.trim());
      }
      catch (Exception e)
      {
      }
      return result;
   }
   
   public double parseNumber(String s)
   {      
      double result = Double.NaN;   // if failure
      try
      {
         result = Double.parseDouble(s.trim());
      }
      catch (Exception e)
      {
      }
      return result;
   }
   
   public boolean canParseInt(String s)
   {
      boolean result = true;
      try
      {
         Integer.parseInt(s.trim());
      }
      catch (Exception e)
      {
         result = false;
      }
      return result;
   }
   
   public boolean canParseNumber(String s)
   {
      boolean result = true;
      try
      {
         Double.parseDouble(s.trim());
      }
      catch (Exception e)
      {
         result = false;
      }
      return result;
   }
   
   public String formatInt(int i)
   {
      return String.valueOf(i);
   }
   
   public String formatInt(int i, int numDigits)
   {
      if (numDigits <= 0)
         return "";
      
      String fmt = "%0" + numDigits + "d";
      return String.format(fmt, i);
   }

   public String formatDecimal(double d)
   {
      return String.valueOf(d);
   }
   
   public String formatDecimal(double d, int numPlaces)
   {
      if (numPlaces <= 0)
         return String.valueOf((int) Math.rint(d));
      
      String fmt = "%." + numPlaces + "f";
      return String.format(fmt, d);
   }
   

   //====================== Program Control API =========================
   
   public int getTimer()
   {
      // Returning an int, this lasts 23 days before a roll-over.
      if (startTimeMs == 0)
         return 0;   // called before start
      return (int) (System.currentTimeMillis() - startTimeMs);
   }
   
   public double getVersion()
   {
      return VERSION;
   }
      
   public void pause()
   {
      logError("ct.pause() is not supported by the standalone Java runtime");
   }
   
   public void stop()
   {
      logError("ct.stop() is not supported by the standalone Java runtime");
   }
   
   public void restart()
   {
      logError("ct.restart() is not supported by the standalone Java runtime");
   }   


   //===============================================================
   //                      Internal Methods 
   //===============================================================
         
   // Return value pinned to the given range
   double pinValue(double value, double min, double max)
   {
      if (value < min)
         return min;
      if (value > max)
         return max;
      return value;
   }
   
   // Return value pinned to the given range
   int pinValue(int value, int min, int max)
   {
      if (value < min)
         return min;
      if (value > max)
         return max;
      return value;
   }

   // Start the game timer
   void startTimer()
   {
      startTimeMs = System.currentTimeMillis();
   }

   // Set the stacking layer for an object
   void setObjLayer(GameObj obj, int layer)
   {
      // Setting layer always re-inserts on top of the given layer
      if (screen.removeObj(obj))
      {
         obj.layer = layer;
         screen.addObj(obj);
      }
   }
   
   // Remove a GameObj from the game. 
   void deleteObj(GameObj obj)
   {
      obj.markDeleted();
      input.invalObj(obj);
      screen.removeObj(obj);
   }
   
   // Draw the game onto the given graphics surface
   void draw(Graphics2D g)
   {
      screen.draw(g, scaleLToP);
   }
   
   // Update the game for the next frame
   void update()
   {
      input.preUpdate();
      screen.update();
      input.postUpdate();
   }

   // Update the size of the game window in pixels
   void setPixelSize(int widthP, int heightP)
   {
      this.widthP = widthP;
      this.heightP = heightP;
      scaleLToP = widthP / WIDTH_L;
      heightL = heightP / scaleLToP;
      
      // Tell the screen that it resized so objects can adjust if necessary
      if (screen != null)
         screen.setSize(WIDTH_L, heightL);
   }

   // Return font point size to use to get text of the given logical height
   int fontPointSizeFromHeight(double height)
   {
      return (int) (height * scaleLToP * scalePToPoints); 
   }
   
   // Return the logical width of a text string drawn in the given font
   double textWidth(String text, Font font)
   {
      Rectangle2D boundsP = font.getStringBounds(text, fontRenderContext);
      return boundsP.getWidth() / scaleLToP;
   }
   
   // Find and return the topmost clickable object that contains 
   // the pixel location (xP, yP), or return null if none.
   GameObj findHitObject(int xP, int yP)
   {
      return screen.findHitObject(xP / scaleLToP, yP / scaleLToP);
   }
   
   // Find and return the first object in group that obj intersects with
   // (or consider all objects if group is null), or return null if none.
   GameObj hitTestGroup(GameObj obj, String group)
   {
      return screen.hitTestGroup(obj, group);
   }   

   // Print a value as it should appear in ct.log output
   void logValue(Object value)
   {
      if (value instanceof String)
      {
         print("\"");
         print(value);
         print("\"");
      }
      else
      {
         print(value.toString());
      }
   }

   // Log an error message
   void logError(String message)
   {
      println("ERROR: " + message);
   }

   // Log an error message plus a quoted string
   void logError(String message, String s)
   {
      println("ERROR: " + message + " \"" + s + "\"");
   }
   
   // Flush the output file, if any
   void flushOutput()
   {
      if (printWriter != null)
         printWriter.flush();
   }
}
