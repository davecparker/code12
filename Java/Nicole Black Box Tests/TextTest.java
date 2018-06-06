// Black box test of:
// Text Output
// Text Input

import Code12.*;

public class TextTest extends Code12Program
{
   GameObj circle;
   GameObj square;
   GameObj rect;
   GameObj line;
   
   int LIMIT = 0;
   
   public static void main(String[] args)
   { 
      Code12.run(new TextTest()); 
   }
   
   public void start()
   {
      // Printing to console
      // ct.print()
      // ct.println()
      circle = ct.circle(50,50,10,"black");
      square = ct.rect(10,10,10,10,"gray");
      rect = ct.rect(ct.getWidth()/2, ct.getHeight()/2, 5, 10, "red");
      line = ct.line(10,10,20,20);
      
      ct.print( "There is a " + circle + " and a " + square );
      ct.println();
      
      String test = "Saving stuff into a string.";
      ct.println(test);
      
      String concat = "Testing string...";
      ct.println(concat + " concatenation");
      
      
      LIMIT = ct.inputInt("Enter # of times to start logging stationary game objects");
       for ( int i = 0; i < LIMIT; i++ )
       {
         ct.log(rect);
         ct.logm("There is a ", line);
       }
       
       String input = ct.inputString("Enter a test string to be used "
                                    + "with Java's string class." );
       
       ct.println("The length of " + input + " is " + input.length() );
       ct.println( input + " to upper case is " + input.toUpperCase() );
       ct.println( input + " to lower case is " + input.toLowerCase() );
       
       int index = ct.inputInt("Enter a valid index for your test string: " );
       
       if ( index >= 0 && index < input.length() )
         ct.println("The char at index " + index + " is " + input.charAt( index ) );
       else
         index = ct.inputInt("Enter a valid index for your test string: " );
      
       ct.println("Now to test substring methods");
       
                                   
   }
   
   public void update()
   {
      // ct.log()
      circle.xSpeed = 1;
      if ( circle.x >= ct.getWidth() )
         circle.x = 0;
      
      
      
     
      
   }
   
}