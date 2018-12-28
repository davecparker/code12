// A backgammon game (two player human vs. human)
class Backgammon
{
	// Game constants
	final int CHIPS_PER_PLAYER = 15;     // chip count for each player
	final int POINTS_PER_SIDE = 12;      // 12 triangle points on top and bottom

	// Layout constants aligned with the background image
	final double POINT_WIDTH = 7.65;   // width of the point triangles
	final double Y_POINT_TOP = 6.2;    // first chip y on top points
	final double Y_POINT_BOTTOM = 94;  // first chip y on bottom points
	final double X_BAR = 50;           // x coordinate of center bar
	final double Y_CENTER = 50;        // y center of the bar (and board)

	// Computed layout constants
	final double CHIP_DIAMETER = POINT_WIDTH - 1;
	final double CHIP_SPACING = CHIP_DIAMETER + 0.2;

	// The x coordinate of each point, indexed by point number.
	// Point 0 is light's bar, points 1-24 go counter-clockwise,
	// and point 25 is dark's bar.
	final int BAR_LIGHT = 0;
	final int POINT_FIRST = 1;
	final int POINT_LAST = POINTS_PER_SIDE * 2;
	final int BAR_DARK = POINT_LAST + 1;
	final int BAR_LAST = BAR_DARK;
	double[] xPoint = new double[BAR_LAST + 1];

	// The layout of chips on the board is stored in two arrays indexed
	// by point number that gives the number of chips on that point.
	// Initialize to the standard starting position.
	int[] lightChipCounts = { 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5,
	                          0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0 };
	int[] darkChipCounts =  { 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0,
	                          5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0 };

	// The game chips
	GameObj[] lightChips = new GameObj[CHIPS_PER_PLAYER];
	GameObj[] darkChips = new GameObj[CHIPS_PER_PLAYER];

	// The dots images and dice squares
	final double DICE_SIZE = 5;
	final double DICE_OFFSET = DICE_SIZE * 0.7;
	GameObj[] dots = new GameObj[2];
	GameObj[] dice = new GameObj[2];

	// The dice roll values
	int numMoves = 0;            // 4 if doubles, otherwise 2 when rolled
	int[] moves = new int[4];    // each 1-6, negative if already moved, 0 if unused 

	// Data indexed by player (LIGHT or DARK)
	final int LIGHT = 0;
	final int DARK = 1;
	String[] labels = { "light", "dark" };
	String[] colors = { "yellow", "red" };

	// Game state variables
	int player = LIGHT;          // current player, LIGHT or DARK  
	int[] playerChipCounts;      // either lightChipCounts or darkChipCounts
	int[] opponentChipCounts;    // either lightChipCounts or darkChipCounts
	int opponentBar;             // either BAR_LIGHT or BAR_DARK
	boolean dragging = false;    // true when dragging a chip
	double xStart, yStart;       // starting position of chip being dragged


	// Start the game
	public void start()
	{
		// Make the background
		ct.setTitle( "Backgammon" );
		ct.setBackImage( "backgammon.png" );

		// Compute the xPoint array (x point positions) using 
		// values that visually align with the background image.
		xPoint[BAR_LIGHT] = X_BAR;
		xPoint[BAR_DARK] = X_BAR;
		xPoint[1] = 94;      // top-right point
		for (int i = 2; i <= 6; i++)
			xPoint[i] = xPoint[i - 1] - POINT_WIDTH;
		xPoint[7] = 44.3;
		for (int i = 8; i <= 12; i++)
			xPoint[i] = xPoint[i - 1] - POINT_WIDTH;
		for (int i = 13; i <= 24; i++)
			xPoint[i] = xPoint[25 - i];   // bottom reflects top

		// Create and place the chips
		createAndPlaceChips( lightChips, lightChipCounts, 
				colors[LIGHT], labels[LIGHT] );
		createAndPlaceChips( darkChips, darkChipCounts,
				colors[DARK], labels[DARK] );

		// Make the dice squares and dots images
		dice[0] = ct.rect( 0, Y_CENTER, DICE_SIZE, DICE_SIZE );
		dice[1] = ct.rect( 0, Y_CENTER, DICE_SIZE, DICE_SIZE );
		dots[0] = ct.image( "1.png", 0, Y_CENTER, DICE_SIZE - 1 );
		dots[1] = ct.image( "1.png", 0, Y_CENTER, DICE_SIZE - 1 );

		// Initialize the first turn randomly to LIGHT or DARK
		changeTurn();   // need to init turn state no matter what
		if (ct.random( 0, 1 ) == 1)
			changeTurn();
	}

