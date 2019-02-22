
class Cube
{
    GameObj[] topPoints = new GameObj[4];
    GameObj[] bottomPoints = new GameObj[4];

    public void start()
    {
        ct.setBackColor("dark gray");
        topPoints[0] = ct.circle(30, 30, 1, "dark blue");
        topPoints[1] = ct.circle(50, 20, 1, "dark blue");
        topPoints[2] = ct.circle(70, 30, 1, "dark blue");
        topPoints[3] = ct.circle(50, 40, 1, "dark blue");

        bottomPoints[0] = ct.circle(30, 70, 1, "dark blue");
        bottomPoints[1] = ct.circle(50, 60, 1, "dark blue");
        bottomPoints[2] = ct.circle(70, 70, 1, "dark blue");
        bottomPoints[3] = ct.circle(50, 80, 1, "dark blue");

        for (int i = 0; i < topPoints.length; i++)
        {
            topPoints[i].setFillColorRGB(0, 76, 153);
            bottomPoints[i].setFillColorRGB(0, 76, 153);
            topPoints[i].setLineWidth(0);
            bottomPoints[i].setLineWidth(0);
            topPoints[i].group = "points";
            bottomPoints[i].group = "points";
        }
    }

    public void update()
    {
        ct.clearGroup("");
        for (int i = 0; i < topPoints.length; i++)
        {
            if (topPoints[i].y < 30 || ct.roundDecimal(topPoints[i].x, 1) == 30)
            {
                topPoints[i].x += 0.05;
                bottomPoints[i].x += 0.05;
                double f = ellipse(topPoints[i].x);
                topPoints[i].y = 30 - f;
                bottomPoints[i].y = 70 - f;
            }
            else if (topPoints[i].y > 30 || ct.roundDecimal(topPoints[i].x, 1) == 70)
            {
                topPoints[i].x -= 0.05;
                bottomPoints[i].x -= 0.05;
                double f = ellipse(topPoints[i].x);
                topPoints[i].y = 30 + f;
                bottomPoints[i].y = 70 + f;
            }

        }
        createLines();
    }

    double ellipse(double x)
    {
        return 10 * Math.sqrt(1 - 0.0025 * Math.pow(ct.roundDecimal(x, 1) - 50, 2));
    }

    void createLines()
    {
        for (int i = 0; i < topPoints.length; i++)
            ct.line(topPoints[i].x, topPoints[i].y, bottomPoints[i].x, bottomPoints[i].y, "white");
        for (int i = 1; i < topPoints.length; i++)
        {
            ct.line(topPoints[i - 1].x, topPoints[i - 1].y, topPoints[i].x, topPoints[i].y, "white");
            ct.line(bottomPoints[i - 1].x, bottomPoints[i - 1].y, bottomPoints[i].x, bottomPoints[i].y, "white");
        }
        ct.line(topPoints[0].x, topPoints[0].y, topPoints[3].x, topPoints[3].y, "white");
        ct.line(bottomPoints[0].x, bottomPoints[0].y, bottomPoints[3].x, bottomPoints[3].y, "white");
    }
}
