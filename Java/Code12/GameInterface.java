package Code12;  // Copyright (c) 2018-2019 Code12 


// These are the methods that you can call on the ct object.
public interface GameInterface
{
   // Graphics Object Creation
   public GameObj circle(double x, double y, double diameter);
   public GameObj circle(double x, double y, double diameter, String color);
   public GameObj rect(double x, double y, double width, double height);
   public GameObj rect(double x, double y, double width, double height, String color);
   public GameObj line(double x, double y, double x2, double y2);
   public GameObj line(double x, double y, double x2, double y2, String color);
   public GameObj text(String text, double x, double y, double height);
   public GameObj text(String text, double x, double y, double height, String color);
   public GameObj image(String filename, double x, double y, double width);

   // Text Output
   public void print(Object obj);
   public void println(Object obj);
   public void println();
   public void log(Object... objs);
   public void logm(String message, Object... objs);
   public void setOutputFile(String filename);     
   
   // Text Input
   public void showAlert(String message);
   public int inputInt(String message);
   public double inputNumber(String message);
   public boolean inputYesNo(String message);
   public String inputString(String message);
   
   // Screen Management
   public void setTitle(String title);
   public void setHeight(double height);
   public double getWidth();
   public double getHeight();
   public double getPixelsPerUnit();
   public void setScreen(String name);
   public String getScreen();
   public void setScreenOrigin(double x, double y);
   public void clearScreen();
   public void clearGroup(String group);
   public void setBackColor(String name);
   public void setBackColorRGB(int r, int g, int b);
   public void setBackImage(String filename);
   
   // Mouse and Keyboard Input
   public boolean clicked();
   public double clickX();
   public double clickY();
   public GameObj objectClicked();
   public boolean keyPressed(String key);
   public boolean charTyped(String ch);
   
   // Audio
   public void loadSound(String filename);
   public void sound(String filename);
   public void setSoundVolume(double d);
   
   // Math Utiliites
   public int random(int min, int max);
   public int round(double d);
   public double roundDecimal(double d, int numPlaces);
   public double distance(double x1, double y1, double x2, double y2);
   public int intDiv(int n, int d);
   public boolean isError(double d);

   // Type Conversion
   public int toInt(double d);     // deprecated, use (int) instead
   public int parseInt(String s);
   public double parseNumber(String s);
   public boolean canParseInt(String s);
   public boolean canParseNumber(String s);
   public String formatInt(int i);
   public String formatInt(int i, int numDigits);
   public String formatDecimal(double d);
   public String formatDecimal(double d, int numPlaces);

   // Program Control
   public int getTimer();
   public double getVersion();
   public void pause();    // not supported (ignored) by the Code12 Java runtime
   public void stop();     // not supported (ignored) by the Code12 Java runtime
   public void restart();  // not supported (ignored) by the Code12 Java runtime
}
