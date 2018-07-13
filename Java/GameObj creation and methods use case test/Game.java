
import Code12.*;

public class Game extends Code12Program
{
    GameObj player;
    GameObj[] enemies;
    GameObj goal;
    GameObj score;
    boolean playerDead = false;
    double playerSpeed = 2;
    double enemySpeed = 1;
    double enemyCount = 0;
    int scoreCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new Game());
    }

    public void start()
    {
        // Player
        player = ct.circle(( ct.toInt(ct.getWidth() / 2)), (3 * ct.toInt(ct.getHeight() / 4)), 5);
        player.setFillColor("blue");

        // Goal
        goal = ct.circle(ct.random(0, ct.toInt(ct.getWidth())), ct.random(ct.toInt(ct.getHeight() / 3), ct.toInt(ct.getHeight())), 5);
        goal.setFillColor("green");

        // Score
        score = ct.text(null, ct.toInt(ct.getWidth() / 2), ct.toInt(ct.getHeight() / 25), 5);
        //"Score: " + scoreCount + "    Goal: 10"

        // Enemies
        enemies = new GameObj[10];
        for (int i = 0; i < enemies.length; i++)
        {
            enemies[i] = ct.rect(ct.random(0, ct.toInt(ct.getWidth())), -2, 3, 3);
            enemies[i].setFillColor("red");
        }
    }

    public void update()
    {
        if (!playerDead)
        {
        //}
           // If Player reaches outside left or right edge of screen: teleport to other side
           if ( player.x + (player.width / 2) < 0 )
               player.x = ct.getWidth();
           else if ( player.x - (player.width / 2) > ct.getWidth() )
               player.x = 0;
   
           // If Player reaches top or bottom edge of screen: prevent passing
           if (player.y - (player.height / 2) <= 0)
           {
               player.y++;
               player.ySpeed = 0;
           }
           else if (player.y + (player.height / 2) >= ct.getHeight())
           {
               player.y--;
               player.ySpeed = 0;
           }
   
           // If Enemy reaches bottom edge of screen: teleport to top
           for (int i = 0; i < enemies.length; i++)
           {
               if (enemies[i].y + (enemies[i].height / 2) >= ct.getHeight())
               {
                   enemies[i].x = ct.random(0, ct.toInt(ct.getWidth()));
                   enemies[i].y = -2;
               }
           }
   
           // If Player hits Goal
           if (player.hit(goal))
           {
               goal.x = ct.random(0, ct.toInt(ct.getWidth()));
               goal.y = ct.random(ct.toInt(ct.getHeight() / 3), ct.toInt(ct.getHeight()));
               scoreCount++;
               score.setText("Score: " + scoreCount + "    Goal: 10");
           }
   
           // If Player hits Enemies
           for (int i = 0; i < enemies.length; i++)
           {
               if (player.hit(enemies[i]))
               {
                   enemies[i].x = ct.random(0, ct.toInt(ct.getWidth()));
                   enemies[i].y = 0;
                   scoreCount--;
                   score.setText("Score: " + scoreCount + "    Goal: 10");
               }
           }
   
           // If Player lost
           if (scoreCount < 0)
           {
               ct.text("You Lost", ct.toInt(ct.getWidth() / 2), ct.toInt(ct.getHeight() / 2), 10);
               player.delete();
               for (int i = 0; i < enemies.length; i++)
                   enemies[i].delete();
               playerDead = true;
           }
   
           // If Player won
           else if (scoreCount == 10)
           {
               ct.text("You Won!", ct.toInt(ct.getWidth() / 2), ct.toInt(ct.getHeight() / 2), 10);
               player.delete();
               for (int i = 0; i < enemies.length; i++)
                   enemies[i].delete();
               playerDead = true;
           }
        }
    }

    public void onKeyPress(String key)
    {
        // Start moving on key presses
        if (key.equals("up"))
            player.ySpeed = playerSpeed * -1;
        else if (key.equals("down"))
            player.ySpeed = playerSpeed;
        else if (key.equals("left"))
            player.xSpeed = playerSpeed * -1;
        else if (key.equals("right"))
            player.xSpeed = playerSpeed;

        enemyCount++;
        if (enemyCount < enemies.length)
            enemies[ct.random(0, enemies.length - 1)].ySpeed = 1;
    }

    public void onKeyRelease(String key)
    {
        // Stop moving on key release
        if (key.equals("up") || key.equals("down"))
            player.ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            player.xSpeed = 0;
    }

}
