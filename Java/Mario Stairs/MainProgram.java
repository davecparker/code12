import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   GameObj koopa; // koopa-troopa image
   int numberOfLevels = 8; // how many blocks high the staircase is
   GameObj[] contactBlocks = new GameObj[20]; // blocks the koopa can come into contact with
   int contactBlocksCount = 0;
   double tileSize = 100 / 16;
   int paused = false;
   
   public void start()
   {
      // Initialize contactBlocks
      contactBlocks = new GameObj[17];
      contactBlocksCount = 0;
      
      // Make the background
      ct.setBackColorRGB( 104, 136, 255 );
      ct.image( "cloud.png", 25, 25, 19 );
      
      // Make the staircase
      double yStairsBottom = 100 - tileSize * 2;
      for (int level = 0; level < numberOfLevels; level++)
      {
         for (int i = 0; i < numberOfLevels + 1 - level; i++)
         {
            GameObj block = ct.image( "block.png", 100 - i * tileSize, yStairsBottom - level * tileSize,  tileSize );
            block.align( "bottom right", true );
            if ( i == numberOfLevels - level || (level == numberOfLevels + 1 && i == 0) )
            {
               contactBlocks[contactBlocksCount] = block;
               contactBlocksCount++;
            }
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
            if ( j == 1 && i > numberOfLevels )
            {
               contactBlocks[contactBlocksCount] = block;
               contactBlocksCount++;
            }
         }
      }
      
      // Make the koopa troopa
      double yStart = yStairsBottom - tileSize * (numberOfLevels + 1);
      koopa = ct.image( "koopa.png", 100, yStart, tileSize );
      koopa.align( "bottom right" );
      koopa.autoDelete = true;
   }
   
   public void update()
   {
      boolean koopaFalling = true;      
      for ( int i = 0; i < contactBlocksCount; i++ )
      {
         GameObj block = contactBlocks[i];
         if ( koopa.hit(block) )
         {
            koopa.ySpeed = 0;
            koopa.y = block.y - tileSize;
            koopa.xSpeed = -0.2;
            koopaFalling = false;
            break;
         }
      }
      if ( koopaFalling )
      {
         koopa.ySpeed = 0.5;
         koopa.xSpeed = -0.1;
      }
   }
}
