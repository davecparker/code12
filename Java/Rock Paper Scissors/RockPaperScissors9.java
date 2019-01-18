// RockPaperScissors9.java
// Syntax Level 9: Function Definitions
// A text-based game of Rock Paper Scissors.
// Plays multiple rounds of rock paper scissors against the computer.
// Uses recursion.

class RockPaperScissors9
{
	int userScore = 0;
	int computerScore = 0;
	int roundCount = 0;

	public void start()
	{
		playGame();
	}

	public void playGame()
	{
		final int TIE = 0;
		final int USER_WON = 1;
		final int COMPUTER_WON = -1;

		// Get user's choice
		String userChoice = ct.inputString( "Rock, Paper, or Scissors?" );
			
		// Check for good user input
		if ( !userChoice.equals( "Rock" ) && !userChoice.equals( "Paper" ) && !userChoice.equals( "Scissors" ) )
		{
			ct.showAlert( "I didn't understand that choice :(" );
			playGame();
		}
		else
		{
			// Increment round count
			roundCount++;
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
			ct.println( "Round " + roundCount + " results:" );
			ct.println( "You chose " + userChoice + " and the computer chose " + computerChoice + "." );
			if ( gameOutcome == TIE )
				ct.println( "It's a tie!" );
			else if ( gameOutcome == COMPUTER_WON )
			{
				ct.println( "The computer won!" );
				computerScore++;
			}
			else
			{
				ct.println( "You won!" );
				userScore++;
			}
			ct.println( "Computer: " + computerScore + ", You: " + userScore );
			ct.println( "---" );
			boolean playAgain = ct.inputYesNo( "Play again?" );
			if ( playAgain )
				playGame();
			else
				ct.println( "Good bye!" );

		}
	}
}
