// RockPaperScissors10.java
// Syntax Level 10: Function Parameters
// A text-based game of Rock Paper Scissors.
// Plays multiple rounds of rock paper scissors against the computer.
// Uses recursion.

class RockPaperScissors10
{
	final int TIE = 0;
	final int USER_WON = 1;
	final int COMPUTER_WON = -1;
	int userScore = 0;
	int computerScore = 0;
	int roundCount = 0;

	public void start()
	{
		playGame();
	}

	public void playGame()
	{
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
			int gameOutcome = getGameOutcome( computerChoice, userChoice );

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

	public int getGameOutcome( String computerChoice, String userChoice )
	{
		if ( computerChoice.equals( userChoice ) )
			return TIE;
		else if ( computerChoice.equals( "Rock" ) && userChoice.equals( "Paper" ) )
			return USER_WON;
		else if ( computerChoice.equals( "Paper" ) && userChoice.equals( "Scissors" ) )
			return USER_WON;
		else if ( computerChoice.equals( "Scissors" ) && userChoice.equals( "Rock" ) )
			return USER_WON;
		return COMPUTER_WON;
	}
}
