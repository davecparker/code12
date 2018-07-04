
import Code12.*;

public class Vectors extends Code12Program
{
    int arrayLength = 20;
    GameObj[] vectors = new GameObj[arrayLength];
    int[] shades = new int[arrayLength];

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

        for (int i = 0; i < vectors.length; i++)
        {
            if (isOutsideOfBoundary(vectors[i].x, vectors[i].y, vectors[i].width))
                defineVector(i);
        }

        for (int i = 0; i < vectors.length; i++)
        {
            if (vectors[i] == null)
                continue;

            updateShade(i);

            for (int j = i + 1; j < vectors.length; j++)
            {
                double x1 = vectors[i].x;
                double y1 = vectors[i].y;
                double x2 = vectors[j].x;
                double y2 = vectors[j].y;
                if (ct.distance(x1, y1, x2, y2) <= 20)
                    defineLine(i, j, x1, y1, x2, y2);
            }
        }
    }

    public void defineVector(int index)
    {
        int x = ct.random(-1, (int) ct.getWidth() - 1);
        int y = ct.random(-1, (int) ct.getHeight() - 1);

        if (vectors[index] == null)
            vectors[index] = ct.circle(x, y, 3);
        else
        {
            vectors[index].x = x;
            vectors[index].y = y;
        }

        double[] speeds = getRandomSpeeds();
        vectors[index].xSpeed = speeds[0];
        vectors[index].ySpeed = speeds[1];

        shades[index] = 127;
    }

    public void defineLine(int index1, int index2, double x1, double y1, double x2, double y2)
    {
        GameObj line = ct.line(x1, y1, x2, y2);
        int minShade = Math.min(shades[index1], shades[index2]);
        line.setLineColorRGB(minShade, minShade, minShade);
        line.group = "lines";
        line.setLayer(0);
    }

    public void updateShade(int index)
    {
        if (shades[index] < 255)
        {
            shades[index]++;
            vectors[index].setFillColorRGB(shades[index], shades[index], shades[index]);
            vectors[index].setLineColorRGB(shades[index], shades[index], shades[index]);
        }
        else
            vectors[index].setLayer(2);
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

    public boolean isOutsideOfBoundary(double x, double y, double width)
    {
        double radius = width / 2.0;
        return (x + radius < 0) || (x - radius > ct.getWidth()) || (y + radius < 0) || (y - radius > ct.getHeight());
    }

}
