import Code12.*;

class level10 extends Code12Program
{
   //Global variables
      boolean startPhase = false;
      boolean mainPhase = true;
      boolean endPhase = false;
      int updates = 0;
      double screenWidth;
      double screenHeight;
      //Player character
      GameObj ghostBird;
      GameObj bird;
      String flap = "downflap";
      String filename;
      final int BIRDHIEGHT = 10;
      double birdX;
      double birdY;
      boolean movingUp = true;
      //Score
      GameObj scoreObj;
      double scoreX;
      double scoreY;
      int score;
      int scoreHeight = 5;
      int highScore = 0;
      String scoreImgFile = "0.png";
      //Background
      GameObj back1;
      GameObj back2;
      //Ground
      GameObj ground1;
      GameObj ground2;
      GameObj ground3;
      //Pipes
      GameObj goal1;
      GameObj goal2;
      int randY;
      boolean hit1 = false;
      boolean hit2 = false;
      int goalY;
      GameObj pipeUp1;
      GameObj pipeDown1;
      GameObj pipeUp2;
      GameObj pipeDown2;
      //End Screen
      GameObj gameOverImg;
      GameObj endScoreText;
      GameObj endScoreImg;
      GameObj endBestText;
      GameObj endBestImg;
      GameObj restartText;
      GameObj restartBox;

   public static void main(String[] args)
   { 
      Code12.run( new level10() ); 
   }
   
   public void start()
   {  
      //sets the height of the sceen to match the height of the background
      screenHeight = 128; //sets h to 128 (the height of the screen)
      ct.setHeight( screenHeight );
      screenWidth = ct.getWidth(); //sets w to 100 (the width of the screen)   
      
      back1 = ct.image("background-day.png", screenWidth / 2, screenHeight / 2, screenWidth );
      back2 = ct.image("background-day.png", 1.5*screenWidth, screenHeight / 2, screenWidth );
      back1.setLayer(0);
      back2.setLayer(0);
      back1.xSpeed = -0.5;
      back2.xSpeed = -0.5;

      //draws the bird ct.image("filename", x, y, h)
      birdX = screenWidth / 2.0; // sets x to 50 (the x position of the bird)
      birdY = screenHeight / 2.0; // sets y to 64  (the y position of the bird)
      //height of the bird (the height of the bird)
      bird = ct.image( "yellowbird-downflap.png", birdX, birdY, BIRDHIEGHT ); //uses x and y to stand in for 50, 64
      ghostBird = ct.rect( birdX, birdY, 4.5, 4.5);
      ghostBird.visible = false;
      ghostBird.ySpeed = 0.5;
      //draws the count
      //the value of x does not change (the x position of the bird and number are equal)
      scoreY = screenHeight / 8.0; //sets y to 16 (the y position of the number)
      scoreX = birdX;
      scoreObj = ct.image( scoreImgFile, scoreX, scoreY, scoreHeight ); 
      scoreObj.setLayer(3);
      score = 0;

      //draws the ground
      int y = 122; //sets y to 122 (the y positoin of all the pieces of the base)
      int h = 40; //sets h to 40 (the height of all the pieces of the base)
      //since the x position of each piece of the base is different it is not useful to use a variable
      GameObj base1 = ct.image( "base.png", 20, y, h );
      GameObj base2 = ct.image( "base.png", 60, y, h );
      GameObj base3 = ct.image( "base.png", 100, y, h );
      base1.setLayer(4);
      base2.setLayer(4);
      base3.setLayer(4);

      randY = ct.random( 38, 90);
      goal1 = ct.rect( screenWidth + 40, randY, BIRDHIEGHT, BIRDHIEGHT * 2.5 );
      goal1.xSpeed = -0.5;
      goal1.setFillColor(null);
      goal1.setLineColor(null);

      randY = ct.random( 38, 90);
      goal2 = ct.rect( screenWidth + 110, randY, BIRDHIEGHT, BIRDHIEGHT * 2.5 );
      goal2.xSpeed = -0.5;
      goal2.setFillColor(null);
      goal2.setLineColor(null);

      //Creates the pipes
      pipeUp1 = ct.image("pipe_green_up.png", goal1.x, goal1.y+75, 10.5);
      pipeUp1.xSpeed = -0.5;
      pipeUp1.setLayer(2);

      pipeUp2 = ct.image("pipe_green_up.png", goal2.x, goal2.y+75, 10.5);
      pipeUp2.xSpeed = -0.5;
      pipeUp2.setLayer(2);

      pipeDown1 = ct.image("pipe_green_down.png", goal1.x, goal1.y-75, 10.5);
      pipeDown1.xSpeed = -0.5;
      pipeDown1.setLayer(2);

      pipeDown2 = ct.image("pipe_green_down.png", goal2.x, goal2.y-75, 10.5);
      pipeDown2.xSpeed = -0.5;
      pipeDown2.setLayer(2);
   }

