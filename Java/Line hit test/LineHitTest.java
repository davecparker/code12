// Test of GameLine.hit(GameObj obj) method
import Code12.*;

class LineHitTest extends Code12Program
{
   public static void main(String[] args)
   {
      Code12.run(new LineHitTest());
   }
   GameObj[] staticLines;
   GameObj[] movingObjs;
   GameObj clickedObj;
   double speed;
   double dx, dy;
   
   public void start()
   {
      speed = 1 / ct.getPixelsPerUnit();

      staticLines = new GameObj[8];

   	staticLines[0] = ct.line(0, 0, 100, 0, "blue");     // top wall
   	staticLines[1] = ct.line(0, 100, 100, 100, "blue");   // bottom wall
   	staticLines[2] = ct.line(0, 0, 0, 100, "blue");     // left wall
      staticLines[3] = ct.line(100, 0, 100, 100, "blue");   // right wall
      for (int i = 0; i <= 3; i++)
         staticLines[i].lineWidth = 5;

      staticLines[4] = ct.line(30, 30, 70, 70, "blue");  // diagonal line top left to bottom right
      staticLines[5] = ct.line(30, 70, 70, 30, "blue");  // diagonal line bottom left to top right
      staticLines[6] = ct.line(50, 25, 50, 75, "blue");  // vertical line in center
      staticLines[7] = ct.line(25, 50, 75, 50, "blue");  // horizontal line in center      

      movingObjs = new GameObj[11];
      movingObjs[0] = ct.rect(25, 90, 15, 10, "green");  // rect
      movingObjs[1] = ct.circle(75, 90, 10, "green");    // circle

      movingObjs[2] = ct.line(40, 5, 60, 5);    // horizontal lines at top
      movingObjs[3] = ct.line(20, 5, 35, 5);
      movingObjs[4] = ct.line(65, 5, 80, 5);
      for (int i = 2; i <= 4; i++)
         movingObjs[i].ySpeed = speed;

      movingObjs[5] = ct.line(5, 40, 5, 60);    // vertical lines at left
      movingObjs[6] = ct.line(5, 20, 5, 35);
      movingObjs[7] = ct.line(5, 65, 5, 80);
      for (int i = 5; i <= 7; i++)
         movingObjs[i].xSpeed = speed;

      movingObjs[8] = ct.line(40, 90, 60, 90);    // horizontal line at bottom
      movingObjs[8].ySpeed = speed;
      movingObjs[9] = ct.line(90, 40, 90, 60);    // vertical line at right
      movingObjs[9].xSpeed = speed;
      movingObjs[10] = ct.line(1, 99, 21, 79);    // diagonal line lower left corner


      for (GameObj obj : movingObjs)
         obj.clickable = true;
   }

   public void update()
   {
      for (GameObj line : staticLines)
      {
         boolean lineHitAnObj = false;
         for (GameObj obj : movingObjs)
         {
            if (line.hit(obj))
            {
               obj.xSpeed = 0;
               obj.ySpeed = 0;
               obj.setFillColor("red");
               obj.setLineColor("red");

               line.setLineColor("red");
               lineHitAnObj = true;
            }
         }
         if (!lineHitAnObj)
            line.setLineColor("blue");
      }
   }

	public void onMouseDrag( GameObj obj, double x, double y )
	{
		if ( obj != null )
		{
			obj.x = x - dx;
			obj.y = y - dy;
         obj.setFillColor("green");
         clickedObj.setLineColor("black");
		}
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		if ( obj != null )
		{
			clickedObj = obj;
         dx = x - obj.x;
         dy = y - obj.y;
		}
		else if (clickedObj != null)
		{
			double vx = x - clickedObj.x;
			double vy = y - clickedObj.y;
			double v = Math.sqrt(vx*vx + vy*vy);
			clickedObj.xSpeed = vx / v * speed;
			clickedObj.ySpeed = vy / v * speed;
         clickedObj.setFillColor("green");
		}
	}
   
   public void onKeyPress( String keyName )
   {
      if (keyName.equals("up"))
      {
         if (clickedObj != null)
         {
            clickedObj.lineWidth++;
         }
      }
   }
   

}
