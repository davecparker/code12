package Code12;  // (c)Copyright 2018 by David C. Parker 


// These are the methods you can call on a GameObj object
public interface GameObjInterface     
{   
   // Misc object properties
   public String getType();
   public String getText();
   public void setText(String text);
   public String toString();
   
   // Object positioning
   public double getWidth();
   public double getHeight();
   public void setSize(double width, double height);
   public void setSpeed(double xSpeed, double ySpeed);
   public void align(String a);
   
   // The fill and line
   public void setFillColor(String name);
   public void setFillColorRGB(int r, int g, int b);
   public void setLineColor(String name);
   public void setLineColorRGB(int r, int g, int b);
   public void setLineWidth(int lineWidth);

   // Manipulate the object in the game's object list
   public int getLayer();
   public void setLayer(int layer);
   public void delete();
   
   // Polled input
   public void setClickable(boolean clickable);
   public boolean clicked();
   
   // Geometry
   public boolean containsPoint(double xPoint, double yPoint);
   public boolean hit(GameObj obj);
   public GameObj objectHitInGroup(String group);
}
