
class Vectors
{
    GameObj[] vectors = new GameObj[40];

    // creates objects and environment
    public void start()
    {
        ct.setBackColor("gray");
        for (int i = 0; i < vectors.length; i++)
            vectors[i] = defineVector();
    }

    // redefines all vectors and lines between them
    public void update()
    {
        updateVectors();
        ct.clearGroup("lines");
        defineLines();
    }

    // creates a vector with random speed
    GameObj defineVector()
    {
        GameObj v = ct.circle(ct.random(1, 99), ct.random(1, 99), 2); // random location within window
        v.id = 127; // shares color with background color, "gray" RGB: (127, 127, 127)
        v.setLineWidth(0);
        setRandomSpeeds(v);
        return v;
    }

    // redefines a vector
    void updateVector(GameObj v)
    {
        /*
         * only difference between this and defineVector(v) is these next two lines,
         * a vector does not need to be created since it already exists, instead only relocated,
         * used in updateVectors, and therefore the update method
         */
        v.x = ct.random(1, 99);
        v.y = ct.random(1, 99);
        v.id = 127;
        setRandomSpeeds(v);
    }

    // collectively redefines all vectors and their fill color
    void updateVectors()
    {
        for (int i = 0; i < vectors.length; i++)
        {
            // a vector is only redefined if the vector leaves the window
            if (isOutsideOfBoundary(vectors[i]))
                updateVector(vectors[i]);
            // a vector's fill color is updated from 127 ("gray") to 255 ("white")
            if (vectors[i].id < 255)
                updateShade(vectors[i]);
        }
    }

    // increments a vectors RGB fill color and sets the vector's fill color
    void updateShade(GameObj v)
    {
        v.id++;
        v.setLayer(v.id - 126); // vectors are set on a higher layer to display according to their shade
        v.setFillColorRGB(v.id, v.id, v.id);
    }

    // creates a line between two vectors with the lowest shade between them
    void defineLine(GameObj v1, GameObj v2)
    {
        GameObj line = ct.line(v1.x, v1.y, v2.x, v2.y); // line from (v1.x, v1.y) -> (v2.x, v2.y)
        int minShade = Math.min(v1.id, v2.id); // the minimum shade is the darkest and also closest color to that of the background
        line.setLineColorRGB(minShade, minShade, minShade);
        line.group = "lines";
        line.setLayer(0);
    }

    // defines all lines between vectors that are within a radius of 20 units
    void defineLines()
    {
        /*
         * for each vector in vectors:
         *   set current vector in visited set,
         *   determine if all unvisited vectors are within 20 units of current vector,
         *     if so, create a line between them (defineLine(v1, v2))
         *   then repeat with next vector (vectors[i + 1]) until all vectors are visited
         */
        for (int i = 0; i < vectors.length; i++)
        {
            for (int j = i + 1; j < vectors.length; j++)
            {
                if (ct.distance(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y) <= 20)
                    defineLine(vectors[i], vectors[j]);
            }
        }
    }

    // sets speed of vector to random x and y speed
    void setRandomSpeeds(GameObj v)
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
        v.setXSpeed(xSpeed);
        v.setYSpeed(ySpeed);
    }

    // returns true if vector is outside of window
    boolean isOutsideOfBoundary(GameObj v)
    {
        boolean outsideLeft   = v.x + v.getWidth() / 2 < 0;
        boolean outsideRight  = v.x - v.getWidth() / 2 > 100;
        boolean outsideTop    = v.y + v.getWidth() / 2 < 0;
        boolean outsideBottom = v.y - v.getWidth() / 2 > 100;
        return outsideLeft || outsideRight || outsideTop || outsideBottom;
    }

}
