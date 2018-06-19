
import Code12.*;

public class Game extends Code12Program
{
    public GameObj player;
    public GameObj goal;
    public GameObj score;
    public int scoreCount = 0;
    public static double playerSpeed = 2, enemySpeed = 1;
    public GameObj enemy1, enemy2, enemy3, enemy4, enemy5, enemy6, enemy7, enemy8, enemy9, enemy10;

    public static void main(String[] args)
    {
        Code12.run(new Game());
    }

    public void start()
    {
       // Player
        this.player = ct.circle(((int) ct.getWidth() / 2), (3 * (int) ct.getHeight() / 4), 5);
        this.player.setFillColor("blue");

        // Goal
        this.goal = ct.circle((int) ct.random(0, (int) ct.getWidth()), ct.random((int) ct.getHeight() / 3, (int) ct.getHeight()), 5);
        this.goal.setFillColor("green");

        // Score
        this.score = ct.text("Score: " + scoreCount + "    Goal: 10", (int) ct.getWidth() / 2, (int) ct.getHeight() / 25, 5);

        // Enemies
        this.enemy1 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy1.setFillColor("red");
        this.enemy1.ySpeed = 1;
        this.enemy2 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy2.setFillColor("red");
        this.enemy2.ySpeed = 1;
        this.enemy3 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy3.setFillColor("red");
        this.enemy3.ySpeed = 1;
        this.enemy4 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy4.setFillColor("red");
        this.enemy4.ySpeed = 1;
        this.enemy5 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy5.setFillColor("red");
        this.enemy5.ySpeed = 1;
        this.enemy6 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy6.setFillColor("red");
        this.enemy6.ySpeed = 1;
        this.enemy7 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy7.setFillColor("red");
        this.enemy7.ySpeed = 1;
        this.enemy8 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy8.setFillColor("red");
        this.enemy8.ySpeed = 1;
        this.enemy9 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy9.setFillColor("red");
        this.enemy9.ySpeed = 1;
        this.enemy10 = ct.rect(ct.random(0, (int) ct.getWidth()), 0, 3, 3);
        this.enemy10.setFillColor("red");
        this.enemy10.ySpeed = 1;
    }

