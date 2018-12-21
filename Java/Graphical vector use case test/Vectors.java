
class Vectors
{
    GameObj[] vectors = new GameObj[40];
    int[] shades = new int[40];

    // creates objects and environment
    public void start()
    {
        ct.setBackColor("gray");
        for (int i = 0; i < vectors.length; i++)
            defineVector(i);
    }

    // redefines all vectors and lines between them
    public void update()
    {
        updateVectors();
        ct.clearGroup("lines");
        defineLines();
    }

    // creates a vector (vectors[i]) with random speed
    void defineVector(int i)
    {
        vectors[i] = ct.circle(ct.random(1, 99), ct.random(1, 99), 2); // random location within window
        vectors[i].setLineWidth(0);
        setRandomSpeeds(i);
        shades[i] = 127; // shares color with background color, "gray" RGB: (127, 127, 127)
    }

    // redefines a vector (vectors[i])
    void updateVector(int i)
    {
        /*
         * only difference between this and defineVector(i) is these next two lines,
         * a vector does not need to be created since it already exists, instead only relocated,
         * used in updateVectors, and therefore the update method
         */
        vectors[i].x = ct.random(1, 99);
        vectors[i].y = ct.random(1, 99);
        setRandomSpeeds(i);
        shades[i] = 127;
    }

    // collectively redefines all vectors and their fill color (shades[i])
    void updateVectors()
    {
        for (int i = 0; i < vectors.length; i++)
        {
            // a vector (vectors[i]) is only redefined if the vector leaves the window
            if (isOutsideOfBoundary(vectors[i]))
                updateVector(i);
            // a vector's fill color (shades[i]) is updated from 127 ("gray") to 255 ("white")
            if (shades[i] < 255)
                updateShade(i);
        }
    }

    // increments a vectors RGB fill color (shades[i]) and sets the vector's (vectors[i]) fill color
    void updateShade(int i)
    {
        shades[i]++;
        vectors[i].setLayer(shades[i] - 126); // vectors (vectors[i]) are set on a higher layer to display according to their shade
        vectors[i].setFillColorRGB(shades[i], shades[i], shades[i]);
    }

    // creates a line between two vectors (vectors[i] and vectors[j]) with the lowest shade between them
    void defineLine(int i, int j)
    {
        GameObj line = ct.line(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y); // line from (x[i], y[i]) -> (x[j], y[j])
        int minShade = (int) Math.min(shades[i], shades[j]); // the minimum shade is the darkest and also closest color to that of the background
        line.setLineColorRGB(minShade, minShade, minShade);
        line.group = "lines";
        line.setLayer(0);
    }

    // defines all lines between vectors (vectors[i] and vectors[j]) that are within a radius of 20 units
    void defineLines()
    {
        /*
         * for each vector in vectors:
         *   set current vector (vectors[i]) in visited set,
         *   determine if all unvisited vectors (vectors[j]) are within 20 units of current vector (vectors[i]),
         *     if so, create a line between them (defineLine(i, j))
         *   then repeat with next vector (vectors[i + 1]) until all vectors are visited
         */
        for (int i = 0; i < vectors.length; i++)
        {
            for (int j = i + 1; j < vectors.length; j++)
            {
                if (ct.distance(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y) <= 20)
                    defineLine(i, j);
            }
        }
    }

    // sets speed of vector (vectors[i]) to random x and y speed
    void setRandomSpeeds(int i)
    {
        double[] speeds = {-0.05, 0, 0.05}; // all possible x and y speeds
        double xSpeed, ySpeed;
        /*
         * while loop will continously loop until vector will move in at least one direction,
         * in other words, the vector will never have xSpeed and ySpeed: (0, 0)
         */
        while (true)
        {
            xSpeed = speeds[ct.random(0, 2)];
            ySpeed = speeds[ct.random(0, 2)];
            if (xSpeed != 0 || ySpeed != 0)
                break;
        }
        vectors[i].setXSpeed(xSpeed);
        vectors[i].setYSpeed(ySpeed);
    }

    // returns true if vector is outside of window
    boolean isOutsideOfBoundary(GameObj vector)
    {
        double x = vector.x;
        double y = vector.y;
        double radius = vector.getWidth() / 2.0;
        return (x + radius < 0) || (x - radius > 100) || (y + radius < 0) || (y - radius > 100);
    }

}
