
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
        {
            defineVector(i);
            shades[i] = 127;
        }
    }

    public void update()
    {
        ct.clearGroup("lines");

        for (int i = 0; i < vectors.length; i++)
        {
            if (isOutsideOfBoundary(vectors[i].x, vectors[i].y, vectors[i].width))
                reDefineVector(i);
        }

        for (int i = 0; i < vectors.length; i++)
        {
            if (vectors[i] == null)
                continue;

            updateShade(i);

            for (int j = i + 1; j < vectors.length; j++)
            {
                int x1 = (int) vectors[i].x;
                int y1 = (int) vectors[i].y;
                int x2 = (int) vectors[j].x;
                int y2 = (int) vectors[j].y;
                if (ct.distance(x1, y1, x2, y2) <= 20)
                    defineLine(i, j, x1, y1, x2, y2);
            }
        }

    }

    public void defineVector(int index)
    {
        int x = ct.random(-1, (int) ct.getWidth() - 1);
        int y = ct.random(-1, (int) ct.getHeight() - 1);
        double[] speeds = getRandomSpeeds();

        vectors[index] = ct.circle(x, y, 3, "gray");

        vectors[index].setLineColor("gray");
        vectors[index].xSpeed = speeds[0];
        vectors[index].ySpeed = speeds[1];

        shades[index] = 127;
    }

    public void reDefineVector(int index)
    {
        vectors[index].delete();
        defineVector(index);
    }

    public double[] getRandomSpeeds()
    {
        double xSpeed, ySpeed;
        while (true)
        {
            xSpeed = ct.random(0, 1) == 1 ? 0.1 : 0;
            ySpeed = ct.random(0, 1) == 1 ? 0.1 : 0;

            if (xSpeed != 0 || ySpeed != 0)
                break;
        }

        double[] speeds = {xSpeed, ySpeed};
        return speeds;
    }

    public boolean isOutsideOfBoundary(double x, double y, double width)
    {
        double radius = width / 2.0;
        return (x + radius < 0) || (x - radius > ct.getWidth()) || (y + radius < 0) || (y - radius > ct.getHeight());
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

    public void defineLine(int index1, int index2, int x1, int y1, int x2, int y2)
    {
        GameObj line = ct.line(x1, y1, x2, y2);
        int minShade = Math.min(shades[index1], shades[index2]);
        line.setLineColorRGB(minShade, minShade, minShade);
        line.group = "lines";
        line.setLayer(0);
    }

}
