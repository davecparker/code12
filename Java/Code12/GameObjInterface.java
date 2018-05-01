package Code12;  // (c)Copyright 2018 by David C. Parker 


// These are the methods you can call on a GameObj object
public interface GameObjInterface     
{   
   // Misc object properties
   public String getType();
   public String getText();
   public void setText(String text);
   public String toString();
   
   // The object size and alignment
   public void setSize(double width, double height);
   public void align(String a);
   public void align(String a, boolean adjustY);
   
   // The object colors
   public void setFillColor(String name);
   public void setFillColorRGB(int r, int g, int b);
   public void setLineColor(String name);
   public void setLineColorRGB(int r, int g, int b);

   // Manipulate the object in the game's object list
   public int getLayer();
   public void setLayer(int layer);
   public void delete();
   
   // Polled input
   public boolean clicked();
   
   // Geometry
   public boolean containsPoint(double xPoint, double yPoint);
   public boolean hit(GameObj obj);
}
