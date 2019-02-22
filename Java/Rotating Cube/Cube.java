
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
    }

    public void update()
    {
        for (int i = 0; i < topPoints.length; i++)
        {
            if (topPoints[i].y < 30 || topPoints[i].x == 30)
            {
                topPoints[i].x += 0.1;
                bottomPoints[i].x += 0.1;
                double f = 10 * Math.sqrt(1 - 0.0025 * Math.pow(topPoints[i].x - 50, 2));

                if (!(30 - f >= 20))
                    ct.println(topPoints[i].x);

                topPoints[i].y = 30 - f;
                bottomPoints[i].y = 70 - f;
            }
            else if (topPoints[i].y > 30 || topPoints[i].x == 70)
            {
                topPoints[i].x -= 0.1;
                bottomPoints[i].x -= 0.1;
                double f = 10 * Math.sqrt(1 - 0.0025 * Math.pow(topPoints[i].x - 50, 2));
                topPoints[i].y = 30 + f;
                bottomPoints[i].y = 70 + f;
            }

        }
    }
}
