
import Code12.*;

public class Game extends Code12Program
{
    GameObj player, goal, score;
    double enemyCount = 0;
    int scoreCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new Game());
    }

    public void start()
    {
        ct.setBackColor("gray");

        player = ct.circle(50, 75, 5, "white");
        player.setLineColor("white");

        goal = ct.circle(ct.random(0, 100), ct.random(33, 100), 3, "light green");
        goal.setLineColor("light green");

        score = ct.text("Score: 0    Goal: 10", 50, 4, 5, "dark gray");
    }

    public void update()
    {
        if (isBeyondLeftBoundary())
            player.x = 100;
        else if (isBeyondRightBoundary())
            player.x = 0;

        if (isBeyondUpperBoundary())
            preventPassingUpperBoundary();
        else if (isBeyondLowerBoundary())
            preventPassingLowerBoundary();

        if (player.hit(goal))
        {
            randomizeGoalPosition();
            incrementScore("++");
        }

        GameObj objHit = player.objectHitInGroup("enemies");
        if (objHit != null && player.visible)
        {
            objHit.delete();
            incrementScore("--");
        }

        if (scoreCount < 0)
            losingAction();
    }

    public boolean isBeyondLeftBoundary()
    {
        return player.x + player.width / 2 <= 0;
    }

    public boolean isBeyondRightBoundary()
    {
        return player.x - player.width / 2 >= 100;
    }

    public boolean isBeyondUpperBoundary()
    {
        return player.y - player.height / 2 <= 0;
    }

    public boolean isBeyondLowerBoundary()
    {
        return player.y + player.height / 2 >= 100;
    }

    public void preventPassingUpperBoundary()
    {
        player.y++;
        player.ySpeed = 0;
    }

    public void preventPassingLowerBoundary()
    {
        player.y--;
        player.ySpeed = 0;
    }

    public void randomizeGoalPosition()
    {
        goal.x = ct.random(0, 100);
        goal.y = ct.random(33, 100);
    }

    public void incrementScore(String increment)
    {
        if (increment.equals("++"))
            scoreCount++;
        else
            scoreCount--;
        score.setText("Score: " + scoreCount + "    Goal: 10");
    }

    public void losingAction()
    {
        ct.text("You Lost", 50, 50, 10, "dark gray");
        goal.visible = false;
        player.visible = false;
    }

    public void onKeyPress(String key)
    {
        if (key.equals("up"))
            player.ySpeed = -2;
        else if (key.equals("down"))
            player.ySpeed = 2;
        else if (key.equals("left"))
            player.xSpeed = -2;
        else if (key.equals("right"))
            player.xSpeed = 2;

        GameObj enemy = ct.rect(ct.random(0, 100), -1, 3, 3, "dark gray");
        enemy.setLineColor("dark gray");
        enemy.setLayer(0);
        enemy.ySpeed = 1;
        enemy.autoDelete = true;
        enemy.group = "enemies";
    }

    public void onKeyRelease(String key)
    {
        if (key.equals("up") || key.equals("down"))
            player.ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            player.xSpeed = 0;
    }

}
