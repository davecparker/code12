import Code12.*;

class level6 extends Code12Program
{
//Global variable
int frame = 0;
String frameNumb;
double h;
double w;
double birdX;
double birdY;
GameObj bird;
int hbird = 10;
int updates = 0;
int halfseconds = 0;
GameObj score;
double scoreX;
double scoreY;

   public static void main(String[] args)
   { 
      Code12.run( new level6() ); 
   }
   
   public void start()
   {  
      //draws the background
      ct.setBackImage( "background-day.png" );

      //sets the height of the sceen to match the height of the background
      h = 128; //sets h to 128 (the height of the screen)
      ct.setHeight( h );
      w = ct.getWidth(); //sets w to 100 (the width of the screen)   
      

      //draws the bird ct.image("filename", x, y, h)
      birdX = w / 2.0; // sets x to 50 (the x position of the bird)
      birdY = h / 2.0; // sets y to 64  (the y position of the bird)
       //height of the bird (the height of the bird)
      bird = ct.image( "yellowbird0.png", birdX, birdY, hbird ); //uses x and y to stand in for 50, 64

      //draws the count
      //the value of x does not change (the x position of the bird and number are equal)
      scoreY = h / 8.0; //sets y to 16 (the y position of the number)
      scoreX = birdX;
      score = ct.image( "0.png", scoreX, scoreY, 5 ); 

      //draws the ground
      int y = 122; //sets y to 122 (the y positoin of all the pieces of the base)
      h = 40; //sets h to 40 (the height of all the pieces of the base)
      //since the x position of each piece of the base is different it is not useful to use a variable
      ct.image( "base.png", 20, y, h );
      ct.image( "base.png", 60, y, h );
      ct.image( "base.png", 100, y, h );
   }

   public void update( )
   {
      updates += 1; //the update event fires 60 times a second

      //Handles the animation of the bird
      ////////////////////////////////////////////////////
      frame = updates % 20; // sets frame to the remainder of the total number of updates and 20
      frame = ct.intDiv( frame, 10 ); // divides the number we got from the previous calculation by 10 and throws aways the ones place 
      frameNumb = ct.formatInt( frame ); //creates a string with the frame we want which changes every 10 updates or 1/6th of a second
      String filename = "yellowbird" + frameNumb + ".png"; //the filenames of the three frames are yellowbird0.png, yellowbird1.png, yellowbird2.png 
      bird.delete();
      bird = ct.image( filename, birdX, birdY, hbird ); 
      ////////////////////////////////////////////////////

      //Handles the animation of the numbers
      halfseconds = updates % 30;
      halfseconds = ct.intDiv( updates, 30 );
      frame = halfseconds % 10; // a new frame value we will use to draw the correct number
      frameNumb = ct.formatInt( frame );
      filename = frameNumb + ".png";
      score.delete();
      score = ct.image( filename, scoreX, scoreY, 5 );
   }

}