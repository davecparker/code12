
class VectorField
{
    GameObj[] objs = new GameObj[50];
    double[] magnitudes = new double[100 * 100];
    double[] angles = new double[100 * 100];
    double timer;

    public void start()
    {
        ct.setBackColor("dark gray");
        defineVectors();
        for (int i = 0; i < objs.length; i++)
        {
            int x = ct.random(1, 99);
            int y = ct.random(1, 99);
            objs[i] = ct.circle(x, y, 1, "white");
            objs[i].setLineWidth(0);
        }
        timer = ct.getTimer();
    }

    public void update()
    {
        if (ct.getTimer() - timer > 50)
        {
            int time = 100 * (int) Math.floor(ct.getTimer() / 100.0);
            for (int k = 0; k < objs.length; k++)
            {
                double x = objs[k].x;
                double y = objs[k].y;
                defineTrace(x, y, time);
            }
            ct.clearGroup(ct.formatInt(time - 5000));
            timer = ct.getTimer();
        }

        for (int k = 0; k < objs.length; k++)
        {
            if (objs[k].x < 1)
                objs[k].x = 99;
            else if (objs[k].x > 99)
                objs[k].x = 1;
            if (objs[k].y < 1)
                objs[k].y = 99;
            else if (objs[k].y > 99)
                objs[k].y = 1;

            int j = ct.round(objs[k].x);
            int i = ct.round(objs[k].y);
            double mag = magnitudes[100 * i + j];
            double ang = angles[100 * i + j];
            double xSpeed = mag * Math.cos(ang);
            double ySpeed = mag * Math.sin(ang);
            objs[k].setXSpeed(objs[k].getXSpeed() + xSpeed);
            objs[k].setYSpeed(objs[k].getYSpeed() + ySpeed);
        }
    }

    void defineVectors()
    {
        magnitudes[0] = 0.0001 * ct.random(1, 99);
        angles[0] = Math.PI * ct.random(0, 359) / 180;
        for (int i = 0; i < 100; i++)
        {
            for (int j = 0; j < 100; j++)
                defineVector(100 * i + j);
        }
    }

    void defineVector(int i)
    {
        int count = 0;
        double magSum = 0;
        double angSum = 0;
        int[] indexes = {i - 101, i - 100, i - 99, i - 1};
        for (int index: indexes)
        {
            if (index >= 0 && index < 10000 && magnitudes[index] != 0)
            {
                count++;
                magSum += magnitudes[index];
                angSum += angles[index];
            }
        }
        if (i > 0 && i < 10000)
        {
            magnitudes[i] = magSum / count + 0.0001 * ct.random(-5, 5);
            angles[i] = angSum / count + Math.PI * ct.random(-40, 40) / 180;
        }
    }

    void defineTrace(double x, double y, int time)
    {
        GameObj trace = ct.circle(x, y, 0.1);
        int count = 0;
        // for (double i = x - 3; i < x + 3; i++)
        // {
        //     for (double j = y - 3; j < y + 3; j++)
        //     {
        //         trace.x = i;
        //         trace.y = j;
        //         for (int k = 0; k < 10; k++)
        //         {
        //             String group = ct.formatDecimal(timer - 1000 * k);
        //             if (trace.objectHitInGroup(group) != null)
        //                 count++;
        //         }
        //     }
        // }
        trace.x = x;
        trace.y = y;
        trace.setSize(0.5, 0.5);
        trace.setFillColorRGB(100 + 20 * count, 100 + 20 * count, 100 + 20 * count);
        trace.setLineWidth(0);
        trace.setLayer(0);
        trace.group = ct.formatInt(time);
    }
}
