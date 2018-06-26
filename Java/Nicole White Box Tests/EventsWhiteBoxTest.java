import Code12.*;

public class EventsWhiteBoxTest extends Code12Program
{
   
   GameObj[][] squares;
   final int PAD = 20;
   final int ROWS = 10;
   final int COLS = 10;
   
   int count = 1;
   boolean selected = false;
   
   public static void main(String[] args)
   {
      Code12.run(new EventsWhiteBoxTest());
   }

   public void start()
   {
      squares = new GameObj[ROWS][COLS];
      double gameWidth = ct.getWidth();
      double gameHeight = ct.getHeight();
      
      double xInc = (double)(gameWidth - 2*PAD)/COLS;
      double yInc = (double)(gameHeight - 2*PAD)/ROWS;
      
      
      for ( int i = 0; i < ROWS; i++)
      {
         double y = PAD + i*yInc;
         for ( int j = 0; j < COLS; j++)
         {
            double x = PAD + j*xInc;
            squares[i][j] = ct.rect(x,y,xInc, yInc );  
         }
      }
      
   }
   
   public void update()
   {
      // Allow tiles to be clicked
      for ( int i = 0; i < squares.length; i++ )
      {
         for ( int j = 0; j < squares[i].length; j++ )
         {
            squares[i][j].clickable = true;
         }
      }
            
     
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      
      if ( obj != null )
      {
         for ( int i = 0; i < squares.length; i++ )
         {
            for ( int j = 0; j < squares[i].length; j++ )
            {
                  if ( squares[i][j].containsPoint(x,y) )
                  {
                     squares[i][j].setFillColor("red");
                     selected = true;
                     ct.println("A tile located at: [" + ct.toInt(squares[i][j].x) + "," + ct.toInt(squares[i][j].y)
                                  + "] was clicked. Selected == " + selected);
                     count++;
                     // If clicked again, revert to original color
                     // Selected(highlighted in red) is false
                     if ( count % 2 != 0 )
                     {
                        squares[i][j].setFillColor("yellow");
                     }
    
                  }
                  
            }
          }
         
      }
   }

   
}