	// Return the starting chip y coordinate for the point with the given index
	double yPoint( int i )
	{
		if (i == BAR_LIGHT)
			return Y_CENTER + CHIP_SPACING / 2;   // bar position for light
		else if (i == BAR_DARK)
			return Y_CENTER - CHIP_SPACING / 2;   // bar position for dark
		else if (i <= POINTS_PER_SIDE)
			return Y_POINT_TOP;
		else
			return Y_POINT_BOTTOM;
	}

	// Return the y spacing interval for chips at the point with the given index
	// (positive for top points, negative for bottom points).
	double chipSpacing( int i )
	{
		if (i == BAR_LIGHT)
			return CHIP_DIAMETER / 4;    // offset stack on light's side of the bar
		else if (i == BAR_DARK)
			return -CHIP_DIAMETER / 4;   // offset stack on dark's side of the bar
		else if (i <= POINTS_PER_SIDE)
			return CHIP_SPACING;
		else
			return -CHIP_SPACING;
	}

	// Create and place the chips using the given chips and counts arrays
	// and the given color and label for the chips.
	void createAndPlaceChips( GameObj[] chips, int[] counts, String color, String label )
	{
		int iChip = 0;
		for (int iPoint = 0; iPoint < BAR_LAST; iPoint++ )
		{
			double x = xPoint[iPoint];
			double y = yPoint( iPoint );

			for (int i = 0; i < counts[iPoint]; i++)
			{
				GameObj chip = ct.circle( x, y, CHIP_DIAMETER, color );
				chip.group = "chips";
				chip.setText( label );
				chips[iChip] = chip;
				iChip++;
				y += chipSpacing( iPoint );
			}
		}
	}

	// Return the point index at the given (x, y) location, or -1 if none.
	int iPointFromPosition( double x, double y )
	{
		// Test the center bar
		if (x == X_BAR)
		{
			if (y < Y_CENTER)
				return BAR_DARK;
			else
				return BAR_LIGHT;
		}

		// Determine point index range top or bottom based on y
		int iMin = 1;
		int iMax = POINTS_PER_SIDE * 2;
		if (y > Y_CENTER)
			iMin = POINTS_PER_SIDE + 1;
		else
			iMax = POINTS_PER_SIDE;

		// If close enough to a point's x then return its index
		for (int i = iMin; i <= iMax; i++)
		{
			if (Math.abs( x - xPoint[i] ) < POINT_WIDTH / 2)
				return i;
		}
		return -1;   // no point found close enough
	}

	// Roll the dice and set moves, numMoves, and the dots images
	void rollDice()
	{
		// Set the moves values
		moves[0] = ct.random( 1, 6 );
		moves[1] = ct.random( 1, 6 );
		numMoves = 2;
		if (moves[0] == moves[1])
		{
			// Doubles
			moves[2] = moves[0];
			moves[3] = moves[0];
			numMoves = 4;
		}

		// Set the dice images
		dots[0].setImage( moves[0] + ".png" );
		dots[1].setImage( moves[1] + ".png" );
	}

	// Set the turn to the other player (LIGHT or DARK) 
	// and set game state that depends on the player.
	void changeTurn()
	{
		// Get a new dice roll
		rollDice();

		// Change the turn state
		if (player == DARK)
		{
			player = LIGHT;
			playerChipCounts = lightChipCounts;
			opponentChipCounts = darkChipCounts;
			opponentBar = BAR_DARK;
			dice[0].x = 75 - DICE_OFFSET;
			dots[0].x = dice[0].x;
			dice[1].x = 75 + DICE_OFFSET;
			dots[1].x = dice[1].x;
		}
		else
		{
			player = DARK;
			playerChipCounts = darkChipCounts;
			opponentChipCounts = lightChipCounts;
			opponentBar = BAR_LIGHT;
			dice[0].x = 25 - DICE_OFFSET;
			dots[0].x = dice[0].x;
			dice[1].x = 25 + DICE_OFFSET;
			dots[1].x = dice[1].x;
		}
		dice[0].setFillColor( colors[player] );
		dice[1].setFillColor( colors[player] );
	}

