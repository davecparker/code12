package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;
import java.awt.image.BufferStrategy;
import java.awt.event.*;
import javax.swing.Timer;


// A canvas containing a Game that animates at a regular frame rate.
// We subclass Canvas but then implement manual repainting.
class GameCanvas extends Canvas implements ActionListener 
{
   // Instance data
   private final int FPS = 60;          // The animation frames per second
   private Dimension size;              // pixel size of the canvas
   private Code12Program program;       // the main program callback interface
   private Game game;                   // The game state  
   private boolean repainting = false;  // to prevent overlapping redraws
   

   // Construct a GameCanvas with the given program callback interface
   GameCanvas(Code12Program program) 
   {
      this.program = program;
      setIgnoreRepaint(true);   // we repaint manually via timer
      setFocusable(true);       // try to start with the focus
   }
   
   // Setup the game and the program's game objects
   void setupGame(GameWindow window, int width, int height)
   {
      game = new Game(program, window, width, height);
      program.ct = game;
      game.startTimer();
      program.start();     // main program creates objects here
      game.flushOutput();  // make sure output in start is written

      // Add input event listeners, sent to the GameInput helper
      addMouseListener(game.input);
      addKeyListener(game.input);
      setFocusTraversalKeysEnabled(false);
   }   
   
   // Start the frame update timer
   void startFrameTimer()
   {    
      // Make a system timer that calls actionPerformed() at each frame
      int ms = 1000 / FPS;   // frame time in milliseconds
      Timer timer = new Timer(ms, this);
      timer.start();
   }
    
   // Action function for frame timer: Update and redraw the canvas.
   public void actionPerformed(ActionEvent e)
   {
      // Check to see if the user resized the window 
      Dimension newSize = getSize();
      if (size == null)
         size = newSize;    // initial size after window show
      else if (newSize != null)
      {
         if (newSize.width != size.width || newSize.height != size.height)
         {
            // Update game size and notify the main program
            size = newSize;
            game.setPixelSize(size.width, size.height);
            program.onResize();
         }
      }

      // Let the game update its object positions
      program.update();
      game.update();
       
      // Repaint the canvas manually
      repaintAll();
   }
    
   // Method to manually repaint the canvas using our fast buffering
   private void repaintAll() 
   {
      // Make sure we don't process overlapping calls
      if (repainting)
         return;
      repainting = true;
         
      // Do a repaint on the page that is not currently showing
      BufferStrategy strategy = getBufferStrategy();
      Graphics2D g = (Graphics2D) strategy.getDrawGraphics();
      if (g != null)
      {
         // Start with a white background
         g.setColor(Color.WHITE);
         g.fillRect(0, 0, size.width, size.height);
         
         // Draw the game
         game.draw(g);
         g.dispose();
      }
        
      // Switch buffers to show the page we just painted
      strategy.show();
      Toolkit.getDefaultToolkit().sync();
        
      // Allow the next repaint
      repainting = false;
   }
   
   // Prepare to quit the game
   void prepareToQuit()
   {
      game.flushOutput();
      game.setOutputFile(null);
   }
}

