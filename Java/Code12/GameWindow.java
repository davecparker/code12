package Code12;  // (c)Copyright 2018 by David C. Parker 

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import java.awt.BorderLayout;
import java.awt.Dimension;


// A window for a game to run in
public class GameWindow extends JFrame
{
   // Instance data
   GameCanvas canvas;    // the drawing surface
   
   // Start a game window with the given title and window size
   public static void start(Code12Program program, String title, int pixelSize) 
   {
      // Create a GameWindow on the event dispatch thread for proper GUI updates
      SwingUtilities.invokeLater(new Runnable() 
         {
            public void run() 
            {
               // Make the window with our title and initially square size
               new GameWindow(program, title, pixelSize, pixelSize);
            }
         }
      );
   }

   // Construct a GameWindow
   GameWindow(Code12Program program, String title, int width, int height) 
   {
      // Create the JFrame with the given title for the window
      super(title);
      
      // Position the window near upper-left corner of screen
      setLocation(10, 60);
      setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);  // closing window quits the app

      // Fill the whole window with our Canvas subclass
      canvas = new GameCanvas(program);
      add(canvas, BorderLayout.CENTER);
      setPixelSize(width, height);
      
      // Setup the canvas and run the client setup method
      canvas.setupGame(this, width, height);

      // Now show the window and start the redraw loop
      setVisible(true);
      canvas.createBufferStrategy(2);  // use double buffering for smooth draws
      canvas.requestFocus();
      canvas.startFrameTimer();
   }
   
   // Set the pixel size of the content area of the window
   void setPixelSize(int width, int height)
   {
      canvas.setSize(width, height);
      pack();    // set overall window size with room for title bar, etc.
   }   
}

