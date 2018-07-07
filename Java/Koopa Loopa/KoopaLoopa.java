// Koopa Loopa
// Code12 Programming Concepts 11: Loops

// An animation of a koopa troopa going down tower of blocks.
// Press the space bar to start/pause the animation.
// When the koopa troopa goes off the screen it should loop back
// to it's starting location.

import Code12.*;

public class KoopaLoopa extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new KoopaLoopa()); 
   }
   
   GameObj koopa; // koopa-troopa image
   int numberOfLevels = 8; // how many blocks high the staircase is
   double tileSize = 100.0 / 16;
   double yGround = 100 - tileSize * 2;
   boolean paused = false;
   
   public void start()
   {      
      // Make the title and background
      ct.setTitle( "Koopa Loopa" );
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
         else 
         {
            // Calculate the y-value of the step koopa should be on
            double yStep = yGround;
            for ( int i = 0; i <= numberOfLevels; i++)
            {
               if ( koopa.x >= 100 - tileSize * (2 + i) )
               {
                  yStep = yGround - tileSize * ( numberOfLevels - i );
                  break;
               }
            }
            // If koopa is above the step, make it fall
            if ( koopa.y < yStep )
            {
               koopa.y = koopa.y + 1;
               koopa.x -= 0.1;
            }
            // Else make it move to the left
            else
            {
               koopa.x = koopa.x - 0.2;
            }
         }
      }
   }
      
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals("space") ) // TODO: was if ( keyName.equals("space") )
         paused = !paused;
   }
}


