
import Code12.*;

class SimpleGuessingGame extends Code12Program
{
   
   int guess = 0;
   int randomNumber;
   int numOfGuesses = 0;
   
   public static void main(String[] args)
   { 
      Code12.run(new SimpleGuessingGame()); 
   }
   
   public void start()
   {
      randomNumber = ct.random(1,100);
      boolean stopped = false;
      
      ct.println("******************************");
      ct.println("Welcome to the guessing game!" );
      ct.println("******************************");
      ct.println();
      
      while ( !stopped )
      {
         guess = ct.inputInt("Enter a number between 1 and 100 to begin: ");
         if ( guess < 1 || guess > 100 )
            guess = ct.inputInt("A number between 1 and 100, please: ");
         else
            {
               numOfGuesses++;
            
               while ( guess != randomNumber )
               {
                  if ( guess < randomNumber )  
                     ct.print("Guess higher! ");
                  else if ( guess > randomNumber )
                     ct.print("Guess lower! ");
                     
                  ct.println("Try again... ");
                  guess = ct.inputInt("Enter a number from 1 - 100: ");
                  numOfGuesses++;
               }
               
               if ( guess == randomNumber )
                 ct.println("You win after " + numOfGuesses + " guesses!");
               
               boolean decide = ct.inputYesNo("Want to play again? Enter y/n: ");
               if ( decide == false )
                  stopped = true;
            }
         
      } 
      
      ct.println("Thanks for playing!" );  
   }
 
}