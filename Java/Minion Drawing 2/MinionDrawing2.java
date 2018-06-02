// Minion Drawing 2
// Code12 Programming Concepts 2: Comments

// Draws a minion using rectangles, circles, and lines.

import Code12.*;

public class MinionDrawing2 extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MinionDrawing2()); 
   }
   
   public void start()
   {       
      // Draw legs
      ct.rect( 40, 85, 10, 10, "blue" ); // left leg
      ct.rect( 60, 85, 10, 10, "blue" ); // right leg
      ct.rect( 37.5, 92.5, 15, 5, "black" ); // left shoe
      ct.rect( 62.5, 92.5, 15, 5, "black" ); // left shoe
      
      // Draw head and body
      ct.circle( 50, 25, 50, "yellow" ); // forehead
      ct.circle( 50, 60, 50, "blue" ); // overall bottoms
      ct.rect( 50, 42.5, 50, 45, "yellow" ); // face + body
      ct.circle( 50, 32, 22, "black" ); // mouth circle
      ct.rect( 50, 28, 50, 16, "yellow" ); // mouth overlay to make semicircle
      ct.line( 25.2, 36, 74.8, 36, "yellow" ); // mouth overlay edge coverup
      ct.rect( 50, 55, 35, 20, "blue" ); // overall bib
      ct.rect( 50, 55, 20, 10, "blue" ); // overall pocket
      ct.rect( 27.5, 47.5, 10, 5, "blue" ); // overall left strap
      ct.rect( 72.5, 47.5, 10, 5, "blue" ); // overall right strap
      
      // Draw arms
      ct.rect( 22.5, 65, 5, 30, "yellow" ); // left arm
      ct.rect( 77.5, 65, 5, 30, "yellow" ); // right arm
      ct.rect( 22.5, 80, 7, 10, "black" ); // left hand
      ct.circle( 22.5, 85, 7, "black" ); // left middle finger
      ct.circle( 19, 82, 7, "black" ); // left outside finger
      ct.circle( 26, 82, 7, "black" ); // left inside finger
      ct.rect( 77.5, 80, 7, 10, "black" ); // right hand
      ct.circle( 77.5, 85, 7, "black" ); // right middle finger
      ct.circle( 74, 82, 7, "black" ); // right inside finger
      ct.circle( 81, 82, 7, "black" ); // right outside finger
      
      // Draw goggles
      ct.circle( 37.5, 20, 25, "gray" ); // left goggle
      ct.circle( 62.5, 20, 25, "gray" ); // right goggle 
      ct.rect( 76.25, 20, 2.5, 10, "gray" ); // right strap anchor
      ct.rect( 23.75, 20, 2.5, 10, "gray" ); // left strap anchor
      
      // Draw eyes
      ct.circle( 37.5, 20, 20, "white" ); // left eye
      ct.circle( 62.5, 20, 20, "white" ); // right eye
      ct.circle( 40, 20, 8, "green" ); // left iris
      ct.circle( 60, 20, 8, "green" ); // right iris
      ct.circle( 40, 20, 4, "black" ); // left pupil
      ct.circle( 60, 20, 4, "black" ); // right pupil
           
   }
   
   public void update()
   {        
   }
}
