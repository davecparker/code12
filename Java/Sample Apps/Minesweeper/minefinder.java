import Code12.*;

class Minesweeper extends Code12Program
{  
      int columns = 20;
      int rows = 14;
      GameObj[] squares = new GameObj[rows * columns];
      GameObj[] flags = new GameObj[rows * columns];
      int numbFlags = 0;
      GameObj numb;
      int numbmines = 20;
      String squareState;
      double timer = 0;
      boolean mouseDown = false;
      GameObj gameStateIndicator;
      boolean gameOver = false;
      int squareIndex;

      public void start()
      { 
            ct.setHeight(80.5); //sets the screen height to match the grid size

            gameStateIndicator = ct.image( "smiley.jpg", 50, 5, 10 ); //Default game state
            gameStateIndicator.setClickable(false);
            for( int y = 0; y < rows; y++ ) //  y = y cord of the square
            {
                  for( int x = 0; x < columns; x++ ) // x = x cord of the square
                  {
                        GameObj square = ct.rect( 2.7+(x*5), 12.9+(y*5), 5, 5, "gray");
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
                  int randX = ct.random( 0, columns - 1 );
                  int randY = ct.random( 0, rows - 1 );
                  //Checks if there is already a mine at this randomly selected coordinate
                  boolean uniqueMine = true; 
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

      //Function to put the squares into a pseudo 2d array
      public void setSquare( int x, int y, GameObj square )
      {
            int i = (y * columns) + x;
            squares[i] = square;
      }

      public int getSquareIndex( GameObj square )
      {
            for( int i = 0; i < squares.length; i++ )
            {
                  if( square == squares[i] )
                        return i;
            }
            return -1;
      }

      public void setSquareValue( int x, int y, String value )
      {
            int i = (y * columns) + x;
            GameObj setMe = squares[i];
            setMe.setText( value );
      }

      public String getSquareValue( int x, int y )
      {
            int i = (y * columns) + x;
            GameObj getMe = squares[i];
            return getMe.getText();
      }

      public GameObj getSquare( int x, int y )
      {
            int i = (y * columns) + x;
            return squares[i];
      }

      public boolean goodIndex( int x, int y )
      {
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

      //Handles the user clicking an empty box
      public void emptySquare( int i )
      {
            int x = i % columns;
            int y = ct.intDiv( i , columns );

            for( int j = -1; j <= 1; j++ )
            {
                  for( int k = -1; k <= 1; k++ )
                  {  
                        if( goodIndex( x + j, y + k ) )
                        {     
                              GameObj otherSquare = getSquare( x + j, y + k );
                              if( otherSquare.visible )
                              {
                                    otherSquare.visible = false;
                                    int otherSquareI = getSquareIndex( otherSquare );
                                    if (flags[otherSquareI] != null)
                                    {
                                          flags[otherSquareI].delete();
                                    }
                                    String compare = otherSquare.getText();
                                    if( compare.equals("0") )
                                    {
                                          otherSquareI = getSquareIndex( otherSquare );
                                          emptySquare( otherSquareI );
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
                  timer += 1;
            }
      }

      public void onMouseRelease( GameObj obj, double x, double y )
      {
            mouseDown = false;

            if (!gameOver) //If the game is not over
            {
                  gameStateIndicator.setImage("smiley.jpg"); //Updates the game state indicator
            }

            if( timer <= 15 ) //Normal click
            {
                  if( obj != null)
                  {
                        if ( obj.group.equals("square") ) //something else has been pressed
                        {
                              squareIndex = getSquareIndex( obj );
                              if ( flags[squareIndex] != null ) //Checks if the square clicked has aa flag
                              {
                                    flags[squareIndex].delete();
                              }
                              else
                              {
                                    obj.visible = false; //Sets the square to be invisible
                                    squareState = obj.getText();

                                    if( squareState.equals("mine") ) //Checks if a mine has been clicked
                                    {
                                          endState( false ); 
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
                        else
                        {
                             obj.delete(); //deletes the flag 
                        }
                  }
            }
            else //Held down click
            {
                  if( obj!= null )
                  {
                        if ( obj.group.equals("square") ) //checks if the object clicked is a square
                        {
                              GameObj flag = ct.image( "flag.png", obj.x, obj.y, 3 );
                              flag.setLayer( 3 );
                              flag.setText( obj.getText() );
                              flag.group = "flag";
                              squareIndex = getSquareIndex(obj);
                              flags[squareIndex] = flag;
                              numbFlags += 1;
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
            endTextObj.setLayer(3); 
            endTextObj.setClickable(false);
      }
}
