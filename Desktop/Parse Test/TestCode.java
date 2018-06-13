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