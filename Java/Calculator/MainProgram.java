import Code12.*;

public class MainProgram extends Code12Program
{
   //Instance Variables
   GameObj display;
   String displayText ="";
   GameObj[] buttons = new GameObj[20];
   GameObj clearBack;
   String[] operatorButtons = { "+", "-", "*", "/", ".", "=", "(", ")", "%"};
   String[] errorMessages = { "Cannot divide by zero!" };
   String compare; //used to compare substrings to set values
   String equation; //holds the current equation being evaluated
   //Instance Variables for the calculate method
   double[] values =  new double[12]; //value stack
   String[] operators = new String[12]; //operator stack
   GameObj temp;
   boolean displayingAnswer = false; //tracks when the display is showing a calculated answer
   
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {  
      
      /////////////////////////////////////////////////////////////////////////////////
      // Calculator Screen
      
      ct.setScreen("Calculator");
      //Adds the 0 number key
      buttons[0] = ct.rect( 20, 83, 15, 10, "gray" );
      ct.text( "0" , 20, 83, 10, "black" );
      
      //Adds the backspace/clear key
      buttons[19] = ct.rect( 71, 31, 15, 10, "gray" );
      clearBack = ct.text( "AC" , 71, 31, 10, "black" );
      
      
      int num = 1;
      //Prints the number keys (1-9)
      for ( int y = 70; y >= 44; y -= 13 ) //outer loop controls y of buttons
      {
         for ( int x = 20; x <= 54; x+=17 ) // inner loop controls x of buttons
         {
            buttons[num] = ct.rect( x, y, 15, 10, "gray");
            ct.text( ct.formatInt(num) , x, y-1, 10, "black" );
            num++;
         }
      }
      
      //adds basic math operator buttons
      for (int y = 83; y >= 44; y -= 13)
      {
         buttons[num] = ct.rect( 71, y, 15, 10, "gray");
         ct.text( operatorButtons[num%10] , 71, y-1, 10, "black" );
         num++;   
      }
      
      //adds equals and decimal button
      for ( int x = 37; x <= 54; x+=17 )
      {
         buttons[num] = ct.rect( x, 83, 15, 10, "gray");
         ct.text( operatorButtons[num%10] , x, 83, 10, "black" );
         num++;
      }
      
      
      // adds (, ), % and clear button
      for ( int x = 20; x <= 54; x+=17 )
      {
         buttons[num] = ct.rect( x, 31, 15, 10, "gray");         
         int y = 31;
         int buttonId = num%10;
         if ( operatorButtons[buttonId].equals("(") || operatorButtons[buttonId].equals(")") )
            y = 30;
         ct.text( operatorButtons[num%10] , x, y, 10, "black" );
         num++;
      } 
      
      for( GameObj button : buttons )
      {
      button.clickable = true;
      }
      
      //Initializes the display
      ct.setTitle("Calculator");
      displayText = "";
      display = ct.text( displayText, 78, 18, 12, "black" );
      display.align("right"); 
      
      // ct.clearScreen();
      
   /////////////////////////////////////////////////////////////////////////////////
   // Equation Solver
   
      equation = ct.inputString("Enter an equation");
      ct.println( Test ( 3 ) );
      ct.println( findIntRoot() );
   }
   
   public String findIntRoot ()
   {
      for ( int x = 0; x < 1000; x++ )
      {
         if( Test( x ) )
         {
            return ct.formatInt( x );
         }
         if( Test( -x ) )
         {
            return ct.formatInt( -x );
         }
      }
     return "Cannot find integar root";
   }   

   public boolean Test( int x )
   {
      for( int i = 0; i < equation.length(); i++ )
      {  
         String temporary = equation.substring(i,i+1);
         if( temporary.equals("x") )
         {
            String temp1 = equation.substring(0,i);
            String temp2 = equation.substring(i+1,equation.length() );
            equation = temp1 + x + temp2;
         }
      } 
      
      return ct.parseNumber( calculate( equation ) ) == 0;
   }

      
   /////////////////////////////////////////////////////////////////////////////////   
      
