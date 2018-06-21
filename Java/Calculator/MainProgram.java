import Code12.*;

public class MainProgram extends Code12Program
{
   //Instance Variables
   GameObj display;
   String displayText;
   GameObj[] buttons = new GameObj[20];
   String[] operatorButtons = { "+", "-", "*", "/", ".", "=", "(", ")", "%", "C" };
   String[] errorMessages = { "Cannot divide by zero!" };
   String equation;
   //Instance Variables for the calculate method
   double[] values =  new double[12]; //value stack
   String[] operators = new String[12]; //operator stack
   GameObj temp;
   
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
      buttons[0] = ct.rect( 20, 83, 15, 10, "grey");
      temp = buttons[0]; //change latter
      temp.clickable = true;
      ct.text( "0" , 20, 83, 10, "black" );
      
      int num = 1;
      //Prints the number keys (1-9)
      for ( int y = 70; y >= 44; y -= 13 ) //outer loop controls y of buttons
      {
         for ( int x = 20; x <= 54; x+=17 ) // inner loop controls x of buttons
         {
            buttons[num] = ct.rect( x, y, 15, 10, "grey");
            temp = buttons[num];
            temp.clickable = true;
            ct.text( ct.formatInt(num) , x, y-1, 10, "black" );
            num++;
         }
      }
      
      //adds basic math operator buttons
      for (int y = 83; y >= 44; y -= 13)
      {
         buttons[num] = ct.rect( 71, y, 15, 10, "grey");
         temp = buttons[num];
         temp.clickable = true;
         ct.text( operatorButtons[num%10] , 71, y-1, 10, "black" );
         num++;   
      }
      
      //adds equals and decimal button
      for ( int x = 37; x <= 54; x+=17 )
      {
         buttons[num] = ct.rect( x, 83, 15, 10, "grey");
         temp = buttons[num];
         temp.clickable = true;
         ct.text( operatorButtons[num%10] , x, 83, 10, "black" );
         num++;
      }
      
      
      // adds (, ), % and clear button
      for ( int x = 20; x <= 71; x+=17 )
      {
         buttons[num] = ct.rect( x, 31, 15, 10, "grey");
         temp = buttons[num];
         temp.clickable = true;
         
         int y = 31;
         
         if ( operatorButtons[num%10] == "(" || operatorButtons[num%10] == ")")
            y = 30;
            
         ct.text( operatorButtons[num%10] , x, y, 10, "black" );
         num++;
      } 
      
      
      //Initializes the display
      ct.setTitle("Calculator");
      displayText = "";
      display = ct.text( displayText, 56, 18, 12, "black" ); 
      
     // ct.clearScreen();
      
   /////////////////////////////////////////////////////////////////////////////////
   // Equation Solver
   
