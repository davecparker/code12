// RockPaperScissors12.java
// Syntax Level 12: Arrays
// A text-based game of Rock Paper Scissors.
// Plays multiple rounds of rock paper scissors against the computer.

class RockPaperScissors12
{
	final int TIE = 0;
	final int USER_WON = 1;
	final int COMPUTER_WON = -1;
	String[] choices = { "rock", "paper", "scissors", "lizard", "spock" };
	int[] outcomes = { TIE, COMPUTER_WON, USER_WON, USER_WON, COMPUTER_WON, // userChoice x computerChoice
	                   USER_WON, TIE, COMPUTER_WON, COMPUTER_WON, USER_WON,
	                   COMPUTER_WON, USER_WON, TIE, USER_WON, COMPUTER_WON,
	                   COMPUTER_WON, USER_WON, COMPUTER_WON, TIE, USER_WON,
	                   USER_WON, COMPUTER_WON, USER_WON, COMPUTER_WON, TIE };
	String[] verbs = { "", " covers ", " crushes ", " crushes ", " vaporizes ",
	                   " covers ", "", " cuts ", " eats ", " disproves ",
	                   " crushes ", " cuts ", "", " decapitates ", " crushes ",
	                   " crushes ", " eats ", " decapitates ", "", " poisons ",
	                   " vaporizes ", " disproves ", " crushes ", " poisons ", "" };
	int userScore = 0;
	int computerScore = 0;
	int roundCount = 0;
	String choicesList = "";

	public void start()
	{
		// Make choicesList
		choicesList = choicesList + choices[0];
		for ( int i = 1; i < choices.length; i++ )
			choicesList = choicesList + ", " + choices[i];
		choicesList = choicesList + "?";
		// Play game
		do
			playGame();
		while( ct.inputYesNo( "Play again?" ) );
		ct.println( "Good bye!" );
	}

	public void playGame()
	{
		// Get user's choice
		int userChoice = -1;
		do
		{
			String userInput = ct.inputString( choicesList );
			userInput = userInput.toLowerCase();
			for ( int i = 0; i < choices.length; i++ )
			{
				if ( userInput.equals( choices[i] ) )
				{
					userChoice = i;
					break;
				}
			}
			if ( userChoice < 0 )
				ct.showAlert( "I didn't understand that choice :(" );
		}
		while ( userChoice < 0 );

		// Increment round count
		roundCount++;
		// Randomly generate computer's choice
		int computerChoice = ct.random( 0, choices.length - 1 );

		// Determine winner
		int gameOutcome = getGameOutcome( computerChoice, userChoice );

		// Output results
		ct.println( "Round " + roundCount + " results:" );
		ct.println( "You chose " + choices[userChoice] + " and the computer chose " + choices[computerChoice] + "." );
		if ( gameOutcome == TIE )
			ct.println( "It's a tie!" );
		else if ( gameOutcome == COMPUTER_WON )
		{
			ct.println( choices[computerChoice] + verbs[computerChoice * choices.length + userChoice] + choices[userChoice] + "." );
			ct.println( "The computer won!" );
			computerScore++;
		}
		else
		{
			ct.println( choices[userChoice] + verbs[computerChoice * choices.length + userChoice] + choices[computerChoice] + "." );
			ct.println( "You won!" );
			userScore++;
		}
		ct.println( "Computer: " + computerScore + ", You: " + userScore );
		ct.println( "---" );
	}

	public int getGameOutcome( int computerChoice, int userChoice )
	{
		int numChoices = choices.length;
		return outcomes[ userChoice * numChoices + computerChoice ];
	}
}
