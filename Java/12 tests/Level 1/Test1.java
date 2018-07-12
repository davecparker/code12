import Code12.*;

class Test1 extends Code12Program
{

   
   public static void main(String[] args)
   { 
      Code12.run( new Test1() ); 
   }
   
   public void start()
   {  
      //This is a comment, it does not effect how the code runs
      //The purpose of a comment is to help people reading the code to understand how it works
      
      //In this program comments directly above a line of code decribe their function
      //Comments on the same line as code give extra information about that line
      
      //Coordinates are given ( x, y ). ( 0, 0 ) is on the top left corner of the screen
      //The positive x direction is right and the positive y direction is down
      
      // GameObj Creation
      //-----------------
      //Creates a circle with its center at ( 12, 15 ) with a diameter of 5 with default color
      ct.circle( 12, 15, 5 ); 
      
      //Creates a black circle with its center at ( 22, 15 ) with a diameter of 5
      ct.circle(22,15,5,"black");//spaces inside of the method call do not matter   
      
      //Creates a rectangle with its center at( 35, 15 ) with a width of 10 and height of 5 with default color
      ct.rect( 35, 15, 10, 5 );//I prefer spaces for visual clarity but that is a style choice   
      
      //Creates a blue rectangle with its center at( 52, 15 ) with a width of 10 and height of 5
      ct.rect( 52, 15, 10, 5, "blue" ); 
      
      //Creates a line from the point ( 62 , 15 ) to the point ( 72, 15 ) with default color 
      ct.line( 62, 15, 72, 15 );
      
      //Creates a cyan line from the point ( 77 , 15 ) to the point ( 87, 15 )
      ct.line( 77, 15, 87, 15, "cyan" );
      //Creates a purple line from the point
      ct.line( 82, 20, 90, 28, "Magenta");
      
      //Creates text at ( 33, 30 ) with a height 10
      ct.text( "Hello world!", 33, 30, 10 );

      //Creates green text at ( 73, 30 ) with a height 10
      ct.text( "Test", 73, 30, 10, "Magenta" );
      
      //Creates a fish at ( 20, 45 ) with a width of 20
      ct.image( "goldfish.png" , 20, 45, 20 );
      
      //Creates a larger fish at ( 60, 50 )
      ct.image( "goldfish.png" , 65, 50, 40 );
      //-----------------
      
      // Screen Management
      //------------------
      
      //Sets the background color of the screen
      ct.setBackColor( "white" );//Looks like nothing

      //Sets the height of the screen (to match the size of the background)
      ct.setHeight(150);
      //Sets the background image
      ct.setBackImage("underwater.jpg"); 
      //------------------
      
      // Audio
      //------------------ 
      //Sets the volume to half the full value
      ct.setSoundVolume( 0.5 );
      
      //Plays the sound bubble
      ct.sound( "bubble.wav" );
      //------------------
      
      //Draws a face below the other tests
      //------------------ 
      //Head
      ct.circle( 50, 100, 50, "yellow");
      
      //Eyes
      ct.circle( 40, 90, 10, "black");
      ct.circle( 60, 90, 10, "black");
      
      //Mouth
      ct.rect( 50, 110, 20, 8, "black");
      //------------------ 
   }
}
