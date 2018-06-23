import Code12.*;

public class EventsWhiteBoxTest extends Code12Program
{
   
   GameObj[][] squares;
   final int PAD = 20;
   final int ROWS = 10;
   final int COLS = 10;
   
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
   }
   
   
}