
import Code12.*;

public class TextOutput extends Code12Program
{
   GameObj circle;
   GameObj square;
   GameObj rect;
   GameObj line;
   
   int[] inputArray;
   //String[][] string2DArray;
   

   public static void main(String[] args)
   { 
      Code12.run(new TextOutput()); 
   }
   
   public void start() 
   {
   
      // Printing to console
      // ct.print()
      // ct.println()
      // These objects will also be used to test logging methods in update()
      circle = ct.circle(50,50,10,"black");
      square = ct.rect(10,10,10,10,"gray");
      rect = ct.rect(ct.getWidth()/2, ct.getHeight()/2, 5, 10, "red");
      line = ct.line(10,10,20,20);
      
      ct.print( "There is a " + circle.toString() + " and a " + square.toString() );
      ct.println();
      
      String test = "Saving stuff into a string.";
      ct.println(test);
      
      String concat = "Testing string...";
      ct.println(concat + " concatenation");
      
      int LIMIT = ct.random(0,10);
      if ( LIMIT == 0 )
         LIMIT = 2;
         
       for ( int i = 0; i < LIMIT; i++ )
       {
         ct.log(rect);
         ct.logm("There is a ", line);
       }
       
       ct.print("Line feeds \nusing Java's \nescape character.");
       
       ct.println();
       //ct.println("\"Double quotes!\" tab:\t\'Single quotes!\'");
       
       ct.print("Carriage return \r ");
       ct.print("Form feed \f ");

       // Testing input methods
       ct.println();
       double d = 5.0;
       if ( ct.isError(d) )
         ct.println("NaN or infinity");
       ct.println( d );
       boolean bool = false;
      //  bool = false;   //bug; this should default to false if user skips it
       if ( bool )
         ct.println("Boolean is true");
       else
         ct.println("Boolean is false"); 

       // int index = ct.inputInt("Enter a valid index for your test string: " );
//        
//        if ( index >= 0 && index < input.length() )
//          ct.println("The char at index " + index + " is " + input.charAt( index ) );
//        else
//          index = 0;  // default
      
       // int i = 0;
//        int j = input.length()-1;
//        ct.println("Is your test input a palindrome?");
//        while ( input.charAt(i) == input.charAt(j) && (i++) <= (j--) );
//        ct.println (i >= j?"Yes, it is!":"No, it isn't.");
      
       
       // substring methods
       // String s = "substring";
//        if ( s.equals("") )
//             s = "DefaultCase";
//        int start = ct.inputInt("Enter starting index: ");
//          // defaults to 0
//             
//        if ( start >= 0 )
//          ct.println( s.substring(start) ); 
//        else
//          ct.println("Index cannot be negative!");
//        
//        int end = ct.random(0,10);
//        if ( end == 0 )
//          end = 10;
//          
//        if ( end < s.length() )
//          ct.println( s.substring( start, end ) );
//        else
//          ct.println("End index is out of bounds!");
   
      // trim method
     //  String excess = "      excess whitespace       ";
//       ct.println(excess);
//       ct.println("After trimming: " + excess.trim() );


      // Explicitly allocating new memory for the string b2
      //String b3 = new String("equal");
      //ct.println("Two equal strings, but one explictly instantiated returns " + (a3 == b3) );   // also prints false
      
      //String a4 = "equal";
      //String b4 = new String("equal").intern();    // check to see if the string exists in pool then return a reference to it
      //ct.println("Two equal strings, one created using the intern() method returns " + (a4 == b4) );   // returns true


      
      // Testing out printing arrays to console
      inputArray = new int[10];
      for ( int i = 0; i < inputArray.length; i++ )
      {
         inputArray[i] = 65;
      }
      
      for ( int i = 0; i < inputArray.length; i++ )
      {
         ct.println("The integer at index " + i + " is " + inputArray[i] );
      }
      
      int rows = ct.random(0,10);
      if ( rows == 0 )
         rows = 2;
      int columns = ct.random(0,10);
      if ( columns == 0 )
         columns = 2;
      
      // string2DArray = new String[rows][columns];
//       
//       for ( rows = 0; rows < string2DArray.length; rows++ )
//       {
//          for ( columns = 0; columns < string2DArray[rows].length; columns++ )
//          {
//             string2DArray[rows][columns] = ct.inputString("Write strings into the array: ");
//             // if no user input, fill with default string
//             string2DArray[rows][columns] = "Default";
//          }
//       }
//       
//       for ( rows = 0; rows < string2DArray.length; rows++ )
//       {
//          ct.print("\nrow " + rows + ":\t" );
//          for ( columns = 0; columns < string2DArray[rows].length; columns++ )
//          {
//             ct.print( string2DArray[rows][columns] + "\t");
//          }
//          ct.println();
//       }
                
   }
   
   public void update()
   {
      circle.xSpeed = 1;
      if ( circle.x >= ct.getWidth() )
         circle.x = 0;
      ct.log(circle);
      
      rect.ySpeed = -1;
      ct.println("There is a " + rect.toString() + " moving " + rect.y + " unit upwards off-screen");
      ct.println("There was a mouse click at " + ct.clickX() + "," + ct.clickY() );

   }
 
}