// Zelda
// Case use for ct.getScreen() and ct.setScreen()

import Code12.*;

class MainProgram extends Code12Program
{
   public static void main(String[] args)
   { 
      Code12.run(new MainProgram()); 
   }
   
   double screenWidth, screenHeight;
   GameObj link;
   double linkWidth;
   double wallWidth;
   double linkSpeed;
   double xMin;
   double xMax;
   double yMin;
   double yMax;
      
   GameObj[] greenObjs, orangeObjs, blueObjs, yellowObjs, redObjs;
   
   public void start()
   {  
      ct.setHeight( 150 );
      screenWidth = ct.getWidth();
      screenHeight = ct.getHeight();
      
      linkWidth = 10;
      wallWidth = 5;
      linkSpeed = 1;
      double doorSize = 20;
      double treasureWidth = 10;
      
      String wallColor = "light gray";
      String roomColor, doorColor;
      GameObj leftWall, rightWall, topWall, bottomWall;
      GameObj wall, door, treasure;
      int objsCount;
      
      // Make green room --------------------------------------------------------------------------------
      roomColor = "green";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      rightWall = ct.rect( screenWidth - wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      topWall = ct.rect( screenWidth / 2, wallWidth / 2, screenWidth, wallWidth, wallColor );
      bottomWall = ct.rect( screenWidth / 2 , screenHeight - wallWidth / 2, screenWidth, wallWidth, wallColor );
      
      // Initialize greenObjs
      greenObjs = new GameObj[5]; // 4 doors + 1 treasure
      objsCount = 0;
      
      // Make doors
      // orange door on top wall
      doorColor = "orange";
      wall = topWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      greenObjs[ objsCount ] = door;
      objsCount++;
      
      // blue door on right wall
      doorColor = "blue";
      wall = rightWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      greenObjs[ objsCount ] = door;
      objsCount++;
      
      // yellow door on bottom wall
      doorColor = "yellow";
      wall = bottomWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      greenObjs[ objsCount ] = door;
      objsCount++;
      
      // red door on left wall
      doorColor = "red";
      wall = leftWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      greenObjs[ objsCount ] = door;
      objsCount++;
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", screenWidth / 2, screenHeight / 2, treasureWidth );
      treasure.group = "treasure";
      treasure.setText( roomColor );
      greenObjs[ objsCount ] = treasure;
      objsCount++;
      
      // Make orange room --------------------------------------------------------------------------------
      roomColor = "orange";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      rightWall = ct.rect( screenWidth - wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      topWall = ct.rect( screenWidth / 2, wallWidth / 2, screenWidth, wallWidth, wallColor );
      bottomWall = ct.rect( screenWidth / 2 , screenHeight - wallWidth / 2, screenWidth, wallWidth, wallColor );
      
      // Initialize orangeObjs[]
      orangeObjs = new GameObj[2]; // 1 door + 1 treasure
      objsCount = 0;
      
      // Make doors     
      // green door on bottom wall
      doorColor = "green";
      wall = bottomWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      orangeObjs[ objsCount ] = door;
      objsCount++;
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", screenWidth / 2, screenHeight / 2, treasureWidth );
      treasure.group = "treasure";
      treasure.setText( roomColor );
      orangeObjs[ objsCount ] = treasure;
      objsCount++;
      
      // Make blue room --------------------------------------------------------------------------------
      roomColor = "blue";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      rightWall = ct.rect( screenWidth - wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      topWall = ct.rect( screenWidth / 2, wallWidth / 2, screenWidth, wallWidth, wallColor );
      bottomWall = ct.rect( screenWidth / 2 , screenHeight - wallWidth / 2, screenWidth, wallWidth, wallColor );
      
      // Initialize blueObjs[]
      blueObjs = new GameObj[2]; // 1 door + 1 treasure
      objsCount = 0;
      
      // Make doors
      // green door on left wall
      doorColor = "green";
      wall = leftWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      blueObjs[ objsCount ] = door;
      objsCount++;
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", screenWidth / 2, screenHeight / 2, treasureWidth );
      treasure.group = "treasure";
      treasure.setText( roomColor );
      blueObjs[ objsCount ] = treasure;
      objsCount++;
      
      // Make yellow room --------------------------------------------------------------------------------
      roomColor = "yellow";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      rightWall = ct.rect( screenWidth - wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      topWall = ct.rect( screenWidth / 2, wallWidth / 2, screenWidth, wallWidth, wallColor );
      bottomWall = ct.rect( screenWidth / 2 , screenHeight - wallWidth / 2, screenWidth, wallWidth, wallColor );
      
      // Initialize yellowObjs[]
      yellowObjs = new GameObj[2]; // 1 door + 1 treasure
      objsCount = 0;
      
      // Make doors
      // green door on top wall
      doorColor = "green";
      wall = topWall;
      door = ct.rect( wall.x, wall.y, doorSize, wallWidth, doorColor );
      door.group = "door";
      door.setText( doorColor );
      yellowObjs[ objsCount ] = door;
      objsCount++;
      
      // Make treasure in center of room
      treasure = ct.image( "treasure.png", screenWidth / 2, screenHeight / 2, treasureWidth );
      treasure.group = "treasure";
      treasure.setText( roomColor );
      yellowObjs[ objsCount ] = treasure;
      objsCount++;
            
      // Make red room --------------------------------------------------------------------------------
      roomColor = "red";
      ct.setScreen( roomColor );
      ct.setBackColor( roomColor );
      
      // Make walls
      leftWall = ct.rect( wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      rightWall = ct.rect( screenWidth - wallWidth / 2, screenHeight / 2, wallWidth, screenHeight, wallColor );
      topWall = ct.rect( screenWidth / 2, wallWidth / 2, screenWidth, wallWidth, wallColor );
      bottomWall = ct.rect( screenWidth / 2 , screenHeight - wallWidth / 2, screenWidth, wallWidth, wallColor );
      
      // Initialize redObjs[]
      redObjs = new GameObj[1]; // 1 door
      objsCount = 0;
      
      // Make doors
      // green door on right wall
      doorColor = "green";
      wall = rightWall;
      door = ct.rect( wall.x, wall.y, wallWidth, doorSize, doorColor );
      door.group = "door";
      door.setText( doorColor );
      redObjs[ objsCount ] = door;
      objsCount++;
      
      // Make Link
      link = ct.image( "link.png", screenWidth / 2, screenHeight / 2, linkWidth );
      
      // Set bounds for Link's x and y values
      xMin = link.width/2 + wallWidth;
      xMax = screenWidth - (link.width/2 + wallWidth);
      yMin = link.height/2 + wallWidth;
      yMax = screenHeight - (link.height/2 + wallWidth);
   }
   
   public void update()
   {  
      String screenName = ct.getScreen();
      GameObj[] screenObjs;
      
      if ( screenName.equals( "green" ) )
      {
         screenObjs = greenObjs;
      }
      else if ( screenName.equals( "orange" ) )
      {
         screenObjs = orangeObjs;
      }
      else if ( screenName.equals( "blue" ) )
      {
         screenObjs = blueObjs;
      }
      else if ( screenName.equals( "yellow" ) )
      {
         screenObjs = yellowObjs;
      }
      else // ( screen.equals( "red" ) )
      {
         screenObjs = redObjs;
      }
      
      int numObjs = screenObjs.length;
      boolean noHits = true;
      
      for ( int i = 0; i < numObjs && noHits; i++ )
      {
         GameObj obj = screenObjs[i];
         if ( obj.visible && link.hit( obj ) )
         {
            noHits = false;
            String group = obj.group;
            String objText = obj.getText();
            ct.println( objText + " " + group + " hit" );
            
            if ( group.equals("treasure") )
            {
                  obj.visible = false;
            }
            else if ( group.equals("door") )
            {               
               // Save Link's data and delete him
               double xSpeed = link.xSpeed;
               double ySpeed = link.ySpeed;
               double x = link.x;
               double y = link.y;
               link.delete();
               
               // Go to screen door leads to
               ct.setScreen( objText );
               
               // Make a new Link
               link = ct.image( "link.png", screenWidth / 2, screenHeight / 2, linkWidth );
               
               // Put link in the appropriate spot
               if ( xSpeed > 0 )
               {
                  // went through a right door, set him at left side of new screen
                  link.x = xMin;
                  link.y = y;
                  link.xSpeed = xSpeed;
               }
               else if ( xSpeed < 0 )
               {
                  // went through a left door, set him at the right side of new screen
                  link.x = xMax;
                  link.y = y;
                  link.xSpeed = xSpeed;
               }
               else if ( ySpeed > 0 )
               {
                  // went through a top door, set him at bottom of new screen
                  link.y = yMin;
                  link.x = x;
                  link.ySpeed = ySpeed;
               }
               else if ( ySpeed < 0 )
               {
                  // went through a bottom door, set him at top of new screen
                  link.y = yMax;
                  link.x = x;
                  link.ySpeed = ySpeed;
               }
            }
         }
      }
      if ( noHits )
      {                 
         if ( link.x < xMin )
         {
            link.x = xMin;
            link.xSpeed = 0;
         }
         else if ( link.x > xMax )
         {
            link.x = xMax;
            link.xSpeed = 0;
         }
         
         if ( link.y < yMin )
         {
            link.y = yMin;
            link.ySpeed = 0;
         }
         else if ( link.y > yMax )
         {
            link.y = yMax;
            link.ySpeed = 0;
         } 
      }
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
      
      if ( keyName.equals( "up" ) && link.y > yMin )
      {
         link.xSpeed = 0;
         link.ySpeed = -linkSpeed;
      }
      else if ( keyName.equals( "down" ) && link.y < yMax )
      {
         link.xSpeed = 0;
         link.ySpeed = linkSpeed;
      }
      else if ( keyName.equals( "left" ) && link.x > xMin )
      {
         link.xSpeed = -linkSpeed;
         link.ySpeed = 0;
      }
      else if ( keyName.equals( "right" ) && link.x < xMax )
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
