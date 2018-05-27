import Code12.*;

public class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   public void start()
   {
      // Make the background
      ct.setBackColorRGB( 104, 136, 255 );
      ct.image( "cloud.png", 25, 25, 19 );
      
      // Make the ground
      double tileSize = 100 / 16;
      int numberOfTiles = ct.toInt(100 / tileSize) + 1;
      for (int i = 0; i < numberOfTiles; i++)
      {
         for (int j = 0; j < 2; j++)
         {
            GameObj tile = ct.image( "ground-tile.png", 100 - i * tileSize, 100 - j * tileSize, tileSize );
            tile.align( "bottom right" );
         }
      }
      
      // Make the staircase
      double yStairsBottom = 100 - tileSize * 2;
      int numberOfLevels = 8;
      for (int level = 0; level < numberOfLevels; level++)
      {
         for (int i = 0; i < numberOfLevels + 1 - level; i++)
         {
            GameObj block = ct.image( "block.png", 100 - i * tileSize, yStairsBottom - level * tileSize,  tileSize );
            block.align( "bottom right" );
         }
      }
      
      // Make the koopa troopa
      double yStairsTop = yStairsBottom - tileSize * numberOfLevels;
      GameObj koopa = ct.image( "koopa.png", 100, yStairsTop, tileSize );
      koopa.align( "bottom right" ); 
   }
   
   public void update()
   {        
   }
}