   public void update()
   { 
             
   }

   public void onKeyPress( String keyName ) 
   {
      if( ct.canParseInt(keyName.substring( keyName.length() - 1 , keyName.length() ) ) )
         {
            int i = ct.parseInt( keyName.substring( keyName.length() - 1 , keyName.length() ) );
            Input( i );
         }
   }
  
   
   public void onMousePress(GameObj obj, double x, double y)
   {
      int i = -1;
      for(i = 0; i < buttons.length; i++ )
         {
            if(obj == buttons[i])
            {
               break;  
            }
         }        
      Input( i );
   }
    
   
    
   //Handles inputs from mouse and keyboard
   public void Input ( int i ) 
   {
      if ( i != -1 )
      {
      
      if(displayText.length() < 12 && i < 14)
      {  
         
         if( i < 10 )
         {  
            //clears the display text if you enter a number while displaying a previously calculated answer          
            if( displayingAnswer )
            {
               displayText = "";
               displayingAnswer = false;
               clearBack.setText("AC");
            }
            
            displayText = displayText + i;
         }
           
         else
         {
            if( displayingAnswer )
            {
               displayingAnswer = false;
               clearBack.setText("AC");
            }

            displayText = displayText + operatorButtons[i%10];
         }
         
         display.setText(displayText);
      }
              
      if ( i == 14 ) //decimal ( "." key )
         {
            String currentNumber = "";
            int j;
            //Finds the last number including decimal up until a mathmatical operator
            for ( j = displayText.length() - 1; j >= 0; j-- )
            {
               compare = displayText.substring(j,j+1);
               if ( compare.equals("+") || compare.equals("-") || compare.equals("*") || compare.equals("/") )
               {
                  break;
               }               
            }
            
            currentNumber =displayText.substring(j+1);
            
            if ( currentNumber.indexOf(".") == -1 )
            {
               if( !currentNumber.equals("") )
               {
                  displayText = displayText + operatorButtons[i%10];
                  display.setText(displayText);
               }
               else
               {
                  displayText = displayText + "0" + operatorButtons[i%10];
                  display.setText(displayText);
               }
            } 
         }        
      
      if(i == 15) // equals ( = key )
      { 
         if( !displayText.equals("") && !ct.canParseNumber(displayText) ) //tests if the display is empty or just a number
         {
            String result = displayText;
            displayText = calculate(result);
            display.setText(displayText);
            displayingAnswer = true;
            clearBack.setText("C");
         }
      }
      
      if(i == 19) // clear ( C/AC key )
      {  
         if( !displayText.equals("") )
         {
            if(displayingAnswer)
            {
               displayText = "";
               display.setText(displayText);
               displayingAnswer = false;
               clearBack.setText("AC");
            }
            else
            {
            displayText = displayText.substring( 0, displayText.length()-1 );
            display.setText(displayText);
            }
         }
      }   
     } 
   }           
   

   // Method that takes the currently displayed function and calculates the value
   // Takes a string representing the displayed value (composed of numbers and math operators)
   // Returns a string of a single number (double)
   
   
   //Helper methods for Calculate

   //IndexOf for arrays
   public int findIndex ( String[] array, String findMe )
   {
      for ( int i = 0; i < array.length; i++)
      {
         if( findMe.equals(array[i]) )
         {
            return i;
         }
      } 
      return -1;
   }
   
   //Handles simple numerical calculations
   //Takes two doubles and a string representing a mathmatical operator
   //Returns a double representing the result of applying the operator to the two numbers
   public double simpleCalculate( double n1, double n2, String o)
   {
      if( o.equals("-") )
      {
         return n1 - n2;
      }
      if( o.equals("+") )
      {
         return n1 + n2;
      }
      if( o.equals("*") )
      {
         return n1 * n2;
      }
      //Add exception to handle dividing by zero!
      if( o.equals("/") )
      {
         return n1 / n2;
      }
      
      return 0;
   }
   
