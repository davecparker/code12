import Code12.*;

class FroggerLevel5 extends Code12Program
{
   // Global variables
   double truckSpeed = 1;
   double carSpeed =  0.5;
   double startTime = 30;
   int initLives = 3;

   GameObj frog;

   public static void main(String[] args)
   { 
      Code12.run(new FroggerLevel5()); 
   }
   
   public void start()
   {
      // Initial setup
      ct.setTitle("Frogger");
      ct.setBackColor("black");
      ct.showAlert("Welcome to frogger!");

      double width = ct.getWidth();
      double halfWidth = width / 2;

      // Goal zone
      ct.rect(50,10,100,20,"dark green");

      // Timer
      ct.text("Time left: " + startTime, 10, 5, 4);

      // Life count
      ct.text("Life:", 80, 5, 4 );
      GameObj life1 = ct.image("fly.png", 87, 5, 5);
      GameObj life2 = ct.image("fly.png", 92, 5, 5);
      GameObj life3 = ct.image("fly.png", 97, 5, 5);

      // Road
      ct.rect(halfWidth,20,width,10,"black");
      ct.rect(halfWidth,20,width,10,"black");
      ct.rect(halfWidth,25,width,1,"white");
      ct.rect(halfWidth,30,width,10,"black");
      ct.rect(halfWidth,35,width,1,"white");
      ct.rect(halfWidth,40,width,10,"black");
      ct.rect(halfWidth,45,width,1,"white");
      ct.rect(halfWidth,50,width,10,"black");
      ct.rect(halfWidth,55,width,1,"white");
      ct.rect(halfWidth,60,width,10,"black");
      ct.rect(halfWidth,65,width,1,"white");
      ct.rect(halfWidth,70,width,10,"black");
      ct.rect(halfWidth,75,width,1,"white");
      ct.rect(halfWidth,80,width,10,"black");

      // Starting zone
      ct.rect(50,95,100,20,"dark green");

      // Frog image
      frog = ct.image("frog1.png", 50, 95, 6);

      // Vehicle images
      GameObj truck1 = ct.image("truck1.png", 70, 20, 20);
      GameObj truck2 = ct.image("truck2.png", 15, 50, 30);
      GameObj car1 = ct.image("car2.png", 20, 30, 15);
      GameObj car2 = ct.image("car1.png", 40, 40, 15);
      GameObj car3 = ct.image("car3.png", 80, 60, 15);
      GameObj car4 = ct.image("car1back.png", 20, 70, 15);
      GameObj car5 = ct.image("car2back.png", 55, 80, 15);

   }
   
}