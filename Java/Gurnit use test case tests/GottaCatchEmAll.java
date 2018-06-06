import Code12.*;

public class GottaCatchEmAll extends Code12Program
{
GameObj pokeball, arena, eevee, charmander, charm, charizard, mewtwo, gastly, bar, powerBar, powerText, evolve, evolveText;
int count;
   public static void main(String[] args)
   { 
      Code12.run(new GottaCatchEmAll()); 
   }   
   public void start()
   {  
      // Game instructions 
      ct.setScreen("instructions");
      ct.setBackImage("arena.png");
      ct.text ("Instructions (Press i to go back) ", 50, 5, 5, "white");
      ct.line(5,8, 95, 8, "white");
      ct.text("Drag the pokeball to capture the pokemon. ", 50, 20, 5, "white");
      ct.text("Catch Mewtwo and power up 2X faster! ", 50, 25, 5, "white");
      ct.text("Once you power up then you can evolve charmander. ", 50, 30, 5, "white");
      ct.text("And watch out for Gastly or he'll drain your power. ", 50, 35, 5, "white");
      ct.text("", 50, 40, 5, "white");
      
      //evolve screen
      ct.setScreen("evolve");
      ct.setBackImage("arena.png");          
      evolve = ct.rect(50, 50,50,30, "pink");
      evolve.clickable = true;
      evolveText = ct.text("EVOLVE!", 50, 50, 10, "white");  
                 
      //game screen
      ct.setScreen("start");
      ct.setBackImage("arena.png");
      ct.text("Press i for instructions", 85,90, 3,"white");
      pokeball = ct.image("pokeball.png", 10, 50, 40);       
      charmander = ct.image("char.png", 95, 10, 15);
      charmander.xSpeed = -2;             
      eevee = ct.image("eevee.png", 95, 60,15);
      eevee.xSpeed = -1;
      mewtwo = ct.image("mewtwo.png", 95, 70, 15);
      mewtwo.xSpeed = -1;
      gastly = ct.image("gastly.png", 95, 90, 20); 
      gastly.xSpeed = -2;      
      
      //power up bar
      bar = ct.rect(80,20,30,2,"white");      
      powerBar = ct.rect(65, 20, .1, 2,"green");
      powerBar.align("left");      
      powerText = ct.text("POWER UP", 85, 15, 5, "black");       
   }   
   public void update()
   {   //brings pokemon back on screen       
       if(charmander.x < 10)
       {
          charmander.visible= true;
          charmander.x = 100;
          charmander.y = ct.random(20,95);
          charmander.ySpeed = ct.random(-1, 0);
       }         
       if(eevee.x < 10)
       {
          eevee.visible = true;
          eevee.x = 100;
          eevee.y = ct.random(20, 95);
          eevee.ySpeed = ct.random(-1,0);
       }   
        if(mewtwo.x < 10)
       {
          mewtwo.visible = true;
          mewtwo.x = ct.random(95, 100);
          mewtwo.y = ct.random(30, 95);
          mewtwo.ySpeed = ct.random(-3,-2);
       }    
       if(gastly.x < 10)
       {
          gastly.visible = true;
          gastly.x = 135;
          gastly.y = ct.random(20, 95);
          gastly.xSpeed = ct.random(-3,-2);
       }  
       // "catching" the pokemon 
       if(pokeball.hit(charmander) && powerBar.width <= 30  )       
       {     
         System.out.println("charmander");
         charmander.visible = false;
         powerBar.width += 0.1;         
       }         
       if(pokeball.hit(eevee) && powerBar.width <= 30 )  
       {          
         System.out.println("eevee");
         eevee.visible = false;
         powerBar.width += 0.1;
       }
       if(pokeball.hit(mewtwo)  && powerBar.width <= 30 )  
       {          
         System.out.println("eevee");
         mewtwo.visible = false;
         powerBar.width += .5;
       } 
      // hitting gastly        
      if(pokeball.hit(gastly))
      {      
         powerBar.width -= .5;
         System.out.println("gastly");
      }
       //switches screen to show instructions
       if(ct.charTyped("i"))
       {
         ct.setScreen("instructions");
         count++;
       }
       //press i again to switch back to game screen       
       if(ct.charTyped("i") && count % 2== 0)
         ct.setScreen("start");
       //evolve when fully powered up
       if(powerBar.width >=30 )
       {
         ct.setScreen("evolve");
       }
       if(evolve.clicked())
       {
         evolve.visible = false;
         evolveText.visible = false;
         charm = ct.image("char.png", 50,50,50);  
         charm.xSpeed = -3;
         if(charm.x <= 10)
            charizard = ct.image("charizard.png", 50, 50, 20);
       }             
//        if(ct.random(1, 200) == 1)
//        {
//          double x = ct.random(90, 100);
//          double y = ct.random(1,100);
//          charmander = ct.image("char.png", x, y, 15); 
//          charmander.xSpeed = -0.5;                  
//        }
         //random attack by Gastly
//        if(ct.random(1, 100) == 1 && ct.getScreen().equals("start"))
//        {        
//          double x = ct.random(90, 100);
//          double y = ct.random(1,100);
//          gastly = ct.image("gastly.png", x, y, 20); 
//          gastly.xSpeed = -1;
//        }
//        if(pokeball.hit(gastly))
//        {
//          powerBar.width -= 1;
//        }
//        if((pokeball.hit(charmander))
//          System.out.println("test");
     }     
      public void onMouseDrag( GameObj obj, double x, double y )
   {
      pokeball.x = x;
      pokeball.y = y;
   }

}