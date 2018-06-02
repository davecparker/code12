import Code12.*;

class MainProgram extends Code12Program
{
GameObj blockRect, rect1, rect2, rect3, circle, blueRect, redRect, pinkRect, deathBlock,slider1, slider2, bar, healthBar, barText, slenderman, checkpoint;
double width, height;

   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()   
  {    
      width = ct.getWidth();
      height = ct.getHeight();  

           
      //winner screen
      ct.setScreen("win");
      ct.setBackImage("winner.jpg");
      ct.text("you win..", 50, 90, 10, "red");
      
       //Game over screen
      ct.setScreen("end");
      ct.setBackColor("black");
      ct.text("GAME OVER", 50, 50, 10, "red");

      
      //start screen
      ct.setScreen("start"); 
      
      //health bar
      bar = ct.rect(80,10,30,2,"white");      
      healthBar = ct.rect(65,10,30,2,"green");
      healthBar.align("left");      
      barText = ct.text("HEALTH", 87, 5, 5, "black");
      
      //obby course    
      rect1 = ct.rect(width/10, height/10*6, 12, 60, "black");
      rect2 = ct.rect(width/3, height/8 , 43, 10, "black");     
      rect3 = ct.rect(width/2, height/10 *5, 9.5, 70, "black");       
      slider1 = ct.rect(width/3, height/2.8, 10, 1, "black");
      slider2 = ct.rect(width/3, height/1.8,10, 1, "black");
      deathBlock = ct.rect(width/10 * 8, height/10*6, 50, 40,"white"); //can't touch this or you die
      deathBlock.setLineColor("white");
      deathBlock.setLayer(0);
      
      blueRect = ct.rect(width/2 * 1.5, height/10*5, 10, 10, "blue");
      redRect = ct.rect(width/2 * 1.5,height/10 *6, 10, 10, "red");
      pinkRect = ct.rect(width/2 *1.5, height/10*7, 10, 10, "pink");
      blueRect.setLineColor( "blue");
      redRect.setLineColor( "red");
      pinkRect.setLineColor("pink"); 
   
      
      slider1.xSpeed = -1;
      slider2.xSpeed = 1;
      blueRect.xSpeed = 1;
      redRect.xSpeed = -1;
      pinkRect.xSpeed = 1;
      
      //player
      slenderman = ct.image("slender.png", width/15, height/10, 10);
      //checkpoint
      checkpoint = ct.image("flag.png", width/10*8, height/10 *2, 20);    
   }
   
   public void update()
   {  
      // moving slenderman   
       if(ct.keyPressed("up"))
       {
         slenderman.y -= 1;
       }
       if(ct.keyPressed("down"))
       {
          slenderman.y += 1;
       }
       if(ct.keyPressed("right"))
       {
         slenderman.x += 1;
       }   
        if(ct.keyPressed("left"))
       {
          slenderman.x -= 1;
       }    

      // moving blue, pink, and red tiles
       if(blueRect.x < 65)
      {
         blueRect.xSpeed = 1;
      }
      else if(blueRect.x > 95)
      {
         blueRect.xSpeed = -1;
      }
      
       if(pinkRect.x < 70)
      {
         pinkRect.xSpeed = 1;
      }
      else if(pinkRect.x > 95)
      {
         pinkRect.xSpeed = -1;
      }

      if(redRect.x < 60)
      {
         redRect.xSpeed = 1;
      } 
      else if(redRect.x > 100)
      {
         redRect.xSpeed = -1;
      }


      //sliders moving back and forth
      if(slider1.hit(rect1) || slider1.hit(rect3))
      {
         slider1.xSpeed = -slider1.xSpeed;
      }
      if(slider2.hit(rect1) || slider2.hit(rect3))
      {
         slider2.xSpeed = -slider2.xSpeed;
      }
      
      //checks if slenderman hit any of the rectangles
      if(slenderman.hit(rect1) ||slenderman.hit(rect2) || slenderman.hit(rect3) || slenderman.hit(deathBlock) ||slenderman.hit(slider1)||slenderman.hit(slider2))
      {
         healthBar.width -= 0.3;  
         
         if(slenderman.hit(pinkRect) || slenderman.hit(blueRect) ||slenderman.hit(redRect))         
            healthBar.width = healthBar.width + 0.3;
            
            if(slenderman.hit(pinkRect))
               pinkRect.xSpeed =0;               
            else if (slenderman.hit(redRect))
               redRect.xSpeed =0;
            else if (slenderman.hit(blueRect))
               blueRect.xSpeed =0;
       }       
              
     if (slenderman.hit(checkpoint))
         ct.setScreen("win"); 
            
     if(healthBar.width == 0)
         ct.setScreen("end"); 

   
    }
}
