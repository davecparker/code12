package Code12;  // Copyright (c) 2018-2019 Code12

import java.awt.*;


// Base class for a graphical object that can be created in a Game
public abstract class GameObj implements GameObjInterface
{
   // Public instance variables (client can get or set these directly)
   public double x, y;              // position of object or start point if line
   public boolean visible;          // true if object is visible
   public int id;                   // numerical identifier, default 0
   public String group;             // group name, default ""

   // Protected instance variables
   protected Game game;             // back pointer to Game this object lives in
   protected String type;           // "circle", etc.
   protected double xAlignFactor;   // 0 for left, 0.5 for center, 1 for right
   protected double yAlignFactor;   // 0 for top, 0.5 for center, 1 for bottom
   protected double width, height;  // size of the object
   protected double xSpeed, ySpeed; // velocity
   protected Color fillColor;       // fill color or null for none
   protected Color lineColor;       // line/frame color or null for none
   protected int lineWidth;         // line/frame thickness in pixels
   protected int layer;             // stacking layer, default 1
   protected String text;           // text to draw or use for log name, or null
   protected boolean clickable;     // true if object is clickable
   protected boolean deleted;       // true when object is deleted from screen


   // Construct a default object at the given location and size
   GameObj(Game game, double x, double y, double width, double height)
   {
      this.x = x;
      this.y = y;
      visible = true;
      id = 0;
      group = "";

      this.game = game;
      type = "GameObj";
      xAlignFactor = 0.5;      // center
      yAlignFactor = 0.5;      // center
      this.width = width;
      this.height = height;
      xSpeed = 0;
      ySpeed = 0;
      fillColor = Color.BLACK;
      lineColor = Color.BLACK;
      lineWidth = 1;
      layer = 1;
      text = null;
      clickable = true;
      deleted = false;
   }


   //======================= GameObj API Methods ============================

   public String getType()                            { return type; }
   public double getWidth()                           { return width; }
   public double getHeight()                          { return height; }
   public void setXSpeed(double xSpeed)               { this.xSpeed = xSpeed; }
   public void setYSpeed(double ySpeed)               { this.ySpeed = ySpeed; }
   public double getXSpeed()                          { return xSpeed; }
   public double getYSpeed()                          { return ySpeed; } 
   public void align(String a)                        { setAlignFromString(a); }
   public void setText(String text)                   { this.text = text; }
   public String getText()                            { return text; }
   public void setFillColor(String name)              { fillColor = colorFromName(name); }
   public void setFillColorRGB(int r, int g, int b)   { fillColor = makeColor(r, g, b); }
   public void setLineColor(String name)              { lineColor = colorFromName(name); }
   public void setLineColorRGB(int r, int g, int b)   { lineColor = makeColor(r, g, b); }
   public void setLineWidth(int lineWidth)            { this.lineWidth = lineWidth; }
   public void setImage(String filename)              {}   // GameImage overrides
   public void setLayer(int layer)                    { game.setObjLayer(this, layer); }
   public int getLayer()                              { return layer; }
   public void delete()                               { game.deleteObj(this); }
   public void setClickable(boolean clickable)        { this.clickable = clickable; }
   public boolean clicked()                           { return (game.input.clickedObj == this); }
   public GameObj objectHitInGroup(String group)      { return game.hitTestGroup(this, group); }

   public void setSize(double width, double height)
   {
      this.width = width;
      this.height = height;
   }

   public String toString()
   {
      // e.g. [rect at (30, 60)] [text at (30, 60) "hello"] [image at (30, 60) "filename.png"]
      String s = "[" + type + " at (" + Math.round(x) + ", " + Math.round(y) + ")";
      if (text != null)
         s += " \"" + text + "\"";
      return s + "]";
   }

   public boolean containsPoint(double xPoint, double yPoint)
   {
      // Reject test each side, taking alignment into account.
      double left = x - (width * xAlignFactor);
      if (xPoint < left)
         return false;
      double right = left + width;
      if (xPoint > right)
         return false;
      double top =  y - (height * yAlignFactor);
      if (yPoint < top)
         return false;
      double bottom = top + height;
      if (yPoint > bottom)
         return false;
      return true;
   }

   public boolean hit(GameObj obj)
   {
      // Make sure both objects are valid and visible
      if (obj == null || obj.deleted || !obj.visible || deleted || !visible)
         return false;
          
   	if (obj.isLine())
   		return obj.hit(this);

   	// Just do a rectangle intersection test on the bounding rects.
      double left = x - (width * xAlignFactor);
      double right = left + width;
      double left2 = obj.x - (obj.width * obj.xAlignFactor);
      double right2 = left2 + obj.width;
      if (right2 < left || left2 > right)
         return false;
      double top =  y - (height * yAlignFactor);
      double bottom = top + height;
      double top2 =  obj.y - (obj.height * obj.yAlignFactor);
      double bottom2 = top2 + obj.height;
      if (bottom2 < top || top2 > bottom)
         return false;
      return true;
   }
   

