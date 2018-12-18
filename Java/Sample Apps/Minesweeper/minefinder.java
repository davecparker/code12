import Code12.*;

class minesweeper extends Code12Program
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
      GameObj smiley;

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
                  endState( true );
            }
      }

      public void endState( boolean win )
      {
            String endText;
            if( win )
            {
                  endText = "You Won!";
            }
            else
            {
                  endText = "Game Over";
            }

            for( GameObj flag : flags )
            {
                  flag.clickable = false;
            }
            for( GameObj square : squares )
            {
                  square.clickable = false;
                  String compare = square.getText();
                  if( compare.equals("mine" ) )
                  {
                        if( square.visible )
                        {
                              square.visible = false;
                        }
                  }   
            } 

            GameObj endTextObj = ct.text( endText, 50, 20, 20 );
            endTextObj.setLayer(3); 
            endTextObj.clickable = false;
      }

      public void onMousePress( GameObj obj, double x, double y )
      {
            mouseDown = true;
      }

      public void onMouseRelease( GameObj obj, double x, double y )
      {
            mouseDown = false;

            if( timer <= 15 )
            {
                  if( obj != null)
                  {
                        obj.visible = false;
                        squareState = obj.getText();

                        
                        if( squareState.equals("mine") )
                        {
                              endState( false );
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
                  if( obj!= null )
                  {
                        ct.println(timer);
                        GameObj flag = ct.image( "flag.png", obj.x, obj.y, 3 );
                        flag.setLayer( 3 );
                        flag.setText( obj.getText() );
                        flags[numbFlags] = flag;
                        numbFlags += 1;                      
                  }      
            }

            timer = 0;
            checkWin( );
      }

      public void start()
      { 
            ct.setHeight(80.5); //sets the screen height to match the grid size

            smiley = ct.image( "smiley.jpg", 50, 5, 10 );
            for( int y = 0; y < rows; y++ ) //  y = y cord of the square
            {
                  for( int x = 0; x < columns; x++ ) // x = x cord of the square
                  {
                        GameObj square = ct.rect( 2.7+(x*5), 12.9+(y*5), 5, 5, "gray");
                        square.setLayer( 2 );
                        square.setText("");
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
                        mine.clickable = false;
                  }
                  else
                  {
                        if( squareState.equals("0") )
                        {
                              numb = ct.text( "", sqrX, sqrY, 5);
                              numb.clickable = false;
                        }
                        else
                        {
                              numb = ct.text( squareState, sqrX, sqrY, 5);
                              numb.clickable = false;
                        }
                        
                  } 
                  
            }
      }

      public void update()
      {
            if( mouseDown )
            {
                  timer += 1;
            }

      }
}
