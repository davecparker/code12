
class NaturalSelectionVisualization
{
    GameObj goal, timer, maxFitness, gen;
    GameObj[] dots;
    boolean[] killed;
    int[] directions;
    int veteran, step;
    double time;

// defining methods ///////////////////////////////////////////////////////////

    // creates objects and environment
    public void start()
    {
        ct.setBackColor("gray");

        /*
         * creates goal object,
         * each dot's objective is to reach the goal
         */
        goal = ct.circle(50, 2, 1, "white");

        /*
         * creates timer object,
         * the population is given ten seconds per generation,
         * when time runs out, dots reset
         */
        timer = ct.text("10.0", 7, 5, 5, "white");
        timer.setLayer(3);

        /*
         * creates maxFitness object,
         * displays the population's current highest fitness
         */
        maxFitness = ct.text("0.00", 90, 5, 5, "white");
        maxFitness.setLayer(3);

        /*
         * creates gen object,
         * displays current generation of population
         */
        gen = ct.text("Gen 1", 10, 95, 5, "white");
        gen.setLayer(3);

        /*
         * killed is a parallel array with dots (dots[50]),
         * the corresponding index in dots represents whether the dot is dead,
         * for example, dots[2] is dead if killed[2] == true
         */
        killed = new boolean[50];

        /*
         * directions is a parallel array with dots (dots[50]),
         * (60 * 10) directions for each dot (60 directions per second for 10 seconds)
         * integers 0-3 represent directions: 0 = up, 1 = down, 2 = left, 3 = right
         */
        directions = new int[60 * 10 * 50];

        time = ct.getTimer(); // used to calculate timer
        veteran = 0;          // index of 'veteran' (highest fitness) dot
        step = 0;             // index of current direction,
                              // dots have 600 directions (60 per second for each update cycle)

        // intial prep
        defineDots();
        defineObstacles();
        defineDirections();
    }

    // creates population (fifty dots) at point (50, 98)
    void defineDots()
    {
        dots = new GameObj[50];
        for (int i = 0; i < dots.length; i++)
            dots[i] = ct.circle(50, 98, 1, "light blue");
    }

    // creates a veteran (id. by light green color) at the predefined veteran index
    void defineVeteran()
    {
        dots[veteran].setFillColor("light green");
        dots[veteran].setLayer(2);
    }

    // creates random directions for all dots
    void defineDirections()
    {
        for (int i = 0; i < directions.length; i++)
            directions[i] = ct.random(0, 3);
    }

    // creates ten obstacles with random locations and dimensions
    void defineObstacles()
    {
        for (int i = 0; i < 10; i++)
        {
            int x = ct.random(0, 100);
            int y = ct.random(20, 80);
            int width = ct.random(1, 8);
            int height = ct.random(1, 15);
            GameObj obstacle = ct.rect(x, y, width, height, "dark gray");
            obstacle.setLayer(-1);
            obstacle.group = "obstacles";
        }
    }

// program methods ////////////////////////////////////////////////////////////

    // move the goal or any obstacle to any location on screen
    public void onMouseDrag(GameObj obj, double x, double y)
    {
        if (obj != null)
        {
            String group = obj.group;
            if (obj == goal || group.equals("obstacles"))
            {
                obj.x = x;
                obj.y = y;
            }
        }
    }

    // move a given dot (dot[i]) according to it's next direction (directions[600 * i + step])
    void move(int i)
    {
        /*
         * sudo two-dimensional array trick
         * 2D_array[i][j]  <=>  1D_array[columns * i + j]
         */
        int direction = directions[600 * i + step];
        dots[i].setXSpeed(0);
        dots[i].setYSpeed(0);
        if (direction == 0)      // up
            dots[i].setYSpeed(0.5);
        else if (direction == 1) // down
            dots[i].setYSpeed(-0.5);
        else if (direction == 2) // left
            dots[i].setXSpeed(0.5);
        else if (direction == 3) // right
            dots[i].setXSpeed(-0.5);
    }

    // alters fifty random directions of a given dot (dots[i]) to random directions
    void mutate(int i)
    {
        for (int j = 0; j < 50; j++)
            directions[600 * i + ct.random(0, 590)] = ct.random(0, 3);
    }

// update methods /////////////////////////////////////////////////////////////

