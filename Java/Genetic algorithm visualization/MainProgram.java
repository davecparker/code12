
import Code12.*;

public class MainProgram extends Code12Program
{
    GameObj goal, timer, maxFitness, gen;
    GameObj[] dots, obstacles;
    String[] spatialDirections = {"up", "down", "left", "right"};
    String[] directions = new String[(60 * 10) * 50];
    boolean[] killed = new boolean[50];
    int veteranIndex, step;
    double time;

    public static void main(String[] args)
    {
        Code12.run(new MainProgram());
    }

    public void start()
    {
        goal = ct.circle(ct.getWidth() / 2, 2, 1);
        timer = ct.text("10.0", ct.getWidth() / 20, ct.getHeight() / 20, 5);
        timer.align("center", true);
        timer.setLayer(3);
        time = ct.getTimer();
        maxFitness = ct.text("0.00", ct.getWidth() - (ct.getWidth() / 10), ct.getHeight() / 20, 5);
        maxFitness.align("center", true);
        maxFitness.setLayer(3);
        gen = ct.text("Gen 1", ct.getWidth() / 10, ct.getHeight() - (ct.getHeight() / 20), 5);
        gen.align("center", true);
        gen.setLayer(3);
        dots = new GameObj[50];
        veteranIndex = 0;
        step = 0;

        defineObstacles();
        defineDots();
        defineDirections();
    }

    public void update()
    {
        updateTimer();
        conditionalUpdates();
        if (areAllDotsDead())
            nextGenPrep();
    }

    public void conditionalUpdates()
    {
        for (int i = 0; i < dots.length; i++)
        {
            killUponSpecifiedEvents(i);
            updateVeteranIndex();
            updateMaxFitness();
            if (!killed[i])
                move(i, step);
        }
        step++;
    }

    public void nextGenPrep()
    {
        for (int i = 0; i < dots.length; i++)
        {
            dots[i].delete();
            killed[i] = false;
            defineDot(i);
            copyVeteranDirections(i);
            if (i != veteranIndex)
                mutate(i);
        }
        defineVeteran();
        updateGen();
        time = ct.getTimer();
        step = 0;
    }

    public boolean areAllDotsDead()
    {
        for (int i = 0; i < dots.length; i++)
        {
            if (!killed[i])
                return false;
        }
        return true;
    }

    public void defineObstacles()
    {
        obstacles = new GameObj[10];
        for (int i = 0; i < obstacles.length; i++)
        {
            int x = ct.random(0, ct.toInt(ct.getWidth()));
            int y = ct.random(ct.toInt(ct.getHeight() / 5), ct.toInt(ct.getHeight()) - ct.toInt(ct.getHeight() / 5));
            obstacles[i] = ct.rect(x, y, ct.random(1, 8), ct.random(1, 15));
            obstacles[i].align("center", true);
        }
    }

    public void defineDots()
    {
        //dots = new GameObj[50];
        for (int i = 0; i < dots.length; i++)
            defineDot(i);
    }

    public void defineDot(int i)
    {
        dots[i] = ct.circle(ct.getWidth() / 2, ct.getHeight() - (ct.getHeight() / 50), 1);
        dots[i].setFillColor("blue");
        dots[i].align("center", true);
    }

    public void defineVeteran()
    {
        dots[veteranIndex].setFillColor("green");
        dots[veteranIndex].setLayer(2);
    }

    public void defineDirections()
    {
        for (int i = 0; i < directions.length; i++)
            directions[i] = spatialDirections[ct.random(0, 3)];
    }

    public void updateTimer()
    {
        double timeDiff = -(ct.getTimer() - time) / 1000 + 10;
        if (timeDiff > 0)
            timer.setText(ct.formatDecimal(timeDiff, 1));
        else
            timer.setText("0.0");
    }

    public void updateVeteranIndex()
    {
        for (int i = 0; i < dots.length; i++)
        {
            if (getFitness(i) > getFitness(veteranIndex))
                veteranIndex = i;
        }
    }

    public void updateMaxFitness()
    {
        if (getFitness(veteranIndex) > ct.parseNumber(maxFitness.getText()))
            maxFitness.setText(ct.formatDecimal(getFitness(veteranIndex), 2));
    }

    public void updateGen()
    {
        String genText = gen.getText();
        gen.setText("Gen " + (ct.parseInt(genText.substring(genText.indexOf(" "))) + 1));
    }

    public void killUponSpecifiedEvents(int i)
    {
        killOutsideBoundary(i);
        killWithinGoal(i);
        killWithinObstacles(i);
        killTimerFinished(i);
    }

    public void killOutsideBoundary(int i)
    {
        if (dots[i].x <= 0 || dots[i].x >= ct.getWidth() || dots[i].y <= 0 || dots[i].y >= ct.getHeight())
            kill(i);
    }

    public void killWithinGoal(int i)
    {
        if (dots[i].hit(goal))
            kill(i);
    }

    public void killWithinObstacles(int i)
    {
        if (isWithinObstacles(i))
            kill(i);
    }

    public boolean isWithinObstacles(int i)
    {
        for (int j = 0; j < obstacles.length; j++)
        {
            if (dots[i].hit(obstacles[j]))
                return true;
        }
        return false;
    }

    public void killTimerFinished(int i)
    {
        String currentTime = timer.getText();
        if (currentTime.equals("0.0") || step >= 600)
            kill(i);
    }

    public void kill(int i)
    {
        killed[i] = true;
        dots[i].xSpeed = 0;
        dots[i].ySpeed = 0;
    }

    public void move(int i, int j)
    {
        String newDirection = directions[600 * i + j];
        if (newDirection.equals("up"))
            dots[i].ySpeed = 1;
        else if (newDirection.equals("down"))
            dots[i].ySpeed = -1;
        else if (newDirection.equals("right"))
            dots[i].xSpeed = 1;
        else if (newDirection.equals("left"))
            dots[i].xSpeed = -1;
    }

    public double getFitness(int i)
    {
        if (dots[i].hit(goal))
            return 100 / Math.pow(step, 0.01);
        return 100 / ct.distance(goal.x, goal.y, dots[i].x, dots[i].y);
    }

    public void copyVeteranDirections(int i)
    {
        for (int j = 0; j < 600; j++)
            directions[600 * i + j] = directions[600 * veteranIndex + j];
    }

    public void mutate(int i)
    {
        for (int j = 0; j < 10; j++)
            directions[600 * i + ct.random(0, 590)] = spatialDirections[ct.random(0, 3)];
    }

}