	// If a move from iPointStart to iPointEnd is valid then return the
	// index in moves that was used, otherwise return -1 if invalid.
	int iMove( int iPointStart, int iPointEnd )
	{
		// Calculate the distance
		int distance = iPointEnd - iPointStart;
		if (player == DARK)
			distance = -distance;   // DARK moves "backwards"

		// See if this distance matches one of the dice moves
		for (int i = 0; i < numMoves; i++)
		{
			if (moves[i] == distance)
				return i;
		}
		return -1;
	}

	// Return true if all of the current moves have been used
	boolean allMovesUsed()
	{
		for (int i = 0; i < numMoves; i++)
		{
			if (moves[i] > 0)
				return false;
		}
		return true;
	}

	// Handle mouse press event
	public void onMousePress( GameObj chip, double x, double y )
	{
		// Was the press on a chip of the current player's color?
		if (chip == null)
			return;
		String label = chip.getText();
		if (!label.equals( labels[player] ))
			return;

		// Only the last chip on a point or bar can be dragged
		int iPoint = iPointFromPosition( chip.x, chip.y );
		if (iPoint < 0)
			return;
		int count = lightChipCounts[iPoint] + darkChipCounts[iPoint];
		double yLast = yPoint( iPoint ) + chipSpacing( iPoint ) * (count - 1);
		if (!chip.containsPoint( xPoint[iPoint], yLast ))
			return;
		
		// OK to drag this chip, remember its starting position
		chip.setLayer( 1 );   // move to top
		dragging = true;
		xStart = chip.x;
		yStart = chip.y;
	}

	// Handle mouse drag event to drag a chip
	public void onMouseDrag( GameObj chip, double x, double y )
	{
		// Are we dragging a chip?
		if (dragging && chip != null)
		{
			// Make the chip follow the mouse
			chip.x = x;
			chip.y = y;
		}
	}

	// Handle mouse release event to finish moving a chip
	public void onMouseRelease( GameObj chip, double x, double y )
	{
		// Are we ending a valid chip drag?
		if (!dragging)
			return;
		dragging = false;
		if (chip == null)
			return;

		// Did the chip land on a valid point? (can't drag to the bar)
		int iPoint = iPointFromPosition( x, y );
		if (iPoint >= POINT_FIRST && iPoint <= POINT_LAST) 
		{
			// Can the chip move here?
			int iPointStart = iPointFromPosition( xStart, yStart );
			int iMove = iMove( iPointStart, iPoint );
			int opponentCount = opponentChipCounts[iPoint];
			if (iMove >= 0 && opponentCount <= 1)
			{
				// Move the chip
				playerChipCounts[iPointStart]--;   // decrease count at starting point
				chip.x = xPoint[iPoint];
				chip.y = yPoint( iPoint ) + chipSpacing( iPoint ) * playerChipCounts[iPoint];
				playerChipCounts[iPoint]++;    // increase count at destination point

				// Did we hit a single opponent chip?
				if (opponentCount == 1)
				{
					// Move opponent chip to the bar
					GameObj opponentChip = chip.objectHitInGroup( "chips" );
					opponentChipCounts[iPoint]--;            // remove from point where hit
					opponentChip.x = xPoint[opponentBar];    // move to bar
					opponentChip.y = yPoint( opponentBar );
					opponentChip.y += chipSpacing( opponentBar ) * opponentChipCounts[opponentBar];
					opponentChip.setLayer( 1 );   // stack on top
					opponentChipCounts[opponentBar]++;
				}

				// Use this move, if all moves are used then change turns
				moves[iMove] = -moves[iMove];
				if (allMovesUsed())
					changeTurn();

				// Successful move
				return;
			}
		}

		// Illegal move, put it back
		chip.x = xStart;
		chip.y = yStart;
	}

}

