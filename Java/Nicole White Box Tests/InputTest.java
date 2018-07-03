import Code12.*;

class InputTest extends Code12Program
{

   public static void main(String[] args)
   { 
      Code12.run(new InputTest()); 
   }
   
   public void start()
   {
      ct.inputString("Enter a string: ");
      String input = ct.inputString("Enter another string: ");
      ct.inputInt("Enter an integer: ");
      int i = ct.inputInt("Enter another integer" );
      ct.inputNumber("Enter a number: ");
      double d = ct.inputNumber("Enter any number: ");
      ct.inputBoolean("Enter a boolean value: ");
      boolean bool = ct.inputBoolean("Enter another boolean value " );
   }
   
}