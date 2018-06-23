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

   public void start()
   {
      speed = 1 / ct.getPixelsPerUnit();

      staticLines = new GameObj[6];

   	staticLines[0] = ct.line(5, 5, 95, 5, "blue");     // top wall
   	staticLines[1] = ct.line(5, 95, 95, 95, "blue");   // bottom wall
   	staticLines[2] = ct.line(5, 5, 5, 95, "blue");     // left wall
      staticLines[3] = ct.line(95, 5, 95, 95, "blue");   // right wall

      staticLines[4] = ct.line(30, 30, 70, 70, "blue");  // diagonal line top left to bottom right
      staticLines[5] = ct.line(30, 70, 70, 30, "blue");  // diagonal line bottom left to top right

      movingObjs = new GameObj[8];
      movingObjs[0] = ct.rect(25, 10, 10, 10);  // rect
      movingObjs[1] = ct.circle(75, 10, 10);    // circle

      movingObjs[2] = ct.line(40, 0, 60, 0);    // horizontal lines from top
      movingObjs[3] = ct.line(20, 0, 40, 0);
      movingObjs[4] = ct.line(60, 0, 80, 0);
      for (int i = 2; i <= 4; i++)
         movingObjs[i].ySpeed = speed;

      movingObjs[5] = ct.line(0, 40, 0, 60);    // vertical lines from left
      movingObjs[6] = ct.line(0, 20, 0, 40);
      movingObjs[7] = ct.line(0, 60, 0, 80);
      for (int i = 5; i <= 7; i++)
         movingObjs[i].xSpeed = speed;

      for (GameObj obj : movingObjs)
         obj.clickable = true;
   }

   public void update()
   {
      for (GameObj line : staticLines)
      {
         for (GameObj obj : movingObjs)
         {
            if (line.hit(obj))
            {
               obj.xSpeed = 0;
               obj.ySpeed = 0;
            }
         }
      }
   }

	public void onMouseDrag( GameObj obj, double x, double y )
	{
		if ( obj != null )
		{
			obj.x = x;
			obj.y = y;
		}
	}

	public void onMousePress( GameObj obj, double x, double y )
	{
		if ( obj != null )
		{
			clickedObj = obj;
		}
		else if (clickedObj != null)
		{
			double vx = x - clickedObj.x;
			double vy = y - clickedObj.y;
			double v = Math.sqrt(vx*vx + vy*vy);
			clickedObj.xSpeed = vx / v * speed;
			clickedObj.ySpeed = vy / v * speed;
		}
	}
}
