import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main( String[] args )
   { 
      Code12.run( new MainProgram() ); 
   }
   
   GameObj gun; // Gun at bottom of window that fires bullets
   double yMax; // Maximum y-coordinate of the game window
      
   public void start()
   {
      // Set title
      ct.setTitle( "Duck Hunt" );
      
      // Set background
      ct.setHeight( 100 * 9 / 16 );
      yMax = ct.getHeight();
      ct.setBackImage( "stage.png" );
      
      // Make gun
      gun = ct.image( "gun.png", 50, 0, 8 );
      gun.y = yMax - gun.height / 2;
   }
   
   public void update()
   {
      
   }
   
   // Makes a bullet at position xStart, yStart that will then
   // move up the window and delete itself once outside the window
   public GameObj createBullet( double xStart, double yStart )
   {
      GameObj bullet = ct.circle( xStart, yStart, 1, "blue" );
      bullet.autoDelete = true;
      bullet.ySpeed = -2;
      return bullet;
   }
   
   // Moves the gun horizontally and first a bullet when the mouse
   // is clicked
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Move the gun horizontally to match the click location
      gun.x = x;
      
      // Fire a new bullet
      double xStart = gun.x;
      double yStart = gun.y - gun.height / 2 * 0.9;
      createBullet( xStart, yStart );
   }
   
   // Updates yMax and image positions when the window is resized.
   public void onResize()
   {
      yMax = ct.getHeight();
      gun.y = yMax - gun.height / 2;
   }

}