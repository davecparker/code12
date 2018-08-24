import Code12.*;

class FroggerLevel7 extends Code12Program
{
   // Global variables
   double truckSpeed = 1;
   double carSpeed =  0.5;
   double startTime = 30;
   int initLives = 3;

   GameObj frog;
   GameObj truck1;
   GameObj truck2;
   GameObj car1;
   GameObj car2;
   GameObj car3;
   GameObj car4;
   GameObj car5;

   public static void main(String[] args)
   { 
      Code12.run(new FroggerLevel7()); 
   }
   
   public void start()
   {
      // Initial setup
      ct.setTitle("Frogger");
      ct.setBackColor("black");
      ct.showAlert("Welcome to frogger!");

      double width = ct.getWidth();
      double halfWidth = width / 2;

      String t = "trucks";
      String c = "cars";
      String l = "lives";

      // Goal zone
      ct.rect(50,10,100,20,"dark green");

      // Timer
      ct.text("Time left: " + startTime, 10, 5, 4);

      // Life count
      ct.text("Life:", 80, 5, 4 );
      GameObj life1 = ct.image("fly.png", 87, 5, 5);
      GameObj life2 = ct.image("fly.png", 92, 5, 5);
      GameObj life3 = ct.image("fly.png", 97, 5, 5);
      life1.group = l;
      life2.group = l;
      life3.group = l;

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

      /* Frog default image + different positions. 
      To be used for realistic movement (going forwards/backwards) */
      frog = ct.image("frog1.png", 50, 95, 6);
      GameObj frogpos1 = ct.image("frogpos1.png", 50, 95, 6);
      frogpos1.visible = false;
      GameObj frogpos2 = ct.image("frogpos2.png", 50, 95, 6);
      frogpos2.visible = false;
      GameObj frogpos3 = ct.image("frogpos3.png", 50, 95, 6);
      frogpos3.visible = false;
      GameObj frogpos4 = ct.image("frogpos4.png", 50, 95, 6);
      frogpos4.visible = false;

      // Vehicle images
      truck1 = ct.image("truck1.png", 70, 20, 20);
      truck2 = ct.image("truck2.png", 15, 50, 30);
      truck1.group = t;
      truck2.group = t;
      car1 = ct.image("car2.png", 20, 30, 15);
      car2 = ct.image("car1.png", 40, 40, 15);
      car3 = ct.image("car3.png", 80, 60, 15);
      car4 = ct.image("car1back.png", 20, 70, 15);
      car5 = ct.image("car2back.png", 55, 80, 15);
      car1.group = c;
      car2.group = c;
      car3.group = c;
      car4.group = c;
      car5.group = c;

      truck1.xSpeed = truckSpeed;
      truck2.xSpeed = truckSpeed;
      car1.xSpeed = carSpeed;
      car2.xSpeed = carSpeed;
      car3.xSpeed = carSpeed;
      car4.xSpeed = carSpeed;
      car5.xSpeed = carSpeed;

      truck1.autoDelete = true;
      truck2.autoDelete = true;
      car1.autoDelete = true;
      car2.autoDelete = true;
      car3.autoDelete = true;
      car4.autoDelete = true;
      car5.autoDelete = true;


   }

   public void update()
   {
      frog.y -= 0.25;

   }
   
}