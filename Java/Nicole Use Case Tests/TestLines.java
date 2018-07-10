import Code12.*;

class TestLines extends Code12Program
{
   GameObj line0;
   GameObj line1;
   GameObj line2;

   public static void main(String[] args)
   { 
      Code12.run(new TestLines()); 
   }
   
   public void start()
   {
      line0 = ct.line(50,50,60,50,"red");
      line0.lineWidth = 5;
      line1 = ct.line(60,50,70,50,"green");
      line1.lineWidth = 5;
      line2 = ct.line(70,50,80,50,"blue");
      line2.lineWidth = 5;
   }
   
   public void update()
   {
   }
   
}