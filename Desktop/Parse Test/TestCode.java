import Code12.*;

class BubblePop extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new BubblePop()); 
   }
   
   public void start()
   {
      // Make the background 
      ct.setHeight(150);
      ct.setBackImage("underwater.jpg"); 
   }
   
   public void update()
   {
      // Make bubbles at random times, positions, and sizes
      if (ct.random(1, 20) == 1)
      {
         double x = ct.random(0, 100);
         double y = ct.getHeight() + 25;
         double size = ct.random(5, 20);
         GameObj bubble = ct.image("bubble.png", 
                              x, y, 
                              size);
         bubble.ySpeed = -1; 
         bubble.clickable = true;
         GameObj bubbleCopy = bubble; // initialization of GameObj from another GameObj
         int z; // declaration without initialization - primitive type
         int x, y, z; // declaring multiple variables
         z = -1 + 2; // assigning value with int and unary minus
         z = 0.707; // assigning value with double
         z = .707; // no leading zero
         z = -.707; // negative with no leading zero
         double xyz = ( 2 * x + y - 3.14 ) / z + 1.414; // initialization with expression
         double z2 = z * 2.0; // initialization from another variable 
         // Strings
         String greeting; //  declaration without initialization - String type
         greeting = "hello"; // assigning value to a string
         String greeting2 = "hello there"; // declaration with initialization - String type
         String greeting3 = greeting1; // declaration with initialization from another variable's value
         String greeting4 = greeting1 + " " + "world"; // declaration with concatenation
         String greeting5 = greeting2.substring(0, 6); // declaration with String method
         // loops
         for (int i = 0; i < 10; i++)
         for (i = 0; i < 10; i = i + 2)
         for (int i = 0; i < 100 && 2 * i < 50; i = i * 2)
         for (int i = 100; i > 0; i--)
         for (int i = 10; i > 0; i = i - 2)
         for (int i = 0; i < len; i++)
         for (int i = 0; i < arr.length; i++)
         while (j < 100)
         do
         while (j < 100);
         while (j < foo && i != bar);
         // arrays
         int[] a;
         int[] a = new int[100];
         int[] a = new int[foo];
         int[] a = new int[b.length * 2];
         int[] a = {1, 2, 3};
         int[] a = { 1,
                     2,
                     3};
         int[] a = b;

      }
   }
   
   public void onMousePress(GameObj obj, double x, double y)
   {
      // Pop bubbles that get clicked
      if (obj != null)
      {
         obj.delete();
         ct.sound("pop.wav");
      }
   }
}

////////////////////////////////////////////////////////////////////
ERRORS

// Lexical errors
@               // invalid character
foo('a');       // char literals not supported
foo(" );        // unclosed string literal 
interface foo   // unsupported reserved word

// Syntax errors
x = 10          // missing ;
foo(x, );       // missing expr in exprList
x = a + ;       // missing expr after binary op
x = a + b * ;   // missing expr after higher precedence binary op
x = a * b + ;   // missing expr after lower precedence binary op
x = ();         // missing expr in parentheses
x = 10 + ! ;    // missing expr after unary op
x = obj.3;      // expected ID after .
if x == 3       // required next token in pattern doesn't match
x + 3;          // no matching pattern
foo(x,          // (incomplete line continued below)
y)              // missing ;

// Unsupported Java syntax
int x = 1, y = 2, z = 3; // declaring and initializing
