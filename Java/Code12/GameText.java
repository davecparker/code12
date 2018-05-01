package Code12;  // (c)Copyright 2018 by David C. Parker 

import java.awt.*;
import java.awt.geom.Rectangle2D;


// A text object that can be created in a Game
public class GameText extends GameObj
{
   // Protected instance data
   protected Font font;           // the cached font to draw in 
   protected int fontSize;        // size of cached font in points

   // Construct a text object with the given string, location, and height. 
   // The width is determined automatically.
   GameText(Game game, String text, double x, double y, double height)
   {
      // Create the GameObj
      super(game, x, y, 0, height);   // width is set below
      type = "text";
      this.text = text;
                  
      // Create the font and measure the text to set width
      makeFont(game.fontPointSizeFromHeight(height));  // sets font and fontSize
      width = game.textWidth(text, font);     
   }
     
   // Set the text of the object
   @Override
   public void setText(String text)
   {
      super.setText(text);
      width = game.textWidth(text, font);    // compute new width   
   }
   
   // Create and set the font given the point size
   protected void makeFont(int pointSize)
   {
      fontSize = pointSize;   // remember size last used
      font = new Font(Font.SANS_SERIF, Font.BOLD, fontSize);
   }
      
   // Draw the text into the given graphics surface
   protected void draw(Graphics2D g)
   {
       if (fillColor != null)
       {
          g.setColor(fillColor);
          
          // See what font size is necessary to draw now, and
          // re-create the font and re-measure width if necessary.
          int fontSizeNeeded = game.fontPointSizeFromHeight(height);
          if (fontSizeNeeded != fontSize)
          {
             makeFont(fontSizeNeeded);
             width = game.textWidth(text, font);   
          }     
             
         // Calculate rounded pixel drawing location using alignment.
         // Estimate the baseline at 85% of way down from the top.
         double scale = game.scaleLToP;
         int leftP = (int) (((x - (width * xAlignFactor)) * scale) + 0.5);
         int baselineP = (int) (((y - (height * (yAlignFactor - 0.85))) * scale) + 0.5);
    
         // Draw the text        
         g.setFont(font);   
         g.drawString(text, leftP, baselineP);
      }
   }
}
