import Code12.*;

class Minesweeper extends Code12Program
{  
      //Global Variables
      int columns = 20; //number of columns in the play area
      int rows = 14; //number of rows in the play area
      int numbmines = 25; //number of mine in the game
      double timer = 0; //variable to track the amount of time the mouse is held down

      boolean mouseDown = false; //boolean to track the status of the mouse click
      boolean gameOver = false; //boolean to track the state of the game

      GameObj[] squares = new GameObj[rows * columns]; //array of all squares
      GameObj[] flags = new GameObj[rows * columns]; //array of all flags
      GameObj gameStateIndicator; //smiley/afraid/win/lose face at the top of the play area
      
      //Placeholder variables
      int squareIndex; //placeholder variable used to index the squares array
      GameObj numb; // placeholder object used to create the mine indication numbers 
      String squareState; //placeholder string used to query and compare the status of a square
                         //which is stored in object.text


      public void start()
      { 
            //Game Initialization
            ct.setHeight(80.5); //sets the screen height to match the grid size

            gameStateIndicator = ct.image( "smiley.jpg", 50, 5, 10 ); //Default game state
            gameStateIndicator.setClickable(false);
            for( int y = 0; y < rows; y++ ) //  y = y cord of the square
            {
                  for( int x = 0; x < columns; x++ ) // x = x cord of the square
                  {
                        GameObj square = ct.rect( 2.7+(x*5), 12.9+(y*5), 4.8, 4.8, "gray");
                        square.setLayer( 2 );
                        square.setText("");
                        square.group = "square"; //Puts the square into the square group
                        setSquare( x, y, square );
                  }
            }

            //Plants the mines
            int m = 0;
            int[] mineCords = new int[numbmines];

            while( m < numbmines )
            {
                  int randX = ct.random( 0, columns - 1 ); //random x position within play area
                  int randY = ct.random( 0, rows - 1 );  //random y position within play area
                  
                  //Checks if there is already a mine at this randomly selected coordinate
                  boolean uniqueMine = true; //if false another mine at the same location exists
                  int newMineCord = (columns * randY) + randX;
                  for( int mineChord : mineCords )
                  {
                        if( mineChord == newMineCord )     
                              uniqueMine = false;
                  }

                  if( uniqueMine )
                  {
                        setSquareValue( randX, randY, "mine");
                        mineCords[m] = newMineCord;
                        m++;
                  }
            }

            //Calculates the square numbers
            for( int x = 0; x < columns; x++ )
            {
                  for( int y = 0; y < rows; y++ )
                  {
                        
                        squareState = getSquareValue(  x, y ); 
                        if( ! (squareState.equals("mine")) )
                        {
                              int adjmines = 0;
                              for( int j = -1; j <= 1; j++ )
                              {
                                    for( int k = -1; k <= 1; k++ )
                                    {
                                          if( goodIndex( x+j, y+k) )
                                          {
                                                String compare = getSquareValue(  x + j, y + k );  
                                                if( compare.equals("mine") )
                                                {
                                                      adjmines += 1;
                                                }
                                          }
                                    }
                              }
                              if( adjmines == 0 )
                                    setSquareValue( x, y, "0" );
                              else
                              {
                                    setSquareValue( x, y, ct.formatInt( adjmines ) );
                              }
                        } 
                  }
            }

            //Draws the square numbers and mines
            for( GameObj square : squares )
            {

                  double sqrX = square.x;
                  double sqrY = square.y;

                  squareState = square.getText(); //stores whether the square has a mine or how many mines are adjacent to it
                  if( squareState.equals("mine") )
                  {
                        GameObj mine = ct.image( "mine.jpg", sqrX, sqrY, 5);
                        mine.setClickable(false);
                  }
                  else
                  {
                        if( squareState.equals("0") )
                        {
                              numb = ct.text( "", sqrX, sqrY, 5);
                              numb.setClickable(false);
                        }
                        else
                        {
                              numb = ct.text( squareState, sqrX, sqrY, 5);
                              numb.setClickable(false);
                        }
                        
                  } 
                  
            }
      }

      //Set of functions to create a pseudo 2d array for the squares
      public void setSquare( int x, int y, GameObj square )
      {
            //given a x and y position within the play area puts a square into the 2d array
            int i = (y * columns) + x;
            squares[i] = square;
      }

      public int getSquareIndex( GameObj square )
      {
            //given a square object finds the index of that square within the array
            for( int i = 0; i < squares.length; i++ )
            {
                  if( square == squares[i] )
                        return i;
            }
            return -1; //return value if square is not found
      }

      public void setSquareValue( int x, int y, String value )
      {
            //given an x and y position and a square value sets a square within the array's value
            int i = (y * columns) + x;
            GameObj setMe = squares[i];
            setMe.setText( value );
      }

      public String getSquareValue( int x, int y )
      {     
            //given an x and y position and a square value returns a square within the array's value
            int i = (y * columns) + x;
            GameObj getMe = squares[i];
            return getMe.getText();
      }

      public GameObj getSquare( int x, int y )
      {
            //given an x and y position returns the square at that location 
            int i = (y * columns) + x;
            return squares[i];
      }

      public boolean goodIndex( int x, int y )
      {
            //given an x and y position checks if it is within the play area
            if( x >= 0 && x < columns )
            {
                  if( y >= 0 && y < rows )
                  {
                        int i = (y * columns) + x;
                        if( i >= 0 && i <= squares.length - 1 )
                        {
                              return true;
                        }
                  }
            }
            return false;
      }
      // end of pseudo 2-d array functions

