
class Game
{
    GameObj player, goal, score;
    boolean end = false;
    int scoreCount = 0;

    public void start()
    {

        ct.setBackColor("gray");
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
        goal.setLineColor("light green");
        goal.setLayer(0);

        /*
         * creates score object,
         * keeps track of score,
         * score updated every update cycle
         */
        score = ct.text("Score: 0", 50, 4, 5, "dark gray");
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
            player.y++;
        // prevents player from going past lower edge
        else if (player.y + player.getHeight() / 2 >= 100)
            player.y--;

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
        if (hitObj != null && !end)
        {
            hitObj.delete();
            scoreCount--;
        }
        // update score text
        score.setText("Score: " + scoreCount);

        // if score is less than zero, end game
        if (scoreCount < 0)
            end();
    }

    public void onKeyPress(String key)
    {
        // if game has not ended, change direction of player
        if (!end)
        {
            if (key.equals("up"))
                player.setYSpeed(-1);
            else if (key.equals("down"))
                player.setYSpeed(1);
            else if (key.equals("left"))
                player.setXSpeed(-1);
            else if (key.equals("right"))
                player.setXSpeed(1);
        }

        // create an object each time a key is pressed
        GameObj enemy = ct.rect(ct.random(0, 100), -1, 3, 3, "dark gray");
        enemy.setLineWidth(0);
        enemy.setLayer(0);
        enemy.setYSpeed(1);
        enemy.group = "enemies";
    }

    public void onKeyRelease(String key)
    {
        // if a key is released, stop player movement
        if (key.equals("up") || key.equals("down"))
            player.setYSpeed(0);
        else if (key.equals("left") || key.equals("right"))
            player.setXSpeed(0);
    }

    // ends game
    void end()
    {
        ct.text("You Lost", 50, 50, 10, "dark gray");
        end = true;
    }

}
