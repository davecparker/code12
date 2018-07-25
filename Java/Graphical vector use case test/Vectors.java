
import Code12.*;

public class Vectors extends Code12Program
{
    GameObj[] vectors = new GameObj[50];
    int[] shades = new int[50];

    public static void main(String[] args)
    {
        Code12.run(new Vectors());
    }

    public void start()
    {
        ct.setBackColor("gray");
        for (int i = 0; i < vectors.length; i++)
            defineVector(i);
    }

    public void update()
    {
        ct.clearGroup("lines");
        defineVectors();
        defineLines();
    }

    public void defineVectors()
    {
        for (int i = 0; i < vectors.length; i++)
        {
            if (isOutsideOfBoundary(vectors[i]))
                defineVector(i);
        }
    }

    public void defineVector(int i)
    {
        int x = ct.random(-1, ct.toInt(ct.getWidth()) - 1);
        int y = ct.random(-1, ct.toInt(ct.getHeight()) - 1);
        if (vectors[i] == null)
            vectors[i] = ct.circle(x, y, 2);
        else
        {
            vectors[i].x = x;
            vectors[i].y = y;
        }
        double[] speeds = getRandomSpeeds();
        vectors[i].xSpeed = speeds[0];
        vectors[i].ySpeed = speeds[1];
        shades[i] = 127;
    }

    public void defineLines()
    {
        for (int i = 0; i < vectors.length; i++)
        {
            if (vectors[i] != null)
            {
                updateShade(i);
                for (int j = i + 1; j < vectors.length; j++)
                {
                    if (ct.distance(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y) <= 20)
                        defineLine(i, j);
                }
            }
        }
    }

    public void defineLine(int i, int j)
    {
        GameObj line = ct.line(vectors[i].x, vectors[i].y, vectors[j].x, vectors[j].y);
        int minShade = ct.toInt(Math.min(shades[i], shades[j]));
        line.setLineColorRGB(minShade, minShade, minShade);
        line.group = "lines";
        line.setLayer(0);
    }

    public void updateShade(int i)
    {
        if (shades[i] < 255)
        {
            shades[i]++;
            vectors[i].setFillColorRGB(shades[i], shades[i], shades[i]);
            vectors[i].setLineColorRGB(shades[i], shades[i], shades[i]);
        }
        else
            vectors[i].setLayer(2);
    }

    public double[] getRandomSpeeds()
    {
        double[] speeds = {-0.1, 0, 0.1};
        double xSpeed, ySpeed;
        while (true)
        {
            xSpeed = speeds[ct.random(0, 2)];
            ySpeed = speeds[ct.random(0, 2)];
            if (xSpeed != 0 || ySpeed != 0)
                break;
        }
        double[] xySpeeds = {xSpeed, ySpeed};
        return xySpeeds;
    }

    public boolean isOutsideOfBoundary(GameObj object)
    {
        double x = object.x;
        double y = object.y;
        double radius = object.width / 2.0;
        return (x + radius < 0) || (x - radius > ct.getWidth()) || (y + radius < 0) || (y - radius > ct.getHeight());
    }

}