      //Handles the user clicking a square with no adjacent mines
      public void emptySquare( int i )
      {
            int x = i % columns; //finds the x position of the square given its index
            int y = ct.intDiv( i , columns ); //finds the y position of the square given its index

            //loops through the adjacent squares to the one clicked
            for( int j = -1; j <= 1; j++ ) 
            {
                  for( int k = -1; k <= 1; k++ )
                  {  
                        if( goodIndex( x + j, y + k ) ) //makes sure that the index is within play area
                        {     
                              GameObj otherSquare = getSquare( x + j, y + k );
                              if( otherSquare.visible ) //if the given adjacent square has not yet been revealed
                              {
                                    otherSquare.visible = false; //reveal it
                                    int otherSquareI = getSquareIndex( otherSquare ); //gets the other square's index
                                    if (flags[otherSquareI] != null) //checks if the square being revealed has a flag
                                    {
                                          flags[otherSquareI].delete(); //if it does removes that flag
                                    }
                                    String compare = otherSquare.getText(); //gets the other square's value
                                    if( compare.equals("0") ) //if it also does not have any adjacent mine
                                    {
                                          emptySquare( otherSquareI ); //calls the empty square function with its index
                                    }
                              }
                        }
                  }
            }    
      }

      public void onMousePress( GameObj obj, double x, double y )
      {
            mouseDown = true; //This variable starts a timer in update
            if (!gameOver) //If the game is not over
            {
                  gameStateIndicator.setImage("scared.jpg");  //Updates the game state indicator
            }

      }

      public void update()
      {
            if( mouseDown ) //tracks how long the mouse is held down 
            {
                  timer += 1; //one incriment for each tick
            }
      }

      public void onMouseRelease( GameObj obj, double x, double y )
      {
            mouseDown = false; //turns of the timer
            if (!gameOver) //if the game is not over
            {
                  gameStateIndicator.setImage("smiley.jpg"); //updates the game state indicator
            }

            if( timer <= 15 ) //normal click
            {
                  if( obj != null) //ensures that the user clicked a flag or square (gamestate indicator is not clickable)
                  {
                        if ( obj.group.equals("square") ) //a square has been pressed
                        {
                              squareIndex = getSquareIndex( obj );
                              if ( flags[squareIndex] != null ) //Checks if the square clicked has a flag
                              {
                                    flags[squareIndex].delete(); //deletes the flag
                                    flags[squareIndex] = null;
                              }
                              else
                              {
                                    obj.visible = false; //Sets the square to be invisible
                                    squareState = obj.getText();

                                    if( squareState.equals("mine") ) //Checks if a mine has been clicked
                                    {
                                          endState( false ); //starts the endgame lose funtion
                                    }
                  
                                    if( squareState.equals("0") )
                                    {
                                          squareIndex = getSquareIndex(obj);
                                          int sqrX = squareIndex % columns;
                                          int sqrY = ct.intDiv( squareIndex , columns );
                                          for( int j = -1; j <= 1; j++ )
                                          {
                                                for( int k = -1; k <= 1; k++ )
                                                {  
                                                      if( goodIndex( sqrX+j, sqrY+k ) )
                                                      {     
                                                            GameObj otherSquare = getSquare( sqrX + j, sqrY + k );
                                                            String compare = otherSquare.getText();
                                                            if( compare.equals("0") && otherSquare.visible)
                                                            {
                                                                  int otherSquareI = getSquareIndex( otherSquare );
                                                                  emptySquare( otherSquareI );
                                                            }
                                                      }
                                                }
                                          }     
                                    }    
                              }   
                        }
                        else //a flag has been pressed
                        {
                              obj.delete(); //deletes the flag
                              flags[squareIndex] = null; //removes the flag from the flag array
                        }
                  }
            }
            else //held down click
            {
                  if( obj!= null )
                  {
                        if ( obj.group.equals("square") ) //checks if the object clicked is a square
                        {
                              GameObj flag = ct.image( "flag.png", obj.x, obj.y, 3 );
                              flag.setLayer( 3 ); //sets the flag layer so it is on top of the squares
                             // flag.setText( obj.getText() ); //matches the flag text to the square text
                              flag.group = "flag";
                              squareIndex = getSquareIndex(obj);
                              flags[squareIndex] = flag;
                        }
                                              
                  }      
            }

            timer = 0;
            checkWin( );
      }

      public void checkWin( )
      {
            boolean win = true;
            for( GameObj square : squares )
            {
                  squareState = square.getText();
                  if( square.visible == true && !squareState.equals("mine") )
                  {
                        win = false;
                        break;
                  }
            }

            if( win )
            {
                  endState( true ); //Winning endgame state
            }
      }
      public void endState( boolean win )
      {
            gameOver = true;
            String endText;
            if( win )
            {
                  endText = "You Won!";
                  gameStateIndicator.setImage("win.jpg");
            }
            else
            {
                  endText = "Game Over";
                  gameStateIndicator.setImage("lose.jpg");
            }

            for( GameObj flag : flags )
            {
                  flag.setClickable(false);
            }
            for( GameObj square : squares )
            {
                  square.setClickable(false);
                  String compare = square.getText();
                  if( compare.equals("mine" ) ) //Reveals all remaining mines
                  {
                        if( square.visible )
                        {
                              square.visible = false;
                        }
                  }   
            } 

            GameObj endTextObj = ct.text( endText, 50, 20, 20 ); //Displays the endgame text depending on if the game is won or lost
            endTextObj.setLayer(4); //sets the layer so the endgame text is above everything else
            endTextObj.setClickable(false);
      }
}
