import Code12.*;

class MainProgram extends Code12Program
{
   int frameCount;
   GameObj image;
   
   public void start()
   {  
      frameCount = 1;
      double pixelsPerUnit = ct.getPixelsPerUnit();
      double width = 225 / pixelsPerUnit;
      double height = 224 / pixelsPerUnit;
      
      image = ct.image( "background.png", width, height, 100 );
      image.setXSpeed( 1 );
   }
   
   public void update()
   {  
      frameCount++;
      if ( image.getWidth() > 10 && frameCount % 10 == 1)
      {
         image.setSize( image.getWidth() - 1, image.getHeight() - 1 );
      }
      if (image.x > 100)
      {
         image.x = 0;
      }
   }

   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
}
