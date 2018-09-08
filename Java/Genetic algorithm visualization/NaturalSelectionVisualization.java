
import Code12.*;

public class NaturalSelectionVisualization extends Code12Program
{
    GameObj goal, timer, maxFitness, gen;
    GameObj[] dots;
    String[] spatialDirections = {"up", "down", "left", "right"};
    String[] directions = new String[(60 * 10) * 50];
    boolean[] killed = new boolean[50];
    int veteranIndex, step;
    double time;

    public static void main(String[] args)
    {
        Code12.run(new NaturalSelectionVisualization());
    }

    public void start()
    {
        ct.setBackColor("gray");
        goal = ct.circle(50, 2, 1, "white");
        timer = ct.text("10.0", 5, 5, 5, "white");
        maxFitness = ct.text("0.00", 90, 5, 5, "white");
        gen = ct.text("Gen 1", 10, 95, 5, "white");
        timer.setLayer(3);
        maxFitness.setLayer(3);
        gen.setLayer(3);
        time = ct.getTimer();
        veteranIndex = 0;
        step = 0;

        defineObstacles();
        defineDots();
        defineDirections();
    }

    public void defineObstacles()
    {
        for (int i = 0; i < 10; i++)
        {
            GameObj obstacle = ct.rect(ct.random(0, 100), ct.random(20, 80), ct.random(1, 8), ct.random(1, 15), "dark gray");
            obstacle.group = "obstacles";
        }
    }

    public void defineDots()
    {
        dots = new GameObj[50];
        for (int i = 0; i < dots.length; i++)
            defineDot(i);
    }

    public void defineDot(int i)
    {
        dots[i] = ct.circle(50, 98, 1, "light blue");
        dots[i].align("center", true);
    }

    public void defineVeteran()
    {
        dots[veteranIndex].setFillColor("light green");
        dots[veteranIndex].setLayer(2);
    }

    public void defineDirections()
    {
        for (int i = 0; i < directions.length; i++)
            directions[i] = spatialDirections[ct.random(0, 3)];
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
        if (dots[i].x <= 0 || dots[i].x >= 100 || dots[i].y <= 0 || dots[i].y >= 100)
            kill(i);
    }

    public void killWithinGoal(int i)
    {
        if (dots[i].hit(goal))
            kill(i);
    }

    public void killWithinObstacles(int i)
    {
        if (dots[i].objectHitInGroup("obstacles") != null)
            kill(i);
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
            dots[i].ySpeed = 0.5;
        else if (newDirection.equals("down"))
            dots[i].ySpeed = -0.5;
        else if (newDirection.equals("right"))
            dots[i].xSpeed = 0.5;
        else if (newDirection.equals("left"))
            dots[i].xSpeed = -0.5;
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
