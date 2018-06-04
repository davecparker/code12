// Zelda
// Case use for ct.getScreen() and ct.setScreen()

import Code12.*;

class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   GameObj link;
   double linkWidth;
   double wallWidth;
   double linkSpeed;
   
   public void start()
   {  
      ct.setHeight( 150 );
      double width = ct.getWidth();
      double height = ct.getHeight();
      
      linkWidth = 10;
      wallWidth = 5;
      linkSpeed = 1;
      double doorSize = 20;
      double treasureWidth = 10;
      
      String wallColor = "light gray";
      String roomColor, doorColor;
      GameObj leftWall, rightWall, topWall, bottomWall;
      GameObj wall, door, treasure;
      
      // Make green room --------------------------------------------------------------------------------
      roomColor = "green";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, height / 2, wallWidth, height, wallColor );
      rightWall = ct.rect( width - wallWidth / 2, height / 2, wallWidth, height, wallColor );
      topWall = ct.rect( width / 2, wallWidth / 2, width, wallWidth, wallColor );
      bottomWall = ct.rect( width / 2 , height - wallWidth / 2, width, wallWidth, wallColor );
      
      // Make doors
      // orange door on top wall
      doorColor = "orange";
      wall = topWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // blue door on right wall
      doorColor = "blue";
      wall = rightWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // yellow door on bottom wall
      doorColor = "yellow";
      wall = bottomWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // red door on left wall
      doorColor = "red";
      wall = leftWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", width / 2, height / 2, treasureWidth );
      treasure.group = "treasure";
      
      // Make orange room --------------------------------------------------------------------------------
      roomColor = "orange";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, height / 2, wallWidth, height, wallColor );
      rightWall = ct.rect( width - wallWidth / 2, height / 2, wallWidth, height, wallColor );
      topWall = ct.rect( width / 2, wallWidth / 2, width, wallWidth, wallColor );
      bottomWall = ct.rect( width / 2 , height - wallWidth / 2, width, wallWidth, wallColor );
      
      // Make doors     
      // green door on bottom wall
      doorColor = "green";
      wall = bottomWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", width / 2, height / 2, treasureWidth );
      treasure.group = "treasure";
      
      // Make blue room --------------------------------------------------------------------------------
      roomColor = "blue";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, height / 2, wallWidth, height, wallColor );
      rightWall = ct.rect( width - wallWidth / 2, height / 2, wallWidth, height, wallColor );
      topWall = ct.rect( width / 2, wallWidth / 2, width, wallWidth, wallColor );
      bottomWall = ct.rect( width / 2 , height - wallWidth / 2, width, wallWidth, wallColor );
      
      // Make doors
      // green door on left wall
      doorColor = "green";
      wall = leftWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", width / 2, height / 2, treasureWidth );
      treasure.group = "treasure";
      
      // Make yellow room --------------------------------------------------------------------------------
      roomColor = "yellow";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, height / 2, wallWidth, height, wallColor );
      rightWall = ct.rect( width - wallWidth / 2, height / 2, wallWidth, height, wallColor );
      topWall = ct.rect( width / 2, wallWidth / 2, width, wallWidth, wallColor );
      bottomWall = ct.rect( width / 2 , height - wallWidth / 2, width, wallWidth, wallColor );
      
      // Make doors
      // green door on top wall
      doorColor = "green";
      wall = topWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", width / 2, height / 2, treasureWidth );
      treasure.group = "treasure";
            
      // Make red room --------------------------------------------------------------------------------
      roomColor = "red";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, height / 2, wallWidth, height, wallColor );
      rightWall = ct.rect( width - wallWidth / 2, height / 2, wallWidth, height, wallColor );
      topWall = ct.rect( width / 2, wallWidth / 2, width, wallWidth, wallColor );
      bottomWall = ct.rect( width / 2 , height - wallWidth / 2, width, wallWidth, wallColor );
      
      // Make doors
      // green door on right wall
      doorColor = "green";
      wall = rightWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "doors";
      door.setText( doorColor );
      
      // Make Link
      link = ct.image( "link.png", width / 2, height / 2, linkWidth );
      
   }
   
   public void update()
   {        
   }
   
   public void onKeyPress( String keyName )
   {
      if ( keyName.equals( "g" ) )
      {
         ct.setScreen( "green" );
      }
      else if ( keyName.equals( "o" ) )
      {
         ct.setScreen( "orange" );
      }
      else if ( keyName.equals( "b" ) )
      {
         ct.setScreen( "blue" );
      }
      else if ( keyName.equals( "y" ) )
      {
         ct.setScreen( "yellow" );
      }
      else if ( keyName.equals( "r" ) )
      {
         ct.setScreen( "red" );
      }
      
      if ( keyName.equals( "up" ) )
      {
         link.xSpeed = 0;
         link.ySpeed = -linkSpeed;
      }
      else if ( keyName.equals( "down" ) )
      {
         link.xSpeed = 0;
         link.ySpeed = linkSpeed;
      }
      else if ( keyName.equals( "left" ) )
      {
         link.xSpeed = -linkSpeed;
         link.ySpeed = 0;
      }
      else if ( keyName.equals( "right" ) )
      {
         link.xSpeed = linkSpeed;
         link.ySpeed = 0;
      }
   }
   
   public void onKeyRelease( String keyName )
   {
      if ( keyName.equals("up") || keyName.equals("down") || keyName.equals("left") || keyName.equals("right") )
      {
         link.xSpeed = 0;
         link.ySpeed = 0;      
      }
   }
}
