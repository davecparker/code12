import Code12.*;

class MoreInputTesting extends Code12Program
{

   GameObj[] circles;
   String[] colors = {"black", "white", "red", "green", "blue", "cyan", "magenta", "yellow"};
   boolean speed;
   int yourSpeed;

   public static void main(String[] args)
   { 
      Code12.run(new MoreInputTesting()); 
   }
   
   public void start()
   {
      int numCircles = ct.inputInt("Enter number of circles to be drawn");
      circles = new GameObj[numCircles];
      for ( int i = 0; i < circles.length; i++ )
      {
         circles[i] = ct.circle(ct.random(0,(int)(ct.getWidth()) ), ct.random(0, (int)(ct.getHeight()) ), ct.random(1,25));
         for ( int j = 0; j < colors.length; j++ )
         {
            circles[i].setFillColor(colors[j]);
         }
      }

      speed = ct.inputYesNo("Should they be set at a random speed?");
      if ( speed == false )
      {
         yourSpeed = ct.inputInt("Enter your own speed");
      }
         
      
      

   }
   
   public void update()
   {
      if ( speed == true )
      {
            for ( int i = 0; i < circles.length; i++ )
            {
               circles[i].setXSpeed( ct.random(1, 5) );
            }
      }

      else
      {
         for ( int i = 0; i < circles.length; i++ )
         {
            circles[i].setXSpeed( yourSpeed );
         }
      }

      for ( int i = 0; i < circles.length; i++ )
      {
         wrapAround(circles[i]);
      }
      
   }

   public void onMousePress(GameObj obj, double x, double y )
   {
      for ( int i = 0; i < circles.length; i++ )
      {
         if ( obj == circles[i])
            ct.showAlert("You clicked on circle number " + i + "!");
      }
   }

   public void wrapAround(GameObj obj)
   {
      if ( obj.x > ct.getWidth() )
         obj.x = 0;
      else if ( obj.y > ct.getHeight() )
         obj.y = 0;
   }
   
}