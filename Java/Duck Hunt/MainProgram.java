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
      setGunSizeAndPosition();
   }
   
   public void update()
   {
      // Make ducks at random times and positions
      if (ct.random(1, 50) == 1)
      {
         double x = 110;
         double y = ct.random( 10, (int)(yMax / 2) );
         GameObj duck = createDuck( x, y, -0.5 );
      }
      
      
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
   
   // Makes a duck to the right of the window at y-coordinate yStart
   // that will then accross the window horizontally with speed xSpeed
   public GameObj createDuck( double xStart, double yStart, double xSpeed )
   {
      GameObj duck = ct.image( "rubber-duck.png", xStart, yStart, 5 );
      duck.autoDelete = true;
      duck.xSpeed = xSpeed;
      return duck;
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
   
   // Sets an objects height to height and changes its width to preserve
   // its original aspect ratio
   public void setHeight( GameObj obj, double height )
   {
      double aspectRatio = obj.width / obj.height;
      obj.height = height;
      obj.width = height * aspectRatio;
   }
   
   // Scales the gun so that it's height is 25% of the window height
   // and sets it's position to the bottom of the window
   public void setGunSizeAndPosition()
   {
      setHeight( gun, yMax * 0.25 );
      gun.y = yMax - gun.height / 2;
   }
   
   // Updates yMax and image positions when the window is resized.
   public void onResize()
   {
      yMax = ct.getHeight();
      setGunSizeAndPosition();
   }
}