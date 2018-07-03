package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;
import java.util.*;


// A screen (named subset of objects) in a Game
public class GameScreen
{
   // Instance data that Game can access
   String name;                    // name of the screen
   double width, height;           // logical size of the screen
   
   // Private instance data
   private GameObj backObj;                // background rect or image or null if none
   private ArrayList<GameObj> objects;     // The objects in this screen


   // Construct a new screen with the given name and initial size
   public GameScreen(String name, double width, double height)
   {
      this.name = name;
      this.width = width;
      this.height = height;
      backObj = null;
      objects = new ArrayList<GameObj>();
   }
   
   // Set the background object
   void setBackObj(GameObj obj)
   { 
      backObj = obj;
   }
   
   // Add an object to the top of its layer
   void addObj(GameObj obj)
   {
      // Find index for the top of this layer
      int i = objects.size() - 1; 
      while (i >= 0 && objects.get(i).layer > obj.layer)
      {
          i--;   // will go to -1 if we need to insert at the bottom
      }
      
      // Add the object
      objects.add(i + 1, obj); 
   }

   // Remove an object from the screen but don't delete it. 
   // Return true if the object was found and removed.
   boolean removeObj(GameObj obj)
   { 
      return objects.remove(obj); 
   }
   
   // Delete objects with the given group name, or all objects if group is null 
   void clear(String group)                           
   {
      // Delete matching objects from the ArrayList in reverse order
      for (int i = objects.size() - 1; i >= 0; i--)
      {
         GameObj obj = objects.get(i);
         if (group == null || obj.group.equals(group))
         {
            obj.markDeleted();
            objects.remove(i);
         }
      }
   }

   // Change the screen size and adjust the contents as necessary
   void setSize(double widthNew, double heightNew)
   {
      // Adjust the background object if any
      if (backObj != null)
      {
         // Re-center it
         backObj.x = widthNew / 2;
         backObj.y = heightNew / 2;
         
         // Resize it
         if (backObj instanceof GameImage)
         {
            // Use as much of the image as possible while filling 
            // the window and retaining the image aspect ratio.
            double aspect = backObj.width / backObj.height;
            if (aspect > (widthNew / heightNew))
               backObj.setSize(heightNew * aspect, heightNew);
            else
               backObj.setSize(widthNew, widthNew / aspect);
         }
         else
         {
            // Resize non-image to simply fill the window
            backObj.setSize(widthNew, heightNew);
         }
      }
      
      // If the height changed, adjust the objects as necessary.      
      if (heightNew != height)
      {         
         for (GameObj obj: objects)
         {
            obj.updateForWindowResize(height, heightNew);
         }
      }
      
      // Store the new size
      width = widthNew;
      height = heightNew;
   }

   // Draw the screen onto the given graphics surface
   void draw(Graphics2D g)
   {
      // Draw the background if any
      if (backObj != null)
         backObj.draw(g);
         
      // Draw the visible objects
      for (GameObj obj: objects)
      {
         if (obj.visible)
            obj.draw(g);
      }
   }
   
   // Update the objects for the next frame
   void update()
   {
      // Update the objects. Note that objects may be deleted during the loop. 
      int i = 0;
      while (i < objects.size())
      {
         GameObj obj = objects.get(i);
         
         // Check for autoDelete
         if (obj.shouldAutoDelete())
            objects.remove(i);
         else
         { 
            obj.update();
            i++;
         }
      }
   }
   
   // Find and return the topmost clickable object that contains 
   // the logical point (xL, yL), or return null if none.
   GameObj findHitObject(double xL, double yL)
   {
      // Search objects in reverse (top-down) order
      for (int i = objects.size() - 1; i >= 0; i--)
      {
         GameObj obj = objects.get(i);
         if (obj.clickable && obj.visible)
         {
            if (obj.containsPoint(xL, yL))
               return obj;
         } 
      }
      return null;  // none found
   } 
}
