
import Code12.*;

public class Game extends Code12Program
{
    GameObj player, goal, score;
    GameObj[] enemies;
    double enemyCount = 0;
    int scoreCount = 0;

    public static void main(String[] args)
    {
        Code12.run(new Game());
    }

    public void start()
    {
        ct.setBackColor("gray");

        player = ct.circle(( (int)(ct.getWidth() / 2)), (3 * (int)(ct.getHeight() / 4)), 5, "white");
        player.setLineColor("white");

        goal = ct.circle(ct.random(0, (int)(ct.getWidth())), ct.random((int)(ct.getHeight() / 3), (int)(ct.getHeight())), 3, "light green");
        goal.setLineColor("light green");

        score = ct.text("Score: " + scoreCount + "    Goal: 10", (int)(ct.getWidth() / 2), (int)(ct.getHeight() / 25), 5, "dark gray");

        enemies = new GameObj[10];
        for (int i = 0; i < enemies.length; i++)
        {
            enemies[i] = ct.rect(ct.random(0, (int)(ct.getWidth())), -2, 3, 3, "dark gray");
            enemies[i].setLineColor("dark gray");
            enemies[i].group = "enemies";
        }
    }

    public void update()
    {
        if (isBeyondLeftBoundary(player))
            player.x = ct.getWidth();
        else if (isBeyondRightBoundary(player))
            player.x = 0;

        if (isBeyondUpperBoundary(player))
            preventPassingUpperBoundary(player);
        else if (isBeyondLowerBoundary(player))
            preventPassingLowerBoundary(player);

        for (int i = 0; i < enemies.length; i++)
        {
            if (isBeyondLowerBoundary(enemies[i]))
                randomizeEnemyPosition(enemies[i]);
        }

        if (player.hit(goal))
        {
            randomizeGoalPosition();
            incrementScore("++");
        }

        for (int i = 0; i < enemies.length; i++)
        {
            if (player.hit(enemies[i]))
            {
                randomizeEnemyPosition(enemies[i]);
                incrementScore("--");
            }
        }

        if (scoreCount < 0)
            winningAction();
        else if (scoreCount == 10)
            losingAction();
    }

    public boolean isBeyondLeftBoundary(GameObj object)
    {
        return object.x + (object.width / 2) <= 0;
    }

    public boolean isBeyondRightBoundary(GameObj object)
    {
        return object.x - (object.width / 2) >= ct.getWidth();
    }

    public boolean isBeyondUpperBoundary(GameObj object)
    {
        return player.y - (player.height / 2) <= 0;
    }

    public boolean isBeyondLowerBoundary(GameObj object)
    {
        return object.y + (object.height / 2) >= ct.getHeight();
    }

    public void preventPassingUpperBoundary(GameObj object)
    {
        object.y++;
        object.ySpeed = 0;
    }

    public void preventPassingLowerBoundary(GameObj object)
    {
        object.y--;
        object.ySpeed = 0;
    }

    public void randomizeEnemyPosition(GameObj enemy)
    {
        enemy.x = ct.random(0, (int)(ct.getWidth()));
        enemy.y = -2;
    }

    public void randomizeGoalPosition()
    {
        goal.x = ct.random(0, (int)(ct.getWidth()));
        goal.y = ct.random((int)(ct.getHeight() / 3), (int)(ct.getHeight()));
    }

    public void incrementScore(String increment)
    {
        if (increment.equals("++"))
            scoreCount++;
        else
            scoreCount--;
        score.setText("Score: " + scoreCount + "    Goal: 10");
    }

    public void winningAction()
    {
        ct.text("You Lost", (int)(ct.getWidth() / 2), (int)(ct.getHeight() / 2), 10, "dark gray");
        player.delete();
        goal.delete();
        ct.clearGroup("enemies");
    }

    public void losingAction()
    {
        ct.text("You Won!", (int)(ct.getWidth() / 2), (int)(ct.getHeight() / 2), 10, "dark gray");
        player.delete();
        goal.delete();
        ct.clearGroup("enemies");
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

        enemyCount++;
        if (enemyCount < enemies.length)
            enemies[ct.random(0, enemies.length - 1)].ySpeed = 1;
    }

    public void onKeyRelease(String key)
    {
        if (key.equals("up") || key.equals("down"))
            player.ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            player.xSpeed = 0;
    }

}
