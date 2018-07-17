import Code12.*;

class minesweeper extends Code12Program
{  
      GameObj[] squares = new GameObj[100];
      int numbMines = 8;

      public static void main(String[] args)
      { 
            Code12.run( new minesweeper() ); 
      }

      //Function to put the squares into a pseudo 2d array
      public void setBox( int x, int y, GameObj square )
      {
            int i = (y * 10) + x;
            squares[i] = square;
      }

      public int getBoxIndex( GameObj square )
      {
            for( int i = 0; i < squares.length; i++ )
            {
                  if( square == squares[i] )
                        return i;
            }
            return -1;
      }

      //Returns the text value (mine or nearby mines) of the squares
      public String getBoxValue( int x, int y )
      {
            int i = (y * 10) + x;

            if( i > 0 && i < squares.length )
            {
                  GameObj returnMe = squares[i];
                  return returnMe.getText(); 
            }
            else
            {
                  return "badIndex";
            }
      }

      public void setBoxValue( int x, int y, String value )
      {
            int i = (y * 10) + x;
            GameObj setMe = squares[i];
            setMe.setText( value );
      }



      public void emptySquare( int i )
      {

      }

      public void onMousePress( GameObj obj, double x, double y )
      {
            if( obj != null)
            {
                  obj.visible = false;
                  String squareState = obj.getText();
                  if( squareState.equals("Bomb") )
                  {
                        GameObj endText = ct.text( "Game Over", 50, 20, 20 );
                        endText.setLayer(3);
                  }
                  if( squareState.equals("") )
                  {

                  }
                  
            }
      }

      public void start()
      {  
            for( int x = 0; x < 10; x++ ) // x = x cord of the square
            {
                  for( int y = 0; y < 10; y++ ) //  y = y cord of the square
                  {
                        GameObj square = ct.rect( 2.7+(x*5), 2.9+(y*5), 5, 5, "gray");
                        square.clickable = true;
                        square.setLayer( 2 );
                        setBox( x, y, square );
                  }
            }

            //Plants the bombs
            int m = 0;
            int[] bombCords = new int[8];

            while( m < numbMines )
            {
                  int randX = ct.random( 0, 9 );
                  int randY = ct.random( 0, 9 );
                  //Checks if there is already a bomb at this randomly selected coordinate
                  boolean uniqueBomb = true; 
                  int newBombCord = 10 * randX + randY;
                  
                  for( int bombChord : bombCords )
                  {
                        if( bombChord == newBombCord )     
                              uniqueBomb = false;
                  }

                  if( uniqueBomb )
                  {
                        setBoxValue( randX, randY, "Bomb");
                        bombCords[m] = newBombCord;
                        m++;
                  }
            }

            //Calculates the box numbers
            for( int x = 0; x < 10; x++ )
            {
                  for( int y = 0; y < 10; y++ )
                  {
                        String squareState = getBoxValue( x, y );
                        if( !squareState.equals("Bomb") )
                        {
                              int checkX = x - 1;
                              int checkY = y - 1;
                              int adjBombs = 0;
                              for( int j = 0; j <= 2; j++ )
                              {
                                    for( int k = 0; k <= 2; k++ )
                                    {
                                          String compare = getBoxValue( checkX + j, checkY + k );   
                                          if( compare.equals("Bomb") )
                                          {
                                                adjBombs += 1;
                                          }
                                    }
                              }
                              if( adjBombs == 0 )
                                    setBoxValue( x, y, "" );
                              else
                              {
                                    setBoxValue( x, y, ct.formatInt( adjBombs ) );
                              }
                        }
                  }
            }

            //Draws the box numbers and bombs
            for( GameObj square : squares )
            {
                  double sqrX = square.x;
                  double sqrY = square.y;

                  String squareState = square.getText(); //stores whether the square has a bomb or how many bombs are adjacent to it

                  if( squareState.equals("Bomb") )
                  {
                        ct.image( "bomb.jpg", sqrX, sqrY, 5);
                  }
                  else
                  {
                        ct.text( squareState, sqrX, sqrY, 5);
                  } 
                  
            }
      }

}
