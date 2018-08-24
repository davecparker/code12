import Code12.*;

class FroggerLevel8 extends Code12Program
{
   // Global variables
   double frogSpeed = 0.25;
   double truckSpeed = 0.80;
   double carSpeed =  0.5;
   double startTime = 30;
   int initLives = 3;

   // Groups
   String trucks = "trucks";
   String cars = "cars";
   String lives = "lives";

   GameObj frog;
   GameObj deadFrog;
   GameObj truck1;
   GameObj truck2;
   GameObj car1;
   GameObj car2;
   GameObj car3;
   GameObj car4;
   GameObj car5;
   GameObj life1;
   GameObj life2;
   GameObj life3;

   int countLives = 0;
   boolean hitSomething;

   public static void main(String[] args)
   { 
      Code12.run(new FroggerLevel8()); 
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
      life1 = ct.image("fly.png", 87, 5, 5);
      life2 = ct.image("fly.png", 92, 5, 5);
      life3 = ct.image("fly.png", 97, 5, 5);
      life1.group = lives;
      life2.group = lives;
      life3.group = lives;

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
      truck1.group = trucks;
      truck2.group = trucks;
      car1 = ct.image("car2.png", 20, 30, 15);
      car2 = ct.image("car1.png", 40, 40, 15);
      car3 = ct.image("car3.png", 80, 60, 15);
      car4 = ct.image("car1back.png", 20, 70, 15);
      car5 = ct.image("car2back.png", 55, 80, 15);
      car1.group = cars;
      car2.group = cars;
      car3.group = cars;
      car4.group = cars;
      car5.group = cars;

      truck1.xSpeed = truckSpeed;
      truck2.xSpeed = truckSpeed;
      car1.xSpeed = carSpeed;
      car2.xSpeed = carSpeed;
      car3.xSpeed = carSpeed;
      car4.xSpeed = carSpeed;
      car5.xSpeed = carSpeed;

   }

   public void update()
   {
      double width = ct.getWidth();


      // If the vehicles go offscreen, set them to the leftmost x-coordinate, 0
      if ( truck1.x > width + 2 )
         truck1.x = 0;
      if ( truck2.x > width )
         truck2.x = 0;
      if ( car1.x > width )
         car1.x = 0;
      if ( car2.x > width )
         car2.x = 0;
      if ( car3.x > width )
         car3.x = 0;
      if ( car4.x > width )
         car4.x = 0;
      if( car5.x > width )
         car5.x = 0;


      // Control the frog
      if ( ct.keyPressed("up"))
      {
         frog.y -= frogSpeed;
      }


      if ( ct.keyPressed("down"))
      {
         frog.y += frogSpeed;
      }

      if ( ct.keyPressed("left"))
      {
         frog.x -= frogSpeed;
      }

      if ( ct.keyPressed("right"))
      {
         frog.x += frogSpeed;
      }

      // Using the group method to detect if frog hit a truck (in the truck group)

      if ( frog.objectHitInGroup(trucks) == truck1 || frog.objectHitInGroup(trucks) == truck2 && frog.visible == true )
      {
         frog.visible = false;
         deadFrog = ct.image("dead.png", frog.x, frog.y, frog.width);
         countLives += 1;
         hitSomething = true;
      }

      // Using the default hit method to detect if frog hit a car
      if ( frog.hit(car1) == true || frog.hit(car2) == true || frog.hit(car3) == true || frog.hit(car4) == true || frog.hit(car5) == true )
      {
         frog.visible = false;
         deadFrog = ct.image("dead.png", frog.x, frog.y, frog.width);
         countLives += 1;
         hitSomething = true;

      }

      // Leave a skull at the place the frog hit a car/truck
      if ( hitSomething == true )
      {
         frog.x = 50;
         frog.y = 95;
         frog.visible = true;
         hitSomething = false;
      }

      if ( countLives == 1 )
         life3.visible = false;
      else if ( countLives == 2 )
         life2.visible = false;
      else if ( countLives == 3 )
         life1.visible = false;


      if ( countLives == 3 )
      {
         frog.visible = false;
         ct.text("Game Over", 50, 50, 10,"red");
      }

   }
   
}