   public String calculate(String toCalculate)
   {
      int i = 0;
      int valueCount = 0;
      int operatorCount = 0;
      
      while( toCalculate.length() > 0 ) //parses through toCalculate
      {
         if( i == (toCalculate.length() - 1) ) //assumes that the last character is not an operator
         {
            valueCount+= 1;
            values[valueCount - 1] = ct.parseNumber(toCalculate);
            break;
         }
         else
         { 
            compare = toCalculate.substring(i,i+1);
            if( compare.equals("+") || compare.equals("-")|| compare.equals("*") ||  compare.equals("/") )
            {
               //Having found the end of a number pushes it to the values array
               valueCount += 1;
               values[valueCount - 1] = ct.parseNumber( toCalculate.substring(0,i) );              

               //Checks if the operator array is empty
               if(operatorCount == 0)
               {
                  operatorCount += 1;
                  operators[operatorCount - 1] = toCalculate.substring(i,i+1);
                  toCalculate = toCalculate.substring(i+1);
                  i = 0;  
               }
                   
               else
               {
                  //Compares the precedence of the operators
                  if(  findIndex(operatorButtons, toCalculate.substring(i,i+1) ) < findIndex( operatorButtons, operators[operatorCount -1]) )
                  {
                     String operator = operators[operatorCount - 1];//Takes the top operator
                     double num1 = values[valueCount - 2]; //Takes the value one from the top
                     double num2 = values[valueCount - 1]; //Takes the top value
                     values[valueCount - 2] = simpleCalculate( num1, num2, operator );
                     operators[operatorCount - 1] = toCalculate.substring(i,i+1);
                     valueCount -= 1; //popped 2 values off and pushed one on  
                     toCalculate = toCalculate.substring(i+1);
                     i = 0;
                  }
                  
                  else
                  {
                  operatorCount += 1;
                  operators[operatorCount - 1] = toCalculate.substring(i,i+1);
                  }
               }         
            }
            
            else
            {   
               i++;
            } 
         }
      }
      
      while( operatorCount > 0 ) //Calculates remaining operators and values
      {
         double num1 = values[valueCount - 2]; //Takes the value one from the top
         double num2 = values[valueCount - 1]; //Takes the top value
         String operator = operators[operatorCount-1];//Takes the top operator
         values[valueCount - 2] = simpleCalculate( num1, num2, operator );
         valueCount -= 1; //popped 2 values off and pushed one on
         operatorCount -= 1;
      }
      
      
      //Formating and returning result
      double result = values[0];
      
      if( result > 999999999 || result < 0.000000001 ) //scientific notation for extreme values
      {
      int exponant = 0;
      double coefficient = 0;
      String exp ="";
      
      
         if( result > 1 ) //large number
         {
         exp = ct.formatInt( ct.toInt(result) );   
         exponant = exp.length() - 1; //change latter
         
         coefficient = result / Math.pow(10,exponant);
         exp = "+e" + ct.formatInt(exponant); 
         }
         
         if( result < 1 ) //small number
         {
         exp = ct.formatDecimal(result);
         exponant = -1*(exp.length()-1);
         
         coefficient = result * Math.pow(10,exponant);
         exp = "-e" + ct.formatInt(exponant); 
         }
           
      result = ct.roundDecimal( coefficient, 11 - exp.length() );
      return ct.formatDecimal(result) + exp;
      }
      
      compare = ct.formatDecimal(result);
      if (compare.length() > 12)
      {  
         compare = ct.formatInt( ct.toInt(result) );
         int decimalPlaces = 11 - compare.length(); //11 represents 12(character limit) minus the . character
         
         result = ct.roundDecimal( result, decimalPlaces );
      }
      
      if ( ct.toInt(result) ==  result ) // checks if the value to be returned is an integar
         return ct.formatInt( ct.toInt(result) );  //returns a string representing an int
         
      return ct.formatDecimal(result); // returns a string representing a double
   }
}   
