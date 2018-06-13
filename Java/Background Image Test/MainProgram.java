import Code12.*;

class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   int frameCount;
   GameObj image;
   
   public void start()
   {  
      frameCount = 1;
      double pixelsPerUnit = ct.getPixelsPerUnit();
      double width = 225 / pixelsPerUnit;
      double height = 224 / pixelsPerUnit;
      
      image = ct.image( "background.png", width, height, 100 );
      image.xSpeed = 1;
   }
   
   public void update()
   {  
//       frameCount++;
//       if ( image.width > 10 && frameCount % 10 == 1)
//       {
//          image.width -= 1;
//          image.height -= 1;
//       }
         if (image.x > 100)
         {
            image.x = 0;
         }
   }
}
