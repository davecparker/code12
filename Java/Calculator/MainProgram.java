import Code12.*;

public class MainProgram extends Code12Program
{
   //Instance Variables
   private GameObj display;
   private String displayText;
   private GameObj buttons[] = new GameObj[20];
   private String[] operatorButtons = { "+", "-", "*", "/", ".", "=", "(", ")", "%", "C" };

   
   
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {  
      ct.print("");
      buttons[0] = ct.rect( 20, 83, 15, 10, "grey");
      buttons[0].clickable = true;
      ct.text( "0" , 20, 83, 10, "black" );
      
      int num = 1;
      //Prints the number keys (1-9)
      for ( int y = 70; y >= 44; y -= 13 ) //outer loop controls y of buttons
      {
         for ( int x = 20; x <= 54; x+=17 ) // inner loop controls x of buttons
         {
            buttons[num] = ct.rect( x, y, 15, 10, "grey");
            buttons[num].clickable = true;
            ct.text( ct.formatInt(num) , x, y-1, 10, "black" );
            num++;
         }
      }
      
      //adds basic math operator buttons
      for (int y = 83; y >= 44; y -= 13)
      {
         buttons[num] = ct.rect( 71, y, 15, 10, "grey");
         buttons[num].clickable = true;
         ct.text( operatorButtons[num%10] , 71, y-1, 10, "black" );
         num++;   
      }
      
      //adds equals and decimal button
      for ( int x = 37; x <= 54; x+=17 )
      {
         buttons[num] = ct.rect( x, 83, 15, 10, "grey");
         buttons[num].clickable = true;
         ct.text( operatorButtons[num%10] , x, 83, 10, "black" );
         num++;
      }
      
      
      // adds (, ), % and clear button
      for ( int x = 20; x <= 71; x+=17 )
      {
         buttons[num] = ct.rect( x, 31, 15, 10, "grey");
         buttons[num].clickable = true;
         
         int y = 31;
         
         if ( operatorButtons[num%10] == "(" || operatorButtons[num%10] == ")")
            y = 30;
            
         ct.text( operatorButtons[num%10] , x, y, 10, "black" );
         num++;
      } 
      
      
      //Initializes the display
      displayText = "";
      display = ct.text( displayText, 56, 18, 12, "black" ); 
      
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
   private void Input ( int i ) 
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
            if( displayText.contains("+") || displayText.contains("-") 
               || displayText.contains("*") || displayText.contains("/") )
            {
               String result = displayText;
               displayText = Calculate(result);
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
               if ( displayText.charAt(j) == '+' || displayText.charAt(j) == '-' 
                  || displayText.charAt(j) == '*' || displayText.charAt(j) == '/' )
               {
                  break;
               }
               
               currentNumber = currentNumber + displayText.charAt(j);
               
            }
            
            if ( !currentNumber.contains(".") )
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
            displayText = Calculate(result);
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
   private void updateDisplay()
   {
      display.setText(displayText);
      double newX = 77 - (display.width / 2.0);
      display.delete();
      display = ct.text( displayText, newX, 18, 12, "black" );
   }
   
   
   // Method that takes the currently displayed function and calculates the value
   // Takes a string representing the displayed value (composed of numbers and math operators)
   // Returns a string of a single number (double)
   private String Calculate(String toCalculate)
   {
   
      double num1 = 0;
      double num2 = 0;
      String temp = "";
      char operator = '-';
      boolean isDouble = false;

      for( int i = 0; i < toCalculate.length(); i++)
      {
         if( toCalculate.charAt(i) == '+' || toCalculate.charAt(i) == '-'
         || toCalculate.charAt(i) == '*' ||  toCalculate.charAt(i) == '/')
         {
            switch( toCalculate.charAt(i) )
            {
               case '+': operator = '+';
                         break;
               case '-': operator = '-';
                         break;
               case '*': operator = '*';
                         break;
               case '/': operator = '/';
                         break;
               default: operator = ' ';
            }
            
            num1 = ct.parseNumber(temp); 
            temp = "";   
         } 
                     
         else
         {
            if( toCalculate.charAt(i) == '.')
            {
               isDouble = true;
            }  
            
            temp = temp + toCalculate.charAt(i);
         }
         
         if (i == toCalculate.length() - 1)
         {
            
            num2 = ct.parseNumber(temp);
         }
      }
      
      double result; 

      switch(operator)
      {
         case '+': result = num1 + num2;
                   break;
         case '-': result = num1 - num2;
                   break;
         case '*': result = (double)num1 * num2;
                   break;
         case '/': result = (double)num1 / num2;
                   break;
         default: result = 0;
      }  
      
      //Formats long numbers / infinate decimals to fit on the screen
      if( ct.formatDecimal(result).length() > 12 )
          result = ct.round( result, 10 );
      
      if( (result % 1) == 0 )
         return ct.formatInt( (int)result );
      return ct.formatDecimal(result);
   }
}