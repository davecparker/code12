// Black box test of:
// Text Output
// Text Input
// You can press the enter key the whole way through in order to bypass manual user input.
// ( It will be filled in with defaults )

import Code12.*;

public class TextTest extends Code12Program
{
   GameObj circle;
   GameObj square;
   GameObj rect;
   GameObj line;
   
   int[] inputArray;
   //String[][] string2DArray;
   

   public static void main(String[] args)
   { 
      Code12.run(new TextTest()); 
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
      
      ct.print( "There is a " + circle + " and a " + square );
      ct.println();
      
      String test = "Saving stuff into a string.";
      ct.println(test);
      
      String concat = "Testing string...";
      ct.println(concat + " concatenation");
      
      int LIMIT = ct.inputInt("Enter # of times to start logging stationary game objects");
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
       double d = ct.inputNumber("Enter a double: ");
       if ( ct.isError(d) )
         ct.println("NaN or infinity");
       ct.println( d );
       boolean bool = ct.inputBoolean("Enter a boolean: ");
      //  bool = false;   //bug; this should default to false if user skips it
       if ( bool )
         ct.println("Boolean is true");
       else
         ct.println("Boolean is false"); 

       // Testing various String methods
       ct.println();
       String input = ct.inputString("Enter a test string to be used "
                                    + "with Java's string methods: " );
       if ( input.equals("") )
         input = "garbage";
       ct.println("The length of " + input + " is " + input.length() );
       ct.println( input + " to upper case is " + input.toUpperCase() );
       ct.println( input + " to lower case is " + input.toLowerCase() );
       
       int index = ct.inputInt("Enter a valid index for your test string: " );
       
       if ( index >= 0 && index < input.length() )
         ct.println("The char at index " + index + " is " + input.charAt( index ) );
       else
         index = 0;  // default
      
       int i = 0;
       int j = input.length()-1;
       ct.println("Is your test input a palindrome?");
       while ( input.charAt(i) == input.charAt(j) && (i++) <= (j--) );
       ct.println (i >= j?"Yes, it is!":"No, it isn't.");
       
       String anotherInput = ct.inputString("Enter a second string: ");
       if ( anotherInput.equals("") )
         anotherInput = "garbageagain";   // Default
         
       int comparing = input.compareTo(anotherInput);
  
       if ( comparing > 0 )
         ct.println( input + " is lexicographically greater than " + anotherInput );
       else if ( comparing == 0 )
       {
         ct.println( input + " and " + anotherInput + " are equal.");
         if ( input.equals(anotherInput) )
            ct.print("equivalent to .equals method)");
       }
       else if ( comparing < 0 )
         ct.println( input + " is lexicographically less than " + anotherInput );
       
       String alphabet = "abcdefghijklmnopqrstuvwxyz";
       String letter = ct.inputString("Enter an alphabet letter: ");
       if ( letter.equals("") )
            letter = "z";
       ct.println( alphabet.indexOf(letter) + 1 + " is the index of " + letter );
       
       // substring methods
       String s = ct.inputString("Enter another string: ");
       if ( s.equals("") )
            s = "DefaultCase";
       int start = ct.inputInt("Enter starting index: ");
         // defaults to 0
            
       if ( start >= 0 )
         ct.println( s.substring(start) ); 
       else
         ct.println("Index cannot be negative!");
       
       int end = ct.inputInt("Enter ending index: " );
       if ( end == 0 )
         end = 10;
         
       if ( end < s.length() )
         ct.println( s.substring( start, end ) );
       else
         ct.println("End index is out of bounds!");
   
      // trim method
      String excess = "      excess whitespace       ";
      ct.println(excess);
      ct.println("After trimming: " + excess.trim() );

      // Testing string equality
      String a = "equal";
      String b = "equal";
      // Memory is allocated once
      ct.println("Two strings pointing to the same spot in memory returns " + ( a == b ) );   // prints true
      
      String a1 = "equal";
      String b1 = "equal";
      ct.println("Two equal strings compared using the equals() method returns " + ( a1.equals(b1) ) );   // prints true
      String a2 = "equa";
      // Appending allocates new memory for String a1
      a2 += "l";
      // a1 and b1 have different references
      String b2 = "equal";
      ct.println("Two equal strings, but one dynamically created returns " + (a2 == b2) );  // prints false
     
      String a3 = "equal";
      // Explicitly allocating new memory for the string b2
      String b3 = new String("equal");
      ct.println("Two equal strings, but one explictly instantiated returns " + (a3 == b3) );   // also prints false
      
      String a4 = "equal";
      String b4 = new String("equal").intern();    // check to see if the string exists in pool then return a reference to it
      ct.println("Two equal strings, one created using the intern() method returns " + (a4 == b4) );   // returns true


      
      // Testing out printing arrays to console
      inputArray = new int[10];
      for ( i = 0; i < inputArray.length; i++ )
      {
         inputArray[i] = ct.inputInt("Enter an integer to fill the array: "); 
      }
      
      for ( i = 0; i < inputArray.length; i++ )
      {
         ct.println("The integer at index " + i + " is " + inputArray[i] );
      }
      
      int rows = ct.inputInt("Enter # of rows for a 2D array: " );
      if ( rows == 0 )
         rows = 2;
      int columns = ct.inputInt("Enter # of columns: " );
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
      ct.logm("There is a " + rect + " moving " + rect.y + " unit upwards off-screen");
      ct.logm("There was a mouse click at " + ct.clickX() + "," + ct.clickY() );

   }
 
}