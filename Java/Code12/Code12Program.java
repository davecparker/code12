package Code12;  // Copyright (c) 2018-2019 Code12 


// The default class (superclass) for a Code12 program.
// The main program will subclass (extend) this class.
public class Code12Program
{
   // The public instance for the main global API
   public Game ct;
   

   // This is called once at the start of the app.
   public void start()
   {
   }
   
   // This is called 60 times per second once the app starts
   // (less if the app waits for input or performs lengthy operations).
   public void update()
   {
   }

   // A mouse press has occured at x, y.
   // If obj != null, it is the topmost clickable object clicked.   
   public void onMousePress(GameObj obj, double x, double y)
   {
   }
   
   // The mouse has dragged to x, y.
   // If obj != null, it is the object that got the onMousePress.   
   public void onMouseDrag(GameObj obj, double x, double y)
   {
   }

   // The mouse has been released at x, y.
   // If obj != null, it is the object that got the onMousePress.   
   public void onMouseRelease(GameObj obj, double x, double y)
   {
   }
    
   // A key has been pressed.
   public void onKeyPress(String key)
   {
   }

   // A key has been released.
   public void onKeyRelease(String key)
   {
   }
   
   // A character has been typed.
   public void onCharTyped(String ch)
   {
   }
      
   // The game window has been resized.
   public void onResize()
   {
   }
}
