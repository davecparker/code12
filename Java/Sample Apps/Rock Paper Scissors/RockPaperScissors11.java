// RockPaperScissors11.java
// Syntax Level 11: Loops
// A text-based game of Rock Paper Scissors.
// Plays multiple rounds of rock paper scissors against the computer.

class RockPaperScissors11
{
	final int TIE = 0;
	final int USER_WON = 1;
	final int COMPUTER_WON = -1;
	int userScore = 0;
	int computerScore = 0;
	int roundCount = 0;

	public void start()
	{
		do
			playGame();
		while( ct.inputYesNo( "Play again?" ) );
		ct.println( "Good bye!" );
	}

	public void playGame()
	{
		// Get user's choice
		String userChoice;
		do
		{
			userChoice = ct.inputString( "Rock, Paper, or Scissors?" );
			if ( !userChoice.equals( "Rock" ) && !userChoice.equals( "Paper" ) && !userChoice.equals( "Scissors" ) )
			{
				ct.showAlert( "I didn't understand that choice :(" );
				userChoice = null;
			}
		}
		while ( userChoice == null );
		
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
