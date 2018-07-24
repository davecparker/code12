package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;
import java.util.*;
import java.awt.event.*;


// A helper class to implement mouse and keyboard input for the Game class
public class GameInput implements MouseListener, KeyListener
{   
   //  Instance data
   Game game;                  // back pointer to the Game object
   Code12Program program;      // the Game's main program callback interface
   boolean mouseDown;          // true if mouse is down and being tracked
   GameObj mouseObj;           // object getting mouse events if mouseDown
   int xMouseP, yMouseP;       // last mouse pixel position
   boolean clicked;            // true if a click happened in this update cycle
   GameObj clickedObj;         // object considered clicked in this update cycle
   HashMap<String, Integer> keyNameToCode;  // map e.g. "up" to KeyEvent.UP
   String[] keyCodeToName;     // map e.g. KeyEvent.UP to "up"
   BitSet keysDown;            // true if key code is currently down
   String keyTyped;            // key (char) typed during this update cycle
 

   // Construct the GameInput helper with back pointer to the game
   GameInput(Game game)
   {
      this.game = game;
      program = game.program;
      mouseDown = false;
      mouseObj = null;
      xMouseP = 0;
      yMouseP = 0;
      clicked = false;
      clickedObj = null;
      keyNameToCode = new HashMap<String, Integer>();
      keyCodeToName = new String[KeyEvent.KEY_LAST + 1];
      makeKeyMaps();
      keysDown = new BitSet();
      keyTyped = null;
   }


   //========== MouseListener Methods ===============

   public void mousePressed(MouseEvent e)
   {
      xMouseP = e.getX();
      yMouseP = e.getY();
      double x = xMouseFromP(xMouseP);
      double y = yMouseFromP(yMouseP);
      
      // Find clickable object that was hit if any
      mouseObj = game.screen.findHitObject(x, y);
      program.onMousePress(mouseObj, x, y);
      mouseDown = true;
      clicked = true;
      clickedObj = mouseObj;
   }
     
   public void mouseReleased(MouseEvent e)
   {
      xMouseP = e.getX();
      yMouseP = e.getY();
      double x = xMouseFromP(xMouseP);
      double y = yMouseFromP(yMouseP);

      // Automatic mouse "capture" always sends release to same obj that got press
      program.onMouseRelease(mouseObj, x, y);
      mouseDown = false;
      mouseObj = null;            
   }

   // Unused events
   public void mouseClicked(MouseEvent e) {}
   public void mouseEntered(MouseEvent e) {}
   public void mouseExited(MouseEvent e)  {}


   //========== KeyListener Methods ===============

   public void keyPressed(KeyEvent e)
   {
      int keyCode = e.getKeyCode();
      if (keyCode < keyCodeToName.length)
      {
         String keyName = keyCodeToName[keyCode];
         keysDown.set(keyCode);  // Mark this key as currently down
         if (keyName != null)    // Send event to client if name is known
            program.onKeyPress(keyName);
      }
   }
   
   public void keyReleased(KeyEvent e)
   {
      int keyCode = e.getKeyCode();
      if (keyCode < keyCodeToName.length)
      {
         String keyName = keyCodeToName[keyCode];
         keysDown.clear(keyCode);  // Mark this key as no longer down
         if (keyName != null)      // Send event to client if name is known
            program.onKeyRelease(keyName);
      }
   }
    
   public void keyTyped(KeyEvent e)
   {
      // Use whatever string Java thinks was typed (e.g. "a", "A", etc.)
      String keyText = String.valueOf(e.getKeyChar());
      keyTyped = keyText;
      program.onCharTyped(keyText);
   }


   //===================== Internal Methods ========================

   // Return the logical x-coordinate for the physical mouse position xP 
   // that is in pixels with respect to the upper-left of the game window.
   double xMouseFromP(double xP)
   {
      return xP / game.scaleLToP + game.screen.xOrigin;
   }

   // Return the logical y-coordinate for the physical mouse position yP 
   // that is in pixels with respect to the upper-left of the game window.
   double yMouseFromP(double yP)
   {
      return yP / game.scaleLToP + game.screen.yOrigin; 
   }

   // Do any processing necessary before a game frame update
   void preUpdate()
   {
      // Check if a tracking object was deleted
      if (mouseObj != null && mouseObj.deleted)
         mouseObj = null;
      if (clickedObj != null && clickedObj.deleted)
         clickedObj = null;
         
      // Check for and send mouseDrag event if necessary
      if (mouseDown)
      {
         Point pt = MouseInfo.getPointerInfo().getLocation();
         Point origin = game.window.canvas.getLocationOnScreen();
         int xNewP = pt.x - origin.x;
         int yNewP = pt.y - origin.y + 1;  // Java seems off by 1 here
         if (xNewP != xMouseP || yNewP != yMouseP)
         {
            double scale = game.scaleLToP;
            double x = xMouseP / scale;
            double y = yMouseP / scale;
            program.onMouseDrag(mouseObj, x, y);
            xMouseP = xNewP;
            yMouseP = yNewP;
         }
      }
   }

   // Do any processing necessary after a game frame update
   void postUpdate()
   {
      clicked = false;   
      clickedObj = null;
      keyTyped = null;
   }

   // Invalidate any references to obj because it is being deleted
   void invalObj(GameObj obj)
   {
      if (mouseObj == obj)
         mouseObj = null;
      if (clickedObj == obj)
         clickedObj = null;
   }

   // Enter the mapping from key name to code in keyNameToCode,
   // and also the mapping from key code to name in keyCodeToName. 
   private void mapKeyNameToCode(String name, int code)
   {
      keyNameToCode.put(name, code);
      keyCodeToName[code] = name;
   }
   
   // Build the keyNameToCode and keyCodeToName maps.
   // Most key names are taken from a subset of the Corona SDK key event names
   // (https://docs.coronalabs.com/api/event/key/keyName.html)
   private void makeKeyMaps()
   {
      char ch;
      int code;
      
      // Letter keys
      for (ch = 'a', code = KeyEvent.VK_A; ch <= 'z'; ch++, code++)
      {
         mapKeyNameToCode(String.valueOf(ch), code);  // "a" to "z"
      }
      
      // Number and Number Pad keys
      for (ch = '0', code = KeyEvent.VK_0; ch <= '9'; ch++, code++)
      {
         mapKeyNameToCode(String.valueOf(ch), code);  // "0" to "9"
      }
      for (ch = '0', code = KeyEvent.VK_NUMPAD0; ch <= '9'; ch++, code++)
      {
         mapKeyNameToCode("numPad" + ch, code);  // "numPad0" to "numPad9"
      }
      
      // Arrow keys
      mapKeyNameToCode("up", KeyEvent.VK_UP);
      mapKeyNameToCode("down", KeyEvent.VK_DOWN);
      mapKeyNameToCode("left", KeyEvent.VK_LEFT);
      mapKeyNameToCode("right", KeyEvent.VK_RIGHT);
      
      // Misc keys
      mapKeyNameToCode("space", KeyEvent.VK_SPACE);
      mapKeyNameToCode("enter", KeyEvent.VK_ENTER);
      mapKeyNameToCode("tab", KeyEvent.VK_TAB);
      mapKeyNameToCode("backspace", KeyEvent.VK_BACK_SPACE);  // Corona: "deleteBack"
      mapKeyNameToCode("escape", KeyEvent.VK_ESCAPE);     
   }
}
