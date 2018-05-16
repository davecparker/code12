package Code12;  // (c)Copyright 2018 by David C. Parker 


// The default class (superclass) for a Code12 program.
// The main program will subclass (extend) this class.
public class Code12Program
{
   // The public instance for the main global API
   public Game ct;
   

   // This is called once at the start of the app.
   void start()
   {
   }
   
   // This is called 60 times per second once the app starts
   // (less if the app waits for input or performs lengthy operations).
   void update()
   {
   }

   // A mouse press has occured at x, y.
   // If obj != null, it is the topmost clickable object clicked.   
   void onMousePress(GameObj obj, double x, double y)
   {
   }
   
   // The mouse has dragged to x, y.
   // If obj != null, it is the object that got the onMousePress.   
   void onMouseDrag(GameObj obj, double x, double y)
   {
   }

   // The mouse has been released at x, y.
   // If obj != null, it is the object that got the onMousePress.   
   void onMouseRelease(GameObj obj, double x, double y)
   {
   }
    
   // A key has been pressed.
   void onKeyPress(String key)
   {
   }

   // A key has been released.
   void onKeyRelease(String key)
   {
   }
   
   // A character has been typed.
   void onCharTyped(String ch)
   {
   }
      
   // The game window has been resized.
   void onResize()
   {
   }
}
