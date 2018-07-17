import Code12.*;

class Test3 extends Code12Program
{

   public static void main(String[] args)
   { 
      Code12.run( new Test3() ); 
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
      
      //Creates variables to store the height and width of the rectangles we will make
      int height = 10;
      int width = 26;
      
      //Sets the string for the color of the rectangle to "yellow"
      c = "yellow";
      
      //Sets x and y to the x and y of the center of the rectangle we will make
      x = 26;
      y = 38;
      
      //Creates a yellow rectangle with its center at ( 14, 20 ) with a height of height and width of width
      ct.rect( x, y, width, height, c);  
      
      //Creates two new integar variables a and b
      int a;
      int b;
      
      //Sets the value of a to be equal to x
      a = x;
      
      //Sets b to the value 48
      b = 52;
      
      //Sets c to "gray"
      c = "gray";
      
      //Creates a gray rectangle with its center at ( a, b ) with a height of height and width of width
      ct.rect( a, b, width, height, c);  
      
      //Sets b and c to a new values
      b = 75;
      c = "purple";
       
      //Creates a gray rectangle with its center at ( a, b ) with a height of width and width of height 
      ct.rect( a, b, height, width, c); //There is nothing special about variable names   
      
      //Creates a variable size of type double
      double size = 40.5;
      
      //Sets x and y to the desired location of the image we will create
      x = 70;
      y = x;
      
      //Creates an image of a fish
      ct.image("goldfish.png", x, y, size );   

   }
}
