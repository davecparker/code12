import Code12.*;
import java.lang.Thread;

public class MainProgram extends Code12Program
{
   GameObj shields[] = new GameObj[10];
   
   GameObj player;
   GameObj baddie;
   GameObj weapon;
   
   
   
   public static void main(String[] args) 
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   { 
      GameObj floor = ct.line(0, ct.getHeight() - 20, ct.getWidth(), ct.getHeight() - 20);
      floor.setLineColor("black");
      floor.lineWidth = 10;
      
      //background
      ct.setBackImage("mountains.jpg");
      
      player = ct.image("pixel.png", 50, ct.getHeight() - 25, 10 );
      
      
      
   }
  
   public void update()                //note. add timer to inc difficulty over time
   {
      wrapAround( player );
      
      //save for later use
      /*for ( int i = 0; i < shields.length; i++ )
      {
         GameObj shield = ct.rect( player.x, player.y, 10, 10 );
         shield.setFillColor("gray");
      }*/
      int count = 0;
      
      for ( int i = 0; i < shields.length; i++ )
      {
         GameObj shield = ct.rect( player.x, player.y - 30, 10, 10 );
         shield.setFillColor("gray");
         count++;
        
      }
           
   }
   
  
   
   public void wrapAround( GameObj obj )
   {
      double height = ct.getHeight();
      double width = ct.getWidth();
      
       if ( obj.x <= 0 )
       {
         //obj.setPosition( width, obj.y );
         obj.x = width;
         obj.y = obj.y;
      }
      
      if ( obj.x > width )
         obj.x = 0;
         //obj.setPosition( 0, obj.y );
      
      
      if ( obj.y <= 0 )
         obj.y = height - 25;
         //obj.setPosition( obj.x, height );
   }
   
   public void onKeyPress( String key )
   {
      int jump = 0;
      switch( key )
      {
         case("up"):
        
               player.y = player.y - 10;
             
            break;
         case("right"):
            player.x = player.x + 3;
            player.xSpeed = 0.5;
            break;
         case("left"):
            player.x = player.x - 3;
            break;
         case("space"):
            weapon = ct.circle( player.x + 3, player.y, 1 );         //todo. add small rand numb gen to get dif sounds
            ct.sound("laser-cannon.wav");
            weapon.setFillColor("white");
            weapon.xSpeed = 1;
      }
   }
   
   public void onMousePress( GameObj obj, double x, double y )
   {
   }
}
