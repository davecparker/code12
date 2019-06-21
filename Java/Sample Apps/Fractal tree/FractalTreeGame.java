
class FractalTreeGame
{
    GameObj thetaSlider, branchSlider;
    double theta, prevTheta, refTheta, branch, prevBranch, refBranch, randomTheta, randomBranch;
    boolean begin, end;

    // creates objects and environment
    public void start()
    {
        ct.setBackColor("dark gray");

        /*
         * creates thetaSlider object,
         * user interactive, a simple slider to alter the theta variable
         */
        ct.line(12.5, 5, 87.5, 5, "white");
        thetaSlider = ct.circle(87.5, 5, 2.5, "white");
        thetaSlider.setLineWidth(0);

        /*
         * creates branchSlider object,
         * user interactive, a simple slider to alter the branch variable
         */
        ct.line(12.5, 9, 87.5, 9, "white");
        branchSlider = ct.circle(12.5, 9, 2.5, "white");
        branchSlider.setLineWidth(0);

        /*
         * theta is the angle (radians) of all player's branches from the vertical,
         * for example, if the angle was PI/2 (90 degrees) the line would be horizontal
         */
        theta = 0;

        /*
         * branch is the intial branch length for the player's branches
         */
        branch = 0;

        /*
         * prevTheta and prevBranch act as duplicates for theta and branch respectively,
         * their purpose is to see if theta and/or branch have changed at all,
         * redrawing all branches is costly in computation, so to help counteract this,
         * prevent the unnecessary step of redrawing a tree that is identical to itself
         */
        prevTheta = 0;
        prevBranch = 0;

        /*
         * refTheta and refBranch are the reference tree equivalent for theta and branch,
         * the player's goal is to alter their tree's angle and branch length
         * so that it appears as the reference tree's
         */
        refTheta = Math.PI;
        refBranch = 10;

        /*
         * randomTheta and randomBranch respectively, act as random variables for
         * refTheta and refBranch, which will then transition to the random variables
         * via update cycles
         */
        randomTheta = 0;
        randomBranch = 0;

        /*
         * begin and end state whether the game is currently in transition,
         * their purpose is to prevent user input during tree redrawing in level transitions
         */
        begin = false;
        end = false;
    }

    // takes user input, move slider if slider has been dragged
    public void onMouseDrag(GameObj obj, double x, double y)
    {
        // moves slider only if there is no current transition between levels
        if ((obj == thetaSlider || obj == branchSlider) && !begin && !end)
            updateSlider(obj, x);
    }

    // redraws player's tree and executes level transitions
    public void update()
    {
        updateTree();   // player's tree is redrawn every update cycle
        if (begin)
            begin();
        else if (end)
            end();
        else if (hasPlayerWon())                                // if player has won the level
        {
            ct.clearGroup("referance branches");                // clear entire reference tree
            randomTheta = Math.PI * ct.random(5, 95) * 0.01;    // choose a random theta for new reference tree
            randomBranch = ct.random(180, 280) * 0.1;           // choose a random branch length for new reference tree
            end = true;                                         // start end level transition
        }
    }

    // a single update cycle during the begin level transition
    void begin()
    {
        ct.clearGroup("referance branches");    // clear entire referance tree
        if (refTheta > randomTheta)             // refTheta defaults to PI (maximum value) during end level transition
            refTheta -= 0.02;                   // decrement refTheta if it's greater than randomTheta
        if (refBranch < randomBranch)           // refBranch defaults to 10 (minimum value) during end level transition
            refBranch += 0.3;                   // increment refBranch if it's less than randomBranch
        if (thetaSlider.x > 25)                 // thetaSlider.x defaults to 87.5 (maximum value) during end level transition
            thetaSlider.x -= 0.5;               // decrement thetaSlider.x if it's less than 25 (25 was objectively choosen)
        if (refTheta <= randomTheta && refBranch >= randomBranch && thetaSlider.x <= 25)    // if all other conditions are completetd
            begin = false;                                                                  // stop begin level transition
        updateRefTree();                        // finally redraw tree
    }

