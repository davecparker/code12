import Code12.*;

import java.util.ArrayList;
import java.util.Iterator;


import javafx.scene.input.KeyCode;
import javafx.scene.Node;
import javafx.geometry.Point2D;
import javafx.scene.shape.Rectangle;
import javafx.scene.paint.Color;
import javafx.scene.layout.Pane;

public class Platformer extends Code12Program
{
    private Pane appRoot = new Pane();
    private Pane gameRoot = new Pane();
    private Pane uiRoot = new Pane();
   
    public static final String[] LEVEL1 = new String[] 
    {
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000000000000000000000000000000",
        "000111000000000000000000000000",
        "000000001110000000000000000000",
        "000002000000011100002000000000",
        "000001110000000000011100011000",
        "111111110011110001111100111111"
    };
    
   //array of platforms, maybe switch to tileset
   ArrayList<GameObj> platforms = new ArrayList<GameObj>();
   
   GameObj player;
   GameObj background;
   
   Point2D playerVelocity = new Point2D(0,0);
   boolean canJump = true;
   
   int levelWidth;
   
   GameObj obj;
   
   public static void main(String[] args)
   { 
      Code12.run(new Platformer()); 
   }
   
   public void start()
   {
      ct.setHeight(100.0 * 9 / 16 );
      double width = ct.getWidth();
      double height = ct.getHeight();
      
      background = ct.rect( width / 2, height / 2, width, height ); 
      background.setFillColor("black");
      
      player = ct.image("blob.png", 0, 50, 10 );
      
      
      
      
       
   }
   
   public void update()
   {
      //initialize
      levelWidth = LEVEL1[0].length() * 60; //scaling
      
      for ( int i = 0; i < LEVEL1.length; i++ )
      {
         String line = LEVEL1[i];
         for ( int j = 0; j < line.length(); j++ )
         {
            switch ( line.charAt(j) )
            {
               case '0':
                  break;
               case '1':
                  GameObj platform = ct.rect(j*60,i*60,60,60);
                  platform.setFillColor("white");
                  platforms.add(platform);
                  break;
                  
                   
            }
         }
      }
      
      //scrolling, will be called whenever the player's x position has changed..need to work on this
      /*double x = player.x;
      
      x.addListener((obs, old, newValue) -> {          
            double offset = newValue.intValue();

            if (offset > 640 && offset < levelWidth - 640) {
                gameRoot.setLayoutX(-(offset - 640));
            }
        });

         appRoot.getChildren().addAll(background, gameRoot, uiRoot);   */    
   }
   
   public void onKeyPress( String key )
   {
      switch ( key )
      {
         case("right"):
            if ( player.x > ct.getWidth() )
               player.x = 0;
            player.x += 5;
            break;
         case("left"):
            player.x -= 5;
            break;
         case("up"):
            jumpPlayer();
      }
      
   }
   
   public void jumpPlayer()
   {
      if ( canJump )
      {
         playerVelocity = playerVelocity.add(0,-30);
      }
   }
   
  
   
}