   //======================= Internal Methods =========================

   protected double boundingBoxLeft()    { return x - (width * xAlignFactor); }
   protected double boundingBoxRight()   { return x - (width * xAlignFactor) + width; }
   protected double boundingBoxTop()     { return y - (height * yAlignFactor); }
   protected double boundingBoxBottom()  { return y - (height * yAlignFactor) + height; }
   protected boolean isLine()            { return false; }

   // Returns the lineWidth of the GameObj in logical units
   protected double lineWidthLU()
   {
		return lineWidth / game.getPixelsPerUnit();
   }

   // Return a valid Color given r, g, b components forced into range.
   private Color makeColor(int r, int g, int b)
   {
      return new Color(game.pinValue(r, 0, 255), 
                       game.pinValue(g, 0, 255), 
                       game.pinValue(b, 0, 255));
   }

   // Set xAlignFactor and yAlignFactor given alignment string
   private void setAlignFromString(String a)
   {
      if (a == null)
         a = "center";
         
      switch (a.toLowerCase())
      {
         case "top left":       xAlignFactor = 0;    yAlignFactor = 0;    break;
         case "top":
         case "top center":     xAlignFactor = 0.5;  yAlignFactor = 0;    break;
         case "top right":      xAlignFactor = 1;    yAlignFactor = 0;    break;
         case "left":           xAlignFactor = 0;    yAlignFactor = 0.5;  break;
         case "center":         xAlignFactor = 0.5;  yAlignFactor = 0.5;  break;
         case "right":          xAlignFactor = 1;    yAlignFactor = 0.5;  break;
         case "bottom left":    xAlignFactor = 0;    yAlignFactor = 1;    break;
         case "bottom":
         case "bottom center":  xAlignFactor = 0.5;  yAlignFactor = 1;    break;
         case "bottom right":   xAlignFactor = 1;    yAlignFactor = 1;    break;
         default:
            game.logError("Invalid object alignment", a);
      }
   }

   // Get a Color for the color string name, or gray if name not known
   private Color colorFromName(String name)
   {
      if (name == null)
         return null;

      switch (name.toLowerCase())
      {
         case "black":         return new Color(0, 0, 0);
         case "white":         return new Color(255, 255, 255);
         case "red":           return new Color(255, 0, 0);
         case "green":         return new Color(0, 255, 0);
         case "blue":          return new Color(0, 0, 255);
         case "cyan":          return new Color(0, 255, 255);
         case "magenta":       return new Color(255, 0, 255);
         case "yellow":        return new Color(255, 255, 0);

         case "gray":          return new Color(127, 127, 127);
         case "orange":        return new Color(255, 127, 0);
         case "pink":          return new Color(255, 192, 203);
         case "purple":        return new Color(64, 0, 127);
         case "brown":         return new Color(130, 70, 30);

         case "light gray":    return new Color(191, 191, 191);
         case "light red":     return new Color(255, 127, 127);
         case "light green":   return new Color(127, 255, 127);
         case "light blue":    return new Color(170, 225, 255);
         case "light cyan":    return new Color(127, 255, 255);
         case "light magenta": return new Color(255, 127, 255);
         case "light yellow":  return new Color(255, 255, 127);

         case "dark gray":     return new Color(64, 64, 64);
         case "dark red":      return new Color(127, 0, 0);
         case "dark green":    return new Color(0, 127, 0);
         case "dark blue":     return new Color(0, 0, 127);
         case "dark cyan":     return new Color(0, 127, 127);
         case "dark magenta":  return new Color(127, 0, 127);
         case "dark yellow":   return new Color(220, 190, 0);
      }
      return new Color(127, 127, 127);   // Gray for color name not found
   }


   //======================= Protected Methods =========================

   // Draw the object into the given graphics surface (subclasses must implement)
   abstract protected void draw(Graphics2D g);

   // Update the object's state for the next animation frame.
   // Return true if the object moved via xSpeed/ySpeed, else false.
   protected boolean update()
   {
      // Apply current velocity
      x += xSpeed;
      y += ySpeed;
      return (xSpeed != 0 || ySpeed != 0);
   }
   
   // Mark the object as deleted
   protected void markDeleted()
   {
      deleted = true;
      visible = false;
      clickable = false;
   }
}