    public void update()
    {
        // If Player reaches outside left or right edge of screen: teleport to other side
        if ( this.player.x + (this.player.width / 2) < 0 )
            this.player.x = ct.getWidth();
        else if ( this.player.x - (this.player.width / 2) > ct.getWidth() )
            this.player.x = 0;

        // If Player reaches top or bottom edge of screen: prevent passing
        if (this.player.y - (this.player.height / 2) <= 0)
        {
            this.player.y++;
            this.player.ySpeed = 0;
        }
        else if (this.player.y + (this.player.height / 2) >= ct.getHeight())
        {
            this.player.y--;
            this.player.ySpeed = 0;
        }

        // If Enemy reaches bottom edge of screen: teleport to top
        if (this.enemy1.y + (this.enemy1.height / 2) >= ct.getHeight())
        {
            this.enemy1.x = ct.random(0, (int) ct.getWidth());
            this.enemy1.y = 0;
        }
        if (this.enemy2.y + (this.enemy2.height / 2) >= ct.getHeight())
        {
            this.enemy2.x = ct.random(0, (int) ct.getWidth());
            this.enemy2.y = 0;
        }
        if (this.enemy3.y + (this.enemy3.height / 2) >= ct.getHeight())
        {
            this.enemy3.x = ct.random(0, (int) ct.getWidth());
            this.enemy3.y = 0;
        }
        if (this.enemy4.y + (this.enemy4.height / 2) >= ct.getHeight())
        {
            this.enemy4.x = ct.random(0, (int) ct.getWidth());
            this.enemy4.y = 0;
        }
        if (this.enemy5.y + (this.enemy5.height / 2) >= ct.getHeight())
        {
            this.enemy5.x = ct.random(0, (int) ct.getWidth());
            this.enemy5.y = 0;
        }
        if (this.enemy6.y + (this.enemy6.height / 2) >= ct.getHeight())
        {
            this.enemy6.x = ct.random(0, (int) ct.getWidth());
            this.enemy6.y = 0;
        }
        if (this.enemy7.y + (this.enemy7.height / 2) >= ct.getHeight())
        {
            this.enemy7.x = ct.random(0, (int) ct.getWidth());
            this.enemy7.y = 0;
        }
        if (this.enemy8.y + (this.enemy8.height / 2) >= ct.getHeight())
        {
            this.enemy8.x = ct.random(0, (int) ct.getWidth());
            this.enemy8.y = 0;
        }
        if (this.enemy9.y + (this.enemy9.height / 2) >= ct.getHeight())
        {
            this.enemy9.x = ct.random(0, (int) ct.getWidth());
            this.enemy9.y = 0;
        }
        if (this.enemy10.y + (this.enemy10.height / 2) >= ct.getHeight())
        {
            this.enemy10.x = ct.random(0, (int) ct.getWidth());
            this.enemy10.y = 0;
        }

        // If Player hits Goal
        if (this.player.hit(this.goal))
        {
            this.goal.x = ct.random(0, (int) ct.getWidth());
            this.goal.y = ct.random((int) ct.getHeight() / 3, (int) ct.getHeight());
            this.score.setText("Score: " + ++this.scoreCount + "    Goal: 10");
        }

        // If Player hits Enemies
        if (this.player.hit(this.enemy1))
        {
            this.enemy1.x = ct.random(0, (int) ct.getWidth());
            this.enemy1.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy2))
        {
            this.enemy2.x = ct.random(0, (int) ct.getWidth());
            this.enemy2.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy3))
        {
            this.enemy3.x = ct.random(0, (int) ct.getWidth());
            this.enemy3.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy4))
        {
            this.enemy4.x = ct.random(0, (int) ct.getWidth());
            this.enemy4.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy5))
        {
            this.enemy5.x = ct.random(0, (int) ct.getWidth());
            this.enemy5.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy6))
        {
            this.enemy6.x = ct.random(0, (int) ct.getWidth());
            this.enemy6.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy7))
        {
            this.enemy7.x = ct.random(0, (int) ct.getWidth());
            this.enemy7.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy8))
        {
            this.enemy8.x = ct.random(0, (int) ct.getWidth());
            this.enemy8.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy9))
        {
            this.enemy9.x = ct.random(0, (int) ct.getWidth());
            this.enemy9.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }
        else if (this.player.hit(this.enemy10))
        {
            this.enemy10.x = ct.random(0, (int) ct.getWidth());
            this.enemy10.y = 0;
            this.score.setText("Score: " + --this.scoreCount + "    Goal: 10");
        }

        // If Player lost
        if (this.scoreCount < 0)
        {
            ct.text("You Lost", (int) ct.getWidth() / 2, (int) ct.getHeight() / 2, 10);
            this.player.delete();
            this.enemy1.delete();
            this.enemy2.delete();
            this.enemy3.delete();
            this.enemy4.delete();
            this.enemy5.delete();
            this.enemy6.delete();
            this.enemy7.delete();
            this.enemy8.delete();
            this.enemy9.delete();
            this.enemy10.delete();
        }


        // If Player won
        else if (this.scoreCount == 10)
        {
            ct.text("You Won!", (int) ct.getWidth() / 2, (int) ct.getHeight() / 2, 10);
            this.player.delete();
            this.enemy1.delete();
            this.enemy2.delete();
            this.enemy3.delete();
            this.enemy4.delete();
            this.enemy5.delete();
            this.enemy6.delete();
            this.enemy7.delete();
            this.enemy8.delete();
            this.enemy9.delete();
            this.enemy10.delete();
        }
    }

    public void onKeyPress(String key)
    {
        // Start moving on key presses
        if (key.equals("up"))
            this.player.ySpeed = this.playerSpeed * -1;

        else if (key.equals("down"))
            this.player.ySpeed = this.playerSpeed;

        else if (key.equals("left"))
            this.player.xSpeed = this.playerSpeed * -1;

        else if (key.equals("right"))
            this.player.xSpeed = this.playerSpeed;

        // Increase Enemy speed
        this.enemy1.ySpeed += 0.005;
        this.enemy2.ySpeed += 0.005;
        this.enemy3.ySpeed += 0.005;
        this.enemy4.ySpeed += 0.005;
        this.enemy5.ySpeed += 0.005;
        this.enemy6.ySpeed += 0.005;
        this.enemy7.ySpeed += 0.005;
        this.enemy8.ySpeed += 0.005;
        this.enemy9.ySpeed += 0.005;
        this.enemy10.ySpeed += 0.005;
    }

    public void onKeyRelease(String key)
    {
        // Stop moving on key release
        if (key.equals("up") || key.equals("down"))
            this.player.ySpeed = 0;

        else if (key.equals("left") || key.equals("right"))
            this.player.xSpeed = 0;
    }

}
