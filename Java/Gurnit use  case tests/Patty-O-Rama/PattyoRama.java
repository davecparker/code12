import Code12.*;

public class PattyoRama extends Code12Program
{
GameObj krabbyPatty, roguePatty, pipe, play, playText, scoreText;
int score = 0;

   public static void main(String[] args)
   { 
      Code12.run(new PattyoRama()); 
   }
   
   public void start()
   {  
      ct.setTitle("PATTY-O-RAMA!");
      
      //win screen
      ct.setScreen("win");
      ct.setBackImage("krabs.png");
      GameObj winner = ct.text("Great job Matey!", 50, 10, 10, "red"); 
           
      //end screen
      ct.setScreen("end");
      ct.setBackColor("red");
      GameObj end = ct.text("Your Fired!!!!!", 50, 50 , 10, "black");          
           
      //Game scren
      ct.setScreen("game");
      ct.setBackImage("kitchen.jpg");
      pipe = ct.image("chute.png", 60, 1, 60);    
      scoreText = ct.text("Order completion: " + score + "/5 Krabby Patties", 40, 95, 5, "yellow" );      
      
       //Start screen
      ct.setScreen("start");
      ct.setBackImage("kk.jpg");
      play = ct.circle(75,15,30,"yellow");
      play.setLineColor("yellow");
      playText = ct.text("PLAY", 75, 15,10 , "black"); 
      GameObj directions = ct.text("Complete an order of 5 krabby patties,watch out for the spoiled ones!", 50, 96, 3.2, "white");    
   }
   
   public void update()
   {          
       play.clickable = true;      
        if(play.clicked())
           ct.setScreen("game");          
                     
        if (ct.getScreen().equals("game") && ct.random(1, 20) == 1)
        {   
           // random position for krabby patties
           int X = ct.random(40, 80);
           int Y = ct.random(35,45);
                      
           krabbyPatty = ct.image("krabbyPatty.png", X, Y, 20);
           krabbyPatty.clickable = true; 
           krabbyPatty.ySpeed = 0.7;                         
        }
        if (ct.getScreen() == "game" && ct.random(1, 30) == 1)
        {  
           // random position or rogue patties
           int x = ct.random(40, 80);
           int y = ct.random(40,45);
           
           roguePatty = ct.image("nastyPatty.png", x, y, 25);
           roguePatty.clickable = true; 
           roguePatty.ySpeed = 0.7;         
        }
        //checks if won              
        if(score == 5)
        {
           ct.setScreen("win");
        }  
        //checks if failed
        if(score <= -2)
        { 
           ct.sound("buzzer.wav");
           ct.setScreen("end");        
        }                        
     }                            
  
    public void onMousePress(GameObj obj, double x, double y)
   {
      //deletes whichever object gets clicked on 
      if ( obj != null && ct.getScreen() == "game")
      {
         obj.delete();
         
         if(obj == krabbyPatty)
         {
            score++;    
            scoreText.setText("Order Completion:  " + score + "/5 Krabby Patties");                 
         }
         if(obj == roguePatty)
         {            
            score--;          
            scoreText.setText((3 + score)+ " away from getting fired!!! " );  
         }      
      }          
   }   
}