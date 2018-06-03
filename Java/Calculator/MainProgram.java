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
      display = ct.text( displayText, 54, 10, 10, "black" ); 
      
   }
   
   
   public void update()
   { 
             
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
  
      if(obj instanceof GameRect)
      {
         int i;
         for(i = 0; i < buttons.length; i++ )
         {
            if(obj == buttons[i])
            {
               break;  
            }
         }  
         
         if(displayText.length() < 15 && i < 15)
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
                  
               i = i%10;
               displayText = displayText + operatorButtons[i];
            }
              
            display.setText(displayText);
            updateDisplay(displayText);
         }
                 
         if(i == 15) // equals ( = key )
         { 
            if( !display.equals("") && !ct.canParseNumber(displayText) ) //tests if the display is empty or just a number
            {
               String result = displayText;
               displayText = Calculate(result);
               updateDisplay(displayText);
            }
         }
         
         if(i == 19) // clear ( c key )
         {
            displayText = "";
            updateDisplay(displayText);
         }   
         
      }           
   }
   
   //Method that takes a newDisplay value and redraws the display to properly display the new value
   private void updateDisplay(String newDisplay)
   {
      display.setText(newDisplay);
      double newX = 75 - (display.width / 2.0);
      display.delete();
      display = ct.text( newDisplay, newX, 10, 10, "black" );
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
      if( (result % 1) == 0 )
         return ct.formatInt( (int)result );
      return ct.formatDecimal(result);
   }
}
