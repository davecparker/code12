import Code12.*;

class TestRandom extends Code12Program
{
   GameObj topCircle;
   GameObj bottomCircle;
   GameObj image;
   
   public static void main(String[] args)
   { 
      Code12.run(new TestRandom()); 
   }
   
   public void start()
   {
      topCircle = ct.circle(50,50,10,"purple");
      // first pos of image
      image = ct.image("test.png", 50, 10, 30 );
   }
   
   public void update()
   {
      topCircle.setYSpeed( -1 );
      // Generate a random int from the value of the circle's y position to 100
      // circles y position starts off less than 100, but increases
      // drawing something at this position
      ct.print( ct.random ( (int)(topCircle.y), 100)  );
      // check to see if circle and image hit
      if ( topCircle.hit(image) )
      {
         image.delete();
         image = ct.image("test.png", ct.random(10,50), ct.random((int)(topCircle.y), 50), 30);
         
         //  What if top circle's y is greater than 50?
         topCircle.y = ct.getHeight();
      }
         
   }
   
}