
class Snake
{
    GameObj[] snake;
    GameObj food;
    String curKey;
    double time;

    public void start()
    {
        ct.setBackColor("dark gray");
        snake = new GameObj[2];
        snake[0] = ct.rect(87.5, 47.5, 5, 5, "light red");
        snake[1] = ct.rect(92.5, 47.5, 5, 5, "light red");
        snake[0].setLineColor("white");
        snake[1].setLineColor("white");
        snake[1].group = "snake";
        food = ct.circle(32.5, 47.5, 5, "white");
        food.setLineWidth(0);
        food.setLayer(0);
        curKey = "left";
        time = ct.getTimer();
    }

    public void update()
    {
        // movement refresh rate is 175 milsec
        if (ct.getTimer() - time > 175)
        {
            moveSnake();
            time = ct.getTimer();
        }

        // if snake hits food, move food to random location and expand snake
        if (snake[0].x == food.x && snake[0].y == food.y)
        {
            food.x = 5 * ct.random(0, 9) + 2.5;
            food.y = 5 * ct.random(0, 9) + 2.5;
            expandSnake();
        }

        // is player has lost, end game
        if (hasPlayerLost())
            end();
    }

    public void onKeyRelease(String key)
    {
        if (key.equals("up") && !curKey.equals("down"))
            curKey = "up";
        else if (key.equals("down") && !curKey.equals("up"))
            curKey = "down";
        else if (key.equals("left") && !curKey.equals("right"))
            curKey = "left";
        else if (key.equals("right") && !curKey.equals("left"))
            curKey = "right";
    }

    void moveSnake()
    {
        for (int i = snake.length - 1; i > 0; i--)
        {
            snake[i].x = snake[i - 1].x;
            snake[i].y = snake[i - 1].y;
        }
        if (curKey.equals("up"))
            snake[0].y -= 5;
        else if (curKey.equals("down"))
            snake[0].y += 5;
        else if (curKey.equals("left"))
            snake[0].x -= 5;
        else if (curKey.equals("right"))
            snake[0].x += 5;
    }

    void expandSnake()
    {
        GameObj[] newSnake = new GameObj[snake.length + 1];
        for (int i = 0; i < snake.length; i++)
            newSnake[i] = snake[i];
        double x = snake[snake.length - 1].x;
        double y = snake[snake.length - 1].y;
        newSnake[newSnake.length - 1] = ct.rect(x, y, 5, 5, "light red");
        newSnake[newSnake.length - 1].setLineColor("white");
        snake = newSnake;
    }

    boolean hasPlayerLost()
    {
        for (int i = 4; i < snake.length; i++)
        {
            if (snake[0].x == snake[i].x && snake[0].y == snake[i].y)
                return true;
        }
        return snake[0].x == -2.5 || snake[0].x == 102.5 || snake[0].y == -2.5 || snake[0].y == 102.5;
    }

    void end()
    {
        ct.showAlert("you lost");
        ct.stop();
    }

}
