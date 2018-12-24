// Test of GameLine.hit(GameObj obj) method
import Code12.*;

class LineHitTest extends Code12Program
{
   GameObj[] objs;
   GameObj clickedObj = null;
   double startSpeed;
   double speed;
   double dx = 0;
   double dy = 0;

   public void start()
   {
      speed = 1 / ct.getPixelsPerUnit();
      startSpeed = speed; 
      
      objs = new GameObj[19];

      objs[0] = ct.rect(25, 90, 15, 10, "gray");  // rect
      objs[1] = ct.circle(75, 90, 10, "gray");    // circle

      objs[2] = ct.line(2, 0, 98, 0, "blue");     // top wall
      objs[3] = ct.line(2, 100, 98, 100, "blue");   // bottom wall
      objs[4] = ct.line(0, 2, 0, 98, "blue");     // left wall
      objs[5] = ct.line(100, 2, 100, 98, "blue");   // right wall
      for (int i = 2; i <= 5; i++)
         objs[i].setLineWidth(5);
      // static lines in center cross
      objs[6] = ct.line(30, 30, 70, 70, "blue");  // diagonal line top left to bottom right
      objs[7] = ct.line(30, 70, 70, 30, "blue");  // diagonal line bottom left to top right
      objs[8] = ct.line(50, 25, 50, 75, "blue");  // vertical line in center
      objs[9] = ct.line(25, 50, 75, 50, "blue");  // horizontal line in center
      // moving lines
      objs[10] = ct.line(40, 5, 60, 5);    // horizontal lines at top
      objs[11] = ct.line(20, 5, 35, 5);
      objs[12] = ct.line(65, 5, 80, 5);
      for (int i = 10; i <= 12; i++)
         objs[i].setYSpeed( startSpeed );
      objs[13] = ct.line(5, 40, 5, 60);    // vertical lines at left
      objs[14] = ct.line(5, 20, 5, 35);
      objs[15] = ct.line(5, 65, 5, 80);
      for (int i = 13; i <= 15; i++)
         objs[i].setXSpeed( startSpeed );
      objs[16] = ct.line(40, 90, 60, 90);    // horizontal line at bottom
      objs[16].setYSpeed( startSpeed );
      objs[17] = ct.line(90, 40, 90, 60);    // vertical line at right
      objs[17].setXSpeed( startSpeed );
      objs[18] = ct.line(95, 95, 90, 90);    // diagonal line lower right corner
      objs[18].setXSpeed( -startSpeed );
      objs[18].setYSpeed( -startSpeed );

      for (int i = 0; i < objs.length; i++)
      {
         if (i > 1)
         {
            objs[i].group = "line";
         }
         objs[i].setText("1");
      }

   }

   public void update()
   {
      // Reset obj colors
      for (int i = 0; i < objs.length; i++)
      {
         GameObj obj = objs[i];
         String group = obj.group;
         if (group.equals("line"))
            obj.setLineColor("black");
         else
            obj.setFillColor("gray");
      }
      // Check if any objects hit each other and change their color if so
      for (int i = 0; i < objs.length; i++)
      {
         GameObj obj1 = objs[i];
         String group1 = obj1.group;
         boolean obj1HitNothing = true;
         for (int j = i + 1; j < objs.length; j++)
         {
            GameObj obj2 = objs[j];
            String group2 = obj2.group;
            if (obj1.hit(obj2))
            {
               obj1HitNothing = false;
               obj1.setXSpeed( 0 );
               obj1.setYSpeed( 0 );
               obj2.setXSpeed( 0 );
               obj2.setYSpeed( 0 );
               if (group1.equals("line"))
                  obj1.setLineColor("red");
               else
                  obj1.setFillColor("red");
               if (group2.equals("line"))
                  obj2.setLineColor("red");
               else
                  obj2.setFillColor("red");
            }
         }
      }
   }

   public void onMousePress( GameObj obj, double x, double y )
   {
      if ( obj == null )
      {
         clickedObj = null;
      }
      else
      {
         clickedObj = obj;
         dx = x - obj.x;
         dy = y - obj.y;
         ct.println(obj.toString() + " clicked");
      }
   }

   public void onMouseDrag( GameObj obj, double x, double y )
   {
      if ( obj != null )
      {
         obj.x = x - dx;
         obj.y = y - dy;
      }
   }


   public void onKeyPress( String keyName )
   {
      if (keyName.equals("+"))
      {
         if (clickedObj != null)
         {
            int lineWidth = ct.parseInt(clickedObj.getText());
            lineWidth++;
            clickedObj.setLineWidth(lineWidth);
            clickedObj.setText("" + lineWidth);
         }
      }
      else if (keyName.equals("-"))
      {
         if (clickedObj != null)
         {
            int lineWidth = ct.parseInt(clickedObj.getText());
            if (lineWidth > 0)
            {
               lineWidth--;
               clickedObj.setLineWidth(lineWidth);
               clickedObj.setText("" + lineWidth);
            }
         }
      }
      else if (clickedObj != null)
      {
         if (keyName.equals("up"))
         {
            clickedObj.setYSpeed( -speed );
            clickedObj.setXSpeed( 0 );
         }
         else if (keyName.equals("down"))
         {
            clickedObj.setYSpeed( speed );
            clickedObj.setXSpeed( 0 );

         }
         else if (keyName.equals("left"))
         {
            clickedObj.setXSpeed( -speed );
            clickedObj.setYSpeed( 0 );
         }
         else if (keyName.equals("right"))
         {
            clickedObj.setXSpeed( speed );
            clickedObj.setYSpeed( 0 );
         }
         else if (keyName.equals("space"))
         {
            clickedObj.setXSpeed( 0 );
            clickedObj.setYSpeed( 0 );         
         }
      }
   }

   public static void main(String[] args)
   {
      Code12.run(new LineHitTest());
   }
}
