import Code12.*;

public class MainProgram extends Code12Program
{
	//Instance Variables
	GameObj display;
	String displayText ="";
	GameObj[] buttons = new GameObj[20];
	GameObj clearBack;
	String operatorButtons ="+-*/.=()%";
	String compare; //used to compare substrings to set values
	GameObj button; //used to temporarily store the buttons during initialization
	GameObj label; //used to temporarily store button label labels during initialization
	String equation; //holds the current equation being evaluated


	//Instance Variables for the calculate method
	GameObj temp;
	boolean displayingAnswer = false; //tracks when the display is showing a calculated answer

	public void update()
	{ 
		//unused for now
	}

	public void start()
	{	  
		//Initialization

		//Adds the 0 number key
		button = ct.rect( 20, 83, 15, 10, "gray" );
		buttons[0] = button;
		button.setText( "0" );
		label = ct.text( "0", 20, 83, 10, "black" );
		label.setClickable(false);

		//Adds the backspace/clear key    
		button = ct.rect( 71, 31, 15, 10, "gray" );
		buttons[19] = button;
		String buttonText = "AC";
		button.setText( buttonText );
		clearBack = ct.text( buttonText, 71, 31, 10, "black" );
		clearBack.setClickable(false);


		int num = 1;
		//Prints the number keys (1-9)
		for ( int y = 70; y >= 44; y -= 13 ) //outer loop controls y of buttons
		{
			for ( int x = 20; x <= 54; x+=17 ) // inner loop controls x of buttons
			{
				button = ct.rect( x, y, 15, 10, "gray");
				buttonText = ct.formatInt( num ); //The button label is the num variable for numbered buttons
				button.setText( buttonText );
				label = ct.text( buttonText , x, y, 10, "black" ); //Creates the label for the button
				label.setClickable(false);
				buttons[num] = button;
				num++;
			}
		}

		//adds basic math operator buttons
		for (int y = 83; y >= 44; y -= 13)
		{
			button = ct.rect( 71, y, 15, 10, "gray");
			buttonText = operatorButtons.substring( num%10,num%10+1 ); //Determines the button operator using the operator string
			button.setText(buttonText);
			label = ct.text( buttonText, 71, y-1, 10, "black" ); //Creates the label for the button
			label.setClickable(false);
			buttons[num] = button;
			num++;   
		}

		//adds equals and decimal button
		for ( int x = 37; x <= 54; x+=17 )
		{
			button = ct.rect( x, 83, 15, 10, "gray");
			buttonText = operatorButtons.substring( num%10, num%10+1 ); //Determines the button operator using the operator string
			button.setText(buttonText);
			label = ct.text( buttonText, x, 83, 10, "black" ); //Creates the label for the button
			label.setClickable(false);
			buttons[num] = button;
			num++;
		}

		// adds (, ), %
		for ( int x = 20; x <= 54; x+=17 )
		{
			buttons[num] = ct.rect( x, 31, 15, 10, "gray");         
			buttonText = operatorButtons.substring( num%10,num%10 + 1 );

			int y = 31;
			if ( buttonText.equals("(") || buttonText.equals(")") ) // Special spacing for '(' and ')'
			{
				y = 30;
			}

			label = ct.text( buttonText, x, y, 10, "black" ); //Creates the label for the button
			label.setClickable(false);
			buttons[num] = button;
			num++;
		} 

		//Initializes the display
		ct.setTitle("Calculator");
		displayText = "";
		display = ct.text( displayText, 78, 18, 12, "black" );
		display.align("right"); 
	}

	public void onKeyPress( String keyName ) 
	{
	//Determines which key is pressed and calls the input function with the appropriate value for i
		//Hardcoded exception for backspace
		if( keyName.equals("backspace") )
		{
			input( 19 );
		}
		//Chack if there is space available on the display
		else if( ct.canParseInt(keyName.substring( keyName.length() - 1 , keyName.length() ) ) ) 
		{
			int i = ct.parseInt( keyName.substring( keyName.length() - 1 , keyName.length() ) );
			input( i ); //input function call based on pressed key
		}
	}

