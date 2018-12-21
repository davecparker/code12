
class Game
{
    GameObj player, goal, score;
    double enemyCount = 0;
    int scoreCount = 0;
    int xSpeed = 0;
    int ySpeed = 0;
    boolean isGameFinished = false;

    public void start()
    {
        ct.setBackColor("gray");

<<<<<<< HEAD
        /*
         * creates player object,
         * user interactive via arrow keys
         */
        player = ct.circle(50, 75, 5, "white");
        player.setLineColor("white");

        /*
         * creates goal object,
         * increases score when player touches goal
         */
        goal = ct.circle(ct.random(0, 100), ct.random(33, 100), 3, "light green");
=======
        player = ct.circle(( (int)(ct.getWidth() / 2)), (3 * (int)(ct.getHeight() / 4)), 5, "white");
        player.setLineColor("white");

        goal = ct.circle(ct.random(0, (int)(ct.getWidth())), ct.random((int)(ct.getHeight() / 3), (int)(ct.getHeight())), 3, "light green");
>>>>>>> master
        goal.setLineColor("light green");
        goal.setLayer(0);

<<<<<<< HEAD
        /*
         * creates score object,
         * keeps track of score,
         * score updated every update cycle
         */
        score = ct.text("Score: 0", 50, 4, 5, "dark gray");
=======
        score = ct.text("Score: " + scoreCount + "    Goal: 10", (int)(ct.getWidth() / 2), (int)(ct.getHeight() / 25), 5, "dark gray");

        enemies = new GameObj[10];
        for (int i = 0; i < enemies.length; i++)
        {
            enemies[i] = ct.rect(ct.random(0, (int)(ct.getWidth())), -2, 3, 3, "dark gray");
            enemies[i].setLineColor("dark gray");
            enemies[i].group = "enemies";
        }
>>>>>>> master
    }

    public void update()
    {
        // teleports player from left edge to right edge
        if (player.x + player.getWidth() / 2 <= 0)
            player.x = 100;
        // teleports player from right edge to left edge
        else if (player.x - player.getWidth() / 2 >= 100)
            player.x = 0;

        // prevents player from going past upper edge
        if (player.y - player.getHeight() / 2 <= 0)
        {
            player.y++;
            player.setXSpeed(xSpeed);
        }
        // prevents player from going past lower edge
        else if (player.y + player.getHeight() / 2 >= 100)
        {
            player.y--;
            player.setXSpeed(xSpeed);
        }

        /*
         * if player hits goal,
         * move goal to random location,
         * and increase score count
         */
        if (player.hit(goal))
        {
            goal.x = ct.random(10, 90);
            goal.y = ct.random(35, 95);
            scoreCount++;
        }
        /*
         * if player hits an enemy,
         * delete enemy,
         * and decrease score count
         */
        GameObj hitObj = player.objectHitInGroup("enemies");
        if (hitObj != null && !isGameFinished)
        {
            hitObj.delete();
            scoreCount--;
        }
        // update score text
        score.setText("Score: " + scoreCount);

        // if score is less than zero, end game
        if (scoreCount < 0)
<<<<<<< HEAD
            end();
=======
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
>>>>>>> master
    }

    public void onKeyPress(String key)
    {
        // if game has not ended, change direction of player
        if (!isGameFinished)
        {
            if (key.equals("up"))
                ySpeed += -1;
            else if (key.equals("down"))
                ySpeed += 1;
            else if (key.equals("left"))
                xSpeed += -1;
            else if (key.equals("right"))
                xSpeed += 1;
            player.setSpeed(xSpeed, ySpeed);
        }

        // create an object each time a key is pressed
        GameObj enemy = ct.rect(ct.random(0, 100), -1, 3, 3, "dark gray");
        enemy.setLineWidth(0);
        enemy.setLayer(0);
        enemy.setSpeed(0, 1);
        enemy.group = "enemies";
    }

    public void onKeyRelease(String key)
    {
        // if a key is released, stop player movement
        if (key.equals("up") || key.equals("down"))
            ySpeed = 0;
        else if (key.equals("left") || key.equals("right"))
            xSpeed = 0;
        player.setSpeed(xSpeed, ySpeed);
    }

    // ends game
    void end()
    {
        ct.text("You Lost", 50, 50, 10, "dark gray");
        isGameFinished = true;
    }

}
