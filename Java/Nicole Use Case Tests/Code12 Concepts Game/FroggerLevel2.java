import Code12.*;

class FroggerLevel2 extends Code12Program
{

   public static void main(String[] args)
   { 
      Code12.run(new FroggerLevel2()); 
   }
   
   public void start()
   {
      // Initial setup
      ct.setTitle("Frogger");
      ct.setBackColor("black");
      ct.showAlert("Welcome to frogger!");

      // Goal zone
      ct.rect(50,10,100,20,"dark green");

      // Timer
      ct.text("Time left:", 10, 5, 4);

      // Life count
      ct.text("Life:", 80, 5, 4 );
      ct.image("fly.png", 87, 5, 5);
      ct.image("fly.png", 92, 5, 5);
      ct.image("fly.png", 97, 5, 5);

      // Road
      ct.rect(50,20,100,10,"black");
      ct.rect(50,25,100,1,"white");
      ct.rect(50,30,100,10,"black");
      ct.rect(50,35,100,1,"white");
      ct.rect(50,40,100,10,"black");
      ct.rect(50,45,100,1,"white");
      ct.rect(50,50,100,10,"black");
      ct.rect(50,55,100,1,"white");
      ct.rect(50,60,100,10,"black");
      ct.rect(50,65,100,1,"white");
      ct.rect(50,70,100,10,"black");
      ct.rect(50,75,100,1,"white");
      ct.rect(50,80,100,10,"black");

      // Starting zone
      ct.rect(50,95,100,20,"dark green");

      // Frog image
      ct.image("frog1.png", 50, 95, 6);

      // Vehicle images
      ct.image("truck1.png", 70, 20, 20);
      ct.image("car2.png", 20, 30, 15);
      ct.image("car1.png", 40, 40, 15);
      ct.image("truck2.png", 15, 50, 30);
      ct.image("car3.png", 80, 60, 15);
      ct.image("car1back.png", 20, 70, 15);
      ct.image("car2back.png", 55, 80, 15);

   }
   
}