	public void onMousePress(GameObj obj, double x, double y)
	{
		int i = -1;

		for(int j = 0; j < buttons.length; j++ ) //searches for the button that was pressed in the button array
		{
			if(obj == buttons[j])
			{
				i = j;
				break;  
			}
		}       
		input( i );
	}

	//Handles inputs from mouse and keyboard
	public void input ( int i ) 
	{
		if ( i != -1 ) //value representing null/mousepress onto empy space
		{
			if( displayText.length() < 12 && i < 18 && i != 15)
			{  
				if( i < 10 )
				{  
					//clears the displayText if you enter a number while displaying a previously calculated answer          
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

					displayText = displayText + operatorButtons.substring( i%10, i%10 + 1 );
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
						displayText = displayText + operatorButtons.substring( i%10, i%10 + 1 );
						display.setText(displayText);
					}
					else
					{
						displayText = displayText + "0" + operatorButtons.substring( i%10, i%10 + 1 );
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

	public int precedence ( String operator ) 
	{
		//Takes in a String representing an operator and returns its precedence
		if ( operator.equals( "+" ) || operator.equals( "-" ) )
		{
			return 5;
		}
		
		if ( operator.equals( "*" ) || operator.equals( "/" ) )
		{
			return 4;
		}
		
		if( operator.equals( "^" ) )
		{
			return 3;
		}
		
		if( operator.equals( "!" ) )
		{
			return 2;
		}

		return 0; //default value (only returned on error)
	}

	public double simpleCalculate( double n1, double n2, String o)
	{
		//Handles simple numerical calculations
		//Takes two doubles and a string representing a mathmatical operator
		//Returns a double representing the result of applying the operator to the two numbers
		
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
		
		if( o.equals("^") )
		{
			return Math.pow(n1, n2);
		}

		return 0; //default value (only returned on error)
	}

	
	public double[] paren( String afterParen )
	{
		//Handles precidence of parenthesis by evaluating the inner portion as a seperate expression
		int i;
		String tempParen;
		String tempParen1;
		double[] parenReturn;
		double result;

		for( i = 0; i < afterParen.length(); i++ )
		{
			tempParen = afterParen.substring(i,i+1);
			if( tempParen.equals(")"))
			{
				break;
			}
			if( tempParen.equals("("))
			{
				parenReturn = paren(afterParen.substring(i+1) );
				tempParen = afterParen.substring(0,i); //everything before the (
				tempParen1 = ct.formatDecimal( parenReturn[0] );
				result = ct.parseNumber( calculate( tempParen + tempParen1 ) );
				i += ct.toInt( parenReturn[1] );
				double[] results = { result, i + 1 };
				return results;
			}
		}

		afterParen = afterParen.substring(0,i); //removes the right parenthesis and anything after
		result = ct.parseNumber (calculate( afterParen ) );
		double[] results = { result, i + 1 };
		return results;
	}

	public String calculate(String toCalculate)
	{
		int i = 0; //index of the parser
		int valueCount = 0;
		int operatorCount = 0;
		String returnMe = "math error";
		String tempCalc;
		double[] parenReturn; //array to store the values returned from param
		double[] values =  new double[12]; //value stack
		String[] operators = new String[12]; //operator stack

		while(true) //parses through toCalculate
		{
			tempCalc = toCalculate.substring(i,i+1);
			if( tempCalc.equals("(") ) 
			{
				parenReturn = paren( toCalculate.substring(1) ); //stuffs the array of returned values from paren into a temporary array
				valueCount += 1;
				values[valueCount - 1] = parenReturn[0]; //the first return value is the evaluation of what was in the parenthesis
				int y = ct.toInt( parenReturn[1] ) +1 ;

				if( y >= toCalculate.length() - 1 )
				{
					break;
				}

				toCalculate = toCalculate.substring( y );
				i=0;
			} 
			else if( i == (toCalculate.length() - 1) ) //handles the parser finding the end of toCalculate
			{
				//checks for operators at the end of
				if( tempCalc.equals("+") || tempCalc.equals("-") || tempCalc.equals("*") || tempCalc.equals("/") || tempCalc.equals("^") || tempCalc.equals("(") )
				{
					return returnMe;
				}

				else
				{
					valueCount+= 1;
					values[valueCount - 1] = ct.parseNumber( toCalculate );
					break;
				}    
			}
			else //if the parser has not found the end or found a ) at the end
			{
				if( tempCalc.equals("+") || tempCalc.equals("-") || tempCalc.equals("*") || tempCalc.equals("/") || tempCalc.equals("^") )
				{
					//Having found the end of a number pushes it to the values array
					if( i != 0 )
					{
						valueCount += 1;
						values[valueCount - 1] = ct.parseNumber( toCalculate.substring(0,i) ); 
					}

					//Checks if the operator array is empty
					if( operatorCount == 0 )
					{
						operatorCount += 1;
						operators[operatorCount - 1] = toCalculate.substring(i,i+1);
					}
					else
					{
						//Compares the precedence of the operators
						if(  precedence( toCalculate.substring( i,i+1 ) ) >= precedence( operators[operatorCount -1] ) )
						{
							String operator = operators[operatorCount - 1];//Takes the top operator
							double num1 = values[valueCount - 2]; //Takes the value one from the top
							double num2 = values[valueCount - 1]; //Takes the top value
							if( num2 == 0 && operator.equals("/"))
							{	
								return "Div by zero no!";
							}
							else
							{
								values[valueCount - 2] = simpleCalculate( num1, num2, operator );
								operators[operatorCount - 1] = toCalculate.substring(i,i+1);
								valueCount -= 1; //popped 2 values off and pushed one on  
							}
						}
						else
						{
							operatorCount += 1;
							operators[operatorCount - 1] = toCalculate.substring(i,i+1);
						}
					}

					toCalculate = toCalculate.substring(i+1);
					i = 0;       
				}
				else
				{
					i++; //iterates through toCalculate
				}
			}
		}

		//Calculates through the parsed equation 
		while( operatorCount > 0 ) //Calculates remaining operators and values
		{                
			double num1 = values[valueCount - 2]; //Takes the value one from the top
			double num2 = values[valueCount - 1]; //Takes the top value      
			String operator = operators[operatorCount - 1];//Takes the top operator
			if( num2 == 0 && operator.equals("/"))
			{
				return "Div by zero no!";
			}
			else
			{
				values[valueCount - 2] = simpleCalculate( num1, num2, operator );
				valueCount -= 1; //popped 2 values off and pushed one on
				operatorCount -= 1;
			}
		}  


		//Formating and returning result 
		double result = values[0];

		if( result == 0 )
		{
			return "0.0";
		}
		else if( Math.abs( result ) > 999999 || Math.abs( result ) < 0.000001 ) //scientific notation for extreme values
		{
			int exp = 0;
			double coefficient = 0;
			String expStr ="";
			if( result > 1 ) //large number
			{
				expStr = ct.formatInt( ct.toInt( result ) );
				exp = expStr.length() - 1; 

				coefficient = result / Math.pow( 10 ,exp );
				expStr = "e+" + ct.formatInt(exp); 
			}

			if( result < 1 ) //small number
			{
				exp = 0;
				while( result < 1 )
				{
					result *= 10;
					exp--;
				}
				coefficient = result;
				expStr = "e" + ct.formatInt(exp); 
			}
			result = ct.roundDecimal( coefficient, 11 - expStr.length() );
			return ct.formatDecimal(result) + expStr;
		}

		returnMe = ct.formatDecimal(result);
		if (returnMe.length() > 12)
		{  
			returnMe = ct.formatInt( ct.toInt(result) );
			int decimalPlaces = 11 - returnMe.length(); //12(character limit) - . char         
			result = ct.roundDecimal( result, decimalPlaces );
			returnMe = ct.formatDecimal(result);
		}

		if ( ct.toInt(result) ==  result ) // checks if the value to be returned is an integar
		{
			returnMe = ct.formatInt( ct.toInt(result) );
			return returnMe; //returns a string representing an int
		}

		return returnMe; // returns a string representing a double
	}
}   