     // equation = ct.inputString("Enter an equation");
     // ct.println( Test( 2 ) );
   }
   
   public String Test( int x )
   {
      for( int i = 0; i < equation.length(); i++ )
      {
         if( equation.substring(i,i+1).equals("x") )
         {
            String temp1 = equation.substring(0,i);
            String temp2 = equation.substring(i+1,equation.length() );
            equation = temp1 + x + temp2;
         }
      } 
      
      return equation;
   }
      
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
      if(obj instanceof GameRect)
      {
         
         for(i = 0; i < buttons.length; i++ )
         {
            if(obj == buttons[i])
            {
               break;  
            }
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
             displayText = displayText + i;
         }
           
         else
         {
            if( displayText.indexOf("+") != -1 || displayText.indexOf("-") != -1  
               || displayText.indexOf("*") != -1  || displayText.indexOf("/") != -1  )
            {
               String result = displayText;
               //displayText = calculate(result);
            }
               
            displayText = displayText + operatorButtons[i%10];
         }
         
         updateDisplay();
      }
              
      if ( i == 14 ) //decimal ( "." key )
         {
            String currentNumber = "";
            
            //Finds the last number including decimal up until a mathmatical operator
            for ( int j = displayText.length() - 1; j >= 0; j-- )
            {
               if ( displayText.substring(j,j+1).equals("+") || displayText.substring(j,j+1).equals("-") 
                  || displayText.substring(j,j+1).equals("*") || displayText.substring(j,j+1).equals("/") )
               {
                  break;
               }
               
               currentNumber = currentNumber + displayText.substring(j,j+1);
               
            }
            
            if ( currentNumber.indexOf(".") == -1 )
            {
               if(currentNumber != "")
               {
                  displayText = displayText + operatorButtons[i%10];
                  updateDisplay();
               }
               else
               {
                  displayText = displayText + "0" + operatorButtons[i%10];
                  updateDisplay();
               }
            } 
         }        
      
      if(i == 15) // equals ( = key )
      { 
         if( !display.equals("") && !ct.canParseNumber(displayText) ) //tests if the display is empty or just a number
         {
            String result = displayText;
            displayText = calculate(result);
            updateDisplay();
         }
      }
      
      if(i == 19) // clear ( c key )
      {
         displayText = "";
         updateDisplay();
      }   
     } 
   }           
   
   
   
   //Method that takes a newDisplay value and redraws the display to properly display the new value
   public void updateDisplay()
   {
      display.setText(displayText);
      double newX = 77 - (display.width / 2.0);
      display.delete();
      display = ct.text( displayText, newX, 18, 12, "black" );
   }


   // Method that takes the currently displayed function and calculates the value
   // Takes a string representing the displayed value (composed of numbers and math operators)
   // Returns a string of a single number (double)
   
   
   //Helper methods for Calculate
   
   //Moves up items in an array to keep the values at the beggining
   /*
   public void updateCalculateArrays( )
   {
      for( int i = 0; i < values.length-2; i++ )
      {
         values[i] = values[i+2];
      }
      
      for ( int i = 0; i < operators.length - 1; i++ )
      {
         operators[i] = operators[i+1];
      }
   } */ //maybe not needed
   
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
         return n1 - n2;
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
      
      while( i < toCalculate.length() ) //calculates until toCalculate is empty
      {
         if( i == toCalculate.length() - 1 ) //assumes that the last character is not an operator
         {
            values[valueCount] = ct.parseInt( toCalculate.substring(0,i) );
            break;
         }
         else
         { 
            if( toCalculate.substring(i,i+1).equals("+") || toCalculate.substring(i,i+1).equals("-")
               || toCalculate.substring(i,i+1).equals("*") ||  toCalculate.substring(i,i+1).equals("/") )
            {
               //Having found the end of a number pushes it to the values array
               values[valueCount] = ct.parseInt( toCalculate.substring(0,i) );
               //Checks if the operator array is empty
               if(operatorCount == 0)
               {
                  operators[operatorCount] = toCalculate.substring(i,i+1);
                  i++;
               }    
               else
               {
                  //Compares the precedence of the operators
                  if(  findIndex(operatorButtons, toCalculate.substring(i,i+1) )  >= findIndex( operatorButtons, operators[0]) )
                  {
                     double num1 = values[valueCount - 2]; //Takes the value one from the top
                     double num2 = values[valueCount - 1]; //Takes the top value
                     String operator = operators[operatorCount - 1];//Takes the top operator
                     values[valueCount - 2] = simpleCalculate( num1, num2, operator );
                     operators[operatorCount -1] = toCalculate.substring(i,i+1);
                     valueCount -= 1; //popped 2 values off and pushed one on  
                  }
   
               }         
            }
            else
            {    
               i++;
            }
            
         }
      }
      
      while( operatorCount > 0 )
      {
         double num1 = values[valueCount - 2]; //Takes the value one from the top
         double num2 = values[valueCount - 1]; //Takes the top value
         String operator = operators[operatorCount - 1];//Takes the top operator
         values[valueCount - 2] = simpleCalculate( num1, num2, operator );
         operators[operatorCount -1] = toCalculate.substring(i,i+1);
         valueCount -= 1; //popped 2 values off and pushed one on
      }
      
      
      return ct.formatDecimal( values[0] );
   }
}   
