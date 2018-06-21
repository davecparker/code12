import Code12.*;

class Test3 extends Code12Program
{

   
   public static void main(String[] args)
   { 
      Code12.run( new Test1() ); 
   }
   
   public void start()
   {  
   
      // GameObj Creation
      //----------------- 
      
      //Creates a variable x of the integar type with the value 12
      int x = 12; 
      
      //Creates a variable y of the integar type with the value 15
      int y = 15; 
      
      //Creates a variable d of the integar type with the value 20
      int d = 100; 
      
      //Creates a circle with its center at ( x, y ) with a diameter of 20 with default color
      ct.circle( x, y, 20 ); 
      
      //The variable x is set to a new value, 40
      x = 40;
        
      //The variable y is not set to a new value
      
      //the variable d is set to a new value, 25
      d = 25;       
      
      //Creates a black circle at position ( x, y ) with a diameter of d
      ct.circle( x, y, d, "black" );   
      
      //x is set to 80 
      x = 78; 
      
      //y is set to 20 
      y = 20;
      
      //d is set to 25
      d = 35;
      
      //Creates a viable c of the String type with the value "blue"
      String c = "blue";
      
      //Creates a black circle with a center at ( x, y ) with a diameter of d
      ct.circle( x, y, d, c );  
      
      
      
      /*/
      //Creates a rectangle at position ( 35, 15 ) with a width of 10 and height of 5 with default color
      ct.rect( 35, 15, 10, 5 );   
      
      //Creates a blue rectangle at position ( 52, 15 ) with a width of 10 and height of 5
      ct.rect( 52, 15, 10, 5, "blue" ); 
      
      //Creates a line at position ( 62 , 15 ) with default color 
      ct.line( 62, 15, 72, 15 );
      
      //Creates a cyan line at position ( 77 , 15 )
      ct.line( 77, 15, 87, 15, "cyan" );
      
      //Creates text at ( 33, 30 ) with a height 10
      ct.text( "Hello world!", 33, 30, 10 );

      //Creates green text at ( 73, 30 ) with a height 10
      ct.text( "Test", 73, 30, 10, "green" );
      
      //Creates a fish at ( 20, 45 ) with a width of 20
      ct.image( "goldfish.png" , 20, 45, 20 );
      
      //Creates a larger fish at ( 60, 50 )
      ct.image( "goldfish.png" , 65, 50, 40 );
      //-----------------
      
      // Screen Management
      //------------------
      //Sets the title of the window
      ct.setTitle( "Test 1" );
      
      //Sets the background color of the screen
      ct.setBackColor( "white" );//Looks like nothing

      //Sets the background image
      ct.setHeight(200);
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
      
      //Head
      ct.circle( 50, 100, 50, "yellow");
      
      //Eyes
      ct.circle( 40, 90, 10, "black");
      ct.circle( 60, 90, 10, "black");
      
      //Mouth
      ct.rect( 50, 110, 20, 8, "black");
      
      */
   }
}
