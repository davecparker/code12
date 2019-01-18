// RockPaperScissors8.java
// Syntax Level 8: If-else
// A text-based game of Rock Paper Scissors.
// Plays one round of rock paper scissors against the computer.

class RockPaperScissors8
{
	public void start()
	{
		final int TIE = 0;
		final int USER_WON = 1;
		final int COMPUTER_WON = -1;
		
		// Get user's choice
		String userChoice = ct.inputString( "Rock, Paper, or Scissors?" );
			
		// Check for good user input
		if ( !userChoice.equals( "Rock" ) && !userChoice.equals( "Paper" ) && !userChoice.equals( "Scissors" ) )
			ct.showAlert( "I didn't understand that choice :(" );
		else
		{
			// Randomly generate computer's choice
			String computerChoice = null;
			int randInt = ct.random( 1, 3 );
			if ( randInt == 1 )
				computerChoice = "Rock";
			else if ( randInt == 2 )
				computerChoice = "Paper";
			else
				computerChoice = "Scissors";

			// Determine winner
			int gameOutcome;
			if ( computerChoice.equals( userChoice ) )
				gameOutcome = TIE;
			else if ( computerChoice.equals( "Rock" ) && userChoice.equals( "Paper" ) )
				gameOutcome = USER_WON;
			else if ( computerChoice.equals( "Paper" ) && userChoice.equals( "Scissors" ) )
				gameOutcome = USER_WON;
			else if ( computerChoice.equals( "Scissors" ) && userChoice.equals( "Rock" ) )
				gameOutcome = USER_WON;
			else
				gameOutcome = COMPUTER_WON;

			// Output results
			ct.println( "You chose " + userChoice + " and the computer chose " + computerChoice + "." );
			if ( gameOutcome == TIE )
				ct.println( "It's a tie!" );
			else if ( gameOutcome == COMPUTER_WON )
				ct.println( "The computer won!" );
			else
				ct.println( "You won!" );
		}

		// Tell user how to play again and stop program
		ct.println( "Please click Restart to play again.");
		ct.stop();
	}
}
