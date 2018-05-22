import Code12.*;

public class MainProgram extends Code12Program
{
   //Instance Variables
   GameText display;
   GameObj buttons[] = new GameObj[10];
   
   
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {  
      
      
      
      buttons[0] = ct.rect( 20, 83, 15, 10, "grey");
      buttons[0].clickable = true;
      ct.text( "0" , 20, 83, 10, "black" );
      
      int num = 1;
      //Prints the number keys (1-9)
      for (int y = 70; y >= 44; y -= 13) //outer loop controls y of buttons
      {
         for ( int x = 20; x <= 54; x+=17) // inner loop controls x of buttons
         {
            buttons[num] = ct.rect( x, y, 15, 10, "grey");
            buttons[num].clickable = true;
            ct.text( ct.formatInt(num) , x, y, 10, "black" );
            num++;
         }
      }
     
   }
   
   public void update()
   { 
             
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
  
      if(obj instanceof GameRect)
      {  
         int i;
         for(i = 0; i < buttons.length; i++ )
         {
            if(obj == buttons[i])
            {
               break;  
            }
         }  
         ct.print(i);
      }
   }
   
}
