package Code12;  // Copyright (c) 2018-2019 Code12 


// These are the methods you can call on a GameObj object
public interface GameObjInterface     
{   
   public String getType();
   public void setSize(double width, double height);
   public double getWidth();
   public double getHeight();
   public void setXSpeed(double xSpeed);
   public void setYSpeed(double ySpeed);
   public double getXSpeed();
   public double getYSpeed();
   public void align(String a);
   public void setText(String text);
   public String getText();
   public String toString();   
   public void setFillColor(String name);
   public void setFillColorRGB(int r, int g, int b);
   public void setLineColor(String name);
   public void setLineColorRGB(int r, int g, int b);
   public void setLineWidth(int lineWidth);
   public void setImage(String filename);
   public void setLayer(int layer);
   public int getLayer();
   public void delete();   
   public void setClickable(boolean clickable);
   public boolean clicked();
   public boolean containsPoint(double xPoint, double yPoint);
   public boolean hit(GameObj obj);
   public GameObj objectHitInGroup(String group);
}
