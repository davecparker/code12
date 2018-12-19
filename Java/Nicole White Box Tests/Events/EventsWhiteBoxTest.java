import Code12.*;

public class EventsWhiteBoxTest extends Code12Program
{
   GameObj[] boxes;
   final int PAD = 20;
   final int ROWS = 10;
   final int COLS = 10;

   double lastX, lastY;
   boolean selected = false;
   
   public static void main(String[] args)
   {
      Code12.run(new EventsWhiteBoxTest());
   }

   public void start()
   {
      // instantiate the array
      boxes  = new GameObj[100];
      
      double gameWidth = ct.getWidth();
      double gameHeight = ct.getHeight();
      
      double xInc = (gameWidth - 2*PAD)/COLS;
      double yInc = (gameHeight - 2*PAD)/ROWS;
      
      // draw boxes(game rects)
      for ( int i = 0; i < ROWS; i++ )
      {
         double y = PAD + i * yInc; // y value is always changing
         for ( int j = 0; j < COLS; j++ )
         {
            double x = PAD + j * xInc;
            boxes[i*j] = ct.rect(x,y,xInc,yInc);
         }
         
      }
    //   squares = new GameObj[ROWS][COLS];
// 
//       for ( int i = 0; i < ROWS; i++)
//       {
//          double y = PAD + i*yInc;
//          for ( int j = 0; j < COLS; j++)
//          {
//             double x = PAD + j*xInc;
//             squares[i][j] = ct.rect(x,y,xInc, yInc );  
//          }
//       }
      
    // GameObj newArray[] = new GameObj[squares.length*squares[0].length];
//     for ( int i = 0; i < squares.length; i++ )
//     {
//         GameObj[] row = squares[i];
//         for ( int j = 0; j < row.length; j++ )
//         {
//             GameObj number = squares[i][j];
//             newArray[i*row.length+j] = number;
//         }
//     }
    
      
   }
   
   public void update()
   {
      // Allow tiles to be clicked
      for ( int i = 0; i < ROWS; i++ )
      {
         for ( int j = 0; j < COLS; j++ )
         {
            boxes[i*j].clickable = true;
         }
      }

   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
      lastX = x;
      lastY = y;
      
      if ( obj != null )
      {
         for ( int i = 0; i < ROWS; i++ )
         {
               for ( int j = 0; j < COLS; j++ )
               {
                  if ( boxes[i*j].containsPoint(x,y) )
                  {
                     boxes[i*j].setFillColor("red");
                     ct.println("A tile located at: [" + (int)(boxes[i*j].x) + "," + (int)(boxes[i*j].y) + " ] was clicked.");
                  }
               }
            
         }
      }
         
 }

   
}