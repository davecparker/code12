package Code12;  // Copyright (c) 2018-2019 Code12 

import java.awt.*;
import java.io.File;
import javax.swing.ImageIcon;


// An image object that can be created in a Game
public class GameImage extends GameObj
{
   // Private instance data
   private boolean found;                 // true if image file was found 
   private Image rawImage;                // unscaled image as loaded from file
   private Image scaledImage;             // cached scaled image as last drawn or null
   private double widthPImg, heightPImg;  // pixel size of scaledImage
   
   
   // Construct an image from the filename at the given location
   GameImage(Game game, String filename, double x, double y)
   {
      // Create the GameObj
      super(game, x, y, 10, 10);  // real size set below, stub in case of failure
      type = "image";
      
      // Set image and default to full pixel size of image initially
      setImageFilename(filename, false);

      // Default to no extra fill and no frame
      setFillColor(null);         // fill color is currently ignored actually
      setLineColor(null);
      
   }

   // Set the image given the filename. If keepSize then keep the existing
   // width and height, otherwise set size to the full pixel size of the image.
   public void setImageFilename(String filename, boolean keepSize)
   {
      // If the file can't be found, warn the user
      text = filename;     // Store filename in text field by default
      found = false;
      rawImage = null;
      if (filename != null)
      {
         String path = filename;
         if (!(new File(path)).isFile())
            game.logError("Cannot find image file", filename);
         else
         {           
            // Load the raw image
            found = true; 
            ImageIcon icon = new ImageIcon(path);  // loads asynchronously unfortunately
            rawImage = icon.getImage();  // blank image until loaded or if not found
            
            // Set the initial size as full pixel size if not keepSize
            if (!keepSize)
            {
               width = icon.getIconWidth() / game.scaleLToP;
               height = icon.getIconHeight() / game.scaleLToP;
            }
         }
      }
      
      // No cached scaled image yet (will lazy init when drawn)
      scaledImage = null;
      widthPImg = 0;
      heightPImg = 0;  
   }

   // Change the image to filename
   @Override
   public void setImage(String filename)
   {
      setImageFilename(filename, true);
   }
   
   // Return true if the image was found
   public boolean imageFound()
   {
      return found;
   }
   
   // Draw the image into the given graphics surface
   protected void draw(Graphics2D g)
   {      
      // Calculate drawing location considering alignment, and round to nearest pixel.
      double scale = game.scaleLToP;
      int leftP = (int) (((x - (width * xAlignFactor)) * scale) + 0.5);
      int topP = (int) (((y - (height * yAlignFactor)) * scale) + 0.5);
      int widthP = (int) ((width * scale) + 0.5);
      int heightP = (int) ((height * scale) + 0.5);

      // Make scaledImage if doesn't exist or if obj resized since last draw
      if (scaledImage == null || widthP != widthPImg || heightP != heightPImg)
      {
         if (rawImage == null || widthP <= 0 || heightP <= 0)
            scaledImage = null;
         else
         {
            scaledImage = rawImage.getScaledInstance(widthP, heightP, Image.SCALE_SMOOTH);
            widthPImg = widthP;
            heightPImg = heightP;
         }
      }
      
      // Draw the image if success
      if (scaledImage != null)
         g.drawImage(scaledImage, leftP, topP, null);
      
      // Draw a frame around the image if lineColor is not null   
      if (lineColor != null)
      {
         g.setStroke(new BasicStroke(lineWidth));
         g.setColor(lineColor);
         g.drawRect(leftP, topP, widthP, heightP);
      }
   }
}
