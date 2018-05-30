import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   GameObj koopa; // koopa-troopa image
   int numberOfLevels = 8; // how many blocks high the staircase is
   double tileSize = 100 / 16;
   double yGround = 100 - tileSize * 2;
   boolean paused = true;
   
   public void start()
   {      
      // Make the background
      ct.setBackColorRGB( 104, 136, 255 );
      ct.image( "cloud.png", 25, 25, 19 );
      
      // Make the staircase
      for (int level = 0; level < numberOfLevels; level++)
      {
         for (int i = 0; i < numberOfLevels + 1 - level; i++)
         {
            GameObj block = ct.image( "block.png", 100 - i * tileSize, yGround - level * tileSize,  tileSize );
            block.align( "bottom right" );
         }
      }
      
      // Make the ground
      int numberOfTiles = ct.toInt(100 / tileSize) + 1;
      for (int i = 0; i < numberOfTiles; i++)
      {
         for ( int j = 0; j < 2; j++ )
         {
            GameObj block = ct.image( "ground-tile.png", 100 - i * tileSize, 100 - j * tileSize, tileSize );
            block.align( "bottom right" );
         }
      }
      
      // Make the koopa troopa
      double yStart = yGround - tileSize * numberOfLevels;
      koopa = ct.image( "koopa.png", 100, yStart, tileSize );
      koopa.align( "bottom right" );
   }
   
   public void update()
   {
      if ( !paused )
      {
         if ( koopa.x < 0 )
         {
            // Reset koopa to top of staircase
            koopa.y = yGround - tileSize * numberOfLevels;
            koopa.x = 100 + koopa.width;
         }
         else if ( koopaFalling() )
         {
            koopa.y = koopa.y + 1;
            koopa.x -= 0.1;
            ct.println("falling");
         }
         else
         {
            koopa.x = koopa.x - 0.2;
            ct.println("not falling");
         }
      }
   }
   
   public boolean koopaFalling()
   {
      return koopa.y < ySteps( koopa.x );
   }
   
   public double ySteps( double x )
   {
      for ( int i = 0; i <= numberOfLevels; i++)
      if ( x >= 100 - tileSize * (2 + i) )
         return yGround - tileSize * ( numberOfLevels - i );
         
      return yGround;
   }
   
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals("space") )
         paused = !paused;
   }
}


