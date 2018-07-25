import Code12.*;

class minesweeper extends Code12Program
{  
      int rows = 10;
      int columns = 10;
      GameObj[] squares = new GameObj[rows * columns];
      int numbMines = 10;
      String squareState;
      double timer = 0;
      boolean mouseDown = false;

      public static void main(String[] args)
      { 
            Code12.run( new minesweeper() ); 
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
            if( x >= 0 && x < rows )
            {
                  if( y >= 0 && y < columns )
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
                                    String compare = otherSquare.getText();
                                    if( compare.equals("0") )
                                    {
                                          int otherSquareI = getSquareIndex( otherSquare );
                                          emptySquare( otherSquareI );
                                    }
                              }
                        }
                  }
            }    
      }

      public void onMousePress( GameObj obj, double x, double y )
      {
            mouseDown = true;
      }

      public void onMouseRelease( GameObj obj, double x, double y )
      {
            if( count <= 60 )
            {
                  if( obj != null)
                  {
                        obj.visible = false;
                        squareState = obj.getText();

                        if( squareState.equals("Mine") )
                        {
                              for( GameObj square : squares )
                              {
                                    square.clickable = false;
                                    String compare = square.getText();
                                    if( compare.equals("Mine" ) )
                                    {
                                          if( square.visible )
                                          {
                                                square.visible = false;
                                          }
                                    }   
                              }  

                              GameObj endText = ct.text( "Game Over", 50, 20, 20 );
                              endText.setLayer(3);
                        }
                        
                        if( squareState.equals("0") )
                        {
                              int i = getSquareIndex(obj);
                              int sqrX = i % columns;
                              int sqrY = ct.intDiv( i , columns );
                              for( int j = -1; j <= 1; j++ )
                              {
                                    for( int k = -1; k <= 1; k++ )
                                    {  
                                          if( goodIndex( sqrX+j, sqrY+k ) )
                                          {     
                                                GameObj otherSquare = getSquare( sqrX + j, sqrY + k );
                                                otherSquare.visible = false;
                                                String compare = otherSquare.getText();
                                                if( compare.equals("0") )
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
                  
            }
      }

      public void start()
      {  
            for( int x = 0; x < rows; x++ ) // x = x cord of the square
            {
                  for( int y = 0; y < columns; y++ ) //  y = y cord of the square
                  {
                        GameObj square = ct.rect( 2.7+(x*5), 12.9+(y*5), 5, 5, "gray");
                        square.clickable = true;
                        square.setLayer( 2 );
                        square.setText("");
                        setSquare( x, y, square );
                  }
            }

            //Plants the mines
            int m = 0;
            int[] mineCords = new int[numbMines];

            while( m < numbMines )
            {
                  int randX = ct.random( 0, rows - 1 );
                  int randY = ct.random( 0, columns - 1 );
                  //Checks if there is already a mine at this randomly selected coordinate
                  boolean uniqueMine = true; 
                  int newMineCord = columns * randX + randY;
                  
                  for( int mineChord : mineCords )
                  {
                        if( mineChord == newMineCord )     
                              uniqueMine = false;
                  }

                  if( uniqueMine )
                  {
                        setSquareValue( randX, randY, "Mine");
                        mineCords[m] = newMineCord;
                        m++;
                  }
            }

            //Calculates the square numbers
            for( int x = 0; x < rows; x++ )
            {
                  for( int y = 0; y < columns; y++ )
                  {
                        
                        squareState = getSquareValue(  x, y ); 
                        if( ! (squareState.equals("Mine")) )
                        {
                              int adjMines = 0;
                              for( int j = -1; j <= 1; j++ )
                              {
                                    for( int k = -1; k <= 1; k++ )
                                    {
                                          if( goodIndex( x+j, y+k) )
                                          {
                                                String compare = getSquareValue(  x + j, y + k );  
                                                if( compare.equals("Mine") )
                                                {
                                                      adjMines += 1;
                                                }
                                          }
                                    }
                              }
                              if( adjMines == 0 )
                                    setSquareValue( x, y, "0" );
                              else
                              {
                                    setSquareValue( x, y, ct.formatInt( adjMines ) );
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
                  if( squareState.equals("Mine") )
                  {
                        ct.image( "mine.jpg", sqrX, sqrY, 5);
                  }
                  else
                  {
                        if( squareState.equals("0") )
                        {
                              ct.text( "", sqrX, sqrY, 5);
                        }
                        else
                        {
                              ct.text( squareState, sqrX, sqrY, 5);
                        }
                        
                  } 
                  
            }
      }

      public void update()
      {
            if( mouseDown )
            {
                  count += 1;
            }
      }
}
