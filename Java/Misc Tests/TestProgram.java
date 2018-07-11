import Code12.*;

class TestProgram extends Code12Program
{

   public static void main(String[] args)
   { 
      Code12.run(new TestProgram()); 
   }
   
   public void start()
   {
		double x = 3.14e;      // Invalid exponential notation
		double x = 3.141e+;    // Invalid exponential notation
		double x = 3.1415e-;   // Invalid exponential notation
		double x = 3.14159e+exponent; // Invalid exponential notation
		double x = 3.141592ee0; // Invalid exponential notation
		double x = 3.141592EE0; // Invalid exponential notation
		double x = 3e; // Invalid exponential notation
		double x = .3E; // Invalid exponential notation
	}
   
   public void update()
   {
   }
   
}