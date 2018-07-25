import Code12.*;

class level10 extends Code12Program
{
   //Global variables
      int updates = 0;
      double screenWidth;
      double screenHeight;
      //Player character
      GameObj bird;
      String flap = "downflap";
      String filename;
      final int BIRDHIEGHT = 10;
      double birdX;
      double birdY;
      //Score
      GameObj score;
      double scoreX;
      double scoreY;
      //Background
      GameObj back1;
      GameObj back2;
      //Ground
      GameObj ground1;
      GameObj ground2;
      GameObj ground3;

   public static void main(String[] args)
   { 
      Code12.run( new level10() ); 
   }
   
   public void start()
   {  
      //sets the height of the sceen to match the height of the background
      screenHeight = 128; //sets h to 128 (the height of the screen)
      ct.setHeight( screenHeight );
      screenWidth = ct.getWidth(); //sets w to 100 (the width of the screen)   
      
      back1 = ct.image("background-day.png", screenWidth / 2, screenHeight / 2, screenWidth );
      back2 = ct.image("background-day.png", 1.5*screenWidth, screenHeight / 2, screenWidth );

      back1.xSpeed = -1;
      back2.xSpeed = -1;

      //draws the bird ct.image("filename", x, y, h)
      birdX = screenWidth / 2.0; // sets x to 50 (the x position of the bird)
      birdY = screenHeight / 2.0; // sets y to 64  (the y position of the bird)
      //height of the bird (the height of the bird)
      bird = ct.image( "yellowbird-downflap.png", birdX, birdY, BIRDHIEGHT ); //uses x and y to stand in for 50, 64

      //draws the count
      //the value of x does not change (the x position of the bird and number are equal)
      scoreY = screenHeight / 8.0; //sets y to 16 (the y position of the number)
      scoreX = birdX;
      score = ct.image( "0.png", scoreX, scoreY, 5 ); 

      //draws the ground
      int y = 122; //sets y to 122 (the y positoin of all the pieces of the base)
      int h = 40; //sets h to 40 (the height of all the pieces of the base)
      //since the x position of each piece of the base is different it is not useful to use a variable
      ct.image( "base.png", 20, y, h );
      ct.image( "base.png", 60, y, h );
      ct.image( "base.png", 100, y, h );
   }

   public void update( )
   {
      //Handles the animation of the 
      updates++;
      boolean changed = false; // boolean to store whether the flap frame has been changed yet
      if( updates == 10 )
      {
         if( flap.equals("downflap") && !changed )
         {
            flap = "midflap";
            changed = true;
         }

         if( flap.equals("midflap") && !changed )
         {
            flap = "upflap";
            changed = true;
         }

         if( flap.equals("upflap") && !changed )
         {
            flap = "downflap";
            changed = true;
         }

         filename = "yellowbird-" + flap + ".png";

         birdX = bird.x;
         birdY = bird.y;
         bird.delete();
         bird = ct.image( filename, birdX, birdY, BIRDHIEGHT );
         updates = 0;
      }

      if( back1.x == -(screenWidth / 2) )
      {
         back1.x = 1.5*screenWidth;
      }
      
      if( back2.x == -(screenWidth / 2) )
      {
         back2.x = 1.5*screenWidth;
      }
   }

}