
class BouncingBalls
{
    GameObj[] balls;    // all ball objects
    boolean[] dirs;     // indicating the direction of ball's acceleration of the same index (true = downwards, false = upwards)
    double g = 0.01;    // gravitational constant

    public void start()
    {
        ct.setBackColor("dark gray");
        int len = ct.inputInt("Enter the amount of balls");     // enter how many balls will be on screen
        balls = new GameObj[len];                               // possible vulnerabilities:
        dirs = new boolean[len];                                // values under 0 will result in an invalid array length,
        for (int i = 0; i < balls.length; i++)                  // and over 1000 will create extreme slowness
        {   // create balls for every item in the array with random RGB codes
            double coord = (100.0 / len) * i + (50.0 / len);
            int rand1 = ct.random(0, 255);
            int rand2 = ct.random(0, 255);
            int rand3 = ct.random(0, 255);
            balls[i] = ct.circle(coord, coord, 2);
            balls[i].setFillColorRGB(rand1, rand2, rand3);
            balls[i].setLineWidth(0);
            dirs[i] = true;
        }
    }

    public void update()
    {
        for (int i = 0; i < balls.length; i++)
        {
            // continously update the direction of acceleration for each ball
            // gravity is focused around the line, y = 50
            if (balls[i].y < 50)
                dirs[i] = true;
            else if (balls[i].y > 50)
                dirs[i] = false;

            // continously increment (linear) the YSpeed of each ball
            // another way this can be done is by quadratically changing the y of each ball
            double ySpeed = balls[i].getYSpeed();
            if (dirs[i])
                balls[i].setYSpeed(ySpeed + g);
            else
                balls[i].setYSpeed(ySpeed - g);
        }
    }
}