    // a single update cycle during the end level transition
    void end()
    {
        /*
         * increment and decrement thetaSlider.x and branchSlider.x respectively
         * the reason updateSlider is used rather than just modifying the x data field as seen on line 107,
         * updateSlider just modfies the x data field but restricts it to values between 12.5 and 87.5,
         * since we want the minimum and maximum values for thetaSlider.x and branchSlider respectively,
         * updateSlider, which is used for user input, was taken advantage of for this purpose,
         * line 107 modifies the x data field only because it is within the boundaries of 12.5 and 87.5
         */
        updateSlider(thetaSlider,  thetaSlider.x  + 0.5);
        updateSlider(branchSlider, branchSlider.x - 0.5);
        if (thetaSlider.x >= 87.5 && branchSlider.x <= 12.5) // if both sliders are in place, modify reference tree values and transition states
        {
            refTheta = Math.PI;
            refBranch = 10;
            end = false;
            begin = true;
        }
    }

    // creates a single branch, then entire player tree through recursion
    void defineBranches(double x1, double y1, double phi, double branchLength, int bundles)
    {
        /*
        * (x1, y1) act as the intial point for the branch
        * (phi, branchLength) act as the polar coordinate for the branch from the orgin (x1, y1)
        * bundles acts as the levels of recursions left from the current branch that is being created
        */
        double x2 = x1 + branchLength * Math.cos(phi); // converting (phi, branchLength) to cartesian coordinates
        double y2 = y1 - branchLength * Math.sin(phi); // from point (x1, y1)
        GameObj nbranch = ct.line(x1, y1, x2, y2, "white"); // creation of single branch, (x1, y1) -> (x2, y2)
        nbranch.group = "player branches";
        if (bundles > 0) // if there is recursion levels left
        {
            bundles--;              // decrement the amount of bundles left
            branchLength /= 1.45;   // shorten the length of branches
            defineBranches(x2, y2, phi + theta, branchLength, bundles); // create right branch
            defineBranches(x2, y2, phi - theta, branchLength, bundles); // create left  branch
        }
    }

    // creates a single branch, then entire reference tree through recursion
    void defineRefBranches(double x1, double y1, double phi, double branchLength, int bundles)
    {
        /*
         * only differences between this method and defineBranches is
         * setting the branches layer to 0 so player tree is visible
         * and adding/subtracting refTheta instead of theta
         */
        double x2 = x1 + branchLength * Math.cos(phi);
        double y2 = y1 - branchLength * Math.sin(phi);
        GameObj nbranch = ct.line(x1, y1, x2, y2, "light red");
        nbranch.group = "referance branches";
        nbranch.setLayer(0);
        if (bundles > 0)
        {
            branchLength /= 1.45;
            bundles--;
            defineRefBranches(x2, y2, phi + refTheta, branchLength, bundles);
            defineRefBranches(x2, y2, phi - refTheta, branchLength, bundles);
        }
    }

    // recalculates theta and branch, deletes player tree then redraws it
    void updateTree()
    {
        theta = Math.PI / 6 * (0.08 * thetaSlider.x - 1);   // calculates theta from thetaSlider.x
        branch = (0.8 * branchSlider.x + 20) / 3;           // calculates branch from branchSlider.x
        if (theta != prevTheta || branch != prevBranch)     // if theta or branch has changed, redraw player tree
        {
            prevTheta = theta;                              // update prevTheta and prevBranch
            prevBranch = branch;
            ct.clearGroup("player branches");               // delete entire player tree
            defineBranches(50, 100, Math.PI / 2, branch, 7);// redraw player tree
        }
    }

    // redraws referance tree
    void updateRefTree()
    {
        defineRefBranches(50, 100, Math.PI / 2, refBranch, 6);
    }

    // updates slider from slider.x data field
    void updateSlider(GameObj slider, double x)
    {
        if (x < 12.5)           // if mouse is beyond minimum value, value defaults to 12.5
            slider.x = 12.5;
        else if (x > 87.5)      // if mouse is beyond maximum value, value defaults to 87.5
            slider.x = 87.5;
        else
            slider.x = x;       // otherwise, mouse is within boundary
    }

    // returns true if theta and branch are within a small range of values
    boolean hasPlayerWon()
    {
        boolean isThetaInRange  = (theta  > refTheta -  0.01) && (theta  < refTheta  + 0.01);
        boolean isBranchInRange = (branch > refBranch - 0.3)  && (branch < refBranch + 0.3);
        return isThetaInRange && isBranchInRange;
    }

}