    // updates timer, all conditional updates for dots, and if the next gen can start
    public void update()
    {
        updateTimer();
        for (int i = 0; i < dots.length; i++)
        {
            killEvents(i);
            updateVeteran();
            updateMaxFitness();
            if (!killed[i])
                move(i);
        }
        step++;
        if (areAllDotsDead())
            nextGenPrep();
    }

    // updates timer's display
    void updateTimer()
    {
        double timeDiff = (time - ct.getTimer()) / 1000 + 10; // calculates how many seconds are left on timer
        if (timeDiff > 0)
            timer.setText(ct.formatDecimal(timeDiff, 1));
        else
            timer.setText("0.0");
    }

    // updates and displays the max fitness of the population
    void updateMaxFitness()
    {
        if (getFitness(veteran) > ct.parseNumber(maxFitness.getText()))
            maxFitness.setText(ct.formatDecimal(getFitness(veteran), 2));
    }

    // updates the veteran index by finding the dot with highest fitness
    void updateVeteran()
    {
        for (int i = 0; i < dots.length; i++)
        {
            if (getFitness(i) > getFitness(veteran))
                veteran = i;
        }
    }

    // updates and displays current generation
    void updateGen()
    {
        String genGetText = gen.getText();
        String genSubText = genGetText.substring(genGetText.indexOf(" "));
        gen.setText("Gen " + (ct.parseInt(genSubText) + 1));
    }

    // prep for next generation
    void nextGenPrep()
    {
        /*
         * for each dot in population:
         *   reset all dots,
         *   make last generation's veteran's direction's their own,
         *   slighltly change these new directions if they are not the current veteran
         */
        for (int i = 0; i < dots.length; i++)
        {
            killed[i] = false;
            dots[i].x = 50;
            dots[i].y = 98;
            dots[i].setLayer(1);
            dots[i].setFillColor("light blue");
            copyVeteranDirections(i);
            if (i != veteran)
                mutate(i);
        }
        defineVeteran();
        updateGen();
        time = ct.getTimer();
        step = 0;
    }

// kill methods ///////////////////////////////////////////////////////////////

    /*
     * kills dots upon specified events:
     *   reached goal,
     *   hit an obstacle,
     *   outside boundaries
     *   ran out of time
     */
    void killEvents(int i)
    {
        killWithinGoal(i);
        killWithinObstacles(i);
        killOutsideBoundary(i);
        killOutOfTime(i);
    }

    // kills a given dot (dots[i]) if hit goal object
    void killWithinGoal(int i)
    {
        if (dots[i].hit(goal))
            kill(i);
    }

    // kills a given dot (dots[i]) if hit an obstacle object
    void killWithinObstacles(int i)
    {
        if (dots[i].objectHitInGroup("obstacles") != null)
            kill(i);
    }

    // kills a given dot (dots[i]) if hit outer window boundaries
    void killOutsideBoundary(int i)
    {
        if (dots[i].x <= 0 || dots[i].x >= 100 || dots[i].y <= 0 || dots[i].y >= 100)
            kill(i);
    }

    // kills a given dot (dots[i]) if timer has count down to zero from ten seconds
    void killOutOfTime(int i)
    {
        String currentTime = timer.getText();
        if (currentTime.equals("0.0") || step >= 600)
            kill(i);
    }

    // kills a given dot (dots[i])
    void kill(int i)
    {
        killed[i] = true;
        dots[i].setXSpeed(0);
        dots[i].setYSpeed(0);
    }

// helper methods /////////////////////////////////////////////////////////////

    // calculates and returns fitness of a given dot (dots[i])
    double getFitness(int i)
    {
        /*
         * fitness: distance from or steps taken to reach goal object,
         *   a shorter distance or less steps taken to reach the goal object results in higher fitness,
         *   a dot with the highest fitness is chosen to be veteran each generation
         */
        if (dots[i].hit(goal))
            return 100 / Math.pow(step, 0.01);
        return 100 / ct.distance(goal.x, goal.y, dots[i].x, dots[i].y);
    }

    // copies all directions from verteran dot into another (dots[i])
    void copyVeteranDirections(int i)
    {
        for (int j = 0; j < 600; j++)
            directions[600 * i + j] = directions[600 * veteran + j];
    }

    // returns true if all items in killed are true
    boolean areAllDotsDead()
    {
        for (int i = 0; i < dots.length; i++)
        {
            if (!killed[i])
                return false;
        }
        return true;
    }

}