   public void update( )
   {      
      //game updates only trigger if not on the star menu or end game screen
      if( mainPhase )
      {
         
         //Handles keypress input
         if( ct.clicked() || ct.charTyped(" ") )
         {
            ghostBird.y -= 4.5;
            ghostBird.ySpeed = -1;
         } 

         //Keeps the visible bird at the same y position as the invisible tracker bird
         if( bird.y != ghostBird.y )
         {
            bird.y = ghostBird.y;
            bird.ySpeed = ghostBird.ySpeed;
         }

         if( (ghostBird.hit( goal1 ) && !hit1) )
         {
            hit1 = true;
            score += 1;
            scoreImgFile = ct.formatInt( score ) + ".png";
            scoreObj.delete();
            scoreObj = ct.image( scoreImgFile, scoreX, scoreY, scoreHeight ); 
            scoreObj.setLayer(2);
         }

         if(ghostBird.hit( goal2 ) && !hit2)
         {
            hit2 = true;
            score += 1;

            if( score == 10 ) 
            {
               scoreHeight = 10;
            }

            scoreImgFile = ct.formatInt( score ) + ".png";
            scoreObj.delete();
            scoreObj = ct.image( scoreImgFile, scoreX, scoreY, scoreHeight ); 
            scoreObj.setLayer(2);
         }
         //Handles the animation of the bird
         updates++;
         boolean changed = false; // boolean to store whether the flap frame has been changed yet
         if( updates == 10 )
         {
            if( flap.equals("downflap") && !changed )
            {
               flap = "midflap";
               changed = true;
            }

            if( flap.equals("midflap") && !changed )
            {
               flap = "upflap";
               changed = true;
            }

            if( flap.equals("upflap") && !changed )
            {
               flap = "downflap";
               changed = true;
            }

            filename = "yellowbird-" + flap + ".png";

            birdY = ghostBird.y;
            bird.delete();
            bird = ct.image( filename, birdX, birdY, BIRDHIEGHT );
            updates = 0;
         }         

         //Handles the background recycling
         if( back1.x == -(screenWidth / 2) ) 
         {  
            back1.x = 1.5*screenWidth; 
         }

         if( back2.x == -(screenWidth / 2) ) 
         {  
            back2.x = 1.5*screenWidth; 
         }

         //Handles the goal and pipes reset when offscreen
         if( goal1.x < 0 - goal1.width ) 
         {  
            //Goal1
            goal1.x = screenWidth + 40;
            randY = ct.random( 38 , 90 );
            goal1.y = randY; 
            hit1 = false;

            //pipes
            pipeUp1.x = goal1.x;
            pipeUp1.y = goal1.y+75;

            pipeDown1.x = goal1.x;
            pipeDown1.y = goal1.y-75;
         }

         if( goal2.x < 0 - goal2.width ) 
         {  
            //Goal2
            goal2.x = screenWidth + 40;
            randY = ct.random( 28 , 100 );
            goal2.y = randY; 
            hit2 = false;

            //pipes
            pipeUp2.x = goal2.x;
            pipeUp2.y = goal2.y+75;

            pipeDown2.x = goal2.x;
            pipeDown2.y = goal2.y-75;
         }

         //Handles bird movement
         if( ghostBird.ySpeed < 3 )
         {
            ghostBird.ySpeed += 0.05;
         }

         if (ghostBird.y < -30 )
         {
            ghostBird.y = 0;
         }  

         //Checks if the bird has crashed into the ground
         if( ghostBird.y > 112 || ghostBird.hit(pipeUp1) || ghostBird.hit(pipeDown1) || ghostBird.hit(pipeUp2) || ghostBird.hit(pipeDown2) )
         {
            mainPhase = false;
            endPhase = true;
            back1.xSpeed = 0;
            back2.xSpeed = 0;
            goal1.xSpeed = 0;
            goal2.xSpeed = 0;
            pipeUp1.xSpeed = 0;
            pipeDown1.xSpeed = 0;
            pipeUp2.xSpeed = 0;
            pipeDown2.xSpeed = 0;
            ghostBird.ySpeed = 0;
            bird.ySpeed = 0;

            if( score > highScore )
            {
               highScore = score;
            }

            //Draws the endgame score and highscore screen
            scoreObj.delete();
            scoreY += 12;
            gameOverImg = ct.image("gameover.png", scoreX, scoreY, 35 );
            gameOverImg.setLayer(4);
            endScoreText = ct.text("Score", scoreX, scoreY+8, 5, "white" );
            endScoreText.setLayer(4);
            scoreImgFile = ct.formatInt( score ) + ".png";
            endScoreImg = ct.image( scoreImgFile, scoreX, scoreY + 16, scoreHeight );
            endScoreImg.setLayer(4);
            endBestText = ct.text("HighScore", scoreX, scoreY + 24, 5, "white" );
            endBestText.setLayer(4);
            scoreImgFile = ct.formatInt( highScore ) + ".png";
            endScoreImg = ct.image( scoreImgFile, scoreX, scoreY + 32, scoreHeight );
            endScoreImg.setLayer(4);
            restartText = ct.text("Restart", scoreX, scoreY + 42, 8, "white" );
            restartText.setLayer(4);
            restartText.clickable = false;
            restartBox = ct.rect( scoreX, scoreY + 42, 24, 8, "orange");
            restartBox.setLayer(3);
         }
      }  
      if( endPhase )
      {
         if( restartBox.clicked() )
         {
            mainPhase = true;
            endPhase = false;

            //Back
            back1.xSpeed = -0.5;
            back2.xSpeed = -0.5;





         }
      }
   }    

}